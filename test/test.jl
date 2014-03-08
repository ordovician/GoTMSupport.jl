#!/usr/bin/env julia
using GoTMSupport
using Base.Test

gopath = ENV["GOPATH"]

if isempty(gopath)
    error("You must set the GOPATH environment variable for this test to work")
end

choices_plist = completion_choices_plist("example.go", 37, 7, gopath * "/bin/gocode")
print(choices_plist)

# If the test works you should see something like this:
# 
# ({display = "Add(u Vector2D) Vector2D";match = Add;insert = "(${1:u})$0";image = func;}, {display = "Dot(u Vector2D) float64";match = Dot;insert = "(${1:u})$0";image = func;}, {display = "Normal() Vector2D";match = Normal;insert = "()$0";image = func;}, {display = "X float64";match = X;insert = "$0";image = var;}, {display = "Y float64";match = Y;insert = "$0";image = var;})