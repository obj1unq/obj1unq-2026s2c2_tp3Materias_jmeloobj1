

class Estudiante{
var property  nombreEstudiante
var property carrerasInscripto = #{}

method inscribirseACarrera(carrera) {
  if(!carrerasInscripto.contains(carrera)){
	carrerasInscripto.add(carrera)
  }
}

method carreraTieneAMateria(materia) {
  return carrerasInscripto.any({carrera => carrera.carreraTieneAMateria(materia) })
}
}

class Carrera{
var property nombreCarrera
var property materias = #{} 
method carreraTieneAMateria(materia) {
  return materias.contains(materia)
}

}

class Materia{
	var property nombreMateria 
}

class HistoriaAcademica{
  var property estudiante = Estudiante
  var property cursadas = []  
  var property materiasAprobadas = #{}
  
method registrarCursada(materia, nota) {
  if(!materiasAprobadas.contains(materia)){
		cursadas.add(new Cursada(estudiante = estudiante ,materia = materia, nota = nota))
	}else{
    self.error("no se puede registrar cursada, esta materia ya está aprobada")
  }
} 

  method materiaSeAprobóPreviamente(materia) {
    return cursadas.any({cursada => cursada.contains(materia) && cursada.materia(materia).estaAprobada()})
  }

  method materiaEstaAprobada(materia) {
    return cursadas.any({cursada => cursada.materia(materia).estaAprobada()})
  }

  method agregarMateriaAprobada(materia) {
    if (self.materiaEstaAprobada(materia)){
        materiasAprobadas.add(materia)
    }
  }

  method materiaPerteneceACarreraDeEstudiante(materia) {
    return estudiante.carreraTieneAMateria(materia)
  }

  method promedioDeMateriasAprobadasDeCarrera(carrera) {
    return carrera.materias() / self.cantidadDeMateriasAprobadasDeCarrera(carrera)
  }

  method materiasAprobadasDeCarrera(carrera) {
    return materiasAprobadas.filter({materia => carrera.carreraTieneAMateria(materia)})
  }

  method cantidadDeMateriasAprobadasDeCarrera(carrera) {
    return self.materiasAprobadasDeCarrera(carrera).size()
  }

  method materiasAprobadasDeCarreras(carreras) {
    return carreras.filter({carrera => self.cantidadDeMateriasAprobadasDeCarrera(carrera)})
  }

  method promedioDeMateriasAprobadasDeCarreras(carreras) {
    return carreras.filter({carrera => self.promedioDeMateriasAprobadasDeCarrera(carrera)})
  }

 method ordenDeCursadaDeMateria(materia) {
   return cursadas.filter({ cursada => cursada.materia() == materia })
 }


}


class Cursada{
  var property estudiante = Estudiante
  var property materia = Materia
  var property nota = 0 
  
  method notaValida() {
    return nota.between(1, 10)
  }


  method estaAprobada(){
    return nota >= 6 
  } 

 
}



