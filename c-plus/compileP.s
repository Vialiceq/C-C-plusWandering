	.file	"compileP.c"
	.text
	.globl	_swap
	.def	_swap;	.scl	2;	.type	32;	.endef
_swap:
LFB0:
	.cfi_startproc															
	pushl	%ebx    		// 被调用者 压栈保存 %ebx内容    %esp->28+4=32
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	//其中 x->%edx  , y->%eax
	movl	8(%esp), %edx	//-32+8=-24 即&a ->%edx
	movl	12(%esp), %eax   //-32+12=-20 , &b=2 ->%eax
	movl	(%edx), %ecx	//16 ->ecx
	movl	(%eax), %ebx	//12->ebx
	movl	%ebx, (%edx)	// 12->edx
	movl	%ecx, (%eax)	//16->eax
	popl	%ebx		//出栈 恢复ebx内容
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
*********************************** memery imiage*****************
**bottom***********stack

111111111	0   (relative position of stack)
1		1	
1		1
1		1
1	1	1	-4	 (<----esp   51 line  
1		1
1		1
1		1
1	2	1	-8	(<----esp   52  line
1		1
1		1
  .....
1		1
1		1
1 2addr 1	-20
1		1
1		1
1		1
1 1addr	1	-24   <----esp   49
1		1     
1		1      
1		1	

***top*************stack          
************************************************************

LFE0:
	.globl	_z
	.def	_z;	.scl	2;	.type	32;	.endef
_z:
LFB1:
	.cfi_startproc
	subl	$24, %esp  	//开辟esp 栈空间												1111111
	.cfi_def_cfa_offset 28

	//***int a,b 
	movl	$1, 20(%esp)    //1->a  ,4byte to int a			(-4	esp				
	movl	$2, 16(%esp)	//2->b							(-8	esp
	
	//**** swap func 
	leal	16(%esp), %eax  //栈指针24->16    b addr ->%eax
	movl	%eax, 4(%esp)	//  b addr ->-20

	leal	20(%esp), %eax
	movl	%eax, (%esp)     //a addr -->-24

	call	_swap		//转swap函数  --》5   esp->24+4=28   swap func结束时 esp-->28-4
	addl	$24, %esp // 释放 stack
	.cfi_def_cfa_offset 4
	ret					//返回
	.cfi_endproc
LFE1:
	.ident	"GCC: (i686-posix-dwarf-rev0, Built by MinGW-W64 project) 8.1.0"
