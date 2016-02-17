import Player from "./player";

let Video = {

  init(socket, element) {
    if(!element) { return; }

    let playerId = element.getAttribute("data-player-id");
    let videoId = element.getAttribute("data-id");

    socket.connect();

    Player.init(element.id, playerId, () => {
      this.onReady(videoId, socket);
    });
  },

  onReady(videoId, socket) {
    let msgContainer = document.getElementById("msg-container");
    let msgInput = document.getElementById("msg-input");
    let postButton = document.getElementById("msg-submit");
    let vidChannel = socket.channel("video:" + videoId);

    vidChannel.join()
    .receive("ok", resp => console.log("joined the video channel", resp))
    .receive("error", reason => console.log("join failed", reason))

    vidChannel.on("ping", ({count}) => console.log("PING", count))
  }

};

export default Video;
