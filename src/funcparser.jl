using SimpleParser

# Parses Go function arguments, and make a TextMate code snipped for setting each argument
# So snippet_from_func_args("(foo int, bacon, bar struct{a int; b string}, egg interface{})")
# Will yield "(${1:foo}, ${2:bacon}, ${3:bar}, ${4:egg})"
function snippet_from_func_args(arg_str::String)
    lexer = Lexer(arg_str)
    parser = Parser(lexer)
    parse_symboltype(parser)
end

function emit_arg(number::Int, name::String)
    "\${$number:$name}"
end

function emit_func_snippet(args::Vector{String})
    "(" * join([emit_arg(i, args[i]) for i in 1:length(args)], ", ") * ")\$0"    
end

# Could be func(arg1 type1, arg2 type) ReturnType, or SymbolType
# TODO: this function has mixed up responsibilities since it both parses and emits
function parse_symboltype(parser::Parser)
    result = "\$0"
    if parser.look_ahead.lexeme == "func"
        match(parser, STRING)  # func
        result = emit_func_snippet(parse_arguments(parser))
        match(parser, STRING) # return type
    else
        match(parser, STRING) # symbol type
    end
    result
end

# Parse a list of Go arguments on the form (arg1 type1, arg2 type2)
function parse_arguments(parser::Parser)
    args = String[] :: Vector{String}
    match(parser, '(')
    if look_ahead_type(parser) == ')'
        match(parser, ')')
        return args
    end

    while !(look_ahead_type(parser) in [EOF, RPAREN])
        push!(args, parse_arg(parser))
    end
    match(parser, RPAREN) # same as ')'
    args
end

# Parse a single Go function argument. It will also match any delimeter following
# the argument itself such as , or )
function parse_arg(parser::Parser)
    arg_name = parser.look_ahead.lexeme
    
    match(parser, STRING)
    if look_ahead_type(parser) == ','
        match(parser, ',')
    elseif look_ahead_type(parser) == ')'
        return arg_name # Don't want to match it because we need it to terminate loop
    else
        parse_type(parser)
        if look_ahead_type(parser) == ','
            match(parser, ',')
        elseif look_ahead_type(parser) == ')'
            return arg_name # Don't want to match it because we need it to terminate loop
        else
            error("Expect token , or ) after argument type")
        end
    end
    
    arg_name
end

# Parse a Go type. That could be a string like Int64, String or a compound
# type like struct{a int; b int;}. The type is ignored. We don't need the result.
# This function is limited in that it can no deal with nested compound types
function parse_type(parser::Parser)
    keyword = parser.look_ahead.lexeme
    if keyword in ["struct", "interface"]
        match(parser, STRING)
        match(parser, '{')
        t = look_ahead_type(parser)
        while t != '}'
            next_token(parser)
            t = look_ahead_type(parser)
            if t == EOF
                error("No matching } for {")
            end
        end
        match(parser, '}')
    else
        match(parser, STRING)
    end
    nothing
end
