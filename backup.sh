#!/bin/bash
# Database connection information
  dbname=dbname     # (e.g.: dbname=drupaldb)
  dbhost=dbhost
  dbuser=dbuser # (e.g.: dbuser=drupaluser)
  dbpass=dbpass # (e.g.: dbuser=drupaluser)

# Website Files
#  webrootdir=/var/www/html/docroot  # (e.g.: webrootdir=/home/user/public_html)
  webrootdir=/project/folder/public_html # (e.g.: webrootdir=/home/user/public_html)

# Default TAR Output File Base Name
  tarnamebase=backup_knowledgehub.
  datestamp=`date +'%Y-%m-%d'`

# Execution directory (script start point)
  startdir=`pwd`

# Temporary Directory
  tempdir=tmpbckdir$datestamp

#
# Input Parameter Check
#

if test "$1" = ""
  then
    tarname=$tarnamebase$datestamp.tgz
  else
    tarname=$1
fi


#
# Banner
#
echo ""
echo "backup.sh V1.0"

#
# Create temporary working directory
#
echo " .. Setup"
mkdir $tempdir
echo " .. done"

#
# TAR website files
#
echo " .. TARing website files in $webrootdir"
cd $webrootdir
tar cf $startdir/$tempdir/filecontent.tgz .
echo " .. done"

#
# sqldump database information
#
echo " .. sqldump'ing database:"
echo "    user: $dbuser; database: $dbname; host: $dbhost"
cd $startdir/$tempdir
mysqldump -u $dbuser -p "$dbpass" --add-drop-table knowledgehub > db.sql
echo " .. done"

#
# Create final backup file
#
echo " .. Creating final compressed (tgz) TAR file: $tarname"
tar czf $startdir/$tarname filecontent.tgz db.sql
echo " .. done"

#
# Cleanup
#
echo " .. Clean-up"
cd $startdir
rm -r $tempdir
echo " .. done"


#
# Exit banner
#
echo " .. Full site backup complete"
echo ""