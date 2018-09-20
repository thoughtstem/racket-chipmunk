/* Copyright (c) 2007 Scott Lembcke
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <stdio.h>
 
#include "chipmunk/chipmunk_private.h"
#include "ChipmunkDemo.h"

#define PLAYER_VELOCITY 500.0

#define PLAYER_GROUND_ACCEL_TIME 0.1
#define PLAYER_GROUND_ACCEL (PLAYER_VELOCITY/PLAYER_GROUND_ACCEL_TIME)

#define PLAYER_AIR_ACCEL_TIME 0.25
#define PLAYER_AIR_ACCEL (PLAYER_VELOCITY/PLAYER_AIR_ACCEL_TIME)

#define JUMP_HEIGHT 50.0
#define JUMP_BOOST_HEIGHT 55.0
#define FALL_VELOCITY 900.0
#define GRAVITY 2000.0

static cpBody *playerBody = NULL;
static cpShape *playerShape = NULL;

static cpFloat remainingBoost = 0;
static cpBool grounded = cpFalse;
static cpBool lastJumpState = cpFalse;

static void
SelectPlayerGroundNormal(cpBody *body, cpArbiter *arb, cpVect *groundNormal){
	cpVect n = cpvneg(cpArbiterGetNormal(arb));
	
	if(n.y > groundNormal->y){
		(*groundNormal) = n;
	}
}

static void
playerUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
{
  /*
	int jumpState = (ChipmunkDemoKeyboard.y > 0.0f);
	
	// Grab the grounding normal from last frame
	cpVect groundNormal = cpvzero;
	cpBodyEachArbiter(playerBody, (cpBodyArbiterIteratorFunc)SelectPlayerGroundNormal, &groundNormal);
	
	grounded = (groundNormal.y > 0.0);
	if(groundNormal.y < 0.0f) remainingBoost = 0.0f;
	
	// Do a normal-ish update
	cpBool boost = (jumpState && remainingBoost > 0.0f);
	cpVect g = (boost ? cpvzero : gravity);
	cpBodyUpdateVelocity(body, g, damping, dt);
	
	// Target horizontal speed for air/ground control
	cpFloat target_vx = PLAYER_VELOCITY*ChipmunkDemoKeyboard.x;
	
	// Update the surface velocity and friction
	// Note that the "feet" move in the opposite direction of the player.
	cpVect surface_v = cpv(-target_vx, 0.0);
	playerShape->surfaceV = surface_v;
	playerShape->u = (grounded ? PLAYER_GROUND_ACCEL/GRAVITY : 0.0);
	
	// Apply air control if not grounded
	if(!grounded){
		// Smoothly accelerate the velocity
		playerBody->v.x = cpflerpconst(playerBody->v.x, target_vx, PLAYER_AIR_ACCEL*dt);
	}
	
	body->v.y = cpfclamp(body->v.y, -FALL_VELOCITY, INFINITY);
        */

	cpBodySetVelocity(body, cpv(PLAYER_VELOCITY*ChipmunkDemoKeyboard.x,PLAYER_VELOCITY*ChipmunkDemoKeyboard.y));
}

static void
update(cpSpace *space, double dt)
{
	int jumpState = (ChipmunkDemoKeyboard.y > 0.0f);
	
	// If the jump key was just pressed this frame, jump!
	if(jumpState && !lastJumpState && grounded){
		cpFloat jump_v = cpfsqrt(2.0*JUMP_HEIGHT*GRAVITY);
		playerBody->v = cpvadd(playerBody->v, cpv(0.0, jump_v));
		
		remainingBoost = JUMP_BOOST_HEIGHT/jump_v;
	}
	
	// Step the space
	cpSpaceStep(space, dt);
	
	remainingBoost -= dt;
	lastJumpState = jumpState;

        //playerUpdateVelocity(playerBody, cpv(0.0f,0.0f), 0.0, 0.0);
}

static cpSpace *
init(void)
{
	cpSpace *space = cpSpaceNew();
	space->iterations = 10;
	space->gravity = cpv(0, -GRAVITY);

	cpBody *body, *staticBody = cpSpaceGetStaticBody(space);
	cpShape *shape;
	
	body = cpSpaceAddBody(space, cpBodyNew(1.0f, INFINITY));
	body->p = cpv(0, -200);
	body->velocity_func = playerUpdateVelocity;
	playerBody = body;

	shape = cpSpaceAddShape(space, cpBoxShapeNew2(body, cpBBNew(-15.0, -27.5, 15.0, 27.5), 10.0));
//	shape = cpSpaceAddShape(space, cpSegmentShapeNew(playerBody, cpvzero, cpv(0, 10.0), 10.0));
	shape->e = 0.0f; shape->u = 0.0f;
	shape->type = 1;
	playerShape = shape;
	
        body = cpBodyNewKinematic();
        body->p = cpv(100 + 60, -200 + 60);
        cpSpaceAddBody(space, body);//cpBodyNew(4.0f, INFINITY));
        
        shape = cpSpaceAddShape(space, cpBoxShapeNew(body, 50, 50, 0.0));
        shape->e = 0.0f; 
        shape->u = 0.7f;
	
	return space;
}

static void
destroy(cpSpace *space)
{
	ChipmunkDemoFreeSpaceChildren(space);
	cpSpaceFree(space);
}

ChipmunkDemo Player = {
	"Platformer Player Controls",
	1.0/180.0,
	init,
	update,
	ChipmunkDemoDefaultDrawImpl,
	destroy,
};
