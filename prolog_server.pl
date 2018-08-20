%===============================================================
% Project:  PENG Engine
% Module:   prolog_server.pl
% Author:   Rolf Schwitter
% Created:  2013-03-13
% Modified: 2017-03-30
% Status:   Work in Progress !!!
%===============================================================

% --------------------------------------------------------------
% Style checking
% --------------------------------------------------------------

:- no_style_check(singleton).
:- no_style_check(discontiguous).


%---------------------------------------------------------------
% Modules
%---------------------------------------------------------------

:- use_module(library('http/thread_httpd')).
:- use_module(library('http/http_dispatch')).
:- use_module(library('http/http_client')).
:- use_module(library('http/json')).
:- use_module(library('http/http_json')).
:- use_module(library('http/http_log')).
:- use_module(library('http/http_parameters')).
:- ensure_loaded('main').


%---------------------------------------------------------------
% set_setting/2
%
%   - set http logfile
%---------------------------------------------------------------

:- set_setting(http:logfile, 'log.txt').


%---------------------------------------------------------------
% server/1
%    - defines an http server at a specific port
%---------------------------------------------------------------

server(Port) :-
  http_server(http_dispatch, [port(Port)]).


%---------------------------------------------------------------
% http_handler/3
%
%   - General HTTP handler
%---------------------------------------------------------------

:- http_handler('/peng/', handle, []).

%---------------------------------------------------------------
% http_handler/3
%
%   - CSS handler
%---------------------------------------------------------------

:- http_handler('/css/styles.css', css_styles, []).

:- http_handler('/css/mic-styles.css', css_mic_styles, []).

:- http_handler('/superfish-master/dist/css/superfish.css', css_superfish, []).

:- http_handler('/css/bootstrap.css', css_bootstrap, []).

:- http_handler('/css/bootstrap-switch.min.css', css_bootstrap_switch, []).

%---------------------------------------------------------------
% http_handler/3
%
%   - JavaScript handler
%---------------------------------------------------------------

:- http_handler('/superfish-master/dist/js/hoverIntent.js', js_hover, []).

:- http_handler('/superfish-master/dist/js/superfish.js', js_superfish, []).

:- http_handler('/javascript/superfish_modules.js', js_superfish_mod, []).

:- http_handler('/javascript/LookaheadObject.js', js_lookahead, []).

:- http_handler('/javascript/ViewModel.js', js_view_model, []).

:- http_handler('/javascript/TextArea.js', js_text_area, []).

:- http_handler('/javascript/SuccessHelper.js', js_success_helper, []).

:- http_handler('/javascript/ClickHelper.js', js_click_helper, []).

:- http_handler('/javascript/web_google_speech_mic.js', js_google_speech, []).

:- http_handler('/javascript/FeatureStructure.js', js_feature_struct, []).

:- http_handler('/js_library/knockout-min.js', js_knockout, []).

:- http_handler('/js_library/jquery-ui.js', js_jquery_ui, []).

:- http_handler('/js_library/jquery.min.js', js_jquery, []).

:- http_handler('/js_library/bootstrap.min.js', js_bootstrap, []).

:- http_handler('/javascript/Autocomplete.js', js_autocomplete, []).

:- http_handler('/javascript/KeyEventHelper.js', js_key_helper, []).

:- http_handler('/js_library/bootstrap-switch.min.js', js_bootstrap_switch, []).

%---------------------------------------------------------------
% http_handler/3
%
%   - Image handler
%---------------------------------------------------------------

%----FOR IMAGES

:- http_handler('/html/mic-animate.gif', mic_animate, []).

:- http_handler('/html/mic-slash.gif', mic_slash, []).

:- http_handler('/html/mic.gif', mic, []).


%---------------------------------------------------------------
% HTTP Reply
%---------------------------------------------------------------


handle(Request) :-
   (
      member(method(post), Request), !,
      http_parameters(Request, [id(Id, []),
				inputmode(InputMode, []),
                                editmode(Mode, []),
                                token(Token, []),
				nbest(NBest, []),
                                featurestructure(FS, []),
                                filename(FName, []),
                                spectext(Text, []),
                                snum(SNum, []),
                                spos(SPos, []),
                                reasoner(Flag, []),
                                reasonermode(RMode, [])
                                ]),
     %  write(user, 'Token: '), writeq(user, Token), nl(user), nl(user),
      JSTN = json([id=Id,
		   inputmode=InputMode,
                   editmode=Mode,
                   token=Token,
		   nbest=NBest,
                   featurestructure=FS,
                   filename=FName,
                   spectext=Text,
                   snum=SNum,
                   spos=SPos,
                   reasoner=Flag,
                   reasonermode=RMode]),
      helper(JSTN),
      main_process(JSTN, JSON),         % defined in main.pl
      reply_json(JSON)
      %% write(user, 'Output: '), write(user, JSON), nl(user), nl(user)
   ;
      http_reply_file('html/index.html', [mime_type('text/html')], Request)
   ).



helper(JSTN) :-
      (
        atom_json_term(Atom, JSTN, [as(string)]),
        write(user, 'Input: '), write(user, Atom), nl(user), nl(user)
      ;
        true
      ).

%---------------------------------------------------------------
% Static images
%---------------------------------------------------------------

%---Dont need, just for reference for template

mic_animate(Request):-
	http_reply_file('html/mic-animate.gif', [mime_type('image/gif')], Request).

mic_slash(Request):-
	http_reply_file('html/mic-slash.gif', [mime_type('image/gif')], Request).

mic(Request):-
	http_reply_file('html/mic.gif', [mime_type('image/gif')], Request).

%---------------------------------------------------------------
% CSS closure
%---------------------------------------------------------------

css_styles(Request) :-
  http_reply_file('css/styles.css', [mime_type('text/css')], Request).

css_mic_styles(Request) :-
  http_reply_file('css/mic-styles.css', [mime_type('text/css')], Request).

css_superfish(Request) :-
  http_reply_file('superfish-master/dist/css/superfish.css', [mime_type('text/css')], Request).

css_bootstrap(Request) :-
  http_reply_file('css/bootstrap.css', [mime_type('text/css')], Request).

css_bootstrap_switch(Request) :-
  http_reply_file('css/bootstrap-switch.min.css', [mime_type('text/css')], Request).

%---------------------------------------------------------------
% JavaScript closure
%---------------------------------------------------------------

js_hover(Request) :-
  http_reply_file('superfish-master/dist/js/hoverIntent.js', [mime_type('text/javascript')], Request).

js_superfish(Request) :-
  http_reply_file('superfish-master/dist/js/superfish.js', [mime_type('text/javascript')], Request).

js_superfish_mod(Request) :-
  http_reply_file('javascript/superfish_modules.js', [mime_type('text/javascript')], Request).

js_lookahead(Request) :-
  http_reply_file('javascript/LookaheadObject.js', [mime_type('text/javascript')], Request).

js_view_model(Request) :-
  http_reply_file('javascript/ViewModel.js', [mime_type('text/javascript')], Request).

js_text_area(Request) :-
  http_reply_file('javascript/TextArea.js', [mime_type('text/javascript')], Request).

js_success_helper(Request) :-
  http_reply_file('javascript/SuccessHelper.js', [mime_type('text/javascript')], Request).

js_click_helper(Request) :-
  http_reply_file('javascript/ClickHelper.js', [mime_type('text/javascript')], Request).

js_google_speech(Request) :-
  http_reply_file('javascript/web_google_speech_mic.js', [mime_type('text/javascript')], Request).

js_feature_struct(Request) :-
  http_reply_file('javascript/FeatureStructure.js', [mime_type('text/javascript')], Request).

js_knockout(Request) :-
  http_reply_file('js_library/knockout-min.js', [mime_type('text/javascript')], Request).

js_jquery_ui(Request) :-
  http_reply_file('js_library/jquery-ui.js', [mime_type('text/javascript')], Request).

js_jquery(Request) :-
  http_reply_file('js_library/jquery.min.js', [mime_type('text/javascript')], Request).

js_bootstrap(Request) :-
  http_reply_file('js_library/bootstrap.min.js', [mime_type('text/javascript')], Request).

js_autocomplete(Request) :-
  http_reply_file('javascript/Autocomplete.js', [mime_type('text/javascript')], Request).

js_key_helper(Request) :-
  http_reply_file('javascript/KeyEventHelper.js', [mime_type('text/javascript')], Request).

js_bootstrap_switch(Request) :-
  http_reply_file('js_library/bootstrap-switch.min.js', [mime_type('text/javascript')], Request).

% ---------------------------------------------------------------
% Starts the server on port 8085
% You can connect to the server via http://localhost:8085/peng/
% ---------------------------------------------------------------

:- server(8085),
   nl, nl,
   write('*** Prolog Server is listening on port: 8085  ***'), nl,
   write('*** Connect via: http://localhost:8085/peng/  ***'),
   nl, nl.
