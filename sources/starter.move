module starter::votacion {

    use std::string::String;
    use sui::vec_map::{Self, VecMap};
 
    // Declaracion de las Notitifcaciones de error
    #[error]
    const NO_AUTORIZADO: vector<u8> = b"No tienes permisos para realizar esta acción";
    #[error]
    const PROPUESTA_YA_FINALIZADA: vector<u8> = b"La propuesta ha finalizado";
    #[error]
    const VOTO_YA_EMITIDO: vector<u8> = b"Este votante ya ha emitido un voto";
    #[error]
    const NO_ES_VOTANTE: vector<u8> = b"No estás autorizado para votar en esta propuesta";
    #[error]
    const BOLETA_INVALIDA: vector<u8> = b"La boleta no corresponde a esta propuesta";
    #[error]
    const OPCION_NO_EXISTE: vector<u8> = b"La opción seleccionada no existe";

   
    // Estructuras del proyecto

    public struct Opcion has copy, drop, store {
    id: u64,
    descripcion: String,      
    }

    public struct Propuesta has key {
        id: object::UID,
        propietario: address,
        pregunta: String,
        opciones: vector<Opcion>,
        votos_por_opcion: VecMap<u64, u64>,
        votantes: VecMap<address, bool>,
        finalizada: bool,
    }

    public struct Boleta has key, store {
        id: object::UID,
        propuesta_id: object::ID,
    }

    public struct Voto has key, store {
        id: object::UID,
        propuesta_id: object::ID,
        votante: address,
        opcion_elegida: u64,
    }


    // Funciones para administrar votaciones

    public fun crear_propuesta(
        pregunta: String,
        opciones: vector<Opcion>,
        ctx: &mut TxContext ) 
    {
        let mut votos_por_opcion = vec_map::empty<u64, u64>();

        let len = vector::length(&opciones);
        let mut i = 0;
        while (i < len) {
            let opcion_ref = vector::borrow(&opciones, i);
            votos_por_opcion.insert(opcion_ref.id, 0);
            i = i + 1;
        };

        let creador = tx_context::sender(ctx);
        let propuesta = Propuesta {
            id: object::new(ctx),
            propietario: creador,
            pregunta,
            opciones,
            votos_por_opcion,
            votantes: vec_map::empty(),
            finalizada: false,
        };
        transfer::transfer(propuesta, creador);
    }

    public fun agregar_votante(propuesta: &mut Propuesta, votante: address, ctx: &mut TxContext) {
        assert!(propuesta.propietario == tx_context::sender(ctx), NO_AUTORIZADO);
        propuesta.votantes.insert(votante, false);
    }

    public fun emitir_boleta(propuesta: &Propuesta, votante: address, ctx: &mut TxContext) {
        assert!(!propuesta.finalizada, PROPUESTA_YA_FINALIZADA);
        assert!(propuesta.votantes.contains(&votante), NO_ES_VOTANTE);

        let boleta = Boleta {
            id: object::new(ctx),
            propuesta_id: object::id(propuesta),  
        };
        transfer::transfer(boleta, votante);
    }

    public fun finalizar_votacion(propuesta: &mut Propuesta, ctx: &mut TxContext) {
        assert!(propuesta.propietario == tx_context::sender(ctx), NO_AUTORIZADO);
        propuesta.finalizada = true;
    }

    public fun obtener_resultados(propuesta: &Propuesta): &VecMap<u64, u64> {
        &propuesta.votos_por_opcion
    }

    public fun crear_propuesta_simple(
    pregunta: String,
    id1: u64,
    desc1: String,
    id2: u64,
    desc2: String,
    ctx: &mut TxContext)
    {
    let opcion1 = Opcion { id: id1, descripcion: desc1 };
    let opcion2 = Opcion { id: id2, descripcion: desc2 };
    let opciones = vector[opcion1, opcion2];

    crear_propuesta(pregunta, opciones, ctx);
}

    public fun eliminar_propuesta(propuesta: Propuesta, ctx: &mut TxContext) {
        assert!(propuesta.propietario == tx_context::sender(ctx), NO_AUTORIZADO);

        let Propuesta {
            id,
            votos_por_opcion,
            votantes,
            ..
        } = propuesta;

        vec_map::destroy_empty(votos_por_opcion);
        vec_map::destroy_empty(votantes);

        id.delete();
    }


    // Funciones para el usuario que emite el voto

    public fun votar(
        propuesta: &mut Propuesta,
        boleta: Boleta,
        opcion_elegida: u64,
        ctx: &mut TxContext
    ): Voto {
        assert!(!propuesta.finalizada, PROPUESTA_YA_FINALIZADA);
        let sender = tx_context::sender(ctx);

        // Validar el voto

        assert!(&object::id(propuesta) == &boleta.propuesta_id, BOLETA_INVALIDA);
        assert!(propuesta.votantes.contains(&sender), NO_ES_VOTANTE);
        assert!(propuesta.votos_por_opcion.contains(&opcion_elegida), OPCION_NO_EXISTE);

        let votado = propuesta.votantes.get(&sender);
        assert!(!*votado, VOTO_YA_EMITIDO);

        // Contar votos
        let current_votes_ref = propuesta.votos_por_opcion.get(&opcion_elegida);
        let current_votes = *current_votes_ref;
        propuesta.votos_por_opcion.insert(opcion_elegida, current_votes + 1);

        // Marcar que ya ha votado
        propuesta.votantes.insert(sender, true);

        // Registrar el voto
        let voto_registro = Voto {
            id: object::new(ctx),
            propuesta_id: object::id(propuesta),
            votante: sender,
            opcion_elegida,
        };

        // Eliminacion de la boleta
        let Boleta { id, .. } = boleta;
        id.delete();

        voto_registro
    }

}
