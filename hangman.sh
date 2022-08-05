#!/bin/bash
### The Hangman Game
game_dir="/home/olegv/pet_projects/hangman_linux"
cat $game_dir/logo
# Declare stages array
stages=("stage1" "stage2" "stage3" "stage4" "stage5" "stage6" "stage7")
# Create an array of words from a file 
word_list=( $(cat hangman_words) )
# Retrieve array indices and get the random indice number
random_indice=$(echo ${!word_list[@]} | xargs shuf -n1 -e )
# Computer random chosen word
computer_word=${word_list[${random_indice}]}
# Switch to end the game
game_over=false
# Number of lives total
lives=6
# Generate an array of blanks for the computer selected word
displayed_word=()
## Get the length of a string that computer selected
computer_word_length=${#computer_word}
count=1
while (( $count <= $computer_word_length ))
do
    displayed_word+=("_")
    ((count++))
done
# Empty array to keep track of guessed letters
guessed_letters=()
echo ${displayed_word[@]}
# Ask User for an input letter
while [[ $game_over != "true" ]]
do    
    read -p "Guess the letter, please: " guessed_letter
    clear
    # Check if the guessed letter was already entered previously
    for letter in ${guessed_letters[@]}
    do
        if [[ "$letter" == "$guessed_letter" ]]
        then
            echo "Letter $guessed_letter was already guessed, just FYI"
        fi
    done
    # Append the guessed_letter to guessed_letters array
    guessed_letters+=("$guessed_letter")
    # Check if guessed letter is not in the word
    if grep -q "${guessed_letter}" <<< "${computer_word}"
    then
        # Loop through the letters of computer selected word
        for (( i=0; i<${#computer_word}; i++ ))
        do
            letter=$(echo "${computer_word:$i:1}")
            # Check if the letter matches user guessed input
            if [[ "$letter" == "$guessed_letter" ]]
            then
                # Replace the blank space with the letter
                displayed_word[$i]="${guessed_letter}"
            fi
        done
    else
        echo "Letter ${guessed_letter} is not in the word. You lost one life."
        ((lives--))
        # Check the number of lives, if 0 - game over
        if (( $lives == 0 ))
        then
            game_over=true
            echo "You lose."
        fi
    fi
    # Check if there are any blank spaces in a list, if not, user won
    blank_spaces=0
    for position in "${displayed_word[@]}"
    do
        if [[ "_" == "$position" ]]
        then
            ((blank_spaces++))
        fi
    done
    if (( $blank_spaces == 0 ))
    then
        game_over=true
        echo "You win."
    fi
    echo ${displayed_word[@]}
    cat $game_dir/${stages[$lives]}
done