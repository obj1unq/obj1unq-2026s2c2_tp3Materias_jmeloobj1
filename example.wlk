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
	
	method hayCarreraDeEStudianteQueTieneMateria(materia) = carrerasInscriptas.any({carrera => carrera.contieneMateria(materia)})

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
	var property nombre
  const property curso  
}


class HistoriaAcadémica {
  const property estudiantes = #{}

  method registrarEstudiante(estudiante) {
    
  }
}