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
		};
	);
}.fork;
) // block close

( // block open
{ // .fork;
	inf.do (
		{
			arg i;
			var env;
			i = (i%10)+1;
			env = {EnvGen.kr(Env.linen(0.01, 1.5, 0.01), doneAction:2)};
			{Pulse.ar((110 * i)!2, 0.5, 0.5) * env}.play;
			0.3.wait;
		};
	);
}.fork;
) // block open

( // block open
{ // fork
	1.do (
		{

		};
	);
}.fork;
) // block close