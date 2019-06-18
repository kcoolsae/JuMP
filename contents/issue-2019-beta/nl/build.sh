#!/bin/bash
#
cp blank.pdf.bak blank.pdf # pdfs are ignored in repository
#
# Sheet 1
#
loffice --headless --convert-to pdf:writer_pdf_Export puzzletext.odt
loffice --headless --convert-to pdf:writer_pdf_Export buzz-wire.odt
loffice --headless --convert-to pdf:writer_pdf_Export editorial.odt
#
inkscape jump1.svg -A jump1.pdf
pdfjam editorial.pdf buzz-wire.pdf --nup 1x2 --outfile page2.pdf
pdfjam puzzletext.pdf page2.pdf \
       --nup 2x1 --outfile sheet1.pdf --paper a3paper --landscape
pdftk  sheet1.pdf background jump1.pdf output result1.pdf

#
# Sheet 2 + 3
#
#
inkscape jump2.svg -A jump2.pdf
inkscape jump3.svg -A jump3.pdf
loffice --headless --convert-to pdf:writer_pdf_Export snippets.odt
loffice --headless --convert-to pdf:writer_pdf_Export physicalscratch.odt
loffice --headless --convert-to pdf:writer_pdf_Export gracehopper.odt
sleep 1 # grace hopper takes a long time to convert?

pdftk snippets.pdf blank.pdf blank.pdf gracehopper.pdf cat output stamp2.pdf
pdftk physicalscratch.pdf multistamp stamp2.pdf output joined2.pdf
#
pdfjam joined2.pdf \
       --nup 2x1 --outfile sheet2.pdf --paper a3paper --landscape
# now use stamp2.pdf for background...
pdftk jump2.pdf jump3.pdf cat output stamp2.pdf
pdftk  sheet2.pdf multibackground stamp2.pdf output result2.pdf
#

#
# Sheet 4
#
loffice --headless --convert-to pdf:writer_pdf_Export quizz.odt
loffice --headless --convert-to pdf:writer_pdf_Export dogcookie.odt
loffice --headless --convert-to pdf:writer_pdf_Export backmatter.odt
loffice --headless --convert-to pdf:writer_pdf_Export puzzlesolution.odt

inkscape jump4.svg -A jump4.pdf
pdfjam quizz.pdf backmatter.pdf dogcookie.pdf puzzlesolution.pdf \
       --nup 2x2 --outfile sheet4.pdf  --paper a3paper --landscape
#pdfjam page4.pdf blank.pdf \
#       --nup 2x1 --outfile sheet4.pdf --paper a3paper --landscape
pdftk  sheet4.pdf background jump4.pdf output result4.pdf

#
# Everything
#
pdftk result1.pdf result2.pdf result4.pdf cat output output.pdf

