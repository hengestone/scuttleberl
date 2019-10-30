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
    ok = mnesia:start(),
    ok = initdb(),
    io:format("~w", [result]),
    mnesia:wait_for_tables([ssb_identity], 5000),
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
        {error, {_, {already_exists, _}}} ->
            create_tables(Nodes);
        {error, _Err} ->
            error;
        ok ->
            create_tables(Nodes)
    end.

create_tables(Nodes) ->
    create_tables(Nodes,
                  [{ssb_identity, record_info(fields, ssb_identity), [#ssb_identity.text]},
                   {ssb_invite, record_info(fields, ssb_invite), [#ssb_invite.text]}],
                  ok).

create_tables(Nodes, [TableInfo | TableInfoRest], ok) ->
    create_tables(Nodes, TableInfoRest,
                  create_table(Nodes, TableInfo));
create_tables(_Nodes, [], ok) ->
    ok;
create_tables(_Nodes, _TableInfoList, Result) ->
    Result.

create_table(Nodes, {Table, RecordInfo, Indexes}) ->
    case mnesia:create_table(Table,
                             [{attributes, RecordInfo},
                              {index, Indexes},
                              {disc_copies, Nodes}]) of
        {atomic, ok} -> ok;
        {_, {already_exists, _}} -> ok;
        Error -> Error
    end.
