local metadata =
{
	plugin =
	{
		format = 'staticLibrary',
		staticLibs = {
			'plugin_bugsnag',
			"c++",
			"z"
		},
		frameworks = { 
			'Bugsnag'
		},
		usesSwift = true
	},
}



return metadata
