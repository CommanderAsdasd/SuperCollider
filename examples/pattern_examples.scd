/******************************************************************************/
// Thomas Klinkenberg 2017
/******************************************************************************/

/* Pattern examples */

(
/* Pbind can combine pattern functions into one variable. In the first example
   it plays C3 (midinote 60) repeatedly with a duration of 0.5 seconds of
   each note. Not boring at all. */
~pattern_example_1 = Pbind (
	\note, 0,
	\dur, 0.5,
);

/* In the second example we now work with \midinote instead of \note. The notes
   are sequenced in the Pseq. The Pseq function needs a array with notes and
   the second argument is how many time the sequences should be repeated. It
   stops when the sequence is done. Look into the helpfile for more info! */
~pattern_example_2 = Pbind (
	\midinote, Pseq([60, 62, 64, 60], 2),
	\dur, 0.5;
);

/* This example makes use of freq instead of notes. The frequencys are sorted
   into an array and it its repeated infite times (inf). The duration of the
   notes are also set into a Pseq. */
~pattern_example_3 = Pbind (
	\freq, Pseq([440, 220, 880], inf),
	\dur, Pseq([0.2, 0.5], inf);
);
)

/* Play the examples */
~pattern_example_1.play;
~pattern_example_2.play;

/* .trace gives outpur of each generated keyword in post window */
~pattern_example_3.trace.play;

(
/* Pbind can work with more keywords like \note or \dur. All these keywords are
   bound to the default synthDef when no other synthDef is defined to the Pbind.
   Lets play around a bit more with the default synthDef.*/
~pattern_example_4 = Pbind (
	\midinote, Pseq([60, 62, 60, 63, 67], 5),
	\dur, Pseq([0.1, 0.2, 0.3], inf),
	\amp, Pseq([0.8, 0.3, 1, 0.5], inf);
);

/* Example with Pwhite. A function that fills a sequence based on white
   noise. */
~pattern_example_5 = Pbind (
	\freq, Pwhite(50, 1000, inf),
	\dur, Pwhite(0.1, 0.9),
	\amp, Pwhite(0.3, 1);
);

/* In the example below the Pshuf is used. Every time the pattern is being used
   is shuffles the sequence. We also see that we can fill the sequence array
   with arrays. The notes now will be played as chords. NOTE: As soon as the
   shortest sequence is done (in this case the \midinote sequence) the
   pattern stops. */
~pattern_example_6 = Pbind (
	\midinote, Pshuf([[60, 64, 67],
		              [60, 65, 69],
		              [59, 62, 67],
		              [60, 64, 69]], 2),
	\dur, Pshuf([0.5, 0.6, 0.7], inf),
	\amp, Pseq([1, 0.5], inf);
);

/* Pser is like Pseq, however the "repeat argument" variable gives the number of
   items instead of the number of complete cycles (lookup the help file). */
~pattern_example_7 = Pbind (
	\midinote, Pser([60, 48, 72], 10),
	\dur, Pseq([0.5, 0.2], inf);
);

/* Other pattern objects you could use:
   Prand() -> chooses random from given array
   Pslide() -> different way to go through the array
   Pseries() -> A pattern that works with a starting value, a value that is
                additioning to the value and the lenght
   Pgeom() -> A pattern just like Pseries() but geometric (multiplication
              factor)
   Pn() -> A pattern object that contains a pattern to repeat the pattern (get
           it?)
   \strum -> Play a chord with a short delay between each note (just like
             strumming on a guitar)

   Look up help files for each object!!! */
)

/* Play the examples */
~pattern_example_4.play;
~pattern_example_5.play;
~pattern_example_6.play;
~pattern_example_7.play;


(
/* In the following example we use a SynthDef \synthdef_example. We have similar
   arguments like freq and amp but also release (for the ADSR) and
   filter_freq. */
SynthDef(\synthdef_example_1, {
	arg freq = 440, amp = 1, gate = 1, attack = 0.1, decay = 0.5, sustain = 0.5,
	    release = 0.5, filter_freq = 440;
	var sig, env;
	env = EnvGen.kr(Env.adsr(attack, decay, sustain, release, curve:-2),
		              gate, doneAction:2);
	sig = Saw.ar(freq, amp);
	sig = BLowPass4.ar(sig, Lag.kr(filter_freq, 0.5));
	sig = sig * env;
	Out.ar([0, 1], sig);
}).add;

/* In this Pbind we call the \synthdef_example with \instrument. After that we
   use the arguments for the synthdef like \freq, \amp, \filter_freq and
   \release. The \dur still determines the duration of the played frequencies.
   You can check all the default keywords for Pbind in the helpfile. */
~pattern_example_8 = Pbind (
	\instrument, \synthdef_example_1,
	\freq, Pwhite(50, 500),
	\dur, Pwhite(0.2, 0.8, inf),
	\amp, Pwhite(0.2, 0.8, inf),
	\filter_freq, Pwhite(440, 5000),
	\release, Pwhite(0.1, 1);
);
)

/* Play the example */
~pattern_example_8.play;

(
/* Another synthdef */
SynthDef(\synthdef_example_2, {
	arg freq = 440, amp = 1.0, gate = 1, attack = 0.1, decay = 0.5,
	    sustain = 0.5, release = 0.5, filter_freq = 440, lfo_freq = 1,
	    pulse_width = 0.5;
	var sig, env, lfo;
	env = EnvGen.kr(Env.adsr(attack, decay, sustain, release, curve:-2),
		              gate, doneAction:2);
	lfo = SinOsc.kr(lfo_freq).range(0.8, 1.2);
	sig = Pulse.ar(freq, pulse_width * lfo, amp);
	sig = BLowPass4.ar(sig, Lag.kr(filter_freq, 0.5));
	sig = sig * env;
	Out.ar([0, 1], sig);
}).add;

/* In this example 1/2, 2/2 and 2/4 is used for the duration. These are
   time signatures. You can work with time signatures if you make use of
   a time clock. See down below at the play section */
~pattern_example_9 = Pbind (
	\instrument, \synthdef_example_2,
	\freq, Pseq([45, 48, 52].midicps, inf),
	\release, 0.2,
	\dur, Prand([1/2, 2/2, 2/4], inf),
	\amp, Pwhite(0.2, 0.8),
	\filter_freq, Pwhite(440, 1000);
);

~pattern_example_10 = Pbind (
	\instrument, \synthdef_example_2,
	\freq, Pseq([60, 62, 64].midicps, inf),
	\dur, Prand([1/2, 2/2, 2/4], inf),
	\release, Prand([0.2, 0.1, 0.5], inf),
	\sustain, 0.1,
	\amp, Pwhite(0.2, 0.5),
	\filter_freq, Pwhite(1000, 5000);
);

/* 1/3 to get some polyrithmic */
~pattern_example_11 = Pbind (
	\instrument, \synthdef_example_2,
	\freq, Pseq([69, 74, 79].midicps, inf),
	\dur, Prand([1/3, 2/3], inf),
	\decay, 0.2,
	\release, 0.1,
	\amp, 0.1,
	\filter_freq, Pwhite(500, 5000);
)
)

/* Play the examples. Variable ~t now has a tempoclock with bpm 80 */
(
~t1 = TempoClock(120/60);
~pattern_example_9.play(~t1);
~pattern_example_10.play(~t1);
~pattern_example_11.play(~t1);
)

/* now the pattern_examples are put into other variables that I called player */
(
~t2 = TempoClock(80/60);
~pattern_player_9 = ~pattern_example_9.play(~t2);
~pattern_player_10 = ~pattern_example_10.play(~t2);
~pattern_player_11 = ~pattern_example_11.play(~t2);
)

/* Fool Around with these */
~pattern_player_9.stop;
~pattern_player_10.stop;
~pattern_player_11.stop;

~pattern_player_9.resume;
~pattern_player_10.resume;
~pattern_player_11.resume;

(
/* Example from the A_Gentle_Introduction_To_SuperCollider.pdf. It uses
   a local variable that contains the duration. */

var myDurs = Pseq([Pn(1, 5), 3,
	               Pn(1, 5), 3,
	               Pn(1, 6), 1/2, 1/2, 1, 1, 3, 1, 3], inf) * 0.4;

~upperMelody = Pbind(
	\midinote, Pseq([69, 74, 76, 77, 79, 81, Pseq([81, 79, 81, 82, 79, 81], 2),
		             82, 81, 79, 77, 76, 74, 74], inf),
    \dur, myDurs;
);

~lowerMelody = Pbind(
	\midinote, Pseq([57, 62, 61, 60, 59, 58, 57, 55, 53, 52, 50, 49, 50, 52,
		             50, 55, 53, 52, 53, 55, 57, 58, 61, 62, 62], inf),
	\dur, myDurs;
);
)

/* Play the melodys */
(
~upperMelody.play;
~lowerMelody.play;
)