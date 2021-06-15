AREA iki,DATA,READWRITE
	
	
	length EQU 6 //ARRAY Uzunlugu
	array1 DCD 12,11,13,5,6,7
		
AREA bir,CODE,READONLY
	ENTRY

	LDR R0,=array1
	LDR R1,=length
    // R0 = Array location
    // R1 = Array length
	//LSL kaydirma operatörü
    PUSH    {R2-R12,LR}         // Stack e push et
    CMP     R1, #1              // dizinin boyutu 0 veya 1 ise döndur
    BLE     hsort_done
    CMP     R1, #2              // dizinin boyutu 2 ise gerekirse swap (degis)
    BLE     hsort_simple
    MOV     R11, #1             // R11 = 1 
    MOV     R12, #2             // R12 = 2 
    MOV     R10, #-1            // R10 = -1 (temp)
    UDIV    R10, R1, R12        // R10 = (len / 2) - 1 (start heapify index)
    SUB     R10, R10, #1
    SUB     R9, R1, #1          // R9 = len - 1 (start pop index)
    MOV     R2, R10             // R2 = Starting heapify index
heapify
    // R2 = Index
    MOV     R3, R2              // R3 = en büyük deger indeksi
    MLA     R4, R2, R12, R11    // R4 = Left index (2i+1)
    MLA     R5, R2, R12, R12    // R5 = Right index (2i+2)
    LDR     R6, [R0, R2, LSL#2] // R6 = Index degeri (R0 + (R2 * 4))
    MOV     R7, R6              // R7 = simdiki en buyuk deger
heapify_check_left
    CMP     R4, R9              // sol dügümün dizi s1n1rlar1 1çerisinde olup olmad1g1na bakar
    BGT     heapify_check_right // degilse sag duyume bakar
    LDR     R8, [R0, R4, LSL#2] // R8 = Left value (R0 + (R4 * 4)
    CMP     R8, R7              // Soldaki degeri en buyuk degerle kars1lastirir
    BLE     heapify_check_right // If left <= largest check right
    MOV     R3, R4              // If left > largest, en buyuk 1ndeks1 degis degeri kopyalar
    MOV     R7, R8             
heapify_check_right
    CMP     R5, R9              // sag duyumun d1z1 sinirlari içerisinde olup olmadigini kontrol eder
    BGT     heapify_swap        // deg1lse  swap den devam eder
    LDR     R8, [R0, R5, LSL#2] // R8 = Right value (R0 + (R5 * 4))
    CMP     R8, R7              // sag degeri en buyuk degerle kars1last1r1r
    BLE     heapify_swap        // If right <= largest devam eder
    MOV     R3, R5              // If right > largest, en buyuk deger deg1s1r 
    MOV     R7, R8              
heapify_swap
    CMP     R2, R3              // en buyuk baslang1c degeri olup olmad1g1n1 kontrol eder
    BEQ     heapify_next        // oyleyse y1g1n olupturma dongusunden cik
    STR     R7, [R0, R2, LSL#2] // Degilse, en büyük ve ilk degerleri degistir
    STR     R6, [R0, R3, LSL#2]
    MOV     R2, R3              //    en buyuk indexi degistir
    B       heapify             //    kaydet
heapify_next
    CMP     R10, #0             // son index s1f1r ise y1g1n biter
    BEQ     heapify_pop
    SUB     R10, R10, #1        // deg1lse next index
    MOV     R2, R10
    B       heapify
heapify_pop
    LDR     R3, [R0]            // R3 = Largest value (y1g1n1n önü)
    LDR     R4, [R0, R9, LSL#2] // R4 = Value from end of heap
    STR     R3, [R0, R9, LSL#2] // Yigin sonunda en büyük degeri depolar
    STR     R4, [R0]            // Yigin baslangicinda bitis degerini saklar
    SUB     R9, #1              //y1g1n1n sonunu azalt1r
    CMP     R9, #1              // yaln1z 2 oge kald1ysa kars1last1r
    BEQ     hsort_simple
    MOV     R2, #0              // Aksi takdirde, yiginin basindan yiginlar
    B       heapify
hsort_simple
    //iki deger kald1g1nda
    LDR     R2, [R0]            // ilk deger
    LDR     R3, [R0, #4]        // ikinci deger
    CMP     R2, R3              // degerleri kars1last1r
    STR     R3, [R0]            // hatal1ysa degis
    STR     R2, [R0, #4]
hsort_done
    POP     {R2-R12,PC}         // Return
	POP     {R2-R12,PC}
	POP     {R2-R12,PC}
	POP     {R2-R12,PC}
	POP     {R2-R12,PC}
	POP     {R2-R12,PC}
	
	END
		