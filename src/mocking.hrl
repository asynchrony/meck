-import(mocking, [stub/4, stub_sequence/4, fake/4, should_never_call/1]).

-define(MOCK_FIXTURE_NAME, mock_fixture_test_).

% add eunit test fixture to module which runs all other functions as tests
% wrapped with meck unload
-define(MOCK_FIXTURE(Setup, Teardown),
    ?MOCK_FIXTURE_NAME() ->
        {foreach,
            fun() -> Setup() end,
            fun(X) -> Teardown(X), meck:unload() end,
            [
                {?MODULE, F} || {F, _A} <- ?MODULE:module_info(exports),
                                F =/= ?MOCK_FIXTURE_NAME
                        andalso F =/= test
                        andalso F =/= module_info
                        andalso F =/= Setup
                        andalso F =/= Teardown
            ]
        }
).

-define(MOCK_FIXTURE, ?MOCK_FIXTURE(fun() -> noop end, fun(_) -> noop end)).
