(() => {
  var __create = Object.create;
  var __defProp = Object.defineProperty;
  var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
  var __getOwnPropNames = Object.getOwnPropertyNames;
  var __getProtoOf = Object.getPrototypeOf;
  var __hasOwnProp = Object.prototype.hasOwnProperty;
  var __markAsModule = (target) => __defProp(target, "__esModule", { value: true });
  var __commonJS = (cb, mod) => function __require() {
    return mod || (0, cb[Object.keys(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
  };
  var __reExport = (target, module, desc) => {
    if (module && typeof module === "object" || typeof module === "function") {
      for (let key of __getOwnPropNames(module))
        if (!__hasOwnProp.call(target, key) && key !== "default")
          __defProp(target, key, { get: () => module[key], enumerable: !(desc = __getOwnPropDesc(module, key)) || desc.enumerable });
    }
    return target;
  };
  var __toModule = (module) => {
    return __reExport(__markAsModule(__defProp(module != null ? __create(__getProtoOf(module)) : {}, "default", module && module.__esModule && "default" in module ? { get: () => module.default, enumerable: true } : { value: module, enumerable: true })), module);
  };

  // lib/ext.js
  var require_ext = __commonJS({
    "lib/ext.js"(exports) {
      (function() {
        HTMLElement.prototype.on = HTMLElement.prototype.addEventListener;
        HTMLElement.prototype.emit = function(name2, detail) {
          var event;
          event = new CustomEvent(name2, {
            bubbles: true,
            detail
          });
          return this.dispatchEvent(event);
        };
        HTMLElement.prototype.render = function(view) {
          if (view == null) {
            view = this.view();
          }
          if (Array.isArray(view)) {
            return this.replaceChildren(...view);
          } else {
            return this.replaceChildren(view);
          }
        };
      }).call(exports);
    }
  });

  // node_modules/hyphenate.pascalcase/lib/main.js
  var require_main = __commonJS({
    "node_modules/hyphenate.pascalcase/lib/main.js"(exports) {
      (function() {
        exports.hyphenate = function(string) {
          return string.split(/([A-Z][a-z]+)/).filter(Boolean).map(Function.prototype.call, String.prototype.toLowerCase).join("-");
        };
      }).call(exports);
    }
  });

  // lib/tags.js
  var import_ext = __toModule(require_ext());

  // lib/wrap.js
  var element;
  var isString;
  var wrap;
  isString = function(object) {
    return typeof object === "string" || object instanceof String;
  };
  element = function() {
    var attributes, content, name2, node, value;
    switch (arguments.length) {
      case 1:
        name2 = arguments[0];
        return document.createElement(name2);
      case 2:
        [name2, content] = arguments;
        node = document.createElement(name2);
        if (isString(content)) {
          node.innerHTML = content;
        } else if (Array.isArray(content)) {
          node.replaceChildren(...content);
        } else {
          attributes = content;
          for (name2 in attributes) {
            value = attributes[name2];
            node.setAttribute(name2, value);
          }
        }
        return node;
      case 3:
        [name2, attributes, content] = arguments;
        node = document.createElement(name2);
        for (name2 in attributes) {
          value = attributes[name2];
          node.setAttribute(name2, value);
        }
        if (isString(content)) {
          node.innerHTML = content;
        } else if (Array.isArray(content)) {
          node.replaceChildren(...content);
        } else {
          console.log(content);
          console.error("What to do with the above content?");
        }
        return node;
      default:
        console.log(arguments);
        return console.error("What to do with the above arguments?");
    }
  };
  wrap = function(name2) {
    return function(...args) {
      return element(name2, ...args);
    };
  };

  // lib/tag/nameless.js
  var NamelessTag;
  var NamelessTagWithRoot;
  NamelessTag = function(spec) {
    var root;
    root = document.createElement("div");
    return NamelessTagWithRoot(root, spec);
  };
  NamelessTagWithRoot = function(root, { data, view, methods, once }) {
    var element2;
    element2 = root instanceof HTMLElement ? root : root();
    return function(input) {
      var context, fn, key, method, name2, result, value;
      if (element2.data == null) {
        element2.data = {};
      }
      for (key in data) {
        fn = data[key];
        if (input) {
          value = input[key];
        }
        context = { value };
        result = fn.call(context);
        element2.data[key] = result;
        element2[key] = result;
      }
      if (methods) {
        for (name2 in methods) {
          method = methods[name2];
          element2[name2] = method;
        }
      }
      if (view) {
        element2.view = view;
        element2.render();
      }
      if (once) {
        once.call(element2);
      }
      return element2;
    };
  };

  // node_modules/hyphenate.pascalcase/lib/esm.mjs
  var import_main = __toModule(require_main());
  var hyphenate = import_main.default.hyphenate;

  // lib/tag/custom_html_element.js
  var CustomHTMLElement;
  CustomHTMLElement = class CustomHTMLElement2 extends HTMLElement {
    connectedCallback() {
      this.render();
      if (this.once) {
        return this.once();
      }
    }
  };

  // lib/tag/named.js
  var CreateTag;
  var NamedTag;
  NamedTag = function(name2, { connected, data, view, methods, once }) {
    var base, fn, m2, n;
    base = class extends CustomHTMLElement {
    };
    if (view) {
      base.prototype.view = view;
    }
    if (once) {
      base.prototype.once = once;
    }
    if (methods) {
      for (n in methods) {
        m2 = methods[n];
        base.prototype[n] = m2;
      }
    }
    fn = CreateTag({ name: name2, data, base });
    window.TAGS[name2] = fn;
    return fn;
  };
  CreateTag = function({ name: name2, data, base }) {
    name2 = hyphenate(name2);
    customElements.define(name2, base);
    if (data) {
      return function(input) {
        var context, element2, fn, key, result, value;
        element2 = document.createElement(name2);
        if (element2.data == null) {
          element2.data = {};
        }
        for (key in data) {
          fn = data[key];
          if (input) {
            value = input[key];
          }
          context = { value };
          result = fn.call(context);
          element2.data[key] = result;
          element2[key] = result;
        }
        return element2;
      };
    } else {
      return wrap(name2);
    }
  };

  // lib/tag.js
  var isString2;
  isString2 = function(object) {
    return typeof object === "string" || object instanceof String;
  };
  window.tag = function() {
    var first, name2, root, spec;
    switch (arguments.length) {
      case 1:
        spec = arguments[0];
        return NamelessTag(spec);
      case 2:
        [first, spec] = arguments;
        if (isString2(first)) {
          name2 = first;
          return NamedTag(name2, spec);
        } else {
          root = first;
          return NamelessTagWithRoot(root, spec);
        }
    }
  };

  // lib/tags.js
  var i;
  var len;
  var name;
  var names;
  names = ["div", "span", "p", "nav", "a", "button", "template", "slot", "ul", "ol", "li", "dl", "dt", "dd"];
  window.TAGS = {};
  for (i = 0, len = names.length; i < len; i++) {
    name = names[i];
    TAGS[name] = wrap(name);
  }

  // scripts/app.js
  console.log(TAGS);
})();
