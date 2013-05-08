let login = "bartholomew"
let password = ""
let host = "163.5.255.5"
let port = 4242

let _ =
    let module Netsoul = Netsoul.Netsoul in
    Netsoul.client host port login password
