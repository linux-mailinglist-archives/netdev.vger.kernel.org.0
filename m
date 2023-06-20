Return-Path: <netdev+bounces-12258-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B887736E4C
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:08:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BB702812A3
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF311643C;
	Tue, 20 Jun 2023 14:08:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0C416421
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 14:08:25 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CACAE58;
	Tue, 20 Jun 2023 07:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687270103; x=1718806103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qrjyt9bQapd+uGsyWTH+B1LZO9nrp8juxXIJ+HmlGKA=;
  b=WGoQSY0uMUYc0yYOSWUL4CHTUTjmY2N5V/gByjYc1HBCXLBiOWSeji6C
   koGiAYI9XvI2De6vpnUF15a5DNCQKtVP6Ied0FdBjKQeqElg+TWwMsmDk
   vBlwmHkomjESf2Hznx3/agjrHl/LNXdV/a1/AyeVNlWoLptjd5gPPSfWv
   K+5r34sK8hpcvNb65Bf2MBcGqYYJ75M4sV/wehOh8sVq4edZkgc72cYfK
   kpj+LDIFg02nzbGvCd40kU0BOHBYqtIUDMMM+qsymys1ZaupnkeT8rl4M
   DhcNkKAoN2JeQkA/8YLh1EhvjeGhgvUQUY4PbDJoErW//aBQk8eC7ceKL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="363289553"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="363289553"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 07:08:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="858600280"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="858600280"
Received: from unknown (HELO localhost.localdomain) ([10.226.216.116])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jun 2023 07:08:18 -0700
From: niravkumar.l.rabara@intel.com
To: krzysztof.kozlowski@linaro.org
Cc: adrian.ho.yin.ng@intel.com,
	andrew@lunn.ch,
	conor+dt@kernel.org,
	devicetree@vger.kernel.org,
	dinguyen@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	linux-clk@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mturquette@baylibre.com,
	netdev@vger.kernel.org,
	niravkumar.l.rabara@intel.com,
	p.zabel@pengutronix.de,
	richardcochran@gmail.com,
	robh+dt@kernel.org,
	sboyd@kernel.org,
	wen.ping.teh@intel.com
Subject: Re: [PATCH 4/4] arm64: dts: agilex5: Add initial support for Intel's Agilex5 SoCFPGA
Date: Tue, 20 Jun 2023 22:07:41 +0800
Message-Id: <20230620140741.2468658-1-niravkumar.l.rabara@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <9dd622a1-b8c5-316e-6100-876b02e22fc9@linaro.org>
References: <9dd622a1-b8c5-316e-6100-876b02e22fc9@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>On 18/06/2023 15:22, niravkumar.l.rabara@intel.com wrote:
>> From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
>> 
>> Add the initial device tree files for Intel's Agilex5 SoCFPGA platform.
>> 
>> Signed-off-by: Adrian Ng Ho Yin <adrian.ho.yin.ng@intel.com>
>> Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
>> ---
>>  arch/arm64/boot/dts/intel/Makefile            |   3 +
>>  .../arm64/boot/dts/intel/socfpga_agilex5.dtsi | 641 
>> ++++++++++++++++++  .../boot/dts/intel/socfpga_agilex5_socdk.dts  | 
>> 184 +++++  .../dts/intel/socfpga_agilex5_socdk_nand.dts  | 131 ++++  
>> .../dts/intel/socfpga_agilex5_socdk_swvp.dts  | 248 +++++++
>>  5 files changed, 1207 insertions(+)
>>  create mode 100644 arch/arm64/boot/dts/intel/socfpga_agilex5.dtsi
>>  create mode 100644 
>> arch/arm64/boot/dts/intel/socfpga_agilex5_socdk.dts
>>  create mode 100644 
>> arch/arm64/boot/dts/intel/socfpga_agilex5_socdk_nand.dts
>>  create mode 100644 
>> arch/arm64/boot/dts/intel/socfpga_agilex5_socdk_swvp.dts
>> 
>> diff --git a/arch/arm64/boot/dts/intel/Makefile 
>> b/arch/arm64/boot/dts/intel/Makefile
>> index c2a723838344..bb74a7e30e58 100644
>> --- a/arch/arm64/boot/dts/intel/Makefile
>> +++ b/arch/arm64/boot/dts/intel/Makefile
>> @@ -2,5 +2,8 @@
>>  dtb-$(CONFIG_ARCH_INTEL_SOCFPGA) += socfpga_agilex_n6000.dtb \
>>  				socfpga_agilex_socdk.dtb \
>>  				socfpga_agilex_socdk_nand.dtb \
>> +				socfpga_agilex5_socdk.dtb \
>> +				socfpga_agilex5_socdk_nand.dtb \
>> +				socfpga_agilex5_socdk_swvp.dtb \
>>  				socfpga_n5x_socdk.dtb
>>  dtb-$(CONFIG_ARCH_KEEMBAY) += keembay-evm.dtb diff --git 
>> a/arch/arm64/boot/dts/intel/socfpga_agilex5.dtsi 
>> b/arch/arm64/boot/dts/intel/socfpga_agilex5.dtsi
>> new file mode 100644
>> index 000000000000..9454d88d6457
>> --- /dev/null
>> +++ b/arch/arm64/boot/dts/intel/socfpga_agilex5.dtsi
>> @@ -0,0 +1,641 @@
>> +// SPDX-License-Identifier:     GPL-2.0
>
>Drop indent before license.
>
>> +/*
>> + * Copyright (C) 2023, Intel Corporation  */
>> +
>> +/dts-v1/;
>> +#include <dt-bindings/reset/altr,rst-mgr-agilex5.h>
>> +#include <dt-bindings/gpio/gpio.h>
>> +#include <dt-bindings/interrupt-controller/arm-gic.h>
>> +#include <dt-bindings/interrupt-controller/irq.h>
>> +#include <dt-bindings/clock/agilex5-clock.h>
>> +
>> +/ {
>> +	compatible = "intel,socfpga-agilex";
>> +	#address-cells = <2>;
>> +	#size-cells = <2>;
>> +
>> +	reserved-memory {
>> +		#address-cells = <2>;
>> +		#size-cells = <2>;
>> +		ranges;
>> +
>> +		service_reserved: svcbuffer@0 {
>> +			compatible = "shared-dma-pool";
>> +			reg = <0x0 0x80000000 0x0 0x2000000>;
>> +			alignment = <0x1000>;
>> +			no-map;
>> +		};
>> +	};
>> +
>> +	cpus {
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		cpu0: cpu@0 {
>> +			compatible = "arm,cortex-a55";
>> +			device_type = "cpu";
>> +			enable-method = "psci";
>> +			reg = <0x0>;
>> +		};
>> +
>> +		cpu1: cpu@1 {
>> +			compatible = "arm,cortex-a55";
>> +			device_type = "cpu";
>> +			enable-method = "psci";
>> +			reg = <0x100>;
>> +		};
>> +
>> +		cpu2: cpu@2 {
>> +			compatible = "arm,cortex-a76";
>> +			device_type = "cpu";
>> +			enable-method = "psci";
>> +			reg = <0x200>;
>> +		};
>> +
>> +		cpu3: cpu@3 {
>> +			compatible = "arm,cortex-a76";
>> +			device_type = "cpu";
>> +			enable-method = "psci";
>> +			reg = <0x300>;
>> +		};
>> +	};
>> +
>> +	psci {
>> +		compatible = "arm,psci-0.2";
>> +		method = "smc";
>> +	};
>> +
>> +	intc: interrupt-controller@1d000000 {
>> +		compatible = "arm,gic-v3", "arm,cortex-a15-gic";
>
>reg is always after compatible. Then ranges, if applicable.
>
>> +		#interrupt-cells = <3>;
>> +		#address-cells = <2>;
>> +		#size-cells =<2>;
>> +		interrupt-controller;
>> +		#redistributor-regions = <1>;
>> +		label = "GIC";
>
>It does not look like you tested the DTS against bindings. Please run `make dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst or https://www.linaro.org/blog/tips-and-tricks-for-validating-devicetree-sources-with-the-devicetree-schema/
>for instructions).
>
>> +		status = "okay";
>
>Drop, you don't need status.
>
>> +		ranges;
>> +		redistributor-stride = <0x0 0x20000>;
>> +		reg = <0x0 0x1d000000 0 0x10000>,
>> +			<0x0 0x1d060000 0 0x100000>;
>> +
>> +		its: msi-controller@1d040000 {
>> +			compatible = "arm,gic-v3-its";
>> +			reg = <0x0 0x1d040000 0x0 0x20000>;
>> +			label = "ITS";
>> +			msi-controller;
>> +			status = "okay";
>
>Drop
>
>Anyway, entire node should be in soc. You clearly did not test it with dtbs W=1. Neither with dtbs_check.
>
>
>> +		};
>> +	};
>> +
>> +	/* Clock tree 5 main sources*/
>> +	clocks {
>> +		cb_intosc_hs_div2_clk: cb-intosc-hs-div2-clk {
>> +			#clock-cells = <0>;
>> +			compatible = "fixed-clock";
>> +		};
>> +
>> +		cb_intosc_ls_clk: cb-intosc-ls-clk {
>> +			#clock-cells = <0>;
>> +			compatible = "fixed-clock";
>> +		};
>> +
>> +		f2s_free_clk: f2s-free-clk {
>> +			#clock-cells = <0>;
>> +			compatible = "fixed-clock";
>> +		};
>> +
>> +		osc1: osc1 {
>> +			#clock-cells = <0>;
>> +			compatible = "fixed-clock";
>> +		};
>> +
>> +		qspi_clk: qspi-clk {
>> +			#clock-cells = <0>;
>> +			compatible = "fixed-clock";
>> +			clock-frequency = <200000000>;
>> +		};
>> +	};
>> +
>> +	timer {
>> +		compatible = "arm,armv8-timer";
>> +		interrupt-parent = <&intc>;
>> +		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
>> +			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
>> +			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
>> +			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
>> +	};
>> +
>> +	usbphy0: usbphy {
>> +		#phy-cells = <0>;
>> +		compatible = "usb-nop-xceiv";
>> +	};
>> +
>> +	soc {
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		compatible = "simple-bus";
>> +		device_type = "soc";
>> +		interrupt-parent = <&intc>;
>> +		ranges = <0 0 0 0xffffffff>;
>> +
>> +		clkmgr: clock-controller@10d10000 {
>> +			compatible = "intel,agilex5-clkmgr";
>> +			reg = <0x10d10000 0x1000>;
>> +			#clock-cells = <1>;
>> +		};
>> +
>> +		stmmac_axi_setup: stmmac-axi-config {
>> +			snps,wr_osr_lmt = <31>;
>> +			snps,rd_osr_lmt = <31>;
>> +			snps,blen = <0 0 0 32 16 8 4>;
>> +		};
>> +
>> +		mtl_rx_setup: rx-queues-config {
>
>These two nodes do not belong to SoC. Soc is for MMIO-based nodes.
>
>
>> +			snps,rx-queues-to-use = <8>;
>> +			snps,rx-sched-sp;
>> +			queue0 {
>> +				snps,dcb-algorithm;
>> +				snps,map-to-dma-channel = <0x0>;
>> +			};
>> +			queue1 {
>> +				snps,dcb-algorithm;
>> +				snps,map-to-dma-channel = <0x1>;
>> +			};
>> +			queue2 {
>> +				snps,dcb-algorithm;
>> +				snps,map-to-dma-channel = <0x2>;
>> +			};
>> +			queue3 {
>> +				snps,dcb-algorithm;
>> +				snps,map-to-dma-channel = <0x3>;
>> +			};
>> +			queue4 {
>> +				snps,dcb-algorithm;
>> +				snps,map-to-dma-channel = <0x4>;
>> +			};
>> +			queue5 {
>> +				snps,dcb-algorithm;
>> +				snps,map-to-dma-channel = <0x5>;
>> +			};
>> +			queue6 {
>> +				snps,dcb-algorithm;
>> +				snps,map-to-dma-channel = <0x6>;
>> +			};
>> +			queue7 {
>> +				snps,dcb-algorithm;
>> +				snps,map-to-dma-channel = <0x7>;
>> +			};
>> +		};
>> +
>> +		mtl_tx_setup: tx-queues-config {
>
>This as well
>
>> +			snps,tx-queues-to-use = <8>;
>> +			snps,tx-sched-wrr;
>> +			queue0 {
>> +				snps,weight = <0x09>;
>> +				snps,dcb-algorithm;
>> +			};
>> +			queue1 {
>> +				snps,weight = <0x0A>;
>> +				snps,dcb-algorithm;
>> +			};
>> +			queue2 {
>> +				snps,weight = <0x0B>;
>> +				snps,dcb-algorithm;
>> +			};
>> +			queue3 {
>> +				snps,weight = <0x0C>;
>> +				snps,dcb-algorithm;
>> +			};
>> +			queue4 {
>> +				snps,weight = <0x0D>;
>> +				snps,dcb-algorithm;
>> +			};
>> +			queue5 {
>> +				snps,weight = <0x0E>;
>> +				snps,dcb-algorithm;
>> +			};
>> +			queue6 {
>> +				snps,weight = <0x0F>;
>> +				snps,dcb-algorithm;
>> +			};
>> +			queue7 {
>> +				snps,weight = <0x10>;
>> +				snps,dcb-algorithm;
>> +			};
>> +		};
>> +
>> +		gmac0: ethernet@10810000 {
>> +			compatible = "altr,socfpga-stmmac-a10-s10",
>> +						"snps,dwxgmac-2.10",
>> +						"snps,dwxgmac";
>
>You have broken alignment.
>
>> +			reg = <0x10810000 0x3500>;
>> +			interrupts = <GIC_SPI 190 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 191 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 192 IRQ_TYPE_LEVEL_HIGH>,
>
>In multiple places. Really.
>
>> +						<GIC_SPI 193 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 194 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 195 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 197 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 198 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 199 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 201 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 202 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 203 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 204 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>,
>> +						<GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
>> +			interrupt-names = "macirq",
>> +							"macirq_tx0",
>
>This is ugly.
>
>> +							"macirq_tx1",
>> +							"macirq_tx2",
>> +							"macirq_tx3",
>> +							"macirq_tx4",
>> +							"macirq_tx5",
>> +							"macirq_tx6",
>> +							"macirq_tx7",
>> +							"macirq_rx0",
>> +							"macirq_rx1",
>> +							"macirq_rx2",
>> +							"macirq_rx3",
>> +							"macirq_rx4",
>> +							"macirq_rx5",
>> +							"macirq_rx6",
>> +							"macirq_rx7";
>> +			mac-address = [00 00 00 00 00 00];
>
>Drop, it's SoC file.

Will remove these nodes, ethernet related changes will be submitted in
separate patch later.

>
>> +			resets = <&rst EMAC0_RESET>, <&rst EMAC0_OCP_RESET>;
>> +			reset-names = "stmmaceth", "stmmaceth-ocp";
>> +			tx-fifo-depth = <32768>;
>> +			rx-fifo-depth = <16384>;
>> +			snps,multicast-filter-bins = <64>;
>> +			snps,perfect-filter-entries = <64>;
>> +			snps,axi-config = <&stmmac_axi_setup>;
>> +			snps,mtl-rx-config = <&mtl_rx_setup>;
>> +			snps,mtl-tx-config = <&mtl_tx_setup>;
>> +			snps,pbl = <32>;
>> +			snps,pblx8;
>> +			snps,multi-irq-en;
>> +			snps,tso;
>> +			altr,sysmgr-syscon = <&sysmgr 0x44 0>;
>> +			altr,smtg-hub;
>> +			snps,rx-vlan-offload;
>> +			clocks = <&clkmgr AGILEX5_EMAC0_CLK>, <&clkmgr AGILEX5_EMAC_PTP_CLK>;
>> +			clock-names = "stmmaceth", "ptp_ref";
>> +			status = "disabled";
>> +		};
>> +
>> +		i2c0: i2c@10c02800 {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>
>compatible first, reg second.
>
>> +			compatible = "snps,designware-i2c";
>> +			reg = <0x10c02800 0x100>;
>> +			interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
>> +			resets = <&rst I2C0_RESET>;
>> +			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
>> +			status = "disabled";
>> +		};
>> +
>> +		i2c1: i2c@10c02900 {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			compatible = "snps,designware-i2c";
>> +			reg = <0x10c02900 0x100>;
>> +			interrupts = <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>;
>> +			resets = <&rst I2C1_RESET>;
>> +			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
>> +			status = "disabled";
>> +		};
>> +
>> +		i2c2: i2c@10c02a00 {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			compatible = "snps,designware-i2c";
>> +			reg = <0x10c02a00 0x100>;
>> +			interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
>> +			resets = <&rst I2C2_RESET>;
>> +			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
>> +			status = "disabled";
>> +		};
>> +
>> +		i2c3: i2c@10c02b00 {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			compatible = "snps,designware-i2c";
>> +			reg = <0x10c02b00 0x100>;
>> +			interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
>> +			resets = <&rst I2C3_RESET>;
>> +			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
>> +			status = "disabled";
>> +		};
>> +
>> +		i2c4: i2c@10c02c00 {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			compatible = "snps,designware-i2c";
>> +			reg = <0x10c02c00 0x100>;
>> +			interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
>> +			resets = <&rst I2C4_RESET>;
>> +			clocks = <&clkmgr AGILEX5_L4_SP_CLK>;
>> +			status = "disabled";
>> +		};
>> +
>> +		i3c0: i3c@10da0000 {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			compatible = "snps,dw-i3c-master-1.00a";
>> +			reg = <0x10da0000 0x1000>;
>> +			interrupts = <GIC_SPI 164 IRQ_TYPE_LEVEL_HIGH>;
>> +			resets = <&rst I3C0_RESET>;
>> +			clocks = <&clkmgr AGILEX5_L4_MP_CLK>;
>> +			status = "disabled";
>> +		};
>> +
>> +		i3c1: i3c@10da1000 {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			compatible = "snps,dw-i3c-master-1.00a";
>> +			reg = <0x10da1000 0x1000>;
>> +			interrupts = <GIC_SPI 165 IRQ_TYPE_LEVEL_HIGH>;
>> +			resets = <&rst I3C1_RESET>;
>> +			clocks = <&clkmgr AGILEX5_L4_MP_CLK>;
>> +			status = "disabled";
>> +		};
>> +
>> +		gpio1: gpio@10C03300 {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			compatible = "snps,dw-apb-gpio";
>> +			reg = <0x10C03300 0x100>;
>> +			resets = <&rst GPIO1_RESET>;
>> +			status = "disabled";
>> +
>> +			portb: gpio-controller@0 {
>> +				compatible = "snps,dw-apb-gpio-port";
>> +				gpio-controller;
>> +				#gpio-cells = <2>;
>> +				snps,nr-gpios = <24>;
>> +				reg = <0>;
>> +				interrupt-controller;
>> +				#interrupt-cells = <2>;
>> +				interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
>> +			};
>> +		};
>> +
>> +		mmc: mmc0@10808000 {
>
>It does not look like you tested the DTS against bindings. Please run `make dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst or https://www.linaro.org/blog/tips-and-tricks-for-validating-devicetree-sources-with-the-devicetree-schema/
>for instructions).
>
>Sorry, but your DTS lacks any basic (internal!) review and basic tests with automated tools.
>
>..
>
>> +		spi0: spi@10da4000 {
>> +			compatible = "snps,dw-apb-ssi";
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			reg = <0x10da4000 0x1000>;
>> +			interrupts = <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>;
>> +			resets = <&rst SPIM0_RESET>;
>> +			reset-names = "spi";
>> +			reg-io-width = <4>;
>> +			num-cs = <4>;
>> +			clocks = <&clkmgr AGILEX5_L4_MAIN_CLK>;
>> +			dmas = <&dmac0 2>, <&dmac0 3>;
>> +			dma-names ="tx", "rx";
>> +
>> +			status = "disabled";
>> +
>> +			flash: m25p128@0 {
>
>It's getting worse...
>
>> +				status = "okay";
>
>and worse
>
>> +				compatible = "st,m25p80";
>> +				spi-max-frequency = <25000000>;
>> +				m25p,fast-read;
>> +				reg = <0>;
>> +
>> +				#address-cells = <1>;
>> +				#size-cells = <1>;
>> +
>> +				partition@0 {
>> +				label = "spi_flash_part0";
>> +				reg = <0x0 0x100000>;
>
>and less conforming to style
>
>> +				};
>> +			};
>> +
>
>... and less.
>...
>
>> +
>> +	chosen {
>> +		stdout-path = "serial0:115200n8";
>> +		bootargs = "console=uart8250,mmio32,0x10c02000,115200n8 \
>> +			root=/dev/ram0 rw initrd=0x10000000 init=/sbin/init \
>> +			ramdisk_size=10000000 earlycon=uart8250,mmio32,0x10c02000,115200n8 \
>> +			panic=-1 nosmp rootfstype=ext3";
>
>NAK. Drop entire bootags.
>
>> +	};
>> +
>> +	leds {
>> +		compatible = "gpio-leds";
>> +		hps0 {
>
>No, srsly? So all our cleanups for few years mean nothing?
>

Will fix all the review comments in v2 patch.

Thanks,
Nirav 

