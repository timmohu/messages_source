package mohu.messages;

/**
 * @author Tim Kendrick
 */

import mohu.utils.ArrayUtils;

class Dispatcher {
	
	public var target(getTarget, setTarget):Dynamic;
	
	private var _target:Dynamic;
	private var _listeners:Array<ListenerMapping>;

	public function new(target:Dynamic) {
		_target = target;
		_listeners = new Array<ListenerMapping>();
	}
	
	public function addListener(listener:Message->Void, ?runOnce:Bool = false):Void {
		if (listener == null) throw "No listener specified";
		for (listenerMapping in _listeners) {
			if (listenerMapping.listener != listener) continue;
			if (listenerMapping.runOnce && !runOnce) listenerMapping.runOnce = false;
			return;
		}
		var listenerMapping:ListenerMapping = {listener: listener, runOnce: runOnce};
		_listeners.push(listenerMapping);
	}
	
	public function hasListener(listener:Message->Void):Bool {
		if (listener == null) throw "No listener specified";
		for (listenerMapping in _listeners) if (listenerMapping.listener == listener) return true;
		return false;
	}
	
	public function removeListener(listener:Message->Void):Void {
		if (listener == null) throw "No listener specified";
		var i:Int = -1;
		while (i < _listeners.length) {
			if (_listeners[++i].listener != listener) continue;
			_listeners.splice(i, 1);
			return;
		}
	}
	
	public function removeAllListeners():Void {
		_listeners = new Array<ListenerMapping>();
	}
	
	public function dispatch(?message:Message, ?customTarget:Dynamic):Void {
		if (_listeners.length == 0) return;
		if (message == null) message = new Message();
		var target:Dynamic = (customTarget ? customTarget : message.target);
		message = message.clone();
		message.target = (target ? target : _target);
		message.currentTarget = _target;
		message.dispatcher = this;
		var i:Int = -1;
		while (++i < _listeners.length) {
			var listenerMapping:ListenerMapping = _listeners[i];
			if (listenerMapping.runOnce) _listeners.splice(i--, 1);
			listenerMapping.listener(message);
		}
		return;
	}
	
	private function getTarget():Dynamic {
		return _target;
	}
	
	private function setTarget(value:Dynamic):Dynamic {
		return _target = value;
	}
}

private typedef ListenerMapping = {
	var listener:Message->Void;
	var runOnce:Bool;
}