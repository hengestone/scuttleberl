%%%-------------------------------------------------------------------
%% @doc nova_admin public API
%% @end
%%%-------------------------------------------------------------------

-module(scuttleberl_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, initdb/0]).
-include("ssb.hrl").

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    logger:set_primary_config(level, debug),
    ok = initdb(),
    mnesia:wait_for_tables([ssb_identity_private,
                            ssb_identity], 5000),
    ok = mnesia:start(),
    nova_sup:start_link(),
    scuttleberl_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
initdb() ->
    Nodes = [node()],
    case mnesia:create_schema(Nodes) of
        {error,{_,{already_exists, _}}} ->
            io:format("already exists"),
            ok;
        {error, Err} ->
          io:format("error: ~s", [Err]),
            error;
        ok ->
          create_tables(Nodes)
    end.

create_tables(Nodes) ->
  {atomic, ok} = mnesia:create_table(ssb_identity,
                        [{attributes, record_info(fields, ssb_identity)},
                         {index, [#ssb_identity.text]},
                         {disc_copies, Nodes}]),
  ok.
