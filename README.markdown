The Prolog GraphPlan Project
============================

The [Graphplan algorithm](http://en.wikipedia.org/wiki/Graphplan) is an [automatic planning](http://en.wikipedia.org/wiki/Automated_planning) algorithm that can compute, given a set of rules, a plan of action to go from an initial state to a final state.

The algorithm was described by Blum and Furst in 1997 and published in:

> A. Blum and M. Furst (1997). Fast planning through planning graph analysis. Artificial intelligence. 90:281-300.

This project provides an open source (GPL v3) implementation of this planner in Prolog.

How to use it
-------------

This implementation has been tested with [SWI-Prolog](http://www.swi-prolog.org/) and is quite simple to use.

There is a basic toy example of a planning domain in **examples/rocket_graph.pl**. This example provides the "rocket payload" scenario where a set or rockets can be used to move cargo between places.

First of all we define the "world" facts that can be used by the planner to do the inferences:

    rocket(rocket1).
    place(london).
    place(paris).
    cargo(a).
    cargo(b).
    cargo(c).
    cargo(d).

The example predicates are very simple atomic predicates, but with our implementation, you can use any kind of prolog predicates and perfom inferences in the word definition predicates.

*Note that these "word" predicates do not describe a changeable state but fixed facts that will not be changed during the planning (i.e. in our examples, the initial position of the rocket is not defined with such predicates)*

The planner can be called with the `plan\4` predicate, for instance:
    plan([at(a, london), at(rocket1, london), has_fuel(rocket1)],
    	     [at(a, paris)], rocket,
    	     P).

This predicate takes three arguments:
1. the initial state of the world
2. the final state of the world that should be reached when the plan is completed
3. a "domain" where the plan should take place (more about that later).

And "returns" the plan in `P`.

The plan tries to find a set of actions to change the initial state to reach the final state. Thus you have to define these actions before you can find a plan.

Actions are defined with three predicates:

1. the *preconditions* required to perform an action:
`can(Action, StateDefinition, Domain).`

	* first you define the action name,
	* second you define the required precondition as a set of state predicates,
	* and you provide a domain (more about that later).

2. what the action *adds* to the current state of the world when it's completed:
`adds(Action, ListOfAddedStatePredicates, _, Domain).`

    * first you define the action name,
	* second you define the list of added state predicates,
	* third you ignore this,
	* and you provide a domain.

3. what the action *removes* from the current state of the world when it's completed:
`deletes(Action, ListOfDeletedStatePredicates, Domain).`

    * first you define the action name,
	* second you define the list of removed state predicates,
	* and you provide a domain.

And that's it. It seems complicated, but you can see the definition of the actions in the rocket example and you will see it's not that hard. For instance:

`unload(Rocket, Place, Cargo).` unload a cargo from a rocket:

1. **preconditions:** the cargo must be in the right place

    can(unload(Rocket, Place, Cargo),[at(Rocket,Place),in(Cargo,Rocket)], rocket) :-
    	rocket(Rocket),
    	cargo(Cargo),
    	place(Place).

2. **added state:** the cargo is now in the new place
    adds(unload(Rocket, Place, Cargo),[at(Cargo,Place)], _, rocket) :-
    	rocket(Rocket),
    	cargo(Cargo),
    	place(Place).

3. **removed state:** the cargo is not in the rocket anymore
    deletes(unload(Rocket, _Place, Cargo),[in(Cargo,Rocket)], rocket) :-
    	rocket(Rocket),
    	cargo(Cargo).

When you call the plan predicate, you will get the complete plan (if one is possible). The current implementation also prints out the plan for simple viewing.

    Step 1:
            load(rocket1,london,a)
    
    Step 2:
            move(rocket1,london,paris)
    
    Step 3:
            unload(rocket1,paris,a)
    
    
    P = [[load(rocket1, london, a)], [move(rocket1, london, paris)], [unload(rocket1, paris, a)]] .

*Note that the graphplan algorithm can find actions that can be performed in parallel and thus you can have more than one action per step. Try the `test2(P)` and `test3(P)` predicates from the example to see how it works.*


The Domain
----------

Because  you can load multiple "action" definitions in the same prolog environment, the current implementation protects each action definition within a domain and this is why you have to define in which domain each action is specified and in which domain to search for a plan.

Contributors
============

This implementation is based on the original algorithm described by **Blum and Furst**.

The initial implementation was provided by [**Dr. Suresh Manandhar**](http://www-users.cs.york.ac.uk/~suresh/) from the University of York Computer Science department and slightly modified by [**Dr. Pierre Andrews**](http://disi.unitn.it/~andrews/).

The code is distributed under GPL v3. If you use it, please be sure to provide the right attribution and, if you wish, let us know about it.

You are welcome to contribute patches or improvements to this project. Dr. Manandhar and Andrews are providing the code as is and do not have any plans to provide support (new features, bug corrections) for this project, but I will make sure to push contributed patches to improve the code when I receive them.

If you want to contribute more examples, it would be great too.

Applications
============

Currently, this implementation of the graphplan has successfully been used for:

* Planning Human-Compute Dialogue by P. Andrews.

*if you use this planner for any other application, please let us know.*
