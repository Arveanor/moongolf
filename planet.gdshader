shader_type particles;

void start() {
	// Called when a particle is spawned.
	TRANSFORM[0][0] = 0.0;
	TRANSFORM[0][1] = 1.0;
	TRANSFORM[1][0] = -1.0;
	TRANSFORM[1][1] = 0.0;
}

void process() {
	// Called every frame on existing particles (according to the Fixed FPS property).
}
