#include "Cl_appl.h"

using namespace std;

Cl_appl::Cl_appl(Head* parent) : Head(parent) {
	actual = this;
	clID = 1;
}

void Cl_appl::set_appl(){
	string name1 = "";
	cin >> name1;
	set_name(name1);
	string name2 = "";
	int obj;
	while (true) {
		cin >> name1;
		if (name1 == "endtree")  break;
		Head* object = find(name1);
		if (object == nullptr) {
			build = 0;
			nfound = name1;
			break;
		}
		else {
			cin >> name2 >> obj;
			switch(obj) {
				case 2:
					object->new_child(new obj2(nullptr), name2);
					break;
				case 3:
					object->new_child(new obj3(nullptr), name2);
					break;
				case 4:
					object->new_child(new obj4(nullptr), name2);
					break;
				case 5:
					object->new_child(new obj5(nullptr), name2);
					break;
				case 6:
					object->new_child(new obj6(nullptr), name2);
					break;
			}
		}
	}
}

void Cl_appl::setup(){
	string name1;
	int status;
	while(cin >> name1) {
		cin >> status;
		lookf(name1)->set_status(status);
	}
}

int Cl_appl::exec_appl() {
	cout << "Object tree";
	show(0);
	if (build){
		active();
		set_connect();
		exec_new_commands();
	}
	else cout << endl << "The head object " << nfound << " is not found";
	return (0);
}

void Cl_appl::exec_commands(){
	string comm, path;
	Head* object;
	while(true){
		cin >> comm;
		if (comm == "END") break;
		else if (comm == "SET") {
			cout << endl;
			cin >> path;
			object = find(path);
			if(object == nullptr) cout << "Object is not found: " << actual->get_name() << " " << path;
			else {
				actual = object;
				cout << "Object is set: " << object->get_name();
			}
		}
		else if (comm == "FIND") {
			cout << endl;
			cin >> path;
			object = find(path);
			if (object == nullptr) cout << path << "     " << "Object is not found";
			else cout << path << "     " << "Object name: " << object->get_name();
		}
		else break;
	}
}

void Cl_appl::signal(string &message){
	message += " (class: 1)";
	cout <<	endl << "Signal from " << get_path();
}

void Cl_appl::handler(string &message){
	cout << endl << "Signal to " << get_path() << " Text:  " << message;
}

void Cl_appl::exec_new_commands(){
	string comm, emit, fhandler, msg;
	int status;
	while (true) {
		cin >> comm;
		if(comm == "END") break;
		if(comm == "SET_CONNECT" || comm == "DELETE_CONNECT"){
			cin >> emit;
			cin >> fhandler;
			Head* emitter = find(emit);
			if(!emitter) {
				cout << endl << "Object " << emit << " not found";
				continue;
			}
			Head* handler = find(fhandler);
			if(!handler){
				cout << endl << "Handler object " << fhandler << " not found";
				continue;
			}
			TYPE_SIGNAL p_signal = get_signal(emitter->get_clID());
			TYPE_HANDLER p_handler = get_handler(handler->get_clID());
			if(comm == "SET_CONNECT") emitter->set_connect(p_signal, p_handler, handler);
			else emitter->delete_connect(p_signal, p_handler, handler);
		}
		else if(comm == "SET_CONDITION"){
			cin >> emit;
			cin >> status;
			Head* emitter = find(emit);
			if(!emitter) {
				cout << endl << "Object " << emit << " not found";
				continue;
			}
			emitter->set_status(status);
		}
		else if(comm == "EMIT"){
			cin >> emit;
			cin.get();
			getline(cin, msg);
			Head* emitter = find(emit);
			if(!emitter){
				cout << endl << "Object " << emit << " not found";
				continue;
			}
			TYPE_SIGNAL signal = get_signal(emitter->get_clID());
			emitter->emmit(signal, msg);
		}
	}
}

void Cl_appl::set_connect(){
	string emit, fhandler;
	while(true){
		cin >> emit;
		if(emit == "end_of_connections") break;
		cin >> fhandler;
		Head* emitter = find(emit);
		if (!emitter){
			cout << endl << "Object " << emit << " not found";
			continue;
		}
		Head* handler = find(fhandler);
		if(!handler){
			cout << endl << "Handler object " << fhandler << " not found";
			continue;
		}
		TYPE_SIGNAL p_signal = get_signal(emitter->get_clID());
		TYPE_HANDLER p_handler = get_handler(handler->get_clID());
		emitter->set_connect(p_signal, p_handler, handler);
	}
}

TYPE_SIGNAL Cl_appl::get_signal(int ss){
	if(ss == 1) return SIGNAL_D(Cl_appl::signal);
	if(ss == 2) return SIGNAL_D(obj2::signal);
	if(ss == 3) return SIGNAL_D(obj3::signal);
	if(ss == 4) return SIGNAL_D(obj4::signal);
	if(ss == 5) return SIGNAL_D(obj5::signal);
	if(ss == 6) return SIGNAL_D(obj6::signal);
	return nullptr;
}

TYPE_HANDLER Cl_appl::get_handler(int ss){
	if(ss == 1) return HANDLER_D(Cl_appl::handler);
	if(ss == 2) return HANDLER_D(obj2::handler);
	if(ss == 3) return HANDLER_D(obj3::handler);
	if(ss == 4) return HANDLER_D(obj4::handler);
	if(ss == 5) return HANDLER_D(obj5::handler);
	if(ss == 6) return HANDLER_D(obj6::handler);
	return nullptr;
}
