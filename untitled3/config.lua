--
-- For more information on build.settings see the Corona SDK Build Guide at:
-- https://docs.coronalabs.com/guide/distribution/buildSettings
--

settings =
{
	orientation =
	{
		-- Supported values for orientation:
		-- portrait, portraitUpsideDown, landscapeLeft, landscapeRight

		default = "portrait",
		supported = { "portrait", },
	},
	
	excludeFiles =
	{
		-- Include only the necessary icon files on each platform
		iphone = { "Icon-*dpi.png", },
		android = { "Icon.png", "Icon-Small-*.png", "Icon*@2x.png", },
	},

	win32 =
	{
		preferenceStorage = "registry",
	},

	window =
	{
		defaultMode = "normal",
	},

	--
	-- iOS Section
	--
	iphone =
	{
		plist =
		{
			UIStatusBarHidden = false,
			UIPrerenderedIcon = true, -- set to false for "shine" overlay
			--UIApplicationExitsOnSuspend = true, -- uncomment to quit app on suspend

			CFBundleIconFiles =
			{
				"Icon.png",
				"Icon@2x.png",
				"Icon-167.png",
				"Icon-60.png",
				"Icon-60@2x.png",
				"Icon-60@3x.png",
				"Icon-72.png",
				"Icon-72@2x.png",
				"Icon-76.png",
				"Icon-76@2x.png",
				"Icon-Small.png",
				"Icon-Small@2x.png",
				"Icon-Small@3x.png",
				"Icon-Small-40.png",
				"Icon-Small-40@2x.png",
				"Icon-Small-50.png",
				"Icon-Small-50@2x.png",
			},
		},
	},
	
	--
	-- Android Section
	--
	android =
	{
		usesPermissions =
		{
			"android.permission.INTERNET",
		},
	},
}
