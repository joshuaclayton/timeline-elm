const $ = require("jquery");

class Errors {
  constructor(selector) {
    this.selector = selector;
  }

  set(value) {
    $(this.selector).text(value);
  }

  clear() {
    $(this.selector).text("");
  }
}

module.exports = Errors;
