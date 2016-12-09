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


      let err fmt = Printf.kprintf (fun f -> raise (Failure f)) fmt

      let err_not_found name = err "%s not found" name

      let read_fs fs name =
        FS.size fs name >>= function
        | `Error (FS.Unknown_key _) -> err_not_found name
        | `Ok size ->
          FS.read fs name 0 (Int64.to_int size) >>= function
          | `Error (FS.Unknown_key _) -> err_not_found name
          | `Ok bufs -> Lwt.return (Cstruct.copyv bufs)

      let asset fs path =
        let path_s = String.concat "/" path in
        read_fs fs path_s

  (* hard setting content type to json below*)
  let create fs =
    let hdr = "HTTP" in
    let callback (_, conn_id) request _body =
      let cid = Cohttp.Connection.to_string conn_id in
      Log.debug (fun f -> f "[%s %s] OK, closing" hdr cid);

      let uri = Cohttp.Request.uri request in
      match Uri.path uri with
      | "/inc" -> respond_ok ~headers:[("Content-Type", "application-json")] ( Dispatcher.dispatch request )
      | "/dec" -> respond_ok ~headers:[("Content-Type", "application-json")] ( Dispatcher.dispatch request )
      | _ as path -> respond_ok (asset fs [path])

      (*respond_ok ( Lwt.return ( "hello world " ^ ( Uri.to_string uri ) ^ ( Cohttp.Code.string_of_method httpMethod ) ) ) *)
    in
    let conn_closed (_,conn_id) =
      let cid = Cohttp.Connection.to_string conn_id in
      Log.debug (fun f -> f "[%s %s] OK, closing" hdr cid)
    in
    S.make ~callback ~conn_closed ()

  let start http fs tmpl () =
    http ( `TCP ( 8080 ) ) (create fs )
end
