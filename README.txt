Video demonstration: http://www.youtube.com/watch?v=rtnACphfJrE

KeyDisembark is a 5 button keyboard. There are 31 combinations (not 32 because pressing nothing will not register as a key press). These combinations map to all 26 letters, shift, space, basic punctuation, and backspace. Here are the combinations:

a = a...
b = .o.t space
c = a..t space
d = a..t
e = ..e.
f = ..et space
g = .oe. space
h = .oe.
i = ..et
j = aoe. space
k = a.et
l = ao..
m = a.e. space
n = ...t space
o = .o..
p = ..e. space
q = ao.t
r = a... space
s = .o.. space
t = ...t
u = aoe.
v = .oet space
w = .o.t
x = a.e.
y = ao.. space
z = a.et space
! = shift and then ao.t space
, = shift and then .oet
. = .oet
? = ao.t space
shift = toea
return = shift and then space
backspace = all 5 (hold for repeat)


timingtest.html
Javascript code for doing a timing test to measure what key combos are fast to type. This was used to increase efficiency by assigning common keys to the be fast ones.

keydisembark.cpp
This is the arduino code that runs on a Leonardo to convert button presses to keyboard writes.

teach.rb
This is a ruby script to help with the learning curve associated with learning a new keyboard layout that must be memorized and committed to muscle memory. It tracks how well you know each key, and chooses words that help you work on the ones you haven't mastered yet. It also does not overwhelm the user; it will never teach more than 2 new letters at a time.