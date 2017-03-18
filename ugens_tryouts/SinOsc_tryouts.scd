/******************************************************************************/
// Thomas Klinkenberg 2017
/******************************************************************************/

s.boot;

/* The Wobbling Sine Drone */

( // Open block
{ // .fork;
	inf.do(
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
	)
}.fork;
) // Close Block

/* Falling Sines */

( // Open block
{ // .fork;
	inf.do (
		{
			var sig, env, line;
			env = {EnvGen.kr(Env.linen(0.1, 0.1, {Rand(0.5, 1)},
				                       curve:-2), doneAction:2)};
			line = {XLine.kr({Rand(800, 500)}, {Rand(450, 50)}, {Rand(0.3, 1)})};
			sig = {SinOsc.ar([line, line], 0, 0.2) * [env, env]}.play;
			rand(1.0, 5.0).wait;
		};
	)
}.fork;
) // Close Block

/* Plops */

( // Open block
{ // .fork;
	inf.do(
		{
			var sig, env;
			env = {EnvGen.kr(Env.perc(0.01, {Rand(0.1, 0.2)},
				                      curve:{Rand(-10, -5)}),
				             doneAction:2)};
			sig = {(SinOsc.ar( ((env + 0.1) * {Rand(400, 800)}),
				            mul:0.5)!2 * env)}.play;
			rand(0.5, 5.0).wait;
		}
	)
}.fork;
) // Close Block  