extends Node2D

@export var Name = ""
@export var damage = ""
@export var item_slot : int
@export var discription = "a"
@export var type = ""
@export var protection : int
@export var char_scaling : String
@export var Script_Name : PackedScene
#@export var characteristic = ""
#@export var Info : PackedScene


func _ready():
	$GearInfo/Label.text = "Name: " + Name
	$GearInfo/Label2.text = "Damage: " + damage
	$/root/level/Hero.remove.connect(remove_self)

func _on_delete_pressed():
	InvLog.remove_item(item_slot)
	queue_free()

func remove_self(Index):
	if Index == item_slot:
		InvLog.remove_item(item_slot)
		#print("Index: " + str(Index))
		#print("item_slot: " + str(item_slot))
		#print("name: " + Name)
		self.queue_free()

func _on_button_pressed():
	Global.selected_item = Script_Name
	
	$/root/level/Hero/CanvasLayer/ItemsMenu.show()
	$/root/level/Hero/CanvasLayer/ItemsMenu/item_name.text = Name
	if type == "weapon":
		$/root/level/Hero/CanvasLayer/ItemsMenu/item_damage_or_res.text = "Damage: " + damage
	if type == "armor":
		$/root/level/Hero/CanvasLayer/ItemsMenu/item_damage_or_res.text = "protection: " + str(protection)
	if type == "coin":
		$/root/level/Hero/CanvasLayer/ItemsMenu/item_damage_or_res.text = "amount: " + str(Global.coins)
	if type == "loot":
		$/root/level/Hero/CanvasLayer/ItemsMenu/item_damage_or_res.text = ""
	$/root/level/Hero/CanvasLayer/ItemsMenu/discription.text = discription
	#$GearInfo.visible = !$GearInfo.visible
	#if $GearInfo == null:
	#	var create = Info.instantiate()
		#add_child(create)
	#	$GearInfo/Label7.text = "Name: " + Name
	#	$GearInfo/Label8.text = "Damage: " + damage
	#	$GearInfo/Delete10.pressed.connect(_on_delete_pressed)
	#else:
	#	$GearInfo.queue_free()
