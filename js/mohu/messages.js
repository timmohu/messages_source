if (typeof(mohu) == "undefined") mohu = {};

if (typeof(mohu.messages) == "undefined") mohu.messages = {};

mohu.messages.Message = function() {

	var self = this;
	
	this.dispatcher = null;
	this.target = null;
	this.currentTarget = null;
	
	if (!mohu.messages.Message.initialised) {	
		mohu.messages.Message.initialised = true;
		
		mohu.messages.Message.prototype.clone = function() {
			return new mohu.messages.Message();
		}
	}
};

mohu.messages.Dispatcher = function(target) {
			
	var self = this;
		
	var _listeners = [];
	
	this.target = target;
	
	if (!mohu.messages.Dispatcher.prototype.initialised) {
		mohu.messages.Dispatcher.prototype.initialised = true;
		
		mohu.messages.Dispatcher.prototype.addListener = function(method, target, runOnce) {
			if (method == null) throw("No method specified");
			for (var i = 0; i < _listeners.length; i++) {
				var listener = _listeners[i];
				if ((listener[0] != method) || (listener[1] != target)) continue;
				if (listener[2] && !runOnce) listener[2] = false;
				return;
			}
			_listeners.push([method, target, runOnce]);
		}
		
		mohu.messages.Dispatcher.prototype.hasListener = function(method, target) {
			if (method == null) throw("No method specified");
			for (var i = 0; i < _listeners.length; i++) {
				var listener = _listeners[i];
				if ((listener[0] == method) && (listener[1] == target)) return true;
			}
			return false;
		}
		
		mohu.messages.Dispatcher.prototype.removeListener = function(method, target) {
			if (method == null) throw("No method specified");
			for (var i = 0; i < _listeners.length; i++) {
				var listener = _listeners[i];
				if ((listener[0] != method) || (listener[1] != target)) continue;
				_listeners.splice(i, 1);
				return;
			}
		}
		
		mohu.messages.Dispatcher.prototype.removeAllListeners = function() {
			_listeners = [];
		}
		
		mohu.messages.Dispatcher.prototype.dispatch = function(message, customTarget) {
			if (_listeners.length == 0) return;
			if (message == null) message = new mohu.messages.Message;
			var target = customTarget || message.target;
			message = message.clone();
			message.target = target || this.target;
			message.currentTarget = this.target;
			message.dispatcher = this;
			for (var i = 0; i < _listeners.length; i++) {
				var listener = _listeners[i];
				if (listener[2]) _listeners.splice(i--, 1 );
				listener[0].call(listener[1], message);
			}
			return;
		}
	}
};