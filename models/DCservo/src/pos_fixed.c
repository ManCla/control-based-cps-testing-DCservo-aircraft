#include <inttypes.h>

#define n 13
#define f11 8143 /* Q2.13 */
#define f21 2042 /* Q2.13 */
#define g1 919   /* Q2.13 */
#define g2 115   /* Q2.13 */
#define l1 26950 /* Q2.13 */
#define l2 14607 /* Q2.13 */
#define k1 16680 /* Q2.13 */
#define k2 10191 /* Q2.13 */
#define kv 26293 /* Q2.13 */

// states -- the _fix suffix is needed to avoid double declaration with 
//           floating point implementation
int16_t x1_fix = 0.0, x2_fix = 0.0, v_fix = 0.0;

int16_t pos_fixed(int16_t r, int16_t y){ 
    // sensor readings come in as function inputs
    int32_t u,e;

    u = (int16_t)(((int32_t)l2*(r-x2_fix) - (int32_t)l1*x1_fix) >> n) - v_fix;
    
    if (u > 511) 
        u = 511;
    else if (u < -512) 
        u = -512;
    //writeOutput(u);

    e = y - x2_fix;
    x2_fix = x2_fix + (int16_t) (((int32_t)f21*x1_fix + (int32_t)g2*(u+v_fix) + (int32_t)k2*e) >> n);
    x1_fix = (int16_t) (((int32_t)f11*x1_fix + (int32_t)g1*(u+v_fix) + (int32_t)k1*e) >> n);
    v_fix = v_fix + (int16_t)(((int32_t)kv*e) >> n);

	return u; // output to actuator
}