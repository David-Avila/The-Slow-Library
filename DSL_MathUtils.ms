// Math utils

// Helper functions
globals.max 	= @mathUtil.max
globals.min 	= @mathUtil.min
globals.clamp 	= @mathUtil.clamp

globals.lerp 	= @mathUtil.lerp
globals.mt 		= @mathUtil.moveTowards

// Helpers to convert radius to degrees and viceversa
// just multiply your angle with one of these to convert
globals.deg2rad = pi / 180
globals.rad2deg = 180 / pi