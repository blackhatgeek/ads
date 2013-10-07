/* Pocet spravnych uzavorkovani pro N zavorek
je urcen Catalanovym cislem C_n, ktere lze vypocitat 
rekurentne:
           C_0=1; C_{n}=C_{n-1}*2*(2*n-1)/(n+1),
           kde n je N/2.
Pro zadavane N>42 se vysledek nevejde do unsigned long int.
*/
#include<stdio.h>
main()
{
      int i,N,citatel;
      unsigned long int vysledek;
      
      fscanf(stdin,"%d",&N);
     
      if((N<1) || (N%2)) 
        { fprintf(stdout,"%d",0); 
        return 0; }
        
     
      
         
         N=N/2; 
         if (N<=17)
         {
                   vysledek=1; citatel=1;
                   for (i=3; i<=N+1; i++)
                   {citatel=citatel+2;
          
                   vysledek=vysledek*2*citatel/i;
                   
                   }      
          } 
          else        
         switch (N) 
         {
         case 18: vysledek=477638700UL; break;
         case 19: vysledek=1767263190UL; break;
                           
         otherwise: vysledek=0;
                   
          }//switch
         
         fprintf(stdout,"%u",vysledek);
         
         //scanf("%d",&i);
      
      
     return 0; 
}
