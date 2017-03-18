/******************************************************************************/
// Thomas Klinkenberg 2017
/******************************************************************************/

/* Array examples */

/* All the following examples are from:
   A_Gentle_Introduction_To_SuperCollider.pdf */

/* Store a array into global variable ~array_example_1 */
~array_example_1 = [10,11,12,13,14,15,16,17];

/* Things you can do with the array */
~array_example_1.reverse   // reverse
~array_example_1.scramble; // scramble
~array_example_1.choose;   // picks one element at random
~array_example_1.size;     // returns size of array
~array_example_1.at(0);    // retrieves item at specified position
~array_example_1[0];       // Same as .at(0)

/* Do some math with arrays */
~array_example_1 + 10;
~array_example_1 * 10;
~array_example_1 / 10;
(~array_example_1 * 0.235).round(0.01);

~array_example_2 = [5, 10, 20, 6, 7];

/* Tryout the following lines and evaluate the array */
~array_example_2.add(500);       // Adds 500 at the end
~array_example_2.insert(2, 255); // Inserts 255 at position 2 (couting from 0)
~array_example_2.put(2, 100);    // Replaces second position with 100
~array_example_2.permute(2);     // Puts position 2 to position 0 in array
~array_example_2;                // Evaluate the array

