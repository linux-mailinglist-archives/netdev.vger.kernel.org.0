Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890952877D1
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgJHPrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:47:03 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53917 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJHPrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:47:01 -0400
Received: from localhost.localdomain ([192.30.34.233]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MPXQi-1k43QB2O4A-00Mekq; Thu, 08 Oct 2020 17:46:26 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] ARM: remove ebsa110 platform
Date:   Thu,  8 Oct 2020 17:45:59 +0200
Message-Id: <20201008154601.1901004-2-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201008154601.1901004-1-arnd@arndb.de>
References: <20201008154601.1901004-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:XrfHJ8EUvJ7+ifVUEj+V5dXfZKPJJ2IJqgGutsBY4jjiUtMlPj5
 qLweypuLHqH0E9g3maXJ9XNxYjddu04OwjfwwzNcQCGZsIx/YR2Sfui4XC/kq7gxbKEmmz0
 B5Avr55lwVPNr8P4KEB8iVR8o+Z9SThyD6EmLNX9H28FZ7XK//Ni5/GiWog+GR+8yYKEyHv
 4ipj/cg9VNqJtDLtqSKlw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:f2NPxX3gi9I=:X7Tg7spAM+PVYspRHD39GJ
 aoEAsv7Zu/wdkvkwGAeDUbhK+dcxwWP/BZcmm8+zBD3LtO31X2o125a++ZuPRVzkEXSQVFhy9
 BNAGfvQewyI40ci3SI+vq0ozCxFGBo7pQa7YEvx30opbe0M2qeYERrQQs987TdPZW+LLbdDrv
 GOKfWIuraSNo2rSMmvRtJV+tyePrWBA2UG2yCV/dOa1kKI/bMSeZ4291RRdKG5agFsAjv7GVW
 JvuYmzxLJHe9KJdjN+444CAO3ukFzUEDP5CYAx8sHh5jKXdmNC0cPDqUaVh85c+xHGQDAMNUE
 nmqii3Fn2s7gxsCsmxGxv26tBLQXayABrqWsBXZ34XDUrvlKQvZwbLJqVqNrFVQ+rbTRw0ZrA
 rfrU6MGn7tiMk4BtV/sfOCP+QZY3BWkO8kPzbuy6Qe7Fzv6x5xoKgh4pF1AJUgpesb663GCko
 lqtZZidFrW9L3hervImNaOjhHofPfziClO/QXgRe8Wz5CnrWMBeVFNEdYigxqpOSOXa8qKtAf
 wX9nBYY8S7VnkAYC6NYoty9DbjJgezi5Fer2LPBGCLHj9swho5MdRhzHAAb7KioBPGp3ucFsX
 NHnu4m30hXKZL/Q0Z7GIDhWlq89QGnf6ad5WnWXH7QStwK1DQBsVD58D0nZL+GK/Iyan0Gx81
 pwmJLDqW9JwcJfkShh0//SfbqQ2O0h7kJe4MKDlBuGeDzFeGmGBmcDjhaYz2iSBNqcjgUMoj2
 tkE9b6r4p/p9oUT1KWlFtabnsmE1FyuiBhFISWC9LGqI9JcxwASsNicMdFXGzeMhmSbOki4Hq
 QkWqgWGSKmtihRHiy4lr7eiY013QmO9CNril3UnEUbJ6Xea6oQJ4orc06TAHlipTeJ22kOK
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell said that he is no longer using this machine, and it seems that
nobody else has in a long time, so it's time to say goodbye to it.

As this is the last platform using CONFIG_ARCH_USES_GETTIMEOFFSET,
there are some follow-up patches to remove that as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS                                   |   8 -
 arch/arm/Kconfig                              |  24 +-
 arch/arm/Kconfig.debug                        |   6 +-
 arch/arm/Makefile                             |   8 -
 arch/arm/configs/ebsa110_defconfig            |  74 ---
 arch/arm/kernel/Makefile                      |   6 +-
 arch/arm/mach-ebsa110/Makefile                |   8 -
 arch/arm/mach-ebsa110/Makefile.boot           |   5 -
 arch/arm/mach-ebsa110/core.c                  | 323 -------------
 arch/arm/mach-ebsa110/core.h                  |  38 --
 .../mach-ebsa110/include/mach/entry-macro.S   |  33 --
 arch/arm/mach-ebsa110/include/mach/hardware.h |  21 -
 arch/arm/mach-ebsa110/include/mach/io.h       |  89 ----
 arch/arm/mach-ebsa110/include/mach/irqs.h     |  17 -
 arch/arm/mach-ebsa110/include/mach/memory.h   |  22 -
 .../mach-ebsa110/include/mach/uncompress.h    |  41 --
 arch/arm/mach-ebsa110/io.c                    | 440 ------------------
 arch/arm/mach-ebsa110/leds.c                  |  71 ---
 18 files changed, 6 insertions(+), 1228 deletions(-)
 delete mode 100644 arch/arm/configs/ebsa110_defconfig
 delete mode 100644 arch/arm/mach-ebsa110/Makefile
 delete mode 100644 arch/arm/mach-ebsa110/Makefile.boot
 delete mode 100644 arch/arm/mach-ebsa110/core.c
 delete mode 100644 arch/arm/mach-ebsa110/core.h
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/io.h
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/memory.h
 delete mode 100644 arch/arm/mach-ebsa110/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-ebsa110/io.c
 delete mode 100644 arch/arm/mach-ebsa110/leds.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 0d0862b19ce5..6096b16cac12 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1809,14 +1809,6 @@ F:	drivers/firmware/turris-mox-rwtm.c
 F:	drivers/gpio/gpio-moxtet.c
 F:	include/linux/moxtet.h
 
-ARM/EBSA110 MACHINE SUPPORT
-M:	Russell King <linux@armlinux.org.uk>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-W:	http://www.armlinux.org.uk/
-F:	arch/arm/mach-ebsa110/
-F:	drivers/net/ethernet/amd/am79c961a.*
-
 ARM/ENERGY MICRO (SILICON LABS) EFM32 SUPPORT
 M:	Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
 R:	Pengutronix Kernel Team <kernel@pengutronix.de>
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e00d94b16658..a14266667bcd 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -264,8 +264,7 @@ config PHYS_OFFSET
 	hex "Physical address of main memory" if MMU
 	depends on !ARM_PATCH_PHYS_VIRT
 	default DRAM_BASE if !MMU
-	default 0x00000000 if ARCH_EBSA110 || \
-			ARCH_FOOTBRIDGE || \
+	default 0x00000000 if ARCH_FOOTBRIDGE || \
 			ARCH_INTEGRATOR || \
 			ARCH_REALVIEW
 	default 0x10000000 if ARCH_OMAP1 || ARCH_RPC
@@ -341,20 +340,6 @@ config ARM_SINGLE_ARMV7M
 	select SPARSE_IRQ
 	select USE_OF
 
-config ARCH_EBSA110
-	bool "EBSA-110"
-	select ARCH_USES_GETTIMEOFFSET
-	select CPU_SA110
-	select ISA
-	select NEED_MACH_IO_H
-	select NEED_MACH_MEMORY_H
-	select NO_IOPORT_MAP
-	help
-	  This is an evaluation board for the StrongARM processor available
-	  from Digital. It has limited hardware on-board, including an
-	  Ethernet interface, two PCMCIA sockets, two serial ports and a
-	  parallel port.
-
 config ARCH_EP93XX
 	bool "EP93xx-based"
 	select ARCH_SPARSEMEM_ENABLE
@@ -1372,7 +1357,6 @@ config ARCH_NR_GPIO
 
 config HZ_FIXED
 	int
-	default 200 if ARCH_EBSA110
 	default 128 if SOC_AT91RM9200
 	default 0
 
@@ -1588,9 +1572,7 @@ config FORCE_MAX_ZONEORDER
 	  a value of 11 means that the largest free memory block is 2^10 pages.
 
 config ALIGNMENT_TRAP
-	bool
-	depends on CPU_CP15_MMU
-	default y if !ARCH_EBSA110
+	def_bool CPU_CP15_MMU
 	select HAVE_PROC_CPU if PROC_FS
 	help
 	  ARM processors cannot fetch/store information which is not
@@ -1799,7 +1781,7 @@ config CMDLINE
 	string "Default kernel command string"
 	default ""
 	help
-	  On some architectures (EBSA110 and CATS), there is currently no way
+	  On some architectures (e.g. CATS), there is currently no way
 	  for the boot loader to pass arguments to the kernel. For these
 	  architectures, you should supply some command-line options at build
 	  time by entering them here. As a minimum, you should specify the
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 80000a66a4e3..48e13a7c694b 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1610,7 +1610,7 @@ config DEBUG_UART_PL01X
 
 # Compatibility options for 8250
 config DEBUG_UART_8250
-	def_bool ARCH_EBSA110 || ARCH_IOP32X || ARCH_IXP4XX || ARCH_RPC
+	def_bool ARCH_IOP32X || ARCH_IXP4XX || ARCH_RPC
 
 config DEBUG_UART_PHYS
 	hex "Physical base address of debug UART"
@@ -1713,7 +1713,6 @@ config DEBUG_UART_PHYS
 	default 0xe8008000 if DEBUG_R7S72100_SCIF2 || DEBUG_R7S9210_SCIF2
 	default 0xe8009000 if DEBUG_R7S9210_SCIF4
 	default 0xf0000000 if DEBUG_DIGICOLOR_UA0
-	default 0xf0000be0 if ARCH_EBSA110
 	default 0xf1012000 if DEBUG_MVEBU_UART0_ALTERNATE
 	default 0xf1012100 if DEBUG_MVEBU_UART1_ALTERNATE
 	default 0xf7fc9000 if DEBUG_BERLIN_UART
@@ -1760,7 +1759,6 @@ config DEBUG_UART_VIRT
 	default 0xc8821000 if DEBUG_RV1108_UART1
 	default 0xc8912000 if DEBUG_RV1108_UART0
 	default 0xe0010fe0 if ARCH_RPC
-	default 0xf0000be0 if ARCH_EBSA110
 	default 0xf0010000 if DEBUG_ASM9260_UART
 	default 0xf0100000 if DEBUG_DIGICOLOR_UA0
 	default 0xf01fb000 if DEBUG_NOMADIK_UART
@@ -1896,7 +1894,7 @@ config DEBUG_UART_8250_PALMCHIP
 config DEBUG_UART_8250_FLOW_CONTROL
 	bool "Enable flow control for 8250 UART"
 	depends on DEBUG_LL_UART_8250 || DEBUG_UART_8250
-	default y if ARCH_EBSA110 || DEBUG_FOOTBRIDGE_COM1 || DEBUG_GEMINI || ARCH_RPC
+	default y if DEBUG_FOOTBRIDGE_COM1 || DEBUG_GEMINI || ARCH_RPC
 
 config DEBUG_UNCOMPRESS
 	bool "Enable decompressor debugging via DEBUG_LL output"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 4e877354515f..ec150cf06729 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -169,7 +169,6 @@ machine-$(CONFIG_ARCH_CNS3XXX)		+= cns3xxx
 machine-$(CONFIG_ARCH_DAVINCI)		+= davinci
 machine-$(CONFIG_ARCH_DIGICOLOR)	+= digicolor
 machine-$(CONFIG_ARCH_DOVE)		+= dove
-machine-$(CONFIG_ARCH_EBSA110)		+= ebsa110
 machine-$(CONFIG_ARCH_EFM32)		+= efm32
 machine-$(CONFIG_ARCH_EP93XX)		+= ep93xx
 machine-$(CONFIG_ARCH_EXYNOS)		+= exynos
@@ -241,13 +240,6 @@ plat-$(CONFIG_PLAT_PXA)		+= pxa
 plat-$(CONFIG_PLAT_S3C24XX)	+= samsung
 plat-$(CONFIG_PLAT_VERSATILE)	+= versatile
 
-ifeq ($(CONFIG_ARCH_EBSA110),y)
-# This is what happens if you forget the IOCS16 line.
-# PCMCIA cards stop working.
-CFLAGS_3c589_cs.o :=-DISA_SIXTEEN_BIT_PERIPHERAL
-export CFLAGS_3c589_cs.o
-endif
-
 # The byte offset of the kernel image in RAM from the start of RAM.
 TEXT_OFFSET := $(textofs-y)
 
diff --git a/arch/arm/configs/ebsa110_defconfig b/arch/arm/configs/ebsa110_defconfig
deleted file mode 100644
index 731a22a55f4e..000000000000
--- a/arch/arm/configs/ebsa110_defconfig
+++ /dev/null
@@ -1,74 +0,0 @@
-CONFIG_SYSVIPC=y
-CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EXPERT=y
-CONFIG_MODULES=y
-CONFIG_ARCH_EBSA110=y
-CONFIG_PCCARD=m
-CONFIG_I82365=m
-CONFIG_LEDS=y
-CONFIG_ZBOOT_ROM_TEXT=0x0
-CONFIG_ZBOOT_ROM_BSS=0x0
-CONFIG_CMDLINE="root=/dev/nfs rw mem=16M console=ttyS1,38400n8"
-CONFIG_FPE_NWFPE=y
-CONFIG_FPE_FASTFPE=y
-CONFIG_BINFMT_AOUT=y
-CONFIG_NET=y
-CONFIG_PACKET=y
-CONFIG_UNIX=y
-CONFIG_INET=y
-CONFIG_IP_MULTICAST=y
-CONFIG_IP_ADVANCED_ROUTER=y
-CONFIG_IP_MULTIPLE_TABLES=y
-CONFIG_IP_ROUTE_VERBOSE=y
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_BOOTP=y
-CONFIG_SYN_COOKIES=y
-CONFIG_IPV6=y
-CONFIG_NETFILTER=y
-CONFIG_IP_NF_IPTABLES=y
-CONFIG_IP_NF_MATCH_ECN=y
-CONFIG_IP_NF_MATCH_TTL=y
-CONFIG_IP_NF_FILTER=y
-CONFIG_IP_NF_TARGET_REJECT=y
-CONFIG_IP_NF_TARGET_LOG=y
-CONFIG_IP_NF_MANGLE=y
-CONFIG_IP_NF_TARGET_ECN=y
-CONFIG_IP6_NF_IPTABLES=y
-CONFIG_IP6_NF_MATCH_FRAG=y
-CONFIG_IP6_NF_MATCH_OPTS=y
-CONFIG_IP6_NF_MATCH_HL=y
-CONFIG_IP6_NF_MATCH_RT=y
-CONFIG_IP6_NF_FILTER=y
-CONFIG_IP6_NF_MANGLE=y
-CONFIG_FW_LOADER=m
-CONFIG_PARPORT=y
-CONFIG_PARPORT_PC=y
-CONFIG_PARPORT_PC_FIFO=y
-CONFIG_PARPORT_1284=y
-CONFIG_BLK_DEV_RAM=y
-CONFIG_NETDEVICES=y
-CONFIG_NET_ETHERNET=y
-CONFIG_ARM_AM79C961A=y
-CONFIG_NET_PCMCIA=y
-CONFIG_PCMCIA_PCNET=m
-CONFIG_PPP=m
-CONFIG_PPP_ASYNC=m
-CONFIG_PPP_DEFLATE=m
-CONFIG_PPP_BSDCOMP=m
-# CONFIG_INPUT is not set
-# CONFIG_SERIO is not set
-# CONFIG_VT is not set
-CONFIG_SERIAL_8250=y
-CONFIG_SERIAL_8250_CONSOLE=y
-CONFIG_SERIAL_8250_CS=m
-CONFIG_PRINTER=m
-CONFIG_WATCHDOG=y
-CONFIG_SOFT_WATCHDOG=y
-CONFIG_AUTOFS4_FS=y
-CONFIG_MINIX_FS=y
-CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
-CONFIG_ROOT_NFS=y
-CONFIG_PARTITION_ADVANCED=y
-# CONFIG_MSDOS_PARTITION is not set
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 89e5d864e923..09e67cb02b20 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -17,7 +17,7 @@ CFLAGS_REMOVE_return_address.o = -pg
 # Object file lists.
 
 obj-y		:= elf.o entry-common.o irq.o opcodes.o \
-		   process.o ptrace.o reboot.o \
+		   process.o ptrace.o reboot.o io.o \
 		   setup.o signal.o sigreturn_codes.o \
 		   stacktrace.o sys_arm.o time.o traps.o
 
@@ -83,10 +83,6 @@ AFLAGS_iwmmxt.o			:= -Wa,-mcpu=iwmmxt
 obj-$(CONFIG_ARM_CPU_TOPOLOGY)  += topology.o
 obj-$(CONFIG_VDSO)		+= vdso.o
 obj-$(CONFIG_EFI)		+= efi.o
-
-ifneq ($(CONFIG_ARCH_EBSA110),y)
-  obj-y		+= io.o
-endif
 obj-$(CONFIG_PARAVIRT)	+= paravirt.o
 
 head-y			:= head$(MMUEXT).o
diff --git a/arch/arm/mach-ebsa110/Makefile b/arch/arm/mach-ebsa110/Makefile
deleted file mode 100644
index 296541315d25..000000000000
--- a/arch/arm/mach-ebsa110/Makefile
+++ /dev/null
@@ -1,8 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-#
-# Makefile for the linux kernel.
-#
-
-# Object file lists.
-
-obj-y			:= core.o io.o leds.o
diff --git a/arch/arm/mach-ebsa110/Makefile.boot b/arch/arm/mach-ebsa110/Makefile.boot
deleted file mode 100644
index e7e98937c71b..000000000000
--- a/arch/arm/mach-ebsa110/Makefile.boot
+++ /dev/null
@@ -1,5 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-   zreladdr-y	+= 0x00008000
-params_phys-y	:= 0x00000400
-initrd_phys-y	:= 0x00800000
-
diff --git a/arch/arm/mach-ebsa110/core.c b/arch/arm/mach-ebsa110/core.c
deleted file mode 100644
index 5960e3dfd2bf..000000000000
--- a/arch/arm/mach-ebsa110/core.c
+++ /dev/null
@@ -1,323 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- *  linux/arch/arm/mach-ebsa110/core.c
- *
- *  Copyright (C) 1998-2001 Russell King
- *
- *  Extra MM routines for the EBSA-110 architecture
- */
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/serial_8250.h>
-#include <linux/init.h>
-#include <linux/io.h>
-
-#include <mach/hardware.h>
-#include <asm/irq.h>
-#include <asm/setup.h>
-#include <asm/mach-types.h>
-#include <asm/page.h>
-#include <asm/system_misc.h>
-
-#include <asm/mach/arch.h>
-#include <asm/mach/irq.h>
-#include <asm/mach/map.h>
-
-#include <asm/mach/time.h>
-
-#include "core.h"
-
-static void ebsa110_mask_irq(struct irq_data *d)
-{
-	__raw_writeb(1 << d->irq, IRQ_MCLR);
-}
-
-static void ebsa110_unmask_irq(struct irq_data *d)
-{
-	__raw_writeb(1 << d->irq, IRQ_MSET);
-}
-
-static struct irq_chip ebsa110_irq_chip = {
-	.irq_ack	= ebsa110_mask_irq,
-	.irq_mask	= ebsa110_mask_irq,
-	.irq_unmask	= ebsa110_unmask_irq,
-};
- 
-static void __init ebsa110_init_irq(void)
-{
-	unsigned long flags;
-	unsigned int irq;
-
-	local_irq_save(flags);
-	__raw_writeb(0xff, IRQ_MCLR);
-	__raw_writeb(0x55, IRQ_MSET);
-	__raw_writeb(0x00, IRQ_MSET);
-	if (__raw_readb(IRQ_MASK) != 0x55)
-		while (1);
-	__raw_writeb(0xff, IRQ_MCLR);	/* clear all interrupt enables */
-	local_irq_restore(flags);
-
-	for (irq = 0; irq < NR_IRQS; irq++) {
-		irq_set_chip_and_handler(irq, &ebsa110_irq_chip,
-					 handle_level_irq);
-		irq_clear_status_flags(irq, IRQ_NOREQUEST | IRQ_NOPROBE);
-	}
-}
-
-static struct map_desc ebsa110_io_desc[] __initdata = {
-	/*
-	 * sparse external-decode ISAIO space
-	 */
-	{	/* IRQ_STAT/IRQ_MCLR */
-		.virtual	= (unsigned long)IRQ_STAT,
-		.pfn		= __phys_to_pfn(TRICK4_PHYS),
-		.length		= TRICK4_SIZE,
-		.type		= MT_DEVICE
-	}, {	/* IRQ_MASK/IRQ_MSET */
-		.virtual	= (unsigned long)IRQ_MASK,
-		.pfn		= __phys_to_pfn(TRICK3_PHYS),
-		.length		= TRICK3_SIZE,
-		.type		= MT_DEVICE
-	}, {	/* SOFT_BASE */
-		.virtual	= (unsigned long)SOFT_BASE,
-		.pfn		= __phys_to_pfn(TRICK1_PHYS),
-		.length		= TRICK1_SIZE,
-		.type		= MT_DEVICE
-	}, {	/* PIT_BASE */
-		.virtual	= (unsigned long)PIT_BASE,
-		.pfn		= __phys_to_pfn(TRICK0_PHYS),
-		.length		= TRICK0_SIZE,
-		.type		= MT_DEVICE
-	},
-
-	/*
-	 * self-decode ISAIO space
-	 */
-	{
-		.virtual	= ISAIO_BASE,
-		.pfn		= __phys_to_pfn(ISAIO_PHYS),
-		.length		= ISAIO_SIZE,
-		.type		= MT_DEVICE
-	}, {
-		.virtual	= ISAMEM_BASE,
-		.pfn		= __phys_to_pfn(ISAMEM_PHYS),
-		.length		= ISAMEM_SIZE,
-		.type		= MT_DEVICE
-	}
-};
-
-static void __init ebsa110_map_io(void)
-{
-	iotable_init(ebsa110_io_desc, ARRAY_SIZE(ebsa110_io_desc));
-}
-
-static void __iomem *ebsa110_ioremap_caller(phys_addr_t cookie, size_t size,
-					    unsigned int flags, void *caller)
-{
-	return (void __iomem *)cookie;
-}
-
-static void ebsa110_iounmap(volatile void __iomem *io_addr)
-{}
-
-static void __init ebsa110_init_early(void)
-{
-	arch_ioremap_caller = ebsa110_ioremap_caller;
-	arch_iounmap = ebsa110_iounmap;
-}
-
-#define PIT_CTRL		(PIT_BASE + 0x0d)
-#define PIT_T2			(PIT_BASE + 0x09)
-#define PIT_T1			(PIT_BASE + 0x05)
-#define PIT_T0			(PIT_BASE + 0x01)
-
-/*
- * This is the rate at which your MCLK signal toggles (in Hz)
- * This was measured on a 10 digit frequency counter sampling
- * over 1 second.
- */
-#define MCLK	47894000
-
-/*
- * This is the rate at which the PIT timers get clocked
- */
-#define CLKBY7	(MCLK / 7)
-
-/*
- * This is the counter value.  We tick at 200Hz on this platform.
- */
-#define COUNT	((CLKBY7 + (HZ / 2)) / HZ)
-
-/*
- * Get the time offset from the system PIT.  Note that if we have missed an
- * interrupt, then the PIT counter will roll over (ie, be negative).
- * This actually works out to be convenient.
- */
-static u32 ebsa110_gettimeoffset(void)
-{
-	unsigned long offset, count;
-
-	__raw_writeb(0x40, PIT_CTRL);
-	count = __raw_readb(PIT_T1);
-	count |= __raw_readb(PIT_T1) << 8;
-
-	/*
-	 * If count > COUNT, make the number negative.
-	 */
-	if (count > COUNT)
-		count |= 0xffff0000;
-
-	offset = COUNT;
-	offset -= count;
-
-	/*
-	 * `offset' is in units of timer counts.  Convert
-	 * offset to units of microseconds.
-	 */
-	offset = offset * (1000000 / HZ) / COUNT;
-
-	return offset * 1000;
-}
-
-static irqreturn_t
-ebsa110_timer_interrupt(int irq, void *dev_id)
-{
-	u32 count;
-
-	/* latch and read timer 1 */
-	__raw_writeb(0x40, PIT_CTRL);
-	count = __raw_readb(PIT_T1);
-	count |= __raw_readb(PIT_T1) << 8;
-
-	count += COUNT;
-
-	__raw_writeb(count & 0xff, PIT_T1);
-	__raw_writeb(count >> 8, PIT_T1);
-
-	timer_tick();
-
-	return IRQ_HANDLED;
-}
-
-/*
- * Set up timer interrupt.
- */
-void __init ebsa110_timer_init(void)
-{
-	int irq = IRQ_EBSA110_TIMER0;
-
-	arch_gettimeoffset = ebsa110_gettimeoffset;
-
-	/*
-	 * Timer 1, mode 2, LSB/MSB
-	 */
-	__raw_writeb(0x70, PIT_CTRL);
-	__raw_writeb(COUNT & 0xff, PIT_T1);
-	__raw_writeb(COUNT >> 8, PIT_T1);
-
-	if (request_irq(irq, ebsa110_timer_interrupt, IRQF_TIMER | IRQF_IRQPOLL,
-			"EBSA110 Timer Tick", NULL))
-		pr_err("Failed to request irq %d (EBSA110 Timer Tick)\n", irq);
-}
-
-static struct plat_serial8250_port serial_platform_data[] = {
-	{
-		.iobase		= 0x3f8,
-		.irq		= 1,
-		.uartclk	= 1843200,
-		.regshift	= 0,
-		.iotype		= UPIO_PORT,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
-	},
-	{
-		.iobase		= 0x2f8,
-		.irq		= 2,
-		.uartclk	= 1843200,
-		.regshift	= 0,
-		.iotype		= UPIO_PORT,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
-	},
-	{ },
-};
-
-static struct platform_device serial_device = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM,
-	.dev			= {
-		.platform_data	= serial_platform_data,
-	},
-};
-
-static struct resource am79c961_resources[] = {
-	{
-		.start		= 0x220,
-		.end		= 0x238,
-		.flags		= IORESOURCE_IO,
-	}, {
-		.start		= IRQ_EBSA110_ETHERNET,
-		.end		= IRQ_EBSA110_ETHERNET,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device am79c961_device = {
-	.name			= "am79c961",
-	.id			= -1,
-	.num_resources		= ARRAY_SIZE(am79c961_resources),
-	.resource		= am79c961_resources,
-};
-
-static struct platform_device *ebsa110_devices[] = {
-	&serial_device,
-	&am79c961_device,
-};
-
-/*
- * EBSA110 idling methodology:
- *
- * We can not execute the "wait for interrupt" instruction since that
- * will stop our MCLK signal (which provides the clock for the glue
- * logic, and therefore the timer interrupt).
- *
- * Instead, we spin, polling the IRQ_STAT register for the occurrence
- * of any interrupt with core clock down to the memory clock.
- */
-static void ebsa110_idle(void)
-{
-	const char *irq_stat = (char *)0xff000000;
-
-	/* disable clock switching */
-	asm volatile ("mcr p15, 0, ip, c15, c2, 2" : : : "cc");
-
-	/* wait for an interrupt to occur */
-	while (!*irq_stat);
-
-	/* enable clock switching */
-	asm volatile ("mcr p15, 0, ip, c15, c1, 2" : : : "cc");
-}
-
-static int __init ebsa110_init(void)
-{
-	arm_pm_idle = ebsa110_idle;
-	return platform_add_devices(ebsa110_devices, ARRAY_SIZE(ebsa110_devices));
-}
-
-arch_initcall(ebsa110_init);
-
-static void ebsa110_restart(enum reboot_mode mode, const char *cmd)
-{
-	soft_restart(0x80000000);
-}
-
-MACHINE_START(EBSA110, "EBSA110")
-	/* Maintainer: Russell King */
-	.atag_offset	= 0x400,
-	.reserve_lp0	= 1,
-	.reserve_lp2	= 1,
-	.map_io		= ebsa110_map_io,
-	.init_early	= ebsa110_init_early,
-	.init_irq	= ebsa110_init_irq,
-	.init_time	= ebsa110_timer_init,
-	.restart	= ebsa110_restart,
-MACHINE_END
diff --git a/arch/arm/mach-ebsa110/core.h b/arch/arm/mach-ebsa110/core.h
deleted file mode 100644
index 47acc610b6b4..000000000000
--- a/arch/arm/mach-ebsa110/core.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- *  Copyright (C) 1996-2000 Russell King.
- *
- * This file contains the core hardware definitions of the EBSA-110.
- */
-#ifndef CORE_H
-#define CORE_H
-
-/* Physical addresses/sizes */
-#define ISAMEM_PHYS		0xe0000000
-#define ISAMEM_SIZE		0x10000000
-
-#define ISAIO_PHYS		0xf0000000
-#define ISAIO_SIZE		PGDIR_SIZE
-
-#define TRICK0_PHYS		0xf2000000
-#define TRICK0_SIZE		PGDIR_SIZE
-#define TRICK1_PHYS		0xf2400000
-#define TRICK1_SIZE		PGDIR_SIZE
-#define TRICK2_PHYS		0xf2800000
-#define TRICK3_PHYS		0xf2c00000
-#define TRICK3_SIZE		PGDIR_SIZE
-#define TRICK4_PHYS		0xf3000000
-#define TRICK4_SIZE		PGDIR_SIZE
-#define TRICK5_PHYS		0xf3400000
-#define TRICK6_PHYS		0xf3800000
-#define TRICK7_PHYS		0xf3c00000
-
-/* Virtual addresses */
-#define PIT_BASE		IOMEM(0xfc000000)	/* trick 0 */
-#define SOFT_BASE		IOMEM(0xfd000000)	/* trick 1 */
-#define IRQ_MASK		IOMEM(0xfe000000)	/* trick 3 - read */
-#define IRQ_MSET		IOMEM(0xfe000000)	/* trick 3 - write */
-#define IRQ_STAT		IOMEM(0xff000000)	/* trick 4 - read */
-#define IRQ_MCLR		IOMEM(0xff000000)	/* trick 4 - write */
-
-#endif
diff --git a/arch/arm/mach-ebsa110/include/mach/entry-macro.S b/arch/arm/mach-ebsa110/include/mach/entry-macro.S
deleted file mode 100644
index 14b110de78a9..000000000000
--- a/arch/arm/mach-ebsa110/include/mach/entry-macro.S
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * arch/arm/mach-ebsa110/include/mach/entry-macro.S
- *
- * Low-level IRQ helper macros for ebsa110 platform.
- *
- * This file is licensed under  the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-
-
-#define IRQ_STAT		0xff000000	/* read */
-
-	.macro  get_irqnr_preamble, base, tmp
-	mov	\base, #IRQ_STAT
-	.endm
-
-	.macro	get_irqnr_and_base, irqnr, stat, base, tmp
-	ldrb	\stat, [\base]			@ get interrupts
-	mov	\irqnr, #0
-	tst	\stat, #15
-	addeq	\irqnr, \irqnr, #4
-	moveq	\stat, \stat, lsr #4
-	tst	\stat, #3
-	addeq	\irqnr, \irqnr, #2
-	moveq	\stat, \stat, lsr #2
-	tst	\stat, #1
-	addeq	\irqnr, \irqnr, #1
-	moveq	\stat, \stat, lsr #1
-	tst	\stat, #1			@ bit 0 should be set
-	.endm
-
diff --git a/arch/arm/mach-ebsa110/include/mach/hardware.h b/arch/arm/mach-ebsa110/include/mach/hardware.h
deleted file mode 100644
index 81f6967683f6..000000000000
--- a/arch/arm/mach-ebsa110/include/mach/hardware.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- *  arch/arm/mach-ebsa110/include/mach/hardware.h
- *
- *  Copyright (C) 1996-2000 Russell King.
- *
- * This file contains the hardware definitions of the EBSA-110.
- */
-#ifndef __ASM_ARCH_HARDWARE_H
-#define __ASM_ARCH_HARDWARE_H
-
-#define ISAMEM_BASE		0xe0000000
-#define ISAIO_BASE		0xf0000000
-
-/*
- * RAM definitions
- */
-#define UNCACHEABLE_ADDR	0xff000000	/* IRQ_STAT */
-
-#endif
-
diff --git a/arch/arm/mach-ebsa110/include/mach/io.h b/arch/arm/mach-ebsa110/include/mach/io.h
deleted file mode 100644
index ad170886c9aa..000000000000
--- a/arch/arm/mach-ebsa110/include/mach/io.h
+++ /dev/null
@@ -1,89 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- *  arch/arm/mach-ebsa110/include/mach/io.h
- *
- *  Copyright (C) 1997,1998 Russell King
- *
- * Modifications:
- *  06-Dec-1997	RMK	Created.
- */
-#ifndef __ASM_ARM_ARCH_IO_H
-#define __ASM_ARM_ARCH_IO_H
-
-u8 __inb8(unsigned int port);
-void __outb8(u8  val, unsigned int port);
-
-u8 __inb16(unsigned int port);
-void __outb16(u8  val, unsigned int port);
-
-u16 __inw(unsigned int port);
-void __outw(u16 val, unsigned int port);
-
-u32 __inl(unsigned int port);
-void __outl(u32 val, unsigned int port);
-
-u8  __readb(const volatile void __iomem *addr);
-u16 __readw(const volatile void __iomem *addr);
-u32 __readl(const volatile void __iomem *addr);
-
-void __writeb(u8  val, volatile void __iomem *addr);
-void __writew(u16 val, volatile void __iomem *addr);
-void __writel(u32 val, volatile void __iomem *addr);
-
-/*
- * Argh, someone forgot the IOCS16 line.  We therefore have to handle
- * the byte stearing by selecting the correct byte IO functions here.
- */
-#ifdef ISA_SIXTEEN_BIT_PERIPHERAL
-#define inb(p) 			__inb16(p)
-#define outb(v,p)		__outb16(v,p)
-#else
-#define inb(p)			__inb8(p)
-#define outb(v,p)		__outb8(v,p)
-#endif
-
-#define inw(p)			__inw(p)
-#define outw(v,p)		__outw(v,p)
-
-#define inl(p)			__inl(p)
-#define outl(v,p)		__outl(v,p)
-
-#define readb(b)		__readb(b)
-#define readw(b)		__readw(b)
-#define readl(b)		__readl(b)
-#define readb_relaxed(addr)	readb(addr)
-#define readw_relaxed(addr)	readw(addr)
-#define readl_relaxed(addr)	readl(addr)
-
-#define writeb(v,b)		__writeb(v,b)
-#define writew(v,b)		__writew(v,b)
-#define writel(v,b)		__writel(v,b)
-
-#define insb insb
-extern void insb(unsigned int port, void *buf, int sz);
-#define insw insw
-extern void insw(unsigned int port, void *buf, int sz);
-#define insl insl
-extern void insl(unsigned int port, void *buf, int sz);
-
-#define outsb outsb
-extern void outsb(unsigned int port, const void *buf, int sz);
-#define outsw outsw
-extern void outsw(unsigned int port, const void *buf, int sz);
-#define outsl outsl
-extern void outsl(unsigned int port, const void *buf, int sz);
-
-/* can't support writesb atm */
-#define writesw writesw
-extern void writesw(volatile void __iomem *addr, const void *data, int wordlen);
-#define writesl writesl
-extern void writesl(volatile void __iomem *addr, const void *data, int longlen);
-
-/* can't support readsb atm */
-#define readsw readsw
-extern void readsw(const volatile void __iomem *addr, void *data, int wordlen);
-
-#define readsl readsl
-extern void readsl(const volatile void __iomem *addr, void *data, int longlen);
-
-#endif
diff --git a/arch/arm/mach-ebsa110/include/mach/irqs.h b/arch/arm/mach-ebsa110/include/mach/irqs.h
deleted file mode 100644
index 29a8671fe849..000000000000
--- a/arch/arm/mach-ebsa110/include/mach/irqs.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- *  arch/arm/mach-ebsa110/include/mach/irqs.h
- *
- *  Copyright (C) 1996 Russell King
- */
-
-#define NR_IRQS			8
-
-#define IRQ_EBSA110_PRINTER	0
-#define IRQ_EBSA110_COM1	1
-#define IRQ_EBSA110_COM2	2
-#define IRQ_EBSA110_ETHERNET	3
-#define IRQ_EBSA110_TIMER0	4
-#define IRQ_EBSA110_TIMER1	5
-#define IRQ_EBSA110_PCMCIA	6
-#define IRQ_EBSA110_IMMEDIATE	7
diff --git a/arch/arm/mach-ebsa110/include/mach/memory.h b/arch/arm/mach-ebsa110/include/mach/memory.h
deleted file mode 100644
index f025f405de50..000000000000
--- a/arch/arm/mach-ebsa110/include/mach/memory.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- *  arch/arm/mach-ebsa110/include/mach/memory.h
- *
- *  Copyright (C) 1996-1999 Russell King.
- *
- *  Changelog:
- *   20-Oct-1996 RMK	Created
- *   31-Dec-1997 RMK	Fixed definitions to reduce warnings
- *   21-Mar-1999 RMK	Renamed to memory.h
- *		 RMK	Moved TASK_SIZE and PAGE_OFFSET here
- */
-#ifndef __ASM_ARCH_MEMORY_H
-#define __ASM_ARCH_MEMORY_H
-
-/*
- * Cache flushing area - SRAM
- */
-#define FLUSH_BASE_PHYS		0x40000000
-#define FLUSH_BASE		0xdf000000
-
-#endif
diff --git a/arch/arm/mach-ebsa110/include/mach/uncompress.h b/arch/arm/mach-ebsa110/include/mach/uncompress.h
deleted file mode 100644
index 3ec12efe98a6..000000000000
--- a/arch/arm/mach-ebsa110/include/mach/uncompress.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- *  arch/arm/mach-ebsa110/include/mach/uncompress.h
- *
- *  Copyright (C) 1996,1997,1998 Russell King
- */
-
-#include <linux/serial_reg.h>
-
-#define SERIAL_BASE	((unsigned char *)0xf0000be0)
-
-/*
- * This does not append a newline
- */
-static inline void putc(int c)
-{
-	unsigned char v, *base = SERIAL_BASE;
-
-	do {
-		v = base[UART_LSR << 2];
-		barrier();
-	} while (!(v & UART_LSR_THRE));
-
-	base[UART_TX << 2] = c;
-}
-
-static inline void flush(void)
-{
-	unsigned char v, *base = SERIAL_BASE;
-
-	do {
-		v = base[UART_LSR << 2];
-		barrier();
-	} while ((v & (UART_LSR_TEMT|UART_LSR_THRE)) !=
-		 (UART_LSR_TEMT|UART_LSR_THRE));
-}
-
-/*
- * nothing to do
- */
-#define arch_decomp_setup()
diff --git a/arch/arm/mach-ebsa110/io.c b/arch/arm/mach-ebsa110/io.c
deleted file mode 100644
index 3c44dd3596ea..000000000000
--- a/arch/arm/mach-ebsa110/io.c
+++ /dev/null
@@ -1,440 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- *  linux/arch/arm/mach-ebsa110/isamem.c
- *
- *  Copyright (C) 2001 Russell King
- *
- * Perform "ISA" memory and IO accesses.  The EBSA110 has some "peculiarities"
- * in the way it handles accesses to odd IO ports on 16-bit devices.  These
- * devices have their D0-D15 lines connected to the processors D0-D15 lines.
- * Since they expect all byte IO operations to be performed on D0-D7, and the
- * StrongARM expects to transfer the byte to these odd addresses on D8-D15,
- * we must use a trick to get the required behaviour.
- *
- * The trick employed here is to use long word stores to odd address -1.  The
- * glue logic picks this up as a "trick" access, and asserts the LSB of the
- * peripherals address bus, thereby accessing the odd IO port.  Meanwhile, the
- * StrongARM transfers its data on D0-D7 as expected.
- *
- * Things get more interesting on the pass-1 EBSA110 - the PCMCIA controller
- * wiring was screwed in such a way that it had limited memory space access.
- * Luckily, the work-around for this is not too horrible.  See
- * __isamem_convert_addr for the details.
- */
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/io.h>
-
-#include <mach/hardware.h>
-#include <asm/page.h>
-
-static void __iomem *__isamem_convert_addr(const volatile void __iomem *addr)
-{
-	u32 ret, a = (u32 __force) addr;
-
-	/*
-	 * The PCMCIA controller is wired up as follows:
-	 *        +---------+---------+---------+---------+---------+---------+
-	 * PCMCIA | 2 2 2 2 | 1 1 1 1 | 1 1 1 1 | 1 1     |         |         |
-	 *        | 3 2 1 0 | 9 8 7 6 | 5 4 3 2 | 1 0 9 8 | 7 6 5 4 | 3 2 1 0 |
-	 *        +---------+---------+---------+---------+---------+---------+
-	 *  CPU   | 2 2 2 2 | 2 1 1 1 | 1 1 1 1 | 1 1 1   |         |         |
-	 *        | 4 3 2 1 | 0 9 9 8 | 7 6 5 4 | 3 2 0 9 | 8 7 6 5 | 4 3 2 x |
-	 *        +---------+---------+---------+---------+---------+---------+
-	 *
-	 * This means that we can access PCMCIA regions as follows:
-	 *	0x*10000 -> 0x*1ffff
-	 *	0x*70000 -> 0x*7ffff
-	 *	0x*90000 -> 0x*9ffff
-	 *	0x*f0000 -> 0x*fffff
-	 */
-	ret  = (a & 0xf803fe) << 1;
-	ret |= (a & 0x03fc00) << 2;
-
-	ret += 0xe8000000;
-
-	if ((a & 0x20000) == (a & 0x40000) >> 1)
-		return (void __iomem *)ret;
-
-	BUG();
-	return NULL;
-}
-
-/*
- * read[bwl] and write[bwl]
- */
-u8 __readb(const volatile void __iomem *addr)
-{
-	void __iomem *a = __isamem_convert_addr(addr);
-	u32 ret;
-
-	if ((unsigned long)addr & 1)
-		ret = __raw_readl(a);
-	else
-		ret = __raw_readb(a);
-	return ret;
-}
-
-u16 __readw(const volatile void __iomem *addr)
-{
-	void __iomem *a = __isamem_convert_addr(addr);
-
-	if ((unsigned long)addr & 1)
-		BUG();
-
-	return __raw_readw(a);
-}
-
-u32 __readl(const volatile void __iomem *addr)
-{
-	void __iomem *a = __isamem_convert_addr(addr);
-	u32 ret;
-
-	if ((unsigned long)addr & 3)
-		BUG();
-
-	ret = __raw_readw(a);
-	ret |= __raw_readw(a + 4) << 16;
-	return ret;
-}
-
-EXPORT_SYMBOL(__readb);
-EXPORT_SYMBOL(__readw);
-EXPORT_SYMBOL(__readl);
-
-void readsw(const volatile void __iomem *addr, void *data, int len)
-{
-	void __iomem *a = __isamem_convert_addr(addr);
-
-	BUG_ON((unsigned long)addr & 1);
-
-	__raw_readsw(a, data, len);
-}
-EXPORT_SYMBOL(readsw);
-
-void readsl(const volatile void __iomem *addr, void *data, int len)
-{
-	void __iomem *a = __isamem_convert_addr(addr);
-
-	BUG_ON((unsigned long)addr & 3);
-
-	__raw_readsl(a, data, len);
-}
-EXPORT_SYMBOL(readsl);
-
-void __writeb(u8 val, volatile void __iomem *addr)
-{
-	void __iomem *a = __isamem_convert_addr(addr);
-
-	if ((unsigned long)addr & 1)
-		__raw_writel(val, a);
-	else
-		__raw_writeb(val, a);
-}
-
-void __writew(u16 val, volatile void __iomem *addr)
-{
-	void __iomem *a = __isamem_convert_addr(addr);
-
-	if ((unsigned long)addr & 1)
-		BUG();
-
-	__raw_writew(val, a);
-}
-
-void __writel(u32 val, volatile void __iomem *addr)
-{
-	void __iomem *a = __isamem_convert_addr(addr);
-
-	if ((unsigned long)addr & 3)
-		BUG();
-
-	__raw_writew(val, a);
-	__raw_writew(val >> 16, a + 4);
-}
-
-EXPORT_SYMBOL(__writeb);
-EXPORT_SYMBOL(__writew);
-EXPORT_SYMBOL(__writel);
-
-void writesw(volatile void __iomem *addr, const void *data, int len)
-{
-	void __iomem *a = __isamem_convert_addr(addr);
-
-	BUG_ON((unsigned long)addr & 1);
-
-	__raw_writesw(a, data, len);
-}
-EXPORT_SYMBOL(writesw);
-
-void writesl(volatile void __iomem *addr, const void *data, int len)
-{
-	void __iomem *a = __isamem_convert_addr(addr);
-
-	BUG_ON((unsigned long)addr & 3);
-
-	__raw_writesl(a, data, len);
-}
-EXPORT_SYMBOL(writesl);
-
-/*
- * The EBSA110 has a weird "ISA IO" region:
- *
- * Region 0 (addr = 0xf0000000 + io << 2)
- * --------------------------------------------------------
- * Physical region	IO region
- * f0000fe0 - f0000ffc	3f8 - 3ff  ttyS0
- * f0000e60 - f0000e64	398 - 399
- * f0000de0 - f0000dfc	378 - 37f  lp0
- * f0000be0 - f0000bfc	2f8 - 2ff  ttyS1
- *
- * Region 1 (addr = 0xf0000000 + (io & ~1) << 1 + (io & 1))
- * --------------------------------------------------------
- * Physical region	IO region
- * f00014f1             a79        pnp write data
- * f00007c0 - f00007c1	3e0 - 3e1  pcmcia
- * f00004f1		279        pnp address
- * f0000440 - f000046c  220 - 236  eth0
- * f0000405		203        pnp read data
- */
-#define SUPERIO_PORT(p) \
-	(((p) >> 3) == (0x3f8 >> 3) || \
-	 ((p) >> 3) == (0x2f8 >> 3) || \
-	 ((p) >> 3) == (0x378 >> 3))
-
-/*
- * We're addressing an 8 or 16-bit peripheral which tranfers
- * odd addresses on the low ISA byte lane.
- */
-u8 __inb8(unsigned int port)
-{
-	u32 ret;
-
-	/*
-	 * The SuperIO registers use sane addressing techniques...
-	 */
-	if (SUPERIO_PORT(port))
-		ret = __raw_readb((void __iomem *)ISAIO_BASE + (port << 2));
-	else {
-		void __iomem *a = (void __iomem *)ISAIO_BASE + ((port & ~1) << 1);
-
-		/*
-		 * Shame nothing else does
-		 */
-		if (port & 1)
-			ret = __raw_readl(a);
-		else
-			ret = __raw_readb(a);
-	}
-	return ret;
-}
-
-/*
- * We're addressing a 16-bit peripheral which transfers odd
- * addresses on the high ISA byte lane.
- */
-u8 __inb16(unsigned int port)
-{
-	unsigned int offset;
-
-	/*
-	 * The SuperIO registers use sane addressing techniques...
-	 */
-	if (SUPERIO_PORT(port))
-		offset = port << 2;
-	else
-		offset = (port & ~1) << 1 | (port & 1);
-
-	return __raw_readb((void __iomem *)ISAIO_BASE + offset);
-}
-
-u16 __inw(unsigned int port)
-{
-	unsigned int offset;
-
-	/*
-	 * The SuperIO registers use sane addressing techniques...
-	 */
-	if (SUPERIO_PORT(port))
-		offset = port << 2;
-	else {
-		offset = port << 1;
-		BUG_ON(port & 1);
-	}
-	return __raw_readw((void __iomem *)ISAIO_BASE + offset);
-}
-
-/*
- * Fake a 32-bit read with two 16-bit reads.  Needed for 3c589.
- */
-u32 __inl(unsigned int port)
-{
-	void __iomem *a;
-
-	if (SUPERIO_PORT(port) || port & 3)
-		BUG();
-
-	a = (void __iomem *)ISAIO_BASE + ((port & ~1) << 1);
-
-	return __raw_readw(a) | __raw_readw(a + 4) << 16;
-}
-
-EXPORT_SYMBOL(__inb8);
-EXPORT_SYMBOL(__inb16);
-EXPORT_SYMBOL(__inw);
-EXPORT_SYMBOL(__inl);
-
-void __outb8(u8 val, unsigned int port)
-{
-	/*
-	 * The SuperIO registers use sane addressing techniques...
-	 */
-	if (SUPERIO_PORT(port))
-		__raw_writeb(val, (void __iomem *)ISAIO_BASE + (port << 2));
-	else {
-		void __iomem *a = (void __iomem *)ISAIO_BASE + ((port & ~1) << 1);
-
-		/*
-		 * Shame nothing else does
-		 */
-		if (port & 1)
-			__raw_writel(val, a);
-		else
-			__raw_writeb(val, a);
-	}
-}
-
-void __outb16(u8 val, unsigned int port)
-{
-	unsigned int offset;
-
-	/*
-	 * The SuperIO registers use sane addressing techniques...
-	 */
-	if (SUPERIO_PORT(port))
-		offset = port << 2;
-	else
-		offset = (port & ~1) << 1 | (port & 1);
-
-	__raw_writeb(val, (void __iomem *)ISAIO_BASE + offset);
-}
-
-void __outw(u16 val, unsigned int port)
-{
-	unsigned int offset;
-
-	/*
-	 * The SuperIO registers use sane addressing techniques...
-	 */
-	if (SUPERIO_PORT(port))
-		offset = port << 2;
-	else {
-		offset = port << 1;
-		BUG_ON(port & 1);
-	}
-	__raw_writew(val, (void __iomem *)ISAIO_BASE + offset);
-}
-
-void __outl(u32 val, unsigned int port)
-{
-	BUG();
-}
-
-EXPORT_SYMBOL(__outb8);
-EXPORT_SYMBOL(__outb16);
-EXPORT_SYMBOL(__outw);
-EXPORT_SYMBOL(__outl);
-
-void outsb(unsigned int port, const void *from, int len)
-{
-	u32 off;
-
-	if (SUPERIO_PORT(port))
-		off = port << 2;
-	else {
-		off = (port & ~1) << 1;
-		if (port & 1)
-			BUG();
-	}
-
-	__raw_writesb((void __iomem *)ISAIO_BASE + off, from, len);
-}
-
-void insb(unsigned int port, void *from, int len)
-{
-	u32 off;
-
-	if (SUPERIO_PORT(port))
-		off = port << 2;
-	else {
-		off = (port & ~1) << 1;
-		if (port & 1)
-			BUG();
-	}
-
-	__raw_readsb((void __iomem *)ISAIO_BASE + off, from, len);
-}
-
-EXPORT_SYMBOL(outsb);
-EXPORT_SYMBOL(insb);
-
-void outsw(unsigned int port, const void *from, int len)
-{
-	u32 off;
-
-	if (SUPERIO_PORT(port))
-		off = port << 2;
-	else {
-		off = (port & ~1) << 1;
-		if (port & 1)
-			BUG();
-	}
-
-	__raw_writesw((void __iomem *)ISAIO_BASE + off, from, len);
-}
-
-void insw(unsigned int port, void *from, int len)
-{
-	u32 off;
-
-	if (SUPERIO_PORT(port))
-		off = port << 2;
-	else {
-		off = (port & ~1) << 1;
-		if (port & 1)
-			BUG();
-	}
-
-	__raw_readsw((void __iomem *)ISAIO_BASE + off, from, len);
-}
-
-EXPORT_SYMBOL(outsw);
-EXPORT_SYMBOL(insw);
-
-/*
- * We implement these as 16-bit insw/outsw, mainly for
- * 3c589 cards.
- */
-void outsl(unsigned int port, const void *from, int len)
-{
-	u32 off = port << 1;
-
-	if (SUPERIO_PORT(port) || port & 3)
-		BUG();
-
-	__raw_writesw((void __iomem *)ISAIO_BASE + off, from, len << 1);
-}
-
-void insl(unsigned int port, void *from, int len)
-{
-	u32 off = port << 1;
-
-	if (SUPERIO_PORT(port) || port & 3)
-		BUG();
-
-	__raw_readsw((void __iomem *)ISAIO_BASE + off, from, len << 1);
-}
-
-EXPORT_SYMBOL(outsl);
-EXPORT_SYMBOL(insl);
diff --git a/arch/arm/mach-ebsa110/leds.c b/arch/arm/mach-ebsa110/leds.c
deleted file mode 100644
index fd1474b66d31..000000000000
--- a/arch/arm/mach-ebsa110/leds.c
+++ /dev/null
@@ -1,71 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Driver for the LED found on the EBSA110 machine
- * Based on Versatile and RealView machine LED code
- *
- * Author: Bryan Wu <bryan.wu@canonical.com>
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/io.h>
-#include <linux/slab.h>
-#include <linux/leds.h>
-
-#include <asm/mach-types.h>
-
-#include "core.h"
-
-#if defined(CONFIG_NEW_LEDS) && defined(CONFIG_LEDS_CLASS)
-static void ebsa110_led_set(struct led_classdev *cdev,
-			      enum led_brightness b)
-{
-	u8 reg = __raw_readb(SOFT_BASE);
-
-	if (b != LED_OFF)
-		reg |= 0x80;
-	else
-		reg &= ~0x80;
-
-	__raw_writeb(reg, SOFT_BASE);
-}
-
-static enum led_brightness ebsa110_led_get(struct led_classdev *cdev)
-{
-	u8 reg = __raw_readb(SOFT_BASE);
-
-	return (reg & 0x80) ? LED_FULL : LED_OFF;
-}
-
-static int __init ebsa110_leds_init(void)
-{
-
-	struct led_classdev *cdev;
-	int ret;
-
-	if (!machine_is_ebsa110())
-		return -ENODEV;
-
-	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
-	if (!cdev)
-		return -ENOMEM;
-
-	cdev->name = "ebsa110:0";
-	cdev->brightness_set = ebsa110_led_set;
-	cdev->brightness_get = ebsa110_led_get;
-	cdev->default_trigger = "heartbeat";
-
-	ret = led_classdev_register(NULL, cdev);
-	if (ret	< 0) {
-		kfree(cdev);
-		return ret;
-	}
-
-	return 0;
-}
-
-/*
- * Since we may have triggers on any subsystem, defer registration
- * until after subsystem_init.
- */
-fs_initcall(ebsa110_leds_init);
-#endif
-- 
2.27.0

