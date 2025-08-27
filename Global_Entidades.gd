extends Node

var npcs = {}

func registrar_npc(nombre: String, nodo: Node):
	npcs[nombre] = nodo
func obtener_npc(nombre: String) -> Node:
	return npcs.get(nombre, null)
