/******************************************************************************/
// Thomas Klinkenberg 2017
// https://github.com/Thomasklinkenbergmusic/SuperCollider
/******************************************************************************/

/* The Wobbling Sine Drone
   This is a stereo FM synth. the 'sig' has two numbers (L/R) that
   are controlled by lfo1 and lfo2. The values of of the speed and the AM are
   random (the Rand() functions) */
(
{ // .fork;
	inf.do (
		{
			var sig, lfo1, lfo2, env;

			env = {EnvGen.kr(Env.linen(0.1, 0.5, 5, curve:-2), doneAction:2)};
			lfo1 = {SinOsc.kr(Rand(0.1, 100)).range(Rand(1, 3), Rand(3, 5))};
			lfo2 = {SinOsc.kr(Rand(0.1, 100)).range(Rand(1, 3), Rand(3, 5))};
			sig = {SinOsc.ar([Rand(20, 100) * lfo1, Rand(20, 100) * lfo2],
			                 0, 0.2) * env}.play;
			(rand(3.0)+3).wait;
		};
	);
}.fork;
)

/* Falling Sines
   Pitch is controlled bye the line and is being called 2 times in a array
   for stereo effect (see 'sig) */
(
{ //.fork;
	inf.do (
		{
			var sig, env, line;
			env = {EnvGen.kr(Env.linen(0.1, 0.1, Rand(0.5, 1), curve:-2),
				             doneAction:2)};
			line = {XLine.kr(Rand(800, 500), Rand(450, 50), Rand(0.3, 1))};
			sig = {SinOsc.ar([line, line], 0, 0.2) * [env, env]}.play;
			(rand(2.5)+0.5).wait;
		};
	);
}.fork;
)

/* Plops
   Same as above, only now a lot faster. The env controls the pitch and the
   amplitude. */
(
{ //.fork;
	inf.do (
		{
			var sig, env;
			env = {EnvGen.kr(Env.perc(0.01, Rand(0.1, 0.2),
				                      curve:Rand(-10, -5)), doneAction:2)};
			sig = {(SinOsc.ar( ((env + 0.1) * Rand(400, 800)),
				              mul:0.5)!2 * env)}.play;
			rand(1.0).wait;
		};
	);
}.fork;
)

/* Heavy FM
   The freq of the SinOsc in ' sig is controlled by a Line.kr that gives high
   random values. The frequencies are high enough to make a strange FM effect.
   */
(
{
	inf.do (
		{
			var sig, mod_freq, env;
			env = {EnvGen.kr(Env.linen(releaseTime: 5, curve:-3),
				            doneAction:2)};
			mod_freq = {Line.kr(Rand(800, 600), Rand(500, 400), 5)};
			sig = {SinOsc.ar(SinOsc.kr(mod_freq).range(Rand(200, 400),
				                                       Rand(400, 800)),
				             mul:0.1)!2 * env}.play;
			(rand(3.0)+2).wait;
		};
	);
}.fork;
)

/* Weird metal plates
   Each hit has 80 (!) SinOsc with a random frequencies between 80 - 1500. The
   list variables stores the 80 frequencies, SinOsc sees it as an array.
   Normally the SinOsc tries to put over different channels (L, R and channel
   3-80) The Splay.ar spreads the 80 SinOsc over 2 channels (L + R). Something
   your DAW can't do ;) */
(
{ // .fork;
	inf.do (
		{
			var sig, env, list;
			list = {Array.fill(80, {Rand(50, 1500)})};
			env = {EnvGen.kr(Env.perc(0.01, Rand(2, 6)), doneAction:2)};
            {FreeVerb.ar(Splay.ar(SinOsc.ar(list, mul:0.2), 1) * env,
				         0.5, 1, 1)}.play;
			(rand(3.5)+0.5).wait;
		};
	);
}.fork;
)

/* RTD2 sings
   A SinOsc that is controlled by LFNoise0 Ugens for random frequencies */
(
{SinOsc.ar([LFNoise0.kr(SinOsc.kr(1).range(1, 10)).range(440, 880),
            LFNoise0.kr(SinOsc.kr(1, 0.5).range(1, 10)).range(440, 880)],
			mul:0.1)}.play;
)

/* The no-var-sine-machine
   Maybe not the best example but interresting to analyse and fun to make. It
   is a SinOsc that controls the frequency of a SinOsc that controls the
   frequency of a SinOsc... etc! The same for the amplitude control. */
(
{SinOsc.ar(SinOsc.kr(SinOsc.kr(SinOsc.kr(0.5, 0, 10, 10), 0, 5, 5),
	                 0, 500, 700),
	       0, 0.5)!2 *
SinOsc.kr(SinOsc.kr(SinOsc.kr(SinOsc.kr(0.01, 0, 0.2, 0.2), 0, 0.3, 0.3),
				    0, 0.4, 0.4), 0, 1)!2 * 0.5}.play;
)

/* Dissonance Bells
   Making use of arrays for the frequencies and amplitudes. For more informa-
   tion on fillings arrays look at my array_example on Github or help files! */
(
{ // .fork;
	inf.do (
		{
			var freq, freqlist, amplist, env, sig;
			freq = {Rand(50, 500)};
			freqlist = Array.geom(10, freq, 1.1).round(0.01);
			env = {EnvGen.kr(Env.linen(0.01, 0.5, 2, curve:-2), doneAction:2)};
			amplist = Array.geom(10, 1, 0.9).round(0.01);
			{Splay.ar(SinOsc.ar(freqlist, 0, amplist * env) * 0.5)}.play;
			(rand(1.5)+0.5).wait;
		};
	);
}.fork;
)