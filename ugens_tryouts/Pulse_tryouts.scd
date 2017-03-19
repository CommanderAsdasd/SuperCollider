/******************************************************************************/
// Thomas Klinkenberg 2017
// https://github.com/Thomasklinkenbergmusic/SuperCollider
/******************************************************************************/

/* A simple Pulse wave loop */

( // block open
{ // .fork;
	inf.do (
		{
			var env;
			env = {EnvGen.kr(Env.linen(0.01, 0.1, 0.1, curve:-2),
				             doneAction:2)};
			{Pulse.ar(freq:Rand(220, 440)!2, mul:0.3) * env}.play;
			0.3.wait;
		}
	)
}.fork;
) // block close