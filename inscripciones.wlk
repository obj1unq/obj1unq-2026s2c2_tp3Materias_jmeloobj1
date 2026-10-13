
object parte5 {
const alex = new Estudiante(nombre = "Alex")
const andy = new Estudiante(nombre = "Andy")


const programacion = new Carrera(nombre = "Programación")
  const epl = new Materia(nombre = "Elementos de Programación y Lógica", carrera = programacion, anio = 1, creditos = 8)
  const mate1 = new Materia(nombre = "Matemática 1", carrera = programacion, anio = 1, creditos = 8)
  const objetos1 = new Materia(nombre = "Objetos 1", carrera = programacion, anio = 1, creditos = 8)
  const objetos2 = new Materia(nombre = "Objetos 2", carrera = programacion, anio = 2, creditos = 8)

  const tuess = new Carrera(nombre = "TUESS")
  const mEyA = new Materia(nombre = "Matemáticas para Economía y Administración", carrera = tuess, anio = 1, creditos = 8)
  const tys = new Materia(nombre = "Trabajo y Sociedad", carrera = tuess, anio = 1, creditos = 8)
  const economia = new Materia(nombre = "Economía", carrera = tuess, anio = 1, creditos = 8)
  const desarrolloLocal = new Materia(nombre = "Desarrollo Local", carrera = tuess, anio = 2, creditos = 8)

  const to = new Carrera(nombre = "Terapia Ocupacional")
  const lea = new Materia(nombre = "Lectura y Escritura Académica", carrera = to, anio = 1, creditos = 8)
  const cienciasSalud = new Materia(nombre = "Ciencias de la Salud", carrera = to, anio = 1, creditos = 8)
  const psicologia = new Materia(nombre = "Psicología", carrera = to, anio = 2, creditos = 4)
  const antropologia = new Materia(nombre = "Antropología", carrera = to, anio = 2, creditos = 4)
  const sociologia = new Materia(nombre = "Sociología", carrera = to, anio = 3, creditos = 8)

  method requisitos() {
    objetos2.requisito(new Correlativas(materiasRequeridas = #{objetos1, mate1}))
    desarrolloLocal.requisito(new Correlativas(materiasRequeridas = #{mEyA}))
    psicologia.requisito(anioAnterior)
    antropologia.requisito(new Creditos(creditosMinimos = 8))
    sociologia.requisito(new Creditos(creditosMinimos = 10))
  }
  method registraCursada(){
    alex.inscribirseACarrera(programacion)
    alex.inscribirseACarrera(tuess)
    alex.registrarCursada(mate1, 2)
    alex.registrarCursada(objetos1, 10)
    alex.registrarCursada(economia, 6)
    alex.registrarCursada(tys, 8)
    alex.registrarCursada(mate1, 8)
    alex.registrarCursada(bd, 2)
    andy.registrarCursada(objetos1, 10)
    andy.registrarCursada(mate1, 10)
  }
}

class Estudiante {
  var property nombre
  const property carreras = #{}
  const property historiaAcademica = new HistoriaAcademica(estudiante = self)
  
  method inscribirseACarrera(carrera) {
    if (self.estaInscriptoEn(carrera)) self.error(
        "ya está inscripto en esa carrera"
      )
    carreras.add(carrera)
  }
  
  method estaInscriptoEn(carrera) = carreras.contains(carrera)
  
  method carreraTieneAMateria(materia) = carreras.any(
    { carrera => carrera.carreraTieneAMateria(materia) }
  )
  
    method puedeInscribirseAMateria(materia) =
    self.carreraTieneAMateria(materia)     && 
    !self.tieneAprobadaMateria(materia)    && 
    !self.estaInscriptoEnMateria(materia)  && 
    materia.cumple(self)

  method inscribirseAMateria(materia) {
    if (self.puedeInscribirseAMateria(materia)){
      materia.estudiantes().add(self)
    }
        else{
          self.error("el estudiante no puede inscribirse a la materia")
        }
  }
  
  method estaInscriptoEnMateria(materia) = materia.estudiantes().contains(self)


  method tieneAprobadaMateria(materia) =
    historiaAcademica.tieneAprobadaMateria(materia)
  
  method creditosEnCarrera(
    carrera
  ) = historiaAcademica.materiasAprobadasDeCarrera(carrera).sum(
    { materia => materia.creditos() }
  )

  	method registrarCursada(materia, nota) {
		self.validarRegistroDeCursada(materia)
		historiaAcademica.registrarCursada(materia, nota)
	}

  method validarRegistroDeCursada(materia) {
		if (!self.carreraTieneAMateria(materia)) {
			self.error(nombre + " no puede registrar la materia " + materia.nombre() + ": no pertenece a ninguna de sus carreras")
		}
		if (self.carreraTieneAMateria(materia)) {
			self.error(nombre + " no puede registrar la materia " + materia.nombre() + ": ya la tiene aprobada")
		}
	}

}

class Carrera {
  var property nombre
  const property materias = #{}
  
  method carreraTieneAMateria(materia) = materias.contains(materia)

  method agregarMateria(materia) {
    materias.add(materia)
    materia.carrera(self)
  }
  
 method agregarMaterias(unasMaterias) {
    unasMaterias.forEach({ materia => self.agregarMateria(materia) })
  }
    method materiasHabilitadasParaEstudiante(estudiante) =
    materias.filter({ materia => estudiante.puedeInscribirseAMateria(materia) })
  
  method materiasDeAnio(anio) =
    materias.filter({ materia => materia.anio() == anio })
  
}

class Materia {
  var property nombre
  var property carrera = null
  var property requisitos = sinRequisitos
  const property estudiantes = #{}
  var property anio = 1
  var property creditos = 0
  
  method cumple(estudiante) = requisitos.cumple(estudiante, self)  
}

object sinRequisitos {
  method cumple(estudiante, materia) = true
}

class Creditos {
  const property creditosMinimos
   method cumple(estudiante, materia) =
    estudiante.creditosEnCarrera(materia.carrera()) >= creditosMinimos
}

class Correlativas {
  const property materiasRequeridas
  
  method cumple(estudiante, materia) = materiasRequeridas.all(
    { requerida => estudiante.tieneAprobadaMateria(requerida) }
  )
}

object anioAnterior {
 method cumple(estudiante, materia) =
    materia.carrera().materiasDeAnio(materia.anio() - 1)
      .all({ anterior => estudiante.tieneAprobadaMateria(anterior) })
}

class HistoriaAcademica {
  const property estudiante
  const property cursadas = []
  
  method registrarCursada(materia, nota) {
    const cursada = new Cursada(materia = materia, nota = nota)
    if (!cursada.notaValida()) self.error("la nota debe estar entre 1 y 10")
    if (!estudiante.carreraTieneAMateria(materia)) self.error(
        "la materia no pertenece a ninguna de sus carreras"
      )
    if (self.tieneAprobadaMateria(materia)) self.error(
        "la materia ya está aprobada"
      )
    cursadas.add(cursada)
  }
  
  method tieneAprobadaMateria(materia) = cursadas.any(
    { cursada => (cursada.materia() == materia) && cursada.estaAprobada() }
  )
  
  method materiasAprobadas() = cursadas.filter(
    { cursada => cursada.estaAprobada() }
  ).map({ cursada => cursada.materia() }).asSet()
  
  
  method materiasAprobadasDeCarrera(carrera) = self.materiasAprobadas().filter(
    { materia => carrera.carreraTieneAMateria(materia) }
  )
  
  method cantidadAprobadasDeCarrera(carrera) =
    self.materiasAprobadasDeCarrera(carrera).size()
  
  method cursadasAprobadasEnCarrera(carrera) = self.cursadasAprobadas().filter(
    { cursada => carrera.carreraTieneAMateria(cursada.materia()) }
  )
  
  method cursadasAprobadasEnCarreras(
    carreras
  ) = self.cursadasAprobadas().filter(
    { cursada => carreras.any(
        { carrera => carrera.carreraTieneAMateria(cursada.materia()) }
      ) }
  )
  
  method cursadasAprobadas() = cursadas.filter(
    { cursada => cursada.estaAprobada() }
  )
  
method promedioDeMateriasAprobadasEnCarrera(carrera) =
    self.promedioDeMateriasAprobadasEnCarreras(#{carrera})


  method promedioDeMateriasAprobadasEnCarreras(carreras) {
    self.validarQueHayMateriasAprobadasEnCarreras(carreras)
    return self.promedioDe(self.cursadasAprobadasEnCarreras(carreras))
  }
  
  method validarQueHayMateriasAprobadasEnCarreras(carreras) {
    if (self.cantidadDeMateriasAprobadasEnCarreras(carreras) == 0) self.error(
        "No hay materias aprobadas en ninguna de las carreras: no se puede calcular el promedio"
      )
  }
  
  method cantidadDeMateriasAprobadasEnCarreras(
    carreras
  ) = self.cursadasAprobadasEnCarreras(carreras).size()
  
  method materiasAprobadasDeTodasLasCarreras() = self.materiasAprobadas().filter(
    { materia => estudiante.carreraTieneAMateria(materia) }
  )
  
   method cantidadDeMateriasAprobadasTotal() =
    self.cantidadDeMateriasAprobadasEnCarreras(estudiante.carreras())
  
 method promedioDeMateriasDeCarreras() =
    self.promedioDeMateriasAprobadasEnCarreras(estudiante.carreras())
  
  method ordenDeCursadaDeMateria(materia) = cursadas.filter(
    { cursada => cursada.materia() == materia }
  )
  
  method promedioDe(cursadasAprobadas) = cursadasAprobadas.sum(
    { cursada => cursada.nota() }
  ) / cursadasAprobadas.size()
}

class Cursada {
  const property materia
  const property nota
  
  method notaValida() = nota.between(1, 10)
  
  method estaAprobada() = nota >= 6

}
