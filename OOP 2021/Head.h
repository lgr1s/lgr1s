#ifndef HEAD_H
#define HEAD_H
#include <string>
#include <vector>
#include <iostream>

using namespace std;

class Head;

typedef void (Head::*TYPE_SIGNAL)(string&);
typedef void (Head::*TYPE_HANDLER)(string&);

#define SIGNAL_D(signal_f)(TYPE_SIGNAL)(&signal_f);
#define HANDLER_D(signal_f)(TYPE_HANDLER)(&signal_f);

class Head{
	protected:
		vector<Head*> children;
		Head* parent;
		string name;
		int status = 0;
		bool rdy = 0;
		Head* actual;
		int clID = 0;
		struct connect{
			TYPE_SIGNAL signal;
			TYPE_HANDLER handler;
			Head* target;
			connect(TYPE_SIGNAL fsignal, TYPE_HANDLER fhandler, Head* ftarget){
				signal = fsignal;
				handler = fhandler;
				target = ftarget;
			}
		};
		vector <connect*> connections;

	public:
		Head(Head* fparent);
		string is_rdy();
		string get_name();
		Head* get_parent();
		void set_name(string fname);
		void set_parent(Head* fparent);
		void show(int step);
		void show_full(int step);
		void new_child(Head* child, string fname);
		void set_status(int fstatus);
		void set_unrdy();
		Head* lookf (string fname);
		Head* find(string path);
		Head* find_point(string path, Head* ob);
		Head* find_child(string fname, Head* object);
		int get_clID();
		string get_path();
		void set_connect(TYPE_SIGNAL fsignal, TYPE_HANDLER fhandler, Head* ftarget);
		void delete_connect(TYPE_SIGNAL fsignal, TYPE_HANDLER fhandler, Head* ftarget);
		void emmit(TYPE_SIGNAL fsignal, string message);
		void active();
};
#endif
