COMMENT @
	It has to be done this way, because the calling convention used in this call uses XMM0-2 and then the normal calling convention of rcx, rdx, r9, etc.
	Problem is that, in a __vectorcall, the compiler wants to use XMM0-2, and then r9 and then it starts putting parameters on the stack. __fastcall does not
	seem to want to use XMM registers at all for a call, and everything gets misaligned. The result is that nothing has a prompt to use or pickup.

	Thank you tremwil(https://github.com/tremwil) for the suggestion and the help writing the asm wrapper. It's bad because I am bad, 
	not cause tremwil told me to write it this way (just fyi :fatcat:).
@

EXTERN ExecActionButtonParamFunc :PROC
EXTERNDEF ExecuteActionButtonParamProxy :QWORD
.code
ALIGN 16

ExecActionButtonParamWrapper PROC
push rcx
push rdx
push r8
push r9
sub rsp, 58h
movaps xmmword ptr [rsp+10h],XMM0
movaps xmmword ptr [rsp+20h],XMM1
movaps xmmword ptr [rsp+30h],XMM2

mov rcx,rdx
call ExecActionButtonParamFunc
cmp al,-1
jz normal_flow
add rsp, 58h
pop r9
pop r8
pop rdx
pop rcx
ret

normal_flow:
movaps XMM0,xmmword ptr [rsp-10h]
movaps XMM1,xmmword ptr [rsp-20h]
movaps XMM2,xmmword ptr [rsp-30h]
add rsp, 58h
pop r9
pop r8
pop rdx
pop rcx
xor rax,rax
jmp [ExecuteActionButtonParamProxy]


ExecActionButtonParamWrapper ENDP

END