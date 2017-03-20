#!/bin/bash

# Rsync files from gr-tr.com
rsync -arzv --delete grtr@gr-tr.com:/home/grtr/public_html/ /backups/gr-tr/public_html
rsync -arzv --delete grtr@gr-tr.com:/home/grtr/sql_backups/ /backups/gr-tr/sql_backups

# Rsync files from grigora.info
rsync -arzv --delete yiigora@grigora.info:/home/yiigora/public_html/ /backups/grigora.info/public_html
rsync -arzv --delete yiigora@grigora.info:/home/yiigora/sql_backups/ /backups/grigora.info/sql_backups

# Rsync files from oineas.gr
#rsync -arzv --delete oineas@oineas.gr:/home/oineas/public_html/ /backups/oineas/public_html
#rsync -arzv --delete oineas@oineas.gr:/home/oineas/sql_backups/ /backups/oineas/sql_backups

# Rsync files from hatzimichalis.gr
#rsync -arzv --delete xatzimix@hatzimichalis.gr:/home/xatzimix/public_html/ /backups/xatzimix/public_html
#rsync -arzv --delete xatzimix@hatzimichalis.gr:/home/xatzimix/sql_backups/ /backups/xatzimix/sql_backups

