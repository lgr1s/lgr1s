#include "Head.h"
#include <iostream>

Head::Head(Head* fparent){
	this->parent = fparent;
}

string Head::get_name(){
	return this->name;
}

Head* Head::get_parent(){
	return this->parent;
}

void Head::set_name(std::string fname){
	this->name = fname;
}

void Head::set_parent(Head* fparent){
	this->parent = fparent;
}

void Head::show(int step){
	cout << endl;
	for (int i = 0; i < step; i++){
		cout << "    ";
	}
	cout << name;
	int cnt = this->children.size();
	for (int i = 0; i < cnt; i++){
		children[i]->show(step+1);
	}
}

void Head::show_full(int step){
	cout << endl;
	for(int i = 0; i < step; i++){
		cout << "    ";
	}
	cout << name;
	cout << " " << is_rdy();
	int cnt = this->children.size();
	for (int i = 0; i < cnt; i++){
		children[i]->show_full(step + 1);
	}
}

void Head::new_child(Head* child, string fname){
	child->set_parent(this);
	child->set_name(fname);
	this->children.push_back(child);
}

Head* Head::lookf(string fname){
	Head* ob = nullptr;
	if (this->name == fname) return this;
	for(auto* each: children){
		ob = each->lookf(fname);
		if(ob != nullptr) break;
	}
	return (Head*)ob;
}

void Head::set_status(int fstatus) {
	this->status = fstatus;
	if (parent == nullptr && status != 0) rdy = 1;
	else if (status != 0 && parent->rdy) rdy = 1;
	else set_unrdy();
}
void Head::set_unrdy() {
	status = 0;
	rdy = 0;
	for (int i = 0; i < children.size(); i++){
		children[i]->set_unrdy();
	}
}

string Head::is_rdy() {
	if (rdy == 1) return "is ready";
	return "is not ready";
}

Head* Head::find(string path){
	Head* ob = nullptr;
	if (path.length() == 1) {
		if (path == "/") ob = this;
		else if (path == ".") ob = actual;
		else ob = find_point(path, actual);
	}
	else if (path[0] == '/') {
		if (path[1] == '/') ob = lookf(path.substr(2));
		else ob = find_point(path.substr(1), this);
	}
	else ob = find_point(path, actual);
	return (Head*)ob;
}

Head* Head::find_point(string path, Head* ob) {
	int length = path.find('/');
	if (length == -1) return find_child(path, ob);
	else{
		Head* object = find_child(path.substr(0, length), ob);
		if (object == nullptr) return object;
		else return find_point(path.substr(length + 1), object);
	}
}

Head* Head::find_child(string fname, Head* object){
	Head* ob = nullptr;
	for (auto* each: object->children) {
		if (each->name == fname) {
			ob = each;
			break;
		}
	}
	return (Head*)ob;
}

int Head::get_clID(){
	return clID;
};

string Head::get_path(){
	if(!parent) return "/";
	Head* current = this;
	string path;
	while(current->parent){
		path = "/" + current->get_name() + path;
		current = current->parent;
	}
	return path;
}

void Head::set_connect(TYPE_SIGNAL fsignal, TYPE_HANDLER fhandler, Head* ftarget){
	connect* tmp = new connect(fsignal, fhandler, ftarget);
	for(connect* connect: connections){
		if((connect->signal == tmp->signal) && (connect->handler == tmp->handler) && (connect->target == tmp->target)) return;
	}
	connections.push_back(tmp);
}

void Head::delete_connect(TYPE_SIGNAL fsignal, TYPE_HANDLER fhandler, Head* ftarget){
	connect* tmp = new connect(fsignal, fhandler, ftarget);
	int pos = 0;
	for(connect* connect: connections){
		if((connect->signal == tmp->signal) && (connect->handler == tmp->handler) && (connect->target == tmp->target)) break;
		pos++;
	}
	if(pos < connections.size()) connections.erase(connections.begin() + pos);
}

void Head::emmit(TYPE_SIGNAL fsignal, string message){
	if(rdy){
		(this->*fsignal)(message);
		for(connect* connect : connections){
			if(connect->signal == fsignal && connect->target->rdy) (connect->target->*connect->handler)(message);
		}
	}
}

void Head::active(){
	status = 1;
	rdy = 1;
	for(Head* each : children){
		each->active();
	}
}
