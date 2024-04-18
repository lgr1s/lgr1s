include "obj3.h"

obj2::obj2(Head* fparent) : Head(parent) {
	clID = 3;
}

void obj2::signal(string &message){
	message += " (class: 3)";
	cout << endl << "Signal from " << get_path();
}

void obj2::handler(string &message){
	cout << endl << "Signal to " << get_path() << " Text:  " << message;
}
