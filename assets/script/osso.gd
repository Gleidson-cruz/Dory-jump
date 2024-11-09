extends Area2D

# Este método é chamado quando o nó é adicionado à cena
func _ready():
	# Conectando o sinal body_entered ao método _on_body_entered
	self.body_entered.connect(_on_body_entered)

# Este método é chamado quando um corpo entra na área
func _on_body_entered(body):
	if body.is_in_group("Personagem"):  # Verifica se o corpo que colidiu é do grupo "jogadores"
		# Acessa a cena principal
#		var main_scene = get_tree().current_scene  # Acessa a cena atual
#		var label = main_scene.get_node("CanvasLayer/Label")  # Substitua pelo caminho correto do seu label

		# Adiciona 1 ao valor atual do label
#		label.text = str(int(label.text) + 1)
		queue_free()  # Remove o coletável da cena
		
