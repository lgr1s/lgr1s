include "obj6.h"

obj2::obj2(Head* fparent) : Head(parent) {
	clID = 6;
}

void obj2::signal(string &message){
	message += " (class: 6)";
	cout << endl << "Signal from " << get_path();
}

void obj2::handler(string &message){
	cout << endl << "Signal to " << get_path() << " Text:  " << message;
}
