let handle_empty () =
  Lwt.return ( (Yojson.Basic.pretty_to_string ( `Assoc [] ) ) )
(* add uri path matcher in here and new controller ml file *)
let dispatch req =
  let uri = Cohttp.Request.uri req in
  let httpMethod = Cohttp.Request.meth req in
  match Uri.path uri with
  | "/foo-counter" -> Counter.CounterController.handle_resource req httpMethod
  | "/bar-counter" -> Counter.CounterController.handle_resource req httpMethod
  | _ -> handle_empty ()
