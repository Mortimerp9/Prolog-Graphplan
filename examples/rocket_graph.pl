%    This file is part of the Prolog Graplan project.
%
%    The Prolog Graplan project is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    The Prolog Graplan project is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with the Prolog Graplan project.  If not, see <http://www.gnu.org/licenses/>.

% (C) 2011 Pierre Andrews 

rocket(rocket1).
place(london).
place(paris).
cargo(a).
cargo(b).
cargo(c).
cargo(d).

%move(Rocket, From, To).
can(move(Rocket,From,To),[at(Rocket,From), has_fuel(Rocket)], rocket) :- %vehicle move only within city
	rocket(Rocket),
	place(From),
	place(To),
	From \= To.

adds(move(Rocket,_From,To),[at(Rocket, To)], at(Rocket,To), rocket):-
	rocket(Rocket),
	place(To).

deletes(move(Rocket,From,_To),[at(Rocket,From), has_fuel(Rocket)], rocket):-
	rocket(Rocket),
	place(From).


%unload(Rocket, Place, Cargo).
can(unload(Rocket, Place, Cargo),[at(Rocket,Place),in(Cargo,Rocket)], rocket) :-
	rocket(Rocket),
	cargo(Cargo),
	place(Place).

adds(unload(Rocket, Place, Cargo),[at(Cargo,Place)], _, rocket) :-
	rocket(Rocket),
	cargo(Cargo),
	place(Place).

deletes(unload(Rocket, _Place, Cargo),[in(Cargo,Rocket)], rocket) :-
	rocket(Rocket),
	cargo(Cargo).



%load(Rocket, Place, Cargo).
can(load(Rocket, Place, Cargo),[at(Rocket,Place),at(Cargo,Place)], rocket) :-
	rocket(Rocket),
	cargo(Cargo),
	place(Place).

adds(load(Rocket, _Place, Cargo),[in(Cargo,Rocket)], _, rocket) :-
	rocket(Rocket),
	cargo(Cargo).

deletes(load(Rocket, Place, Cargo),[at(Cargo,Place)], rocket) :-
	rocket(Rocket),
	cargo(Cargo),
	place(Place).


test(P) :-
	plan([at(a, london), at(rocket1, london), has_fuel(rocket1)],
	     [at(a, paris)], rocket,
	     P).
test2(P) :-
	plan([at(a, london), at(b,london), at(rocket1, london), has_fuel(rocket1)],
	     [at(a, paris), at(b,paris)], rocket,
	     P).
test3(P) :-
	plan([at(a, london), at(b,london), at(c,london), at(rocket1, london), has_fuel(rocket1)],
	     [at(a, paris), at(b,paris), at(c,paris)], rocket,
	     P).
