%% Copyright (C) 2019 Conrad Steenberg <conrad.steenberg@gmail.com>
%%
%% This program is free software: you can redistribute it and/or modify
%% it under the terms of the GNU Affero General Public License as
%% published by the Free Software Foundation, either version 3 of the
%% License, or (at your option) any later version.
%%
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU Affero General Public License for more details.
%%
%% You should have received a copy of the GNU Affero General Public License
%% along with this program.  If not, see <http://www.gnu.org/licenses/>.%%

-module(scuttleberl_db).
-export([init/0]).
-include("ssb.hrl").

init() ->
    Nodes = [node()],
    ok = mnesia:start(),
    ok = case mnesia:create_schema(Nodes) of
        {error, {_, {already_exists, _}}} ->
            create_tables(Nodes);
        {error, _Err} ->
            error;
        ok ->
            create_tables(Nodes)
    end.

create_tables(Nodes) ->
    ok = create_tables(Nodes,
                  [{ssb_identity, record_info(fields, ssb_identity), [#ssb_identity.text]},
                   {ssb_invite, record_info(fields, ssb_invite), [#ssb_invite.text]}],
                  ok),
    mnesia:wait_for_tables([ssb_identity, ssb_invite], 5000).

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
