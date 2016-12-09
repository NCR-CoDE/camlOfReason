module CounterController = Controller.Make ( struct
    let handle_get req =
      "hello resource using get"

    let handle_post req =
      "hello resource using post"

    let handle_put req =
      "hello resource using put"

    let handle_delete req =
      "hello resource using delete"
  end
  )
