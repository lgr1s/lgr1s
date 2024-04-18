This porject was done in 2021 as a course work for OOP in Russian Technological University MIREA


INTRODUCTION
This course work examines the process of creating a program that implements the construction of a hierarchical tree of objects.
The system is assembled from objects belonging to certain classes. Object names are unique. 
The program implements various methods of interaction with tree objects, for example, object readiness. Readiness is set for each object individually. 
A system of signals and handlers was also implemented for the interaction of objects with each other outside the communication circuit. 
Along with the signal transmission, a lot of data is also transmitted. A one-to-many object interaction scheme has been implemented. 
It is possible to access any system object from the current object. 
A method has been implemented to obtain a pointer to any object in the object hierarchy tree according to the path.

FORMULATION OF THE PROBLEM
Implementation of signals and handlers

To organize the interaction of objects outside the interconnection scheme, the mechanism of signals and handlers is used. 
Along with the signal transmission, a certain amount of data is also transmitted. 
The mechanism of signals and handlers implements a one-to-many object interaction scheme.

Implement a mechanism for interaction of objects using signals and handlers, transmitting a text message (string variable) together with the signal.
To organize the relationship between signals and handlers, add three methods to the base class:
1. Establishing a connection between the signal of the current object and the handler of the target object;
2. Removing (breaking) the connection between the signal of the current object and the handler of the target object;
3. Issuing a signal from the current object with passing a string variable. An enabled object can produce or process a signal.
To the connection setup method, pass a pointer to the current object's signal method, a pointer to the target object, and a pointer to the target object's handler method.
To the method of deleting (breaking) a connection, pass a pointer to the signal method of the current object, a pointer to the target object, and a pointer to the handler method of the target object.

Pass a pointer to the signal method and a string variable to the signal issuing method. In this method, implement the algorithm:

1. Calling the signal method, passing a string variable by reference.
2. Loop through all signal-handler connections of the current object.
    2.1. If the next signal-handler connection involves a signal method passed by parameter, then call the handler method of the next target object and pass a string variable by value as an argument.
3. End of the cycle.

To cast a pointer to a signal method and a handler method, use a parameterized preprocessor macro definition.
Add a method for determining the absolute path to the current object to the base class. This method returns the absolute path of the current object.
The composition and hierarchy of objects is built by entering initial data.
The system contains objects of six classes with numbers: 1,2,3,4,5,6. The class of the root object corresponds to number 1. In each derived class, implement one signal method and one handler method.
Each newline signal method outputs:
Signal from "absolute object coordinate"
Each signal method adds the membership class number of the current object to the text string passed as a parameter in the form:
"space"(class: "class number")
Each handler method prints on a new line:
Signal to “absolute object coordinate” Text: “passed string”

Implement the system operation algorithm:

1. In the system construction method:
    1.1. Constructing an object hierarchy tree according to the input.
    1.2. Input and construction of a set of signal-processor connections for given pairs of objects.
2. In the system testing method:
    2.1. Bring all objects into a state of readiness.
    2.2. Loop until input completion sign.
         2.2.1. Entering the object name and message text.
         2.2.2. Calls a signal from a given object and passes as an argument a string variable containing the text of the message.
    2.3. End of the cycle.
  
We assume that all input data is entered syntactically correctly. Control of the correctness of input data can be implemented for self-monitoring of program operation.
Unspecified but necessary functions and class elements are added by the developer


DESCRIPTION OF THE INPUT DATA
In the system construction method.
A set of objects, their characteristics and location on the hierarchy tree. The data structure for input is as set out in version No. 3 of the course work.
After entering the composition of the hierarchy tree, enter line by line:
“coordinate of the object issuing the signal” “coordinate of the target object”
Entering information for building connections ends with a line that contains
end_of_connections

In the method of launching (working out) the system.
Many commands are entered line by line in derivative order:
EMIT “object coordinate” “text” - issue a signal from an object specified by coordinate;
SET_CONNECT “coordinate of the object issuing the signal” “coordinate of the target object” - establishing a connection;
DELETE_CONNECT “coordinate of the object issuing the signal” “coordinate of the target object” - deleting a connection;
SET_CONDITION “object coordinate” “state value” - setting the object’s state.
END – end the functioning of the system (program execution).
The END command is required.
If the coordinate of an object is specified incorrectly, the corresponding operation is not performed and an error message is displayed on a new line.
If an object is not found by coordinate:
Object “object coordinate” not found
If the target object is not found by coordinate:
Handler object “target object coordinate” not found


Example input
appls_root
/object_s1 3
/object_s2 2
/object_s2 object_s4 4
/object_s13 5
/object_s2 object_s6 6
/object_s1 object_s7 2
endtree
/object_s2/object_s4 /object_s2/object_s6
/object_s2 /object_s1/object_s7
//object_s2/object_s4
/object_s2/object_s4/
end_of_connections
EMIT /object_s2/object_s4 Send message 1
DELETE_CONNECT /object_s2/object_s4 /
EMIT /object_s2/object_s4 Send message 2
SET_CONDITION /object_s2/object_s4 0
EMIT /object_s2/object_s4 Send message 3
SET_CONNECT /object_s1 /object_s2/object_s6
EMIT /object_s1 Send message 4
END

First line:
Object tree
From the second line, display the hierarchy of the constructed tree.
Next, line by line, if the signal method worked:
Signal from "absolute object coordinate"

If the handler method worked:
Signal to “absolute object coordinate” Text: “passed string”


Example output
Object tree
appls_root
     object_s1
         object_s7
     object_s2
         object_s4
         object_s6
     object_s13
Signal from /object_s2/object_s4
Signal to /object_s2/object_s6 Text: Send message 1 (class: 4)
Signal to / Text: Send message 1 (class: 4)
Signal from /object_s2/object_s4
Signal to /object_s2/object_s6 Text: Send message 2 (class: 4)
Signal from /object_s1
Signal to /object_s2/object_s6 Text: Send message 4 (class: 3)
