#!/bin/bash

######################
# Author: Veera Marni
# Description: This script will get all the users who has access to the git repo and revoke the access for particular
#              user using api call.
######################

# GitHub API URl

API_URL="https://api.github.com"

# GitHub Username and Token (We can get it from the organization)

USERNAME=$username      #These values are exported to the bash_profile
TOKEN=$token

# User and Repository information
# These are command line arguments provided by the user when running the script

REPO_OWNER=$1
REPO_NAME=$2
number_of_arguments=$#

# Function to make a GET request to the GIT API

function github_get_api {
  endpoint="$1"
  local url="${API_URL}/${endpoint}"

  # Send a GET request to the GitHub API with authentication

  curl -s -u "${USERNAME}:${TOKEN}" "${url}"
}

function list_users_with_read_access {
  local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

  # Insert the collaborators and their roles on the repository into the collaborator_roles
  # splitting the output on space delimiter
  read -rd ' ' -a collaborators <<< "$(github_get_api "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"
  read -rd ' ' -a role_names <<< "$(github_get_api "$endpoint" | jq -r '.[].role_name')"
#
#  read -rd ' ' -a collaborators_arr <<< "$collaborators"
#  read -rd ' ' -a role_names_arr <<< "$role_names"

  # Display the list of collaborators with read access
  if [[ -z "$collaborators" ]]; then
    echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
  else
    echo "Users with read access and their roles to ${REPO_OWNER}/${REPO_NAME}:"
    for i in "${!collaborators[@]}"; do
      collaborator="${collaborators[$i]}"
      role="${role_names[$i]}"
      # shellcheck disable=SC2059
      printf "$collaborator\t: $role\n"
      done
    echo $'\n'
  fi
}

function main {
  if [ $number_of_arguments != 2 ]; then
    echo "Please enter the required command line arguments <<REPO_OWNER>> and <<REPO_NAME>> followed by the command."
  else
    list_users_with_read_access
  fi
}

# Main script

echo $'\nListing the users with read access to the ${REPO_OWNER}/${REPO_NAME}.....\n'
main
