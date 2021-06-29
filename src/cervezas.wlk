// Siempre hablamos de un lote de cerveza

// lúpulo: importado o local (posible polimorfismo)

// Tres tipos de birras: Clásica, Lager y Porter

// requerimiento: Calcular el costo total de cualquier lote de cerveza.
// cerveza.costoTotal()

class LoteCerveza {
	const lupulo
	const azucar
	
	// Template method
	method costoTotal() {
		return lupulo.costo() + self.costoDeElaboracion()
	}
	
	method costoDeElaboracion()
	
	method ibu() {
		return azucar * lupulo.amargor() / 2
	}
}

class Clasica inherits LoteCerveza { 
	const levadura
	
	override method costoDeElaboracion() {
		return levadura.costoDeElaboracion(lupulo)
	}
	
	method descuento() = 0.05
}

class Lager inherits LoteCerveza { 
	const aditivo
	
	override method costoDeElaboracion() {
		return 50 * aditivo
	}

	method descuento() = (0.02*aditivo).min(0.1)
}

class Porter inherits LoteCerveza { 
	const contenidoAlcoholico
	const limiteDeBorrachera = 0.08
	
	override method costoDeElaboracion() {
		return if (self.altoContenidoAlcoholico()) 450 else 150
	}
	
	method altoContenidoAlcoholico() {
		return contenidoAlcoholico > limiteDeBorrachera
	}

	method descuento() = 0
	
	override method ibu() {
		return super() * self.coeficienteDeIBU()
	}
	
	method coeficienteDeIBU() {
		return if (self.altoContenidoAlcoholico()) 
				(1 + (contenidoAlcoholico - limiteDeBorrachera))
		else 	0.97 
	}
	
}

// LUPULOS
object importado {
	var property impuestoAFIP = 0.2
	
	method costo() { return 1000 * (1 + impuestoAFIP) }
	
	method amargor() { return 2.4 }
}

object local {
	method costo() { return 800 }

	method amargor() { return 1.6 }
}

// LEVADURAS
object alta { 
	method costoDeElaboracion(lupulo) = 0.1 * lupulo.costo()
}

object baja { 
	method costoDeElaboracion(lupulo) = 300
}


// Requerimiento: Conocer el precio de un pedido para un distribuidor
// distribuidor.precioFinal(pedido)
// pedido.precioFinal(distribuidor)

class Distribuidor { 
	const property pedidosPendientes = []
	var property comision
	var property promocion
	var property cobrado = 0
	
	method tomarPedido(pedido) {
		self.validarPedido(pedido)
		pedidosPendientes.add(pedido)
	}
	
	method descuentoPorPromocion(pedido) {
		return if (self.aplicaPromocion(pedido)) 
			pedido.descuentoPorCerveza()
		else
			0
	}
	
	method aplicaPromocion(pedido) {
		return promocion.aplica(pedido)
	}
	
	method entregarPedidos() {
		pedidosPendientes.forEach({pedido => self.entregar(pedido)})
	}
	
	method entregar(pedido) {
		cobrado += pedido.comisionPara(self) 
		pedidosPendientes.remove(pedido)
	}
	
	method pedidosDificiles() {
		return pedidosPendientes.filter({pedido => pedido.esDificil()})
	}
	
	method lotesAEncargar() {
		return pedidosPendientes.map({pedido => pedido.lotesCervezas()}).flatten().asSet()
	}
	
	method validarPedido(pedido) {
		if (pedido.cumpleConLaLey())
			self.error("Este pedido es ilegal") 
	}
}

// PROMOCIONES
class PorCantidad {
	var cantidadLimite
	
	method aplica(pedido) {
		return pedido.cantidadLotes() > cantidadLimite
	}
}

object porCercania {
	method aplica(pedido) {
		return pedido.estaCerca()
	}
}

// Null Object (modelar la nada)
object sinPromocion {
	method aplica(pedido) {
		return false
	}
}


class Pedido { 
	
	method precioFinal(distribuidor) {
		return self.precioBase() + self.comisionPara(distribuidor) - distribuidor.descuentoPorPromocion(self)
	}
	
	method comisionPara(distribuidor) {
		return self.precioBase() * distribuidor.comision()
	}
	
	method estaCerca() {
		return self.distancia() < 1
	}
	
	method esDificil() {
		return self.cantidadLotes() > 10 or not self.estaCerca()
	}
	
	method distancia() 
	method cantidadLotes()
	method precioBase() 
}

class PedidoSimple inherits Pedido {
	const property cantidadLotes
	const property loteCerveza 
	const property distancia
	
	override method precioBase() {
		return cantidadLotes * loteCerveza.costoTotal() 
	}
	
	method descuentoPorCerveza() {
		return self.precioBase() * loteCerveza.descuento()
	}
	
	method cumpleConLaLey() {
		return loteCerveza.ibu() > ley.ibuMaximo()
	}
	
	method lotesCervezas() {
		return [loteCerveza]
	}
}

// Composite
class PedidoCompuesto inherits Pedido {
	const pedidos = []
	
	override method cantidadLotes() { 
		return pedidos.sum({pedido => pedido.cantidadLotes()})
	}
	
	method lotesCervezas() {
		return pedidos.flatMap({pedido => pedido.lotesCervezas()})
	}
	
	override method distancia() { 
		return pedidos.max({pedido => pedido.distancia()}).distancia()
	}
	
	override method precioBase() {
		return pedidos.sum({pedido => pedido.precioBase()})
	}
	
	method descuentoPorCerveza() {
		return pedidos.sum({pedido => pedido.descuentoPorCerveza()})
	}
	
	method cumpleConLaLey() {
		return pedidos.all({pedido => pedido.cumpleConLaLey()})
	}
}



object ley {
	var property ibuMaximo = 0 
}
