/*
 * (C) Copyright 2003
 * David Müller ELSOFT AG Switzerland. d.mueller@elsoft.ch
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

/************************************************
 * NAME	    : s3c2410.h
 * Version  : 31.3.2003
 *
 * Based on S3C2410X User's manual Rev 1.1
 ************************************************/

#ifndef __S3C6410_H__
#define __S3C6410_H__

#define S3C64X0_UART_CHANNELS	3
#define S3C64X0_SPI_CHANNELS	2

/* S3C2410 only supports 512 Byte HW ECC */
#define S3C2410_ECCSIZE		512
#define S3C2410_ECCBYTES	3

enum s3c64x0_uarts_nr {
	S3C64X0_UART0,
	S3C64X0_UART1,
	S3C64X0_UART2,
};

/* S3C2410 device base addresses */
#define S3C24X0_MEMCTL_BASE		0x48000000
#define S3C64X0_USB_HOST_BASE		0x77100000
#define S3C64X0_INTERRUPT_BASE		0x7F008900
#define S3C64X0_DMA_BASE		0x75000000
#define S3C64X0_CLOCK_POWER_BASE	0x7e00f000
#define S3C64X0_LCD_BASE		0x77100000
#define S3C6410_NAND_BASE		0x70200000
#define S3C64X0_UART_BASE		0x7F005000
#define S3C24X0_TIMER_BASE		0x51000000
#define S3C24X0_USB_DEVICE_BASE		0x52000140
#define S3C24X0_WATCHDOG_BASE		0x53000000
#define S3C64X0_I2C_BASE		0x7f004000
#define S3C64X0_I2S_BASE		0x7f002000
#define S3C64X0_GPIO_BASE		0x7f008000
#define S3C24X0_RTC_BASE		0x57000000
#define S3C6410_ADC_BASE		0x7e00b000
#define S3C64X0_SPI_BASE		0x7f00b000
#define S3C2410_SDI_BASE		0x5A000000


/* include common stuff */
#include <asm/arch/s3c64x0.h>

// Nand FLash Configure
#define NFCONF_ECC_MLC		(1<<24)

#define NFCONF_ECC_1BIT		(0<<23)
#define NFCONF_ECC_4BIT		(2<<23)
#define NFCONF_ECC_8BIT		(1<<23)

#define NFCONT_ECC_ENC		(1<<18)
#define NFCONT_WP		(1<<16)
#define NFCONT_MECCLOCK		(1<<7)
#define NFCONT_SECCLOCK		(1<<6)
#define NFCONT_INITMECC		(1<<5)
#define NFCONT_INITSECC		(1<<4)
#define NFCONT_INITECC		(NFCONT_INITMECC | NFCONT_INITSECC)
#define NFCONT_CS_ALT		(1<<1)
#define NFCONT_CS		(1<<1)
#define NFSTAT_ECCENCDONE	(1<<7)
#define NFSTAT_ECCDECDONE	(1<<6)
#define NFSTAT_RnB		(1<<0)
#define NFESTAT0_ECCBUSY	(1<<31)


static inline struct s3c24x0_memctl *s3c24x0_get_base_memctl(void)
{
	return (struct s3c24x0_memctl *)S3C24X0_MEMCTL_BASE;
}

static inline struct s3c24x0_usb_host *s3c24x0_get_base_usb_host(void)
{
	return (struct s3c24x0_usb_host *)S3C64X0_USB_HOST_BASE;
}

static inline struct s3c64x0_interrupt *s3c24x0_get_base_interrupt(void)
{
	return (struct s3c64x0_interrupt *)S3C64X0_INTERRUPT_BASE;
}

static inline struct s3c24x0_dmas *s3c24x0_get_base_dmas(void)
{
	return (struct s3c24x0_dmas *)S3C64X0_DMA_BASE;
}

static inline struct s3c24x0_clock_power *s3c24x0_get_base_clock_power(void)
{
	return (struct s3c24x0_clock_power *)S3C64X0_CLOCK_POWER_BASE;
}

static inline struct s3c24x0_lcd *s3c24x0_get_base_lcd(void)
{
	return (struct s3c24x0_lcd *)S3C64X0_LCD_BASE;
}

static inline struct s3c6410_nand *s3c6410_get_base_nand(void)
{
	return (struct s3c6410_nand *)S3C6410_NAND_BASE;
}

static inline struct s3c64x0_uart
	*s3c64x0_get_base_uart(enum s3c64x0_uarts_nr n)
{
	return (struct s3c64x0_uart *)(S3C64X0_UART_BASE + (n * 0x4000));
}

static inline struct s3c24x0_timers *s3c24x0_get_base_timers(void)
{
	return (struct s3c24x0_timers *)S3C24X0_TIMER_BASE;
}

static inline struct s3c24x0_usb_device *s3c24x0_get_base_usb_device(void)
{
	return (struct s3c24x0_usb_device *)S3C24X0_USB_DEVICE_BASE;
}

static inline struct s3c24x0_watchdog *s3c24x0_get_base_watchdog(void)
{
	return (struct s3c24x0_watchdog *)S3C24X0_WATCHDOG_BASE;
}

static inline struct s3c24x0_i2c *s3c24x0_get_base_i2c(void)
{
	return (struct s3c24x0_i2c *)S3C64X0_I2C_BASE;
}

static inline struct s3c24x0_i2s *s3c24x0_get_base_i2s(void)
{
	return (struct s3c24x0_i2s *)S3C64X0_I2S_BASE;
}

static inline struct s3c24x0_gpio *s3c24x0_get_base_gpio(void)
{
	return (struct s3c24x0_gpio *)S3C64X0_GPIO_BASE;
}

static inline struct s3c24x0_rtc *s3c24x0_get_base_rtc(void)
{
	return (struct s3c24x0_rtc *)S3C24X0_RTC_BASE;
}

static inline struct s3c2410_adc *s3c2410_get_base_adc(void)
{
	return (struct s3c2410_adc *)S3C6410_ADC_BASE;
}

static inline struct s3c24x0_spi *s3c24x0_get_base_spi(void)
{
	return (struct s3c24x0_spi *)S3C64X0_SPI_BASE;
}

static inline struct s3c24x0_sdi *s3c24x0_get_base_sdi(void)
{
	return (struct s3c24x0_sdi *)S3C2410_SDI_BASE;
}

#endif /*__S3C2410_H__*/
