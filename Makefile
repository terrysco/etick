compile:
	rebar compile skip_deps=true

all:
	rebar get-deps compile
	dialyzer -r ebin

shell:
	erl -pa ./ebin  ../deps/*/ebin

