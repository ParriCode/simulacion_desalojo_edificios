/// Recursos del sistema
pub struct Path {}
pub struct Stairs {
    capacity: u32,
}
pub struct Door {
    capacity: u32,
}

impl Door {
    fn new(capacity: u32) -> Self {
        Self { capacity }
    }
}
