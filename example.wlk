class Estudiante {
  var property nombreEstudiante
  var property carrerasInscripto = #{}
  
  method inscribirseACarrera(carrera) {
    if (!carrerasInscripto.contains(carrera)) carrerasInscripto.add(carrera)
  }
  
  method carreraTieneAMateria(materia) = carrerasInscripto.any({ carrera => carrera.carreraTieneAMateria(materia) })
}

class Carrera {
  var property nombreCarrera
  var property materias = #{}
  
  method carreraTieneAMateria(materia) = materias.contains(materia)
}

class Materia {
  var property nombreMateria
}

class HistoriaAcademica {
  var property estudiante = Estudiante
  var property cursadas = []
  
  method registrarCursada(materia, nota) {
    const cursada = new Cursada(materia = materia, nota = nota)
    if (!cursada.notaValida()) 
    self.error("la nota debe estar entre 1 y 10")
    if (!estudiante.carreraTieneAMateria(materia))
     self.error( "la materia no pertenece a ninguna de sus carreras")
    if (self.tieneAprobadaMateria(materia)) self.error(
        "la materia ya está aprobada"
      )
    cursadas.add(cursada)
  }
  
   method tieneAprobadaMateria(materia) =
    cursadas.any({ cursada => cursada.materia() == materia && cursada.estaAprobada() })

  method materiasAprobadas() =
    cursadas.filter({ cursada => cursada.estaAprobada() }).map({ cursada => cursada.materia() }).asSet()

  method mejorNotaDeMateria(materia) =
    cursadas
      .filter({ cursada => cursada.materia() == materia && cursada.estaAprobada() })
      .map({ cursada => cursada.nota() })
      .max()

  method materiasAprobadasDeCarrera(carrera) =
    self.materiasAprobadas().filter({ materia => carrera.carreraTieneAMateria(materia) })

  method cantidadAprobadasDeCarrera(carrera) =
    self.materiasAprobadasDeCarrera(carrera).size()

  method promedioDeMateriasAprobadasDeCarrera(carrera) {
      if(carrera.isEmpty()) {
      return 0
    }
    return  carrera.materias().size() / carrera.sum({ carrera => self.cantidadAprobadasDeCarrera(carrera) }) 
  }

  // Req 4
  method materiasAprobadasDeTodasLasCarreras() =
    self.materiasAprobadas().filter({ materia => estudiante.carreraTieneAMateria(materia) })

  method cantidadDeMateriasAprobadasTotal() =
    self.materiasAprobadasDeTodasLasCarreras().size()

  method promedioDeMateriasDeCarreras(){
    return estudiante.carrerasInscripto().size() / self.materiasAprobadasDeTodasLasCarreras().size()
  }

  method ordenDeCursadaDeMateria(materia) =
    cursadas.filter({ cursada => cursada.materia() == materia })

}

class Cursada {
  const property materia
  const property nota
  
  method notaValida() = nota.between(1, 10)
  
  method estaAprobada() = nota >= 6
}


