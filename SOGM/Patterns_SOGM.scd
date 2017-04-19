/******************************************************************************/
// Thomas Klinkenberg 2017
// https://github.com/Thomasklinkenbergmusic/SuperCollider
/******************************************************************************/

/*
Patterns - SOGM workshop/les

- WAT ZIJN PATTERNS? -
De Patterns (ook wel de P-family genoemd) zijn classes in SC (SuperCollider) om
sequenties (sequences / reeksen) te creëren, af te spelen en te ordenen. De
patterns classes kun je herkennen aan de hoofdletter P (bijv. Pbind, Pseq, Prand
etc). Patterns kunnen elke vorm van data creëren maar word voornamelijk gebruikt
voor algoritmische compositie. Denk aan data van frequencties/noten, duratie,
ritme, parameters van effecten, etc.

- WAAROM PATTERNS? -
Patterns zijn ideaal voor algoritmische compositie. Het is het beste middel in
SC om sequenties aan te sturen. Met behulp van Patterns schrijf je wat er moet
gebeuren in plaats van hoe SC het moet uitvoeren. Een Pattern is een "blauwdruk"
en SC voert de blauwdruk uit. In de meeste gevallen betekend dit ook minder
code.

Voor een uitgebreide documentatie: Help Browser -> Streams-Patterns-Events ->
A-Practical-Guide.

*/

/******************************************************************************/

/*
- Pbind -
Pbind is een class die verschillende Pattern objecten bij elkaar voegt en o.a.
een zelfgemaakte SynthDef kan aansturen. Hieronder een eenvoudig voorbeeld met
uitleg.
*/

// Een SynthDef met de naam SineSynth. De argumenten die mee te geven zijn aan
// de synth zijn out (output channel), gate (gate trigger voor de envelope),
// release voor de envelope, frequentie en amplitude.
(
SynthDef.new(\SineSynth,
	{
		arg out = 0, gate = 1, rel = 0.25, freq = 220, amp = 1;
		var env, sine1, sine2, sig;

		env = EnvGen.kr(Env.adsr(0.05, 1, 0.75, rel), gate, doneAction:2);
		sine1 = SinOsc.ar(freq);
		sine2 = SinOsc.ar([freq * 0.99, freq * 1.01] * 2, 0, 0.5);
		sig = Mix([sine1, sine2]);
		sig = sig * 0.25;
		sig = sig * env * amp;

		Out.ar(out, sig);
	};
).add;
)

// Synth voorbeeld
Synth(\SineSynth);

// Een Pbind in variable ~pattern1
(
~pattern1 = Pbind(
	\instrument, \SineSynth,
	\freq, Pseq([60, 62, 64, 60].midicps, 2),
	\amp, 1,
	\dur, Pseq([1, 1, 1, 1], inf),
);
)

// Speel ~pattern1
~pattern1.play();

/*
Het Pbind object heeft argumenten nodig in paren van twee die gescheiden worden
door een comma. Zo'n paar bestaat een "control input" en wat voor data er
doorgestuurd moet worden naar de controller.

De control inputs in de bovenstaande Pbind zijn \instrument, \freq, \dur en
\amp. Achter de \instrument control input staat \SineSynth. Hiermee word de data
van de Pbind doorgevoerd naar de SynthDef die eerder is aangemaakt. De \freq en
\amp control inputs sturen de argumenten aan van de SynthDef die gedefinieerd
word door de \instrument control input. Dit kan letterlijk elk argument zijn
zolang de SynthDef het beschikbaar stelt.

De \dur control input is echter geen argument van de \SineSynth. Dit komt omdat
Pbind een paar standaard control inputs heeft die een SynthDef kunnen aansturen.
Control input \dur bepaalde in dit geval de duratie van elke noot. De standaard
control inputs kun je vinden bij de Pbind Help Browser -> SynthDef and Event.

Bij control input \freq staat een Pseq. Dit is een van de Pattern classes die
gebruikt kunnen worden bij het maken van een sequentie. Pseq bij \freq heeft
twee argumenten; een lijst en een 2. Kijk in de helpbrowser voor mee informatie.
In dit geval zal hij de lijst met data 2 keer herhalen en doorsturen naar
SynthDef SineSynth argument freq.

Bij control input \dur staat een Pseq met een lijst en inf. Dit houd in dat de
lijst oneindig keer herhaald zal worden. De waardes in deze lijst zijn
nootlengtes (verder in dit document een uitleg over tempo). Bij \amp
staat 1 wat inhoud dat de waarde altijd 1 zal blijven.

NOTE: De Pbind stopt zodra het eerste Pattern object klaar is met z'n sequentie.
In het bovenstaande geval is dat de Pseq bij control input \freq.

Er zijn veel meer Pattern objecten als Pseq. Kijk in Help Browser ->
Streams-Patterns-Events -> A-Practical-Guide -> Pattern Guide 02: Basic
Vocabulary voor meer informatie.

*/

// Prand en Pxrand
(
~pattern2 = Pbind(
	\instrument, \SineSynth,
	\freq, Prand([48, 50, 51, 53, 55].midicps, inf),
	\amp, Pseq([1, 0.5, 0.1], inf),
	\dur, Pxrand([1/2, 1/4, 1/8], inf),
);
)

~pattern2.play();

// Pshuf, Pwhite en \midinote
// NOTE: de \midinote control input stuurt waardes door naar argument met de naam
// freq. Dus als er geen argument is met de naam freq zal dit geen effect hebben!
(
~pattern3 = Pbind(
	\instrument, \SineSynth,
	\midinote, Pshuf([60, 63, 67], 4),
	\amp, Pwhite(0.1, 1, inf),
	\dur, Pseq([1/2, 1/4, 1/4], inf),
);
)

~pattern3.play();

// Data naar \rel (stuurt release aan)
(
~pattern4 = Pbind(
	\instrument, \SineSynth,
	\freq, Pwhite(220, 1720, 32),
	\amp, Pwhite(0.2, 1, inf),
	\rel, Pwhite(0.1, 4, inf),
	\dur, Pxrand([1/8, 1/16, 1/8, 1/4], inf),
);
)

~pattern4.play;

/******************************************************************************/

/*
- Tempo en ritme -
Bij control input \dur kun je nootwaardes invullen die het ritme bepalen. Deze
nootwaardes houden rekening met een TempoClock (een klok, vergelijkbaar met een
metronoom). SC heeft altijd een default TempoClock die loopt op 60 BPM. Deze
TempoClock staat altijd aan. We kunnen Pbinds ook op verschillende TempoClocks
laten draaien. Meer info over TempoClocks kun je vinden in de helpfile.

We gebruiken de SineSynth SynthDef uit het vorige voorbeeld.
*/

// Een simpele Pbind met \dur, 1 (speelt kwartnoten af)
(
~pattern5 = Pbind(
	\instrument, \SineSynth,
	\midinote, Pseq([64, 62, 60, 62], 2),
	\amp, 1,
	\dur, 1,
);
)

~pattern5.play();

// Aanpassen van de default TempoClock
TempoClock.default.tempo=(60/60) // default
TempoClock.default.tempo=(120/60) // Twee keer zo snel
TempoClock.default.tempo=(240/60) // Vier keer zo snel

// Pas de default TempoClock aan en speel ~pattern5 nog een keer af. Alle
// eerdere Pbind voorbeelden zullen ook sneller afgespeeld worden (deze lopen
// ook op de default TempoClock.

(
~pattern6 = Pbind(
	\instrument, \SineSynth,
	\midinote, Pseq([60, 62,
		             64, 67, 64, 62,
		             60, 64, 67,
		             69, 72, 71, 67,
		             64, 65, 64, 62], inf),
	\amp, 1,
	\dur, Pseq([1/4, 1/4,
		        1, 1, 1, 1,
		        3.5, 1/4, 1/4,
		        1, 1, 1, 1,
		        1.5, 1/4, 1/4, 1.5]),
);
)

// Maak hier een aparte tempoclock met variable naam ~t
~t = TempoClock.new(100/60);

// De Pattern laten afspelen met de ~t TempoClock
~pattern6.play(~t);

/* NOTE: Wanneer de shortcut CMD+. word ingetoets stoppen ook de zelfgemaakte
   TempoClock stop gezet. Deze moet opnieuw aangezet worden. */

// Twee patterns
(
~pattern7 = Pbind(
	\instrument, \SineSynth,
	\midinote, Pseq([48, 48, 48, 60, 60, 60, 60], inf),
	\sustain, 0.1,
	\amp, 1,
	\dur, Pseq([1/4, 1/4, 1/2, 1/4, 1/4, 1/4, 1/4], inf),
);

~pattern8 = Pbind(
	\instrument, \SineSynth,
	\midinote, Pshuf([67, 63, 72, 75], inf),
	\amp, Pseq([0.75, 0.5, 0.25], inf),
	\sustain, 0.2,
	\dur, Pshuf([1/2, 1/2, 1/4, 1/4], 5),
);
)

// Default TempoClock op 120 BPM.
TempoClock.default.tempo=(120/60);

// Tegelijk afspelen laat ze allebei tegelijk starten. Afzonderlijk van elkaar
// starten kan een ongedefinieerd ritme geven.
~pattern7.play();
~pattern8.play();

// Met argument quant worden deze op een bepaalde maatwaarden van de TempoClock
// gestart.
~pattern7.play(quant:4);
~pattern8.play(quant:4);

// Een Pbind met \rest
(
~pattern9 = Pbind(
	\instrument, \SineSynth,
	\midinote, Pseq([60, 55, \rest, 60, \rest, 63, 62, \rest]+12, inf),
	\dur, 1/4,
	\amp, 0.5,
);
)

~pattern9.play(quant:4);

// In de \midinote control input staan nu \rest's en de \dur is constant 1/4. Op
// de \rest word een rust uitgevoerd

/******************************************************************************/

/*
- Patterns in Patterns -
Met Pbind kun je een combinatie van sequenties laten afspelen. In de
bovenstaande voorbeelden moesten we deze zelf afspelen. Nu word het tijd om
Patterns in Patterns te verwerken voor een uitgebreidere compositie.

In de volgende compositie gebruiken maken we een nieuwe SynthDef.
*/

// Een SynthDef
(
SynthDef.new(\BassSynth,
	{
		arg out = 0, amp = 1, gate = 1, freq = 50, filter_freq = 880,
		    filter_q = 0.63;
		var sig, env, filter_env;

		env = EnvGen.kr(Env.adsr(0.01, 0.25, 0.75, 0.1), gate, doneAction:2);
		filter_env = XLine.kr(filter_freq * 1.4193, filter_freq, 0.5);
		sig = VarSaw.ar([freq, freq * 1.0005], 0, 0.15, 20).distort;
		sig = RLPF.ar(sig, filter_env, filter_q);
		sig = Mix.new([sig]);
		sig = sig * env * 0.5;
		sig = sig * amp;

		Out.ar(out, sig);
	}
).add;
)

// Verschillende Pbinds opgeslagen in variable
(
~mainPattern = Pbind(
	\instrument, \BassSynth,
	\midinote, Pseq([36, 36, 36, \rest, 36, 48], 2),
    \dur, Pseq([1/2, 1/4, 1/4, 1/2, 1/4, 1/4], inf),
	\filter_freq, Pwhite(220, 880, inf),
	\legato, Pshuf([0.9, 0.3, 0.3, 0.3, 0.3], inf),
	\amp, 1,
);
~variantionPattern1 = Pbind(
	\instrument, \BassSynth,
	\midinote, Pshuf([\rest, 48, 39, 43, 48, 39, 47], inf),
    \dur, Pshuf([1/4, 1/4, 1/2], 4),
	\filter_freq, Pwhite(50, 1720, inf),
	\legato, Pseq([0.3, 0.3, 0.3, 0.3, 0.3], inf),
	\amp, 1,
);
~variantionPattern2 = Pbind(
	\instrument, \BassSynth,
	\freq, Pwhite(50, 220, inf),
	\dur, Pseq([1/4, 1/4, 1/4, 1/4], 4),
	\filter_freq, Pwhite(50, 220, inf),
	\filter_q, Pwhite(0.2, 0.75, inf),
	\legato, 0.3,
	\amp, Pwhite(0.1, 0.5, inf),
);
~endPattern = Pbind(
	\instrument, \BassSynth,
	\midinote, Pseq([34, 34, 34, 34, 32, 32, 32, 32], 1),
    \dur, Pseq([1, 1, 1, 1, 1, 1, 1, 1], inf),
	\filter_q, Pseq([0.9, 0.8, 0.75, 0.6, 0.5, 0.45, 0.40, 0.35], inf),
	\legato, 1,
	\amp, 0.5,
);
)

// Een Pseq die verschillede Pbinds afspeelt in variabel ~pattern_player1
(
~pattern_player1 = Pseq([
	~mainPattern,
	~variantionPattern1,
	~mainPattern,
	~variantionPattern2,
	~mainPattern,
	~variantionPattern1,
	~mainPattern,
	~endPattern,
], 2);
)

TempoClock.default.tempo=(120/60);

// Play ~pattern_player1
~pattern_player1.play(quant:4);

// Een Prand die de patterns random afspelen
(
~pattern_player2 = Prand([
	~mainPattern,
	~variantionPattern1,
	~variantionPattern2,
	~endPattern,
], inf);
)

// Play ~pattern_player2
~pattern_player2.play(quant:4);
