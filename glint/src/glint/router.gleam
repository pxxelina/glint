import gleam/dynamic/decode
import gleam/erlang/process
import gleam/http.{Delete, Get, Post}
import gleam/int
import gleam/json
import gleam/otp/actor
import gleam/string_tree
import glint/store.{type Message}
import glint/task.{type Task}
import simplifile
import wisp.{type Request, type Response}

fn task_to_json(t: Task) -> json.Json {
  json.object([
    #("id", json.int(t.id)),
    #("title", json.string(t.title)),
    #("done", json.bool(t.done)),
  ])
}

fn title_decoder() -> decode.Decoder(String) {
  decode.at(["title"], decode.string)
}

fn to_json_string(j: json.Json) -> String {
  j |> json.to_string_tree |> string_tree.to_string
}

pub fn handle_request(req: Request, store: process.Subject(Message)) -> Response {
  let path = wisp.path_segments(req)
  case req.method, path {
    Get, [] -> {
      case simplifile.read("priv/static/index.html") {
        Ok(content) -> wisp.html_response(content, 200)
        Error(_) -> wisp.not_found()
      }
    }
    Get, ["tasks"] -> {
      let tasks = actor.call(store, waiting: 1000, sending: store.GetAll)
      json.array(tasks, task_to_json)
      |> to_json_string
      |> wisp.json_response(200)
    }
    Post, ["tasks"] -> {
      use json_body <- wisp.require_json(req)
      case decode.run(json_body, title_decoder()) {
        Ok(title) -> {
          let task =
            actor.call(store, waiting: 1000, sending: store.Create(title, _))
          task_to_json(task)
          |> to_json_string
          |> wisp.json_response(201)
        }
        Error(_) -> wisp.unprocessable_content()
      }
    }
    Get, ["tasks", id_str] -> {
      case int.parse(id_str) {
        Ok(id) -> {
          case actor.call(store, waiting: 1000, sending: store.GetOne(id, _)) {
            Ok(task) ->
              task_to_json(task)
              |> to_json_string
              |> wisp.json_response(200)
            Error(_) -> wisp.not_found()
          }
        }
        Error(_) -> wisp.bad_request("invalid id")
      }
    }
    Delete, ["tasks", id_str] -> {
      case int.parse(id_str) {
        Ok(id) -> {
          case actor.call(store, waiting: 1000, sending: store.Delete(id, _)) {
            Ok(_) -> wisp.response(204)
            Error(_) -> wisp.not_found()
          }
        }
        Error(_) -> wisp.bad_request("invalid id")
      }
    }
    _, _ -> wisp.not_found()
  }
}
