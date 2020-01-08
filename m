Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09050134317
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 13:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgAHM6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 07:58:31 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:35721 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgAHM63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 07:58:29 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Claudiu.Beznea@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="Claudiu.Beznea@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Claudiu.Beznea@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: q/E3kw/EzLjYxWS0VnS7w8yoChcyhd/TXbdDWRkOr/Qtzn7V14oMO1iWukrwSjgo9B2U2UsMbb
 Fcn4KUOQBGE23yms+vm5Xb+3mJLuyAhT/g5D3dLHVE32K0ilSonHYUdlmFGaHd1MpTH6hnOvoM
 N8vR76QR37KcKhTsZTMp9SLlkPUydLis9qRNX6/H4gJ1bMZ8LFNKBn/TkzFDzJ6U5G8i3UcXws
 lwztxR99DWH+J5tckfTRA5vdVSnlGkAExwRQfep/Zd2zQHdQTZsO12iOUAewAbiACZi9Wx5KKS
 TZU=
X-IronPort-AV: E=Sophos;i="5.69,410,1571727600"; 
   d="scan'208";a="62569424"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jan 2020 05:58:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jan 2020 05:58:06 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.85.251) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 8 Jan 2020 05:57:59 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <vkoul@kernel.org>,
        <eugen.hristev@microchip.com>, <jic23@kernel.org>,
        <knaack.h@gmx.de>, <lars@metafoo.de>, <pmeerw@pmeerw.net>,
        <mchehab@kernel.org>, <lee.jones@linaro.org>,
        <richard.genoud@gmail.com>, <radu_nicolae.pirea@upb.ro>,
        <tudor.ambarus@microchip.com>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <a.zummo@towertech.it>, <broonie@kernel.org>
CC:     <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rtc@vger.kernel.org>,
        Sandeep Sheriker Mallikarjun 
        <sandeepsheriker.mallikarjun@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Subject: [PATCH 16/16] ARM: dts: at91: sam9x60: add device tree for soc and board
Date:   Wed, 8 Jan 2020 14:55:23 +0200
Message-ID: <1578488123-26127-17-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578488123-26127-1-git-send-email-claudiu.beznea@microchip.com>
References: <1578488123-26127-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sandeep Sheriker Mallikarjun <sandeepsheriker.mallikarjun@microchip.com>

Add device tree files for SAM9X60 SoC and SAM9X60-EK board.

Signed-off-by: Sandeep Sheriker Mallikarjun <sandeepsheriker.mallikarjun@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---
 arch/arm/boot/dts/Makefile           |   2 +
 arch/arm/boot/dts/at91-sam9x60ek.dts | 647 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/sam9x60.dtsi       | 691 +++++++++++++++++++++++++++++++++++
 3 files changed, 1340 insertions(+)
 create mode 100644 arch/arm/boot/dts/at91-sam9x60ek.dts
 create mode 100644 arch/arm/boot/dts/sam9x60.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 08011dc8c7a6..36e90f07be13 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -44,6 +44,8 @@ dtb-$(CONFIG_SOC_AT91SAM9) += \
 	at91sam9g35ek.dtb \
 	at91sam9x25ek.dtb \
 	at91sam9x35ek.dtb
+dtb-$(CONFIG_SOC_SAM9X60) += \
+	at91-sam9x60ek.dtb
 dtb-$(CONFIG_SOC_SAM_V7) += \
 	at91-kizbox2-2.dtb \
 	at91-kizbox3-hs.dtb \
diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
new file mode 100644
index 000000000000..9f30132d7d7b
--- /dev/null
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -0,0 +1,647 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
+/*
+ * at91-sam9x60ek.dts - Device Tree file for Microchip SAM9X60-EK board
+ *
+ * Copyright (C) 2019 Microchip Technology Inc. and its subsidiaries
+ *
+ * Author: Sandeep Sheriker M <sandeepsheriker.mallikarjun@microchip.com>
+ */
+/dts-v1/;
+#include "sam9x60.dtsi"
+
+/ {
+	model = "Microchip SAM9X60-EK";
+	compatible = "microchip,sam9x60ek", "microchip,sam9x60", "atmel,at91sam9";
+
+	aliases {
+		i2c0 = &i2c0;
+		i2c1 = &i2c1;
+		serial1 = &uart1;
+	};
+
+	chosen {
+		stdout-path = "serial0:115200n8";
+	};
+
+	clocks {
+		slow_xtal {
+			clock-frequency = <32768>;
+		};
+
+		main_xtal {
+			clock-frequency = <24000000>;
+		};
+	};
+
+	regulators: regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vdd_1v8: fixed-regulator-vdd_1v8@0 {
+			compatible = "regulator-fixed";
+			regulator-name = "VDD_1V8";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+			status = "okay";
+		};
+
+		vdd_1v5: fixed-regulator-vdd_1v5@1 {
+			compatible = "regulator-fixed";
+			regulator-name = "VDD_1V5";
+			regulator-min-microvolt = <1500000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-always-on;
+			status = "okay";
+		};
+
+		vdd1_3v3: fixed-regulator-vdd1_3v3@2 {
+			compatible = "regulator-fixed";
+			regulator-name = "VDD1_3V3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+			status = "okay";
+		};
+
+		vdd2_3v3: regulator-fixed-vdd2_3v3@3 {
+			compatible = "regulator-fixed";
+			regulator-name = "VDD2_3V3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+			status = "okay";
+		};
+	};
+
+	gpio_keys {
+		compatible = "gpio-keys";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_key_gpio_default>;
+		status = "okay";
+
+		sw1 {
+			label = "SW1";
+			gpios = <&pioD 18 GPIO_ACTIVE_LOW>;
+			linux,code=<0x104>;
+			wakeup-source;
+		};
+	};
+
+	leds {
+		compatible = "gpio-leds";
+		status = "okay"; /* Conflict with pwm0. */
+
+		red {
+			label = "red";
+			gpios = <&pioB 11 GPIO_ACTIVE_HIGH>;
+		};
+
+		green {
+			label = "green";
+			gpios = <&pioB 12 GPIO_ACTIVE_HIGH>;
+		};
+
+		blue {
+			label = "blue";
+			gpios = <&pioB 13 GPIO_ACTIVE_HIGH>;
+			linux,default-trigger = "heartbeat";
+		};
+	};
+};
+
+&adc {
+	vddana-supply = <&vdd1_3v3>;
+	vref-supply = <&vdd1_3v3>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_adc_default &pinctrl_adtrg_default>;
+	status = "okay";
+};
+
+&can0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_can0_rx_tx>;
+	status = "disabled"; /* Conflict with dbgu. */
+};
+
+&can1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_can1_rx_tx>;
+	status = "okay";
+};
+
+&classd {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_classd_default>;
+	atmel,pwm-type = "diff";
+	atmel,non-overlap-time = <10>;
+	status = "okay";
+};
+
+&dbgu {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_dbgu>;
+	status = "okay"; /* Conflict with can0. */
+};
+
+&ebi {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_ebi_addr_nand &pinctrl_ebi_data_0_7>;
+	status = "okay";
+
+	nand_controller: nand-controller {
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_nand_oe_we &pinctrl_nand_cs &pinctrl_nand_rb>;
+		status = "okay";
+
+		nand@3 {
+			reg = <0x3 0x0 0x800000>;
+			rb-gpios = <&pioD 5 GPIO_ACTIVE_HIGH>;
+			cs-gpios = <&pioD 4 GPIO_ACTIVE_HIGH>;
+			nand-bus-width = <8>;
+			nand-ecc-mode = "hw";
+			nand-ecc-strength = <8>;
+			nand-ecc-step-size = <512>;
+			nand-on-flash-bbt;
+			label = "atmel_nand";
+
+			partitions {
+				compatible = "fixed-partitions";
+				#address-cells = <1>;
+				#size-cells = <1>;
+
+				at91bootstrap@0 {
+					label = "at91bootstrap";
+					reg = <0x0 0x40000>;
+				};
+
+				uboot@40000 {
+					label = "u-boot";
+					reg = <0x40000 0xc0000>;
+				};
+
+				ubootenvred@100000 {
+					label = "U-Boot Env Redundant";
+					reg = <0x100000 0x40000>;
+				};
+
+				ubootenv@140000 {
+					label = "U-Boot Env";
+					reg = <0x140000 0x40000>;
+				};
+
+				dtb@180000 {
+					label = "device tree";
+					reg = <0x180000 0x80000>;
+				};
+
+				kernel@200000 {
+					label = "kernel";
+					reg = <0x200000 0x600000>;
+				};
+
+				rootfs@800000 {
+					label = "rootfs";
+					reg = <0x800000 0x1f800000>;
+				};
+			};
+		};
+	};
+};
+
+&flx0 {
+	atmel,flexcom-mode = <ATMEL_FLEXCOM_MODE_TWI>;
+	status = "okay";
+
+	i2c0: i2c@600 {
+		compatible = "microchip,sam9x60-i2c";
+		reg = <0x600 0x200>;
+		interrupts = <5 IRQ_TYPE_LEVEL_HIGH 7>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&pmc PMC_TYPE_PERIPHERAL 5>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_flx0_default>;
+		atmel,fifo-size = <16>;
+		i2c-analog-filter;
+		i2c-digital-filter;
+		i2c-digital-filter-width-ns = <35>;
+		status = "okay";
+
+		eeprom@53 {
+			compatible = "atmel,24c32";
+			reg = <0x53>;
+			pagesize = <16>;
+			size = <128>;
+			status = "okay";
+		};
+	};
+};
+
+&flx4 {
+	atmel,flexcom-mode = <ATMEL_FLEXCOM_MODE_SPI>;
+	status = "disabled";
+
+	spi0: spi@400 {
+		compatible = "microchip,sam9x60-spi", "atmel,at91rm9200-spi";
+		reg = <0x400 0x200>;
+		interrupts = <13 IRQ_TYPE_LEVEL_HIGH 7>;
+		clocks = <&pmc PMC_TYPE_PERIPHERAL 13>;
+		clock-names = "spi_clk";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_flx4_default>;
+		atmel,fifo-size = <16>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+};
+
+&flx5 {
+	atmel,flexcom-mode = <ATMEL_FLEXCOM_MODE_USART>;
+	status = "okay";
+
+	uart1: serial@200 {
+		compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
+		reg = <0x200 0x200>;
+		interrupts = <14 IRQ_TYPE_LEVEL_HIGH 7>;
+		dmas = <&dma0
+			(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+			 AT91_XDMAC_DT_PERID(10))>,
+		       <&dma0
+			(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+			 AT91_XDMAC_DT_PERID(11))>;
+		dma-names = "tx", "rx";
+		clocks = <&pmc PMC_TYPE_PERIPHERAL 14>;
+		clock-names = "usart";
+		pinctrl-0 = <&pinctrl_flx5_default>;
+		pinctrl-names = "default";
+		atmel,use-dma-rx;
+		atmel,use-dma-tx;
+		status = "okay";
+	};
+};
+
+&flx6 {
+	atmel,flexcom-mode = <ATMEL_FLEXCOM_MODE_TWI>;
+	status = "okay";
+
+	i2c1: i2c@600 {
+		compatible = "microchip,sam9x60-i2c";
+		reg = <0x600 0x200>;
+		interrupts = <9 IRQ_TYPE_LEVEL_HIGH 7>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&pmc PMC_TYPE_PERIPHERAL 9>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_flx6_default>;
+		atmel,fifo-size = <16>;
+		i2c-analog-filter;
+		i2c-digital-filter;
+		i2c-digital-filter-width-ns = <35>;
+		status = "okay";
+
+		gpio_exp: mcp23008@20 {
+			compatible = "microchip,mcp23008";
+			reg = <0x20>;
+		};
+	};
+};
+
+&i2s {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_i2s_default>;
+	#sound-dai-cells = <0>;
+	status = "disabled"; /* Conflict with QSPI. */
+};
+
+&macb0 {
+	phy-mode = "rmii";
+	#address-cells = <1>;
+	#size-cells = <0>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_macb0_rmii>;
+	status = "okay";
+
+	ethernet-phy@0 {
+		reg = <0x0>;
+	};
+};
+
+&pinctrl {
+	atmel,mux-mask = <
+			 /*	A	B	C	*/
+			 0xFFFFFE7F 0xC0E0397F 0xEF00019D	/* pioA */
+			 0x03FFFFFF 0x02FC7E68 0x00780000	/* pioB */
+			 0xffffffff 0xF83FFFFF 0xB800F3FC	/* pioC */
+			 0x003FFFFF 0x003F8000 0x00000000	/* pioD */
+			 >;
+
+	adc {
+		pinctrl_adc_default: adc_default {
+			atmel,pins = <AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+		};
+
+		pinctrl_adtrg_default: adtrg_default {
+			atmel,pins = <AT91_PIOB 18 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;
+		};
+	};
+
+	dbgu {
+		pinctrl_dbgu: dbgu-0 {
+			atmel,pins = <AT91_PIOA 9 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
+				      AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+		};
+	};
+
+	i2s {
+		pinctrl_i2s_default: i2s {
+			atmel,pins =
+				<AT91_PIOB 19 AT91_PERIPH_B AT91_PINCTRL_NONE		/* I2SCK */
+				 AT91_PIOB 20 AT91_PERIPH_B AT91_PINCTRL_NONE		/* I2SWS */
+				 AT91_PIOB 21 AT91_PERIPH_B AT91_PINCTRL_NONE		/* I2SDIN */
+				 AT91_PIOB 22 AT91_PERIPH_B AT91_PINCTRL_NONE		/* I2SDOUT */
+				 AT91_PIOB 23 AT91_PERIPH_B AT91_PINCTRL_NONE>;		/* I2SMCK */
+		};
+	};
+
+	qspi {
+		pinctrl_qspi: qspi {
+			atmel,pins =
+				<AT91_PIOB 19 AT91_PERIPH_A AT91_PINCTRL_SLEWRATE_DIS
+				 AT91_PIOB 20 AT91_PERIPH_A AT91_PINCTRL_SLEWRATE_DIS
+				 AT91_PIOB 21 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_SLEWRATE_DIS)
+				 AT91_PIOB 22 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_SLEWRATE_DIS)
+				 AT91_PIOB 23 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_SLEWRATE_DIS)
+				 AT91_PIOB 24 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_SLEWRATE_DIS)>;
+		};
+	};
+
+	nand {
+		pinctrl_nand_oe_we: nand-oe-we-0 {
+			atmel,pins =
+				<AT91_PIOD 0 AT91_PERIPH_A (AT91_PINCTRL_NONE | AT91_PINCTRL_SLEWRATE_DIS)
+				 AT91_PIOD 1 AT91_PERIPH_A (AT91_PINCTRL_NONE | AT91_PINCTRL_SLEWRATE_DIS)>;
+		};
+
+		pinctrl_nand_rb: nand-rb-0 {
+			atmel,pins =
+				<AT91_PIOD 5 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP>;
+		};
+
+		pinctrl_nand_cs: nand-cs-0 {
+			atmel,pins =
+				<AT91_PIOD 4 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP>;
+		};
+	};
+
+	ebi {
+		pinctrl_ebi_data_0_7: ebi-data-lsb-0 {
+			atmel,pins =
+				<AT91_PIOD 6 AT91_PERIPH_A (AT91_PINCTRL_NONE | AT91_PINCTRL_SLEWRATE_DIS)
+				 AT91_PIOD 7 AT91_PERIPH_A (AT91_PINCTRL_NONE | AT91_PINCTRL_SLEWRATE_DIS)
+				 AT91_PIOD 8 AT91_PERIPH_A (AT91_PINCTRL_NONE | AT91_PINCTRL_SLEWRATE_DIS)
+				 AT91_PIOD 9 AT91_PERIPH_A (AT91_PINCTRL_NONE | AT91_PINCTRL_SLEWRATE_DIS)
+				 AT91_PIOD 10 AT91_PERIPH_A (AT91_PINCTRL_NONE | AT91_PINCTRL_SLEWRATE_DIS)
+				 AT91_PIOD 11 AT91_PERIPH_A (AT91_PINCTRL_NONE | AT91_PINCTRL_SLEWRATE_DIS)
+				 AT91_PIOD 12 AT91_PERIPH_A (AT91_PINCTRL_NONE | AT91_PINCTRL_SLEWRATE_DIS)
+				 AT91_PIOD 13 AT91_PERIPH_A (AT91_PINCTRL_NONE | AT91_PINCTRL_SLEWRATE_DIS)>;
+		};
+
+		pinctrl_ebi_data_0_15: ebi-data-msb-0 {
+			atmel,pins =
+				<AT91_PIOD 6 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 7 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 8 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 9 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 10 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 11 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 12 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 13 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 14 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 15 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 16 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 17 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 18 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 19 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 20 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOD 21 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+		};
+
+		pinctrl_ebi_addr_nand: ebi-addr-0 {
+			atmel,pins =
+				<AT91_PIOD 2 AT91_PERIPH_A (AT91_PINCTRL_NONE | AT91_PINCTRL_SLEWRATE_DIS)
+				 AT91_PIOD 3 AT91_PERIPH_A (AT91_PINCTRL_NONE | AT91_PINCTRL_SLEWRATE_DIS)>;
+		};
+	};
+
+	flexcom {
+		pinctrl_flx0_default: flx0_twi {
+			atmel,pins =
+				<AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
+				 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
+		};
+
+		pinctrl_flx4_default: flx4_spi {
+			atmel,pins =
+				<AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOA 12 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE
+				 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+		};
+
+		pinctrl_flx5_default: flx_uart {
+			atmel,pins =
+				<AT91_PIOA 7 AT91_PERIPH_C AT91_PINCTRL_NONE
+				 AT91_PIOA 8 AT91_PERIPH_B AT91_PINCTRL_NONE
+				 AT91_PIOA 21 AT91_PERIPH_B AT91_PINCTRL_NONE
+				 AT91_PIOA 22 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+		};
+
+		pinctrl_flx6_default: flx6_twi {
+			atmel,pins =
+				<AT91_PIOA 30 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
+				 AT91_PIOA 31 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
+		};
+	};
+
+	classd {
+		pinctrl_classd_default: classd {
+			atmel,pins =
+				<AT91_PIOA 24 AT91_PERIPH_C AT91_PINCTRL_PULL_UP
+				 AT91_PIOA 25 AT91_PERIPH_C AT91_PINCTRL_PULL_UP
+				 AT91_PIOA 26 AT91_PERIPH_C AT91_PINCTRL_PULL_UP
+				 AT91_PIOA 27 AT91_PERIPH_C AT91_PINCTRL_PULL_UP>;
+		};
+	};
+
+	can0 {
+		pinctrl_can0_rx_tx: can0_rx_tx {
+			atmel,pins =
+				<AT91_PIOA 9 AT91_PERIPH_B AT91_PINCTRL_NONE	/* CANRX0 */
+				 AT91_PIOA 10 AT91_PERIPH_B AT91_PINCTRL_NONE	/* CANTX0 */
+				 AT91_PIOD 20 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_DOWN	/* Enable CAN0 mux */
+				 AT91_PIOD 21 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_DOWN>;	/* Enable CAN Transceivers */
+		};
+	};
+
+	can1 {
+		pinctrl_can1_rx_tx: can1_rx_tx {
+			atmel,pins =
+				<AT91_PIOA 6 AT91_PERIPH_B AT91_PINCTRL_NONE	/* CANRX1 RXD1 */
+				 AT91_PIOA 5 AT91_PERIPH_B AT91_PINCTRL_NONE	/* CANTX1 TXD1 */
+				 AT91_PIOD 19 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_DOWN	/* Enable CAN1 mux */
+				 AT91_PIOD 21 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_DOWN>;	/* Enable CAN Transceivers */
+		};
+	};
+
+	macb0 {
+		pinctrl_macb0_rmii: macb0_rmii-0 {
+			atmel,pins =
+				<AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB0 periph A */
+				 AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB1 periph A */
+				 AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB2 periph A */
+				 AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB3 periph A */
+				 AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB4 periph A */
+				 AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB5 periph A */
+				 AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB6 periph A */
+				 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB7 periph A */
+				 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A */
+				 AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB10 periph A */
+		};
+	};
+
+	pwm0 {
+		pinctrl_pwm0_0: pwm0_0 {
+			atmel,pins = <AT91_PIOB 11 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+		};
+
+		pinctrl_pwm0_1: pwm0_1 {
+			atmel,pins = <AT91_PIOB 12 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+		};
+
+		pinctrl_pwm0_2: pwm0_2 {
+			atmel,pins = <AT91_PIOB 13 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+		};
+
+		pinctrl_pwm0_3: pwm0_3 {
+			atmel,pins = <AT91_PIOB 14 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+		};
+	};
+
+	sdmmc0 {
+		pinctrl_sdmmc0_default: sdmmc0 {
+			atmel,pins =
+				<AT91_PIOA 17 AT91_PERIPH_A (AT91_PINCTRL_DRIVE_STRENGTH_HI)				/* PA17 CK  periph A with pullup */
+				 AT91_PIOA 16 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_DRIVE_STRENGTH_HI)	/* PA16 CMD periph A with pullup */
+				 AT91_PIOA 15 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_DRIVE_STRENGTH_HI)	/* PA15 DAT0 periph A */
+				 AT91_PIOA 18 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_DRIVE_STRENGTH_HI)	/* PA18 DAT1 periph A with pullup */
+				 AT91_PIOA 19 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_DRIVE_STRENGTH_HI)	/* PA19 DAT2 periph A with pullup */
+				 AT91_PIOA 20 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_DRIVE_STRENGTH_HI)>;	/* PA20 DAT3 periph A with pullup */
+		};
+	};
+
+	gpio_keys {
+		pinctrl_key_gpio_default: pinctrl_key_gpio {
+			atmel,pins = <AT91_PIOD 18 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+		};
+	};
+}; /* pinctrl */
+
+&pmc {
+	atmel,osc-bypass;
+};
+
+&pwm0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_pwm0_0 &pinctrl_pwm0_1 &pinctrl_pwm0_2 &pinctrl_pwm0_3>;
+	status = "disabled"; /* Conflict with leds. */
+};
+
+&sdmmc0 {
+	bus-width = <4>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_sdmmc0_default>;
+	status = "okay";
+	cd-gpios = <&pioA 23 GPIO_ACTIVE_LOW>;
+	disable-wp;
+};
+
+&qspi {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_qspi>;
+	status = "okay"; /* Conflict with i2s. */
+
+	flash@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "jedec,spi-nor";
+		reg = <0>;
+		spi-max-frequency = <80000000>;
+		m25p,fast-read;
+
+		at91bootstrap@0 {
+			label = "qspi: at91bootstrap";
+			reg = <0x0 0x40000>;
+		};
+
+		bootloader@40000 {
+			label = "qspi: bootloader";
+			reg = <0x40000 0xc0000>;
+		};
+
+		bootloaderenvred@100000 {
+			label = "qspi: bootloader env redundant";
+			reg = <0x100000 0x40000>;
+		};
+
+		bootloaderenv@140000 {
+			label = "qspi: bootloader env";
+			reg = <0x140000 0x40000>;
+		};
+
+		dtb@180000 {
+			label = "qspi: device tree";
+			reg = <0x180000 0x80000>;
+		};
+
+		kernel@200000 {
+			label = "qspi: kernel";
+			reg = <0x200000 0x600000>;
+		};
+	};
+};
+
+&shutdown_controller {
+	atmel,shdwc-debouncer = <976>;
+	status = "okay";
+
+	input@0 {
+		reg = <0>;
+	};
+};
+
+&tcb0 {
+	timer0: timer@0 {
+		compatible = "atmel,tcb-timer";
+		reg = <0>;
+	};
+
+	timer1: timer@1 {
+		compatible = "atmel,tcb-timer";
+		reg = <1>;
+	};
+};
+
+&usb1 {
+	num-ports = <3>;
+	atmel,vbus-gpio = <0
+			   &pioD 15 GPIO_ACTIVE_HIGH
+			   &pioD 16 GPIO_ACTIVE_HIGH>;
+	status = "okay";
+};
+
+&usb2 {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/sam9x60.dtsi b/arch/arm/boot/dts/sam9x60.dtsi
new file mode 100644
index 000000000000..2eb92a90453b
--- /dev/null
+++ b/arch/arm/boot/dts/sam9x60.dtsi
@@ -0,0 +1,691 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
+/*
+ * sam9x60.dtsi - Device Tree Include file for Microchip SAM9X60 SoC
+ *
+ * Copyright (C) 2019 Microchip Technology Inc. and its subsidiaries
+ *
+ * Author: Sandeep Sheriker M <sandeepsheriker.mallikarjun@microchip.com>
+ */
+
+#include <dt-bindings/dma/at91.h>
+#include <dt-bindings/pinctrl/at91.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/clock/at91.h>
+#include <dt-bindings/mfd/atmel-flexcom.h>
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	model = "Microchip SAM9X60 SoC";
+	compatible = "microchip,sam9x60";
+	interrupt-parent = <&aic>;
+
+	aliases {
+		serial0 = &dbgu;
+		gpio0 = &pioA;
+		gpio1 = &pioB;
+		gpio2 = &pioC;
+		gpio3 = &pioD;
+		tcb0 = &tcb0;
+		tcb1 = &tcb1;
+	};
+
+	cpus {
+		#address-cells = <0>;
+		#size-cells = <0>;
+
+		cpu {
+			compatible = "arm,arm926ej-s";
+			device_type = "cpu";
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x20000000 0x10000000>;
+	};
+
+	clocks {
+		slow_xtal: slow_xtal {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+		};
+
+		main_xtal: main_xtal {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+		};
+	};
+
+	sram: sram@300000 {
+		compatible = "mmio-sram";
+		reg = <0x00300000 0x100000>;
+	};
+
+	ahb {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		usb1: ohci@600000 {
+			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
+			reg = <0x00600000 0x100000>;
+			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 22>, <&pmc PMC_TYPE_PERIPHERAL 22>, <&pmc PMC_TYPE_SYSTEM 6>;
+			clock-names = "ohci_clk", "hclk", "uhpck";
+			status = "disabled";
+		};
+
+		usb2: ehci@700000 {
+			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
+			reg = <0x00700000 0x100000>;
+			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&pmc PMC_TYPE_CORE PMC_UTMI>, <&pmc PMC_TYPE_PERIPHERAL 22>;
+			clock-names = "usb_clk", "ehci_clk";
+			assigned-clocks = <&pmc PMC_TYPE_CORE PMC_UTMI>;
+			assigned-clock-rates = <480000000>;
+			status = "disabled";
+		};
+
+		ebi: ebi@10000000 {
+			compatible = "microchip,sam9x60-ebi";
+			#address-cells = <2>;
+			#size-cells = <1>;
+			atmel,smc = <&smc>;
+			microchip,sfr = <&sfr>;
+			reg = <0x10000000 0x60000000>;
+			ranges = <0x0 0x0 0x10000000 0x10000000
+				  0x1 0x0 0x20000000 0x10000000
+				  0x2 0x0 0x30000000 0x10000000
+				  0x3 0x0 0x40000000 0x10000000
+				  0x4 0x0 0x50000000 0x10000000
+				  0x5 0x0 0x60000000 0x10000000>;
+			clocks = <&pmc PMC_TYPE_CORE PMC_MCK>;
+			status = "disabled";
+
+			nand_controller: nand-controller {
+				compatible = "microchip,sam9x60-nand-controller";
+				ecc-engine = <&pmecc>;
+				#address-cells = <2>;
+				#size-cells = <1>;
+				ranges;
+				status = "disabled";
+			};
+		};
+
+		sdmmc0: sdio-host@80000000 {
+			compatible = "microchip,sam9x60-sdhci";
+			reg = <0x80000000 0x300>;
+			interrupts = <12 IRQ_TYPE_LEVEL_HIGH 0>;
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 12>, <&pmc PMC_TYPE_GCK 12>;
+			clock-names = "hclock", "multclk";
+			assigned-clocks = <&pmc PMC_TYPE_GCK 12>;
+			assigned-clock-rates = <100000000>;
+			status = "disabled";
+		};
+
+		sdmmc1: sdio-host@90000000 {
+			compatible = "microchip,sam9x60-sdhci";
+			reg = <0x90000000 0x300>;
+			interrupts = <26 IRQ_TYPE_LEVEL_HIGH 0>;
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 26>, <&pmc PMC_TYPE_GCK 26>;
+			clock-names = "hclock", "multclk";
+			assigned-clocks = <&pmc PMC_TYPE_GCK 26>;
+			assigned-clock-rates = <100000000>;
+			status = "disabled";
+		};
+
+		apb {
+			compatible = "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			flx4: flexcom@f0000000 {
+				compatible = "atmel,sama5d2-flexcom";
+				reg = <0xf0000000 0x200>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 13>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0xf0000000 0x800>;
+				status = "disabled";
+			};
+
+			flx5: flexcom@f0004000 {
+				compatible = "atmel,sama5d2-flexcom";
+				reg = <0xf0004000 0x200>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 14>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0xf0004000 0x800>;
+				status = "disabled";
+			};
+
+			dma0: dma-controller@f0008000 {
+				compatible = "microchip,sam9x60-dma", "atmel,sama5d4-dma";
+				reg = <0xf0008000 0x1000>;
+				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
+				#dma-cells = <1>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 20>;
+				clock-names = "dma_clk";
+			};
+
+			ssc: ssc@f0010000 {
+				compatible = "atmel,at91sam9g45-ssc";
+				reg = <0xf0010000 0x4000>;
+				interrupts = <28 IRQ_TYPE_LEVEL_HIGH 5>;
+				dmas = <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(38))>,
+				       <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(39))>;
+				dma-names = "tx", "rx";
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 28>;
+				clock-names = "pclk";
+				status = "disabled";
+			};
+
+			qspi: spi@f0014000 {
+				compatible = "microchip,sam9x60-qspi";
+				reg = <0xf0014000 0x100>, <0x70000000 0x10000000>;
+				reg-names = "qspi_base", "qspi_mmap";
+				interrupts = <35 IRQ_TYPE_LEVEL_HIGH 7>;
+				dmas = <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(26))>,
+				       <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(27))>;
+				dma-names = "tx", "rx";
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 35>, <&pmc PMC_TYPE_SYSTEM 19>;
+				clock-names = "pclk", "qspick";
+				atmel,pmc = <&pmc>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				status = "disabled";
+			};
+
+			i2s: i2s@f001c000 {
+				compatible = "microchip,sam9x60-i2smcc";
+				reg = <0xf001c000 0x100>;
+				interrupts = <34 IRQ_TYPE_LEVEL_HIGH 7>;
+				dmas = <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(36))>,
+				       <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(37))>;
+				dma-names = "tx", "rx";
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 34>, <&pmc PMC_TYPE_GCK 34>;
+				clock-names = "pclk", "gclk";
+				status = "disabled";
+			};
+
+			flx11: flexcom@f0020000 {
+				compatible = "atmel,sama5d2-flexcom";
+				reg = <0xf0020000 0x200>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 32>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0xf0020000 0x800>;
+				status = "disabled";
+			};
+
+			flx12: flexcom@f0024000 {
+				compatible = "atmel,sama5d2-flexcom";
+				reg = <0xf0024000 0x200>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 33>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0xf0024000 0x800>;
+				status = "disabled";
+			};
+
+			pit64b: timer@f0028000 {
+				compatible = "microchip,sam9x60-pit64b";
+				reg = <0xf0028000 0x100>;
+				interrupts = <37 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 37>, <&pmc PMC_TYPE_GCK 37>;
+				clock-names = "pclk", "gclk";
+			};
+
+			sha: sha@f002c000 {
+				compatible = "atmel,at91sam9g46-sha";
+				reg = <0xf002c000 0x100>;
+				interrupts = <41 IRQ_TYPE_LEVEL_HIGH 0>;
+				dmas = <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(34))>;
+				dma-names = "tx";
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 41>;
+				clock-names = "sha_clk";
+				status = "okay";
+			};
+
+			trng: trng@f0030000 {
+				compatible = "microchip,sam9x60-trng";
+				reg = <0xf0030000 0x100>;
+				interrupts = <38 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 38>;
+				status = "okay";
+			};
+
+			aes: aes@f0034000 {
+				compatible = "atmel,at91sam9g46-aes";
+				reg = <0xf0034000 0x100>;
+				interrupts = <39 IRQ_TYPE_LEVEL_HIGH 0>;
+				dmas = <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(32))>,
+				       <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(33))>;
+				dma-names = "tx", "rx";
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 39>;
+				clock-names = "aes_clk";
+				status = "okay";
+			};
+
+			tdes: tdes@f0038000 {
+				compatible = "atmel,at91sam9g46-tdes";
+				reg = <0xf0038000 0x100>;
+				interrupts = <40 IRQ_TYPE_LEVEL_HIGH 0>;
+				dmas = <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(31))>,
+				       <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(30))>;
+				dma-names = "tx", "rx";
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 40>;
+				clock-names = "tdes_clk";
+				status = "okay";
+			};
+
+			classd: classd@f003c000 {
+				compatible = "atmel,sama5d2-classd";
+				reg = <0xf003c000 0x100>;
+				interrupts = <42 IRQ_TYPE_LEVEL_HIGH 7>;
+				dmas = <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(35))>;
+				dma-names = "tx";
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 42>, <&pmc PMC_TYPE_GCK 42>;
+				clock-names = "pclk", "gclk";
+				status = "disabled";
+			};
+
+			can0: can@f8000000 {
+				compatible = "microchip,sam9x60-can", "atmel,at91sam9x5-can";
+				reg = <0xf8000000 0x300>;
+				interrupts = <29 IRQ_TYPE_LEVEL_HIGH 3>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 29>;
+				clock-names = "can_clk";
+				status = "disabled";
+			};
+
+			can1: can@f8004000 {
+				compatible = "microchip,sam9x60-can", "atmel,at91sam9x5-can";
+				reg = <0xf8004000 0x300>;
+				interrupts = <30 IRQ_TYPE_LEVEL_HIGH 3>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 30>;
+				clock-names = "can_clk";
+				status = "disabled";
+			};
+
+			tcb0: timer@f8008000 {
+				compatible = "microchip,sam9x60-tcb", "atmel,at91sam9x5-tcb", "simple-mfd", "syscon";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0xf8008000 0x100>;
+				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 17>, <&clk32k 0>;
+				clock-names = "t0_clk", "slow_clk";
+			};
+
+			tcb1: timer@f800c000 {
+				compatible = "microchip,sam9x60-tcb", "atmel,at91sam9x5-tcb", "simple-mfd", "syscon";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0xf800c000 0x100>;
+				interrupts = <45 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 45>, <&clk32k 0>;
+				clock-names = "t0_clk", "slow_clk";
+			};
+
+			flx6: flexcom@f8010000 {
+				compatible = "atmel,sama5d2-flexcom";
+				reg = <0xf8010000 0x200>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 9>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0xf8010000 0x800>;
+				status = "disabled";
+			};
+
+			flx7: flexcom@f8014000 {
+				compatible = "atmel,sama5d2-flexcom";
+				reg = <0xf8014000 0x200>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 10>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0xf8014000 0x800>;
+				status = "disabled";
+			};
+
+			flx8: flexcom@f8018000 {
+				compatible = "atmel,sama5d2-flexcom";
+				reg = <0xf8018000 0x200>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 11>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0xf8018000 0x800>;
+				status = "disabled";
+			};
+
+			flx0: flexcom@f801c000 {
+				compatible = "atmel,sama5d2-flexcom";
+				reg = <0xf801c000 0x200>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 5>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0xf801c000 0x800>;
+				status = "disabled";
+			};
+
+			flx1: flexcom@f8020000 {
+				compatible = "atmel,sama5d2-flexcom";
+				reg = <0xf8020000 0x200>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 6>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0xf8020000 0x800>;
+				status = "disabled";
+			};
+
+			flx2: flexcom@f8024000 {
+				compatible = "atmel,sama5d2-flexcom";
+				reg = <0xf8024000 0x200>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 7>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0xf8024000 0x800>;
+				status = "disabled";
+			};
+
+			flx3: flexcom@f8028000 {
+				compatible = "atmel,sama5d2-flexcom";
+				reg = <0xf8028000 0x200>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 8>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0xf8028000 0x800>;
+				status = "disabled";
+			};
+
+			macb0: ethernet@f802c000 {
+				compatible = "cdns,sam9x60-macb", "cdns,macb";
+				reg = <0xf802c000 0x1000>;
+				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 24>, <&pmc PMC_TYPE_PERIPHERAL 24>;
+				clock-names = "hclk", "pclk";
+				status = "disabled";
+			};
+
+			macb1: ethernet@f8030000 {
+				compatible = "cdns,sam9x60-macb", "cdns,macb";
+				reg = <0xf8030000 0x1000>;
+				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 3>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 27>, <&pmc PMC_TYPE_PERIPHERAL 27>;
+				clock-names = "hclk", "pclk";
+				status = "disabled";
+			};
+
+			pwm0: pwm@f8034000 {
+				compatible = "microchip,sam9x60-pwm";
+				reg = <0xf8034000 0x300>;
+				interrupts = <18 IRQ_TYPE_LEVEL_HIGH 4>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 18>;
+				#pwm-cells = <3>;
+				status="disabled";
+			};
+
+			hlcdc: hlcdc@f8038000 {
+				compatible = "microchip,sam9x60-hlcdc";
+				reg = <0xf8038000 0x4000>;
+				interrupts = <25 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 25>, <&pmc PMC_TYPE_GCK 25>, <&clk32k 1>;
+				clock-names = "periph_clk","sys_clk", "slow_clk";
+				assigned-clocks = <&pmc PMC_TYPE_GCK 25>;
+				assigned-clock-parents = <&pmc PMC_TYPE_CORE PMC_MCK>;
+				status = "disabled";
+
+				hlcdc-display-controller {
+					compatible = "atmel,hlcdc-display-controller";
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						#address-cells = <1>;
+						#size-cells = <0>;
+						reg = <0>;
+					};
+				};
+
+				hlcdc_pwm: hlcdc-pwm {
+					compatible = "atmel,hlcdc-pwm";
+					#pwm-cells = <3>;
+				};
+			};
+
+			flx9: flexcom@f8040000 {
+				compatible = "atmel,sama5d2-flexcom";
+				reg = <0xf8040000 0x200>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 15>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0xf8040000 0x800>;
+				status = "disabled";
+			};
+
+			flx10: flexcom@f8044000 {
+				compatible = "atmel,sama5d2-flexcom";
+				reg = <0xf8044000 0x200>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 16>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0x0 0xf8044000 0x800>;
+				status = "disabled";
+			};
+
+			isi: isi@f8048000 {
+				compatible = "microchip,sam9x60-isi", "atmel,at91sam9g45-isi";
+				reg = <0xf8048000 0x100>;
+				interrupts = <43 IRQ_TYPE_LEVEL_HIGH 5>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 43>;
+				clock-names = "isi_clk";
+				status = "disabled";
+				port {
+					#address-cells = <1>;
+					#size-cells = <0>;
+				};
+			};
+
+			adc: adc@f804c000 {
+				compatible = "microchip,sam9x60-adc", "atmel,sama5d2-adc";
+				reg = <0xf804c000 0x100>;
+				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 19>;
+				clock-names = "adc_clk";
+				dmas = <&dma0 (AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) | AT91_XDMAC_DT_PERID(40))>;
+				dma-names = "rx";
+				atmel,min-sample-rate-hz = <200000>;
+				atmel,max-sample-rate-hz = <20000000>;
+				atmel,startup-time-ms = <4>;
+				atmel,trigger-edge-type = <IRQ_TYPE_EDGE_RISING>;
+				#io-channel-cells = <1>;
+				status = "disabled";
+			};
+
+			sfr: sfr@f8050000 {
+				compatible = "microchip,sam9x60-sfr", "syscon";
+				reg = <0xf8050000 0x100>;
+			};
+
+			matrix: matrix@ffffde00 {
+				compatible = "microchip,sam9x60-matrix", "atmel,at91sam9x5-matrix", "syscon";
+				reg = <0xffffde00 0x200>;
+			};
+
+			pmecc: ecc-engine@ffffe000 {
+				compatible = "microchip,sam9x60-pmecc", "atmel,at91sam9g45-pmecc";
+				reg = <0xffffe000 0x300>,
+				      <0xffffe600 0x100>;
+			};
+
+			mpddrc: mpddrc@ffffe800 {
+				compatible = "microchip,sam9x60-ddramc", "atmel,sama5d3-ddramc";
+				reg = <0xffffe800 0x200>;
+				clocks = <&pmc PMC_TYPE_SYSTEM 2>, <&pmc PMC_TYPE_CORE PMC_MCK>;
+				clock-names = "ddrck", "mpddr";
+			};
+
+			smc: smc@ffffea00 {
+				compatible = "microchip,sam9x60-smc", "atmel,at91sam9260-smc", "syscon";
+				reg = <0xffffea00 0x100>;
+			};
+
+			aic: interrupt-controller@fffff100 {
+				compatible = "microchip,sam9x60-aic";
+				#interrupt-cells = <3>;
+				interrupt-controller;
+				reg = <0xfffff100 0x100>;
+				atmel,external-irqs = <31>;
+			};
+
+			dbgu: serial@fffff200 {
+				compatible = "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+				reg = <0xfffff200 0x200>;
+				interrupts = <47 IRQ_TYPE_LEVEL_HIGH 7>;
+				dmas = <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(28))>,
+				       <&dma0
+					(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
+					 AT91_XDMAC_DT_PERID(29))>;
+				dma-names = "tx", "rx";
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 47>;
+				clock-names = "usart";
+				status = "disabled";
+			};
+
+			pinctrl: pinctrl@fffff400 {
+				#address-cells = <1>;
+				#size-cells = <1>;
+				compatible = "microchip,sam9x60-pinctrl", "atmel,at91sam9x5-pinctrl", "atmel,at91rm9200-pinctrl", "simple-bus";
+				ranges = <0xfffff400 0xfffff400 0x800>;
+
+				pioA: gpio@fffff400 {
+					compatible = "microchip,sam9x60-gpio", "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
+					reg = <0xfffff400 0x200>;
+					interrupts = <2 IRQ_TYPE_LEVEL_HIGH 1>;
+					#gpio-cells = <2>;
+					gpio-controller;
+					interrupt-controller;
+					#interrupt-cells = <2>;
+					clocks = <&pmc PMC_TYPE_PERIPHERAL 2>;
+				};
+
+				pioB: gpio@fffff600 {
+					compatible = "microchip,sam9x60-gpio", "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
+					reg = <0xfffff600 0x200>;
+					interrupts = <3 IRQ_TYPE_LEVEL_HIGH 1>;
+					#gpio-cells = <2>;
+					gpio-controller;
+					#gpio-lines = <26>;
+					interrupt-controller;
+					#interrupt-cells = <2>;
+					clocks = <&pmc PMC_TYPE_PERIPHERAL 3>;
+				};
+
+				pioC: gpio@fffff800 {
+					compatible = "microchip,sam9x60-gpio", "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
+					reg = <0xfffff800 0x200>;
+					interrupts = <4 IRQ_TYPE_LEVEL_HIGH 1>;
+					#gpio-cells = <2>;
+					gpio-controller;
+					interrupt-controller;
+					#interrupt-cells = <2>;
+					clocks = <&pmc PMC_TYPE_PERIPHERAL 4>;
+				};
+
+				pioD: gpio@fffffa00 {
+					compatible = "microchip,sam9x60-gpio", "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
+					reg = <0xfffffa00 0x200>;
+					interrupts = <44 IRQ_TYPE_LEVEL_HIGH 1>;
+					#gpio-cells = <2>;
+					gpio-controller;
+					#gpio-lines = <22>;
+					interrupt-controller;
+					#interrupt-cells = <2>;
+					clocks = <&pmc PMC_TYPE_PERIPHERAL 44>;
+				};
+			};
+
+			pmc: pmc@fffffc00 {
+				compatible = "microchip,sam9x60-pmc", "syscon";
+				reg = <0xfffffc00 0x200>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				#clock-cells = <2>;
+				clocks = <&clk32k 1>, <&clk32k 0>, <&main_xtal>;
+				clock-names = "td_slck", "md_slck", "main_xtal";
+			};
+
+			reset_controller: rstc@fffffe00 {
+				compatible = "microchip,sam9x60-rstc";
+				reg = <0xfffffe00 0x10>;
+				clocks = <&clk32k 0>;
+			};
+
+			shutdown_controller: shdwc@fffffe10 {
+				compatible = "microchip,sam9x60-shdwc";
+				reg = <0xfffffe10 0x10>;
+				clocks = <&clk32k 0>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				atmel,wakeup-rtc-timer;
+				atmel,wakeup-rtt-timer;
+				status = "disabled";
+			};
+
+			pit: timer@fffffe40 {
+				compatible = "atmel,at91sam9260-pit";
+				reg = <0xfffffe40 0x10>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&pmc PMC_TYPE_CORE PMC_MCK>;
+			};
+
+			clk32k: sckc@fffffe50 {
+				compatible = "microchip,sam9x60-sckc";
+				reg = <0xfffffe50 0x4>;
+				clocks = <&slow_xtal>;
+				#clock-cells = <1>;
+			};
+
+			gpbr: syscon@fffffe60 {
+				compatible = "microchip,sam9x60-gpbr", "atmel,at91sam9260-gpbr", "syscon";
+				reg = <0xfffffe60 0x10>;
+			};
+
+			rtc: rtc@fffffea8 {
+				compatible = "microchip,sam9x60-rtc", "atmel,at91sam9x5-rtc";
+				reg = <0xfffffea8 0x100>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&clk32k 0>;
+			};
+		};
+	};
+};
-- 
2.7.4

