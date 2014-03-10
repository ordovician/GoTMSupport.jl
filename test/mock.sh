#!/bin/sh
# This scripts pretends to be TextMate by setting up the environment
# variables TextMate would usually setup before calling a command script

export TM_BUNDLE_SUPPORT=support # Could be anything
export DIALOG=echo               # Just so we see arguments passed
export TM_GOCODE=$GOPATH/bin/gocode

# We pretend that TextMate has the source code file example.go open and
# the cursor at line 37 and column 7 (must write 6 since first index zero)
export TM_FILEPATH=example.go
export TM_LINE_NUMBER=37
export TM_LINE_INDEX=6

julia ../src/bundlecode.jl