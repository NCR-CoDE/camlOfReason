module type CONTROLLER =
sig
  val handle_get : Cohttp.Request.t -> string
  val handle_post : Cohttp.Request.t -> string
  val handle_put : Cohttp.Request.t -> string
  val handle_delete : Cohttp.Request.t -> string
end


module Make
    (C : CONTROLLER) : sig
  val handle_resource : Cohttp.Request.t -> [> `DELETE | `GET | `POST | `PUT ] -> string Lwt.t
end
