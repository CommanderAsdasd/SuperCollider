/******************************************************************************/
// Thomas Klinkenberg 2017
/******************************************************************************/

/* The Wobbling Sine Drone */

( // block open
{ // .fork;
	inf.do (
		{
			var sig, lfo1, lfo2, env;

			env = {EnvGen.kr(Env.linen(0.1, 0.5, 5, curve:-2), doneAction:2)};
			lfo1 = {SinOsc.kr({Rand(0.1, 100)}).range({Rand(1, 3)},
				                                      {Rand(3, 5)})};
			lfo2 = {SinOsc.kr({Rand(0.1, 100)}).range({Rand(1, 3)},
				                                      {Rand(3, 5)})};
			sig = {SinOsc.ar([{Rand(20, 100)} * lfo1, {Rand(20, 100)} * lfo2],
			                 0, 0.2) * env}.play;
			rand(3.0, 6.0).wait;
		};
	);
}.fork;
) // block close

/* Falling Sines */

( // block open
{ // .fork;
	inf.do (
		{
			var sig, env, line;
			env = {EnvGen.kr(Env.linen(0.1, 0.1, {Rand(0.5, 1)},
				                       curve:-2), doneAction:2)};
			line = {XLine.kr({Rand(800, 500)}, {Rand(450, 50)},
				                               {Rand(0.3, 1)})};
			sig = {SinOsc.ar([line, line], 0, 0.2) * [env, env]}.play;
			rand(1.0, 5.0).wait;
		};
	);
}.fork;
) // block close

/* Plops */

( // block open
{ // .fork;
	inf.do (
		{
			var sig, env;
			env = {EnvGen.kr(Env.perc(0.01, {Rand(0.1, 0.2)},
				                      curve:{Rand(-10, -5)}),
				             doneAction:2)};
			sig = {(SinOsc.ar( ((env + 0.1) * {Rand(400, 800)}),
				              mul:0.5)!2 * env)}.play;
			rand(0.5, 5.0).wait;
		};
	);
}.fork;
) // block close

/* Heavy FM */

( // block open
{ // .fork;
	inf.do (
		{
			var sig, mod_freq, env;
			env = {EnvGen.kr(Env.linen(releaseTime: 5, curve:-6),
				            doneAction:2)};
			mod_freq = {Line.kr({Rand(800, 600)}, {Rand(500, 400)}, 5)};
			sig = {SinOsc.ar(SinOsc.kr(mod_freq).range({Rand(200, 400)},
				                                       {Rand(400, 800)}),
				             mul:0.1)!2 * env}.play;
			rand(5, 10.0).wait;
		};
	);
}.fork;
) // block close

/* Weird metal plates (duplicated sine waves) */

( // block open
{ // .fork;
	inf.do (
		{
			var sig, env, list, done_env;
			list = {Array.fill(80, {Rand(50, 1500)})};
			env = {EnvGen.kr(Env.perc(0.01, {Rand(2, 6)}))};
			done_env = {EnvGen.kr(Env.perc(0.1, 8), doneAction:2)};
			sig = {FreeVerb.ar((Splay.ar((SinOsc.ar(list, mul:0.2)), 1) * env),
				               0.5, 1, 1)}.play;
			rrand(0.5, 4.0).wait;
		};
	);
}.fork;
) // block clase

/* RTD2 sings */

( // block open
{ // .fork;
	1.do (
		{
			{SinOsc.ar([LFNoise0.kr(SinOsc.kr(1).range(1, 10)).range(440, 880),
				        LFNoise0.kr(SinOsc.kr(1, 0.5).range(1, 10)
			            ).range(440, 880)],
			mul:0.1)}.play;
		};
	);
}.fork;
) // block closes