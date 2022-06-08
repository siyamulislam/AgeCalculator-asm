include 'emu8086.inc'
.model small
.stack 100h 
.data 


cd2 db ?
cd1 db ?

cm2 db ? 
cm1 db ?           ;current date 

cy4 db ?
cy3 db ?
cy2 db ?
cy1 db ?
 
 
bd2 db ?
bd1 db ?

bm2 db ?
bm1 db ?            ;Birth date

by4 db ?
by3 db ?
by2 db ?
by1 db ?


md2 db ?
md1 db ?

mmm2 db ?           ;Calculated AGE
mmm1 db ?

my4 db ?
my3 db ?
my2 db ?
my1 db ?


td2 db ?
td1 db ?

tm2 db ?           ;Temp. veriable
tm1 db ?

ty4 db ?
ty3 db ?
ty2 db ?
ty1 db ?



.code

main proc
    
    mov ax, @data
    mov ds, ax
    
    printn " ~ - _ Wellcome To _ - ~"
    printn "* * * Age Calculator * * *"
    printn "-   -   -   -   -   -   -"
    print  "Current  Date:"
    
    mov ah, 1
    int 21h
    sub al, 48                ;User input current date from user
    mov cd2, al               ;Store current date in temp ver.
    mov td2, al
    
    
    int 21h
    sub al, 48 
    mov cd1, al
    mov td1, al
    print "/"
    
    int 21h
    sub al, 48 
    mov cm2, al
    mov tm2, al
    
    int 21h 
    sub al, 48
    mov cm1, al
    mov tm1, al 
    print "/"
    
    int 21h  
    sub al, 48
    mov cy4, al
    mov ty4, al
    
    int 21h
    sub al, 48 
    mov cy3, al
    mov ty3, al
    
    int 21h 
    sub al, 48
    mov cy2, al
    mov ty2, al
    
    int 21h 
    sub al, 48
    mov cy1, al
    mov ty1, al
    
    printn 
     
     
    Response:                          ;User choise opton
    call set_current_date
    printn " Press 1 for Calculate Age"
    printn " Press 0 for Exit"
    mov ah, 1 
    ResponseAgain:
    print " Waiting For Your Response:"
    int 21h
    sub al, 48
    cmp al, 1
    je Execute
    cmp al, 0
    je Exit
    
    printn
    printn
    printn "Wrong Choice!!"
    printn "Try Again!"
    printn
    jmp ResponseAgain
    
    
    
    Execute:
    Printn
    Printn  
    printn "Enter Your Birth Date..."
    
    mov ah, 1
    takeDay:                ;input Day
    print " Day     : "
    int 21h
    mov bd2, al
    int 21h
    mov bd1, al
    sub bd2, 48           
    sub bd1, 48       ;convert asci value to decimal 
    printn
        
        
    mov bl, bd2
    cmp bl, 3
    jg  errorDay
    jge checkd2
    jmp takeMonth 
    checkd2:              ;Check Error Day
    mov bl, bd1
    cmp bl, 1
    jg errorDay 
    jmp takeMonth
    
    errorDay:
    printn "Error!! Day can not be over than 31"
    jmp takeDay
       
       
    takeMonth:
    print " Month   : "         ;User input BirthMonth
    int 21h
    mov bm2, al
    int 21h
    mov bm1, al
    sub bm2, 48              ;convert asci value to decimal 
    sub bm1, 48
    printn 
    
    mov bl, bm2
    cmp bl, 1
    jg  errorMonth
    jge checkm2
    jmp takeYear 
    checkm2:              ;Check Error month
    mov bl, bm1
    cmp bl, 2
    jg errorMonth 
    jmp takeYear
    
    errorMonth:
    printn "Error!! Month can not be over than 12"
    jmp takeMonth
       
       
    takeYear:

    print " Year    : "      ;Input Year
    int 21h
    mov by4, al
    int 21h
    mov by3, al
    int 21h
    mov by2, al
    int 21h
    mov by1, al 
    sub by4, 48           
    sub by3, 48
    sub by2, 48           
    sub by1, 48
    printn
    
               
     
    mov bl, by4
    cmp bl, cy4
    jg  errorYear
    jge checkY3
    jmp CalculateAGE 
    checkY3:              ;Check Error year
    mov bl, by3
    cmp bl, cy3
    jg errorYear
    jge checkY2  
    jmp CalculateAGE
    
    checkY2:
    mov bl, by2
    cmp bl, cy2 
    jg  errorYear
    jge checkY1
    jmp CalculateAGE
    
    checkY1:
    mov bl, by1
    cmp bl, cy1
    jg errorYear 
    jmp CalculateAGE
    
    errorYear:
    printn "Error!! BirthYear can not be over than CurrentYear"
    jmp takeYear               
   
    
    
    
    CalculateAGE:
    mov bl, cd2
    cmp bl, bd2        ;compare cd2 & bd2
     
    je check_bd1        ;compare currentDay to BirthDay   
    jl fix_day
    jg cal_day
    
    
    check_bd1:
    mov bl, cd1         
    cmp bl, bd1
    
    jl fix_day         ;compare cd1 & bd1
    je cal_day
    jg cal_day
    
    
    fix_day:
    
    add cd2, 3         ;add 30days  for current day is less than birthday 
   
   
    call decrement      ; decrement currentMonth if currentDay is less than BirthDay
                                            
    jmp cal_day 
         
    cal_day:
             
    mov bl, cd1
    cmp bl, bd1
    jl l1
    sub bl, bd1
    mov md1, bl
    jmp next
                             
    l1:
    add bl, 10          ;subtract Current date - Birth day
    sub bl, bd1
    mov md1, bl
    inc bd2
    
    next: 
    mov bl, cd2
    
    sub bl, bd2
    mov md2, bl
                   
              
                      
                       ;calculation of month 
    
     
    mov bl, cm2
    cmp bl, bm2
     
    je check_bm1       ;compare currentMonth to BirthMonth 
    jl fix_mn
    jg cal_mn
    
    
    check_bm1:
    mov bl, cm1         
    cmp bl, bm1
    
    jl fix_mn         ;compare cm1 & bm1
    je cal_mn
    jg cal_mn
    
    
    fix_mn:
    
    mov bl, 1
    mov cl, 2

    
    add cl, cm1
                
                
    cmp cl, 10
    jge lll1
    mov cm1, cl       ;add 12 months,  if current month  is less than birth month
    jmp next3
    
    lll1:
    sub cl, 10
    inc bl
    mov cm1, cl
    
    next3: 
    add bl, cm2
    mov cm2, bl
    
    
    call decrement_cyr           ; decrement currentYear if currentMonth is less than BirthMonth

                                            
    jmp cal_mn 
         
    cal_mn:
             
    mov bl, cm1
    cmp bl, bm1
    jl l2
    sub bl, bm1
    mov mmm1, bl
    jmp next4
                             
    l2:
    add bl, 10          ;subtract current Month - birth month
    sub bl, bm1
    mov mmm1, bl
    inc bm2
    
    next4: 
    mov bl, cm2
    
    sub bl, bm2
    mov mmm2, bl  
     
     
                   ;calculation of year
                   
                   
      
    mov bl, cy1
    cmp bl, by1
    jl tt1				
    sub bl, by1
    mov my1, bl 
    jmp test02
    tt1:
    add bl, 10
    sub bl, by1
    mov my1, bl
    inc by2			;Subtraction CurrentYear- BirthYear
    
    test02:
    mov bl, cy2
    cmp bl, by2
    jl tt2
    sub bl, by2
    mov my2, bl
    jmp test03
    tt2:
    add bl, 10
    sub bl, by2
    mov my2, bl
    inc by3
    
    test03:
    mov bl, cy3
    cmp bl, by3
    jl tt3
    sub bl, by3
    mov my3, bl
    jmp test04
    tt3:
    add bl, 10
    sub bl, by3
    mov my3, bl
    inc by4
    
    test04:
    mov bl, cy4
    cmp bl, by4
    jl tt4

    
    sub bl, by4
    mov my4, bl
    jmp complete_yr
    tt4:
    printn "Invailed input year!!"
    printn
    jmp return 
    
    complete_yr:               
    
    
    printn
    printn    
    print "Your Age: " 
     
           
    mov ah,2
    printn
    printn
    add md1, 48
    add md2, 48
    add mmm1, 48
    add mmm2, 48
    add my4, 48
    add my3, 48
    add my2, 48
    add my1, 48
    
                            
    
    
    mov dl, my4
    int 21h                  ;Print main age   Year
    mov dl, my3
    int 21h
    mov dl, my2
    int 21h
    mov dl, my1
    int 21h
    print " Year,  "
    
    
    mov dl, mmm2             ;Print main age   Month
    int 21h                 
    mov dl, mmm1
    int 21h
    print " Month,  "
    
     
    mov dl, md2             ;Print main age   Day 
    int 21h                 
    mov dl, md1
    int 21h 
    print " Day" 
    
    printn
    Printn 
    
    return:
    
   jmp Response
             
   
   
    Exit:
    
    mov ah, 00
    mov al, 02
    int 10h
    
    
    Printn 
    Printn    "     ----------------------------------------"
    Printn    "     |                                      |" 
    Printn    "     |                                      |"
    Printn    "     |         Thank You! Very Much!        |" 
    Printn    "     |                                      |"
    Printn    "     |                                      |"
    Printn    "     |                                      |"  
    Printn    "     ----------------------------------------"  
    
    mov ax, 4ch
    int 21h             ;end program 
    main endp 
    
    
    
    
       decrement proc
        
        
        mov bl, 1
        mov cl, 0
        cmp bl, cm1
        jg ll1
        sub cm1, bl
        jmp next2              ;decrement function
                             ;decrement CurrentMonth
      ll1:
        add cm1, 10
        sub cm1, bl
        inc cl
    
        next2: 
        sub cm2, cl
       
                             
        ret
        
       endp decrement
      
       
       decrement_cyr proc 
        
        mov bl, 1
        mov bh, 0
        mov cl, 0
        mov ch, 0             ;decrement CurrentYear
        
        cmp bl, cy1
        jg t1
        sub cy1, bl
        jmp case2
        t1:
        add cy1, 10
        sub cy1, bl
        inc bh
        
        case2:
        cmp bh, cy2
        jg t2
        sub cy2, bh
        jmp case3
        t2:
        add cy2, 10
        sub cy2, bh
        inc cl
        
        case3:
        cmp cl, cy3
        jg t3
        sub cy3, cl
        jmp case4
        t3:
        add cy3, 10
        sub cy3, cl
        inc ch
        
        case4:
        cmp ch, cy4
        jg t4
        sub cy4, ch
        jmp complete 
        t4:
        add cy4, 10
        sub cy4, ch
        
        complete: 
        
        ret
       
       endp decrement_cyr
       
       set_current_date proc
        
        mov bl, td2          ;Reset CurrentDate from Temp. for next Calculation
        mov cd2, bl
        mov bl, td1
        mov cd1, bl
        
        mov bl, tm2
        mov cm2, bl
        mov bl, tm1
        mov cm1, bl
        
        mov bl, ty4
        mov cy4, bl
        mov bl, ty3
        mov cy3, bl
        mov bl, ty2
        mov cy2, bl
        mov bl, ty1
        mov cy1, bl
        
        
        ret
        endp set_current_date
       
       
          
           
      endp main  
      
      
      
