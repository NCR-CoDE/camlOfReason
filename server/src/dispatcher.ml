

let handle_empty req httpMethod =
  Lwt.return ( "hello using " ^ ( Cohttp.Code.string_of_method httpMethod ) )

let dispatch req =
  let uri = Cohttp.Request.uri req in
  let httpMethod = Cohttp.Request.meth req in
  match Uri.path uri with
  | "/foo-counter" -> Counter.CounterController.handle_resource req httpMethod
  | "/bar-counter" -> Counter.CounterController.handle_resource req httpMethod
  | _ -> handle_empty req httpMethod
