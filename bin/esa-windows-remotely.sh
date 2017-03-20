#!/bin/sh
ssh -fNL 33389:sciops-ts2.net4.lan:3389 esac-hop
rdesktop -5 -K -r clipboard:CLIPBOARD localhost:33389 -g 1200x800 &
