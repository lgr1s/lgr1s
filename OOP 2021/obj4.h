#ifndef OBJ4_H
#define OBJ4_H

#include "Head.h"

class obj4 : public Head{
	public:
	obj4(Head* fparent);
	void signal(string &message);
	void handler(string &message);
};
#endif
