"Resource/UI/SpectatorGUIHealth.res"
{
	"PlayerStatusHealthBonusImage"
	{
		"ControlName"								"ImagePanel"
		"fieldName"									"PlayerStatusHealthBonusImage"
		"xpos"										"9"
		"ypos"										"14"
		"zpos"										"-1"
		"wide"										"15"
		"tall"										"15"
		"visible"									"0"
		"enabled"									"1"
		"image"										"../hud/health_over_bg"
		"scaleImage"								"1"	
	}
	
	"PlayerStatusHealthValueTarget"
	{
		"ControlName"								"Label"
		"fieldName"									"PlayerStatusHealthValueTarget"
		"xpos"										"0"
		"ypos"										"11"
		"zpos"										"25"
		"wide"										"180"
		"tall"										"20"
		"visible"									"1"
		"enabled"									"1"
		"textAlignment"								"left"	
		"labeltext"									"%Health%"
		"font"										"m0refont18"
		"fgcolor_override"  						"Health Numbers"
	}
	
	"PlayerStatusHealthValueTargetShadow"
	{
		"ControlName"								"Label"
		"fieldName"									"PlayerStatusHealthValueTargetShadow"
		"xpos"										"-1"
		"ypos"										"-1"
		"zpos"										"25"
		"wide"										"180"
		"tall"										"20"
		"visible"									"1"
		"enabled"									"1"
		"textAlignment"								"left"	
		"labeltext"									"%Health%"
		"font"										"m0refont18"
		"fgcolor_override"  						"Black"
		
		"pin_to_sibling"							"PlayerStatusHealthValueTarget"
	}

	"PlayerStatusPlayerLevel"
	{
		"ControlName"								"CExLabel"
		"fieldName"									"PlayerStatusPlayerLevel"
		"xpos"										"10"
		"ypos"										"9"
		"zpos"										"5"
		"wide"										"12"
		"tall"										"12"
		"visible"									"0"
		"enabled"									"1"
		"textAlignment"								"center"	
		"font"										"ScoreboardVerySmall"
		"fgcolor"									"TFOrange"
	}

	
	
	
	
	//////////////////////////////////REMOVED STUFF//////////////////////////////////
	
	"PlayerStatusHealthImage"
	{
		"ControlName"								"ImagePanel"
		"fieldName"									"PlayerStatusHealthImage"
		"wide"										"0"
		"tall"										"0"
		"visible"									"0"
		"enabled"									"0"
	}
	"PlayerStatusHealthImageBG"
	{
		"ControlName"								"ImagePanel"
		"fieldName"									"PlayerStatusHealthImageBG"
		"wide"										"0"
		"tall"										"0"
		"visible"									"0"
		"enabled"									"0"
	}
	"BuildingStatusHealthImageBG"
	{
		"ControlName"								"ImagePanel"
		"fieldName"									"BuildingStatusHealthImageBG"
		"wide"										"0"
		"tall"										"0"
		"visible"									"0"
		"enabled"									"0"
	}
}