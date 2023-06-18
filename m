Return-Path: <netdev+bounces-11774-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1871F73465B
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 15:24:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FB8128115D
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 13:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 108ED1FB1;
	Sun, 18 Jun 2023 13:23:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3255184C
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 13:23:54 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F651728;
	Sun, 18 Jun 2023 06:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687094612; x=1718630612;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=rCzFHJ7T9piwXY/XOwXix/8/izDJuLEne8+2d/T2SUE=;
  b=VFQSWdIkcOOosdYv1bbkRnzkWGIO02cHLvGChBhMo9WBEkiEve5efrX5
   VfUW6Q4srhD1dih+5bCpcidaiWoOBrdd1uryG8yeRKx+gtEeUF79zY+S6
   OthFiayBFxsxjnj7DOzS4sGJBjWDULdt/v8zt0gcyIjeuLAstnvKk10lq
   yC+nCjX+xzX6UwAmTemhgnyS6cEJWcC8FMuefUzT9DmDMYxtRDnawtpo3
   keoQcMm2PGWUkqK6bDcZB4AKQXpaIpkXVdJTTzBlR8C0uJzJYppCupg+L
   lY4WbgYs3vCFsERrIKuJ9dVkRtJ/OXqoddFEJYH1eDZnO3VSXzbFomcZB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="356967092"
X-IronPort-AV: E=Sophos;i="6.00,252,1681196400"; 
   d="scan'208";a="356967092"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2023 06:23:31 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="747146851"
X-IronPort-AV: E=Sophos;i="6.00,252,1681196400"; 
   d="scan'208";a="747146851"
Received: from unknown (HELO localhost.localdomain) ([10.226.216.116])
  by orsmga001.jf.intel.com with ESMTP; 18 Jun 2023 06:23:27 -0700
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
Subject: [PATCH 4/4] arm64: dts: agilex5: Add initial support for Intel's Agilex5 SoCFPGA
Date: Sun, 18 Jun 2023 21:22:35 +0800
Message-Id: <20230618132235.728641-5-niravkumar.l.rabara@intel.com>
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

Add the initial device tree files for Intel's Agilex5 SoCFPGA platform.

Signed-off-by: Adrian Ng Ho Yin <adrian.ho.yin.ng@intel.com>
Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
---
 arch/arm64/boot/dts/intel/Makefile            |   3 +
 .../arm64/boot/dts/intel/socfpga_agilex5.dtsi | 641 ++++++++++++++++++
 .../boot/dts/intel/socfpga_agilex5_socdk.dts  | 184 +++++
 .../dts/intel/socfpga_agilex5_socdk_nand.dts  | 131 ++++
 .../dts/intel/socfpga_agilex5_socdk_swvp.dts  | 248 +++++++
 5 files changed, 1207 insertions(+)
 create mode 100644 arch/arm64/boot/dts/intel/socfpga_agilex5.dtsi
 create mode 100644 arch/arm64/boot/dts/intel/socfpga_agilex5_socdk.dts
 create mode 100644 arch/arm64/boot/dts/intel/socfpga_agilex5_socdk_nand.dts
 create mode 100644 arch/arm64/boot/dts/intel/socfpga_agilex5_socdk_swvp.dts

diff --git a/arch/arm64/boot/dts/intel/Makefile b/arch/arm64/boot/dts/intel/Makefile
index c2a723838344..bb74a7e30e58 100644
--- a/arch/arm64/boot/dts/intel/Makefile
+++ b/arch/arm64/boot/dts/intel/Makefile
@@ -2,5 +2,8 @@
 dtb-$(CONFIG_ARCH_INTEL_SOCFPGA) += socfpga_agilex_n6000.dtb \
 				socfpga_agilex_socdk.dtb \
 				socfpga_agilex_socdk_nand.dtb \
+				socfpga_agilex5_socdk.dtb \
+				socfpga_agilex5_socdk_nand.dtb \
+				socfpga_agilex5_socdk_swvp.dtb \
 				socfpga_n5x_socdk.dtb
 dtb-$(CONFIG_ARCH_KEEMBAY) += keembay-evm.dtb
diff --git a/arch/arm64/boot/dts/intel/socfpga_agilex5.dtsi b/arch/arm64/boot/dts/intel/socfpga_agilex5.dtsi
new file mode 100644
index 000000000000..9454d88d6457
--- /dev/null
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex5.dtsi
@@ -0,0 +1,641 @@
+// SPDX-License-Identifier:     GPL-2.0
+/*
+ * Copyright (C) 2023, Intel Corporation
+ */
+
+/dts-v1/;
+#include <dt-bindings/reset/altr,rst-mgr-agilex5.h>
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/clock/agilex5-clock.h>
+
+/ {
+	compatible = "intel,socfpga-agilex";
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		service_reserved: svcbuffer@0 {
+			compatible = "shared-dma-pool";
+			reg = <0x0 0x80000000 0x0 0x2000000>;
+			alignment = <0x1000>;
+			no-map;
+		};
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu0: cpu@0 {
+			compatible = "arm,cortex-a55";
+			device_type = "cpu";
+			enable-method = "psci";
+			reg = <0x0>;
+		};
+
+		cpu1: cpu@1 {
+			compatible = "arm,cortex-a55";
+			device_type = "cpu";
+			enable-method = "psci";
+			reg = <0x100>;
+		};
+
+		cpu2: cpu@2 {
+			compatible = "arm,cortex-a76";
+			device_type = "cpu";
+			enable-method = "psci";
+			reg = <0x200>;
+		};
+
+		cpu3: cpu@3 {
+			compatible = "arm,cortex-a76";
+			device_type = "cpu";
+			enable-method = "psci";
+			reg = <0x300>;
+		};
+	};
+
+	psci {
+		compatible = "arm,psci-0.2";
+		method = "smc";
+	};
+
+	intc: interrupt-controller@1d000000 {
+		compatible = "arm,gic-v3", "arm,cortex-a15-gic";
+		#interrupt-cells = <3>;
+		#address-cells = <2>;
+		#size-cells =<2>;
+		interrupt-controller;
+		#redistributor-regions = <1>;
+		label = "GIC";
+		status = "okay";
+		ranges;
+		redistributor-stride = <0x0 0x20000>;
+		reg = <0x0 0x1d000000 0 0x10000>,
+			<0x0 0x1d060000 0 0x100000>;
+
+		its: msi-controller@1d040000 {
+			compatible = "arm,gic-v3-its";
+			reg = <0x0 0x1d040000 0x0 0x20000>;
+			label = "ITS";
+			msi-controller;
+			status = "okay";
+		};
+	};
+
+	/* Clock tree 5 main sources*/
+	clocks {
+		cb_intosc_hs_div2_clk: cb-intosc-hs-div2-clk {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+		};
+
+		cb_intosc_ls_clk: cb-intosc-ls-clk {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+		};
+
+		f2s_free_clk: f2s-free-clk {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+		};
+
+		osc1: osc1 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+		};
+
+		qspi_clk: qspi-clk {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <200000000>;
+		};
+	};
+
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupt-parent = <&intc>;
+		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
+	};
+
+	usbphy0: usbphy {
+		#phy-cells = <0>;
+		compatible = "usb-nop-xceiv";
+	};
+
+	soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "simple-bus";
+		device_type = "soc";
+		interrupt-parent = <&intc>;
+		ranges = <0 0 0 0xffffffff>;
+
+		clkmgr: clock-controller@10d10000 {
+			compatible = "intel,agilex5-clkmgr";
+			reg = <0x10d10000 0x1000>;
+			#clock-cells = <1>;
+		};
+
+		stmmac_axi_setup: stmmac-axi-config {
+			snps,wr_osr_lmt = <31>;
+			snps,rd_osr_lmt = <31>;
+			snps,blen = <0 0 0 32 16 8 4>;
+		};
+
+		mtl_rx_setup: rx-queues-config {
+			snps,rx-queues-to-use = <8>;
+			snps,rx-sched-sp;
+			queue0 {
+				snps,dcb-algorithm;
+				snps,map-to-dma-channel = <0x0>;
+			};
+			queue1 {
+				snps,dcb-algorithm;
+				snps,map-to-dma-channel = <0x1>;
+			};
+			queue2 {
+				snps,dcb-algorithm;
+				snps,map-to-dma-channel = <0x2>;
+			};
+			queue3 {
+				snps,dcb-algorithm;
+				snps,map-to-dma-channel = <0x3>;
+			};
+			queue4 {
+				snps,dcb-algorithm;
+				snps,map-to-dma-channel = <0x4>;
+			};
+			queue5 {
+				snps,dcb-algorithm;
+				snps,map-to-dma-channel = <0x5>;
+			};
+			queue6 {
+				snps,dcb-algorithm;
+				snps,map-to-dma-channel = <0x6>;
+			};
+			queue7 {
+				snps,dcb-algorithm;
+				snps,map-to-dma-channel = <0x7>;
+			};
+		};
+
+		mtl_tx_setup: tx-queues-config {
+			snps,tx-queues-to-use = <8>;
+			snps,tx-sched-wrr;
+			queue0 {
+				snps,weight = <0x09>;
+				snps,dcb-algorithm;
+			};
+			queue1 {
+				snps,weight = <0x0A>;
+				snps,dcb-algorithm;
+			};
+			queue2 {
+				snps,weight = <0x0B>;
+				snps,dcb-algorithm;
+			};
+			queue3 {
+				snps,weight = <0x0C>;
+				snps,dcb-algorithm;
+			};
+			queue4 {
+				snps,weight = <0x0D>;
+				snps,dcb-algorithm;
+			};
+			queue5 {
+				snps,weight = <0x0E>;
+				snps,dcb-algorithm;
+			};
+			queue6 {
+				snps,weight = <0x0F>;
+				snps,dcb-algorithm;
+			};
+			queue7 {
+				snps,weight = <0x10>;
+				snps,dcb-algorithm;
+			};
+		};
+
+		gmac0: ethernet@10810000 {
+			compatible = "altr,socfpga-stmmac-a10-s10",
+						"snps,dwxgmac-2.10",
+						"snps,dwxgmac";
+			reg = <0x10810000 0x3500>;
+			interrupts = <GIC_SPI 190 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 191 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 192 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 193 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 194 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 195 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 197 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 198 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 199 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 201 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 202 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 203 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 204 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>,
+						<GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "macirq",
+							"macirq_tx0",
+							"macirq_tx1",
+							"macirq_tx2",
+							"macirq_tx3",
+							"macirq_tx4",
+							"macirq_tx5",
+							"macirq_tx6",
+							"macirq_tx7",
+							"macirq_rx0",
+							"macirq_rx1",
+							"macirq_rx2",
+							"macirq_rx3",
+							"macirq_rx4",
+							"macirq_rx5",
+							"macirq_rx6",
+							"macirq_rx7";
+			mac-address = [00 00 00 00 00 00];
+			resets = <&rst EMAC0_RESET>, <&rst EMAC0_OCP_RESET>;
+			reset-names = "stmmaceth", "stmmaceth-ocp";
+			tx-fifo-depth = <32768>;
+			rx-fifo-depth = <16384>;
+			snps,multicast-filter-bins = <64>;
+			snps,perfect-filter-entries = <64>;
+			snps,axi-config = <&stmmac_axi_setup>;
+			snps,mtl-rx-config = <&mtl_rx_setup>;
+			snps,mtl-tx-config = <&mtl_tx_setup>;
+			snps,pbl = <32>;
+			snps,pblx8;
+			snps,multi-irq-en;
+			snps,tso;
+			altr,sysmgr-syscon = <&sysmgr 0x44 0>;
+			altr,smtg-hub;
+			snps,rx-vlan-offload;
+			clocks = <&clkmgr AGILEX5_EMAC0_CLK>, <&clkmgr AGILEX5_EMAC_PTP_CLK>;
+			clock-names = "stmmaceth", "ptp_ref";
+			status = "disabled";
+		};
+
+		i2c0: i2c@10c02800 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "snps,designware-i2c";
+			reg = <0x10c02800 0x100>;
+			interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst I2C0_RESET>;
+			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
+			status = "disabled";
+		};
+
+		i2c1: i2c@10c02900 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "snps,designware-i2c";
+			reg = <0x10c02900 0x100>;
+			interrupts = <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst I2C1_RESET>;
+			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
+			status = "disabled";
+		};
+
+		i2c2: i2c@10c02a00 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "snps,designware-i2c";
+			reg = <0x10c02a00 0x100>;
+			interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst I2C2_RESET>;
+			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
+			status = "disabled";
+		};
+
+		i2c3: i2c@10c02b00 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "snps,designware-i2c";
+			reg = <0x10c02b00 0x100>;
+			interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst I2C3_RESET>;
+			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
+			status = "disabled";
+		};
+
+		i2c4: i2c@10c02c00 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "snps,designware-i2c";
+			reg = <0x10c02c00 0x100>;
+			interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst I2C4_RESET>;
+			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
+			status = "disabled";
+		};
+
+		i3c0: i3c@10da0000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "snps,dw-i3c-master-1.00a";
+			reg = <0x10da0000 0x1000>;
+			interrupts = <GIC_SPI 164 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst I3C0_RESET>;
+			clocks = <&clkmgr AGILEX5_L4_MP_CLK>;
+			status = "disabled";
+		};
+
+		i3c1: i3c@10da1000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "snps,dw-i3c-master-1.00a";
+			reg = <0x10da1000 0x1000>;
+			interrupts = <GIC_SPI 165 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst I3C1_RESET>;
+			clocks = <&clkmgr AGILEX5_L4_MP_CLK>;
+			status = "disabled";
+		};
+
+		gpio1: gpio@10C03300 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "snps,dw-apb-gpio";
+			reg = <0x10C03300 0x100>;
+			resets = <&rst GPIO1_RESET>;
+			status = "disabled";
+
+			portb: gpio-controller@0 {
+				compatible = "snps,dw-apb-gpio-port";
+				gpio-controller;
+				#gpio-cells = <2>;
+				snps,nr-gpios = <24>;
+				reg = <0>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
+			};
+		};
+
+		mmc: mmc0@10808000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "cdns,sd4hc";
+			reg = <0x10808000 0x1000>;
+			interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
+			fifo-depth = <0x800>;
+			resets = <&rst SDMMC_RESET>;
+			reset-names = "reset";
+			clocks = <&clkmgr AGILEX5_L4_MP_CLK>, <&clkmgr AGILEX5_SDMCLK>;
+			clock-names = "biu", "ciu";
+			/*iommus = <&smmu 5>;*/
+			status = "disabled";
+		};
+
+		nand: nand-controller@10b80000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "cdns,hp-nfc";
+			reg = <0x10b80000 0x10000>,
+					<0x10840000 0x1000>;
+			reg-names = "reg", "sdma";
+			interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clkmgr AGILEX5_NAND_NF_CLK>;
+			clock-names = "nf_clk";
+			cdns,board-delay-ps = <4830>;
+			status = "disabled";
+		};
+
+		ocram: sram@00000000 {
+			compatible = "mmio-sram";
+			reg = <0x00000000 0x40000>;
+		};
+
+		dmac0: dma-controller@10DB0000 {
+			compatible = "snps,axi-dma-1.01a";
+			reg = <0x10DB0000 0x500>;
+			clocks = <&clkmgr AGILEX5_L4_MAIN_CLK>,
+				 <&clkmgr AGILEX5_L4_MP_CLK>;
+			clock-names = "core-clk", "cfgr-clk";
+			interrupt-parent = <&intc>;
+			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			dma-channels = <4>;
+			snps,dma-masters = <1>;
+			snps,data-width = <2>;
+			snps,block-size = <32767 32767 32767 32767>;
+			snps,priority = <0 1 2 3>;
+			snps,axi-max-burst-len = <8>;
+			status = "okay";
+		};
+
+		dmac1: dma-controller@10DC0000 {
+			compatible = "snps,axi-dma-1.01a";
+			reg = <0x10DC0000 0x500>;
+			clocks = <&clkmgr AGILEX5_L4_MAIN_CLK>,
+				 <&clkmgr AGILEX5_L4_MP_CLK>;
+			clock-names = "core-clk", "cfgr-clk";
+			interrupt-parent = <&intc>;
+			interrupts = <GIC_SPI 171 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			dma-channels = <4>;
+			snps,dma-masters = <1>;
+			snps,data-width = <2>;
+			snps,block-size = <32767 32767 32767 32767>;
+			snps,priority = <0 1 2 3>;
+			snps,axi-max-burst-len = <8>;
+			status = "okay";
+		};
+
+		rst: rstmgr@10d11000 {
+			#reset-cells = <1>;
+			compatible = "altr,stratix10-rst-mgr";
+			reg = <0x10d11000 0x100>;
+		};
+
+		spi0: spi@10da4000 {
+			compatible = "snps,dw-apb-ssi";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x10da4000 0x1000>;
+			interrupts = <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst SPIM0_RESET>;
+			reset-names = "spi";
+			reg-io-width = <4>;
+			num-cs = <4>;
+			clocks = <&clkmgr AGILEX5_L4_MAIN_CLK>;
+			dmas = <&dmac0 2>, <&dmac0 3>;
+			dma-names ="tx", "rx";
+
+			status = "disabled";
+
+			flash: m25p128@0 {
+				status = "okay";
+				compatible = "st,m25p80";
+				spi-max-frequency = <25000000>;
+				m25p,fast-read;
+				reg = <0>;
+
+				#address-cells = <1>;
+				#size-cells = <1>;
+
+				partition@0 {
+				label = "spi_flash_part0";
+				reg = <0x0 0x100000>;
+				};
+			};
+
+		};
+
+		spi1: spi@10da5000 {
+			compatible = "snps,dw-apb-ssi";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x10da5000 0x1000>;
+			interrupts = <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst SPIM1_RESET>;
+			reset-names = "spi";
+			reg-io-width = <4>;
+			num-cs = <4>;
+			clocks = <&clkmgr AGILEX5_L4_MAIN_CLK>;
+			status = "disabled";
+		};
+
+		sysmgr: sysmgr@10d12000 {
+			compatible = "altr,sys-mgr-s10","altr,sys-mgr";
+			reg = <0x10d12000 0x500>;
+		};
+
+		timer0: timer0@10c03000 {
+			compatible = "snps,dw-apb-timer";
+			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
+			reg = <0x10c03000 0x100>;
+			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
+			clock-names = "timer";
+		};
+
+		timer1: timer1@10c03100 {
+			compatible = "snps,dw-apb-timer";
+			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+			reg = <0x10c03100 0x100>;
+			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
+			clock-names = "timer";
+		};
+
+		timer2: timer2@10d00000 {
+			compatible = "snps,dw-apb-timer";
+			interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
+			reg = <0x10d00000 0x100>;
+			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
+			clock-names = "timer";
+		};
+
+		timer3: timer3@10d00100 {
+			compatible = "snps,dw-apb-timer";
+			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
+			reg = <0x10d00100 0x100>;
+			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
+			clock-names = "timer";
+		};
+
+		uart0: serial@10c02000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x10c02000 0x100>;
+			interrupts = <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			resets = <&rst UART0_RESET>;
+			status = "disabled";
+			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
+		};
+
+		uart1: serial@10c02100 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x10c02100 0x100>;
+			interrupts = <GIC_SPI 109 IRQ_TYPE_LEVEL_HIGH>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			resets = <&rst UART1_RESET>;
+			status = "disabled";
+			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
+		};
+
+		usb0: usb@10b00000 {
+			compatible = "snps,dwc2";
+			reg = <0x10b00000 0x40000>;
+			interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>;
+			phys = <&usbphy0>;
+			phy-names = "usb2-phy";
+			resets = <&rst USB0_RESET>, <&rst USB0_OCP_RESET>;
+			reset-names = "dwc2", "dwc2-ecc";
+			clocks = <&clkmgr AGILEX5_USB2OTG_HCLK>;
+			clock-names = "otg";
+			status = "disabled";
+		};
+
+		watchdog0: watchdog@10d00200 {
+			compatible = "snps,dw-wdt";
+			reg = <0x10d00200 0x100>;
+			interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst WATCHDOG0_RESET>;
+			clocks = <&clkmgr AGILEX5_L4_SYS_FREE_CLK>;
+			status = "disabled";
+		};
+
+		watchdog1: watchdog@10d00300 {
+			compatible = "snps,dw-wdt";
+			reg = <0x10d00300 0x100>;
+			interrupts = <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst WATCHDOG1_RESET>;
+			clocks = <&clkmgr AGILEX5_L4_SYS_FREE_CLK>;
+			status = "disabled";
+		};
+
+		watchdog2: watchdog@10d00400 {
+			compatible = "snps,dw-wdt";
+			reg = <0x10d00400 0x100>;
+			interrupts = <GIC_SPI 125 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst WATCHDOG2_RESET>;
+			clocks = <&clkmgr AGILEX5_L4_SYS_FREE_CLK>;
+			status = "disabled";
+		};
+
+		watchdog3: watchdog@10d00500 {
+			compatible = "snps,dw-wdt";
+			reg = <0x10d00500 0x100>;
+			interrupts = <GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst WATCHDOG3_RESET>;
+			clocks = <&clkmgr AGILEX5_L4_SYS_FREE_CLK>;
+			status = "disabled";
+		};
+		watchdog4: watchdog@10d00600 {
+			compatible = "snps,dw-wdt";
+			reg = <0x10d00600 0x100>;
+			interrupts = <GIC_SPI 175 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&rst WATCHDOG4_RESET>;
+			clocks = <&clkmgr AGILEX5_L4_SYS_FREE_CLK>;
+			status = "disabled";
+		};
+
+		qspi: spi@108d2000 {
+			compatible = "intel,socfpga-qspi", "cdns,qspi-nor";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x108d2000 0x100>,
+			      <0x10900000 0x100000>;
+			interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
+			cdns,fifo-depth = <128>;
+			cdns,fifo-width = <4>;
+			cdns,trigger-address = <0x00000000>;
+			clocks = <&qspi_clk>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/arm64/boot/dts/intel/socfpga_agilex5_socdk.dts b/arch/arm64/boot/dts/intel/socfpga_agilex5_socdk.dts
new file mode 100644
index 000000000000..c29a6f8af1e6
--- /dev/null
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex5_socdk.dts
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier:     GPL-2.0
+/*
+ * Copyright (C) 2023, Intel Corporation
+ */
+#include "socfpga_agilex5.dtsi"
+
+/ {
+	model = "SoCFPGA Agilex5 SoCDK";
+	compatible = "intel,socfpga-agilex5-socdk", "intel,socfpga-agilex";
+
+	aliases {
+		serial0 = &uart0;
+		ethernet0 = &gmac0;
+	};
+
+	chosen {
+		stdout-path = "serial0:115200n8";
+		bootargs = "console=uart8250,mmio32,0x10c02000,115200n8 \
+			root=/dev/ram0 rw initrd=0x10000000 init=/sbin/init \
+			ramdisk_size=10000000 earlycon=uart8250,mmio32,0x10c02000,115200n8 \
+			panic=-1 nosmp rootfstype=ext3";
+	};
+
+	leds {
+		compatible = "gpio-leds";
+		hps0 {
+			label = "hps_led0";
+			gpios = <&portb 20 GPIO_ACTIVE_HIGH>;
+		};
+
+		hps1 {
+			label = "hps_led1";
+			gpios = <&portb 19 GPIO_ACTIVE_HIGH>;
+		};
+
+		hps2 {
+			label = "hps_led2";
+			gpios = <&portb 21 GPIO_ACTIVE_HIGH>;
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x0 0x80000000 0x0 0x80000000>;
+		#address-cells = <0x2>;
+		#size-cells = <0x2>;
+		u-boot,dm-pre-reloc;
+	};
+};
+
+&gpio1 {
+	status = "okay";
+};
+
+&gmac0 {
+	status = "okay";
+	phy-mode = "rgmii";
+	phy-handle = <&phy0>;
+
+	max-frame-size = <9000>;
+
+	mdio0 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "snps,dwmac-mdio";
+		phy0: ethernet-phy@0 {
+			reg = <0>;
+		};
+	};
+};
+
+&mmc {
+	status = "okay";
+	bus-width = <4>;
+	sd-uhs-sdr50;
+	sdhci-caps = <0x00000000 0x0000c800>;
+	sdhci-caps-mask = <0x00002000 0x0000ff00>;
+	no-sdio;
+	cdns,phy-use-ext-lpbk-dqs = <1>;
+	cdns,phy-use-lpbk-dqs = <1>;
+	cdns,phy-use-phony-dqs = <1>;
+	cdns,phy-use-phony-dqs-cmd = <1>;
+	cdns,phy-io-mask-always-on = <0>;
+	cdns,phy-io-mask-end = <5>;
+	cdns,phy-io-mask-start = <0>;
+	cdns,phy-data-select-oe-end = <1>;
+	cdns,phy-sync-method = <1>;
+	cdns,phy-sw-half-cycle-shift = <0>;
+	cdns,phy-rd-del-sel = <52>;
+	cdns,phy-underrun-suppress = <1>;
+	cdns,phy-gate-cfg-always-on = <1>;
+	cdns,phy-param-dll-bypass-mode = <1>;
+	cdns,phy-param-phase-detect-sel = <2>;
+	cdns,phy-param-dll-start-point = <254>;
+	cdns,phy-read-dqs-cmd-delay = <0>;
+	cdns,phy-clk-wrdqs-delay = <0>;
+	cdns,phy-clk-wr-delay = <0>;
+	cdns,phy-read-dqs-delay = <0>;
+	cdns,phy-phony-dqs-timing = <0>;
+	cdns,hrs09-rddata-en = <1>;
+	cdns,hrs09-rdcmd-en = <1>;
+	cdns,hrs09-extended-wr-mode = <1>;
+	cdns,hrs09-extended-rd-mode = <1>;
+	cdns,hrs10-hcsdclkadj = <3>;
+	cdns,hrs16-wrdata1-sdclk-dly = <0>;
+	cdns,hrs16-wrdata0-sdclk-dly = <0>;
+	cdns,hrs16-wrcmd1-sdclk-dly = <0>;
+	cdns,hrs16-wrcmd0-sdclk-dly = <0>;
+	cdns,hrs16-wrdata1-dly = <0>;
+	cdns,hrs16-wrdata0-dly = <0>;
+	cdns,hrs16-wrcmd1-dly = <0>;
+	cdns,hrs16-wrcmd0-dly = <0>;
+	cdns,hrs07-rw-compensate = <10>;
+	cdns,hrs07-idelay-val = <0>;
+};
+
+&osc1 {
+	clock-frequency = <25000000>;
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&usb0 {
+	status = "okay";
+	disable-over-current;
+};
+
+&watchdog0 {
+	status = "okay";
+};
+
+&watchdog1 {
+	status = "okay";
+};
+
+&watchdog2 {
+	status = "okay";
+};
+
+&watchdog3 {
+	status = "okay";
+};
+
+&watchdog4 {
+	status = "okay";
+};
+
+&qspi {
+	status = "okay";
+	flash@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
+		reg = <0>;
+		spi-max-frequency = <100000000>;
+
+		m25p,fast-read;
+		cdns,page-size = <256>;
+		cdns,block-size = <16>;
+		cdns,read-delay = <2>;
+		cdns,tshsl-ns = <50>;
+		cdns,tsd2d-ns = <50>;
+		cdns,tchsh-ns = <4>;
+		cdns,tslch-ns = <4>;
+
+		partitions {
+			compatible = "fixed-partitions";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			qspi_boot: partition@0 {
+				label = "Boot and fpga data";
+				reg = <0x0 0x03FE0000>;
+			};
+
+			qspi_rootfs: partition@3FE0000 {
+				label = "Root Filesystem - JFFS2";
+				reg = <0x03FE0000 0x0C020000>;
+			};
+		};
+	};
+};
diff --git a/arch/arm64/boot/dts/intel/socfpga_agilex5_socdk_nand.dts b/arch/arm64/boot/dts/intel/socfpga_agilex5_socdk_nand.dts
new file mode 100644
index 000000000000..0403f3859b4e
--- /dev/null
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex5_socdk_nand.dts
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier:     GPL-2.0
+/*
+ * Copyright (C) 2023, Intel Corporation
+ */
+#include "socfpga_agilex5.dtsi"
+
+/ {
+	model = "SoCFPGA Agilex5 SoCDK";
+	compatible = "intel,socfpga-agilex5-socdk", "intel,socfpga-agilex";
+
+	aliases {
+		serial0 = &uart0;
+		ethernet0 = &gmac0;
+	};
+
+	chosen {
+		stdout-path = "serial0:115200n8";
+	};
+
+	leds {
+		compatible = "gpio-leds";
+		hps0 {
+			label = "hps_led0";
+			gpios = <&portb 20 GPIO_ACTIVE_HIGH>;
+		};
+
+		hps1 {
+			label = "hps_led1";
+			gpios = <&portb 19 GPIO_ACTIVE_HIGH>;
+		};
+
+		hps2 {
+			label = "hps_led2";
+			gpios = <&portb 21 GPIO_ACTIVE_HIGH>;
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x0 0x80000000 0x0 0x80000000>;
+		#address-cells = <0x2>;
+		#size-cells = <0x2>;
+		u-boot,dm-pre-reloc;
+	};
+};
+
+&gpio1 {
+	status = "okay";
+};
+
+&gmac0 {
+	status = "okay";
+	phy-mode = "rgmii";
+	phy-handle = <&phy0>;
+
+	max-frame-size = <9000>;
+
+	mdio0 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "snps,dwmac-mdio";
+		phy0: ethernet-phy@0 {
+			reg = <0>;
+		};
+	};
+};
+
+&osc1 {
+	clock-frequency = <25000000>;
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&watchdog0 {
+	status = "okay";
+};
+
+&watchdog1 {
+	status = "okay";
+};
+
+&watchdog2 {
+	status = "okay";
+};
+
+&watchdog3 {
+	status = "okay";
+};
+
+&watchdog4 {
+	status = "okay";
+};
+
+&nand {
+	status = "okay";
+
+	flash@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0>;
+		nand-bus-width = <16>;
+
+		partition@0 {
+			label = "u-boot";
+			reg = <0 0x200000>;
+		};
+		partition@200000 {
+			label = "env";
+			reg = <0x200000 0x40000>;
+		};
+		partition@240000 {
+			label = "dtb";
+			reg = <0x240000 0x40000>;
+		};
+		partition@280000 {
+			label = "kernel";
+			reg = <0x280000 0x2000000>;
+		};
+		partition@2280000 {
+			label = "misc";
+			reg = <0x2280000 0x2000000>;
+		};
+		partition@4280000 {
+			label = "rootfs";
+			reg = <0x4280000 0x3d80000>;
+		};
+	};
+};
+
diff --git a/arch/arm64/boot/dts/intel/socfpga_agilex5_socdk_swvp.dts b/arch/arm64/boot/dts/intel/socfpga_agilex5_socdk_swvp.dts
new file mode 100644
index 000000000000..26a9347a23cc
--- /dev/null
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex5_socdk_swvp.dts
@@ -0,0 +1,248 @@
+// SPDX-License-Identifier:     GPL-2.0
+/*
+ * Copyright (C) 2023, Intel Corporation
+ */
+#include "socfpga_agilex5.dtsi"
+
+/ {
+	model = "SoCFPGA Agilex5 SoCDK";
+	compatible = "intel,socfpga-agilex5-socdk", "intel,socfpga-agilex";
+
+	aliases {
+		serial0 = &uart0;
+		ethernet0 = &gmac0;
+	};
+
+	chosen {
+		stdout-path = "serial0:115200n8";
+		bootargs = "console=uart8250,mmio32,0x10c02000,115200n8 \
+			root=/dev/ram0 rw initrd=0x10000000 init=/sbin/init \
+			ramdisk_size=10000000 earlycon=uart8250,mmio32,0x10c02000,115200n8 \
+			panic=-1 nosmp rootfstype=ext3";
+	};
+
+	leds {
+		compatible = "gpio-leds";
+		hps0 {
+			label = "hps_led0";
+			gpios = <&portb 20 GPIO_ACTIVE_HIGH>;
+		};
+
+		hps1 {
+			label = "hps_led1";
+			gpios = <&portb 19 GPIO_ACTIVE_HIGH>;
+		};
+
+		hps2 {
+			label = "hps_led2";
+			gpios = <&portb 21 GPIO_ACTIVE_HIGH>;
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x0 0x80000000 0x0 0x80000000>;
+		#address-cells = <0x2>;
+		#size-cells = <0x2>;
+		u-boot,dm-pre-reloc;
+	};
+};
+
+&gpio1 {
+	status = "okay";
+};
+
+&gmac0 {
+	status = "okay";
+	phy-mode = "rgmii";
+	phy-handle = <&phy0>;
+
+	max-frame-size = <9000>;
+
+	mdio0 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "snps,dwmac-mdio";
+		phy0: ethernet-phy@0 {
+			reg = <0>;
+		};
+	};
+};
+
+&mmc {
+	status = "okay";
+	bus-width = <4>;
+	sd-uhs-sdr50;
+	sdhci-caps = <0x00000000 0x0000c800>;
+	sdhci-caps-mask = <0x00002000 0x0000ff00>;
+	no-sdio;
+	cdns,phy-use-ext-lpbk-dqs = <1>;
+	cdns,phy-use-lpbk-dqs = <1>;
+	cdns,phy-use-phony-dqs = <1>;
+	cdns,phy-use-phony-dqs-cmd = <1>;
+	cdns,phy-io-mask-always-on = <0>;
+	cdns,phy-io-mask-end = <5>;
+	cdns,phy-io-mask-start = <0>;
+	cdns,phy-data-select-oe-end = <1>;
+	cdns,phy-sync-method = <1>;
+	cdns,phy-sw-half-cycle-shift = <0>;
+	cdns,phy-rd-del-sel = <52>;
+	cdns,phy-underrun-suppress = <1>;
+	cdns,phy-gate-cfg-always-on = <1>;
+	cdns,phy-param-dll-bypass-mode = <1>;
+	cdns,phy-param-phase-detect-sel = <2>;
+	cdns,phy-param-dll-start-point = <254>;
+	cdns,phy-read-dqs-cmd-delay = <0>;
+	cdns,phy-clk-wrdqs-delay = <0>;
+	cdns,phy-clk-wr-delay = <0>;
+	cdns,phy-read-dqs-delay = <0>;
+	cdns,phy-phony-dqs-timing = <0>;
+	cdns,hrs09-rddata-en = <1>;
+	cdns,hrs09-rdcmd-en = <1>;
+	cdns,hrs09-extended-wr-mode = <1>;
+	cdns,hrs09-extended-rd-mode = <1>;
+	cdns,hrs10-hcsdclkadj = <3>;
+	cdns,hrs16-wrdata1-sdclk-dly = <0>;
+	cdns,hrs16-wrdata0-sdclk-dly = <0>;
+	cdns,hrs16-wrcmd1-sdclk-dly = <0>;
+	cdns,hrs16-wrcmd0-sdclk-dly = <0>;
+	cdns,hrs16-wrdata1-dly = <0>;
+	cdns,hrs16-wrdata0-dly = <0>;
+	cdns,hrs16-wrcmd1-dly = <0>;
+	cdns,hrs16-wrcmd0-dly = <0>;
+	cdns,hrs07-rw-compensate = <10>;
+	cdns,hrs07-idelay-val = <0>;
+};
+
+&i2c0 {
+	status = "okay";
+};
+
+&i2c1 {
+	status = "okay";
+};
+
+&i2c2 {
+	status = "okay";
+};
+
+&i2c3 {
+	status = "okay";
+};
+
+&i2c4 {
+	status = "okay";
+};
+
+&i3c0 {
+	status = "okay";
+};
+
+&i3c1 {
+	status = "okay";
+};
+
+&osc1 {
+	clock-frequency = <25000000>;
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&usb0 {
+	status = "okay";
+	disable-over-current;
+};
+
+&watchdog0 {
+	status = "okay";
+};
+
+&watchdog1 {
+	status = "okay";
+};
+
+&watchdog2 {
+	status = "okay";
+};
+
+&watchdog3 {
+	status = "okay";
+};
+
+&watchdog4 {
+	status = "okay";
+};
+
+&qspi {
+	status = "okay";
+	flash@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
+		reg = <0>;
+		spi-max-frequency = <100000000>;
+
+		m25p,fast-read;
+		cdns,page-size = <256>;
+		cdns,block-size = <16>;
+		cdns,read-delay = <2>;
+		cdns,tshsl-ns = <50>;
+		cdns,tsd2d-ns = <50>;
+		cdns,tchsh-ns = <4>;
+		cdns,tslch-ns = <4>;
+
+		partitions {
+			compatible = "fixed-partitions";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			qspi_boot: partition@0 {
+				label = "Boot and fpga data";
+				reg = <0x0 0x03FE0000>;
+			};
+
+			qspi_rootfs: partition@3FE0000 {
+				label = "Root Filesystem - JFFS2";
+				reg = <0x03FE0000 0x0C020000>;
+			};
+		};
+	};
+};
+
+&nand {
+	status = "okay";
+
+	flash@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0>;
+		nand-bus-width = <16>;
+
+		partition@0 {
+			label = "u-boot";
+			reg = <0 0x200000>;
+		};
+		partition@200000 {
+			label = "env";
+			reg = <0x200000 0x40000>;
+		};
+		partition@240000 {
+			label = "dtb";
+			reg = <0x240000 0x40000>;
+		};
+		partition@280000 {
+			label = "kernel";
+			reg = <0x280000 0x2000000>;
+		};
+		partition@2280000 {
+			label = "misc";
+			reg = <0x2280000 0x2000000>;
+		};
+		partition@4280000 {
+			label = "rootfs";
+			reg = <0x4280000 0x3d80000>;
+		};
+	};
+};
-- 
2.25.1


