Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CFB47BD70
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 10:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbhLUJsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 04:48:23 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:14955 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236699AbhLUJsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 04:48:18 -0500
X-IronPort-AV: E=Sophos;i="5.88,223,1635174000"; 
   d="scan'208";a="104695791"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 21 Dec 2021 18:48:16 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id E0DC64006199;
        Tue, 21 Dec 2021 18:48:11 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        dmaengine@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH 08/16] dt-bindings: clock: Add R9A07G054 CPG Clock and Reset Definitions
Date:   Tue, 21 Dec 2021 09:47:09 +0000
Message-Id: <20211221094717.16187-9-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

Define RZ/V2L (R9A07G054) Clock Pulse Generator Core Clock and module
clock outputs, as listed in Table 7.1.4.2 ("Clock List r1.0") and also
add Reset definitions referring to registers CPG_RST_* in Section 7.2.3
("Register configuration") of the RZ/V2L Hardware User's Manual (Rev.1.00,
Nov.2021).

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 include/dt-bindings/clock/r9a07g054-cpg.h | 226 ++++++++++++++++++++++
 1 file changed, 226 insertions(+)
 create mode 100644 include/dt-bindings/clock/r9a07g054-cpg.h

diff --git a/include/dt-bindings/clock/r9a07g054-cpg.h b/include/dt-bindings/clock/r9a07g054-cpg.h
new file mode 100644
index 000000000000..fa338a7827bd
--- /dev/null
+++ b/include/dt-bindings/clock/r9a07g054-cpg.h
@@ -0,0 +1,226 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+ *
+ * Copyright (C) 2021 Renesas Electronics Corp.
+ */
+#ifndef __DT_BINDINGS_CLOCK_R9A07G054_CPG_H__
+#define __DT_BINDINGS_CLOCK_R9A07G054_CPG_H__
+
+#include <dt-bindings/clock/renesas-cpg-mssr.h>
+
+/* R9A07G054 CPG Core Clocks */
+#define R9A07G054_CLK_I			0
+#define R9A07G054_CLK_I2		1
+#define R9A07G054_CLK_G			2
+#define R9A07G054_CLK_S0		3
+#define R9A07G054_CLK_S1		4
+#define R9A07G054_CLK_SPI0		5
+#define R9A07G054_CLK_SPI1		6
+#define R9A07G054_CLK_SD0		7
+#define R9A07G054_CLK_SD1		8
+#define R9A07G054_CLK_M0		9
+#define R9A07G054_CLK_M1		10
+#define R9A07G054_CLK_M2		11
+#define R9A07G054_CLK_M3		12
+#define R9A07G054_CLK_M4		13
+#define R9A07G054_CLK_HP		14
+#define R9A07G054_CLK_TSU		15
+#define R9A07G054_CLK_ZT		16
+#define R9A07G054_CLK_P0		17
+#define R9A07G054_CLK_P1		18
+#define R9A07G054_CLK_P2		19
+#define R9A07G054_CLK_AT		20
+#define R9A07G054_OSCCLK		21
+#define R9A07G054_CLK_P0_DIV2		22
+
+/* R9A07G054 Module Clocks */
+#define R9A07G054_CA55_SCLK		0
+#define R9A07G054_CA55_PCLK		1
+#define R9A07G054_CA55_ATCLK		2
+#define R9A07G054_CA55_GICCLK		3
+#define R9A07G054_CA55_PERICLK		4
+#define R9A07G054_CA55_ACLK		5
+#define R9A07G054_CA55_TSCLK		6
+#define R9A07G054_GIC600_GICCLK		7
+#define R9A07G054_IA55_CLK		8
+#define R9A07G054_IA55_PCLK		9
+#define R9A07G054_MHU_PCLK		10
+#define R9A07G054_SYC_CNT_CLK		11
+#define R9A07G054_DMAC_ACLK		12
+#define R9A07G054_DMAC_PCLK		13
+#define R9A07G054_OSTM0_PCLK		14
+#define R9A07G054_OSTM1_PCLK		15
+#define R9A07G054_OSTM2_PCLK		16
+#define R9A07G054_MTU_X_MCK_MTU3	17
+#define R9A07G054_POE3_CLKM_POE		18
+#define R9A07G054_GPT_PCLK		19
+#define R9A07G054_POEG_A_CLKP		20
+#define R9A07G054_POEG_B_CLKP		21
+#define R9A07G054_POEG_C_CLKP		22
+#define R9A07G054_POEG_D_CLKP		23
+#define R9A07G054_WDT0_PCLK		24
+#define R9A07G054_WDT0_CLK		25
+#define R9A07G054_WDT1_PCLK		26
+#define R9A07G054_WDT1_CLK		27
+#define R9A07G054_WDT2_PCLK		28
+#define R9A07G054_WDT2_CLK		29
+#define R9A07G054_SPI_CLK2		30
+#define R9A07G054_SPI_CLK		31
+#define R9A07G054_SDHI0_IMCLK		32
+#define R9A07G054_SDHI0_IMCLK2		33
+#define R9A07G054_SDHI0_CLK_HS		34
+#define R9A07G054_SDHI0_ACLK		35
+#define R9A07G054_SDHI1_IMCLK		36
+#define R9A07G054_SDHI1_IMCLK2		37
+#define R9A07G054_SDHI1_CLK_HS		38
+#define R9A07G054_SDHI1_ACLK		39
+#define R9A07G054_GPU_CLK		40
+#define R9A07G054_GPU_AXI_CLK		41
+#define R9A07G054_GPU_ACE_CLK		42
+#define R9A07G054_ISU_ACLK		43
+#define R9A07G054_ISU_PCLK		44
+#define R9A07G054_H264_CLK_A		45
+#define R9A07G054_H264_CLK_P		46
+#define R9A07G054_CRU_SYSCLK		47
+#define R9A07G054_CRU_VCLK		48
+#define R9A07G054_CRU_PCLK		49
+#define R9A07G054_CRU_ACLK		50
+#define R9A07G054_MIPI_DSI_PLLCLK	51
+#define R9A07G054_MIPI_DSI_SYSCLK	52
+#define R9A07G054_MIPI_DSI_ACLK		53
+#define R9A07G054_MIPI_DSI_PCLK		54
+#define R9A07G054_MIPI_DSI_VCLK		55
+#define R9A07G054_MIPI_DSI_LPCLK	56
+#define R9A07G054_LCDC_CLK_A		57
+#define R9A07G054_LCDC_CLK_P		58
+#define R9A07G054_LCDC_CLK_D		59
+#define R9A07G054_SSI0_PCLK2		60
+#define R9A07G054_SSI0_PCLK_SFR		61
+#define R9A07G054_SSI1_PCLK2		62
+#define R9A07G054_SSI1_PCLK_SFR		63
+#define R9A07G054_SSI2_PCLK2		64
+#define R9A07G054_SSI2_PCLK_SFR		65
+#define R9A07G054_SSI3_PCLK2		66
+#define R9A07G054_SSI3_PCLK_SFR		67
+#define R9A07G054_SRC_CLKP		68
+#define R9A07G054_USB_U2H0_HCLK		69
+#define R9A07G054_USB_U2H1_HCLK		70
+#define R9A07G054_USB_U2P_EXR_CPUCLK	71
+#define R9A07G054_USB_PCLK		72
+#define R9A07G054_ETH0_CLK_AXI		73
+#define R9A07G054_ETH0_CLK_CHI		74
+#define R9A07G054_ETH1_CLK_AXI		75
+#define R9A07G054_ETH1_CLK_CHI		76
+#define R9A07G054_I2C0_PCLK		77
+#define R9A07G054_I2C1_PCLK		78
+#define R9A07G054_I2C2_PCLK		79
+#define R9A07G054_I2C3_PCLK		80
+#define R9A07G054_SCIF0_CLK_PCK		81
+#define R9A07G054_SCIF1_CLK_PCK		82
+#define R9A07G054_SCIF2_CLK_PCK		83
+#define R9A07G054_SCIF3_CLK_PCK		84
+#define R9A07G054_SCIF4_CLK_PCK		85
+#define R9A07G054_SCI0_CLKP		86
+#define R9A07G054_SCI1_CLKP		87
+#define R9A07G054_IRDA_CLKP		88
+#define R9A07G054_RSPI0_CLKB		89
+#define R9A07G054_RSPI1_CLKB		90
+#define R9A07G054_RSPI2_CLKB		91
+#define R9A07G054_CANFD_PCLK		92
+#define R9A07G054_GPIO_HCLK		93
+#define R9A07G054_ADC_ADCLK		94
+#define R9A07G054_ADC_PCLK		95
+#define R9A07G054_TSU_PCLK		96
+#define R9A07G054_STPAI_INITCLK		97
+#define R9A07G054_STPAI_ACLK		98
+#define R9A07G054_STPAI_MCLK		99
+#define R9A07G054_STPAI_DCLKIN		100
+#define R9A07G054_STPAI_ACLK_DRP	101
+
+/* R9A07G054 Resets */
+#define R9A07G054_CA55_RST_1_0		0
+#define R9A07G054_CA55_RST_1_1		1
+#define R9A07G054_CA55_RST_3_0		2
+#define R9A07G054_CA55_RST_3_1		3
+#define R9A07G054_CA55_RST_4		4
+#define R9A07G054_CA55_RST_5		5
+#define R9A07G054_CA55_RST_6		6
+#define R9A07G054_CA55_RST_7		7
+#define R9A07G054_CA55_RST_8		8
+#define R9A07G054_CA55_RST_9		9
+#define R9A07G054_CA55_RST_10		10
+#define R9A07G054_CA55_RST_11		11
+#define R9A07G054_CA55_RST_12		12
+#define R9A07G054_GIC600_GICRESET_N	13
+#define R9A07G054_GIC600_DBG_GICRESET_N	14
+#define R9A07G054_IA55_RESETN		15
+#define R9A07G054_MHU_RESETN		16
+#define R9A07G054_DMAC_ARESETN		17
+#define R9A07G054_DMAC_RST_ASYNC	18
+#define R9A07G054_SYC_RESETN		19
+#define R9A07G054_OSTM0_PRESETZ		20
+#define R9A07G054_OSTM1_PRESETZ		21
+#define R9A07G054_OSTM2_PRESETZ		22
+#define R9A07G054_MTU_X_PRESET_MTU3	23
+#define R9A07G054_POE3_RST_M_REG	24
+#define R9A07G054_GPT_RST_C		25
+#define R9A07G054_POEG_A_RST		26
+#define R9A07G054_POEG_B_RST		27
+#define R9A07G054_POEG_C_RST		28
+#define R9A07G054_POEG_D_RST		29
+#define R9A07G054_WDT0_PRESETN		30
+#define R9A07G054_WDT1_PRESETN		31
+#define R9A07G054_WDT2_PRESETN		32
+#define R9A07G054_SPI_RST		33
+#define R9A07G054_SDHI0_IXRST		34
+#define R9A07G054_SDHI1_IXRST		35
+#define R9A07G054_GPU_RESETN		36
+#define R9A07G054_GPU_AXI_RESETN	37
+#define R9A07G054_GPU_ACE_RESETN	38
+#define R9A07G054_ISU_ARESETN		39
+#define R9A07G054_ISU_PRESETN		40
+#define R9A07G054_H264_X_RESET_VCP	41
+#define R9A07G054_H264_CP_PRESET_P	42
+#define R9A07G054_CRU_CMN_RSTB		43
+#define R9A07G054_CRU_PRESETN		44
+#define R9A07G054_CRU_ARESETN		45
+#define R9A07G054_MIPI_DSI_CMN_RSTB	46
+#define R9A07G054_MIPI_DSI_ARESET_N	47
+#define R9A07G054_MIPI_DSI_PRESET_N	48
+#define R9A07G054_LCDC_RESET_N		49
+#define R9A07G054_SSI0_RST_M2_REG	50
+#define R9A07G054_SSI1_RST_M2_REG	51
+#define R9A07G054_SSI2_RST_M2_REG	52
+#define R9A07G054_SSI3_RST_M2_REG	53
+#define R9A07G054_SRC_RST		54
+#define R9A07G054_USB_U2H0_HRESETN	55
+#define R9A07G054_USB_U2H1_HRESETN	56
+#define R9A07G054_USB_U2P_EXL_SYSRST	57
+#define R9A07G054_USB_PRESETN		58
+#define R9A07G054_ETH0_RST_HW_N		59
+#define R9A07G054_ETH1_RST_HW_N		60
+#define R9A07G054_I2C0_MRST		61
+#define R9A07G054_I2C1_MRST		62
+#define R9A07G054_I2C2_MRST		63
+#define R9A07G054_I2C3_MRST		64
+#define R9A07G054_SCIF0_RST_SYSTEM_N	65
+#define R9A07G054_SCIF1_RST_SYSTEM_N	66
+#define R9A07G054_SCIF2_RST_SYSTEM_N	67
+#define R9A07G054_SCIF3_RST_SYSTEM_N	68
+#define R9A07G054_SCIF4_RST_SYSTEM_N	69
+#define R9A07G054_SCI0_RST		70
+#define R9A07G054_SCI1_RST		71
+#define R9A07G054_IRDA_RST		72
+#define R9A07G054_RSPI0_RST		73
+#define R9A07G054_RSPI1_RST		74
+#define R9A07G054_RSPI2_RST		75
+#define R9A07G054_CANFD_RSTP_N		76
+#define R9A07G054_CANFD_RSTC_N		77
+#define R9A07G054_GPIO_RSTN		78
+#define R9A07G054_GPIO_PORT_RESETN	79
+#define R9A07G054_GPIO_SPARE_RESETN	80
+#define R9A07G054_ADC_PRESETN		81
+#define R9A07G054_ADC_ADRST_N		82
+#define R9A07G054_TSU_PRESETN		83
+#define R9A07G054_STPAI_ARESETN		84
+
+#endif /* __DT_BINDINGS_CLOCK_R9A07G054_CPG_H__ */
-- 
2.17.1

