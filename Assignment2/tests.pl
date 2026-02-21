%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PATH VALIDITY CHECKER
% Validity checker in the test file to ensure that bfs and dfs are returning a valid path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

valid_path([_]).
valid_path([S1,S2|Rest]) :-
    move(S1,S2,_),
    valid_path([S2|Rest]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RUN ALL REQUIRED TESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run_tests :-

    writeln('=============================='),
    writeln('1. safe([3,3,left]) should succeed'),
    (safe([3,3,left]) ->
        writeln('PASSED')
    ;
        writeln('FAILED')
    ),

    writeln('------------------------------'),
    writeln('2. safe([1,2,left]) should fail'),
    (safe([1,2,left]) ->
        writeln('FAILED')
    ;
        writeln('PASSED')
    ),

    writeln('------------------------------'),
    writeln('3. move([3,3,left], S2, A)'),
    findall((S2,A), move([3,3,left], S2, A), Moves),
    writeln('Legal successors:'),
    writeln(Moves),

    writeln('------------------------------'),
    writeln('4. solve_bfs(P) ends in [0,0,right]'),
    solve_bfs(Pbfs),
    last(Pbfs, LastBFS),
    writeln(Pbfs),
    (LastBFS = [0,0,right] ->
        writeln('BFS goal test PASSED')
    ;
        writeln('BFS goal test FAILED')
    ),

    writeln('------------------------------'),
    writeln('5. solve_dfs(P) ends in [0,0,right]'),
    solve_dfs(Pdfs),
    last(Pdfs, LastDFS),
    writeln(Pdfs),
    (LastDFS = [0,0,right] ->
        writeln('DFS goal test PASSED')
    ;
        writeln('DFS goal test FAILED')
    ),

    writeln('------------------------------'),
    writeln('6. Compare BFS and DFS path lengths'),
    length(Pbfs, LB),
    length(Pdfs, LD),
    CrossB is LB - 1,
    CrossD is LD - 1,
    write('BFS crossings: '), writeln(CrossB),
    write('DFS crossings: '), writeln(CrossD),

    writeln('------------------------------'),
    writeln('7. Path validity check'),
    (valid_path(Pbfs) ->
        writeln('BFS path valid')
    ;
        writeln('BFS path INVALID')
    ),
    (valid_path(Pdfs) ->
        writeln('DFS path valid')
    ;
        writeln('DFS path INVALID')
    ),

    writeln('==============================').