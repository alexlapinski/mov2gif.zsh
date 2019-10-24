function mov2gif() {
	if (( $# == 0 ))
	then 
		echo "usage: mov2gif <input_filepath> [output_filepath] [dimensions]"; 
		echo "\t <input_filepath>  - [required] the path to the mov file input"
		echo "\t <output_filepath> - [optional] the path to save the output gif (default is 'out.gif')"
		echo "\t <dimensions>      - [optional] the width and height of the output, passed to ffmpeg, use -1 to allow auto scaling. (default is 640:-1)"
		echo "examples: ";
		echo "\tmov2gif ./movie.mov ./output.gif 1024x768"; 
		echo "\tmov2gif ./movie.mov ./output.gif"; 
		return; 
	fi
	source="${1}"
	dest="${2:-out.gif}"
	scale="${3:-640:-1}"

	echo $fg[grey]"Checking Dependencies"$fg[default]

	if ! [[ -x "$(command -v ffmpeg)" ]] 
	then
		if ! [[ -x "$(command -v brew)" ]] 
		then
			echo $fg[red]"Error: Homebrew isn't installed, go install that first"
			echo $fg_bold[white]"https://brew.sh/"
			echo ""
			return;
		fi
		
		echo $fg[yellow]"Installing ffmpeg"
		brew install ffmpeg
		echo $fg[green]"Install Complete"
	fi

	if ! [[ -x "$(command -v gifsicle)" ]]
	then
		if ! [[ -x "$(command -v brew)" ]] 
		then
			echo $fg[red] "Error: Homebrew isn't installed, go install that first"$fg[default]
			echo $fg[red] "https://brew.sh/"$fg[default]
			echo ""
			return;
		fi
		
		echo $fg[yellow]"Installing gifsicle"$fg[default]

		# dependency for gifsicle (only in mountain lion (10.8) and above)
		systemVersion=$(sw_vers -productVersion | sed 's/\(.*\)\.\(.*\)\.\(.*\)/\2/')
		mountainLionVersion=8
		if [[ systemVersion -ge mountainLionVersion ]] then;
			echo $fg[yellow]"Installing xquartz"$fg[default]
			brew cask install xquartz
		fi

		brew install gifsicle
		echo $fg[green]"Install Complete"$fg[default]
	fi
	echo $fg[green]"Done\n"$fg[default]

	print $fg_bold"Reading file at:"   $fg_no_bold"'$source'"
	echo $fg_bold"Scaling output to:" $fg_no_bold"'$scale'"
	echo $fg_bold"Writing output to:" $fg_no_bold"'$source'"
	echo $fg[green]"Executing ffmpeg & gifsicle"$fg[default]
	ffmpeg -loglevel quiet -i $source -vf scale=$scale -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $dest
	echo $fg[green]"Done"$fg[default]
	echo ""
	echo $fg[green]"Conversion Complete"$fg[default]
	echo ""
}
