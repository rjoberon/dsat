
#include <stdio.h>
#include <stdlib.h>

void toVier (int a);

int main () {
	int a;

	//scanf ("%i", &a);

	//toVier(a);

        printf ("Alt Rehse      4569378.0  5931202.0"); 
	toVier(4569378); toVier(5931202); toVier(45693780); toVier(59312020);
	printf ("\n");
	printf ("Alt Schwerin   4515537.0  5931490.0"); 
	toVier(4515537); toVier(5931490); toVier(45155370); toVier(59314900);
	printf ("\n");
	printf ("Alt Schönau    4540284.0  5940145.0"); 
	toVier(4540284); toVier(5940145); toVier(45402840); toVier(59401450);
	printf ("\n");
	printf ("Alt Sührkow    4534473.0  5964256.0"); 
	toVier(4534473); toVier(5964256); toVier(45344730); toVier(59642560); 
	printf ("\n");
	printf ("Alt Tucheband  4662321.0  5828176.0"); 
	toVier(4662321); toVier(5828176); toVier(46623210); toVier(58281760);
	printf ("\n");
	printf ("Alt Zauche     4633275.0  5757712.0"); 
	toVier(4633275); toVier(5757712); toVier(46332750); toVier(57577120);
	printf ("\n");
	printf ("Alt Zeschdorf  4659984.0  5815654.0"); 
	toVier(4659984); toVier(5815654); toVier(46599840); toVier(58156540);
	printf ("\n");
	

	return EXIT_SUCCESS;
}




void toVier (int a) {
	
     	if (a > 0xffffff) {
  	  printf ("%i %i %i %i / ", (a/24)%256, (a/16)%256, (a/256)%256, a%256);	}
	if (a > 0xffff && a <= 0xffffff) {
  	  printf ("0 %i %i %i / ", (a/16)%256, (a/256)%256, a%256);
	}
	if (a > 0xff && a <= 0xffff) {
  	  printf ("0 0 %i %i / ", (a/256)%256, a%256);
	}
	if (a <= 0xff) {
  	  printf ("0 0 0 %i / ", a%256);
	}
}	
	
