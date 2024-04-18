#ifndef OBJ3_H
#define OBJ3_H

#include "Head.h"

class obj3 : public Head{
	public:
	obj3(Head* fparent);
	void signal(string &message);
	void handler(string &message);
};
#endif
