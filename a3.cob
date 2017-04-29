*>Domenic Bianchi 
*>Assignment #3
*>March 24, 2017
*>This program reads in a text file and counts the number of words, chars, numbers, and calulates ratios.

identification division.
program-id. textReader.

environment division.
    input-output section.
    file-control.
    select ifile assign to dynamic fileName
        file status is fstatus.
    select ofile assign to "out.txt".

data division.
    file section.
    fd ifile.
    01 fileLetter.
        05 letter pic x(1).
    fd ofile.
    01 outLetter pic x(1).

    working-storage section.

    01 outputLines.
        02 filler pic x(80)
            value "--------------------------------------------------------------------------------".
        02 filler pic x(1)
            value x"0A".
        02 filler pic x(20)
            value spaces.
        02 filler pic x(35)
            value "NUMBER OF SENTENCES=".
        02 outputSentence pic -(7)9.
        02 filler pic x(1)
            value x"0A".
        02 filler pic x(20)
            value spaces.
        02 filler pic x(35)
            value "NUMBER OF WORDS=".
        02 outputWords pic -(7)9.
        02 filler pic x(1)
            value x"0A".
        02 filler pic x(20)
            value spaces.
        02 filler pic x(35)
            value "NUMBER OF CHARS=".
        02 outputChars pic -(7)9.
        02 filler pic x(1)
            value x"0A".
        02 filler pic x(20)
            value spaces.
        02 filler pic x(35)
            value "AVERAGE NUMBER OF WORDS/SENTENCE=".
        02 outputWrdSen pic -(4)9.9(2).
        02 filler pic x(1)
            value x"0A".
        02 filler pic x(20)
            value spaces.
        02 filler pic x(35)
            value "AVERAGE NUMBER OF SYMBOLS/WORD=".
        02 outputSymWrd pic -(4)9.9(2).
	02 filler pic x(1)
            value x"0A".
        02 filler pic x(20)
            value spaces.
        02 filler pic x(35)
            value "NUMBER OF NUMBERS=".
        02 outputNumOfNums pic -(7)9.
        02 filler pic x(1)
            value x"0A".

    01 outputTitle.
        02 filler pic x(80)
            value "--------------------------------------------------------------------------------".
        02 filler pic x(1)
            value x"0A".
        02 filler pic x(31)
            value spaces.
        02 filler pic x(19)
            value "INPUT TEXT ANALYZED".
        02 fller pic x(1)
            value x"0A".
        02 filler pic x(80)
            value "--------------------------------------------------------------------------------".

    77 fileName pic x(50).
    77 prevChar pic x(1).
    01 fstatus pic x(2).
    01 i pic 9999.
    01 numOfWords pic 999999.
    01 numOfNums pic 999999.
    01 numOfSentences pic 999999.
    01 numOfChars pic 999999.

procedure division.
 
    *>Get file name from user and prompt until the file can be opened
    perform
        until i equals 1
        display "Enter file name:"
        accept fileName

        open input ifile
        *>File status of 00 means there are no issues with the file and the program can correctly handle it
        if fstatus not equals 00 then
            display "Invalid file. Please input the name of a valid text file."
        else
            move 1 to i
        end-if
        close ifile
    end-perform.

    open input ifile, output ofile.
    
    *>Write header to the output file
    move 82 to i.
    perform
        until i is greater than 212
        write outLetter from outputTitle(i:1)
        add 1 to i
    end-perform.
    write outLetter from x"0A".

    *>Set default values
    move 0 to numOfWords.
    move 0 to numOfNums.
    move 0 to numOfSentences.
    move 0 to numOfChars.

    *>Loop through each character in the file
    perform forever
        read ifile into fileLetter
            at end exit perform
            not at end
                write outLetter from fileLetter

               *>If the character is a letter from the alphabet count it as a character
                if fileLetter is alphabetic and fileLetter not equals space and fileLetter not equals x"0A" then
                    add 1 to numOfChars
                end-if

                *>If a number has been found, do not count it as a word but rather a number
                if fileLetter is numeric and prevChar is not numeric then
                    add 1 to numOfNums
                    subtract 1 from numOfWords
                end-if

                *>Check for the end of a sentence
                if fileLetter equals '.' or fileLetter equals '?' or fileLetter equals '!' then
                    add 1 to numOfSentences
                *>Check for the end of a word
                else if (fileLetter equals space or fileLetter equals x"0A") and prevChar not equals '/' and prevChar not equals space and prevChar not equals x"0A" then
                    add 1 to numOfWords

                    *>If a dash is found in between words treat it as one word
                    if prevChar is equal to '-' then
                        subtract 1 from numOfWords
                    end-if
                end-if

        end-read
        move fileLetter to prevChar
    end-perform.
    close ifile.

    *>Calculate stats that require averages
    compute outputWrdSen = numOfWords/numOfSentences
    compute outputSymWrd = numOfChars/numOfWords

    *>Move the stats to other variables to make it easier to write the data to the file
    move numOfSentences to outputSentence.
    move numOfWords to outputWords.
    move numOfChars to outputChars.
    move numOfNums to outputNumofNums.

    *>Write all stats to the output file
    move 1 to i.
    perform
        until i is greater than 464
        write outLetter from outputLines(i:1)
        add 1 to i
    end-perform.
    write outLetter from x"0A".

    *>Add the header to the output file
    move 1 to i.
    perform
        until i is greater than 212
        write outLetter from outputTitle(i:1)
        add 1 to i
    end-perform.
    write outLetter from x"0A".

    close ofile.
