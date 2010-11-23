package mohu.messages;

/**
 * @author Tim Kendrick
 */

import Array;

class Message {
	
	public var target(getTarget, setTarget):Dynamic;
	public var currentTarget(getCurrentTarget, setCurrentTarget):Dynamic;
	public var dispatcher(getDispatcher, setDispatcher):Dynamic;
	
	private var _target:Dynamic;
	private var _currentTarget:Dynamic;
	private var _dispatcher:Dispatcher;

	public function new() {
	}
	
	public function clone():Message {
		if (Type.getClass(this) != Message) throw "All Message subclasses must override the clone() method";
		return new Message();
	}
	
	private function getTarget():Dynamic {
		return _target;
	}
	
	private function setTarget(value:Dynamic):Dynamic {
		return _target = value;
	}
	
	private function getCurrentTarget():Dynamic {
		return _currentTarget;
	}
	
	private function setCurrentTarget(value:Dynamic):Dynamic {
		return _currentTarget = value;
	}
	
	private function getDispatcher():Dispatcher {
		return _dispatcher;
	}
	
	private function setDispatcher(value:Dispatcher):Dispatcher {
		return _dispatcher = value;
	}
}