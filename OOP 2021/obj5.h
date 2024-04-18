#ifndef OBJ5_H
#define OBJ5_H

#include "Head.h"

class obj5 : public Head{
	public:
	obj5(Head* fparent);
	void signal(string &message);
	void handler(string &message);
};
#endif
