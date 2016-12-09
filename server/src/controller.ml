module type CONTROLLER =
sig
  val handle_get : Cohttp.Request.t -> string
  val handle_post : Cohttp.Request.t -> string
  val handle_put : Cohttp.Request.t -> string
  val handle_delete : Cohttp.Request.t -> string
end

module Make
    (C: CONTROLLER)
= struct
  let handle_resource req httpMethod =
    let response =
      match httpMethod with
      | `GET -> C.handle_get req
      | `POST -> C.handle_post req
      | `PUT -> C.handle_put req
      | `DELETE -> C.handle_delete req
      | _ -> C.handle_get req
    in
    Lwt.return ( response )
end
