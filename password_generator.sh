#!/bin/bash

# Define Colors
red="\033[38;5;196m"
green="\033[38;5;82m"
yellow="\033[0;33m"
blue="\033[38;5;51m"
reset="\033[0m"

# Ensure crunch is installed
if ! command -v crunch &> /dev/null; then
    echo -e "${red}Error: crunch is not installed. Install it using 'sudo apt-get install crunch'.${reset}"
    exit 1
fi

# Display banner with decoration
clear
echo -e "${blue}----------------------------------------${reset}"
echo -e "${yellow}   Password Generating Tool${reset}"
echo -e "${green}      Created by: Madhan${reset}"
echo -e "${green}      Email: madhan542111@gmail.com${reset}"
echo -e "${blue}----------------------------------------${reset}"
echo -e ""
toilet -f future "Password Generator" | lolcat
sleep 1

# Prompt user for password length
echo -e "\n${yellow}Enter the password length range:${reset}"
read -p "  Minimum length: " min_len
read -p "  Maximum length: " max_len

# Validate length inputs
if [[ ! $min_len =~ ^[0-9]+$ ]] || [[ ! $max_len =~ ^[0-9]+$ ]] || [[ $min_len -gt $max_len ]]; then
    echo -e "${red}Invalid input. Please enter valid numerical lengths.${reset}"
    exit 1
fi

# Prompt user for character set
read -p "$(echo -e '\033[0;33mEnter the characters to include (e.g., abc123!@#): \033[0m')" char_set

# Validate character set input
if [ -z "$char_set" ]; then
    echo -e "${red}Character set cannot be empty.${reset}"
    exit 1
fi

# Calculate the total number of combinations
total_passwords=0
char_len=${#char_set}

for (( i=$min_len; i<=$max_len; i++ )); do
    combinations=$(( char_len ** i ))
    total_passwords=$(( total_passwords + combinations ))
done

# Calculate the estimated file size (each password includes a newline)
estimated_size=$(( total_passwords * (max_len + 1) ))

# Convert to human-readable format
if [ "$estimated_size" -lt 1024 ]; then
    size_human="${estimated_size} bytes"
elif [ "$estimated_size" -lt 1048576 ]; then
    size_human="$(bc <<< "scale=2; $estimated_size/1024") KB"
else
    size_human="$(bc <<< "scale=2; $estimated_size/1048576") MB"
fi

# Display estimated file size
echo -e "\n${green}Estimated file size: $size_human (${total_passwords} passwords)${reset}"
read -p "$(echo -e '\033[38;5;82mDo you want to continue? (y/n): \033[0m')" confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo -e "${red}Operation cancelled.${reset}"
    exit 1
fi

# Prompt user for output file name
read -p "${yellow}Enter the output filename (without extension): ${reset}" output_file
output_file="${output_file}.txt"

# Generate the password list using crunch
echo -e "\n${blue}Generating password list... This may take some time depending on the size.${reset}"
sleep 1
crunch "$min_len" "$max_len" "$char_set" -o "$output_file"

# Confirm completion
if [ $? -eq 0 ]; then
    echo -e "\n${green}Password list created successfully!${reset}"
    echo -e "${yellow}File saved as: ${output_file}${reset}"
else
    echo -e "${red}An error occurred while generating the password list.${reset}"
fi

# Exit message
echo -e "\n${blue}Thank you for using the Password Generating Tool!${reset}"
cowsay -f dragon "Happy Hacking!" | lolcat
