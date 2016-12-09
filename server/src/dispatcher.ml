let handle_empty () =
  Lwt.return ( (Yojson.Basic.pretty_to_string ( `Assoc [] ) ) )
(* add uri path matcher in here and new controller ml file *)
let dispatch req =
  let uri = Cohttp.Request.uri req in
  let httpMethod = Cohttp.Request.meth req in
  match Uri.path uri with
  | "/inc" -> Counter.CounterController.handle_request req httpMethod
  | "/dec" -> Counter.CounterController.handle_request req httpMethod
  | _ -> handle_empty ()
