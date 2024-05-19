%Graph
bridge(a,b).%1 bridge
bridge(b,a).%1 bridge

bridge(b,c).%2 bridge
bridge(c,b).%2 bridge

bridge(a,c).%3 bridge
bridge(c,a).%3 bridge 


% Delete edge from graph
remove_bridge(X, Y, [bridge(X, Y)|T], T).
remove_bridge(X, Y, [H|T], [H|NT]) :- remove_bridge(X, Y, T, NT).

% Find euler way
euler_path(X, X, _, [X]).
euler_path(X, Y, E, [X|T]) :- remove_bridge(X, Z, E, NE), euler_path(Z, Y, NE, T).

% Start Euler Way
start_euler :-
    findall(bridge(A, B), bridge(A, B), Bridges),
    findall(X, member(bridge(X, _), Bridges), Vertices),
    sort(Vertices, SortedVertices),
    findall(Degree-X, (member(X, SortedVertices), findall(_, bridge(X, _), DegreeList), length(DegreeList, Degree)), Degrees),
    include(odd_degree, Degrees, OddDegrees),
    (length(OddDegrees, 2) -> OddDegrees = [_-Start, _-End], findall(P, euler_path(Start, End, Bridges, P), Paths),nl,write("Start point: "), write(Start),nl,write("End point: "), write(End), nl, longest(Paths, Path), write('Path: '), write(Path) ;
     length(OddDegrees, 0) -> member(_-Start, Degrees), findall(P, euler_path(Start, Start, Bridges, P), Paths), longest(Paths, Path), write("Start point: "), write(Start),nl,write("End point: "), write(Start), nl, longest(Paths, Path), write('Path: '), write(Path) ).


%Odd value
odd_degree(Degree-_) :- 1 is Degree mod 2.

% Longest Way
longest([P], P).
longest([P|Ps], Longest) :-
    longest(Ps, Longest1),
    (length(P, N), length(Longest1, N1), N > N1 -> Longest = P ; Longest = Longest1).
