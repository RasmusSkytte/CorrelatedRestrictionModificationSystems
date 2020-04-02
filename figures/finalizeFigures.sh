# Figure 2
cp Illustrations/fig2a.png Figure_2/fig2a.png
cp Illustrations/fig2f.png Figure_2/fig2f.png
#
convert Figure_2/fig2a.png -flatten Figure_2/fig2a.png
convert Figure_2/fig2f.png -flatten Figure_2/fig2f.png
#
convert Figure_2/fig2a.png   -gravity northwest -stroke none -fill black -pointsize 64 -annotate +0-10    A Figure_2/Fig2a.png
convert Figure_2/fig2b.tif   -gravity northwest -stroke none -fill black -pointsize 64 -annotate +0-10    B Figure_2/Fig2b.tif
convert Figure_2/fig2cde.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +0-10    C Figure_2/Fig2cde.tif
convert Figure_2/fig2cde.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +575-10  D Figure_2/Fig2cde.tif
convert Figure_2/fig2cde.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +1150-10 E Figure_2/Fig2cde.tif
convert Figure_2/fig2f.png   -gravity northwest -stroke none -fill black -pointsize 64 -annotate +0-10    F Figure_2/Fig2f.png
convert Figure_2/fig2gh.tif  -gravity northwest -stroke none -fill black -pointsize 64 -annotate +0-10    G Figure_2/Fig2gh.tif
convert Figure_2/fig2gh.tif  -gravity northwest -stroke none -fill black -pointsize 64 -annotate +780-10  H Figure_2/Fig2gh.tif
#
convert Figure_2/fig2a.png  Figure_2/fig2b.tif   +append Figure_2/fig2ab.tif
convert Figure_2/fig2ab.tif Figure_2/fig2cde.tif -append Figure_2/fig2abcde.tif
convert Figure_2/fig2f.png  Figure_2/fig2gh.tif  -append Figure_2/fig2fgh.tif
#
convert Figure_2/fig2abcde.tif  -pointsize 64 -fill white -background grey40 label:'Evolutionary dynamics' +swap -gravity West -append Figure_2/fig2abcde.tif
convert Figure_2/fig2fgh.tif    -pointsize 64 -fill white -background grey40 label:'Explanation'           +swap -gravity West -append Figure_2/fig2fgh.tif
#
convert Figure_2/fig2abcde.tif  Figure_2/fig2fgh.tif  -append Figure_2/fig2.tif
#
rm Figure_2/fig2a.png
rm Figure_2/fig2b.tif
rm Figure_2/fig2cde.tif
rm Figure_2/fig2f.png
rm Figure_2/fig2gh.tif
#
rm Figure_2/fig2ab.tif
rm Figure_2/fig2abcde.tif
rm Figure_2/fig2fgh.tif
#
# Figure 3
convert Figure_3/fig3.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +50+0  A Figure_3/fig3.tif
convert Figure_3/fig3.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +915+0 B Figure_3/fig3.tif
#
# Figure 4
convert Figure_4/fig4.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +70+0    A Figure_4/fig4.tif
convert Figure_4/fig4.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +70+580  B Figure_4/fig4.tif
convert Figure_4/fig4.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +850+0   C Figure_4/fig4.tif
convert Figure_4/fig4.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +850+445 D Figure_4/fig4.tif
#
# Figure 5
convert Figure_5/fig5abc.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +25+40   A Figure_5/fig5abc.tif
convert Figure_5/fig5abc.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +590+40  B Figure_5/fig5abc.tif
convert Figure_5/fig5abc.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +1160+40 C Figure_5/fig5abc.tif
#
convert Figure_5/fig5def.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +25+40   D Figure_5/fig5def.tif
convert Figure_5/fig5def.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +590+40  E Figure_5/fig5def.tif
convert Figure_5/fig5def.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +1170+40 F Figure_5/fig5def.tif
#
convert Figure_5/fig5abc.tif  Figure_5/fig5def.tif  -append Figure_5/fig5.tif
#
rm Figure_5/fig5abc.tif
rm Figure_5/fig5def.tif
#
# Figure S1
convert Figure_S1/figS1.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +50+0  A Figure_S1/figS1.tif
convert Figure_S1/figS1.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +915+0 B Figure_S1/figS1.tif
#
# Figure S2
convert Figure_S2/figS2ab.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +25+0  A Figure_S2/figS2ab.tif
convert Figure_S2/figS2ab.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +890+0 B Figure_S2/figS2ab.tif
#
convert Figure_S2/figS2cd.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +25+0  C Figure_S2/figS2cd.tif
convert Figure_S2/figS2cd.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +890+0 D Figure_S2/figS2cd.tif
#
convert Figure_S2/figS2efg.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +10-10   E Figure_S2/FigS2efg.tif
convert Figure_S2/figS2efg.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +580-10  F Figure_S2/FigS2efg.tif
convert Figure_S2/figS2efg.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +1145-10 G Figure_S2/FigS2efg.tif
#
convert Figure_S2/figS2ab.tif  Figure_S2/figS2cd.tif Figure_S2/figS2efg.tif  -append Figure_S2/figS2.tif
#
rm Figure_S2/figS2ab.tif
rm Figure_S2/figS2cd.tif
rm Figure_S2/figS2efg.tif
#
# Figure S3
convert Figure_S3/figS3.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +35+40   A Figure_S3/figS3.tif
convert Figure_S3/figS3.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +625+40  B Figure_S3/figS3.tif
convert Figure_S3/figS3.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +1200+40 C Figure_S3/figS3.tif
#
# Figure S4
convert Figure_S4/figS4ab.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +35+0  A Figure_S4/figS4ab.tif
convert Figure_S4/figS4ab.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +890+0 B Figure_S4/figS4ab.tif
#
convert Figure_S4/figS4cde.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +10-10   C Figure_S4/FigS4cde.tif
convert Figure_S4/figS4cde.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +580-10  D Figure_S4/FigS4cde.tif
convert Figure_S4/figS4cde.tif -gravity northwest -stroke none -fill black -pointsize 64 -annotate +1150-10 E Figure_S4/FigS4cde.tif
#
convert Figure_S4/figS4ab.tif  Figure_S4/figS4cde.tif -append Figure_S4/figS4.tif
#
rm Figure_S4/figS4ab.tif
rm Figure_S4/figS4cde.tif
#