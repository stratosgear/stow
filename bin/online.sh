#!/bin/bash

wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ $? -eq 0 ]]; then
        echo ""
else
        echo ""
  	     exit 1
fi
