?- safe([3,3,left]).
% should succeed

?- safe([1,2,left]).
% should fail

?- move([3,3,left], S2, A).
% should generate only safe legal successors

?- solve_bfs(P).
% should return shortest solution ending in [0,0,right]

?- solve_dfs(P).
% should return a valid solution ending in [0,0,right]

?- run(bfs).
?- run(dfs).
