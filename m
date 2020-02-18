Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A25162C19
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgBRROF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:14:05 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43175 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727636AbgBRRNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:13:40 -0500
Received: by mail-oi1-f196.google.com with SMTP id p125so20818028oif.10;
        Tue, 18 Feb 2020 09:13:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OfSjz0SY3gB9vvqANcu/VWw8bhc0UxSKC0tVnm3NpGk=;
        b=L1AGWk8BpgWHL5guD5QdhRD713FXIpInZBcfX2DHLO7iWUSArEo13izgAJ9OBj+qep
         2HtrjqwuB7bSRzniiWuFenijkHqzWyGvLHi6hgNBQZ12nRoWqwC17sxAtK+pAMLVbAiW
         Au76CT7uz7ONcymB/idAwc0a09v0kPeflhhxdxC87TDfomwYOQQK6frOWwiPPVJjJRZA
         d6531oOLaF3begNXV8t148fnQuFjIbobAPK4/a7Iuoz2afRNfyVt1rHPfzNJ+TwUVqI4
         sYnZcmRMVbBENJKqoLeY6aR8c5HulGNNIA4GmY2r43teZaK6juSMddPcjjQS0SWNkcqP
         Epew==
X-Gm-Message-State: APjAAAWCPwf1qPbc4fvrusGEB3/MJb7aBU9/QEcKet8Jbca4/pM1Sgzj
        58/G6gJX5wWWoDxV8t8tyw==
X-Google-Smtp-Source: APXvYqxbphi1K6W3rxnH0g40QxVSz6sF58VircIrd+GanSZMoZoTlalIrudHTPYPIyhAT1DhIrluPg==
X-Received: by 2002:aca:f305:: with SMTP id r5mr1981696oih.174.1582046018439;
        Tue, 18 Feb 2020 09:13:38 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id y25sm1545755oto.27.2020.02.18.09.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:13:37 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        soc@kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 09/11] ARM: Remove Calxeda platform support
Date:   Tue, 18 Feb 2020 11:13:19 -0600
Message-Id: <20200218171321.30990-10-robh@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218171321.30990-1-robh@kernel.org>
References: <20200218171321.30990-1-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Rob Herring <robh@kernel.org>
---
 MAINTAINERS                         |   8 --
 arch/arm/Kconfig                    |   2 -
 arch/arm/Kconfig.debug              |  12 +-
 arch/arm/Makefile                   |   1 -
 arch/arm/configs/multi_v7_defconfig |   5 -
 arch/arm/mach-highbank/Kconfig      |  19 ---
 arch/arm/mach-highbank/Makefile     |   4 -
 arch/arm/mach-highbank/core.h       |  18 ---
 arch/arm/mach-highbank/highbank.c   | 175 ----------------------------
 arch/arm/mach-highbank/pm.c         |  49 --------
 arch/arm/mach-highbank/smc.S        |  25 ----
 arch/arm/mach-highbank/sysregs.h    |  75 ------------
 arch/arm/mach-highbank/system.c     |  22 ----
 13 files changed, 1 insertion(+), 414 deletions(-)
 delete mode 100644 arch/arm/mach-highbank/Kconfig
 delete mode 100644 arch/arm/mach-highbank/Makefile
 delete mode 100644 arch/arm/mach-highbank/core.h
 delete mode 100644 arch/arm/mach-highbank/highbank.c
 delete mode 100644 arch/arm/mach-highbank/pm.c
 delete mode 100644 arch/arm/mach-highbank/smc.S
 delete mode 100644 arch/arm/mach-highbank/sysregs.h
 delete mode 100644 arch/arm/mach-highbank/system.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4732bb268299..551aaa9d2dab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1604,14 +1604,6 @@ F:	Documentation/devicetree/bindings/arm/bitmain.yaml
 F:	Documentation/devicetree/bindings/clock/bitmain,bm1880-clk.yaml
 F:	Documentation/devicetree/bindings/pinctrl/bitmain,bm1880-pinctrl.txt
 
-ARM/CALXEDA HIGHBANK ARCHITECTURE
-M:	Rob Herring <robh@kernel.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	arch/arm/mach-highbank/
-F:	arch/arm/boot/dts/highbank.dts
-F:	arch/arm/boot/dts/ecx-*.dts*
-
 ARM/CAVIUM NETWORKS CNS3XXX MACHINE SUPPORT
 M:	Krzysztof Halasa <khalasa@piap.pl>
 S:	Maintained
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 97864aabc2a6..6f8ce7b38a46 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -640,8 +640,6 @@ source "arch/arm/mach-footbridge/Kconfig"
 
 source "arch/arm/mach-gemini/Kconfig"
 
-source "arch/arm/mach-highbank/Kconfig"
-
 source "arch/arm/mach-hisi/Kconfig"
 
 source "arch/arm/mach-imx/Kconfig"
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index b70d7debf5ca..66413f98cae9 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -346,14 +346,6 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on HI3620 UART.
 
-	config DEBUG_HIGHBANK_UART
-		bool "Kernel low-level debugging messages via Highbank UART"
-		depends on ARCH_HIGHBANK
-		select DEBUG_UART_PL01X
-		help
-		  Say Y here if you want the debug print routines to direct
-		  their output to the UART on Highbank based devices.
-
 	config DEBUG_HIP01_UART
 		bool "Hisilicon Hip01 Debug UART"
 		depends on ARCH_HIP01
@@ -1692,7 +1684,6 @@ config DEBUG_UART_PHYS
 	default 0xffc03000 if DEBUG_SOCFPGA_CYCLONE5_UART1
 	default 0xffe40000 if DEBUG_RCAR_GEN1_SCIF0
 	default 0xffe42000 if DEBUG_RCAR_GEN1_SCIF2
-	default 0xfff36000 if DEBUG_HIGHBANK_UART
 	default 0xfffb0000 if DEBUG_OMAP1UART1 || DEBUG_OMAP7XXUART1
 	default 0xfffb0800 if DEBUG_OMAP1UART2 || DEBUG_OMAP7XXUART2
 	default 0xfffb9800 if DEBUG_OMAP1UART3 || DEBUG_OMAP7XXUART3
@@ -1810,7 +1801,6 @@ config DEBUG_UART_VIRT
 	default 0xfee20000 if DEBUG_NSPIRE_CLASSIC_UART || DEBUG_NSPIRE_CX_UART
 	default 0xfef00000 if ARCH_IXP4XX && !CPU_BIG_ENDIAN
 	default 0xfef00003 if ARCH_IXP4XX && CPU_BIG_ENDIAN
-	default 0xfef36000 if DEBUG_HIGHBANK_UART
 	default 0xfefb0000 if DEBUG_OMAP1UART1 || DEBUG_OMAP7XXUART1
 	default 0xfefb0800 if DEBUG_OMAP1UART2 || DEBUG_OMAP7XXUART2
 	default 0xfefb9800 if DEBUG_OMAP1UART3 || DEBUG_OMAP7XXUART3
@@ -1873,7 +1863,7 @@ config DEBUG_UNCOMPRESS
 	  When this option is set, the selected DEBUG_LL output method
 	  will be re-used for normal decompressor output on multiplatform
 	  kernels.
-	  
+
 
 config UNCOMPRESS_INCLUDE
 	string
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index db857d07114f..fa3bc920e3ac 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -178,7 +178,6 @@ machine-$(CONFIG_ARCH_EP93XX)		+= ep93xx
 machine-$(CONFIG_ARCH_EXYNOS)		+= exynos
 machine-$(CONFIG_ARCH_FOOTBRIDGE)	+= footbridge
 machine-$(CONFIG_ARCH_GEMINI)		+= gemini
-machine-$(CONFIG_ARCH_HIGHBANK)		+= highbank
 machine-$(CONFIG_ARCH_HISI)		+= hisi
 machine-$(CONFIG_ARCH_INTEGRATOR)	+= integrator
 machine-$(CONFIG_ARCH_IOP32X)		+= iop32x
diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 017d65f86eba..69eb62f831c7 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -31,7 +31,6 @@ CONFIG_MACH_BERLIN_BG2CD=y
 CONFIG_MACH_BERLIN_BG2Q=y
 CONFIG_ARCH_DIGICOLOR=y
 CONFIG_ARCH_EXYNOS=y
-CONFIG_ARCH_HIGHBANK=y
 CONFIG_ARCH_HISI=y
 CONFIG_ARCH_HI3xxx=y
 CONFIG_ARCH_HIP01=y
@@ -236,7 +235,6 @@ CONFIG_AHCI_ST=y
 CONFIG_AHCI_IMX=y
 CONFIG_AHCI_SUNXI=y
 CONFIG_AHCI_TEGRA=y
-CONFIG_SATA_HIGHBANK=y
 CONFIG_SATA_MV=y
 CONFIG_SATA_RCAR=y
 CONFIG_NETDEVICES=y
@@ -250,7 +248,6 @@ CONFIG_BCMGENET=m
 CONFIG_BGMAC_BCMA=y
 CONFIG_SYSTEMPORT=m
 CONFIG_MACB=y
-CONFIG_NET_CALXEDA_XGMAC=y
 CONFIG_FTGMAC100=m
 CONFIG_GIANFAR=y
 CONFIG_HIX5HD2_GMAC=y
@@ -866,8 +863,6 @@ CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
 CONFIG_LEDS_TRIGGER_TRANSIENT=y
 CONFIG_LEDS_TRIGGER_CAMERA=y
 CONFIG_EDAC=y
-CONFIG_EDAC_HIGHBANK_MC=y
-CONFIG_EDAC_HIGHBANK_L2=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_AC100=y
 CONFIG_RTC_DRV_AS3722=y
diff --git a/arch/arm/mach-highbank/Kconfig b/arch/arm/mach-highbank/Kconfig
deleted file mode 100644
index 1bc68913d62c..000000000000
--- a/arch/arm/mach-highbank/Kconfig
+++ /dev/null
@@ -1,19 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-config ARCH_HIGHBANK
-	bool "Calxeda ECX-1000/2000 (Highbank/Midway)"
-	depends on ARCH_MULTI_V7
-	select ARCH_HAS_HOLES_MEMORYMODEL
-	select ARCH_SUPPORTS_BIG_ENDIAN
-	select ARM_AMBA
-	select ARM_ERRATA_764369 if SMP
-	select ARM_ERRATA_775420
-	select ARM_ERRATA_798181 if SMP
-	select ARM_GIC
-	select ARM_PSCI
-	select ARM_TIMER_SP804
-	select CACHE_L2X0
-	select HAVE_ARM_SCU
-	select HAVE_ARM_TWD if SMP
-	select MAILBOX
-	select PL320_MBOX
-	select ZONE_DMA if ARM_LPAE
diff --git a/arch/arm/mach-highbank/Makefile b/arch/arm/mach-highbank/Makefile
deleted file mode 100644
index 71cc68041d92..000000000000
--- a/arch/arm/mach-highbank/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-obj-y					:= highbank.o system.o smc.o
-
-obj-$(CONFIG_PM_SLEEP)			+= pm.o
diff --git a/arch/arm/mach-highbank/core.h b/arch/arm/mach-highbank/core.h
deleted file mode 100644
index 3991a6594ae5..000000000000
--- a/arch/arm/mach-highbank/core.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __HIGHBANK_CORE_H
-#define __HIGHBANK_CORE_H
-
-#include <linux/reboot.h>
-
-extern void highbank_restart(enum reboot_mode, const char *);
-extern void __iomem *scu_base_addr;
-
-#ifdef CONFIG_PM_SLEEP
-extern void highbank_pm_init(void);
-#else
-static inline void highbank_pm_init(void) {}
-#endif
-
-extern void highbank_smc1(int fn, int arg);
-
-#endif
diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
deleted file mode 100644
index 56bf29523c65..000000000000
--- a/arch/arm/mach-highbank/highbank.c
+++ /dev/null
@@ -1,175 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2010-2011 Calxeda, Inc.
- */
-#include <linux/clk.h>
-#include <linux/clkdev.h>
-#include <linux/clocksource.h>
-#include <linux/dma-mapping.h>
-#include <linux/input.h>
-#include <linux/io.h>
-#include <linux/irqchip.h>
-#include <linux/pl320-ipc.h>
-#include <linux/of.h>
-#include <linux/of_irq.h>
-#include <linux/of_address.h>
-#include <linux/reboot.h>
-#include <linux/amba/bus.h>
-#include <linux/platform_device.h>
-#include <linux/psci.h>
-
-#include <asm/hardware/cache-l2x0.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-
-#include "core.h"
-#include "sysregs.h"
-
-void __iomem *sregs_base;
-void __iomem *scu_base_addr;
-
-static void __init highbank_scu_map_io(void)
-{
-	unsigned long base;
-
-	/* Get SCU base */
-	asm("mrc p15, 4, %0, c15, c0, 0" : "=r" (base));
-
-	scu_base_addr = ioremap(base, SZ_4K);
-}
-
-
-static void highbank_l2c310_write_sec(unsigned long val, unsigned reg)
-{
-	if (reg == L2X0_CTRL)
-		highbank_smc1(0x102, val);
-	else
-		WARN_ONCE(1, "Highbank L2C310: ignoring write to reg 0x%x\n",
-			  reg);
-}
-
-static void __init highbank_init_irq(void)
-{
-	irqchip_init();
-
-	if (of_find_compatible_node(NULL, NULL, "arm,cortex-a9"))
-		highbank_scu_map_io();
-}
-
-static void highbank_power_off(void)
-{
-	highbank_set_pwr_shutdown();
-
-	while (1)
-		cpu_do_idle();
-}
-
-static int highbank_platform_notifier(struct notifier_block *nb,
-				  unsigned long event, void *__dev)
-{
-	struct resource *res;
-	int reg = -1;
-	u32 val;
-	struct device *dev = __dev;
-
-	if (event != BUS_NOTIFY_ADD_DEVICE)
-		return NOTIFY_DONE;
-
-	if (of_device_is_compatible(dev->of_node, "calxeda,hb-ahci"))
-		reg = 0xc;
-	else if (of_device_is_compatible(dev->of_node, "calxeda,hb-sdhci"))
-		reg = 0x18;
-	else if (of_device_is_compatible(dev->of_node, "arm,pl330"))
-		reg = 0x20;
-	else if (of_device_is_compatible(dev->of_node, "calxeda,hb-xgmac")) {
-		res = platform_get_resource(to_platform_device(dev),
-					    IORESOURCE_MEM, 0);
-		if (res) {
-			if (res->start == 0xfff50000)
-				reg = 0;
-			else if (res->start == 0xfff51000)
-				reg = 4;
-		}
-	}
-
-	if (reg < 0)
-		return NOTIFY_DONE;
-
-	if (of_property_read_bool(dev->of_node, "dma-coherent")) {
-		val = readl(sregs_base + reg);
-		writel(val | 0xff01, sregs_base + reg);
-		set_dma_ops(dev, &arm_coherent_dma_ops);
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block highbank_amba_nb = {
-	.notifier_call = highbank_platform_notifier,
-};
-
-static struct notifier_block highbank_platform_nb = {
-	.notifier_call = highbank_platform_notifier,
-};
-
-static struct platform_device highbank_cpuidle_device = {
-	.name = "cpuidle-calxeda",
-};
-
-static int hb_keys_notifier(struct notifier_block *nb, unsigned long event, void *data)
-{
-	u32 key = *(u32 *)data;
-
-	if (event != 0x1000)
-		return 0;
-
-	if (key == KEY_POWER)
-		orderly_poweroff(false);
-	else if (key == 0xffff)
-		ctrl_alt_del();
-
-	return 0;
-}
-static struct notifier_block hb_keys_nb = {
-	.notifier_call = hb_keys_notifier,
-};
-
-static void __init highbank_init(void)
-{
-	struct device_node *np;
-
-	/* Map system registers */
-	np = of_find_compatible_node(NULL, NULL, "calxeda,hb-sregs");
-	sregs_base = of_iomap(np, 0);
-	WARN_ON(!sregs_base);
-
-	pm_power_off = highbank_power_off;
-	highbank_pm_init();
-
-	bus_register_notifier(&platform_bus_type, &highbank_platform_nb);
-	bus_register_notifier(&amba_bustype, &highbank_amba_nb);
-
-	pl320_ipc_register_notifier(&hb_keys_nb);
-
-	if (psci_ops.cpu_suspend)
-		platform_device_register(&highbank_cpuidle_device);
-}
-
-static const char *const highbank_match[] __initconst = {
-	"calxeda,highbank",
-	"calxeda,ecx-2000",
-	NULL,
-};
-
-DT_MACHINE_START(HIGHBANK, "Highbank")
-#if defined(CONFIG_ZONE_DMA) && defined(CONFIG_ARM_LPAE)
-	.dma_zone_size	= (4ULL * SZ_1G),
-#endif
-	.l2c_aux_val	= 0,
-	.l2c_aux_mask	= ~0,
-	.l2c_write_sec	= highbank_l2c310_write_sec,
-	.init_irq	= highbank_init_irq,
-	.init_machine	= highbank_init,
-	.dt_compat	= highbank_match,
-	.restart	= highbank_restart,
-MACHINE_END
diff --git a/arch/arm/mach-highbank/pm.c b/arch/arm/mach-highbank/pm.c
deleted file mode 100644
index 561941baeda9..000000000000
--- a/arch/arm/mach-highbank/pm.c
+++ /dev/null
@@ -1,49 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2011 Calxeda, Inc.
- */
-
-#include <linux/cpu_pm.h>
-#include <linux/init.h>
-#include <linux/psci.h>
-#include <linux/suspend.h>
-
-#include <asm/suspend.h>
-
-#include <uapi/linux/psci.h>
-
-#define HIGHBANK_SUSPEND_PARAM \
-	((0 << PSCI_0_2_POWER_STATE_ID_SHIFT) | \
-	 (1 << PSCI_0_2_POWER_STATE_AFFL_SHIFT) | \
-	 (PSCI_POWER_STATE_TYPE_POWER_DOWN << PSCI_0_2_POWER_STATE_TYPE_SHIFT))
-
-static int highbank_suspend_finish(unsigned long val)
-{
-	return psci_ops.cpu_suspend(HIGHBANK_SUSPEND_PARAM, __pa(cpu_resume));
-}
-
-static int highbank_pm_enter(suspend_state_t state)
-{
-	cpu_pm_enter();
-	cpu_cluster_pm_enter();
-
-	cpu_suspend(0, highbank_suspend_finish);
-
-	cpu_cluster_pm_exit();
-	cpu_pm_exit();
-
-	return 0;
-}
-
-static const struct platform_suspend_ops highbank_pm_ops = {
-	.enter = highbank_pm_enter,
-	.valid = suspend_valid_only_mem,
-};
-
-void __init highbank_pm_init(void)
-{
-	if (!psci_ops.cpu_suspend)
-		return;
-
-	suspend_set_ops(&highbank_pm_ops);
-}
diff --git a/arch/arm/mach-highbank/smc.S b/arch/arm/mach-highbank/smc.S
deleted file mode 100644
index 78b3f19e7f37..000000000000
--- a/arch/arm/mach-highbank/smc.S
+++ /dev/null
@@ -1,25 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copied from omap44xx-smc.S Copyright (C) 2010 Texas Instruments, Inc.
- * Copyright 2012 Calxeda, Inc.
- */
-
-#include <linux/linkage.h>
-
-/*
- * This is common routine to manage secure monitor API
- * used to modify the PL310 secure registers.
- * 'r0' contains the value to be modified and 'r12' contains
- * the monitor API number.
- * Function signature : void highbank_smc1(u32 fn, u32 arg)
- */
-	.arch armv7-a
-	.arch_extension sec
-ENTRY(highbank_smc1)
-	stmfd   sp!, {r4-r11, lr}
-	mov	r12, r0
-	mov 	r0, r1
-	dsb
-	smc	#0
-	ldmfd   sp!, {r4-r11, pc}
-ENDPROC(highbank_smc1)
diff --git a/arch/arm/mach-highbank/sysregs.h b/arch/arm/mach-highbank/sysregs.h
deleted file mode 100644
index 3c13fdcafb1e..000000000000
--- a/arch/arm/mach-highbank/sysregs.h
+++ /dev/null
@@ -1,75 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright 2011 Calxeda, Inc.
- */
-#ifndef _MACH_HIGHBANK__SYSREGS_H_
-#define _MACH_HIGHBANK__SYSREGS_H_
-
-#include <linux/io.h>
-#include <linux/smp.h>
-#include <asm/smp_plat.h>
-#include <asm/smp_scu.h>
-#include "core.h"
-
-extern void __iomem *sregs_base;
-
-#define HB_SREG_A9_PWR_REQ		0xf00
-#define HB_SREG_A9_BOOT_STAT		0xf04
-#define HB_SREG_A9_BOOT_DATA		0xf08
-
-#define HB_PWR_SUSPEND			0
-#define HB_PWR_SOFT_RESET		1
-#define HB_PWR_HARD_RESET		2
-#define HB_PWR_SHUTDOWN			3
-
-#define SREG_CPU_PWR_CTRL(c)		(0x200 + ((c) * 4))
-
-static inline void highbank_set_core_pwr(void)
-{
-	int cpu = MPIDR_AFFINITY_LEVEL(cpu_logical_map(smp_processor_id()), 0);
-	if (scu_base_addr)
-		scu_power_mode(scu_base_addr, SCU_PM_POWEROFF);
-	else
-		writel_relaxed(1, sregs_base + SREG_CPU_PWR_CTRL(cpu));
-}
-
-static inline void highbank_clear_core_pwr(void)
-{
-	int cpu = MPIDR_AFFINITY_LEVEL(cpu_logical_map(smp_processor_id()), 0);
-	if (scu_base_addr)
-		scu_power_mode(scu_base_addr, SCU_PM_NORMAL);
-	else
-		writel_relaxed(0, sregs_base + SREG_CPU_PWR_CTRL(cpu));
-}
-
-static inline void highbank_set_pwr_suspend(void)
-{
-	writel(HB_PWR_SUSPEND, sregs_base + HB_SREG_A9_PWR_REQ);
-	highbank_set_core_pwr();
-}
-
-static inline void highbank_set_pwr_shutdown(void)
-{
-	writel(HB_PWR_SHUTDOWN, sregs_base + HB_SREG_A9_PWR_REQ);
-	highbank_set_core_pwr();
-}
-
-static inline void highbank_set_pwr_soft_reset(void)
-{
-	writel(HB_PWR_SOFT_RESET, sregs_base + HB_SREG_A9_PWR_REQ);
-	highbank_set_core_pwr();
-}
-
-static inline void highbank_set_pwr_hard_reset(void)
-{
-	writel(HB_PWR_HARD_RESET, sregs_base + HB_SREG_A9_PWR_REQ);
-	highbank_set_core_pwr();
-}
-
-static inline void highbank_clear_pwr_request(void)
-{
-	writel(~0UL, sregs_base + HB_SREG_A9_PWR_REQ);
-	highbank_clear_core_pwr();
-}
-
-#endif
diff --git a/arch/arm/mach-highbank/system.c b/arch/arm/mach-highbank/system.c
deleted file mode 100644
index b749c4a6ddf5..000000000000
--- a/arch/arm/mach-highbank/system.c
+++ /dev/null
@@ -1,22 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2011 Calxeda, Inc.
- */
-#include <linux/io.h>
-#include <asm/proc-fns.h>
-#include <linux/reboot.h>
-
-#include "core.h"
-#include "sysregs.h"
-
-void highbank_restart(enum reboot_mode mode, const char *cmd)
-{
-	if (mode == REBOOT_HARD)
-		highbank_set_pwr_hard_reset();
-	else
-		highbank_set_pwr_soft_reset();
-
-	while (1)
-		cpu_do_idle();
-}
-
-- 
2.20.1

