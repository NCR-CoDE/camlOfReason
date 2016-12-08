open Mirage

let get ~default name =
  try String.lowercase @@ Sys.getenv name
  with Not_found -> default

let image = get "XENIMG" ~default:"www"

let http_port =
  let doc = Key.Arg.info
      ~doc:"Port to listen on for plain HTTP connections"
      ~docv:"PORT" ["http-port"]
  in
  Key.(create "http-port" Arg.(opt ~stage:`Both int 8080 doc))

let stack = generic_stackv4 default_console tap0

let keys = Key.([ abstract http_port ])
let http =
  foreign ~keys "Handler.Make"
    (http @-> kv_ro @-> kv_ro @-> clock @-> job)

let dispatch =
    (** Without tls *)
    (http $ http_server (conduit_direct stack))

let libraries = [ "rrd" ]
let packages  = [ "xapi-rrd" ]

let fs_key = Key.(value @@ kv_ro ())
let filesfs = generic_kv_ro ~key:fs_key "../files"
let tmplfs = generic_kv_ro ~key:fs_key "../tmpl"

let () =
  let tracing = None in
  (* let tracing = mprof_trace ~size:10000 () in *)
  register ?tracing ~libraries ~packages image [  dispatch $ filesfs $ tmplfs $ default_clock ]
(*  register ?tracing ~libraries ~packages image [  dispatch $ filesfs $ tmplfs $ default_clock  ] *)
