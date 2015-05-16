<script>
var animation = getParameterByName('animation');
xmlhttp=new XMLHttpRequest();
xmlhttp.open("GET","XMLTranslate.cfm?script=" + animation, false);
xmlhttp.send();
xmlDoc=xmlhttp.responseXML;
counter=0;
frameCount=0;
frames="";
loops=0;
delayTime=xmlDoc.getElementsByTagName("animation")[0].getElementsByTagName("delayTime")[0].getElementsByTagName("value")[0].childNodes[0].nodeValue;

// Check to see if a "loop" is defined
if (typeof(xmlDoc.getElementsByTagName("animation")[0].getElementsByTagName("loopCount")[0]) != "undefined") {
	document.write("Number of loops: " + xmlDoc.getElementsByTagName("animation")[0].getElementsByTagName("loopCount")[0].getElementsByTagName("value")[0].childNodes[0].nodeValue + "<br />");
	loops = parseInt(xmlDoc.getElementsByTagName("animation")[0].getElementsByTagName("loopCount")[0].getElementsByTagName("value")[0].childNodes[0].nodeValue);
	frameCount = xmlDoc.getElementsByTagName("animation")[0].childNodes.length - 2;
} else {
	frameCount = xmlDoc.getElementsByTagName("animation")[0].childNodes.length - 1;
}
document.write("Delay in MS: " + delayTime + "<br />");
document.write("Number of frames: " + frameCount + "<br />");
window.onload = function() {
	document.getElementById('frames').innerHTML ="<h1>Rendering...</h1>";
}
var j = 0
function loopLoop () {
	setTimeout(function () {
		var i = 0;                     

		function frameLoop () {          
		   setTimeout(function () {    
				var a=i;
				setTimeout(callback(a), delayTime);
			  i++;                     
			  if (i < frameCount) {
				 frameLoop(); 
			  }        
		   }, delayTime);
		}
		j++;
		frameLoop();                 
		if (j < loops) {  
			loopLoop();  
		}
	}, delayTime * frameCount);
}

loopLoop();
	
function callback(a){
    return function(){
		for (z=0; z < 8; z++) {
    	//document.write(xmlDoc.getElementsByTagName("animation")[0].getElementsByTagName("frame")[a].getElementsByTagName("value")[z].childNodes[0].nodeValue + "<br />");
		frames+= xmlDoc.getElementsByTagName("animation")[0].getElementsByTagName("frame")[a].getElementsByTagName("value")[z].childNodes[0].nodeValue + "<br />";
		}
		frames = frames.replace(/0/gi, "<div style='width: 50px; height: 50px; background-color: #000; display: inline-block;'></div>");
		frames = frames.replace(/1/gi, "<div style='width: 50px; height: 50px; background-color: #f00; display: inline-block;'></div>");
		document.getElementById('frames').innerHTML = frames;
		frames = "";
		//document.write("<br />");
    }
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
</script>

<div id="frames"></div>