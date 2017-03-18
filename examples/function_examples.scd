/******************************************************************************/
// Thomas Klinkenberg 2017
/******************************************************************************/

/* Function examples
   Go to the control structures help file for more information! */

/* Simple if statement */
(
var i = rand(100);

if ( (rand(100) > 50),
	// true
	{"first statement true".postln},
	// false
	{"first statement false".postln};
);

// Compare local variable int
("variable i = " + i).postln;
if ( (i > 50),
	// true
	{"second statement true".postln},
	// false
	{"second statement false".postln};
);
)

/* Case function */
(
var i = rand(100);
("variable i = " + i).postln;

case
{(i >= 0) && (i < 25)}{"i is less then 25".postln}
{(i >= 25) && (i < 50)}{"i is between 24 and 50".postln}
{(i >= 50) && (i < 75)}{"i is between 49 and 75".postln}
{true} {"none of the statements above are true".postln};

/* Boolean expression have to be a comparison. You can fill in multipile
   expression with && (AND) or || (OR) */
);

/* While function - While the first statement is true, execute the function */
(
var i = 0;
while ( {i < 5}, {i = i + 1; "adding to i!".postln} );
i.postln;
);

/* For loop - Start value and ending value - repeats same task while counting
   up the argument */
(
for (0, 9, {arg i;i.postln});
);

/* Switch function - Compares a given value */
(
var x=rand(2); // Random choosing between 0 and 1
switch(x,
	0, {"hello".postln},
	1, {"goodbye".postln}
)
)

/* Do function - Like a forloop, executes a given function x many times */
(
5.do({arg i;
	i + 1;
	i.postln;
});
)