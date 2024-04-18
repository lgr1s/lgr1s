#include "Head.h"
#include "Cl_appl.h"

int main()
{
	Cl_appl application(nullptr);
	application.set_appl();
	return application.exec_appl();
}
