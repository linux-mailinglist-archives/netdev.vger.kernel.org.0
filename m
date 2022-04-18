Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9308D50596B
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 16:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244368AbiDROTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 10:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345198AbiDROSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 10:18:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A204C42D;
        Mon, 18 Apr 2022 06:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23D0760F5E;
        Mon, 18 Apr 2022 13:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4ABC385A1;
        Mon, 18 Apr 2022 13:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650287649;
        bh=OWZ971jw8CZNKUwPBGYVYpdeU3kKngi7ozqIslI6Rfs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h9oegXdiYR48VEerZeEyCqMhFnXVHu04eV4QvHBGw7p/UfDUT/RUdbUWDKHlx+sXW
         9ZIqRFGNYXmVsGDKl6nOgdLzNfsa0DCAO9Z9C59LQYeiLPOtmMNHeh6k9VvDvRKcqG
         L4ldbVjs6VlIJYuy4Z0KUTobXUB9ZQJe93DVnOhlQ9+8YberOQFw0ZiFo1epSjCLip
         AHNFpcLXjdWrP3z1rDpPsp/GGmMi8welusHv8+9tiSpeXJ0l7Bn15TxnU/1OVd+qeR
         P1BAblfqfrr4/VLcigsguEkKPNqHSoeIx61fWgpOY9ri1CiaSgmPKK1XKCR3T8+vK7
         ZsqaBFD/dIhOA==
Date:   Mon, 18 Apr 2022 21:14:02 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Abel Vesa <abel.vesa@nxp.com>
Cc:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Jacky Bai <ping.bai@nxp.com>
Subject: Re: [PATCH v6 03/13] arm64: dts: freescale: Add the imx8dxl
 connectivity subsys dtsi
Message-ID: <20220418131402.GQ391514@dragon>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
 <20220413103356.3433637-4-abel.vesa@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413103356.3433637-4-abel.vesa@nxp.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 01:33:46PM +0300, Abel Vesa wrote:
> From: Jacky Bai <ping.bai@nxp.com>
> 
> On i.MX8DXL, the Connectivity subsystem includes below peripherals:
> 1x ENET with AVB support, 1x ENET with TSN support, 2x USB OTG,
> 1x eMMC, 2x SD, 1x NAND.
> 
> Signed-off-by: Jacky Bai <ping.bai@nxp.com>
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>

I got following warning with 'W=1' build flag.

../arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi:10.45-15.4: Warning (simple_bus_reg): /bus@5b000000/clock-conn-enet0-root: missing or empty reg/ranges property
../arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi:63.29-68.4: Warning (simple_bus_reg): /bus@5b000000/usbphy@0x5b110000: simple-bus unit address format error, expected "5b110000"
../arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi:7.27-12.4: Warning (simple_bus_reg): /bus@5c000000/clock-db-ipg: missing or empty reg/ranges property

Shawn

> ---
>  .../boot/dts/freescale/imx8dxl-ss-conn.dtsi   | 134 ++++++++++++++++++
>  1 file changed, 134 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
> new file mode 100644
> index 000000000000..b776d0ed42b4
> --- /dev/null
> +++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
> @@ -0,0 +1,134 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright 2019-2021 NXP
> + */
> +
> +/delete-node/ &enet1_lpcg;
> +/delete-node/ &fec2;
> +
> +&conn_subsys {
> +	conn_enet0_root_clk: clock-conn-enet0-root {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <250000000>;
> +		clock-output-names = "conn_enet0_root_clk";
> +	};
> +
> +	eqos: ethernet@5b050000 {
> +		compatible = "nxp,imx8dxl-dwmac-eqos", "snps,dwmac-5.10a";
> +		reg = <0x5b050000 0x10000>;
> +		interrupt-parent = <&gic>;
> +		interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>,
> +			     <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>;
> +		interrupt-names = "eth_wake_irq", "macirq";
> +		clocks = <&eqos_lpcg IMX_LPCG_CLK_2>,
> +			 <&eqos_lpcg IMX_LPCG_CLK_4>,
> +			 <&eqos_lpcg IMX_LPCG_CLK_0>,
> +			 <&eqos_lpcg IMX_LPCG_CLK_3>,
> +			 <&eqos_lpcg IMX_LPCG_CLK_1>;
> +		clock-names = "stmmaceth", "pclk", "ptp_ref", "tx", "mem";
> +		assigned-clocks = <&clk IMX_SC_R_ENET_1 IMX_SC_PM_CLK_PER>;
> +		assigned-clock-rates = <125000000>;
> +		power-domains = <&pd IMX_SC_R_ENET_1>;
> +		status = "disabled";
> +	};
> +
> +	usbotg2: usb@5b0e0000 {
> +		compatible = "fsl,imx8dxl-usb", "fsl,imx7ulp-usb";
> +		reg = <0x5b0e0000 0x200>;
> +		interrupt-parent = <&gic>;
> +		interrupts = <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
> +		fsl,usbphy = <&usbphy2>;
> +		fsl,usbmisc = <&usbmisc2 0>;
> +		/*
> +		 * usbotg1 and usbotg2 share one clock
> +		 * scfw disable clock access and keep it always on
> +		 * in case other core (M4) use one of these.
> +		 */
> +		clocks = <&clk_dummy>;
> +		ahb-burst-config = <0x0>;
> +		tx-burst-size-dword = <0x10>;
> +		rx-burst-size-dword = <0x10>;
> +		#stream-id-cells = <1>;

Where do I find bindings for this property?

Shawn

> +		power-domains = <&pd IMX_SC_R_USB_1>;
> +		status = "disabled";
> +	};
> +
> +	usbmisc2: usbmisc@5b0e0200 {
> +		#index-cells = <1>;
> +		compatible = "fsl,imx8dxl-usbmisc", "fsl,imx7ulp-usbmisc";
> +		reg = <0x5b0e0200 0x200>;
> +	};
> +
> +	usbphy2: usbphy@0x5b110000 {
> +		compatible = "fsl,imx8dxl-usbphy", "fsl,imx7ulp-usbphy";
> +		reg = <0x5b110000 0x1000>;
> +		clocks = <&usb2_2_lpcg IMX_LPCG_CLK_7>;
> +		status = "disabled";
> +	};
> +
> +	eqos_lpcg: clock-controller@5b240000 {
> +		compatible = "fsl,imx8qxp-lpcg";
> +		reg = <0x5b240000 0x10000>;
> +		#clock-cells = <1>;
> +		clocks = <&conn_enet0_root_clk>,
> +			 <&conn_axi_clk>,
> +			 <&conn_axi_clk>,
> +			 <&clk IMX_SC_R_ENET_1 IMX_SC_PM_CLK_PER>,
> +			 <&conn_ipg_clk>;
> +		clock-indices = <IMX_LPCG_CLK_0>,
> +				<IMX_LPCG_CLK_2>,
> +				<IMX_LPCG_CLK_4>,
> +				<IMX_LPCG_CLK_5>,
> +				<IMX_LPCG_CLK_6>;
> +		clock-output-names = "eqos_ptp",
> +				     "eqos_mem_clk",
> +				     "eqos_aclk",
> +				     "eqos_clk",
> +				     "eqos_csr_clk";
> +		power-domains = <&pd IMX_SC_R_ENET_1>;
> +	};
> +
> +	usb2_2_lpcg: clock-controller@5b280000 {
> +		compatible = "fsl,imx8qxp-lpcg";
> +		reg = <0x5b280000 0x10000>;
> +		#clock-cells = <1>;
> +		clock-indices = <IMX_LPCG_CLK_7>;
> +		clocks = <&conn_ipg_clk>;
> +		clock-output-names = "usboh3_2_phy_ipg_clk";
> +	};
> +};
> +
> +&enet0_lpcg {
> +	clocks = <&conn_enet0_root_clk>,
> +		 <&conn_enet0_root_clk>,
> +		 <&conn_axi_clk>,
> +		 <&clk IMX_SC_R_ENET_0 IMX_SC_C_TXCLK>,
> +		 <&conn_ipg_clk>,
> +		 <&conn_ipg_clk>;
> +};
> +
> +&fec1 {
> +	compatible = "fsl,imx8dxl-fec", "fsl,imx8qm-fec";
> +	interrupts = <GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>,
> +		     <GIC_SPI 158 IRQ_TYPE_LEVEL_HIGH>,
> +		     <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>,
> +		     <GIC_SPI 161 IRQ_TYPE_LEVEL_HIGH>;
> +	assigned-clocks = <&clk IMX_SC_R_ENET_0 IMX_SC_C_CLKDIV>;
> +	assigned-clock-rates = <125000000>;
> +};
> +
> +&usdhc1 {
> +	compatible = "fsl,imx8dxl-usdhc", "fsl,imx8qxp-usdhc";
> +	interrupts = <GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>;
> +};
> +
> +&usdhc2 {
> +	compatible = "fsl,imx8dxl-usdhc", "fsl,imx8qxp-usdhc";
> +	interrupts = <GIC_SPI 139 IRQ_TYPE_LEVEL_HIGH>;
> +};
> +
> +&usdhc3 {
> +	compatible = "fsl,imx8dxl-usdhc", "fsl,imx8qxp-usdhc";
> +	interrupts = <GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>;
> +};
> -- 
> 2.34.1
> 
