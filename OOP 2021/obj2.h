#ifndef OBJ2_H
#define OBJ2_H

#include "Head.h"

class obj2 : public Head{
	public:
	obj2(Head* fparent);
	void signal(string &message);
	void handler(string &message);
};
#endif
