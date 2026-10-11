

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
  var property materia = Materia
  var property nota = 0
  var property materiasAprobadas = #{}
  
  method notaValida() {
    return nota.between(1, 10)
  }

  method materiaSeAprobóPreviamente() {
    return !(estudiante.carrerasInscripto().contains(materia))
  }

  method materiaPerteneceACarreraDeEstudiante() {
    return estudiante.carreraTieneAMateria(materia)
  }

  method aprobóLaMateria() {
   return  self.notaValida() && nota <=6
  }

  method agregarMateriaAprobada() {
    if(self.aprobóLaMateria()){
      materiasAprobadas.add(materia)
    }
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






}



