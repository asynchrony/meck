-module(mocking).
-compile([export_all]).

stub(M, F, A, R) ->
    stub(M),
    meck:expect(M, F, A, R).

stub_sequence(M, F, A, Rs) ->
    stub(M),
    meck:sequence(M, F, A, Rs).

fake(M, F, A, R) ->
    fake(M),
    meck:expect(M, F, A, R).

should_never_call(Module) ->
    meck:new(Module, [no_link]).

% ---- INTERNALS ----

stub(M) ->
    mock(M, stub_options).

fake(M) ->
    mock(M, fake_options).

mock(M, MeckOptionsFun) ->
    case module_already_mocked(M) of
        false -> meck:new(M, ?MODULE:MeckOptionsFun(M));
        true -> noop
    end.

module_already_mocked(Module) ->
    case erlang:whereis(meck_process_name(Module)) of
        undefined -> false;
        _ -> true
    end.

meck_process_name(Module) ->
    list_to_atom(atom_to_list(Module) ++ "_meck").

stub_options(M) ->
    {module, M} = code:ensure_loaded(M),

    case code:is_sticky(M) of
        true ->
            [no_link, unstick];
        false ->
            [no_link]
    end.

fake_options(M) ->
    false = code:is_loaded(M),

    [no_link].
