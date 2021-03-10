Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE3B333789
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbhCJIjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:39:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41185 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhCJIiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 03:38:52 -0500
Received: from mail-wm1-f70.google.com ([209.85.128.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lJuMl-0003hx-6D
        for netdev@vger.kernel.org; Wed, 10 Mar 2021 08:38:51 +0000
Received: by mail-wm1-f70.google.com with SMTP id m17so858455wml.3
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 00:38:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sJ+sWBPv8WTfBNPzw5KlNRJFjLSGVwyyKfH3WBvU8l8=;
        b=Hh770yF0hSXmLngoZGTStYx4jid0JHuKKFFPaC6hffOlOlAg1y9SlMJOubKWLRxm8I
         hVLW7t3EbMFdssYsZNY9AeO93ui6wCPs9whEJLsKwgrJKxeK/O0JGr61yzmGV65GkNzg
         OX4Az4IPhdVYalVET4sX1gmMgdvvxLKDls49qvKhWL9QdORKlMpe6bmoCZLPnuIZbfri
         TcMDZuHH61I8TSAywT6onM5KWL7XyL2lKL7evKBuPcrxL3MECsBPR2t2R2rTjBH/aPnj
         ASxpNQ7CdBeNlEoi2PfmHcvoiTGj10FNTdWYuD0A5AmCaN5DW88KCy7EfZNp1FszOw/R
         Wrgw==
X-Gm-Message-State: AOAM5320l4jyrxbs5b9fW/EdDCm1lXxPXSfRqcsgaOq4tzLOrA/nqqmB
        kB6nFeARv/FSBi9bK0zwYBUGe9ZpKs6ehh/zumBgN0ogw0nyxrwd5NKIA2VxXuJ1hJmQkUQ1lwK
        adfngo4KFa173RFgjOXQOKnshDQDjMNXNMQ==
X-Received: by 2002:a05:600c:35cd:: with SMTP id r13mr2199367wmq.186.1615365530695;
        Wed, 10 Mar 2021 00:38:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxffKMarXt3WZ+2PQHxVk57BSqlnROHSdAmLc0YNptS3mf1yMHQoutG4Gedc/GO/nV/7BS6Sw==
X-Received: by 2002:a05:600c:35cd:: with SMTP id r13mr2199348wmq.186.1615365530484;
        Wed, 10 Mar 2021 00:38:50 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id u20sm32781061wru.6.2021.03.10.00.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 00:38:50 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Moritz Fischer <mdf@kernel.org>, Tom Rix <trix@redhat.com>,
        Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-fpga@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        arm@kernel.org, soc@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [RFC v2 3/5] arm64: socfpga: rename ARCH_STRATIX10 to ARCH_SOCFPGA64
Date:   Wed, 10 Mar 2021 09:38:37 +0100
Message-Id: <20210310083840.481615-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310083327.480837-1-krzysztof.kozlowski@canonical.com>
References: <20210310083327.480837-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for merging Stratix 10, Agilex and N5X into one arm64
architecture by first renaming the ARCH_STRATIX10 into ARCH_SOCFPGA64.

The existing ARCH_SOCFPGA (in ARMv7) Kconfig symbol cannot be used
because altera_edac driver builds differently between them (with
ifdefs).

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/arm64/Kconfig.platforms                |  7 ++++---
 arch/arm64/boot/dts/altera/Makefile         |  2 +-
 arch/arm64/configs/defconfig                |  2 +-
 drivers/clk/Makefile                        |  2 +-
 drivers/clk/socfpga/Kconfig                 |  4 ++--
 drivers/edac/Kconfig                        |  2 +-
 drivers/edac/altera_edac.c                  | 10 +++++-----
 drivers/firmware/Kconfig                    |  2 +-
 drivers/fpga/Kconfig                        |  2 +-
 drivers/mfd/Kconfig                         |  2 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig |  4 ++--
 drivers/reset/Kconfig                       |  2 +-
 12 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
index cdfd5fed457f..78bba3633eab 100644
--- a/arch/arm64/Kconfig.platforms
+++ b/arch/arm64/Kconfig.platforms
@@ -254,10 +254,11 @@ config ARCH_SEATTLE
 	help
 	  This enables support for AMD Seattle SOC Family
 
-config ARCH_STRATIX10
-	bool "Altera's Stratix 10 SoCFPGA Family"
+config ARCH_SOCFPGA64
+	bool "Intel's SoCFPGA ARMv8 Families"
 	help
-	  This enables support for Altera's Stratix 10 SoCFPGA Family.
+	  This enables support for Intel's SoCFPGA ARMv8 families:
+	  Stratix 10 (ex. Altera), Agilex and eASIC N5X.
 
 config ARCH_SYNQUACER
 	bool "Socionext SynQuacer SoC Family"
diff --git a/arch/arm64/boot/dts/altera/Makefile b/arch/arm64/boot/dts/altera/Makefile
index 10119c7ab437..b45b92f8b4ec 100644
--- a/arch/arm64/boot/dts/altera/Makefile
+++ b/arch/arm64/boot/dts/altera/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-dtb-$(CONFIG_ARCH_STRATIX10) += socfpga_stratix10_socdk.dtb \
+dtb-$(CONFIG_ARCH_SOCFPGA64) += socfpga_stratix10_socdk.dtb \
 				socfpga_stratix10_socdk_nand.dtb
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index d612f633b771..ee742900a150 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -50,7 +50,7 @@ CONFIG_ARCH_RENESAS=y
 CONFIG_ARCH_ROCKCHIP=y
 CONFIG_ARCH_S32=y
 CONFIG_ARCH_SEATTLE=y
-CONFIG_ARCH_STRATIX10=y
+CONFIG_ARCH_SOCFPGA64=y
 CONFIG_ARCH_SYNQUACER=y
 CONFIG_ARCH_TEGRA=y
 CONFIG_ARCH_SPRD=y
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 12e46b12e587..e34457539edf 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -107,7 +107,7 @@ obj-$(CONFIG_CLK_SIFIVE)		+= sifive/
 obj-$(CONFIG_ARCH_SOCFPGA)		+= socfpga/
 obj-$(CONFIG_ARCH_AGILEX)		+= socfpga/
 obj-$(CONFIG_ARCH_N5X)			+= socfpga/
-obj-$(CONFIG_ARCH_STRATIX10)		+= socfpga/
+obj-$(CONFIG_ARCH_SOCFPGA64)		+= socfpga/
 obj-$(CONFIG_PLAT_SPEAR)		+= spear/
 obj-y					+= sprd/
 obj-$(CONFIG_ARCH_STI)			+= st/
diff --git a/drivers/clk/socfpga/Kconfig b/drivers/clk/socfpga/Kconfig
index 7d4772faf93d..8cf3dfdba255 100644
--- a/drivers/clk/socfpga/Kconfig
+++ b/drivers/clk/socfpga/Kconfig
@@ -2,5 +2,5 @@
 config COMMON_CLK_SOCFPGA64
 	bool
 	# Intel Stratix / Agilex / N5X clock controller support
-	default y if ARCH_AGILEX || ARCH_N5X || ARCH_STRATIX10
-	depends on ARCH_AGILEX || ARCH_N5X || ARCH_STRATIX10
+	default y if ARCH_AGILEX || ARCH_N5X || ARCH_SOCFPGA64
+	depends on ARCH_AGILEX || ARCH_N5X || ARCH_SOCFPGA64
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 27d0c4cdc58d..97fa2056bd47 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -396,7 +396,7 @@ config EDAC_THUNDERX
 
 config EDAC_ALTERA
 	bool "Altera SOCFPGA ECC"
-	depends on EDAC=y && (ARCH_SOCFPGA || ARCH_STRATIX10)
+	depends on EDAC=y && (ARCH_SOCFPGA || ARCH_SOCFPGA64)
 	help
 	  Support for error detection and correction on the
 	  Altera SOCs. This is the global enable for the
diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index e91cf1147a4e..ba11219664ca 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1502,7 +1502,7 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 	dci->dev_name = ecc_name;
 
 	/* Update the PortB IRQs - A10 has 4, S10 has 2, Index accordingly */
-#ifdef CONFIG_ARCH_STRATIX10
+#ifdef CONFIG_ARCH_SOCFPGA64
 	altdev->sb_irq = irq_of_parse_and_map(np, 1);
 #else
 	altdev->sb_irq = irq_of_parse_and_map(np, 2);
@@ -1521,7 +1521,7 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 		goto err_release_group_1;
 	}
 
-#ifdef CONFIG_ARCH_STRATIX10
+#ifdef CONFIG_ARCH_SOCFPGA64
 	/* Use IRQ to determine SError origin instead of assigning IRQ */
 	rc = of_property_read_u32_index(np, "interrupts", 1, &altdev->db_irq);
 	if (rc) {
@@ -1931,7 +1931,7 @@ static int altr_edac_a10_device_add(struct altr_arria10_edac *edac,
 		goto err_release_group1;
 	}
 
-#ifdef CONFIG_ARCH_STRATIX10
+#ifdef CONFIG_ARCH_SOCFPGA64
 	/* Use IRQ to determine SError origin instead of assigning IRQ */
 	rc = of_property_read_u32_index(np, "interrupts", 0, &altdev->db_irq);
 	if (rc) {
@@ -2016,7 +2016,7 @@ static const struct irq_domain_ops a10_eccmgr_ic_ops = {
 /************** Stratix 10 EDAC Double Bit Error Handler ************/
 #define to_a10edac(p, m) container_of(p, struct altr_arria10_edac, m)
 
-#ifdef CONFIG_ARCH_STRATIX10
+#ifdef CONFIG_ARCH_SOCFPGA64
 /* panic routine issues reboot on non-zero panic_timeout */
 extern int panic_timeout;
 
@@ -2109,7 +2109,7 @@ static int altr_edac_a10_probe(struct platform_device *pdev)
 					 altr_edac_a10_irq_handler,
 					 edac);
 
-#ifdef CONFIG_ARCH_STRATIX10
+#ifdef CONFIG_ARCH_SOCFPGA64
 	{
 		int dberror, err_addr;
 
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 3f14dffb9669..59660798f05f 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -206,7 +206,7 @@ config FW_CFG_SYSFS_CMDLINE
 
 config INTEL_STRATIX10_SERVICE
 	tristate "Intel Stratix10 Service Layer"
-	depends on (ARCH_STRATIX10 || ARCH_AGILEX) && HAVE_ARM_SMCCC
+	depends on (ARCH_SOCFPGA64 || ARCH_AGILEX) && HAVE_ARM_SMCCC
 	default n
 	help
 	  Intel Stratix10 service layer runs at privileged exception level,
diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index 5ff9438b7b46..7f7504d1c961 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -60,7 +60,7 @@ config FPGA_MGR_ZYNQ_FPGA
 
 config FPGA_MGR_STRATIX10_SOC
 	tristate "Intel Stratix10 SoC FPGA Manager"
-	depends on (ARCH_STRATIX10 && INTEL_STRATIX10_SERVICE)
+	depends on (ARCH_SOCFPGA64 && INTEL_STRATIX10_SERVICE)
 	help
 	  FPGA manager driver support for the Intel Stratix10 SoC.
 
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index a03de3f7a8ed..8fbd10cc6944 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -32,7 +32,7 @@ config MFD_ALTERA_A10SR
 
 config MFD_ALTERA_SYSMGR
 	bool "Altera SOCFPGA System Manager"
-	depends on (ARCH_SOCFPGA || ARCH_STRATIX10) && OF
+	depends on (ARCH_SOCFPGA || ARCH_SOCFPGA64) && OF
 	select MFD_SYSCON
 	help
 	  Select this to get System Manager support for all Altera branded
diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index e675ba12fde2..ab6eb792fbdb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -140,8 +140,8 @@ config DWMAC_ROCKCHIP
 
 config DWMAC_SOCFPGA
 	tristate "SOCFPGA dwmac support"
-	default (ARCH_SOCFPGA || ARCH_STRATIX10)
-	depends on OF && (ARCH_SOCFPGA || ARCH_STRATIX10 || COMPILE_TEST)
+	default (ARCH_SOCFPGA || ARCH_SOCFPGA64)
+	depends on OF && (ARCH_SOCFPGA || ARCH_SOCFPGA64 || COMPILE_TEST)
 	select MFD_SYSCON
 	help
 	  Support for ethernet controller on Altera SOCFPGA
diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index 4171c6f76385..fa7f1394697b 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -183,7 +183,7 @@ config RESET_SCMI
 
 config RESET_SIMPLE
 	bool "Simple Reset Controller Driver" if COMPILE_TEST
-	default ARCH_AGILEX || ARCH_ASPEED || ARCH_BCM4908 || ARCH_BITMAIN || ARCH_REALTEK || ARCH_STM32 || ARCH_STRATIX10 || ARCH_SUNXI || ARC
+	default ARCH_AGILEX || ARCH_ASPEED || ARCH_BCM4908 || ARCH_BITMAIN || ARCH_REALTEK || ARCH_STM32 || ARCH_SOCFPGA64 || ARCH_SUNXI || ARC
 	help
 	  This enables a simple reset controller driver for reset lines that
 	  that can be asserted and deasserted by toggling bits in a contiguous,
-- 
2.25.1

