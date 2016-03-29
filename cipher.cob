*>Alex Lapena
*>Trithemius Cipher

identification division.
program-id. cipher.

environment division.
input-output section.
file-control.
	select ifile 	assign to fChoice
		organization is line sequential.

data division.
	file section.
	fd ifile.
	01 in-record.
		05 word		pic X(100).

working-storage section.

	01 switches.
		05 eof-switch	pic x value "N".	
		05 choice		pic x.
		05 fChoice		pic x(50).
	01 counters.
		05 counter		pic 9(3) value 0.
		05 trail		pic 99.
		05 strLength	pic 9(3).
		05 strLength2	pic 9(3).
		05 i			pic 99.
		05 cyphCount	pic 9(8).
	01 string1.
		05 str			pic x occurs 100 times.
	01 cyphVal			pic 9(8).
	01 offset			pic 9(8).

procedure division.

000-main.	

*> 	User must copy code encrypted output to a file then re-run for decryption
	display "Enter a file to encrypt or decrypt.".
	accept fChoice.
	
	open input ifile.
	
	read ifile
		at end
			move "Y" to eof-switch
		not at end
			compute counter = counter + 1
	end-read.
	
	display "*****************************************".
	display "Would you like to (e)ncrypt or (d)ecrypt?".
	display "*****************************************".
	
	accept choice.
	
	if choice is equal to "e"
		Display "+-----------------+"
		display "|Encrypted Message|"
		Display "+-----------------+"
		Display " "
		perform 100-encrypt
			until eof-switch = "Y"
	else 
		if choice is equal to "d"
			Display "+-----------------+"
			display "|Decrypted Message|"
			Display "+-----------------+"
			Display " "
			perform 200-decrypt
				until eof-switch = "Y"
		else
			display "Please enter a valid command."
		end-if
	end-if.
	Display " ".

	close ifile.
	
	stop run.
	
*> Encrypts the user inputted file.
100-encrypt.

	move 00000000 to cyphCount
	move word to string1.
	move function length(string1) to strLength.
	perform 300-cleanString.
	
*> Loops through the cypher, calculates an offset to appropriately scale the alpha loop
	perform varying i from 1 by 1 until i is greater than strLength2	
		if str(i) is not alphabetic
			display str(i)
		else 
			if str(i) is not equal to " "
				if cyphCount is greater than 26
					move 00000000 to cyphCount
				end-if
				compute cyphVal = function ord(str(i)) - cyphCount
				if cyphVal is less than 00000098 and function ord(str(i)) is greater than 00000091
					compute offset = 00000098 - cyphVal
					compute cyphVal = 00000124 - offset
				else 
					if cyphVal is less than 00000066
						compute offset = 00000066 - cyphVal
						compute cyphVal = 00000091 - offset
					end-if
				end-if
				display function char(cyphVal) with no advancing		
				compute cyphCount = cyphCount + 00000001
			end-if
		end-if
	end-perform.
	
	read ifile
		at end
			move "Y" to eof-switch
		not at end
			compute counter = counter + 1
	end-read.
	
*> Decrypts encrypted code for the user.
200-decrypt.

	move 00000000 to cyphCount
	move word to string1.
	move function length(string1) to strLength.
	perform 300-cleanString.
	
*> Loops through the cypher, calculates an offset to appropriately scale the alpha loop
	perform varying i from 1 by 1 until i is greater than strLength2	
		if str(i) is not alphabetic
			display str(i)
		else 
			if str(i) is not equal to " "
				if cyphCount is greater than 26
					move 00000000 to cyphCount
				end-if
				compute cyphVal = function ord(str(i)) + cyphCount
				if cyphVal is greater than 00000123
					compute offset = cyphVal - 00000124
					compute cyphVal = 00000098 + offset
				else 
					if cyphVal is greater than 00000091 and function ord(str(i)) is less than 00000091
						compute offset = cyphVal - 00000091
						compute cyphVal = 00000066 + offset
					end-if
				end-if
				display function char(cyphVal) with no advancing
				compute cyphCount = cyphCount + 00000001
			end-if
		end-if
	end-perform.
	
	read ifile
		at end
			move "Y" to eof-switch
		not at end
			compute counter = counter + 1
	end-read.
	
*> Removes trailing zeros from the sting to clean up the lengths.
300-cleanString.
	
		move zero to trail.
		inspect function reverse(string1)
			tallying trail for leading space.
		compute strLength2 = strLength - trail.
