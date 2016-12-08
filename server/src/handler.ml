open Lwt.Infix

let err fmt = Printf.kprintf (fun f -> raise (Failure f)) fmt

let domain_of_string x =
  let uri = Uri.of_string x in
  let scheme = match Uri.scheme uri with
    | Some "http"  -> `Http
    | Some "https" -> `Https
    | _ ->
      err "%s: wrong scheme for redirect. Should be either http:// or https://." x
  in
  let host = match Uri.host uri with
    | Some x -> x
    | None   -> err "%s: missing hostname for redirect." x
  in
  scheme, host

module Make
    (S: Cohttp_lwt.Server)
    (FS: V1_LWT.KV_RO) (TMPL: V1_LWT.KV_RO)
    (Clock: V1.CLOCK)
= struct

  let log_src = Logs.Src.create "dispatch" ~doc:"Web server"
  module Log = (val Logs.src_log log_src : Logs.LOG)

  let respond_ok ?(headers=[]) body =
    body >>= fun body ->
    let status = `OK in
    let headers = Cohttp.Header.of_list headers in
    S.respond_string ~headers ~status ~body ()

  let create () =
    let hdr = "HTTP" in
    let callback (_, conn_id) request _body =
      let uri = Cohttp.Request.uri request in
      let headers = Cohttp.Request.headers request in
      let httpMethod = Cohttp.Request.meth request in
      respond_ok ( Dispatcher.dispatch request )
      (*respond_ok ( Lwt.return ( "hello world " ^ ( Uri.to_string uri ) ^ ( Cohttp.Code.string_of_method httpMethod ) ) ) *)
    in
    let conn_closed (_,conn_id) =
      let cid = Cohttp.Connection.to_string conn_id in
      Log.debug (fun f -> f "[%s %s] OK, closing" hdr cid)
    in
    S.make ~callback ~conn_closed ()

  let start http fs tmpl () =
    http ( `TCP ( 8080 ) ) (create () )
end
