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

-module(identity_tests).
-include_lib("eunit/include/eunit.hrl").
-include("ssb.hrl").

create_identity_test() ->
    #ssb_identity{} = identity:create(ed25519, pub).

key_text_test() ->
    Id = identity:create(ed25519, client),
    is_binary(identity:key_text(Id#ssb_identity.secret_key, ed25519)).
