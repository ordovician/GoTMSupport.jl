#!/usr/bin/env julia
# This is the code which be used as the implementation for the TextMate
# bundle command. You create a new command in the bundle and paste this code in.
# The code can be tested without using TextMate by using the mock.sh
# shell script which mock the environment variables and external executables
# used in this file.
# PList, SimpleParser julie modules must be installed however. And the
# gocode executable

using PList
import GoTMSupport

bundle_support = ENV["TM_BUNDLE_SUPPORT"]
dialog = ENV["DIALOG"]
gocode = ENV["TM_GOCODE"]
filepath = ENV["TM_FILEPATH"]
row = int(ENV["TM_LINE_NUMBER"])
col = int(ENV["TM_LINE_INDEX"]) + 1

function register_icons()
    icons = icon_plist()
    run(`$dialog images --register $icons`)    
end

function icon_plist()
    writeplist_string(map({"const", "func", "package", "type", "var"}) do v
        {v => string(bundle_support, "/icons/$v.png")}
    end)
end
    
suggestions = GoTMSupport.completion_choices_plist(filepath, row, col, gocode)

register_icons()

# suggestions = "( { display = law; }, { display = laws; } )"
print(readall(`$dialog popup --suggestions $suggestions`))