module CounterController = Controller.Make ( struct

  let counter = ref ( CounterModel.create () )

  let handle_get req =
    let uri = Cohttp.Request.uri req in
    match Uri.path uri with
    | "/inc" ->
      begin
        counter := CounterModel.increment_counter !counter;
        CounterModel.construct_string_response !counter
      end
    | "/dec" ->
        begin
          counter := CounterModel.add_counter (-1) !counter;
          CounterModel.construct_string_response !counter
        end
    | _ ->
       CounterModel.construct_string_response !counter



  let handle_post req =
    counter := CounterModel.add_counter 4 !counter;
    CounterModel.construct_json_response !counter

  let handle_put req =
    counter := CounterModel.set_counter 4 !counter;
    CounterModel.construct_json_response !counter

  let handle_delete req =
    counter := CounterModel.set_counter 0 !counter;
    CounterModel.construct_json_response !counter

end
)
