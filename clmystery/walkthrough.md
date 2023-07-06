https://github.com/veltman/clmystery

**Prompt**

> There's been a murder in Terminal City, and TCPD needs your help. To figure out whodunit, you need access to a command line.

---

[**Step 1**](/clmystery/shell.sh#L1-L5) Get the crime scene report

```shell
cat instructions
grep "CLUE" crimescene
```

> CLUE: Footage from an ATM security camera is blurry but shows that the perpetrator is a tall male, at least 6'. 
>
> CLUE: Found a wallet believed to belong to the killer: no ID, just loose change, and membership cards for AAA, Delta SkyMiles, the local library, and the Museum of Bash History. The cards are totally untraceable and have no name, for some reason.
>
> CLUE: Questioned the barista at the local coffee shop. He said a woman left right before they heard the shots. The name on her latte was Annabel, she had blond spiky hair and a New Zealand accent.

---

[**Step 2**](/clmystery/shell.sh#L8-L13) Find witness and get report transcripts

```shell
grep "Annabel" people | grep -w "F"
```
<table>
<tr>
    <td>Annabel Sun</td><td>F</td><td>26</td><td>Hart Place, line 40</td>
</tr>
<tr>
    <td>Annabel Church</td><td>F</td><td>38</td><td>Buckingham Place, line 179</td>
</tr>
</table>

```shell
head -40 streets/Hart_Place | tail +40
```
> SEE INTERVIEW #47246024

```shell
head -179 streets/Buckingham_Place | tail +179
```
> SEE INTERVIEW #699607

```shell
cat interviews/interview-47246024 <(echo '\n') interviews/interview-699607 
```

> Ms. Sun has brown hair and is not from New Zealand.  Not the witness from the cafe.
>
> Interviewed Ms. Church at 2:04 pm.  Witness stated that she did not see anyone she could identify as the shooter, that she ran away as soon as the shots were fired.
> 
> However, she reports seeing the car that fled the scene.  Describes it as a blue Honda, with a license plate that starts with "L337" and ends with "9"

---

[**Step 3**](/clmystery/shell.sh#L16) Find the suspects at least 6' tallwith Hondas that match Annabel's description

```shell
grep -A 5 "L337..9" vehicles | grep -A 4 "Honda" | grep -A 3 "Blue" | grep -B 1 "6'.\""  | cut -c8- | awk "NR % 3 == 1" > suspects
```

> Erika Owens <br/>
> Joe Germuska <br />
> Jeremy Bowers <br />
> Jacqui Maher

---

[**Step 4**](/clmystery/shell.sh#L19) Find the suspects with all four memberships

```shell
grep -xf memberships/Delta_SkyMiles memberships/Terminal_City_Library | grep -xf memberships/AAA | grep -xf memberships/Museum_of_Bash_History > members
```

> Sonata Raif <br />
> Marina Murphy <br />
> ... <br />
> Kelly Kulish

---

[**Step 5**](/clmystery/shell.sh#L22-L24) Find the suspects in both groups

```shell
grep -f members suspects
```

> Jeremy Bowers <br />
> Jacqui Maher <br />

```shell
grep 'Jeremy Bowers\|Jacqui Maher' people
```
<table>
<tr>
    <td>Jacqui Maher</td><td>F</td><td>40</td><td>Andover Road, line 224</td>
</tr>
<tr>
    <td>Jeremy Bowers</td><td>M</td><td>34</td><td>Dunstable Road, line 284</td>
</tr>
</table>

Since Jeremy is Male, he must be the perpetrator.

---

**Check solution**

```shell
echo "Jeremy Bowers" | $(command -v md5 || command -v md5sum) | grep -qif /dev/stdin encoded && echo CORRECT\! GREAT WORK, GUMSHOE. || echo SORRY, TRY AGAIN.
```

> CORRECT! GREAT WORK, GUMSHOE.
