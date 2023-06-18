Return-Path: <netdev+bounces-11772-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 236DA734653
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 15:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DFC41C209E9
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 13:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B93184C;
	Sun, 18 Jun 2023 13:23:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163C02103
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 13:23:35 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7165D10EA;
	Sun, 18 Jun 2023 06:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687094600; x=1718630600;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=smWl5ah5P/0V1pO6ueK2N3Uy7j2KbeEIkqx27f0W3g4=;
  b=Cq/w1qMjbTe9YxOaRy/hxtjFdsHo7xhu/iHyG2c0GFsB7Cc4QyB1rgAb
   Vh3dMpddwo9fB0wgXYIJFfUguVvtNHRT4tNUC1XsiUH+qr5//HpljhuMN
   LsuAd/eEj7nC3QusTg/SKl320RKALRW8aOV5PmTpqb8Hoy2jIzTOWqRdX
   /YT06ChSz2B5uy1KAmTU79AU2WRQWg0uBTAHg7wxE6IuotxO+ODW8VgXQ
   v5b69ZqE3XGMcCcWdYThuQ0PWJZShNriX72JHz8bYNLzxPKUUcKdqPCce
   x9CQPNtuinjNtvGyPhHDzyfAcBtJ+6hY2oJwBGgpKRmb7ZTEquHjxwSRX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="356967059"
X-IronPort-AV: E=Sophos;i="6.00,252,1681196400"; 
   d="scan'208";a="356967059"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2023 06:23:19 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="747146795"
X-IronPort-AV: E=Sophos;i="6.00,252,1681196400"; 
   d="scan'208";a="747146795"
Received: from unknown (HELO localhost.localdomain) ([10.226.216.116])
  by orsmga001.jf.intel.com with ESMTP; 18 Jun 2023 06:23:15 -0700
From: niravkumar.l.rabara@intel.com
To: Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Wen Ping <wen.ping.teh@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	netdev@vger.kernel.org,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@intel.com>
Subject: [PATCH 2/4] dt-bindings: clock: Add Intel Agilex5 clocks and resets
Date: Sun, 18 Jun 2023 21:22:33 +0800
Message-Id: <20230618132235.728641-3-niravkumar.l.rabara@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230618132235.728641-1-niravkumar.l.rabara@intel.com>
References: <20230618132235.728641-1-niravkumar.l.rabara@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>

Add clock and reset ID definitions for Intel Agilex5 SoCFPGA

Co-developed-by: Teh Wen Ping <wen.ping.teh@intel.com>
Signed-off-by: Teh Wen Ping <wen.ping.teh@intel.com>
Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
---
 .../bindings/clock/intel,agilex5.yaml         |  42 ++++++++
 include/dt-bindings/clock/agilex5-clock.h     | 100 ++++++++++++++++++
 .../dt-bindings/reset/altr,rst-mgr-agilex5.h  |  79 ++++++++++++++
 3 files changed, 221 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/intel,agilex5.yaml
 create mode 100644 include/dt-bindings/clock/agilex5-clock.h
 create mode 100644 include/dt-bindings/reset/altr,rst-mgr-agilex5.h

diff --git a/Documentation/devicetree/bindings/clock/intel,agilex5.yaml b/Documentation/devicetree/bindings/clock/intel,agilex5.yaml
new file mode 100644
index 000000000000..e408c52deefa
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/intel,agilex5.yaml
@@ -0,0 +1,42 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/clock/intel,agilex5.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Intel SoCFPGA Agilex5 platform clock controller binding
+
+maintainers:
+  - Teh Wen Ping <wen.ping.teh@intel.com>
+  - Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
+
+description:
+  The Intel Agilex5 Clock controller is an integrated clock controller, which
+  generates and supplies to all modules.
+
+properties:
+  compatible:
+    const: intel,agilex5-clkmgr
+
+  '#clock-cells':
+    const: 1
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - '#clock-cells'
+
+additionalProperties: false
+
+examples:
+  # Clock controller node:
+  - |
+    clkmgr: clock-controller@10d10000 {
+      compatible = "intel,agilex5-clkmgr";
+      reg = <0x10d10000 0x1000>;
+      #clock-cells = <1>;
+    };
+...
diff --git a/include/dt-bindings/clock/agilex5-clock.h b/include/dt-bindings/clock/agilex5-clock.h
new file mode 100644
index 000000000000..4505b352cd83
--- /dev/null
+++ b/include/dt-bindings/clock/agilex5-clock.h
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
+/*
+ * Copyright (C) 2022, Intel Corporation
+ */
+
+#ifndef __AGILEX5_CLOCK_H
+#define __AGILEX5_CLOCK_H
+
+/* fixed rate clocks */
+#define AGILEX5_OSC1			0
+#define AGILEX5_CB_INTOSC_HS_DIV2_CLK	1
+#define AGILEX5_CB_INTOSC_LS_CLK	2
+#define AGILEX5_F2S_FREE_CLK		3
+
+/* PLL clocks */
+#define AGILEX5_MAIN_PLL_CLK		4
+#define AGILEX5_MAIN_PLL_C0_CLK		5
+#define AGILEX5_MAIN_PLL_C1_CLK		6
+#define AGILEX5_MAIN_PLL_C2_CLK		7
+#define AGILEX5_MAIN_PLL_C3_CLK		8
+#define AGILEX5_PERIPH_PLL_CLK		9
+#define AGILEX5_PERIPH_PLL_C0_CLK	10
+#define AGILEX5_PERIPH_PLL_C1_CLK	11
+#define AGILEX5_PERIPH_PLL_C2_CLK	12
+#define AGILEX5_PERIPH_PLL_C3_CLK	13
+#define AGILEX5_CORE0_FREE_CLK		14
+#define AGILEX5_CORE1_FREE_CLK		15
+#define AGILEX5_CORE2_FREE_CLK		16
+#define AGILEX5_CORE3_FREE_CLK		17
+#define AGILEX5_DSU_FREE_CLK		18
+#define AGILEX5_BOOT_CLK		19
+
+/* fixed factor clocks */
+#define AGILEX5_L3_MAIN_FREE_CLK	20
+#define AGILEX5_NOC_FREE_CLK		21
+#define AGILEX5_S2F_USR0_CLK		22
+#define AGILEX5_NOC_CLK			23
+#define AGILEX5_EMAC_A_FREE_CLK		24
+#define AGILEX5_EMAC_B_FREE_CLK		25
+#define AGILEX5_EMAC_PTP_FREE_CLK	26
+#define AGILEX5_GPIO_DB_FREE_CLK	27
+#define AGILEX5_S2F_USER0_FREE_CLK	28
+#define AGILEX5_S2F_USER1_FREE_CLK	29
+#define AGILEX5_PSI_REF_FREE_CLK	30
+#define AGILEX5_USB31_FREE_CLK		31
+
+/* Gate clocks */
+#define AGILEX5_CORE0_CLK		32
+#define AGILEX5_CORE1_CLK		33
+#define AGILEX5_CORE2_CLK		34
+#define AGILEX5_CORE3_CLK		35
+#define AGILEX5_MPU_CLK			36
+#define AGILEX5_MPU_PERIPH_CLK		37
+#define AGILEX5_MPU_CCU_CLK		38
+#define AGILEX5_L4_MAIN_CLK		39
+#define AGILEX5_L4_MP_CLK		40
+#define AGILEX5_L4_SYS_FREE_CLK		41
+#define AGILEX5_L4_SP_CLK		42
+#define AGILEX5_CS_AT_CLK		43
+#define AGILEX5_CS_TRACE_CLK		44
+#define AGILEX5_CS_PDBG_CLK		45
+#define AGILEX5_EMAC1_CLK		47
+#define AGILEX5_EMAC2_CLK		48
+#define AGILEX5_EMAC_PTP_CLK		49
+#define AGILEX5_GPIO_DB_CLK		50
+#define AGILEX5_S2F_USER0_CLK		51
+#define AGILEX5_S2F_USER1_CLK		52
+#define AGILEX5_PSI_REF_CLK		53
+#define AGILEX5_USB31_SUSPEND_CLK	54
+#define AGILEX5_EMAC0_CLK		46
+#define AGILEX5_USB31_BUS_CLK_EARLY	55
+#define AGILEX5_USB2OTG_HCLK		56
+#define AGILEX5_SPIM_0_CLK		57
+#define AGILEX5_SPIM_1_CLK		58
+#define AGILEX5_SPIS_0_CLK		59
+#define AGILEX5_SPIS_1_CLK		60
+#define AGILEX5_DMA_CORE_CLK		61
+#define AGILEX5_DMA_HS_CLK		62
+#define AGILEX5_I3C_0_CORE_CLK		63
+#define AGILEX5_I3C_1_CORE_CLK		64
+#define AGILEX5_I2C_0_PCLK		65
+#define AGILEX5_I2C_1_PCLK		66
+#define AGILEX5_I2C_EMAC0_PCLK		67
+#define AGILEX5_I2C_EMAC1_PCLK		68
+#define AGILEX5_I2C_EMAC2_PCLK		69
+#define AGILEX5_UART_0_PCLK		70
+#define AGILEX5_UART_1_PCLK		71
+#define AGILEX5_SPTIMER_0_PCLK		72
+#define AGILEX5_SPTIMER_1_PCLK		73
+#define AGILEX5_DFI_CLK			74
+#define AGILEX5_NAND_NF_CLK		75
+#define AGILEX5_NAND_BCH_CLK		76
+#define AGILEX5_SDMMC_SDPHY_REG_CLK	77
+#define AGILEX5_SDMCLK			78
+#define AGILEX5_SOFTPHY_REG_PCLK	79
+#define AGILEX5_SOFTPHY_PHY_CLK		80
+#define AGILEX5_SOFTPHY_CTRL_CLK	81
+#define AGILEX5_NUM_CLKS		82
+
+#endif	/* __AGILEX5_CLOCK_H */
diff --git a/include/dt-bindings/reset/altr,rst-mgr-agilex5.h b/include/dt-bindings/reset/altr,rst-mgr-agilex5.h
new file mode 100644
index 000000000000..81e5e8c89893
--- /dev/null
+++ b/include/dt-bindings/reset/altr,rst-mgr-agilex5.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
+/*
+ * Copyright (C) 2023 Intel Corporation. All rights reserved
+ *
+ */
+
+#ifndef _DT_BINDINGS_RESET_ALTR_RST_MGR_AGILEX5_H
+#define _DT_BINDINGS_RESET_ALTR_RST_MGR_AGILEX5_H
+
+/* PER0MODRST */
+#define EMAC0_RESET		32
+#define EMAC1_RESET		33
+#define EMAC2_RESET		34
+#define USB0_RESET		35
+#define USB1_RESET		36
+#define NAND_RESET		37
+#define SOFT_PHY_RESET		38
+#define SDMMC_RESET		39
+#define EMAC0_OCP_RESET		40
+#define EMAC1_OCP_RESET		41
+#define EMAC2_OCP_RESET		42
+#define USB0_OCP_RESET		43
+#define USB1_OCP_RESET		44
+#define NAND_OCP_RESET		45
+/* 46 is empty */
+#define SDMMC_OCP_RESET		47
+#define DMA_RESET		48
+#define SPIM0_RESET		49
+#define SPIM1_RESET		50
+#define SPIS0_RESET		51
+#define SPIS1_RESET		52
+#define DMA_OCP_RESET		53
+#define EMAC_PTP_RESET		54
+/* 55 is empty*/
+#define DMAIF0_RESET		56
+#define DMAIF1_RESET		57
+#define DMAIF2_RESET		58
+#define DMAIF3_RESET		59
+#define DMAIF4_RESET		60
+#define DMAIF5_RESET		61
+#define DMAIF6_RESET		62
+#define DMAIF7_RESET		63
+
+/* PER1MODRST */
+#define WATCHDOG0_RESET		64
+#define WATCHDOG1_RESET		65
+#define WATCHDOG2_RESET		66
+#define WATCHDOG3_RESET		67
+#define L4SYSTIMER0_RESET	68
+#define L4SYSTIMER1_RESET	69
+#define SPTIMER0_RESET		70
+#define SPTIMER1_RESET		71
+#define I2C0_RESET		72
+#define I2C1_RESET		73
+#define I2C2_RESET		74
+#define I2C3_RESET		75
+#define I2C4_RESET		76
+#define I3C0_RESET		77
+#define I3C1_RESET		78
+/* 79 is empty */
+#define UART0_RESET		80
+#define UART1_RESET		81
+/* 82-87 is empty */
+#define GPIO0_RESET		88
+#define GPIO1_RESET		89
+#define WATCHDOG4_RESET		90
+
+/* BRGMODRST */
+#define SOC2FPGA_RESET		96
+#define LWHPS2FPGA_RESET	97
+#define FPGA2SOC_RESET		98
+#define F2SSDRAM0_RESET		99
+/* 100-101 is empty */
+#define MPFE_RESET		102
+
+/* DBGMODRST */
+#define DBG_RESET		128
+
+#endif
-- 
2.25.1


