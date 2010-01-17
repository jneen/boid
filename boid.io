#!/usr/bin/env io

Importer addSearchPath("Boid")

Boid
Range

Directory setCurrentWorkingDirectory(Boid boidDir path)

opts := System args
opts removeFirst
opts first switch(
	nil,
		"boid -h" println
	,
	"check",
		System getEnvironmentVariable("BOIDDIR") ifNil(Boid fail("BOIDDIR environment variable not set"))
		ioImportEnv := System getEnvironmentVariable("IOIMPORT")
		ioImportEnv ifNil(Boid fail("IOIMPORT environment variable not set"))
		if(ioImportEnv split(":") contains(Boid ioDir path) not, Boid fail("`#{Boid ioDir path}' not in IOIMPORT"))
		if(System getEnvironmentVariable("PATH") split(":") contains(Boid binDir path) not, Boid fail("`#{Boid binDir path}' not in PATH"))
		"ok" println
	,
	"install",
		packageSpec := opts second
		if(packageSpec isNil, Boid fail("no package spec provided"))
		Boid install(packageSpec)
	,
	"uninstall",
		packageSpec := opts second
		if(packageSpec isNil, Boid fail("no package spec provided"))
		Boid uninstall(packageSpec)
	,
	"list",
		Boid listPackages
	,
	"env",
		envCmd := opts second
		if(envCmd isNil, envCmd = "list")
		envCmd switch(
			"list",
				Boid Environment directories foreach(d,
					if(d at(".active"), "* " print)
					d name println
				)
			,
			"active",
				Boid Environment directories select(d, d at(".active")) first name println
			,
			"use",
				envName := opts third
				if(envName isNil, Boid fail("no environment name provided"))
				e := try(Boid Environment use(envName))
				e catch(BoidError, Boid fail(e error))
				"switched environment to #{envName}" interpolate println
			,
			"create",
				envName := opts third
				if(envName isNil, Boid fail("no environment name provided"))
				e := try(Boid Environment create(envName))
				e catch(BoidError, Boid fail(e error))
				"#{envName} environment created" interpolate println
			,
			"destroy",
				envName := opts third
				if(envName isNil, Boid fail("no environment name provided"))
				e := try(Boid Environment destroy(envName))
				e catch(BoidError, Boid fail(e error))
				"#{envName} environment destroyed" interpolate println
		)
)
