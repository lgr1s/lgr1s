#ifndef OBJ6_H
#define OBJ6_H

#include "Head.h"

class obj6 : public Head{
	public:
	obj6(Head* fparent);
	void signal(string &message);
	void handler(string &message);
};
#endif
