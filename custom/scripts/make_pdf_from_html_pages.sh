sudo apt-get install wget htmldoc 
wget -r -D taskjuggler.org -np -p -k -nc http://www.taskjuggler.org/tj3/manual/ 
cd www.taskjuggler.org/tj3/manual/ 
mkdir toc 
mv toc.html toc/ 
htmldoc --size a4 -f tj3_manual.pdf --webpage toc/toc.html *.html 
mv tj3_manual.pdf ../../../ 
cd .. 
cd .. 
cd .. 
rm -r www.taskjuggler.org 