CFML Hat Emulator
=================

This emulator renders the dot matrix scripts, used by the CFML Hat, In a browser using CFML and JavaScript.

The files are read from the <code>/animations</code> directory. Any files saved in the folder can be called through this script.

Data is translated to XML and then called into JavaScript to render the animations frame by frame.

=To Use:=

Simply browse to the location of the <code>Emulate.cfm</code> file (Located in the <code>/emulator</code> folder) in a web browser and append <code>?animation=<em>ScriptToRender</em></code> to the end of the URL.

The URL should look similar to this: <code>http://localhost/emulator/emulate.cfm?animation=lucee</code>

There will be a few seconds of delay as the code is rendered to frames of animation, then the animation will take place of the "Rendering..." text.

=Troubleshooting:=

If the page is returned blank, try adding a new line at the end of your CFML Hat script. Due to current rendering limitations, abrupt line endings after the last row of data can throw exceptions.

Example:

Good!

00000000
This is a blank line
-> End of file

Bad!

00000000 -> End of file