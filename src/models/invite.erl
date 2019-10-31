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

-module(invite).
-include("ssb.hrl").
-export([create/2, store/1]).

-spec create(#ssb_identity{}, integer()) -> #ssb_invite{}.
create(#ssb_identity{secret_key=_SK, public_key=_PK} = PubId, MaxUse) when is_integer(MaxUse) andalso MaxUse > 0 ->
    InviteId = identity:create(PubId#ssb_identity.tpe, invite),
    #ssb_invite{
       pub_text   = PubId#ssb_identity.text,
       public_key = InviteId#ssb_identity.public_key,
       secret_key = InviteId#ssb_identity.secret_key,
       text       = identity:key_text(InviteId#ssb_identity.secret_key, PubId#ssb_identity.tpe),
       max_uses   = MaxUse,
       num_uses   = 0
      }.

-spec store(#ssb_invite{}) -> {ok, atomic} | {error, any()}.
store(#ssb_invite{secret_key=SK} = Invite) when is_binary(SK) ->
    {atomic, ok} = mnesia:transaction(fun () ->
                                              mnesia:write(ssb_invite, Invite, write)
                                      end),
    {ok, atomic}.
