Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA4C5059AC
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 16:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344377AbiDRO1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 10:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345414AbiDROY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 10:24:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D944D37A1E;
        Mon, 18 Apr 2022 06:19:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 664E660F56;
        Mon, 18 Apr 2022 13:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193D6C385A1;
        Mon, 18 Apr 2022 13:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650287996;
        bh=1Mi8biN2KXQIL140qKALu53xSNHOc/pw3Qr7fbr4D6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WoqjP/z4vP+CLTdu2OPcK+LiqSuJjy2wEemTGDavUd+ptfClsDVTIyn+tOl8VXBOB
         OkzSMdHQC0FSumISRB0rRbeA15G1zlL7jH+teXQU+/6g/hY4ReVsoLF0lRPbkcaDC+
         o+dqj1IphYKvzRHQPfr8yleB7PAm+qP172HMOIiodQfCpuFHpkLC0jmxBi86ZGO4ih
         WTPvZa7u0pt3pcrqRHfODwj8Bh1qlg72eYlXN7HY2ij2417MgeTQqS1p/DwjpdrkEN
         yqqfCpygeAMdirbL+ebfHnpJSgaMeahjcPP5MhoYN01i7Ywpvn8DUYv3sv4toYahD7
         aOZGNFz4rmdsQ==
Date:   Mon, 18 Apr 2022 21:19:50 +0800
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
Subject: Re: [PATCH v6 06/13] arm64: dts: freescale: Add i.MX8DXL evk board
 support
Message-ID: <20220418131950.GR391514@dragon>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
 <20220413103356.3433637-7-abel.vesa@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413103356.3433637-7-abel.vesa@nxp.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 01:33:49PM +0300, Abel Vesa wrote:
> From: Jacky Bai <ping.bai@nxp.com>
> 
> Add i.MX8DXL EVK board support.
> 
> Signed-off-by: Jacky Bai <ping.bai@nxp.com>
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> ---
>  arch/arm64/boot/dts/freescale/Makefile        |   1 +
>  arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 266 ++++++++++++++++++
>  2 files changed, 267 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
> 
> diff --git a/arch/arm64/boot/dts/freescale/Makefile b/arch/arm64/boot/dts/freescale/Makefile
> index 85c2c9ba5110..d6be4e8ff3c2 100644
> --- a/arch/arm64/boot/dts/freescale/Makefile
> +++ b/arch/arm64/boot/dts/freescale/Makefile
> @@ -98,6 +98,7 @@ dtb-$(CONFIG_ARCH_MXC) += imx8mq-pico-pi.dtb
>  dtb-$(CONFIG_ARCH_MXC) += imx8mq-thor96.dtb
>  dtb-$(CONFIG_ARCH_MXC) += imx8mq-zii-ultra-rmb3.dtb
>  dtb-$(CONFIG_ARCH_MXC) += imx8mq-zii-ultra-zest.dtb
> +dtb-$(CONFIG_ARCH_MXC) += imx8dxl-evk.dtb

Out of alphabetical order.

>  dtb-$(CONFIG_ARCH_MXC) += imx8qm-mek.dtb
>  dtb-$(CONFIG_ARCH_MXC) += imx8qxp-ai_ml.dtb
>  dtb-$(CONFIG_ARCH_MXC) += imx8qxp-colibri-eval-v3.dtb
> diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
> new file mode 100644
> index 000000000000..68dfe722af6d
> --- /dev/null
> +++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
> @@ -0,0 +1,266 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright 2019-2021 NXP
> + */
> +
> +/dts-v1/;
> +
> +#include "imx8dxl.dtsi"
> +
> +/ {
> +	model = "Freescale i.MX8DXL EVK";
> +	compatible = "fsl,imx8dxl-evk", "fsl,imx8dxl";
> +
> +	chosen {
> +		stdout-path = &lpuart0;
> +	};
> +
> +	memory@80000000 {
> +		device_type = "memory";
> +		reg = <0x00000000 0x80000000 0 0x40000000>;
> +	};
> +
> +	reserved-memory {
> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		ranges;
> +
> +		/*
> +		 * 0x8800_0000 ~ 0x8FFF_FFFF is reserved for M4
> +		 * Shouldn't be used at A core and Linux side.
> +		 *
> +		 */
> +		m4_reserved: m4@88000000 {
> +			no-map;
> +			reg = <0 0x88000000 0 0x8000000>;
> +		};
> +
> +		/* global autoconfigured region for contiguous allocations */
> +		linux,cma {
> +			compatible = "shared-dma-pool";
> +			reusable;
> +			size = <0 0x14000000>;
> +			alloc-ranges = <0 0x98000000 0 0x14000000>;
> +			linux,cma-default;
> +		};
> +	};
> +
> +	reg_usdhc2_vmmc: usdhc2-vmmc {
> +		compatible = "regulator-fixed";
> +		regulator-name = "SD1_SPWR";
> +		regulator-min-microvolt = <3000000>;
> +		regulator-max-microvolt = <3000000>;
> +		gpio = <&lsio_gpio4 30 GPIO_ACTIVE_HIGH>;
> +		enable-active-high;
> +		off-on-delay-us = <3480>;
> +	};
> +};
> +
> +&lpuart0 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_lpuart0>;
> +	status = "okay";
> +};
> +
> +&lpuart1 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_lpuart1>;
> +	status = "okay";
> +};
> +
> +&lsio_gpio4 {
> +	status = "okay";
> +};
> +
> +&lsio_gpio5 {
> +	status = "okay";
> +};
> +
> +&thermal_zones {
> +	pmic-thermal0 {
> +		polling-delay-passive = <250>;
> +		polling-delay = <2000>;
> +		thermal-sensors = <&tsens IMX_SC_R_PMIC_0>;

Newline between properties and child node.

> +		trips {
> +			pmic_alert0: trip0 {
> +				temperature = <110000>;
> +				hysteresis = <2000>;
> +				type = "passive";
> +			};

Newline between nodes.

> +			pmic_crit0: trip1 {
> +				temperature = <125000>;
> +				hysteresis = <2000>;
> +				type = "critical";
> +			};
> +		};
> +		cooling-maps {
> +			map0 {
> +				trip = <&pmic_alert0>;
> +				cooling-device =
> +					<&A35_0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
> +					<&A35_1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
> +			};
> +		};
> +	};
> +};
> +
> +&usdhc1 {
> +		pinctrl-names = "default", "state_100mhz", "state_200mhz";
> +		pinctrl-0 = <&pinctrl_usdhc1>;
> +		pinctrl-1 = <&pinctrl_usdhc1_100mhz>;
> +		pinctrl-2 = <&pinctrl_usdhc1_200mhz>;
> +		bus-width = <8>;
> +		no-sd;
> +		no-sdio;
> +		non-removable;
> +		status = "okay";

One level indent is good enough.

Shawn

> +};
> +
> +&usdhc2 {
> +		pinctrl-names = "default", "state_100mhz", "state_200mhz";
> +		pinctrl-0 = <&pinctrl_usdhc2>, <&pinctrl_usdhc2_gpio>;
> +		pinctrl-1 = <&pinctrl_usdhc2_100mhz>, <&pinctrl_usdhc2_gpio>;
> +		pinctrl-2 = <&pinctrl_usdhc2_200mhz>, <&pinctrl_usdhc2_gpio>;
> +		bus-width = <4>;
> +		vmmc-supply = <&reg_usdhc2_vmmc>;
> +		cd-gpios = <&lsio_gpio5 1 GPIO_ACTIVE_LOW>;
> +		wp-gpios = <&lsio_gpio5 0 GPIO_ACTIVE_HIGH>;
> +		max-frequency = <100000000>;
> +		status = "okay";
> +};
> +
> +&iomuxc {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_hog>;
> +
> +	pinctrl_hog: hoggrp {
> +		fsl,pins = <
> +			IMX8DXL_COMP_CTL_GPIO_1V8_3V3_GPIORHB_PAD	0x000514a0
> +			IMX8DXL_COMP_CTL_GPIO_1V8_3V3_GPIORHK_PAD	0x000014a0
> +			IMX8DXL_SPI3_CS0_ADMA_ACM_MCLK_OUT1		0x0600004c
> +			IMX8DXL_SNVS_TAMPER_OUT1_LSIO_GPIO2_IO05_IN	0x0600004c
> +		>;
> +	};
> +
> +	pinctrl_i2c2: i2c2grp {
> +		fsl,pins = <
> +			IMX8DXL_SPI1_SCK_ADMA_I2C2_SDA		0x06000021
> +			IMX8DXL_SPI1_SDO_ADMA_I2C2_SCL		0x06000021
> +		>;
> +	};
> +
> +	pinctrl_i2c3: i2c3grp {
> +		fsl,pins = <
> +			IMX8DXL_SPI1_CS0_ADMA_I2C3_SDA		0x06000021
> +			IMX8DXL_SPI1_SDI_ADMA_I2C3_SCL		0x06000021
> +		>;
> +	};
> +
> +	pinctrl_lpuart0: lpuart0grp {
> +		fsl,pins = <
> +			IMX8DXL_UART0_RX_ADMA_UART0_RX		0x06000020
> +			IMX8DXL_UART0_TX_ADMA_UART0_TX		0x06000020
> +		>;
> +	};
> +
> +	pinctrl_lpuart1: lpuart1grp {
> +		fsl,pins = <
> +			IMX8DXL_UART1_TX_ADMA_UART1_TX          0x06000020
> +			IMX8DXL_UART1_RX_ADMA_UART1_RX          0x06000020
> +			IMX8DXL_UART1_RTS_B_ADMA_UART1_RTS_B    0x06000020
> +			IMX8DXL_UART1_CTS_B_ADMA_UART1_CTS_B    0x06000020
> +		>;
> +	};
> +
> +	pinctrl_usdhc1: usdhc1grp {
> +		fsl,pins = <
> +			IMX8DXL_EMMC0_CLK_CONN_EMMC0_CLK	0x06000041
> +			IMX8DXL_EMMC0_CMD_CONN_EMMC0_CMD	0x00000021
> +			IMX8DXL_EMMC0_DATA0_CONN_EMMC0_DATA0	0x00000021
> +			IMX8DXL_EMMC0_DATA1_CONN_EMMC0_DATA1	0x00000021
> +			IMX8DXL_EMMC0_DATA2_CONN_EMMC0_DATA2	0x00000021
> +			IMX8DXL_EMMC0_DATA3_CONN_EMMC0_DATA3	0x00000021
> +			IMX8DXL_EMMC0_DATA4_CONN_EMMC0_DATA4	0x00000021
> +			IMX8DXL_EMMC0_DATA5_CONN_EMMC0_DATA5	0x00000021
> +			IMX8DXL_EMMC0_DATA6_CONN_EMMC0_DATA6	0x00000021
> +			IMX8DXL_EMMC0_DATA7_CONN_EMMC0_DATA7	0x00000021
> +			IMX8DXL_EMMC0_STROBE_CONN_EMMC0_STROBE	0x00000041
> +		>;
> +	};
> +
> +	pinctrl_usdhc1_100mhz: usdhc1grp100mhz {
> +		fsl,pins = <
> +			IMX8DXL_EMMC0_CLK_CONN_EMMC0_CLK	0x06000041
> +			IMX8DXL_EMMC0_CMD_CONN_EMMC0_CMD	0x00000021
> +			IMX8DXL_EMMC0_DATA0_CONN_EMMC0_DATA0	0x00000021
> +			IMX8DXL_EMMC0_DATA1_CONN_EMMC0_DATA1	0x00000021
> +			IMX8DXL_EMMC0_DATA2_CONN_EMMC0_DATA2	0x00000021
> +			IMX8DXL_EMMC0_DATA3_CONN_EMMC0_DATA3	0x00000021
> +			IMX8DXL_EMMC0_DATA4_CONN_EMMC0_DATA4	0x00000021
> +			IMX8DXL_EMMC0_DATA5_CONN_EMMC0_DATA5	0x00000021
> +			IMX8DXL_EMMC0_DATA6_CONN_EMMC0_DATA6	0x00000021
> +			IMX8DXL_EMMC0_DATA7_CONN_EMMC0_DATA7	0x00000021
> +			IMX8DXL_EMMC0_STROBE_CONN_EMMC0_STROBE	0x00000041
> +		>;
> +	};
> +
> +	pinctrl_usdhc1_200mhz: usdhc1grp200mhz {
> +		fsl,pins = <
> +			IMX8DXL_EMMC0_CLK_CONN_EMMC0_CLK	0x06000041
> +			IMX8DXL_EMMC0_CMD_CONN_EMMC0_CMD	0x00000021
> +			IMX8DXL_EMMC0_DATA0_CONN_EMMC0_DATA0	0x00000021
> +			IMX8DXL_EMMC0_DATA1_CONN_EMMC0_DATA1	0x00000021
> +			IMX8DXL_EMMC0_DATA2_CONN_EMMC0_DATA2	0x00000021
> +			IMX8DXL_EMMC0_DATA3_CONN_EMMC0_DATA3	0x00000021
> +			IMX8DXL_EMMC0_DATA4_CONN_EMMC0_DATA4	0x00000021
> +			IMX8DXL_EMMC0_DATA5_CONN_EMMC0_DATA5	0x00000021
> +			IMX8DXL_EMMC0_DATA6_CONN_EMMC0_DATA6	0x00000021
> +			IMX8DXL_EMMC0_DATA7_CONN_EMMC0_DATA7	0x00000021
> +			IMX8DXL_EMMC0_STROBE_CONN_EMMC0_STROBE	0x00000041
> +		>;
> +	};
> +
> +	pinctrl_usdhc2_gpio: usdhc2gpiogrp {
> +		fsl,pins = <
> +			IMX8DXL_ENET0_RGMII_TX_CTL_LSIO_GPIO4_IO30	0x00000040 /* RESET_B */
> +			IMX8DXL_ENET0_RGMII_TXD1_LSIO_GPIO5_IO00	0x00000021 /* WP */
> +			IMX8DXL_ENET0_RGMII_TXD2_LSIO_GPIO5_IO01	0x00000021 /* CD */
> +		>;
> +	};
> +
> +	pinctrl_usdhc2: usdhc2grp {
> +		fsl,pins = <
> +			IMX8DXL_ENET0_RGMII_RXC_CONN_USDHC1_CLK		0x06000041
> +			IMX8DXL_ENET0_RGMII_RX_CTL_CONN_USDHC1_CMD	0x00000021
> +			IMX8DXL_ENET0_RGMII_RXD0_CONN_USDHC1_DATA0	0x00000021
> +			IMX8DXL_ENET0_RGMII_RXD1_CONN_USDHC1_DATA1	0x00000021
> +			IMX8DXL_ENET0_RGMII_RXD2_CONN_USDHC1_DATA2	0x00000021
> +			IMX8DXL_ENET0_RGMII_RXD3_CONN_USDHC1_DATA3	0x00000021
> +			IMX8DXL_ENET0_RGMII_TXD0_CONN_USDHC1_VSELECT	0x00000021
> +		>;
> +	};
> +
> +	pinctrl_usdhc2_100mhz: usdhc2grp100mhz {
> +		fsl,pins = <
> +			IMX8DXL_ENET0_RGMII_RXC_CONN_USDHC1_CLK		0x06000041
> +			IMX8DXL_ENET0_RGMII_RX_CTL_CONN_USDHC1_CMD	0x00000021
> +			IMX8DXL_ENET0_RGMII_RXD0_CONN_USDHC1_DATA0	0x00000021
> +			IMX8DXL_ENET0_RGMII_RXD1_CONN_USDHC1_DATA1	0x00000021
> +			IMX8DXL_ENET0_RGMII_RXD2_CONN_USDHC1_DATA2	0x00000021
> +			IMX8DXL_ENET0_RGMII_RXD3_CONN_USDHC1_DATA3	0x00000021
> +			IMX8DXL_ENET0_RGMII_TXD0_CONN_USDHC1_VSELECT	0x00000021
> +		>;
> +	};
> +
> +	pinctrl_usdhc2_200mhz: usdhc2grp200mhz {
> +		fsl,pins = <
> +			IMX8DXL_ENET0_RGMII_RXC_CONN_USDHC1_CLK		0x06000041
> +			IMX8DXL_ENET0_RGMII_RX_CTL_CONN_USDHC1_CMD	0x00000021
> +			IMX8DXL_ENET0_RGMII_RXD0_CONN_USDHC1_DATA0	0x00000021
> +			IMX8DXL_ENET0_RGMII_RXD1_CONN_USDHC1_DATA1	0x00000021
> +			IMX8DXL_ENET0_RGMII_RXD2_CONN_USDHC1_DATA2	0x00000021
> +			IMX8DXL_ENET0_RGMII_RXD3_CONN_USDHC1_DATA3	0x00000021
> +			IMX8DXL_ENET0_RGMII_TXD0_CONN_USDHC1_VSELECT	0x00000021
> +		>;
> +	};
> +};
> -- 
> 2.34.1
> 
