use super::entitys::Person;
use super::resources::Door;
use serde::Serialize;
use serde_toml;
use std::arch::x86_64::_MM_ROUND_MASK;
use std::collections::{HashMap, HashSet, VecDeque};
use std::fs;
use std::io::Error;
use strum::EnumCount;

#[derive(EnumCount)]
enum ConnectionTypes {
    Door = 1,
    EmergencyDoor = 2,
    Stairs = 3,
}

//un edificio es un conjunto de pisos
struct Building {
    graph: Vec<Vec<u32>>, //> Cada nodo representa una habitación , los pesos representan (id conexion )
    rooms: Vec<VecDeque<u32>>,
    connections: Vec<VecDeque<u32>>,
    persons: HashMap<u32, Person>,
}

impl Building {
    pub fn new(graph: Vec<Vec<u32>>) -> Result<Self, String> {
        //Validar la matriz de adyacencia del grafo
        Self::validar_edificio(&graph)?;

        Ok(Self {
            graph: (graph),
            rooms: Vec::<VecDeque<u32>>::new(),
            connections: Vec::<VecDeque<u32>>::new(),
            persons: HashMap::<u32, Person>::new(),
        })
        //Test de grafo conexo
        //
    }
    ///BFS para comprobar el grafo
    fn validar_edificio(graph: &[Vec<u32>]) -> Result<(), String> {
        let tam_vec = graph.len();
        if tam_vec == 0 {
            return Err("El grafo tiene longitud 0 de matriz".to_string());
        }

        let mut visited = vec![false; tam_vec]; // Nodos visitados Y DENTRO DE LAS CLAVES DEL HASHMAP
        let mut queue = VecDeque::new();

        for r in graph {
            if tam_vec != r.len() {
                return Err("La matriz del grafo de adyacencia no es cuadrada".to_string());
            }
        }

        queue.push_back(0);
        visited[0] = true;

        while let Some(node) = queue.pop_front() {
            for i in 0..tam_vec {
                let door_id = graph[node][i];

                if door_id == 0 {
                    // No tiene conexión , continuar con el grafo
                    continue;
                }

                if door_id > ConnectionTypes::COUNT as u32 {
                    return Err(format!("Tipo de conexión {} no válido", door_id));
                }
                if !visited[i] {
                    visited[i] = true;
                    queue.push_back(i);
                }
            }
        }

        if visited.iter().all(|&v| v) {
            Ok(())
        } else {
            Err("El grafo no es conexo".to_string())
        }
    }

    fn load_persons(&mut self, num: u32) {
        let mut rng = rand::rng();
        for id in 0..num {
            let room_id = rng.random_range(0..self.rooms.len());
            self.rooms[room_id].push_back(id);
        }
    }
}
