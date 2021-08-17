#  Bullseye Assembly Game (MIPS)
#  Written by Eran Meir    

# Input
This program gets 3 number chars in a row, '0' - '9' that do not contain repetition
```diff
+ Example for legal inputs: 123, 321, 234, 987, 012 etc.
- Example for illegal inputs: 111, 121, 122, 133, 2qa, asd, 3k1, 999 etc.
```

# Output
If you have guessed the correct number in the correct index - you'll get 'b'

# Example 1:
Guess my number (bool array): <b>1</b>23

Nice, good number input!

Enter your guess (guess array): <b>1</b>89

Nice, good number input!

b

If you have guessed a correct number but not in the correct index - you'll get a 'p'
# Example 2:
Guess my number (bool array): <b>1</b>23

Nice, good number input!

Enter your guess (guess array): 4<b>1</b>5

Nice, good number input!

p

Combination of the cases above
# Example 3:
Guess my number (bool array): 123

Nice, good number input!

Enter your guess (guess array): 321

Nice, good number input!

bpp

If you have guessed everything correctly (bbb) the game will end and you will be asked if you want to start another game
# Example 4:
Guess my number (bool array): 123

Nice, good number input!

Enter your guess (guess array): 123

Nice, good number input!

bbb

Well done! You got 3 b's, bye! 

Would you like to start another game? (y/n): y

Guess my number (bool array): ......

Illegal inputs will result asking for a legal input:
# Example 5:
Guess my number (bool array): asd

Illegal input! Enter again.

Guess my number (bool array): 123

Nice, good number input!


