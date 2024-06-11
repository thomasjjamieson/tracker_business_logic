-module(db_api).
-export([put_package/3, get_package/2, deliver_package/2, get_status/2, put_location/4, get_location/2]).


put_package(Package_ID, Location_ID, Pid) ->
	Request=riakc_obj:new(<<"packages">>, Package_ID, Location_ID),
	riakc_pb_socket:put(Pid, Request).

get_package(Package_ID, Pid) ->
	{ok, FetchedObject} = riak:get(Pid, <<"packages">>, Package_ID),
	riak_object:get_key(FetchedObject).


%% db functions for package_deliver
deliver_package(Package_ID,Pid) ->
	Package = riakc_obj:new(<<"deliveries">>, Package_ID),
	riakc_pb_socket:put(Pid, Package).

get_status(Package_ID, Pid) ->
	{ok, FetchedObject} = riak:get(Pid, <<"packages">>, Package_ID),
	%% Extract the value from the object
	riak_object:get_key(FetchedObject).


%% db functions for location_update
put_location(Location_ID, Latitude, Longitude, Pid) ->
    Location = riakc_obj:new(<<"locations">>, Location_ID, {Latitude, Longitude}),
    riak:put(Pid, Location).


%% db functions for location_request
get_location(Location_ID, Pid) ->
	{ok, FetchedObject} = riak:get(Pid, <<"locations">>, Location_ID),
	riak_object:get_key(FetchedObject).