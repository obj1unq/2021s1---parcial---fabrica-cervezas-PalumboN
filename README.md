# Fábrica de Cervezas

**La moda de las cervezas artesanales sigue estando en auge y en este tiempo que está complicado abrir los locales aumentaron los envíos. Unos productores nos pidieron un sistema que facilite la administración de su negocio.**


## Aclaraciones sobre el parcial
- El parcial es **individual** y se entrega **pusheando a este repositorio** como en las entregas anteriores. Recomendamos _ir pusheando cada cierto tiempo_ para evitar inconvenientes, lo ideal es después de cada punto resuelto.
- No se tendrán en cuenta los commits realizados después de la hora de finalización del examen.
- Una vez hecho el _push_ final, **verifiquen en github.com** que haya quedado la versión final. Nosotros corregiremos lo que está en github, si ustedes lo pueden ver ahí entonces nosotros también.
- No olvidarse de **los conceptos aprendidos**: polimorfismo, delegación, buenas abstracciones, no repetir lógica, guardar vs calcular, lanzar excepción cuando un método no puede cumplir con su responsabilidad, etc. Eso es lo que se está evaluando.
- La solución del examen consiste en la **implementación de un programa** que resuelva los requerimientos pedidos y sus **tests automatizados**.
- Este enunciado es acompañado con un archivo `.wtest` que tiene diseñado los test a realizar. Es importante aclarar que:
  - Estos tests se proponen para facilitar el desarrollo. Se puede diseñar otros si así se considera necesario.
  - El conjunto de tests propuesto es suficiente para este ejercicio. No hace falta agregar nuevos, pero tampoco se prohibe hacerlo.
  - Todos los objetos allí usados se asumen como instancias de una clase. Si el diseño de la solución utiliza objetos bien conocidos en algunos casos entonces se debe remover la declaración de la variable y la línea en que se sugiere la instanciación
  - Según el diseño de la solución, es probable que se requiera agregar más objetos a los sugeridos en los tests
  - Los tests están comentados de manera de poder _ir incorporándolos a medida que se avanza_ con la solución del ejercicio



### Las cervezas
La fábrica trabaja con muchas cervezas diferentes, que se pueden organizar en 3 tipos: Clásica, Lager y Porter, cada una con sus propias características. 

El primer objetivo es calcular los costos de cada lote de cerveza, que se determina por el costo de su ingrediente destacado, el lúpulo, más los costos de elaboración. 

Actualmente la fábrica trabaja con dos variedades de lúpulo: _importado_ y _local_. El costo del lúpulo para un lote de cualquier tipo de cerveza es de $800 para el caso de producción nacional, mientras que el importado es $1000 + un impuesto al lúpulo cobrado por la AFIP, que actualmente es del 20% pero podría variar. Si bien ahora se cuentan con solamente estas dos variedades, es posible que se incorporen nuevas variedades en el futuro debido a las fluctuaciones del mercado. 

Los costos de elaboración son:
- Para cualquier cerveza Clásica, depende del tipo de levadura que se usó en el proceso de elaboración, pudiendo ser de fermentación baja o alta.
- Si la levadura es de fermentación baja el costo de elaboración es de $300 por lote, pero si se usa levadura de fermentación alta, el costo de elaboración es un 10% del costo del lúpulo.

_Ejemplo: El costo total de un lote de una cerveza Clásica con lúpulo local y levadura de fermentación alta es de $880._

- Para las Lager se utilizan aditivos, por lo que su costo de elaboración es de $50 por cada gramo de aditivo utilizado.

_Ejemplo: El costo total de un lote de una cerveza Lager con lúpulo importado y 2 grs de aditivos es de $1300. Pero si se baja el impuesto al lúpulo de la AFIP al 10% queda en $1200._

- Y para una cerveza negra Porter el costo de elaboración es siempre de $450 si la cerveza tiene alto contenido alcohólico, o sea mayor del 8%, o $150 en caso contrario.

_Ejemplo: El costo de producción de un lote de una cerveza Porter con lúpulo importado y 9% de alcohol es de $1650._

**Se pide**
1. Calcular el costo total de cualquier lote de cerveza. 
2. Hacer los tests de los ejemplos mencionados.

### Distribuidores
La empresa cuenta con distribuidores que ejecutan los pedidos que se realicen de lotes de cerveza. Un pedido siempre está compuesto por una determinada cantidad de lotes de la misma cerveza. Además, es necesario conocer la distancia en km a donde se enviará el pedido.

Para calcular el precio final de un pedido se parte de un precio base producto de multiplicar la cantidad de lotes del pedido por el costo de cada lote, más una comisión porcentual (sobre el precio base) que cobra cada distribuidor. Además, los distribuidores pueden aplicar promociones que otorgan ciertos descuentos (también porcentuales sobre el precio base).

Entonces el cálculo quedaría como `precio base + comisión porcentual sobre el precio base - descuento porcentual sobre el precio base (si aplica)`

El porcentaje de los descuentos que se pueden aplicar van a depender del tipo de cerveza:
- En las cervezas Clásicas, el descuento es del 5%.
- En las Lager el descuento es 2% por cada gramo de aditivo, hasta un descuento máximo de 10%. 
- Las Porter nunca dan descuentos.

Cada distribuidor decide en qué circunstancias los pedidos obtienen el descuento en base a la promoción que tenga en vigencia, que puede ser:
- Por cantidad: Aplica el descuento cuando la cantidad de lotes del pedido supera cierta cantidad que se indica para cada promo.
- Por cercanía: Aplica el descuento cuando el pedido se encuentra cerca del distribuidor. Esto significa que la distancia de envío es menor a 1 km.

Tener en cuenta que cada distribuidor tiene una sola promoción en vigencia y la puede cambiar en cualquier momento. También hay que contemplar los casos de distribuidores que en algún momento no tengan ninguna promoción vigente.

Además se lleva un prolijo registro de los pedidos pendientes, sabiendo qué distribuidor lo tiene asignado, y cuánto lleva cobrado (por comisiones) al momento cada distribuidor. 


_Ejemplo:_ 

_El distribuidor "Los Tres Birreros" da descuentos para pedidos de más de 3 lotes y se queda con una comisión del 5%. Mientras que el distribuidor de "Moe" da descuentos a partir de los 7 lotes y se queda con una comisión del 7%._

_Un pedido de 4 lotes de cerveza Clásica para entregar a 4km de distancia tendrá un precio de:_
- _$3520 para "Los Tres Birreros": precio base es $3520 ($880 * 4) + comisión de $176 ($3520 * 5%) - descuento de $176 ($3520 * 5% por ser Clásica)._
- _$3766.4 para "Moe": precio base es $3520 ($880 * 4) + comisión de $246,4 ($3520 * 7%) - descuento de $0 (no aplica la promoción por cantidad)._


**Se pide**
1. Conocer el precio de un pedido para un distribuidor, contemplando los descuentos y promociones descritas.
2. Hacer que un distribuidor concrete todos sus pedidos pendientes, dejándolos de tener pendientes y cobrando la comisión de cada uno.
3. Averiguar el total cobrado por comisiones de un distribuidor.
4. Conocer los pedidos díficiles que tiene pendientes un distribuidor, que son los que tienen más de 10 lotes de cerveza o no se encuentran cerca (tienen una distancia mayor a 1km).
5. Saber los lotes de cervezas a encargar por un distribuidor, que es el conjunto de lotes de cervezas con pedidos pendientes, sin repetidos.
6. Hacer los tests propuestos para el ejemplo mencionado.

### IBU
Un aspecto que le interesa calcular a la fábrica es la unidad internacional de amargor (IBU), que se calcula en base a los ingredientes de cada cerveza.

La fórmula para calcular el IBU es
`grs de azúcar * amargor del lúpulo / 2`

El amargor del lúpulo es un coeficiente, que para el lúpulo importado es 2.4 y para el local 1.6. La cantidad de azúcar requerida no tiene por qué ser la misma en todas las cervezas. 

Además, para las cervezas Porter:
- en caso que tenga alto contenido alcohólico, la fórmula es 
`grs de azúcar * amargor del lúpulo / 2 * (1 + (porcentaje alcohólico - límite para considerarla de alto contenido alcohólico)/100)`
- en caso contrario, la fórmula es 
`grs de azúcar * amargor del lúpulo / 2 * 0.97` 

_ATENCIÓN: no repetir lógica!_

**Se pide:**
1. Calcular el IBU de un lote de cerveza.
2. Se establece una ley por la cual se prohíbe vender cervezas con un IBU superior a un valor determinado para todas las cervezas. Hacer que los distribuidores solamente tomen pedidos que cumplan con la ley.
3. Implementar los tests propuestos.

### Pedidos compuestos
Se incorpora la capacidad de hacer pedidos compuestos, o sea, poder juntar varios "subpedidos" en uno más grande. 

El precio final del pedido compuesto es el que surge de sumar los precios con los descuentos propios de cada subpedido, en caso que el pedido compuesto aplique a la promoción del distribuidor. Para analizar si corresponde aplicar la promoción, se considera:
- La cantidad de lotes es la suma de las cantidades de los subpedidos. 
- La distancia es la máxima distancia entre los subpedidos.

Si alguno de los subpedidos supera el IBU permitido, entonces decimos que el pedido compuesto no cumple con la ley.

**Se pide:**

1. Incorporar el soporte de pedidos compuesto.
2. Implementar los tests propuestos.
