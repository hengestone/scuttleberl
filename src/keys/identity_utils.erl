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

-export([create_identity/1, store_identity/1]).

-spec create_identity(atom()) -> #ssb_identity{}.
create_identity(Type = ed25519) ->
    #{ public := PublicKey, secret := PrivKeyOut } = enacl:crypto_sign_ed25519_keypair(),

    #ssb_identity{
       tpe = Type,
       secret_key = PrivKeyOut,
       public_key = PublicKey,
       text       = binary:list_to_bin(io_lib:format("@~s.~s",[base64:encode(PublicKey), Type]))
      }.

store_identity(#ssb_identity{secret_key=SK} = Id) when is_binary(SK) ->
  mnesia:transaction(fun () ->
    mnesia:write(ssb_identity, Id, write)
  end).
