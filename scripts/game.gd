extends Node2D

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry

const Player = preload("res://scenes/tank.tscn")
const SERVER_PORT = 8080
var enet_peer =ENetMultiplayerPeer.new()

func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		enet_peer.create_server(SERVER_PORT)
		multiplayer.multiplayer_peer=enet_peer
		multiplayer.peer_connected.connect(add_player)
		multiplayer.peer_disconnected.connect(remove_player)

func _on_host_button_pressed() -> void:
	main_menu.hide()
	
	enet_peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer=enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)

func _on_join_button_pressed() -> void:
	main_menu.hide()
	var SERVER_IP = address_entry.text
	enet_peer.create_client(SERVER_IP,SERVER_PORT)
	multiplayer.multiplayer_peer=enet_peer

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func add_player(peer_id):
	var player = Player.instantiate()
	player.name=str(peer_id)
	add_child(player)
