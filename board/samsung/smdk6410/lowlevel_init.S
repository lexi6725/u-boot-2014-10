/*
 * Memory Setup stuff - taken from blob memsetup.S
 *
 * Copyright (C) 1999 2000 2001 Erik Mouw (J.A.K.Mouw@its.tudelft.nl) and
 *                     Jan-Derk Bakker (J.D.Bakker@its.tudelft.nl)
 *
 * Modified for the Samsung SMDK2410 by
 * (C) Copyright 2002
 * David Mueller, ELSOFT AG, <d.mueller@elsoft.ch>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */


#include <config.h>
#include <version.h>


/* some parameters for the board */

/*
 *
 * Taken from linux/arch/arm/boot/compressed/head-s3c2410.S
 *
 * Copyright (C) 2002 Samsung Electronics SW.LEE  <hitchcar@sec.samsung.com>
 *
 */

#define BWSCON	0x48000000

/* BWSCON */
#define DW8			(0x0)
#define DW16			(0x1)
#define DW32			(0x2)
#define WAIT			(0x1<<2)
#define UBLB			(0x1<<3)

#define B1_BWSCON		(DW32)
#define B2_BWSCON		(DW16)
#define B3_BWSCON		(DW16 + WAIT + UBLB)
#define B4_BWSCON		(DW16)
#define B5_BWSCON		(DW16)
#define B6_BWSCON		(DW32)
#define B7_BWSCON		(DW32)

/* BANK0CON */
#define B0_Tacs			0x0	/*  0clk */
#define B0_Tcos			0x0	/*  0clk */
#define B0_Tacc			0x7	/* 14clk */
#define B0_Tcoh			0x0	/*  0clk */
#define B0_Tah			0x0	/*  0clk */
#define B0_Tacp			0x0
#define B0_PMC			0x0	/* normal */

/* BANK1CON */
#define B1_Tacs			0x0	/*  0clk */
#define B1_Tcos			0x0	/*  0clk */
#define B1_Tacc			0x7	/* 14clk */
#define B1_Tcoh			0x0	/*  0clk */
#define B1_Tah			0x0	/*  0clk */
#define B1_Tacp			0x0
#define B1_PMC			0x0

#define B2_Tacs			0x0
#define B2_Tcos			0x0
#define B2_Tacc			0x7
#define B2_Tcoh			0x0
#define B2_Tah			0x0
#define B2_Tacp			0x0
#define B2_PMC			0x0

#define B3_Tacs			0x0	/*  0clk */
#define B3_Tcos			0x3	/*  4clk */
#define B3_Tacc			0x7	/* 14clk */
#define B3_Tcoh			0x1	/*  1clk */
#define B3_Tah			0x0	/*  0clk */
#define B3_Tacp			0x3     /*  6clk */
#define B3_PMC			0x0	/* normal */

#define B4_Tacs			0x0	/*  0clk */
#define B4_Tcos			0x0	/*  0clk */
#define B4_Tacc			0x7	/* 14clk */
#define B4_Tcoh			0x0	/*  0clk */
#define B4_Tah			0x0	/*  0clk */
#define B4_Tacp			0x0
#define B4_PMC			0x0	/* normal */

#define B5_Tacs			0x0	/*  0clk */
#define B5_Tcos			0x0	/*  0clk */
#define B5_Tacc			0x7	/* 14clk */
#define B5_Tcoh			0x0	/*  0clk */
#define B5_Tah			0x0	/*  0clk */
#define B5_Tacp			0x0
#define B5_PMC			0x0	/* normal */

#define B6_MT			0x3	/* SDRAM */
#define B6_Trcd			0x1
#define B6_SCAN			0x1	/* 9bit */

#define B7_MT			0x3	/* SDRAM */
#define B7_Trcd			0x1	/* 3clk */
#define B7_SCAN			0x1	/* 9bit */

/* REFRESH parameter */
#define REFEN			0x1	/* Refresh enable */
#define TREFMD			0x0	/* CBR(CAS before RAS)/Auto refresh */
#define Trp			0x0	/* 2clk */
#define Trc			0x3	/* 7clk */
#define Tchr			0x2	/* 3clk */
#define REFCNT			1113	/* period=15.6us, HCLK=60Mhz, (2048+1-15.6*60) */
/**************************************/

.globl lowlevel_init
lowlevel_init:
	mov r12, lr

	ldr	r0, =S3C64X0_GPIO_BASE
	ldr	r1, =0x55555555
	str	r1, [r0, #0x800]		@ GPKCON0

	ldr	r1, =0x55555555
	str	r1, [r0, #0x804]		@GPKCON1

	ldr	r1, =0x22222666
	str	r1, [r0, #0x810]		@GPLCON0

	ldr	r1, = 0x04000000
	str	r1, [r0, #0xA0]			@ GPFCON
	ldr	r1, =0x2000
	str	r1, [r0, #0xA4]			@ GPFDAT

	/* LED on only #8 */
	ldr 	r1, =0x00111111
	str	r1, [r0, #0x820]			@ GPMCON

	ldr	r1, = 0x00000555
	str	r1, [r0, #0x828]		@ GPMPUD

	ldr	r1, =0x002a
	str	r1, [r0, #0x824]		@ GPMDAT

	ldr	r1, =0
	str	r1, [r0, #0x1D4]		@ Memory Port 0 Drive strength Control Registe

	/* Disable Watchdog */
	ldr	r0, =0x7e000000		@ 0x7e004000 Watchdog cofigure register
	orr	r0, r0, #0x4000
	mov	r1, #0
	str 	r1, [r0]

	@ External Interrupt pending clear
	ldr	r0, =(S3C64X0_GPIO_BASE+0x924)	// EINTPEND
	ldr	r1, [r0]
	str 	r1, [r0]

	ldr	r0, =0x71200000			@ VIC0
	ldr	r1, =0x71300000			@ VIC1

	@ Disable all interrupts(VIC0 and VIC1)
	mvn	r3, #0x0
	str	r3, [r0, #0x14]			@ VIC0 INT MASK
	str	r3, [r1, #0x14]			@ VIC1 INT MASK

	@ Set all interrupts as IRQ
	mov	r3, #0x0
	str	r3, [r0, #0xC]				@ VIC0 INT MODE
	str	r3, [r1, #0xC]				@ VIC1 INT MODE

	@ Pending interrupt Clear
	mov r3, #0x0
	str	r3, [r0, #0xF00]			@ VIC0 INT ADDR
	str	r3, [r1, #0xF00]			@ VIC1 INT ADDR

	/*
	 * Init System Clock
	 */
	ldr	r0, =S3C64X0_CLOCK_POWER_BASE		@ 0x7e00f000

#ifdef CONIG_SYNC_MODE
	ldr	r1, [r0, #0x900]		@ SYSCON others control register
	mov	r2, #0x40
	orr	r1, r1, r2
	str	r1, [r0, #0x900]

	nop
	nop
	nop
	nop
	nop
	nop

	ldr	r2, =0x80
	orr	r1, r1, r2
	str	r1, [r0, #0x900]

check_syncack:
	ldr	r1, [r0, #0x900]
	ldr	r2, = 0xf00
	and	r1, r1, r2
	cmp	r1, #0xf00
	bne check_syncack

#else	/* ASYNC Mode */
	nop
	nop
	nop
	nop
	nop

	ldr	r1, [r0, #0x900]
	bic	r1, r1, #0xc0
	orr	r1, r1, #0x40
	str	r1, [r0, #0x900]

wait_for_async:
	ldr	r1, [r0, #0x900]
	and	r1, r1, #0xf00
	cmp	r1, #0x0
	bne wait_for_async

	ldr	r1, [r0, #0x900]
	bic	r1, r1, #0x40
	str	r1, [r0, #0x900]
#endif

	mov	r1, #0xff00
	orr	r1, r1, #0xff
	str	r1, [r0, #0]		@ APLL_LOCK
	str	r1, [r0, #0x4]		@ MPLL_LOCK
	str	r1, [r0, #0x8]		@ EPLL_LOCK
/* CLKUART(=66.5Mhz) = CLKUART_input(532/2=266Mhz) / (UART_RATIO(3)+1) */
/* CLKUART(=50Mhz) = CLKUART_input(400/2=200Mhz) / (UART_RATIO(3)+1) */
/* Now, When you use UART CLK SRC by EXT_UCLK1, We support 532MHz & 400MHz value */

#if defined(CONFIG_CLKSRC_CLKUART)
		ldr 	r1, [r0, #0x28]			@ CLK_DIV2
		bic r1, r1, #0x70000
		orr r1, r1, #0x30000
		str r1, [r0, #0x28]
#endif

	ldr   	r1, [r0, #0x20]	/*Set Clock Divider*/
	bic	r1, r1, #0x30000
	bic	r1, r1, #0xff00
	bic	r1, r1, #0xff
	ldr	r2, =CLK_DIV_VAL
	orr	r1, r1, r2
	str	r1, [r0, #0x20]

	ldr	r1, =APLL_VAL
	str	r1, [r0, #0x0C]		@ APLL CON
	ldr	r1, =MPLL_VAL
	str	r1, [r0, #0x10]		@ MPLL CON

	ldr	r1, =0x80200203			/* FOUT of EPLL is 96MHz */
	str	r1, [r0, #0x14]		@ EPLL CON0
	ldr	r1, =0x0
	str	r1, [r0, #0x18]		@ EPLL CON1

	@ CLOCK SOURCE
	ldr	r1, [r0, #0x1C]	/* APLL, MPLL, EPLL select to Fout */
	
#if defined(CONFIG_CLKSRC_CLKUART)
		ldr r2, =0x2007
#else
		ldr r2, =0x7
#endif
	orr	r1, r1, r2

	str	r1, [r0, #CLK_SRC_OFFSET]
	
	/* wait at least 200us to stablize all clock */
	mov r1, #0x10000
1:	subs	r1, r1, #1
	bne 1b
	
#ifdef CONFIG_SYNC_MODE				/* Synchronization for VIC port */
		ldr r1, [r0, #OTHERS_OFFSET]
		orr r1, r1, #0x20
		str r1, [r0, #OTHERS_OFFSET]
#else
		ldr r1, [r0, #OTHERS_OFFSET]
		bic r1, r1, #0x20
		str r1, [r0, #OTHERS_OFFSET]
#endif
	
	/* memory control configuration */
	/* make r0 relative the current location so that it */
	/* reads SMRDATA out of FLASH rather than memory ! */
	ldr     r0, =SMRDATA
	ldr	r1, =CONFIG_SYS_TEXT_BASE
	sub	r0, r0, r1
	ldr	r1, =BWSCON	/* Bus Width Status Controller */
	add     r2, r0, #13*4
0:
	ldr     r3, [r0], #4
	str     r3, [r1], #4
	cmp     r2, r0
	bne     0b

	/* everything is fine now */
	mov	pc, lr

	.ltorg
/* the literal pools origin */

SMRDATA:
    .word (0+(B1_BWSCON<<4)+(B2_BWSCON<<8)+(B3_BWSCON<<12)+(B4_BWSCON<<16)+(B5_BWSCON<<20)+(B6_BWSCON<<24)+(B7_BWSCON<<28))
    .word ((B0_Tacs<<13)+(B0_Tcos<<11)+(B0_Tacc<<8)+(B0_Tcoh<<6)+(B0_Tah<<4)+(B0_Tacp<<2)+(B0_PMC))
    .word ((B1_Tacs<<13)+(B1_Tcos<<11)+(B1_Tacc<<8)+(B1_Tcoh<<6)+(B1_Tah<<4)+(B1_Tacp<<2)+(B1_PMC))
    .word ((B2_Tacs<<13)+(B2_Tcos<<11)+(B2_Tacc<<8)+(B2_Tcoh<<6)+(B2_Tah<<4)+(B2_Tacp<<2)+(B2_PMC))
    .word ((B3_Tacs<<13)+(B3_Tcos<<11)+(B3_Tacc<<8)+(B3_Tcoh<<6)+(B3_Tah<<4)+(B3_Tacp<<2)+(B3_PMC))
    .word ((B4_Tacs<<13)+(B4_Tcos<<11)+(B4_Tacc<<8)+(B4_Tcoh<<6)+(B4_Tah<<4)+(B4_Tacp<<2)+(B4_PMC))
    .word ((B5_Tacs<<13)+(B5_Tcos<<11)+(B5_Tacc<<8)+(B5_Tcoh<<6)+(B5_Tah<<4)+(B5_Tacp<<2)+(B5_PMC))
    .word ((B6_MT<<15)+(B6_Trcd<<2)+(B6_SCAN))
    .word ((B7_MT<<15)+(B7_Trcd<<2)+(B7_SCAN))
    .word ((REFEN<<23)+(TREFMD<<22)+(Trp<<20)+(Trc<<18)+(Tchr<<16)+REFCNT)
    .word 0x32
    .word 0x30
    .word 0x30
