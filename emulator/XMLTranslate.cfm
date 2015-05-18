<cfcontent type="application/xml; charset=UTF-8">
<cfscript>

// Global Variables
fileLocation = url.script;
animationFile = FileOpen("../animations/#fileLocation#", "read"); 
readFile = FileRead(animationFile); 
matchedFile = REReplace(readFile, "frame\W", "<frame>", "ALL");
storedData = REMatch("[0-9A-Za-z]*[0-9A-Za-z]\W", readFile);
parentPackagerBool = "";
parentPackagerStart = "";
parentPackagerStop = "";
lineCounter = 0;
lineCount = 0;

//Start of the XML framework
WriteOutput("<animation>");
for (key in storedData) {
	
	// Convert "Loop" parameter to XML
	if (trim(key) == "loop") {
	key = REReplace(key, "[a-zA-Z]*[A-Za-z][[:space:]]", "<header>#key#</header>", "ALL");
	parentPackagerStart = "<loopCount>";
	parentPackagerStop = "</loopCount>";
	lineCount = 1;
	lineCounter = lineCount;
	}
	
	// Convert "Delay" parameter to XML
	if (trim(key) == "delay") {
	key = REReplace(key, "[a-zA-Z]*[A-Za-z][[:space:]]", "<header>#key#</header>", "ALL");
	parentPackagerStart = "<delayTime>";
	parentPackagerStop = "</delayTime>";
	lineCount = 1;
	lineCounter = lineCount;
	}
	
	// Convert frames to XML format
	if (trim(key) == "frame") {
	key = REReplace(key, "frame", "<header>#key#</header>", "ALL");
	parentPackagerStart = "<frame>";
	parentPackagerStop = "</frame>";
	lineCount = 8;
	lineCounter = lineCount;
	}
	
	if (lineCount > 0) {
		// If statement to check if the #key# variable is numeric (See If it is a XML header, or data)
		if (IsNumeric(key)) {
			key = REReplace(key, "[0-9]*[0-9]\W", "<value>#key#</value>", "ALL");
			parentPackagerBool = 0;
			lineCounter = lineCounter - 1;
		} else {
			parentPackagerBool = 1;
		}
		
		// If the #key# variable is a header, and if the line is the first line of the XML child, then apply the #partentPackagerStart#
		if (parentPackagerBool == 1 && lineCount == lineCounter) {
			WriteOutput(parentPackagerStart);
		}
		WriteOutput(key);
		
		// If the #key# variable is a data (<value>) value, and if the line is the last line of the XML child, then apply the #partentPackagerStop# to the end.
		if (parentPackagerBool == 0 && lineCounter == 0) {
			WriteOutput(parentPackagerStop);
		}
	}
}
// Close the XML framework
WriteOutput("</animation>");
FileClose(animationFile);
</cfscript>