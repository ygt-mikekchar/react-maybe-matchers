/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var ComponentQuery, ReactMatchers;

	__webpack_require__(1);

	ComponentQuery = __webpack_require__(2);

	ReactMatchers = {
	  toBeAComponent: function(util, testers) {
	    return {
	      compare: function(component, func) {
	        var filter;
	        filter = new ComponentQuery(component, util, testers);
	        return func(filter);
	      }
	    };
	  }
	};

	module.exports = ReactMatchers;


/***/ },
/* 1 */
/***/ function(module, exports) {

	String.prototype.pluralize = function(num, plural) {
	  if (num === 1) {
	    return this;
	  }
	  if (plural != null) {
	    return plural;
	  } else {
	    return this + "s";
	  }
	};


/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	var ComponentFilter, ComponentQuery, JasmineMonad,
	  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
	  hasProp = {}.hasOwnProperty;

	JasmineMonad = __webpack_require__(3);

	ComponentFilter = __webpack_require__(4);

	ComponentQuery = (function(superClass) {
	  extend(ComponentQuery, superClass);

	  function ComponentQuery(value, util, testers, messages1) {
	    this.value = value;
	    this.util = util;
	    this.testers = testers;
	    this.messages = messages1;
	    ComponentQuery.__super__.constructor.call(this, this.value, this.util, this.testers, this.messages);
	    this.contains = this;
	  }

	  ComponentQuery.prototype.returnMany = function(nodes, messages) {
	    return new ComponentFilter(nodes, this.util, this.testers, messages);
	  };

	  ComponentQuery.prototype.tags = function(tag) {
	    return this.bind((function(_this) {
	      return function(component) {
	        var messages, nodes;
	        nodes = Utils.scryRenderedDOMComponentsWithTag(component, tag);
	        messages = ["Expected to find DOM tag " + tag + ", but it was not there.", "Expected not to find DOM tag " + tag + ", but there " + (_this.was(nodes.length)) + "."];
	        if (nodes.length > 0) {
	          return _this.returnMany(nodes, messages);
	        } else {
	          return _this["return"](null, messages);
	        }
	      };
	    })(this));
	  };

	  return ComponentQuery;

	})(JasmineMonad);

	module.exports = ComponentQuery;


/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	var JasmineMonad;

	__webpack_require__(1);

	JasmineMonad = (function() {
	  function JasmineMonad(value1, util, testers, messages1) {
	    this.value = value1;
	    this.util = util;
	    this.testers = testers;
	    this.messages = messages1;
	    if (this.messages == null) {
	      this.messages = [];
	    }
	  }

	  JasmineMonad.prototype["return"] = function(value, messages) {
	    return new this.constructor(value, this.util, this.testers, messages);
	  };

	  JasmineMonad.prototype.bind = function(func) {
	    if (this.passed()) {
	      return func(this.value);
	    } else {
	      return this;
	    }
	  };

	  JasmineMonad.prototype.passed = function() {
	    return this.value != null;
	  };

	  JasmineMonad.prototype.result = function() {
	    var result;
	    result = {};
	    result.pass = this.util.equals(this.passed(), true, this.testers);
	    if (this.messages != null) {
	      if (result.pass) {
	        result.message = this.messages[1];
	      } else {
	        result.message = this.messages[0];
	      }
	    }
	    return result;
	  };

	  JasmineMonad.prototype.was = function(num) {
	    return 'was'.pluralize(num, 'were') + (" " + num);
	  };

	  JasmineMonad.prototype.count = function(num, singular, plural) {
	    return num + " " + (singular.pluralize(num, plural));
	  };

	  return JasmineMonad;

	})();

	module.exports = JasmineMonad;


/***/ },
/* 4 */
/***/ function(module, exports, __webpack_require__) {

	var ComponentFilter, JasmineMonad,
	  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
	  hasProp = {}.hasOwnProperty;

	JasmineMonad = __webpack_require__(3);

	__webpack_require__(1);

	ComponentFilter = (function(superClass) {
	  extend(ComponentFilter, superClass);

	  function ComponentFilter(value, util, testers, messages1) {
	    this.value = value;
	    this.util = util;
	    this.testers = testers;
	    this.messages = messages1;
	    ComponentFilter.__super__.constructor.call(this, this.value, this.util, this.testers, this.messages);
	    this["with"] = this;
	    this.and = this;
	    this.time = this;
	    this.times = this;
	  }

	  ComponentFilter.prototype.cssClass = function(cssClass) {
	    return this.bind((function(_this) {
	      return function(nodes) {
	        var match, matched, messages, node;
	        match = function(a, b) {
	          if (b == null) {
	            return false;
	          }
	          return b.indexOf(a) !== -1;
	        };
	        if (nodes != null ? nodes.length : void 0) {
	          matched = (function() {
	            var i, len, results;
	            results = [];
	            for (i = 0, len = nodes.length; i < len; i++) {
	              node = nodes[i];
	              if (match(cssClass, node.props.className)) {
	                results.push(node);
	              }
	            }
	            return results;
	          })();
	        } else {
	          matched = [];
	        }
	        messages = ["Expected to find DOM node with class " + cssClass + ", but it was not there.", "Expected not to find DOM node with class " + cssClass + ", but there " + (_this.was(matched.length)) + "."];
	        if (matched.length > 0) {
	          return _this["return"](matched, messages);
	        } else {
	          return _this["return"](null, messages);
	        }
	      };
	    })(this));
	  };

	  ComponentFilter.prototype.exactly = function(num) {
	    return this.bind((function(_this) {
	      return function(nodes) {
	        var messages;
	        messages = ["Expected to find exactly " + (_this.count(num, 'node')) + ", but there " + (_this.was(nodes.length)), "Expected not find " + (_this.count(num, 'node')) + ", but there " + (_this.was(nodes.length)) + "."];
	        if (nodes.length === num) {
	          return _this["return"](nodes, messages);
	        } else {
	          return _this["return"](null, messages);
	        }
	      };
	    })(this));
	  };

	  return ComponentFilter;

	})(JasmineMonad);

	module.exports = ComponentFilter;


/***/ }
/******/ ]);