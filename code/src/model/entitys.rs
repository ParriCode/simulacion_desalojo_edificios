///La única entidad del modelo , las entidades son objetos dinámicos
/// en la simulación que se mueven por el sistema y actúan con los recursos
/// y con otras entidades
///
#[derive(Debug, Clone, Copy, PartialEq)]
enum PersonState {
    Waiting,
    Evacuating,
    Evacuated,
}

struct Person {
    id: u32,
    pos: (f32, f32, u32), //> x , y , piso
    state: PersonState,   //> Esperando , evacuando y evacuado
    speed: f32,
    exit_time: f32,
}
