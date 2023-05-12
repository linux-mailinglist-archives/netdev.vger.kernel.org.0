Return-Path: <netdev+bounces-2029-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50E04700028
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:13:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DBC31C2112D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08EE1377;
	Fri, 12 May 2023 06:13:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA89CA2A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:13:42 +0000 (UTC)
X-Greylist: delayed 1221 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 May 2023 23:13:26 PDT
Received: from gateway34.websitewelcome.com (gateway34.websitewelcome.com [192.185.148.194])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9640546BC
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:13:26 -0700 (PDT)
Received: from atl1wswcm05.websitewelcome.com (unknown [50.6.129.166])
	by atl3wswob05.websitewelcome.com (Postfix) with ESMTP id 3AA6615DF6
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 05:53:05 +0000 (UTC)
Received: from md-in-79.webhostbox.net ([43.225.55.182])
	by cmsmtp with ESMTP
	id xLiAp1704U1GUxLiCpCXgk; Fri, 12 May 2023 05:53:05 +0000
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=linumiz.com
	; s=default; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
	:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f1xCeiowuqUT4s720wL8aYrpE97LjSlbigsmROqh0ck=; b=HkVZsrzdb9pQvuzJekFEWTaohP
	LBUS9cSOuT4FLOubaxJ8WPg8Tw79/Nal4BrywgHlnf0B+u/qr4+oQPx/dDeQ+g3gU5N636rS26g/G
	td8f97Z7F5sYcwfG1683HxDJb6yI5Gaj54NjU9cEM8myglmOt6Ol5rJxgqhu5VV+qv/Hsq8nFkOnI
	RBmYhBT3lzSPup32uIs0Z8rBWX8KDI52GRkhLC4Bl+JBMBmjAF98hr7UWWwZWC9domugukkA8JbbN
	pinUyNtUdhUJPCwERXWYjrMvkHDrkR1lMOBY4c1TvEL2R96PMM4+JDaX0XWG5TQIwRBG6jDyvMtZT
	+C8BPUJg==;
Received: from [157.46.74.44] (port=56878 helo=localhost.localdomain)
	by md-in-79.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <parthiban@linumiz.com>)
	id 1pxLi9-002nAG-5p;
	Fri, 12 May 2023 11:23:01 +0530
From: Parthiban Nallathambi <parthiban@linumiz.com>
To: robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	shawnguo@kernel.org,
	s.hauer@pengutronix.de
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	netdev@vger.kernel.org,
	Parthiban Nallathambi <parthiban@linumiz.com>
Subject: [PATCH] arm64: dts: imx8mm: add support for compulab iot gateway
Date: Fri, 12 May 2023 11:22:30 +0530
Message-Id: <20230512055230.811421-1-parthiban@linumiz.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - md-in-79.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linumiz.com
X-BWhitelist: no
X-Source-IP: 157.46.74.44
X-Source-L: No
X-Exim-ID: 1pxLi9-002nAG-5p
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (localhost.localdomain) [157.46.74.44]:56878
X-Source-Auth: parthiban@linumiz.com
X-Email-Count: 1
X-Source-Cap: bGludW1jbWM7aG9zdGdhdG9yO21kLWluLTc5LndlYmhvc3Rib3gubmV0
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfByn3Cp+6A0Z9tcwcbsiWw4XBWA7K+Ot+C9N69Pc2e+qhakw1Vw52kgVksARsFhWfyzDEYlXDfli778wFdEX1rTc/kWTZuBvUV8Ntw+KSLNIf0qbRVDU
 GQdcj3UgC7A/1dJh1bfwSQHNyX3yHBiIgccpV4X3nx0NQXCov2DJBJRBYj2+fI01pl6hVUoV9AfjTRmCbppvGEnaZJOlL1pNv+g=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for compulab for imx8mm IoT gateway with
UCM-iMX8M-Mini SoM. IoT gateway comes with dual ethernet,
USB and IO expansion.

WLAN, Bluetooth can be part of SoM or extended over PCIE.

Signed-off-by: Parthiban Nallathambi <parthiban@linumiz.com>
---
 .../devicetree/bindings/arm/fsl.yaml          |   2 +
 .../bindings/net/microchip,lan95xx.yaml       |   1 +
 arch/arm64/boot/dts/freescale/Makefile        |   1 +
 .../freescale/imx8mm-compulab-iot-gate.dts    | 315 +++++++++++
 .../dts/freescale/imx8mm-compulab-ucm.dtsi    | 532 ++++++++++++++++++
 5 files changed, 851 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-compulab-iot-gate.dts
 create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-compulab-ucm.dtsi

diff --git a/Documentation/devicetree/bindings/arm/fsl.yaml b/Documentation/devicetree/bindings/arm/fsl.yaml
index 15d411084065..d2425c5ed4b7 100644
--- a/Documentation/devicetree/bindings/arm/fsl.yaml
+++ b/Documentation/devicetree/bindings/arm/fsl.yaml
@@ -895,6 +895,8 @@ properties:
       - description: i.MX8MM based Boards
         items:
           - enum:
+              - compulab,imx8mm-ucm-som   # UCM-iMX8M-Mini Compulab SoM
+              - compulab,iot-gate-imx8    # iMX8M IoT Compulab Gateway with UCM-iMX8M-Mini
               - beacon,imx8mm-beacon-kit  # i.MX8MM Beacon Development Kit
               - boundary,imx8mm-nitrogen8mm  # i.MX8MM Nitrogen Board
               - dmo,imx8mm-data-modul-edm-sbc # i.MX8MM eDM SBC
diff --git a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
index 0b97e14d947f..86279724695e 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
@@ -22,6 +22,7 @@ properties:
       - enum:
           - usb424,9500   # SMSC9500 USB Ethernet Device
           - usb424,9505   # SMSC9505 USB Ethernet Device
+          - usb424,9514   # SMSC9514 USB Ethernet Device
           - usb424,9530   # SMSC LAN9530 USB Ethernet Device
           - usb424,9730   # SMSC LAN9730 USB Ethernet Device
           - usb424,9900   # SMSC9500 USB Ethernet Device (SAL10)
diff --git a/arch/arm64/boot/dts/freescale/Makefile b/arch/arm64/boot/dts/freescale/Makefile
index ef7d17aef58f..2a613c576d29 100644
--- a/arch/arm64/boot/dts/freescale/Makefile
+++ b/arch/arm64/boot/dts/freescale/Makefile
@@ -51,6 +51,7 @@ dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1028a-qds-9999.dtb
 
 dtb-$(CONFIG_ARCH_MXC) += imx8dxl-evk.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-beacon-kit.dtb
+dtb-$(CONFIG_ARCH_MXC) += imx8mm-compulab-iot-gate.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-data-modul-edm-sbc.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-ddr4-evk.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-emcon-avari.dtb
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-compulab-iot-gate.dts b/arch/arm64/boot/dts/freescale/imx8mm-compulab-iot-gate.dts
new file mode 100644
index 000000000000..678a9022549f
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8mm-compulab-iot-gate.dts
@@ -0,0 +1,315 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
+/*
+ * Copyright 2018 Compulab
+ */
+
+/dts-v1/;
+
+#include "imx8mm-compulab-ucm.dtsi"
+
+/ {
+	model = "CompuLab IOT-GATE-iMX8 board";
+	compatible = "compulab,iot-gate-imx8", "compulab,imx8mm-ucm-som", "fsl,imx8mm";
+
+	regulator-usbhub-ena {
+		compatible = "regulator-fixed";
+		regulator-name = "usbhub_ena";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio4 28 GPIO_ACTIVE_HIGH>;
+		regulator-always-on;
+		enable-active-high;
+	};
+
+	regulator-usbhub-rst {
+		compatible = "regulator-fixed";
+		regulator-name = "usbhub_rst";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio3 24 GPIO_ACTIVE_HIGH>;
+		regulator-always-on;
+		enable-active-high;
+	};
+
+	regulator-uart1-mode {
+		compatible = "regulator-fixed";
+		regulator-name = "uart1_mode";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio4 26 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+		regulator-always-on;
+	};
+
+	regulator-uart1-duplex {
+		compatible = "regulator-fixed";
+		regulator-name = "uart1_duplex";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio4 27 GPIO_ACTIVE_HIGH>;
+		regulator-always-on;
+		enable-active-high;
+	};
+
+	regulator-uart1-shdn {
+		compatible = "regulator-fixed";
+		regulator-name = "uart1_shdn";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio5 5 GPIO_ACTIVE_HIGH>;
+		regulator-always-on;
+		enable-active-high;
+	};
+
+	regulator-uart1-trmen {
+		compatible = "regulator-fixed";
+		regulator-name = "uart1_trmen";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio4 25 GPIO_ACTIVE_LOW>;
+		regulator-always-on;
+		enable-active-low;
+	};
+
+	regulator-usdhc2_v {
+		compatible = "regulator-fixed";
+		regulator-name = "usdhc2_v";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio1 4 GPIO_ACTIVE_HIGH>;
+		regulator-always-on;
+		enable-active-high;
+	};
+
+	reg_usdhc2_rst: regulator-usdhc2_rst {
+		compatible = "regulator-fixed";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_reg_usdhc2_rst>;
+		regulator-name = "usdhc2_rst";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio2 19 GPIO_ACTIVE_HIGH>;
+		startup-delay-us = <100>;
+		off-on-delay-us = <12000>;
+		enable-active-high;
+	};
+
+	regulator-mpcie2_rst {
+		compatible = "regulator-fixed";
+		regulator-name = "mpcie2_rst";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio3 22 GPIO_ACTIVE_HIGH>;
+		regulator-always-on;
+		enable-active-high;
+	};
+
+	regulator-mpcie2lora_dis {
+		compatible = "regulator-fixed";
+		regulator-name = "mpcie2lora_dis";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio3 21 GPIO_ACTIVE_HIGH>;
+		regulator-always-on;
+		enable-active-high;
+	};
+
+	pcie0_refclk: pcie0-refclk {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <100000000>;
+	};
+};
+
+&ethphy0 {
+	status = "okay";
+};
+
+&fec1 {
+	status = "okay";
+};
+
+&uart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_uart1 &pinctrl_uart1_gpio>;
+	assigned-clocks = <&clk IMX8MM_CLK_UART1>;
+	assigned-clock-parents = <&clk IMX8MM_SYS_PLL1_80M>;
+	linux,rs485-enabled-at-boot-time;
+	rts-gpios = <&gpio4 24 GPIO_ACTIVE_LOW>;
+	status = "okay";
+};
+
+&uart4 {
+	status = "disabled";
+};
+
+&i2c1 {
+	clock-frequency = <100000>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_i2c1>;
+	status = "okay";
+
+	eeprom@54 {
+		compatible = "atmel,24c08";
+		reg = <0x54>;
+		pagesize = <16>;
+	};
+};
+
+&ecspi1 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	fsl,spi-num-chipselects = <1>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_ecspi1 &pinctrl_ecspi1_cs>;
+	cs-gpios = <&gpio5 9 GPIO_ACTIVE_LOW>;
+	status = "okay";
+};
+
+&usbotg1 {
+	dr_mode = "host";
+	disable-over-current;
+	status = "okay";
+};
+
+&usbotg2 {
+	dr_mode = "host";
+	disable-over-current;
+	status = "okay";
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	usb9514@1 {
+		compatible = "usb424,9514";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_usb9514>;
+		reg = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethernet: usbether@1 {
+			compatible = "usb424,ec00";
+			reg = <1>;
+		};
+	};
+};
+
+&usdhc1 {
+	status = "disabled";
+};
+
+&usdhc2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usdhc2>;
+	bus-width = <4>;
+	mmc-ddr-1_8v;
+	non-removable;
+	vmmc-supply = <&reg_usdhc2_rst>;
+	status = "okay";
+};
+
+&pcie0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_pcie0>;
+	reset-gpio = <&gpio3 20 GPIO_ACTIVE_LOW>;
+	clocks = <&clk IMX8MM_CLK_PCIE1_ROOT>,
+		 <&clk IMX8MM_CLK_PCIE1_AUX>,
+		 <&clk IMX8MM_CLK_PCIE1_PHY>,
+		 <&pcie0_refclk>;
+	clock-names = "pcie", "pcie_aux", "pcie_phy", "pcie_bus";
+	assigned-clocks = <&clk IMX8MM_CLK_PCIE1_AUX>,
+			  <&clk IMX8MM_CLK_PCIE1_PHY>,
+			  <&clk IMX8MM_CLK_PCIE1_CTRL>;
+	assigned-clock-rates = <10000000>, <100000000>, <250000000>;
+	assigned-clock-parents = <&clk IMX8MM_SYS_PLL2_50M>,
+				 <&clk IMX8MM_SYS_PLL2_100M>,
+				 <&clk IMX8MM_SYS_PLL2_250M>;
+	ext_osc = <1>;
+	status = "disabled";
+};
+
+&iomuxc {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_hog_sb_iotgimx8>;
+
+	sb-iotgimx8 {
+		pinctrl_hog_sb_iotgimx8: hoggrp_sb-iotgimx8 {
+			fsl,pins = <
+				/* mPCIe2 */
+				MX8MM_IOMUXC_SAI5_RXD0_GPIO3_IO21	0x140 /* LORA_DISABLE */
+				MX8MM_IOMUXC_SAI5_RXD1_GPIO3_IO22	0x140 /* PERSTn */
+			>;
+		};
+
+		pinctrl_uart1: uart1grp {
+			fsl,pins = <
+				MX8MM_IOMUXC_SAI2_RXC_UART1_DCE_RX	0x140
+				MX8MM_IOMUXC_SAI2_RXFS_UART1_DCE_TX	0x140
+				MX8MM_IOMUXC_SAI2_TXFS_GPIO4_IO24	0x140 /* RTS */
+				MX8MM_IOMUXC_SAI2_RXD0_UART1_DCE_RTS_B	0x140 /* CTS */
+			>;
+		};
+
+		pinctrl_uart1_gpio: uart1gpiogrp {
+			fsl,pins = <
+				MX8MM_IOMUXC_SAI2_TXD0_GPIO4_IO26	0x000 /* RS_485_232_SEL */
+				MX8MM_IOMUXC_SAI2_MCLK_GPIO4_IO27	0x140 /* RS_485_H/F_SEL */
+				MX8MM_IOMUXC_SPDIF_EXT_CLK_GPIO5_IO5	0x140 /* SHDN */
+				MX8MM_IOMUXC_SAI2_TXC_GPIO4_IO25	0x140 /* RS_485_TRMEN */
+			>;
+		};
+
+		pinctrl_i2c1: i2c1grp {
+			fsl,pins = <
+				MX8MM_IOMUXC_I2C1_SCL_I2C1_SCL		0x400001c3
+				MX8MM_IOMUXC_I2C1_SDA_I2C1_SDA		0x400001c3
+			>;
+		};
+
+		pinctrl_ecspi1: ecspi1grp {
+			fsl,pins = <
+				MX8MM_IOMUXC_ECSPI1_SCLK_ECSPI1_SCLK	0x82
+				MX8MM_IOMUXC_ECSPI1_MOSI_ECSPI1_MOSI	0x82
+				MX8MM_IOMUXC_ECSPI1_MISO_ECSPI1_MISO	0x82
+			>;
+		};
+
+		pinctrl_ecspi1_cs: ecspi1cs {
+			fsl,pins = <
+				MX8MM_IOMUXC_ECSPI1_SS0_GPIO5_IO9	0x40000
+			>;
+		};
+
+		pinctrl_usb9514: usb9514grp {
+			fsl,pins = <
+				MX8MM_IOMUXC_SAI3_RXFS_GPIO4_IO28	0x140 /* USB_PS_EN */
+				MX8MM_IOMUXC_SAI5_RXD3_GPIO3_IO24	0x140 /* HUB_RSTn */
+			>;
+		};
+
+		pinctrl_usdhc2: usdhc2grp {
+			fsl,pins = <
+				MX8MM_IOMUXC_SD2_CLK_USDHC2_CLK		0x190
+				MX8MM_IOMUXC_SD2_CMD_USDHC2_CMD		0x1d0
+				MX8MM_IOMUXC_SD2_DATA0_USDHC2_DATA0	0x1d0
+				MX8MM_IOMUXC_SD2_DATA1_USDHC2_DATA1	0x1d0
+				MX8MM_IOMUXC_SD2_DATA2_USDHC2_DATA2	0x1d0
+				MX8MM_IOMUXC_SD2_DATA3_USDHC2_DATA3	0x1d0
+				MX8MM_IOMUXC_GPIO1_IO04_GPIO1_IO4	0x1d0 /* SD2_VSEL */
+			>;
+		};
+
+		pinctrl_reg_usdhc2_rst: usdhc2rst {
+			fsl,pins = <
+				MX8MM_IOMUXC_SD2_RESET_B_GPIO2_IO19	0x41  /* EMMC_RST */
+			>;
+		};
+
+		pinctrl_pcie0: pcie0grp {
+			fsl,pins = <
+				MX8MM_IOMUXC_SAI5_RXC_GPIO3_IO20	0x140
+			>;
+		};
+	};
+};
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-compulab-ucm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-compulab-ucm.dtsi
new file mode 100644
index 000000000000..d6cdf833744e
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8mm-compulab-ucm.dtsi
@@ -0,0 +1,532 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
+/*
+ * Copyright 2018 Compulab
+ */
+
+#include "imx8mm.dtsi"
+
+/ {
+	model = "Compulab i.MX8M-Mini UCM SoM";
+	compatible = "compulab,imx8mm-ucm-som", "fsl,imx8mm";
+
+	aliases {
+		rtc0 = &rtc0;
+		rtc1 = &snvs_rtc;
+	};
+
+	leds {
+		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_gpio_led>;
+
+		heartbeat-led {
+			label = "Heartbeat";
+			gpios = <&gpio1 12 GPIO_ACTIVE_LOW>;
+			linux,default-trigger = "heartbeat";
+		};
+	};
+
+	pmic_osc: clock-pmic {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <32768>;
+		clock-output-names = "pmic_osc";
+	};
+
+	reg_ethphy: regulator-ethphy {
+		compatible = "regulator-fixed";
+		enable-active-high;
+		gpio = <&gpio1 10 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_reg_eth>;
+		regulator-always-on;
+		regulator-boot-on;
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-name = "On-module +V3.3_ETH";
+		startup-delay-us = <500>;
+	};
+
+	reg_usdhc3_vmmc: regulator-usdhc3-vmmc {
+		compatible = "regulator-fixed";
+		enable-active-high;
+		gpio = <&gpio3 16 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_reg_usdhc3>;
+		regulator-always-on;
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-name = "On-module +V3.3_USDHC";
+	};
+
+	usdhc1_pwrseq: usdhc1_pwrseq {
+		compatible = "mmc-pwrseq-simple";
+		reset-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;
+	};
+};
+
+&fec1 {
+	fsl,magic-packet;
+	fsl,rgmii_rxc_dly;
+	phy-handle = <&ethphy0>;
+	phy-mode = "rgmii-id";
+	phy-supply = <&reg_ethphy>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_fec1>;
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy0: ethernet-phy@0 {
+			compatible = "ethernet-phy-ieee802.3-c22";
+			micrel,led-mode = <0>;
+			reg = <0>;
+		};
+	};
+};
+
+&i2c2 {
+	clock-frequency = <400000>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_i2c2>;
+	status = "okay";
+
+	rtc0: rtc@69 {
+		compatible = "abracon,ab1805";
+		reg = <0x69>;
+	};
+
+	pmic: bd71837@4b {
+		compatible = "rohm,bd71837";
+		reg = <0x4b>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_pmic>;
+		clocks = <&pmic_osc>;
+		clock-names = "osc";
+		clock-output-names = "pmic_clk";
+		interrupt-parent = <&gpio1>;
+		interrupts = <3 GPIO_ACTIVE_LOW>;
+		rohm,reset-snvs-powered;
+
+		regulators {
+			buck1_reg: BUCK1 {
+				regulator-name = "buck1";
+				regulator-min-microvolt = <700000>;
+				regulator-max-microvolt = <1300000>;
+				regulator-boot-on;
+				regulator-ramp-delay = <1250>;
+				rohm,dvs-run-voltage = <900000>;
+				rohm,dvs-idle-voltage = <850000>;
+				rohm,dvs-suspend-voltage = <800000>;
+				regulator-always-on;
+			};
+
+			buck2_reg: BUCK2 {
+				regulator-name = "buck2";
+				regulator-min-microvolt = <700000>;
+				regulator-max-microvolt = <1300000>;
+				regulator-boot-on;
+				regulator-ramp-delay = <1250>;
+				rohm,dvs-run-voltage = <1000000>;
+				rohm,dvs-idle-voltage = <900000>;
+				regulator-always-on;
+			};
+
+			buck3_reg: BUCK3 {
+				regulator-name = "buck3";
+				regulator-min-microvolt = <700000>;
+				regulator-max-microvolt = <1300000>;
+				regulator-boot-on;
+				rohm,dvs-run-voltage = <900000>;
+			};
+
+			buck4_reg: BUCK4 {
+				regulator-name = "buck4";
+				regulator-min-microvolt = <700000>;
+				regulator-max-microvolt = <1300000>;
+				rohm,dvs-run-voltage = <1000000>;
+			};
+
+			buck5_reg: BUCK5 {
+				regulator-name = "buck5";
+				regulator-min-microvolt = <700000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			buck6_reg: BUCK6 {
+				regulator-name = "buck6";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			buck7_reg: BUCK7 {
+				regulator-name = "buck7";
+				regulator-min-microvolt = <1605000>;
+				regulator-max-microvolt = <1995000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			buck8_reg: BUCK8 {
+				regulator-name = "buck8";
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <1400000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo1_reg: LDO1 {
+				regulator-name = "ldo1";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
+				/* leave on for snvs power button */
+				regulator-always-on;
+			};
+
+			ldo2_reg: LDO2 {
+				regulator-name = "ldo2";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <900000>;
+				regulator-boot-on;
+				/* leave on for snvs power button */
+				regulator-always-on;
+			};
+
+			ldo3_reg: LDO3 {
+				regulator-name = "ldo3";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo4_reg: LDO4 {
+				regulator-name = "ldo4";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo5_reg: LDO5 {
+				/* VDD_PHY_0V9 - MIPI and HDMI domains */
+				regulator-name = "ldo5";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-always-on;
+			};
+
+			ldo6_reg: LDO6 {
+				/* VDD_PHY_0V9 - MIPI, HDMI and USB domains */
+				regulator-name = "ldo6";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo7_reg: LDO7 {
+				/* VDD_PHY_3V3 - USB domain */
+				regulator-name = "ldo7";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+		};
+	};
+
+	eeprom@50 {
+		compatible = "atmel,24c08";
+		reg = <0x50>;
+		pagesize = <16>;
+	};
+};
+
+&snvs {
+	status = "okay";
+};
+
+&snvs_pwrkey {
+	status = "okay";
+};
+
+/* console */
+&uart3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_uart3>;
+	status = "okay";
+};
+
+/* bluetooth */
+&uart4 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_uart4>;
+	assigned-clocks = <&clk IMX8MM_CLK_UART4>;
+	assigned-clock-parents = <&clk IMX8MM_SYS_PLL1_80M>;
+	uart-has-rtscts;
+
+	bluetooth {
+		compatible = "brcm,bcm4330-bt";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_bt>;
+		max-speed = <3000000>;
+		device-wakeup-gpios = <&gpio2 7 GPIO_ACTIVE_HIGH>;
+		host-wakeup-gpios = <&gpio2 8 GPIO_ACTIVE_HIGH>;
+		shutdown-gpios = <&gpio2 6 GPIO_ACTIVE_HIGH>;
+	};
+};
+
+&usdhc1 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	pinctrl-names = "default", "state_100mhz", "state_200mhz";
+	pinctrl-0 = <&pinctrl_usdhc1>, <&pinctrl_usdhc1_gpio>;
+	pinctrl-1 = <&pinctrl_usdhc1_100mhz>, <&pinctrl_usdhc1_gpio>;
+	pinctrl-2 = <&pinctrl_usdhc1_200mhz>, <&pinctrl_usdhc1_gpio>;
+	bus-width = <4>;
+	non-removable;
+	wifi-host;
+	pm-ignore-notify;
+	cap-power-off-card;
+	mmc-pwrseq = <&usdhc1_pwrseq>;
+
+	brcmf: wifi@1 {
+		compatible = "brcm,bcm4329-fmac";
+		reg = <1>;
+		interrupt-parent = <&gpio2>;
+		interrupts = <9 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "host-wake";
+	};
+};
+
+&usdhc3 {
+	pinctrl-names = "default", "state_100mhz", "state_200mhz";
+	pinctrl-0 = <&pinctrl_usdhc3>;
+	pinctrl-1 = <&pinctrl_usdhc3_100mhz>;
+	pinctrl-2 = <&pinctrl_usdhc3_200mhz>;
+	bus-width = <8>;
+	non-removable;
+	no-sd;
+	no-sdio;
+	no-1-8-v;
+	vmmc-supply = <&reg_usdhc3_vmmc>;
+	status = "okay";
+};
+
+&usbotg2 {
+	dr_mode = "host";
+	hnp-disable;
+	srp-disable;
+	disable-over-current;
+	status = "okay";
+};
+
+&wdog1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_wdog>;
+	fsl,ext-reset-output;
+	status = "okay";
+};
+
+&cpu_alert0 {
+	temperature = <105000>;
+};
+
+&cpu_crit0 {
+	temperature = <115000>;
+};
+
+&A53_0 {
+	cpu-supply = <&buck2_reg>;
+};
+
+&iomuxc {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_hog_1>;
+
+	ucm-imx8m-mini {
+		pinctrl_hog_1: hoggrp-1 {
+			fsl,pins = <
+				MX8MM_IOMUXC_GPIO1_IO10_GPIO1_IO10	0x19
+				MX8MM_IOMUXC_NAND_READY_B_GPIO3_IO16	0x190
+			>;
+		};
+
+		pinctrl_fec1: fec1grp {
+			fsl,pins = <
+				MX8MM_IOMUXC_ENET_MDC_ENET1_MDC		0x3
+				MX8MM_IOMUXC_ENET_MDIO_ENET1_MDIO	0x3
+				MX8MM_IOMUXC_ENET_TD3_ENET1_RGMII_TD3	0x1f
+				MX8MM_IOMUXC_ENET_TD2_ENET1_RGMII_TD2	0x1f
+				MX8MM_IOMUXC_ENET_TD1_ENET1_RGMII_TD1	0x1f
+				MX8MM_IOMUXC_ENET_TD0_ENET1_RGMII_TD0	0x1f
+				MX8MM_IOMUXC_ENET_RD3_ENET1_RGMII_RD3	0x91
+				MX8MM_IOMUXC_ENET_RD2_ENET1_RGMII_RD2	0x91
+				MX8MM_IOMUXC_ENET_RD1_ENET1_RGMII_RD1	0x91
+				MX8MM_IOMUXC_ENET_RD0_ENET1_RGMII_RD0	0x91
+				MX8MM_IOMUXC_ENET_TXC_ENET1_RGMII_TXC	0x1f
+				MX8MM_IOMUXC_ENET_RXC_ENET1_RGMII_RXC	0x91
+				MX8MM_IOMUXC_ENET_RX_CTL_ENET1_RGMII_RX_CTL	0x91
+				MX8MM_IOMUXC_ENET_TX_CTL_ENET1_RGMII_TX_CTL	0x1f
+			>;
+		};
+
+		pinctrl_gpio_led: gpioledgrp {
+			fsl,pins = <
+				MX8MM_IOMUXC_GPIO1_IO12_GPIO1_IO12	0x19
+			>;
+		};
+
+		pinctrl_i2c2: i2c2grp {
+			fsl,pins = <
+				MX8MM_IOMUXC_I2C2_SCL_I2C2_SCL			0x400001c3
+				MX8MM_IOMUXC_I2C2_SDA_I2C2_SDA			0x400001c3
+			>;
+		};
+
+		pinctrl_pmic: pmicirq {
+			fsl,pins = <
+				MX8MM_IOMUXC_GPIO1_IO03_GPIO1_IO3		0x41
+			>;
+		};
+
+		pinctrl_reg_usdhc3: regusdhcgrp {
+			fsl,pins =
+				<MX8MM_IOMUXC_NAND_READY_B_GPIO3_IO16		0x146>;
+		};
+
+		pinctrl_reg_eth: regethgrp {
+			fsl,pins =
+				<MX8MM_IOMUXC_SD2_WP_GPIO2_IO20			0x146>;
+		};
+
+		pinctrl_uart3: uart3grp {
+			fsl,pins = <
+				MX8MM_IOMUXC_UART3_RXD_UART3_DCE_RX	0x49
+				MX8MM_IOMUXC_UART3_TXD_UART3_DCE_TX	0x49
+			>;
+		};
+
+		pinctrl_uart4: uart4grp {
+			fsl,pins = <
+				MX8MM_IOMUXC_ECSPI2_MISO_UART4_DCE_CTS_B 0x140
+				MX8MM_IOMUXC_ECSPI2_MOSI_UART4_DCE_TX    0x140
+				MX8MM_IOMUXC_ECSPI2_SS0_UART4_DCE_RTS_B  0x140
+				MX8MM_IOMUXC_ECSPI2_SCLK_UART4_DCE_RX    0x140
+			>;
+		};
+
+		pinctrl_usdhc1_gpio: usdhc1grpgpio {
+			fsl,pins = <
+				MX8MM_IOMUXC_SD1_RESET_B_GPIO2_IO10	0x41
+			>;
+		};
+
+		pinctrl_usdhc1: usdhc1grp {
+			fsl,pins = <
+				MX8MM_IOMUXC_SD1_CLK_USDHC1_CLK		0x190
+				MX8MM_IOMUXC_SD1_CMD_USDHC1_CMD		0x1d0
+				MX8MM_IOMUXC_SD1_DATA0_USDHC1_DATA0	0x1d0
+				MX8MM_IOMUXC_SD1_DATA1_USDHC1_DATA1	0x1d0
+				MX8MM_IOMUXC_SD1_DATA2_USDHC1_DATA2	0x1d0
+				MX8MM_IOMUXC_SD1_DATA3_USDHC1_DATA3	0x1d0
+				MX8MM_IOMUXC_GPIO1_IO03_USDHC1_VSELECT	0x1d0
+			>;
+		};
+
+		pinctrl_usdhc1_100mhz: usdhc1grp100mhz {
+			fsl,pins = <
+				MX8MM_IOMUXC_SD1_CLK_USDHC1_CLK		0x194
+				MX8MM_IOMUXC_SD1_CMD_USDHC1_CMD		0x1d4
+				MX8MM_IOMUXC_SD1_DATA0_USDHC1_DATA0	0x1d4
+				MX8MM_IOMUXC_SD1_DATA1_USDHC1_DATA1	0x1d4
+				MX8MM_IOMUXC_SD1_DATA2_USDHC1_DATA2	0x1d4
+				MX8MM_IOMUXC_SD1_DATA3_USDHC1_DATA3	0x1d4
+				MX8MM_IOMUXC_GPIO1_IO03_USDHC1_VSELECT	0x1d0
+			>;
+		};
+
+		pinctrl_usdhc1_200mhz: usdhc1grp200mhz {
+			fsl,pins = <
+				MX8MM_IOMUXC_SD1_CLK_USDHC1_CLK		0x196
+				MX8MM_IOMUXC_SD1_CMD_USDHC1_CMD		0x1d6
+				MX8MM_IOMUXC_SD1_DATA0_USDHC1_DATA0	0x1d6
+				MX8MM_IOMUXC_SD1_DATA1_USDHC1_DATA1	0x1d6
+				MX8MM_IOMUXC_SD1_DATA2_USDHC1_DATA2	0x1d6
+				MX8MM_IOMUXC_SD1_DATA3_USDHC1_DATA3	0x1d6
+				MX8MM_IOMUXC_GPIO1_IO03_USDHC1_VSELECT	0x1d0
+			>;
+		};
+
+
+
+		pinctrl_usdhc3: usdhc3grp {
+			fsl,pins = <
+				MX8MM_IOMUXC_NAND_WE_B_USDHC3_CLK		0x40000190
+				MX8MM_IOMUXC_NAND_WP_B_USDHC3_CMD		0x1d0
+				MX8MM_IOMUXC_NAND_DATA04_USDHC3_DATA0		0x1d0
+				MX8MM_IOMUXC_NAND_DATA05_USDHC3_DATA1		0x1d0
+				MX8MM_IOMUXC_NAND_DATA06_USDHC3_DATA2		0x1d0
+				MX8MM_IOMUXC_NAND_DATA07_USDHC3_DATA3		0x1d0
+				MX8MM_IOMUXC_NAND_RE_B_USDHC3_DATA4		0x1d0
+				MX8MM_IOMUXC_NAND_CE2_B_USDHC3_DATA5		0x1d0
+				MX8MM_IOMUXC_NAND_CE3_B_USDHC3_DATA6		0x1d0
+				MX8MM_IOMUXC_NAND_CLE_USDHC3_DATA7		0x1d0
+				MX8MM_IOMUXC_NAND_CE1_B_USDHC3_STROBE		0x190
+			>;
+		};
+
+		pinctrl_usdhc3_100mhz: usdhc3grp100mhz {
+			fsl,pins = <
+				MX8MM_IOMUXC_NAND_WE_B_USDHC3_CLK		0x40000194
+				MX8MM_IOMUXC_NAND_WP_B_USDHC3_CMD		0x1d4
+				MX8MM_IOMUXC_NAND_DATA04_USDHC3_DATA0		0x1d4
+				MX8MM_IOMUXC_NAND_DATA05_USDHC3_DATA1		0x1d4
+				MX8MM_IOMUXC_NAND_DATA06_USDHC3_DATA2		0x1d4
+				MX8MM_IOMUXC_NAND_DATA07_USDHC3_DATA3		0x1d4
+				MX8MM_IOMUXC_NAND_RE_B_USDHC3_DATA4		0x1d4
+				MX8MM_IOMUXC_NAND_CE2_B_USDHC3_DATA5		0x1d4
+				MX8MM_IOMUXC_NAND_CE3_B_USDHC3_DATA6		0x1d4
+				MX8MM_IOMUXC_NAND_CLE_USDHC3_DATA7		0x1d4
+				MX8MM_IOMUXC_NAND_CE1_B_USDHC3_STROBE		0x194
+			>;
+		};
+
+		pinctrl_usdhc3_200mhz: usdhc3grp200mhz {
+			fsl,pins = <
+				MX8MM_IOMUXC_NAND_WE_B_USDHC3_CLK		0x40000196
+				MX8MM_IOMUXC_NAND_WP_B_USDHC3_CMD		0x1d6
+				MX8MM_IOMUXC_NAND_DATA04_USDHC3_DATA0		0x1d6
+				MX8MM_IOMUXC_NAND_DATA05_USDHC3_DATA1		0x1d6
+				MX8MM_IOMUXC_NAND_DATA06_USDHC3_DATA2		0x1d6
+				MX8MM_IOMUXC_NAND_DATA07_USDHC3_DATA3		0x1d6
+				MX8MM_IOMUXC_NAND_RE_B_USDHC3_DATA4		0x1d6
+				MX8MM_IOMUXC_NAND_CE2_B_USDHC3_DATA5		0x1d6
+				MX8MM_IOMUXC_NAND_CE3_B_USDHC3_DATA6		0x1d6
+				MX8MM_IOMUXC_NAND_CLE_USDHC3_DATA7		0x1d6
+				MX8MM_IOMUXC_NAND_CE1_B_USDHC3_STROBE		0x196
+			>;
+		};
+
+		pinctrl_wdog: wdoggrp {
+			fsl,pins = <
+				MX8MM_IOMUXC_GPIO1_IO02_WDOG1_WDOG_B		0xc6
+			>;
+		};
+
+		pinctrl_bt: bt0grp {
+			fsl,pins = <
+				MX8MM_IOMUXC_SD1_DATA4_GPIO2_IO6	0x19 /* BT_REG_ON */
+				MX8MM_IOMUXC_SD1_DATA5_GPIO2_IO7	0x19 /* BT_DEV_WU */
+				MX8MM_IOMUXC_SD1_DATA6_GPIO2_IO8	0x19 /* BT_HST_WU */
+			>;
+		};
+	};
+};
-- 
2.34.1


