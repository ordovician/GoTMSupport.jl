using PList

function completion_choices_plist(
    filepath::String, 
    row::Int, 
    col::Int,
    gocode::String)
    
    document = open(readlines, filepath)
    # byte offset of cursor position from the beginning of file
    cursor = sum(map(length, document[1:row - 1])) + col - 1
    (stream, process) = readsfrom(`$gocode -f=csv -in=$filepath autocomplete $cursor`)
    suggestion_table = readcsv(stream)
    no_rows = size(suggestion_table)[1]
    choices = map(make_completion_choices, {suggestion_table[row,:] for row in 1:no_rows})
    writeplist_string(choices)
    # suggestions = writeplist_string({{"display" => row} for row in suggestion_table[:,3]})
end

function make_completion_choices(comp)
    image = comp[1]
    match = comp[3]
    args = comp[end]
    insert = snippet_from_func_args(args)
    display = string(match, image == "func" ? replace(args, "func", "") : " " * args)
    
    { "match" => match, "display" =>  display, "insert" => insert, "image" => image }
end