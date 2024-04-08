extends Control

@export_file('*.tscn') var start_scene

var points = 0
var click_plano = 1
var points_per_second = 0

var tiempo_transcurrido = 0
var segundo = 1.0 # Intervalo de tiempo en segundos

var escalado_click_plano = 50
var escalado_clickers = 100

func _ready():
	update_points_label()
	update_upgrades_on()
	# Iniciar el temporizador cuando se inicializa el script
	set_process(true)

func _process(delta) -> void:
	if is_it_50():
		$Panel/VBoxContainer2.visible = true
	
	tiempo_transcurrido += delta
	if tiempo_transcurrido >= segundo:
		points += points_per_second
		tiempo_transcurrido = 0
		update_points_label()
	


func is_it_50() -> bool:
	if points >= 50:
		return true
	else:
		return false
	

func update_points_label():
	$Panel/VBoxContainer/HBoxContainer/Label2.text = str(points)

func _on_button_pressed_click():
	points += click_plano
	update_points_label()
	update_upgrades_on()

func update_upgrades_on():
	# Si los puntos son mayores o iguales que el costo de la próxima mejora
	if points >= escalado_click_plano:
		# Habilitar el upgrade de moreClicks de la lista de ítems
		$Panel/VBoxContainer2/ItemList.set_item_disabled(0, false)
	if points >= escalado_clickers:
		$Panel/VBoxContainer2/ItemList.set_item_disabled(1, false)

func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	match index:
		0:
			if points >= escalado_click_plano:
				# Restar los puntos correspondientes al costo de la mejora
				points -= escalado_click_plano
				# Aumentar el costo de la mejora para la próxima vez
				escalado_click_plano *= 1.5
				# Actualizar la etiqueta de puntos
				update_points_label()
				# Deseleccionar item
				$Panel/VBoxContainer2/ItemList.set_item_disabled(0, true)
				# Volver a comprobar si se pueden habilitar más mejoras
				update_upgrades_on()
				# Hacer el aumento de clicks_planto
				click_plano *=2
				# Actualizar precio en pantalla
				var new_cost_click_plano = escalado_click_plano
				$Panel/VBoxContainer2/ItemList.set_item_text(0, "MoreClicks -- " + str(new_cost_click_plano) + " points")
				
		1:
			if points >= escalado_clickers:
				# Restar los puntos correspondientes al costo de la mejora
				points -= escalado_clickers
				# Aumentar el costo de la mejora para la próxima vez
				escalado_clickers *= 1.5
				# Actualizar la etiqueta de puntos
				update_points_label()
				# Deseleccionar item
				$Panel/VBoxContainer2/ItemList.set_item_disabled(1, true)
				# Volver a comprobar si se pueden habilitar más mejoras
				update_upgrades_on()
				# Hacer el aumento de points_per_second
				points_per_second += 1
				# Actualizar precio en pantalla
				var new_cost_clickers = escalado_clickers
				$Panel/VBoxContainer2/ItemList.set_item_text(1, "Clickers -- " + str(new_cost_clickers) + " points")


func _on_btn_salir_pressed_exit():
	get_tree().change_scene_to_file(start_scene)
