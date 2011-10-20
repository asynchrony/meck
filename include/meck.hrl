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
