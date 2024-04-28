bank $1f
if expandPRG
bank $3f
endif
base $E000




; boomerang rotate speed
boomerangRotateSpeed = 6
org $efe8
    db boomerangRotateSpeed
	
if $ > $ffef
    error not enough space for custom code ({format:05x:$})
endif	