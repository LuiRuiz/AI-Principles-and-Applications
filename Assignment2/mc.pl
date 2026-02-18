%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Missionaries and Cannibals
% State format: [ML, CL, Side]
% ML = missionaries on left (0–3)
% CL = cannibals on left (0–3)
% Side = left or right (boat location)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial and Goal States
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

start([3,3,left]).
goal([0,0,right]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAFE STATE DEFINITION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

safe([ML,CL,_]) :-
    ML >= 0, ML =< 3,
    CL >= 0, CL =< 3,
    MR is 3 - ML,
    CR is 3 - CL,

    % Left bank safe
    (ML =:= 0 ; ML >= CL),

    % Right bank safe
    (MR =:= 0 ; MR >= CR).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOVE DEFINITIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Boat passenger combinations
boat(2,0).
boat(0,2).
boat(1,0).
boat(0,1).
boat(1,1).

% Move from LEFT to RIGHT
move([ML,CL,left], [ML2,CL2,right], boat(M,C)) :-
    boat(M,C),
    ML >= M,
    CL >= C,
    ML2 is ML - M,
    CL2 is CL - C,
    safe([ML2,CL2,right]).

% Move from RIGHT to LEFT
move([ML,CL,right], [ML2,CL2,left], boat(M,C)) :-
    boat(M,C),
    MR is 3 - ML,
    CR is 3 - CL,
    MR >= M,
    CR >= C,
    ML2 is ML + M,
    CL2 is CL + C,
    safe([ML2,CL2,left]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DFS WITH CYCLE CHECKING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve_dfs(Path) :-
    start(Start),
    dfs(Start, [Start], RevPath),
    reverse(RevPath, Path).

dfs(State, Visited, Visited) :-
    goal(State).

dfs(State, Visited, Path) :-
    move(State, Next, _),
    \+ member(Next, Visited),
    dfs(Next, [Next|Visited], Path).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BFS FOR SHORTEST PATH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve_bfs(Path) :-
    start(Start),
    bfs([[Start]], Solution),
    reverse(Solution, Path).

bfs([[State|Rest]|_], [State|Rest]) :-
    goal(State).

bfs([Path|Paths], Solution) :-
    extend(Path, NewPaths),
    append(Paths, NewPaths, UpdatedQueue),
    bfs(UpdatedQueue, Solution).

extend([State|Rest], NewPaths) :-
    findall([Next,State|Rest],
        (move(State, Next, _),
         \+ member(Next, [State|Rest])),
        NewPaths).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RUN PREDICATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run(dfs) :-
    solve_dfs(Path),
    print_path(Path),
    length(Path, L),
    Crossings is L - 1,
    write('Number of crossings: '), write(Crossings), nl.

run(bfs) :-
    solve_bfs(Path),
    print_path(Path),
    length(Path, L),
    Crossings is L - 1,
    write('Number of crossings: '), write(Crossings), nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRINTING UTILITIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

print_path([]).
print_path([State|Rest]) :-
    write(State), nl,
    print_path(Rest).
