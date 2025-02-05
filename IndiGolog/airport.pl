/* 
        IndiGolog - Airport Operations 

    1. simple_scheduling(1): 
    The simple controller tries to schedule the landings without considering planes dimensions

    2. smart_scheduling(2):
    The smart controller uses the planes dimensions to schedule the landing and departurting processes

    3. exo_scheduling(3):
    It uses exogenous actions for emergency landing

*/

:- use_module(library(random)).
:- dynamic controller/1.

:- discontiguous 
    fun_fluent/1,
    rel_fluent/1,
    proc/2,
    causes_true/3,
    causes_true/2,
    causes_true/1,
    causes_false/3,
    causes_false/2,
    causes_false/1,
    random/1,
    random_between/3.

cache(_) :- fail.

/* FLUENTS */
rel_fluent(waitingToLand(Plane)).
rel_fluent(passengersLoaded(Plane)).
rel_fluent(hasPassengersLoaded(Plane)).
rel_fluent(hasPassengersUnloaded(Plane)).
rel_fluent(planeTakeonOff(Plane)).

rel_fluent(gateAvailable(G)) :-gtn(G).
gate_number(4).
gtn(G) :- gate_number(N), between(1,N,G).

rel_fluent(runwayAvailable(R)):- rnn(R).
run_number(3).
rnn(R) :- run_number(M), between(1,M,R).

fun_fluent(gate(Plane)).
fun_fluent(runway(Plane)).
fun_fluent(dim(Plane)).

max_dim(3).
dime(D) :- max_dim(O), between(1,O,D).

/* ACTIONS */
prim_action(land(Plane, _)).
poss(land(Plane, R), and(or(waitingToLand(Plane),requestToLand(Plane)), and(runwayAvailable(R), passengersLoaded(Plane)))).

prim_action(taxiToGate(Plane,R,G)). 
poss(taxiToGate(Plane, R, G), and(passengersLoaded(Plane),and((R is runway(Plane)), gateAvailable(G)))).

prim_action(taxiToRunway(Plane,G,R)).
poss(taxiToRunway(Plane,G,R), and(hasPassengersLoaded(Plane),and((G is gate(Plane)),runwayAvailable(R)))).

prim_action(takeoff(Plane,R)).
poss(takeoff(Plane, R), and((R is runway(Plane)), hasPassengersLoaded(Plane))).

prim_action(unload(Plane, G)).
poss(unload(Plane,G), and((G is gate(Plane)), passengersLoaded(Plane))).

prim_action(load(Plane, G)).
poss(load(Plane,G), and((G is gate(Plane)), hasPassengersUnloaded(Plane))).

/* CAUSAL LAWS */
causes_val(land(Plane,R), runway(Plane), R, true).
causes_false(land(Plane, _), waitingToLand(Plane), true).
causes_false(land(Plane, _), requestToLand(Plane), true).
causes_false(land(_, R), runwayAvailable(R), true).

causes_val(taxiToGate(Plane,_,G), gate(Plane), G, true).
causes_val(taxiToGate(Plane,_,_), runway(Plane), 0, true).
causes_true(taxiToGate(_, R, _), runwayAvailable(R), true).
causes_false(taxiToGate(_, _, G), gateAvailable(G), true).

causes_val(taxiToRunway(Plane,_,R), runway(Plane), R, true).
causes_val(taxiToRunway(Plane,_,_), gate(Plane), 0, true).
causes_true(taxiToRunway(_,G,_), gateAvailable(G), true).
causes_false(taxiToRunway(_,_,R), runwayAvailable(R), true).

causes_val(takeoff(Plane,_), runway(Plane), 0, true).
causes_true(takeoff(_, R), runwayAvailable(R), true).
causes_true(takeoff(Plane, _), planeTakeonOff(Plane), true).
causes_false(takeoff(Plane, _), hasPassengersLoaded(Plane), true).

causes_true(unload(Plane, _), hasPassengersUnloaded(Plane),true).
causes_false(unload(Plane, _), passengersLoaded(Plane),true).
causes_false(unload(Plane, _), hasPassengersLoaded(Plane),true).

causes_true(load(Plane, _), hasPassengersLoaded(Plane), true).

/* EXOGENOUS */
rel_fluent(emergency(Plane)).
rel_fluent(requestToLand(Plane)).
rel_fluent(new_land).

exog_action(eml(Plane)).
causes_true(eml(Plane), emergency(Plane), true).
causes_true(eml(Plane),new_land,neg(waitingToLand(Plane))).

exog_action(arrive(Plane)).
causes_val(arrive(Plane), dim(Plane), D, true) :- dime(D), random(1,3,D).
causes_true(arrive(Plane), requestToLand(Plane),true).
causes_true(arrive(Plane), passengersLoaded(Plane),true).
causes_true(arrive(Plane),new_land,neg(waitingToLand(Plane))).

prim_action(emergencyLand(Plane, _)).
poss(emergencyLand(Plane, R), and(emergency(Plane), runwayAvailable(R))).
causes_val(emergencyLand(Plane,R), runway(Plane), R, true).
causes_false(emergencyLand(Plane, _), emergency(Plane), true).
causes_false(emergencyLand(_, R), runwayAvailable(R), true).

/* INITIAL SITUATION */
initially(waitingToLand(p1), true).
initially(waitingToLand(p2), true).
initially(waitingToLand(p3), true).
initially(waitingToLand(p4), true).
initially(waitingToLand(p5), true).
initially(passengersLoaded(p1), true).
initially(passengersLoaded(p2), true).
initially(passengersLoaded(p3), true).
initially(passengersLoaded(p4), true).
initially(passengersLoaded(p5), true).
initially(gateAvailable(G), true) :- gtn(G),member(G,[1,2,3,4]).
initially(runwayAvailable(R), true) :- rnn(R),member(R,[1,2,3]).
initially(dim(p1), 2).
initially(dim(p2), 1).
initially(dim(p3), 3).
initially(dim(p4), 2).
initially(dim(p5), 1).
initially(new_land, false).

/* PROCEDURES */
proc(some_waiting, some(p, waitingToLand(p))).
proc(some_em, some(p, emergency(p))).
proc(some_arrive, some(p, requestToLand(p))).

proc(go_to_gate(P,R,G), [land(P,R),taxiToGate(P,R,G)]).

proc(handle_passengers(P,G), [unload(P,G), load(P,G)]).

proc(departure(P,G,R), [taxiToRunway(P,G,R), takeoff(P,R)]).

proc(handle_departure_simple, pi([p,g,r],[go_to_gate(p,r,g), handle_passengers(p,g), departure(p,g,r)])).

proc(handle_departure_smart, pi(p, [ ?(or(waitingToLand(p), requestToLand(p))),
                
    pi(r, [if(and(rnn(r), runwayAvailable(r)),land(p,r),[]),
        
        pi(g, if(and(gtn(g), and(dim(p)<g, gateAvailable(g))),[taxiToGate(p,r,g),handle_passengers(p,g),
            
                pi(r1, if(and(rnn(r1), runwayAvailable(r1)),departure(p,g,r1),[])) 
            
            ],[])
        )
    ])  
    ])
).

proc(handle_emergency, pi(p, [ ?(emergency(p)),
        pi(r, [if(and(rnn(r),(runwayAvailable(r))),emergencyLand(p,r),[])]
)])).


/* CONTROLLERS */
proc(control(simple_scheduling), while(some_waiting, handle_departure_simple)).
proc(control(smart_scheduling), while(some_waiting , handle_departure_smart)).
proc(control(exo_scheduling), 
            [prioritized_interrupts([              
                interrupt(some_em, [unset(new_land), gexec(neg(new_land), handle_emergency)]),
                interrupt(some_waiting, handle_departure_smart),
                interrupt(some_arrive, [unset(new_land), gexec(neg(new_land), handle_departure_smart)]),
                interrupt(true, ?(wait_exog_action))                 
            ])]
).


actionNum(X,X).