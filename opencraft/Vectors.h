// TODO: #pragma once

#ifndef LWTK_VEC_H
#define LWTK_VEC_H 1
#include "Core.h"
#include "Constants.h"
CC_BEGIN_HEADER

typedef struct CC_ALIGNED(4) { float x, y; } vec2;
typedef struct CC_ALIGNED(4) { float x, y, z; } vec3;
typedef struct CC_ALIGNED(4) { int x, y, z; } vec3i;

struct CC_ALIGNED(4) Vec4 { float x, y, z, w; };

struct CC_ALIGNED(32) Matrix {
	struct Vec4 row1, row2, row3, row4;
};

#define Matrix_IdentityValue \
{ \
	{ 1.0f, 0.0f, 0.0f, 0.0f }, \
	{ 0.0f, 1.0f, 0.0f, 0.0f }, \
	{ 0.0f, 0.0f, 1.0f, 0.0f }, \
	{ 0.0f, 0.0f, 0.0f, 1.0f }  \
}

/* Identity matrix. (A * Identity = A) */
extern const struct Matrix Matrix_Identity;

/* Returns a vector with all components set to Int32_MaxValue. */
static CC_INLINE vec3i IVec3_MaxValue(void) {
	vec3i v = { Int32_MaxValue, Int32_MaxValue, Int32_MaxValue }; return v;
}
static CC_INLINE vec3 Vec3_BigPos(void) {
	vec3 v = { 1e25f, 1e25f, 1e25f }; return v;
}

static CC_INLINE vec3 Vec3_Create3(float x, float y, float z) {
	vec3 v; v.x = x; v.y = y; v.z = z; return v;
}

/**
 * Set the x, y and z components of this 3d vector to the supplied values.
 */
#define Vec3_Set(self, X, Y, Z) (self).x = X; (self).y = Y; (self.z) = Z;

/* Whether all components of a 3D vector are 0 */
#define Vec3_IsZero(v) ((v).x == 0 && (v).y == 0 && (v).z == 0)

/* Returns the squared length of the vector. */
/* Squared length can be used for comparison, to avoid a costly sqrt() */
/* However, you must sqrt() this when adding lengths. */
static CC_INLINE float Vec3_LengthSquared(const vec3* v) {
	return v->x * v->x + v->y * v->y + v->z * v->z;
}
/* Adds components of two vectors together. */
static CC_INLINE void Vec3_Add(vec3* result, const vec3* a, const vec3* b) {
	result->x = a->x + b->x; result->y = a->y + b->y; result->z = a->z + b->z;
}
/* Adds a value to each component of a vector. */
static CC_INLINE void Vec3_Add1(vec3* result, const vec3* a, float b) {
	result->x = a->x + b; result->y = a->y + b; result->z = a->z + b;
}
/* Subtracts components of two vectors from each other. */
static CC_INLINE void Vec3_Sub(vec3* result, const vec3* a, const vec3* b) {
	result->x = a->x - b->x; result->y = a->y - b->y; result->z = a->z - b->z;
}
/* Mulitplies each component of a vector by a value. */
static CC_INLINE void Vec3_Mul1(vec3* result, const vec3* a, float b) {
	result->x = a->x * b; result->y = a->y * b; result->z = a->z * b;
}
/* Multiplies components of two vectors together. */
static CC_INLINE void Vec3_Mul3(vec3* result, const vec3* a, const vec3* b) {
	result->x = a->x * b->x; result->y = a->y * b->y; result->z = a->z * b->z;
}
/* Negates the components of a vector. */
static CC_INLINE void Vec3_Negate(vec3* result, vec3* a) {
	result->x = -a->x; result->y = -a->y; result->z = -a->z;
}

#define Vec3_AddBy(dst, value) Vec3_Add(dst, dst, value)
#define Vec3_SubBy(dst, value) Vec3_Sub(dst, dst, value)
#define Vec3_Mul1By(dst, value) Vec3_Mul1(dst, dst, value)
#define Vec3_Mul3By(dst, value) Vec3_Mul3(dst, dst, value)

/* Linearly interpolates components of two vectors. */
void Vec3_Lerp(vec3* result, const vec3* a, const vec3* b, float blend);
/* Scales all components of a vector to lie in [-1, 1] */
void Vec3_Normalise(vec3* v);

/* Transforms a vector by the given matrix. */
void Vec3_Transform(vec3* result, const vec3* a, const struct Matrix* mat);
/* Same as Vec3_Transform, but faster since X and Z are assumed as 0. */
void Vec3_TransformY(vec3* result, float y, const struct Matrix* mat);

vec3 Vec3_RotateX(vec3 v, float angle);
vec3 Vec3_RotateY(vec3 v, float angle);
vec3 Vec3_RotateY3(float x, float y, float z, float angle);
vec3 Vec3_RotateZ(vec3 v, float angle);

/* Whether all of the components of the two vectors are equal. */
static CC_INLINE cc_bool Vec3_Equals(const vec3* a, const vec3* b) {
	return a->x == b->x && a->y == b->y && a->z == b->z;
}

void IVec3_Floor(vec3i* result, const vec3* a);
void IVec3_ToVec3(vec3* result, const vec3i* a);
void IVec3_Min(vec3i* result, const vec3i* a, const vec3i* b);
void IVec3_Max(vec3i* result, const vec3i* a, const vec3i* b);

/* Returns a normalised vector facing in the direction described by the given yaw and pitch. */
vec3 Vec3_GetDirVector(float yawRad, float pitchRad);
/* Returns the yaw and pitch of the given direction vector.
NOTE: This is not an identity function. Returned pitch is always within [-90, 90] degrees.*/
/*void Vec3_GetHeading(Vector3 dir, float* yawRad, float* pitchRad);*/

/* Returns a matrix representing a counter-clockwise rotation around X axis. */
CC_API void Matrix_RotateX(struct Matrix* result, float angle);
/* Returns a matrix representing a counter-clockwise rotation around Y axis. */
CC_API void Matrix_RotateY(struct Matrix* result, float angle);
/* Returns a matrix representing a counter-clockwise rotation around Z axis. */
CC_API void Matrix_RotateZ(struct Matrix* result, float angle);
/* Returns a matrix representing a translation to the given coordinates. */
CC_API void Matrix_Translate(struct Matrix* result, float x, float y, float z);
/* Returns a matrix representing a scaling by the given factors. */
CC_API void Matrix_Scale(struct Matrix* result, float x, float y, float z);

#define Matrix_MulBy(dst, right) Matrix_Mul(dst, dst, right)
/* Multiplies two matrices together. */
/* NOTE: result can be the same pointer as left or right. */
CC_API void Matrix_Mul(struct Matrix* result, const struct Matrix* left, const struct Matrix* right);

void Matrix_LookRot(struct Matrix* result, vec3 pos, vec2 rot);

#define FRUSTUM_OUTSIDE     0x00
#define FRUSTUM_ON_OR_IN    0x01

/* Tests whether the given sphere lies outside any of the clipping planes */
int  Frustum_TestSphere(float x, float y, float z, float radius);
/* Calculates the clipping planes from the combined modelview and projection matrices */
/* Matrix_Mul(&clip, modelView, projection); */
void Frustum_CalcPlanes(struct Matrix* clip);

CC_END_HEADER
#endif // LWTK_VEC_H
