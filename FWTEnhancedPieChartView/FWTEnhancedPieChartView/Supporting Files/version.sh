#!/bin/sh

# Script for managing build and version numbers using git and agvtool.

# Change log:
# v1.0 18-Jul-11 First public release.

version() {
	echo "version.sh 1.0 by Joachim Bondo <osteslag@gmail.com> http://osteslag.tumblr.com"
}

usage() {
	version
cat << EOF >&2

Manages build and version numbers using git and agvtool.

Usage:
  $(basename $0) [options]

Options:
      --terse              Prints the version number in the terse format
  -s, --set                Sets the version number using agvtool
  -p, --plist-path <path>  Write to the built Info.plist file directly
  -b, --bump               Bumps the build number
  -q, --quiet              Supresses output
  -h, --help               Displays this help text
  -v, --version            Displays script version number

Notes:
  - If no options are given, the current versions are printed
  - Specifying -s requires a --plist-path and uses the git tag
EOF
}

list() {

	# List current project version and git version. Ignore $should_echo_output.
	# If the --terse option is given, make the output terse.

	# Add --abbrev=0 to reduce to latest git tag only (without commit count and SAH):
	git_version=`git describe --tags`
  git_version=`git describe --tags` 
  if [ -z "$git_version" ]; then
    git_version="dev-"`git rev-parse --short HEAD`
  fi
	build_number=`agvtool what-version -terse`

	if [ $# == 1 ]; then
		echo "${git_version} (${build_number})"
	else
		echo "Version: ${git_version} (${build_number})"
	fi
}

bump() {

	# Bumps the build number, i.e. the number in parenthesis.

	# Don't print the output of the command itself.
	agvtool bump -all &> /dev/null
	new_version=`agvtool what-version -terse`
	if [ $should_echo_output == true ]; then
		echo "Bumped build number to: ${new_version}"
  fi
}

set_version() {

	# Set the marketing version of the project. 
	# Take the number from git and apply it to the project.
	# Any "v" prepended to the git tag will be removed.

	# Get the current release description from git.
	git_version=`git describe --tags`

	# Check to see if the tag starts with with "v", and remove if so.
	if [[ "${git_version}" == v* ]]; then
		git_version="${git_version#*v}"
	fi

	# Set the project version. 

	# If we use agvtool for this, and this script runs as a build phase, Xcode
	# insists on reloading the project file which is undesired. But if run from
	# the command line, it makes good sense. If plist_path is not empty, we'll 
	# set the version number in it directly.

	if [ -z "$1" ]; then
		agvtool new-marketing-version "${git_version}" &> /dev/null
		new_version=`agvtool what-marketing-version -terse1`
	else
		# Remove the (.plist) extension from the path.
		defaults write "${1%.*}" 'CFBundleShortVersionString' "${git_version}" &> /dev/null
		new_version=`defaults read "${1%.*}" 'CFBundleShortVersionString'`
	fi
	
	if [ $should_echo_output == true ]; then
		echo "New version: ${new_version}"
	fi

}

# --- Main entry point --------------------------------------------------------

# If we don't have any options, just list versions, or if terse, list terse.
if [ $# == 0 ]; then
	list
	exit 0
elif [ $# == 1 -a $1 == --terse ]; then
	list --terse
	exit 0
fi

# Set default values.
should_set_version_number=false
plist_path=""
should_echo_output=true

# Parse command line options.
while [ $# -gt 0 ]; do
	# Check parameters.
	case $1 in
		-s | --set )
			should_set_version_number=true
			;;
		-p | --plist-path )
			plist_path=$2
			shift;;
		-b | --bump )
			bump
			;;
		-q | --quiet )
			should_echo_output=false
			;;
		-h | --help )
			usage
			exit 1;;
		-v | --version )
			version
			exit 1;;
		* ) # Unknown option
			echo "Error: Unknown option '$1'" 1>&2
			usage
			exit 1;;
	esac	
	shift
done

if [ $should_set_version_number == true ]; then
	if [ ! -e "$plist_path" ]; then
		echo "Error: File does not exist '$plist_path'. Specify a valid --plist-path." 1>&2
		exit 1
	else
		set_version "$plist_path"
	fi
fi

exit 0
