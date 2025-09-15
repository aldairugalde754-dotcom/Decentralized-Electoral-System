# 🚀 Sistema de Votación en Blockchain -- SUI

Sui es una plataforma de blockchain y contratos inteligentes de capa 1 diseñada para que la propiedad de activos digitales sea rápida, privada, segura y accesible.

Move es un lenguaje de código abierto para escribir programas seguros que manipulan objetos en la blockchain. Permite bibliotecas, herramientas y comunidades de desarrolladores comunes en blockchains con modelos de datos y ejecución muy diferentes.

---

## Proyecto

Este repositorio es un proyecto para manejar votaciones utilizando la blockchain de SUI. Permite crear propuestas con múltiples opciones, agregar votantes, emitir boletas y registrar votos de manera segura y transparente. Cada propuesta es controlada por su propietario, y cada votante recibe una boleta única para garantizar la integridad de la votación.

---

## Comenzando con Codespaces

### 1. Clona el Repositorio  
Copia este repositorio a tu cuenta de GitHub haciendo clic en el botón **Fork**. Puedes renombrar el repositorio según tu proyecto.

![Fork](./imagenes/fork.png)

### 2. Abre en Codespaces  
Presiona el botón `<> Code` y navega a la pestaña **Codespaces**.

![Codespaces](./imagenes/codespaces.png)

### 3. Crea el Codespace  
Haz clic en **Create codespace on master**. Esto abrirá un entorno de Visual Studio Code directamente en tu navegador, con todas las herramientas necesarias ya instaladas.

---

### 🧪 Ejecutando el Proyecto

Para asegurarte de que todo está configurado correctamente, puedes ejecutar las pruebas unitarias incluidas.


### Contenido

Este proyecto instala las siguientes herramientas:
* [SuiUp](https://github.com/Mystenlabs/suiup/) (Administrador de versiones).
* [Sui CLI](https://docs.sui.io/references/cli/client) (Instalada usando SuiUp).
* Extensión de VS Code [Move](https://marketplace.visualstudio.com/items?itemName=mysten.move).
* Extensión de VS Code [Move Formatter](https://marketplace.visualstudio.com/items?itemName=mysten.prettier-move).

Todas las herramientas fueron desarrolladas por [MystenLabs](https://www.mystenlabs.com/).

## Ejecutando el proyecto

Ingresa a tu terminal y ejecuta el siguiente comando:

```sh
sui move test
```

Deberías de obtener el siguiente resultado:
```sh
INCLUDING DEPENDENCY Bridge
INCLUDING DEPENDENCY SuiSystem
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING Intro
Running Move unit tests
[debug] "Hello, World!"
[ PASS    ] introduccion::practica_sui::prueba
Test result: OK. Total tests: 1; passed: 1; failed: 0
```

¡Felicidades! :partying_face: Acabas de ejecutar de manera exitosa tu primer módulo Move. Ahora, analicemos que está pasando.

En la carpeta `sources` podemos encontrar un archivo llamado `starter.move`. Este archivo, como lo indica la extensión, contiene el código de Move que estamos ejecutando. En este caso, es un **módulo** con una **función** y un **test**.

## Estructura de un módulo

La estructura de un **módulo** es la siguiente:

```rust
module direccion::nombre_modulo {
    // ...  resto del código
}
```

1. Declaración del módulo con la palabra clave `module`.
2. Dirección en la que se desplegará el módulo.
    La dirección la encontramos en el archivo de configuraciones `Move.toml`, en el apartado de `addresses`. En nuestro caso:
    ```toml
    [addresses]
    starter = "0x0"
    ```
3. Nombre del módulo, en nuestro caso: `practica_sui`

Por lo que nuestro código luce así:
```rust
module introduccion::practica_sui {
    // ...  resto del código
}
```

Después, vienen los `imports` o los módulos/librerías que estamos importando para que el nuestro funcione. En nuestro código, estamos importando dos funciones de la librería principal de **Move**:

```rust
    use std::debug::print;
    use std::string::utf8;
```

Se importa la función para imprimir en consola, así como una función para convertir cadenas de texto a un formato aceptado por la función anterior.

La siguiente sección de código incluye nuestra primera función:

```rust
    fun practica() {
        print(&utf8(b"Hello, World!"));
    }
```

En ella, hacemos uso de ambas librerías importadas. La función simplemente imprime la cadena `Hello, World!` en la consola.

Y por último, necesitamos una forma de ejecutar esta función. Por ahora lo estamos haciendo a través de un **bloque de pruebas** o `test`:

```rust
    #[test]
    fun prueba() {
        practica();
    }
```

Al nosotros haber ejecutado `sui move test` le estamos diciendo a la CLI que ejecute todas las funciones que tengan un bloque `[#test]`, en este caso, ejecuta nuestra función `prueba`, la cual a su vez llama a la función `practica`.

## Output

Por último, analicemos el resultado que se imprimió en la consola.

```sh
INCLUDING DEPENDENCY Bridge
INCLUDING DEPENDENCY SuiSystem
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING Intro
Running Move unit tests
[debug] "Hello, World!"
[ PASS    ] introduccion::practica_sui::prueba
Test result: OK. Total tests: 1; passed: 1; failed: 0
```

El primer bloque de texto nos indica que está incluyendo las dependencias necesarias para ejecutar el proyecto:

```sh
INCLUDING DEPENDENCY Bridge
INCLUDING DEPENDENCY SuiSystem
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING Intro
```

Estas dependencias son las dependencias básicas que todo paquete en **Move** necesita, así que el compilador las importa de manera automática.
Puedes comprobar que no estamos importando ninguna dependencia en el archivo `Move.toml` en el apartado `[dependencies]`.

La siguiente línea en el output nos indica que se ejecutaran las pruebas unitarias en el archivo, recuerda que esto es porque corrimos el comando `sui move test`:
```
Running Move unit tests
```

Después, obtenemos el mensaje que ejecuta la función prueba, en nuestro caso, la línea de texto `Hello, World!`:
```sh
[debug] "Hello, World!"
```

Ahora, en la siguiente línea, podemos obtener información de exactamente que funciones se ejecutaron:
```sh
[ PASS    ] starter::practica_sui::prueba
```
La estructura es algo así:
```rust
direccion::nombre_modulo::funcion
```
Con esto, podemos comprobar que la función que se ejecutó fue `prueba`.

Por último, obtenemos información sobre las pruebas unitarias, cómo cuantas se ejecutaron y cuantas se pasaron:

```sh
Test result: OK. Total tests: 1; passed: 1; failed: 0
```
