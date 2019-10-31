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

-module(identity_utils_tests).
-include_lib("eunit/include/eunit.hrl").
-include("ssb.hrl").

create_identity_test() ->
    #ssb_identity{} = identity_utils:create(ed25519, pub).

create_invite_test() ->
  Id = identity_utils:create(ed25519, pub),
  #ssb_invite{} = identity_utils:invite(Id, 1).

key_text_test() ->
  Id = identity_utils:create(ed25519, client),
  is_binary(identity_utils:key_text(Id#ssb_identity.secret_key, ed25519)).
