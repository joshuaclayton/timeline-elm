const { app, Menu } = require("electron").remote;

const template = [
  {
    label: app.appName,
    submenu: [{ role: "quit" }]
  },
  {
    label: "Edit",
    submenu: [
      { role: "undo" },
      { role: "redo" },
      { type: "separator" },
      { role: "cut" },
      { role: "copy" },
      { role: "paste" },
      { role: "selectall" }
    ]
  },
  {
    role: "window",
    submenu: [{ role: "minimize" }, { role: "close" }]
  },
  {
    role: "help",
    submenu: [
      {
        label: "Learn More",
        click() {
          require("electron").shell.openExternal(
            "https://github.com/joshuaclayton/timeline-app"
          );
        }
      }
    ]
  }
];

const menu = Menu.buildFromTemplate(template);
Menu.setApplicationMenu(menu);
