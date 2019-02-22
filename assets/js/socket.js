import { Socket } from "phoenix";

const token = document.querySelector('meta[name=ws_token]').getAttribute('content');
let socket = token && new Socket("/socket", { params: { token: token } });
socket && socket.connect();

export default socket;
