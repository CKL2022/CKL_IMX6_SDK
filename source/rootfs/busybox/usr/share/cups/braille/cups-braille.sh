#
# Copyright (c) 2015-2016 Samuel Thibault <samuel.thibault@ens-lyon.org>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 

# Get an attribute from the ppd file
getAttribute () {
  ATTRIBUTE=$1
  VALUE=`grep "^\*$ATTRIBUTE:" "$PPD" | cut -d" " -f2`
  VALUE=${VALUE##\"}
  VALUE=${VALUE%%\"}
  printf "DEBUG: Attribute $ATTRIBUTE is '%s'\n" "$VALUE" >&2
  printf "%s" "$VALUE"
}

# Get an option for the document: either default ppd attribute or user-provided value
getOption () {
  OPTION=$1
  VALUE=$(getAttribute Default$OPTION)
  printf "DEBUG: Default $OPTION is '%s'\n" "$VALUE" >&2

  if [ -n "$OPTIONS" ]
  then
    # Case of the very first option
    if [ -z "${OPTIONS/$OPTION=*}" ]
    then
      VALUE=${OPTIONS#$OPTION=}
      VALUE=${VALUE%% *}
      printf "DEBUG: Selected $OPTION is '%s'\n" "$VALUE" >&2
    fi
    # Case of other options
    if [ -z "${OPTIONS/* $OPTION=*}" ]
    then
      VALUE=${OPTIONS##* $OPTION=}
      VALUE=${VALUE%% *}
      printf "DEBUG: Selected $OPTION is '%s'\n" "$VALUE" >&2
    fi

    # Boolean options
    if [ -z "${OPTIONS/* $OPTION *}" ]
    then
      VALUE=True
      printf "DEBUG: Selected $OPTION is '%s'\n" "$VALUE" >&2
    fi
    if [ -z "${OPTIONS/* no$OPTION *}" ]
    then
      VALUE=False
      printf "DEBUG: Selected $OPTION is '%s'\n" "$VALUE" >&2
    fi
  fi

  printf "%s" "$VALUE"
}

# Get an option for the document and check that it is a number
getOptionNumber () {
  OPTION=$1
  VALUE=$(getOption $OPTION)
  case "$VALUE" in
    [0-9]*) ;;
    *) printf "ERROR: Option $OPTION must be a number, got '%s'\n" "$VALUE" >&2
       exit 1
       ;;
  esac
  printf "%s" "$VALUE"
}

[ -z "$NB" ] && NB=1

#
# Page size
# Units in 100th of mm
#

# TODO: better handle imageable area
PAGESIZE=$(getOption PageSize)
case "$PAGESIZE" in
  Legal)
    PAGEWIDTH=21590
    PAGEHEIGHT=35560
    ;;
  Letter)
    PAGEWIDTH=21590
    PAGEHEIGHT=27940
    ;;
  A3)
    PAGEWIDTH=29700
    PAGEHEIGHT=42000
    ;;
  A4)
    PAGEWIDTH=21000
    PAGEHEIGHT=29700
    ;;
  A4TF)
    PAGEWIDTH=21000
    PAGEHEIGHT=30480
    ;;
  A5)
    PAGEWIDTH=14850
    PAGEHEIGHT=21000
    ;;
  110x115)
    PAGEWIDTH=27940
    PAGEHEIGHT=29210
    ;;
  110x120)
    PAGEWIDTH=27940
    PAGEHEIGHT=30480
    ;;
  110x170)
    PAGEWIDTH=27940
    PAGEHEIGHT=43180
    ;;
  115x110)
    PAGEWIDTH=29210
    PAGEHEIGHT=27940
    ;;
  120x120)
    PAGEWIDTH=30480
    PAGEHEIGHT=30480
    ;;
  *)
    printf "ERROR: Unknown page size '%s'\n" "$PAGESIZE" >&2
    exit 1
    ;;
esac

#??TODO: hardcoded margin
PRINTABLEWIDTH=$((PAGEWIDTH - 1000))
PRINTABLEHEIGHT=$((PAGEHEIGHT - 1000))


#
# Text spacing
#

TEXTDOTDISTANCE=$(getOptionNumber TextDotDistance)
case "$TEXTDOTDISTANCE" in
  220) TEXTCELLDISTANCE=310 ;;
  250) TEXTCELLDISTANCE=350 ;;
  320) TEXTCELLDISTANCE=525 ;;
  *)
    printf "ERROR: Unknown text dot distance '%s'\n" "$TEXTDOTDISTANCE" >&2
    exit 1
    ;;
esac

TEXTDOTS=$(getOptionNumber TextDots)
LINESPACING=$(getOptionNumber LineSpacing)

# Compute number of printable cells according to page width and height
TEXTWIDTH=$(( ($PRINTABLEWIDTH + $TEXTCELLDISTANCE) / ($TEXTDOTDISTANCE + $TEXTCELLDISTANCE) ))
TEXTHEIGHT=$(( ($PRINTABLEHEIGHT + $LINESPACING) / ($TEXTDOTDISTANCE * ($TEXTDOTS / 2 - 1) + $LINESPACING) ))

#
# Graphic spacing
#

# Compute number of printable cells according to page size
GRAPHICDOTDISTANCE=$(getOptionNumber GraphicDotDistance)
GRAPHICWIDTH=$(( $PRINTABLEWIDTH / $GRAPHICDOTDISTANCE ))
GRAPHICHEIGHT=$(( $PRINTABLEHEIGHT / $GRAPHICDOTDISTANCE ))

#
# Text translation
#

TABLESDIR=/usr/share/liblouis/tables
echo "DEBUG: Liblouis table directory is $TABLESDIR" >&2
  
getOptionLibLouis () {
  OPTION=$1
  VALUE=$(getOption $OPTION)

  # Check validity of input
  case "$VALUE" in
    [-_.0-9A-Za-z]*) ;;
    *) printf "ERROR: Option $OPTION must be a valid liblouis table name, got '%s'\n" "$VALUE" >&2
       exit 1
       ;;
  esac

  # Check presence of table
  if [ "$VALUE" != None ]
  then
    [ -f "$TABLESDIR/$VALUE".utb ] && VALUE="$VALUE".utb
    [ -f "$TABLESDIR/$VALUE".ctb ] && VALUE="$VALUE".ctb
    if [ ! -f "$TABLESDIR/$VALUE" ]
    then
      printf "ERROR: Could not find $OPTION table '%s'\n" "$VALUE"
      exit 1
    fi
  fi

  printf "%s" "$VALUE"
}

LIBLOUIS1=$(getOptionLibLouis LibLouis)
LIBLOUIS2=$(getOptionLibLouis LibLouis2)
LIBLOUIS3=$(getOptionLibLouis LibLouis3)
LIBLOUIS4=$(getOptionLibLouis LibLouis4)

echo "DEBUG: Table1 $LIBLOUIS1" >&2
echo "DEBUG: Table2 $LIBLOUIS2" >&2
echo "DEBUG: Table3 $LIBLOUIS3" >&2
echo "DEBUG: Table4 $LIBLOUIS4" >&2

[ "$LIBLOUIS1" != None ] && LIBLOUIS_TABLES="$LIBLOUIS1"
[ "$LIBLOUIS2" != None ] && LIBLOUIS_TABLES="${LIBLOUIS_TABLES:+$LIBLOUIS_TABLES,}$LIBLOUIS2"
[ "$LIBLOUIS3" != None ] && LIBLOUIS_TABLES="${LIBLOUIS_TABLES:+$LIBLOUIS_TABLES,}$LIBLOUIS3"
[ "$LIBLOUIS4" != None ] && LIBLOUIS_TABLES="${LIBLOUIS_TABLES:+$LIBLOUIS_TABLES,}$LIBLOUIS4"

#
# Checking for presence of tools
#
checkTool() {
  TOOL=$1
  PACKAGE=$2
  USE=$3
  if ! type $TOOL > /dev/null
  then
    printf "ERROR: The $PACKAGE package is required for $USE\n" >&2
    exit 1
  fi
}
