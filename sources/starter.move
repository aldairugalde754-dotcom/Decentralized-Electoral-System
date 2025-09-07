module starter::biblioteca {
    use std::string::{String};
    use sui::vec_map::{VecMap, Self};

    #[error]
    const ID_YA_EXISTE: vector<u8> = b"El ID que se intento insertar ya existe.";
    #[error]
    const ID_NO_EXISTE: vector<u8> = b"El ID del libro no existe.";

    public struct Biblioteca has key {
        id: UID,
        nombre: String,
        libros: VecMap<u64, Libro>,
    }
    
    public struct Libro has store, drop {
        titulo: String,
        autor: String,
        publicacion: u16,
        disponible: bool,
    }

    public fun crear_biblioteca(nombre: String, ctx: &mut TxContext) {
        let biblioteca = Biblioteca {
            id: object::new(ctx),
            nombre,
            libros: vec_map::empty(),
        };

        transfer::transfer(biblioteca, tx_context::sender(ctx));
    }

    public fun agregar_libro(biblioteca: &mut Biblioteca, id: u64, titulo: String, autor: String, publicacion: u16) {
        assert!(!biblioteca.libros.contains(&id), ID_YA_EXISTE);

        let libro = Libro { titulo, autor, publicacion, disponible: true };
        biblioteca.libros.insert(id, libro);
    }

    public fun eliminar_libro(biblioteca: &mut Biblioteca, id: u64) {
        assert!(biblioteca.libros.contains(&id), ID_NO_EXISTE);
        biblioteca.libros.remove(&id);
    }

    public fun actualizar_disponibilidad(biblioteca: &mut Biblioteca, id: u64) {
        assert!(biblioteca.libros.contains(&id), ID_NO_EXISTE);
        let libro = biblioteca.libros.get_mut(&id);
        libro.disponible = !libro.disponible;
    }

    public fun eliminar_biblioteca(biblioteca: Biblioteca) {
        let Biblioteca { id, libros: _, nombre: _ } = biblioteca;
        id.delete();
    }
}