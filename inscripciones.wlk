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
