%% -*- coding: utf-8 -*-
%% Automatically generated, do not edit
%% Generated by gpb_compile version 4.7.1

-ifndef(ssb).
-define(ssb, true).

-define(ssb_gpb_version, "4.7.1").

-ifndef('IDENTITY_PB_H').
-define('IDENTITY_PB_H', true).
-record(identity,
        {tpe = ed25519          :: 'ed25519' | 'ed448' | integer() | undefined, % = 1, enum keytype
         secret_key = <<>>      :: iodata() | undefined, % = 2
         public_key = <<>>      :: iodata() | undefined, % = 3
         text = <<>>            :: iodata() | undefined % = 4
        }).
-endif.

-ifndef('ADDRESS_PB_H').
-define('ADDRESS_PB_H', true).
-record(address,
        {host = <<>>            :: iodata() | undefined, % = 1
         port = 0               :: integer() | undefined, % = 2, 32 bits
         key = undefined        :: ssb:identity() | undefined % = 3
        }).
-endif.

-ifndef('CONTENT_PB_H').
-define('CONTENT_PB_H', true).
-record(content,
        {tpe = pub              :: 'pub' | 'invite' | integer() | undefined, % = 1, enum msgtype
         address = undefined    :: ssb:address() | undefined % = 2
        }).
-endif.

-ifndef('MSG_PB_H').
-define('MSG_PB_H', true).
-record(msg,
        {author = undefined     :: ssb:identity() | undefined, % = 1
         content = undefined    :: ssb:content() | undefined % = 2
        }).
-endif.

-ifndef('INVITE_PB_H').
-define('INVITE_PB_H', true).
-record(invite,
        {keys = undefined       :: ssb:identity() | undefined % = 1
        }).
-endif.

-endif.
