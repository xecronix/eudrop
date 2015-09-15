clean: 
	cd demo && rm -rf demo docs eudropper eudrop.xml extsrc README.md test Makefile
	cd demo && echo "clean: " >> Makefile
	cd demo && echo "	rm -rf demo  docs eudropper eudrop.xml extsrc README.md test" >> Makefile
