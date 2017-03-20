#!/bin/bash
find $1 -exec grep -H $2 {} \;
