# instructions
cat instructions

# get clues from crimescene report
grep "CLUE" crimescene

# get Annabels that match the clues
grep "Annabel" people | grep -w "F"

head -40 streets/Hart_Place | tail +40
head -179 streets/Buckingham_Place | tail +179

cat interviews/interview-47246024 <(echo '\n') interviews/interview-699607 

# find drivers of matching vehicles
grep -A 5 "L337..9" vehicles | grep -A 4 "Honda" | grep -A 3 "Blue" | grep -B 1 "6'.\""  | cut -c8- | awk "NR % 3 == 1" > suspects

# find people with matching memberships
grep -xf memberships/Delta_SkyMiles memberships/Terminal_City_Library | grep -xf memberships/AAA | grep -xf memberships/Museum_of_Bash_History > members

# find suspects that match memberships and vehicles
grep -f members suspects

grep 'Jeremy Bowers\|Jacqui Maher' people

# submit answer
echo "Jeremy Bowers" | $(command -v md5 || command -v md5sum) | grep -qif /dev/stdin encoded && echo CORRECT\! GREAT WORK, GUMSHOE. || echo SORRY, TRY AGAIN.