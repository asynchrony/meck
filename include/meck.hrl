%%==============================================================================
%% Copyright 2011 Adam Lindberg & Erlang Solutions Ltd.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%% http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%==============================================================================

%% @author Matt Campbell <matthew.campbell@asolutions.com>
%% @copyright 2011, Adam Lindberg & Erlang Solutions Ltd
%% @doc Helper macros for eunit testing with Meck


%% @spec assertWasCalled(Mod:: atom(), Func:: atom(), Args:: list(term()))
%% @doc Assert that a given function was called with expected arguments.
%%
%% If the function was called with the specified arguments, this assertion passes.
%%
%% Otherwise, if the function (of the same arity) was called with different arguments,
%% the assertion fails with an error showing the arguments which were used instead.
%%
%% If the function (of the same arity) was never called during the test, the assertion
%% fails with a different error indicating that the function was never invoked.

-define(assertWasCalled(Mod,Func,Args),
    ((fun () ->
        case (meck:called(Mod,Func,Args)) of
            true -> ok;
            false ->
                case (meck:arguments(Mod,Func,length(Args))) of
                    [] ->
                        .erlang:error({assertionFailed_mockFunctionNotCalled,
                            [{module, ?MODULE},
                                {line, ?LINE},
                                {function, {Mod, Func, length(Args)}},
                                {expected_args, Args},
                                {value, not_called}]});
                    ActualArgs ->
                        .erlang:error({assertionFailed_mockFunctionCalledWithWrongArgs,
                            [{module, ?MODULE},
                                {line, ?LINE},
                                {function, {Mod, Func, length(Args)}},
                                {expected_args, Args},
                                {actual_args, ActualArgs}]})
                end
        end
    end)())).
