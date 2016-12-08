let handle_empty req httpMethod =
  Lwt.return ( "hello using " ^ ( Cohttp.Code.string_of_method httpMethod ) )

let handle_resource req httpMethod =
  let response =
    match httpMethod with
    | `GET -> Resource.handle_get req
    | `POST -> Resource.handle_post req
    | `PUT -> Resource.handle_put req
    | `DELETE -> Resource.handle_delete req
    | _ -> Resource.handle_get req
  in
  Lwt.return ( response )

let dispatch req =
  let uri = Cohttp.Request.uri req in
  let httpMethod = Cohttp.Request.meth req in
  match Uri.path uri with
  | "/resource" -> handle_resource req httpMethod
  | _ -> handle_empty req httpMethod
