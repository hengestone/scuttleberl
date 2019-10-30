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

-module(identity_utils).
-include("ssb.hrl").

-export([create/2, store/1, invite/2, key_text/2]).

-spec create(atom(), atom()) -> #ssb_identity{}.
create(Type = ed25519, Purpose) ->
    #{ public := PublicKey, secret := PrivKeyOut } = enacl:crypto_sign_ed25519_keypair(),

    #ssb_identity{
       tpe        = Type,
       purpose    = Purpose,
       secret_key = PrivKeyOut,
       public_key = PublicKey,
       text       = key_text(PublicKey, Type)
      }.

-spec store(#ssb_identity{}) -> {ok, atomic} | {error, any()}.
store(#ssb_identity{secret_key=SK} = Id) when is_binary(SK) ->
    {atomic, ok} = mnesia:transaction(fun () ->
                                              mnesia:write(ssb_identity, Id, write)
                                      end),
    {ok, atomic};
store(#ssb_invite{secret_key=SK} = Invite) when is_binary(SK) ->
    {atomic, ok} = mnesia:transaction(fun () ->
                                              mnesia:write(ssb_invite, Invite, write)
                                      end),
    {ok, atomic}.

-spec invite(#ssb_identity{}, integer()) -> #ssb_invite{}.
invite(#ssb_identity{secret_key=_SK, public_key=_PK} = PubId, MaxUse) when is_integer(MaxUse) andalso MaxUse > 0 ->
    InviteId = create(PubId#ssb_identity.tpe, invite),
    #ssb_invite{
       pub_text   = PubId#ssb_identity.text,
       public_key = InviteId#ssb_identity.public_key,
       secret_key = InviteId#ssb_identity.secret_key,
       text       = key_text(InviteId#ssb_identity.secret_key, PubId#ssb_identity.tpe),
       max_uses   = MaxUse,
       num_uses   = 0
      }.

key_text(Key, Type) ->
  binary:list_to_bin(io_lib:format("@~s.~s",[base64:encode(Key), Type])).
