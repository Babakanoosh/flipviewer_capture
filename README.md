# flipviewer_capture
Autoit Version: v3.3.16.1
[AutoIt's download page](https://www.autoitscript.com/site/autoit/downloads/ "https://www.autoitscript.com/site/autoit/downloads/")

Created to capture flipviewer pages to BMP. (can also just be used to capture up to two boxed areas on the screen)

Set the top left and bottom right coordinate of the page capture area then start capturing.
Hide the cursor area magnifier to reduce program lag.
The files will be saved and the page number will go up by 1 for every page captured.
Uncheck a page box if it is not going to be captured.


How the screen coordinates are defined: X is horizonal and Y is vertical and the point of origin is the top left of the screen.

<pre>
+--------X
|
|
|
Y
</pre>


How the page capture box is defined

Top left point(#)  
<pre>
#-------------+
|             |
|             |
|             |
|             |
|             |
+-------------@
</pre>
Bottom right point (@)



Controls:
<pre>
  Shift + Alt + Q   Set point for top left of first-page/left-page
  Shift + Alt + A   Set point for bottom right of first-page/left-page

  Shift + Alt + W   Set point for top left of second-page/right-page
  Shift + Alt + S   Set point for bottom right of second-page/right-page

  Shift + Alt + E   Hide/Show cursor magnifier

  Shift + Alt + Z   Draw box of the set capture area of first/left page
  Shift + Alt + X   Draw box of the set capture area of second/right page

  Shift + Alt + C   Capture the pages
  
  ESC               Quit the program
</pre>

<br />
<br />

Example run of the program:
<br />
<img align="center" width="50%" src="/Examples/Example Run.png">
<br />
<br />
<br />
Example capture of "page 1" (Cyan box)
<br />
<img align="center" width="30%" src="/Examples/1.png">
<br />
<br />
<br />
Example capture of "page 2" (Magenta box)
<br />
<img align="center"  src="/Examples/2.png">



<br />
<br />
<br />
<br />
<br />
        


<p width="100%" align="center">
Now check it out!
<br/>
<img align="center" width="32%" src="checkit.gif">
</p>
