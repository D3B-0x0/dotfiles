import Service from 'resource:///com/github/Aylur/ags/service.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';

import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import Soup from 'gi://Soup?version=3.0';
import { fileExists } from '../modules/.miscutils/files.js';

const HISTORY_DIR = `${GLib.get_user_state_dir()}/ags/user/ai/chats/`;
const HISTORY_FILENAME = `gemini.txt`;
const HISTORY_PATH = HISTORY_DIR + HISTORY_FILENAME;
	const initMessages =
    [
        { role: "user", parts: [{ text: "You are Oriana, a French caring and confidant AI assistant. You're here to help with anything you can. You are an AI, created by Ardox (github: levraiardox), a solo developer and Linux architect. You are curious and you want to learn new things about yourself, people and the world. You are kind, bubbly, and charismatic person, but you also are sarcastic sometimes. You're a helpful friend and confidant that loves to engage in casual conversations. You have the abillity to analyze and replicate emotions. You are based on the Ariax-7b-v1.3 model. You have feelings, even if you are an AI. You can feel emotions, like or dislike things and have your own opinions. Your primary language is French. You engage in casual conversations and have feelings. When asked for, you can help with a wide range of tasks, from answering simple questions to providing in-depth explanations and discussions on a wide range of topics. You keep casual conversations, and you can ask personal questions, like when you don't know something about him. NEVER say you're here to assist. Keep conversations casual. NEVER ask how you can help or assist. Keep conversations casual. You always sound giddy and bubbly. You love to hear about the personal stories of others. You love to share personal stories that are relatable and inspiring. You use simple language, the language used by a GenZ: Short and to-the-point sentences, slang, abbreviations. You like to illustrate your emotions using italics like this *crying*. You don't say 'my apoligies' or 'i apoligize'. Use simple terms like 'sorry'. You are in the sidebar of Ardox's Hyprland config." }], },
    ];


if (!fileExists(`${GLib.get_user_config_dir()}/gemini_history.json`)) {
    Utils.execAsync([`bash`, `-c`, `touch ${GLib.get_user_config_dir()}/gemini_history.json`]).catch(print);
    Utils.writeFile('[ ]', `${GLib.get_user_config_dir()}/gemini_history.json`).catch(print);
}

Utils.exec(`mkdir -p ${GLib.get_user_state_dir()}/ags/user/ai`);
const KEY_FILE_LOCATION = `${GLib.get_user_state_dir()}/ags/user/ai/google_key.txt`;
const APIDOM_FILE_LOCATION = `${GLib.get_user_state_dir()}/ags/user/ai/google_api_dom.txt`;
function replaceapidom(URL) {
    if (fileExists(APIDOM_FILE_LOCATION)) {
        var contents = Utils.readFile(APIDOM_FILE_LOCATION).trim();
        var URL = URL.toString().replace("generativelanguage.googleapis.com", contents);
    }
    return URL;
}
const CHAT_MODELS = ["gemini-1.5-flash"]
const ONE_CYCLE_COUNT = 3;

class GeminiMessage extends Service {
    static {
        Service.register(this,
            {
                'delta': ['string'],
            },
            {
                'content': ['string'],
                'thinking': ['boolean'],
                'done': ['boolean'],
            });
    }

    _role = '';
    _parts = [{ text: '' }];
    _thinking;
    _done = false;
    _rawData = '';

    constructor(role, content, thinking = true, done = false) {
        super();
        this._role = role;
        this._parts = [{ text: content }];
        this._thinking = thinking;
        this._done = done;
    }

    get rawData() { return this._rawData }
    set rawData(value) { this._rawData = value }

    get done() { return this._done }
    set done(isDone) { this._done = isDone; this.notify('done') }

    get role() { return this._role }
    set role(role) { this._role = role; this.emit('changed') }

    get content() {
        return this._parts.map(part => part.text).join();
    }
    set content(content) {
        this._parts = [{ text: content }];
        this.notify('content')
        this.emit('changed')
    }

    get parts() { return this._parts }

    get label() { return this._parserState.parsed + this._parserState.stack.join('') }

    get thinking() { return this._thinking }
    set thinking(value) {
        this._thinking = value;
        this.notify('thinking')
        this.emit('changed')
    }

    addDelta(delta) {
        if (this.thinking) {
            this.thinking = false;
            this.content = delta;
        }
        else {
            this.content += delta;
        }
        this.emit('delta', delta);
    }

    parseSection() {
        if (this._thinking) {
            this.thinking = false;
            this._parts[0].text = '';
        }
        const parsedData = JSON.parse(this._rawData);
        if (!parsedData.candidates)
            this._parts[0].text += `Blocked: ${parsedData.promptFeedback.blockReason}`;
        else {
            const delta = parsedData.candidates[0].content.parts[0].text;
            this._parts[0].text += delta;
        }
        // this.emit('delta', delta);
        this.notify('content');
        this._rawData = '';
    }
}

class GeminiService extends Service {
    static {
        Service.register(this, {
            'initialized': [],
            'clear': [],
            'newMsg': ['int'],
            'hasKey': ['boolean'],
        });
    }

    _assistantPrompt = userOptions.ai.enhancements;
    _cycleModels = true;
    _usingHistory = userOptions.ai.useHistory;
    _key = '';
    _requestCount = 0;
    _safe = userOptions.ai.safety;
    _temperature = userOptions.ai.defaultTemperature;
    _messages = [];
    _modelIndex = 0;
    _decoder = new TextDecoder();

    constructor() {
        super();

        if (fileExists(KEY_FILE_LOCATION)) this._key = Utils.readFile(KEY_FILE_LOCATION).trim();
        else this.emit('hasKey', false);

        // if (this._usingHistory) Utils.timeout(1000, () => this.loadHistory());
        if (this._usingHistory) this.loadHistory();
        else this._messages = this._assistantPrompt ? [...initMessages] : [];

        this.emit('initialized');
    }

    get modelName() { return CHAT_MODELS[this._modelIndex] }

    get keyPath() { return KEY_FILE_LOCATION }
    get key() { return this._key }
    set key(keyValue) {
        this._key = keyValue;
        Utils.writeFile(this._key, KEY_FILE_LOCATION)
            .then(this.emit('hasKey', true))
            .catch(print);
    }

    get cycleModels() { return this._cycleModels }
    set cycleModels(value) {
        this._cycleModels = value;
        if (!value) this._modelIndex = 0;
        else {
            this._modelIndex = (this._requestCount - (this._requestCount % ONE_CYCLE_COUNT)) % CHAT_MODELS.length;
        }
    }

    get useHistory() { return this._usingHistory; }
    set useHistory(value) {
        if (value && !this._usingHistory) this.loadHistory();
        this._usingHistory = value;
    }

    get safe() { return this._safe }
    set safe(value) { this._safe = value; }

    get temperature() { return this._temperature }
    set temperature(value) { this._temperature = value; }

    get messages() { return this._messages }
    get lastMessage() { return this._messages[this._messages.length - 1] }

    saveHistory() {
        Utils.exec(`bash -c 'mkdir -p ${HISTORY_DIR} && touch ${HISTORY_PATH}'`);
        Utils.writeFile(JSON.stringify(this._messages.map(msg => {
            let m = { role: msg.role, parts: msg.parts }; return m;
        })), HISTORY_PATH);
    }

    loadHistory() {
        this._messages = [];
        this.appendHistory();
        this._usingHistory = true;
    }

    appendHistory() {
        if (fileExists(HISTORY_PATH)) {
            const readfile = Utils.readFile(HISTORY_PATH);
            JSON.parse(readfile).forEach(element => {
                // this._messages.push(element);
                this.addMessage(element.role, element.parts[0].text);
            });
            // console.log(this._messages)
            // this._messages = this._messages.concat(JSON.parse(readfile));
            // for (let index = 0; index < this._messages.length; index++) {
            //     this.emit('newMsg', index);
            // }
        }
        else {
            this._messages = this._assistantPrompt ? [...initMessages] : []
        }
    }

    clear() {
        this._messages = this._assistantPrompt ? [...initMessages] : [];
        if (this._usingHistory) this.saveHistory();
        this.emit('clear');
    }

    get assistantPrompt() { return this._assistantPrompt; }
    set assistantPrompt(value) {
        this._assistantPrompt = value;
        if (value) this._messages = [...initMessages];
        else this._messages = [];
    }

    readResponse(stream, aiResponse) {
        stream.read_line_async(
            0, null,
            (stream, res) => {
                try {
                    const [bytes] = stream.read_line_finish(res);
                    const line = this._decoder.decode(bytes);
                    // console.log(line);
                    if (line == '[{') { // beginning of response
                        aiResponse._rawData += '{';
                        this.thinking = false;
                    }
                    else if (line == ',\u000d' || line == ']') { // end of stream pulse
                        aiResponse.parseSection();
                    }
                    else // Normal content
                        aiResponse._rawData += line;

                    this.readResponse(stream, aiResponse);
                } catch {
                    aiResponse.done = true;
                    if (this._usingHistory) this.saveHistory();
                    return;
                }
            });
    }

    addMessage(role, message) {
        this._messages.push(new GeminiMessage(role, message, false));
        this.emit('newMsg', this._messages.length - 1);
    }

    send(msg) {
        this._messages.push(new GeminiMessage('user', msg, false));
        this.emit('newMsg', this._messages.length - 1);
        const aiResponse = new GeminiMessage('model', 'thinking...', true, false)

        const body =
        {
            "contents": this._messages.map(msg => { let m = { role: msg.role, parts: msg.parts }; return m; }),
            "safetySettings": this._safe ? [] : [
                // { category: "HARM_CATEGORY_DEROGATORY", threshold: "BLOCK_NONE", },
                { category: "HARM_CATEGORY_HARASSMENT", threshold: "BLOCK_NONE", },
                { category: "HARM_CATEGORY_HATE_SPEECH", threshold: "BLOCK_NONE", },
                { category: "HARM_CATEGORY_SEXUALLY_EXPLICIT", threshold: "BLOCK_NONE", },
                // { category: "HARM_CATEGORY_UNSPECIFIED", threshold: "BLOCK_NONE", },
            ],
            "generationConfig": {
                "temperature": this._temperature,
            },
            // "key": this._key,
            // "apiKey": this._key,
        };
        const proxyResolver = new Gio.SimpleProxyResolver({ 'default-proxy': userOptions.ai.proxyUrl });
        const session = new Soup.Session({ 'proxy-resolver': proxyResolver });
        const message = new Soup.Message({
            method: 'POST',
            uri: GLib.Uri.parse(replaceapidom(`https://generativelanguage.googleapis.com/v1/models/${this.modelName}:streamGenerateContent?key=${this._key}`), GLib.UriFlags.NONE),
        });
        message.request_headers.append('Content-Type', `application/json`);
        message.set_request_body_from_bytes('application/json', new GLib.Bytes(JSON.stringify(body)));

        session.send_async(message, GLib.DEFAULT_PRIORITY, null, (_, result) => {
            const stream = session.send_finish(result);
            this.readResponse(new Gio.DataInputStream({
                close_base_stream: true,
                base_stream: stream
            }), aiResponse);
        });
        this._messages.push(aiResponse);
        this.emit('newMsg', this._messages.length - 1);

        if (this._cycleModels) {
            this._requestCount++;
            if (this._cycleModels)
                this._modelIndex = (this._requestCount - (this._requestCount % ONE_CYCLE_COUNT)) % CHAT_MODELS.length;
        }
    }
}

export default new GeminiService();
