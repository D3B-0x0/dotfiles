-- DMS user keybind overrides (edit via Control Center or dms; do not remove this header)

hl.unbind("SUPER + SHIFT + A")
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd("sh -c \"herdr server stop\""))
