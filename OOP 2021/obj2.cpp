include "obj2.h"

obj2::obj2(Head* fparent) : Head(parent) {
	clID = 2;
}

void obj2::signal(string &message){
	message += " (class: 2)";
	cout << endl << "Signal from " << get_path();
}

void obj2::handler(string &message){
	cout << endl << "Signal to " << get_path() << " Text:  " << message;
}
