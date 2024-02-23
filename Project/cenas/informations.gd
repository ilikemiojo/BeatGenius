extends Control

signal close()

var baiao_info = 'Baião is a northeastern musical rhythm, accompanied by dance, very popular in the Northeast and northern regions of Brazil.
The baião is also a form of dance. Dancers usually dance in pairs, making synchronized movements that imitate the movements of a bird called a "baião", which gives the genre its name.
It was in the second half of the 1940s that baião became popular, through musicians Luiz Gonzaga (known as the “king of baião”) and Humberto Teixeira (“the doctor of baião”).\n\n'

var xote_info = 'Xote is a musical rhythm and dance originating from northeastern Brazil, influenced by indigenous, African, and European traditions. It is characterized by a distinct beat in binary time signatures (2/4 or 4/4) and typical instrumentation including accordion, zabumba (a type of drum), and triangle. Xote dance is performed in pairs with simple yet engaging movements. The lyrics often depict everyday themes of northeastern life such as love, longing, and rural experiences. Xote gained national and international prominence through artists like Luiz Gonzaga, representing a cultural emblem of northeastern Brazil.\n\n'

var xaxado_info = 'Xaxado is a traditional musical style and dance from northeastern Brazil, with vigorous and striking rhythms, associated with the hinterland culture. Originating from Pernambuco, xaxado is characterized by energetic movements that simulate the march of the cangaceiros. Its lyrics often address social and resistance themes. Xaxado is an essential part of the northeastern cultural identity, having gained prominence through artists like Luiz Gonzaga.\n\n'

func show_baiao_info():
	$Background/VBoxContainer/Title.text = 'Baião\n\n'
	$Background/VBoxContainer/Info.text = baiao_info

func show_xote_info():
	$Background/VBoxContainer/Title.text = 'Xote\n\n'
	$Background/VBoxContainer/Info.text = xote_info

func show_xaxado_info():
	$Background/VBoxContainer/Title.text = 'Xaxado\n\n'
	$Background/VBoxContainer/Info.text = xaxado_info


func _on_close_pressed():
	emit_signal("close")
