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

-export([create_identity/1]).

create_identity(tpe) when is_atom(tpe) ->
    #{ public := PublicKey, secret := PrivKeyOut } = enacl:crypto_sign_ed25519_keypair(),

    #ssb_identity{
       tpe = tpe,
       secret_key = PrivKeyOut,
       public_key = PublicKey,
       text       = binary:list_to_bin(iolist:format("@~s.~s",[base64:encode(PublicKey), tpe]))
      }.
