use super::resources::Door;
use std::collections::{HashMap, HashSet};

struct Connection {}

///Las habitaciones son nodos
struct Room {
    id: u32,
    width: f32,
    height: f32,
    connection: Vec<Connection>,
}

//un edificio es un conjunto de pisos
struct Building {
    graph: Vec<Vec<u32>>, //> Cada nodo representa una habitación , los pesos representan una puerta
    rooms: HashMap<u32, Room>,
    doors: HashMap<u32, Door>,
}

impl Building {
    fn new(rooms: Vec<Vec<u32>>) {
        //Test de grafo conexo
    }
}
