#include <inttypes.h>

#define f11 0.9940
#define f21 0.2493
#define g1 0.1122
#define g2 0.0140
#define l1 3.2898
#define l2 1.7831
#define k1 2.0361
#define k2 1.2440
#define kv 3.2096

// states -- the _float suffix is needed to avoid double declaration with 
//           fixed point implementation
double x1_float = 0.0, x2_float = 0.0, v_float = 0.0;


int16_t pos_float(int16_t r, int16_t y){
    // sensor readings come in as function inputs
	double u,e;

    u = l2*((double)r-x2_float) - l1*x1_float - v_float;
    if (u > 511) 
    	u = 511.0;
    else if (u < -512) 
    	u = -512.0;
    //writeOutput(u);

    //update state
    e = (double)y - x2_float;
    x2_float = f21*x1_float + x2_float + g2*(u+v_float) + k2*e;
    x1_float = f11*x1_float            + g1*(u+v_float) + k1*e;
    v_float = v_float + kv*e;

	return u; // output to actuator
}