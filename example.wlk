

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





