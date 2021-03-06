/*
This program makes two lists of prime numbers

The first list is made by a standard searching Algorithm (SSA)
The second list is made by the Cycle Searching Algorithm (CSA) - original paper attached on this reposiory

Both lists contains all prime numbers 
from the smallest one up to the 910077th one

Each list is attached to a .txt file on the diretory of the compiled code (after it runs)
List_of_prime_numbers_obtained_by_Standard_Searching.txt
List_of_prime_numbers_obtained_by_Cycle_Searching.txt

This website can be used for results analysis: https://pt.numberempire.com/13999981

This program was written in portugol programming language 
for a 1st semester Logic Progrmming graduatting course: TADS, at IFRS
(compiled on PortugolStudio - Univali) - http://lite.acad.univali.br/portugol/
*/

programa
{

	inclua biblioteca Matematica --> mt
	inclua biblioteca Tipos --> tp
	inclua biblioteca Arquivos --> arq
	inclua biblioteca Util --> ut
	
	funcao inicio()
	{

	//const inteiro n_max = 16777216				// maximum qantity a vextor can store in Portugol Studio
	const inteiro Pn_max = 2147483647				// maximum value Portugol Studio can handle
	const inteiro n_max = 14000000					// its related to the maximum quantity of variables Portugol Studio
									// can handle with tha avaliable RAN it has into the machine this pseudocode was implemented
	
	inteiro n_large_enought						// handle the C[m] loops de C[m], at STAGE_2
	inteiro m, m_max						// m belongs to the closed range [1,Pn_max]
	inteiro k							// loop iteratable variables of C[m]
	inteiro P[n_max], n=0, n_total=0, nc_total=0			// P[n] is the vector which stores prime numbers into growing order 
									// P[0]=2, P[1]=3, P[2]=5, P[3]=7 P[4]=11, ...
	inteiro PC[n_max], PNP[n_max]					// simillar to P[n], PC[n] is the vector which stores prime numbers into growing order 
									// PC[0]=2, PC[1]=3, PC[2]=5, PC[3]=7 PC[4]=11, ...
									// but calculated throught C[m]
	inteiro Eratosthenes_limit=0					// loop limit
	inteiro memory_address
	inteiro time_spent, aux_time_spent
	inteiro SSA_time_spent=0, CSA_time_spent=0 
	inteiro t, t_max=1
	inteiro verify=0, verify_C=0				
	
	real difference							// difference ratio between results from both methods
	real SSA_time_spent_average=0.0
	real CSA_time_spent_average=0.0

	logico is_it_prime						// validative variable
	logico C[n_max]							// Cn(m) - nth Cycle applyed into m values

	cadeia file_address
	cadeia word
	cadeia limbo

	para ( t=0 ; t<t_max ; t++ ) {					// Time data gathering

	//////////////////////////////////////////////////////////////////////////////////////////////
		////// Standard Searching Algorithm - SSA					//////
	//////////////////////////////////////////////////////////////////////////////////////////////	
	
//		escreva("Standard Searching Algorithm - SSA")
		
		time_spent = ut.tempo_decorrido()

		n_total = 0
		P[n_total] = 2						// the lower prime number is 2
		
									// Here, we verify if m is a prime number or not.
									// If it's a prime number, it's stored into P[n]
									// These m numbers belongs to the closed range
									// [ lowest_prime_number , biggest_prime_number_Portugol_Studio_can_handle ]
		para ( m=P[n_total]+1 ; ( (m<=Pn_max) e (n_total<n_max-1) e (m<=n_max) ) ; m++ ) {				
			is_it_prime = verdadeiro			// is m a prime number? Yes, unless we prove it wrong
	
									// Here, m will be divided by each prime number that belongs to the closed range
									// [ lowest_prime_number , root_stare_of_the_biggest_prime_number_found_so_far ]
									// until we find out m is not a prime number or m run out of the range
			Eratosthenes_limit = tp.real_para_inteiro(mt.raiz(tp.inteiro_para_real(P[n_total]),2.0))+1
			para (n=0 ; ( (n<=n_total) e (P[n]<=Eratosthenes_limit) e (is_it_prime) ) ; n++ ) {
verify++
				se (m%P[n]==0) {			// If the rest of the division m/P[n] is equal to zero, m is not a prime number
					is_it_prime = falso			
				}
			}
			se ( (is_it_prime) e (P[n_total]!=m) ) {	// If m is still a prime number here, P[n+1] = m
				n_total += 1
				P[n_total]=m
			}
			
		}
	
		aux_time_spent = ut.tempo_decorrido()
		SSA_time_spent += aux_time_spent-time_spent
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	////// Storing P[n] into a text file		 					//////
	//////////////////////////////////////////////////////////////////////////////////////////////	
	
		memory_address = arq.abrir_arquivo("List_of_prime_numbers_obtained_by_Standard_Searching.txt", 1)
		
		para ( n=0 ; n<=n_total ; n++ ) {
			word = "P[" + tp.inteiro_para_cadeia(n, 10) + "] = " + tp.inteiro_para_cadeia(P[n], 10) + "\n"
			arq.escrever_linha(word, memory_address)
		}
		arq.fechar_arquivo(memory_address)
		escreva("\nP[",n_total,"] = ",P[n_total])
//		escreva("\nTime spent into Standard Searching Pseudocode = ",time_spent)
escreva("\nQuantity of prime checking operations = ",verify)
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	////// End of the Standard Searching Algorithm						//////
	//////////////////////////////////////////////////////////////////////////////////////////////	
	
	
	
	
		
	//////////////////////////////////////////////////////////////////////////////////////////////
	////// Cycle Searching Algorithm - CSA							//////
	//////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	////// STAGE_1 - Cn[m], n = 0								//////
	//////////////////////////////////////////////////////////////////////////////////////////////
	
//		escreva("\n\nCycle Searching Algorithm - CSA")
		
		time_spent = ut.tempo_decorrido()
						
		nc_total = 0
		PC[nc_total] = 2					// PC[0] = 2						
	
		k = 1							// C[m], k = 0, made throught PC[0]
		m_max = n_max
		para ( m=0 ; m<m_max ; m++) {
			se (k<PC[nc_total]) {
				C[m] = verdadeiro			// If k is not a multiple of PC[0], C[m] = true
				k++
			}
			senao {
				C[m] = falso				// If k is a multiple of PC[0], C[m] = false
				k=1
			}	
		} 							// End of STAGE_1
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	////// STAGE_2 - Cn[m], n = 1 ~ Cn[m], n = root_square_n_max				//////
	//////////////////////////////////////////////////////////////////////////////////////////////
	
		PNP[0] = 1
	
		Eratosthenes_limit = tp.real_para_inteiro(mt.raiz(tp.inteiro_para_real(n_max),2.0))+1
		para ( n=0 ; PC[nc_total]<Eratosthenes_limit ; n++ ) {
			
	
			k=1						// List of Possible Newt Prime numbers (PNP) made throught C[m]
			m_max = n_max/PC[nc_total]+PC[nc_total]		// Recalculating the m_max value
			para ( m=PC[nc_total] ; m<m_max ; m++) {
				se (C[m]) {
					PNP[k] = m+1
					k++
				}
			} 						// End of the list of Possible Newt Prime numbers (PNP) made throught C[m]
			
			nc_total++					// "Catching the next prime number"
			PC[nc_total] = PNP[1]	
	
									// Here we assign new values to C[m], where C[m] cannot be true
			n_large_enought = n_max/PC[nc_total]+1	
			para ( k=0 ; PNP[k]<n_large_enought ; k++) {
verify_C++
				C[PNP[k]*PC[nc_total]-1] = falso	// These are the m values where m+1 cannot be a prime number
			} 						// End of new C[m] values assignment step
	
		} 							// End of STAGE_2
		//escreva("\nPC[",nc_total,"] = ",PC[nc_total])	
				
	//////////////////////////////////////////////////////////////////////////////////////////////
	////// STAGE_3	- Cn[m], n = root_square_n_max						//////
	//////////////////////////////////////////////////////////////////////////////////////////////		
		
		para ( m=PC[nc_total] ; m<n_max-1 ; m++ ) {		
			se (C[m]) {
				nc_total++
				PC[nc_total] = m+1			// If C[m] = true, m+1 is the next prime number
			}	
		} 							// End of STAGE_3
	
		aux_time_spent = ut.tempo_decorrido()
		CSA_time_spent += aux_time_spent-time_spent
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	////// Storing PC[n] into a text file	 						//////
	//////////////////////////////////////////////////////////////////////////////////////////////	
	
		memory_address = arq.abrir_arquivo("List_of_prime_numbers_obtained_by_Cycle_Searching.txt", 1)
		
		para ( n=0 ; n<=nc_total ; n++ ) {		
			word = "PC[" + tp.inteiro_para_cadeia(n, 10) + "] = " + tp.inteiro_para_cadeia(PC[n], 10) + "\n"
			arq.escrever_linha(word, memory_address)
		}
		arq.fechar_arquivo(memory_address)
		escreva("\nPC[",nc_total,"] = ",PC[nc_total])
//		escreva("\nTime spent into CSA = ",time_spent)
escreva("\nQuantity of prime checking operations = ",verify_C)
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	////// End of the Cycle Searching Algorithm 						//////
	//////////////////////////////////////////////////////////////////////////////////////////////


//*


//////////////////////////////////////////////////////////////////////////////////////////////
////// Result reseting 									//////
//////////////////////////////////////////////////////////////////////////////////////////////	

	para ( n=0 ; n<n_max ; n++) {
		P[n] = 0
		PC[n] = 0
	}

//////////////////////////////////////////////////////////////////////////////////////////////
////// End of result reseting 							  	//////
//////////////////////////////////////////////////////////////////////////////////////////////	

//*/

	} 								// End of time data gathering

/*

//////////////////////////////////////////////////////////////////////////////////////////////
////// Results comparison 								//////
//////////////////////////////////////////////////////////////////////////////////////////////	
	
	difference = 0.0
	para ( m=0 ; ( (m<nc_total) e (m<n_total) ) ; m++ ) {	
		se ( P[m] != PC[m] ) difference++
	}

	escreva("\n\n")
	escreva("The difference ratio between both methods is ",(difference/m)*100,"%")

//////////////////////////////////////////////////////////////////////////////////////////////
////// End of results comparison							//////
//////////////////////////////////////////////////////////////////////////////////////////////


*/


//////////////////////////////////////////////////////////////////////////////////////////////
////// The avarage time spent in each searching method					//////
//////////////////////////////////////////////////////////////////////////////////////////////

	SSA_time_spent_average = 1.0*SSA_time_spent/t_max
	CSA_time_spent_average = 1.0*CSA_time_spent/t_max

	escreva("\n\nThe avarage of time spent into SSA is ",SSA_time_spent_average)
	escreva("\nThe avarage of time spent into CSA is ",CSA_time_spent_average)
	escreva("\n\n")

//////////////////////////////////////////////////////////////////////////////////////////////
////// End of avarage time spent in each searching method				//////
//////////////////////////////////////////////////////////////////////////////////////////////

	} 								// End of main program
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 803; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */
