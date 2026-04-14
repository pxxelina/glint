import gleam/erlang/process
import glint/router
import glint/store
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()
  let secret = wisp.random_string(64)
  let st = store.start()

  let handler = fn(req) {
    use <- wisp.log_request(req)
    use <- wisp.rescue_crashes
    router.handle_request(req, st)
  }

  let assert Ok(_) =
    wisp_mist.handler(handler, secret)
    |> mist.new()
    |> mist.port(8000)
    |> mist.start()

  process.sleep_forever()
}
