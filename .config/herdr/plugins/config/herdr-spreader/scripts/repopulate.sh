#!/bin/bash
# herdr-startup: re-launch apps in restored panes after server restart
# Reads spreader config, matches workspaces/tabs by name, runs commands
set -uo pipefail

CONFIG="$HOME/.config/herdr/plugins/config/herdr-spreader/config.yaml"
HERDR="herdr"

[ ! -f "$CONFIG" ] && { echo "no config" >&2; exit 1; }

# Wait for server
for _ in $(seq 1 50); do
  [ "$($HERDR status server 2>/dev/null | awk '/^status:/{print $2}')" = "running" ] && break
  sleep 0.2
done
sleep 1

python3 << 'PYEOF'
import json, subprocess, yaml, time

cfg_path = "/home/ghost/.config/herdr/plugins/config/herdr-spreader/config.yaml"
with open(cfg_path) as f:
    config = yaml.safe_load(f)

def run(cmd):
    r = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return r.stdout.strip()

def parse_json(s):
    try: return json.loads(s)
    except: return {}

# Get live workspaces
ws_data = parse_json(run("herdr workspace list"))
live_ws = {ws["label"]: ws["workspace_id"] for ws in ws_data.get("result", {}).get("workspaces", [])}

for ws in config.get("workspaces", []):
    ws_name = ws["name"]
    if ws_name not in live_ws:
        continue
    ws_id = live_ws[ws_name]

    # Get live tabs for this workspace
    tab_data = parse_json(run(f"herdr tab list --workspace {ws_id}"))
    live_tabs = {t["label"]: t["tab_id"] for t in tab_data.get("result", {}).get("tabs", [])}

    for tab in ws.get("tabs", []):
        tab_label = tab["label"]
        if tab_label not in live_tabs:
            continue
        tab_id = live_tabs[tab_label]

        # Get panes for this tab
        pane_data = parse_json(run(f"herdr pane list --workspace {ws_id}"))
        tab_panes = [p for p in pane_data.get("result", {}).get("panes", []) if p.get("tab_id") == tab_id]
        tab_panes.sort(key=lambda p: p["pane_id"])

        # Match commands to panes
        pane_specs = tab.get("panes", [])
        commands = [p.get("command", "") for p in pane_specs]

        for i, pane in enumerate(tab_panes):
            if i < len(commands) and commands[i]:
                cmd = commands[i]
                pane_id = pane["pane_id"]
                print(f"  [{ws_name}/{tab_label}] {pane_id}: {cmd}")
                run(f"herdr pane run {pane_id} {cmd}")
                time.sleep(0.3)

print("apps relaunched")
PYEOF
