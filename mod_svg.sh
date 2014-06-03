#!/bin/sh
#This script inserts param values into an svg file to allow
#modification of simple SVG files within QGIS.
#
#It follows the example in:
#http://www.sourcepole.com/svg-symbols-in-qgis-with-modifiable-colors
#
#USAGE: mod_svg.sh filename(s)

change ()
{
#check for file
if test -f $1 ; then

#echo $1
#echo $@

#get file extension
	ext=`echo $1 | awk -F . '{if (NF>1) {print $NF}}'`
#	echo $ext
	ext_fmt=`echo $ext | tr A-Z a-z`
#	echo $ext_fmt

#is it the right file type?
	if test "$ext_fmt" = 'svg'; then

#check to make sure it's something that can be modified
	  fill=`grep -c fill= $1`
	  stroke=`grep -c stroke= $1`
	  s_width=`grep -c stroke-width= $1`
	  fsw=$(($fill+$stroke+$s_width))
#	  echo $fill	
#	  echo $stroke
#	  echo $s_width
#	  echo $fsw
 	  if test $fsw -gt 0
	  then
#	      echo "candidate passes"

#check to make sure it's not already been done
	     fill_m=`grep -c param\(fill $1`
	     stroke_m=`grep -c param\(stroke $1`
	     s_width_m=`grep -c param\(stroke-width $1`
#	     echo $fill_m
#	     echo $stroke_m
#	     echo $s_width_m
		
 	     if [ "$fill" -ne "$fill_m" -a "$stroke" -ne "$stroke_m" -a "$s_width" -ne "$s_width_m" ]
	     then

		 
# fetch filename. Assuming only .svg or .SVG extensions
		if test "$ext" = 'svg'; then
		    file=`basename $1 .svg`
		else
		    file=`basename $1 .SVG`
		fi
		echo $file


#actually do the substitution
		sed -e 's|\(fill="\)|\1param(fill) |g' \
		    -e 's|\(stroke="\)|\1param(outline) |g' \
		    -e 's|\(stroke-width="\)|\1param(stroke-width) |g' \
			< $1 > "$file"_mod.$ext

#uncomment this to *overwrite* the original
#		cp $1 "$1.bak"; mv "$file"_mod.$ext $1; rm "$file"_mod.$ext

#end of loop looking for completed parameters
	     else
	         echo $1" probably already been done. Check."
          fi

#end of loop checking for valid parameters
	      else
	        echo $1" has no suitable parameters."
	    fi

	else
		echo "$1 is not an SVG file."
	fi

else
	echo "$1 does not exist."
fi
}

while test $# -gt 0
do
    change $1
    shift
done
