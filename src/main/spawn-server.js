const _spawn = require("child_process").spawn;
const path = require("path");
const serverPath = path.join(__dirname, "../../bin/timeline-server");

module.exports = () => {
  const server = _spawn(serverPath);

  server.stdout.on("data", data => {
    console.log(`server data: ${data}`);
  });

  server.stderr.on("data", data => {
    console.log(`server error: ${data}`);
  });

  server.on("close", code => {
    console.log("server exit code", code);
  });

  return server;
};
