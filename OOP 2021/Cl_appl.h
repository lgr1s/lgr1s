#ifndef CL_APPL_H
#define CL_APPL_H
#include "Head.h"
#include <iostream>
#include "obj2.h"
#include "obj3.h"
#include "obj4.h"
#include "obj5.h"
#include "obj6.h"



using namespace std;

class Cl_appl : public Head {

protected:
	bool build = 1;
	string nfound;

public:
	Cl_appl(Head* parent);
	void set_appl();
	void setup();
	int exec_appl();
	void exec_commands();
	void signal(string &message);
	void handler(string &message);
	void exec_new_commands();
	void set_connect();
	TYPE_SIGNAL get_signal(int ss);
	TYPE_HANDLER get_handler(int ss);
};
#endif
