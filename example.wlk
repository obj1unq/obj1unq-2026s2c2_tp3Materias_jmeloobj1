class Estudiante{
  var property nombreEstudiante  
	const carrerasInscriptas = #{}
	method carrerasInscriptas() = carrerasInscriptas
	
	method inscribirse(carrera){
		self.validarInscripcion(carrera)
		self.agregarCarrera(carrera)
	}
	method validarInscripcion(carrera){
		if(self.estaInscripto(carrera)){
			self.error("no se puede inscribir a una carrera que ya esta inscripto")
		}
	}
	method estaInscripto(carrera) = carrerasInscriptas.contains(carrera)
	method agregarCarrera(carrera){
		carrerasInscriptas.add(carrera)
	}
	
	method materiaPerteneceACarrera(materia) = carrerasInscriptas.any({carrera => carrera.contieneMateria(materia)})

  method notaEnMateria(materia) {
    return 
  }
}

class Carrera{
	var property nombre
	const materias = #{}
	method materias() = materias
	
	method agregarMateria(materia){
		materias.add(materia)
	}
	
	method contieneMateria(materia) = materias.contains(materia)
	
	
}

class Materia{
	var property nombreMateria
}


class HistoriaAcadémica {
  const property estudiantes = #{}

  method registrarEstudiante(estudiante, materia) {
  
  }
}

class Nota {
  var property estudiante = Estudiante
  var property nota
  var property materia 

  method validarNota(_nota) {
    if(! _nota.between(1,10) ){
      self.error("nota no valida")
    }else{
      nota = _nota
    }
  }

  method notaAProbada() {
    return nota.between(6, 10)
  }

  method notaDeEstudianteEnMAteria() {
    return ([estudiante.nombreEstudiante(), materia.nombre(), nota])
  }


}