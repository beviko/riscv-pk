OUTPUT_ARCH( "riscv" )
ENTRY( _start )

SECTIONS
{
  /* Trusted bootloader is invoked via a function call at the base of its segment! */

  . = (0x80000000);
  _start = .;

  /* A special HTIF region to communicate with the host */
  . = 0x80000000;
  //.htif ALIGN(0x1000) (NOLOAD) : {
  //  *(.htif.fromhost)
  //  *(.htif.tohost)
  //}
  //. = ALIGN(0x1000);


  /* Reserve some space for M-mode stacks (handled by ROT) */
  .m_stacks (NOLOAD) : {
    *(.mstacks)
  }

  ASSERT (( . <= 0x80002000), "HTIF and Stacks overlap with the bootloader!")


  /* trusted (but authenticated) boot loader in DRAM */
  . = 0x80002000;
  .bootloader : {
    PROVIDE(bootloader_ptr = .);
    *(.bootloader)
  }
  ASSERT (( . == 0x80002000 + 131072), "Bootloader segment is of incorrect size :(")

  . = (0x80002000 + 131072);

  /* Security monitor's keys */
  .sm_header : {
    PROVIDE(PK_D = .);
    . += 32;

    PROVIDE(SM_H = .);
    . += 64;

    PROVIDE(PK_SM = .);
    . += 32;

    PROVIDE(SK_SM = .);
    . += 64;

    PROVIDE(SM_SIG = .);
    . += 64;

    PROVIDE(sm_size = .);
    QUAD( SIZEOF(.sm) );
  }

  . = ALIGN(0x1000);

  /* Security monitor */
  .sm : {
    PROVIDE(sm_ptr = .);
    _ftext = .;
    *(.text.init)
    *(.text)
    *(.text.*)
    *(.gnu.linkonce.t.*)
  }

  /* rodata: Read-only data */
  .rodata : 
  {
    *(.rdata)
    *(.rodata)
    *(.rodata.*)
    *(.gnu.linkonce.r.*)
//  *(.got)
//  *(.got*)
  }

  /* End of code and read-only segment */
  PROVIDE( etext = . );
  _etext = .;

  /*--------------------------------------------------------------------*/
  /* HTIF, isolated onto separate page                                  */
  /*--------------------------------------------------------------------*/
	/*
  . = ALIGN(0x1000);
  .htif :
  {
    *(.htif)
  }
  . = ALIGN(0x1000);
  */

  /*--------------------------------------------------------------------*/
  /* Initialized data segment                                           */
  /*--------------------------------------------------------------------*/

  /* Start of initialized data segment */
  . = ALIGN(16);
   _fdata = .;

  /* data: Writable data */
  .data : 
  {
    *(.data)
    *(.data.*)
    *(.srodata*)
    *(.gnu.linkonce.d.*)
    *(.comment)
  }

  /* End of initialized data segment */
  . = ALIGN(4);
  PROVIDE( edata = . );
  _edata = .;

  /*--------------------------------------------------------------------*/
  /* Uninitialized data segment                                         */
  /*--------------------------------------------------------------------*/

  /* Start of uninitialized data segment */
  . = .;
  _fbss = .;

  /* sbss: Uninitialized writeable small data section */
  . = .;

  /* bss: Uninitialized writeable data section */
  . = .;
  _bss_start = .;
  .bss : 
  {
    *(.bss)
    *(.bss.*)
    *(.sbss*)
    *(.gnu.linkonce.b.*)
    *(COMMON)
  }

  .sbi :
  {
    *(.sbi)

    /* payload provides its own alignment and _idpt_start symbol */
    *(.idpt)
  }

  .payload :
  {
    *(.payload)
  }

  _end = .;
}
