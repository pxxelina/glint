import gleam/erlang/process.{type Subject}
import gleam/list
import gleam/otp/actor
import glint/task.{type Task, Task}

pub type Message {
  GetAll(reply_with: Subject(List(Task)))
  GetOne(id: Int, reply_with: Subject(Result(Task, Nil)))
  Create(title: String, reply_with: Subject(Task))
  Delete(id: Int, reply_with: Subject(Result(Nil, Nil)))
}

type State {
  State(tasks: List(Task), next_id: Int)
}

fn handle(state: State, message: Message) -> actor.Next(State, Message) {
  case message {
    GetAll(client) -> {
      process.send(client, state.tasks)
      actor.continue(state)
    }
    GetOne(id, client) -> {
      let found = list.find(state.tasks, fn(t) { t.id == id })
      process.send(client, found)
      actor.continue(state)
    }
    Create(title, client) -> {
      let task = Task(id: state.next_id, title: title, done: False)
      process.send(client, task)
      actor.continue(State(
        tasks: [task, ..state.tasks],
        next_id: state.next_id + 1,
      ))
    }
    Delete(id, client) -> {
      let exists = list.any(state.tasks, fn(t) { t.id == id })
      case exists {
        True -> {
          let updated = list.filter(state.tasks, fn(t) { t.id != id })
          process.send(client, Ok(Nil))
          actor.continue(State(..state, tasks: updated))
        }
        False -> {
          process.send(client, Error(Nil))
          actor.continue(state)
        }
      }
    }
  }
}

pub fn start() -> Subject(Message) {
  let assert Ok(started) =
    actor.new(State(tasks: [], next_id: 1))
    |> actor.on_message(handle)
    |> actor.start()
  started.data
}
