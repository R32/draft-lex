package;

class Main extends Test {             // override hscript/Test.hx

	override function assertScript(x, v:Dynamic, ?vars:Dynamic, allowTypes = false, ?pos:haxe.PosInfos) {
		var str = lms.ByteData.ofString(x);
		var lex = new hs.Lexer(str);  // hs.Lexer
		var p = new hs.Parser(lex);   // hs.Parser
		var program = p.main();
		var bytes = hscript.Bytes.encode(program);
		program = hscript.Bytes.decode(bytes);
		var interp = new hscript.Interp();
		if( vars != null )
			for( v in Reflect.fields(vars) )
				interp.variables.set(v,Reflect.field(vars,v));
		var ret : Dynamic = interp.execute(program);
		assertEquals(v, ret, pos);
	}

	static function main() {
		#if ((haxe_ver < 4) && php)
		// uncaught exception: The each() function is deprecated. This message will be suppressed on further calls (errno: 8192)
		// in file: /Users/travis/build/andyli/hscript/bin/lib/Type.class.php line 178
		untyped __php__("error_reporting(E_ALL ^ E_DEPRECATED);");
		#end

		var runner = new haxe.unit.TestRunner();
		runner.add(new Main());
		var succeed = runner.run();

		#if sys
			Sys.exit(succeed ? 0 : 1);
		#elseif flash
			flash.system.System.exit(succeed ? 0 : 1);
		#else
			if (!succeed)
				throw "failed";
		#end
	}
}