Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02948380A9
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfFFW2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:28:24 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35468 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfFFW2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:28:23 -0400
Received: by mail-wr1-f68.google.com with SMTP id m3so221457wrv.2;
        Thu, 06 Jun 2019 15:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=K8LRZAGyxTA91e565NC0WdxUL44tT7JJZTxvCh2Q5n0=;
        b=AhtcL6cP7rZU1yX2Iu9vJzeoGJ0Bnz7Hl/floUOmKa4mZYwItJz8fNrF6Lbc1LB0fp
         XY2xFcADNY2grLi+jPcrkgawo9jn1qz0FT/Rrx0r/48eRjvUUT7HCSzcZqd9NjNOAgKb
         yfxFMAP0D9dhfRSmis03kKBUEwaL27NmtfHe6FoSxYedpmN2M4x/QzTDniI+ESEA8aXi
         Rh/X6EyJJ0OarAYkJzf4t4k9RKjQaxvD3kk+sBMN5OBZBenMJ7zscvopNCMtORWprxdj
         t7275r0jPEfhxV5JwohNn8pmb8hhTEI+k9Oc8FY/bqh2dVGkvA97qs3mvJFc/tXjTTg+
         XeLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=K8LRZAGyxTA91e565NC0WdxUL44tT7JJZTxvCh2Q5n0=;
        b=bloLDXaoFsulK/AjkiwK0KIPHz/hy7VbG5EMErGfzGYHhV7RuxGKYB57dGFmOXqFIS
         VGoUbUIXZxIt4ey+mfmOvWv1ru/3Jvv3sz0EjFDEAwDmlFzkFBYt5LpSJOfvRuDxGOTv
         jMK+YTx6YwSbs0vmG8XtpZmHiBreBrU9qLH/jxMCbapkn+iVMWLmYJLAoR8DPuhhgWwb
         fMan0yMJj6jTxn2l+ILJ0gJTwvCgGzkJn34yVttYSlGodzoW2lY8bbMSUCOmb3nhRkJ3
         cc6aDygoYy3rzW5ApRZ1NfgoxTFn0F334DYoi/ODDeCANZI8wQt8oF0xMIkWRCjlHryL
         GWcQ==
X-Gm-Message-State: APjAAAWskTKriQLo/RikchMbrpVI2K9FEf/N7iSG+nQXlILcw/QDif8D
        LvfqCB2QuBSymMZh0nT68Gg=
X-Google-Smtp-Source: APXvYqyvuY1RelhcBhUggjE4fxrjJ4yul8towhNZkJtNFNc5/o2oigiFGX39aGq/51KA5rgSgLsrBw==
X-Received: by 2002:adf:f50c:: with SMTP id q12mr4506022wro.300.1559860100607;
        Thu, 06 Jun 2019 15:28:20 -0700 (PDT)
Received: from localhost.localdomain (5-12-124-26.residential.rdsnet.ro. [5.12.124.26])
        by smtp.gmail.com with ESMTPSA id v184sm220527wme.10.2019.06.06.15.28.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 15:28:20 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org
Cc:     leoyang.li@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4] ARM: dts: Introduce the NXP LS1021A-TSN board
Date:   Fri,  7 Jun 2019 01:28:17 +0300
Message-Id: <20190606222817.14223-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LS1021A-TSN is a development board built by VVDN/Argonboards in
partnership with NXP.

It features the LS1021A SoC and the first-generation SJA1105T Ethernet
switch for prototyping implementations of a subset of IEEE 802.1 TSN
standards.

It has two regular Ethernet ports and four switched, TSN-capable ports.

It also features:
- One Arduino header
- One expansion header
- Two USB 3.0 ports
- One mini PCIe slot
- One SATA interface
- Accelerometer, gyroscope, temperature sensors

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes from v3:
- Not all nodes were alphabetically sorted ("d->i->e" vs "d->e->i")

Changes from v2:
- Sorted nodes alphabetically
- Renamed SAI2 codec node into audio-codec

v2 patch available at:
https://lkml.org/lkml/2019/5/29/998

Changes from v1:
- Applied Shawn's feedback
- Introduced QSPI flash node

v1 patch available at:
https://patchwork.kernel.org/patch/10930451/

 arch/arm/boot/dts/Makefile        |   1 +
 arch/arm/boot/dts/ls1021a-tsn.dts | 289 ++++++++++++++++++++++++++++++
 2 files changed, 290 insertions(+)
 create mode 100644 arch/arm/boot/dts/ls1021a-tsn.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index dab2914fa293..a4eb4ca5e148 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -602,6 +602,7 @@ dtb-$(CONFIG_SOC_IMX7ULP) += \
 dtb-$(CONFIG_SOC_LS1021A) += \
 	ls1021a-moxa-uc-8410a.dtb \
 	ls1021a-qds.dtb \
+	ls1021a-tsn.dtb \
 	ls1021a-twr.dtb
 dtb-$(CONFIG_SOC_VF610) += \
 	vf500-colibri-eval-v3.dtb \
diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
new file mode 100644
index 000000000000..5b7689094b70
--- /dev/null
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -0,0 +1,289 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2016-2018 NXP Semiconductors
+ * Copyright 2019 Vladimir Oltean <olteanv@gmail.com>
+ */
+
+/dts-v1/;
+#include "ls1021a.dtsi"
+
+/ {
+	model = "NXP LS1021A-TSN Board";
+
+	sys_mclk: clock-mclk {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <24576000>;
+	};
+
+	reg_vdda_codec: regulator-3V3 {
+		compatible = "regulator-fixed";
+		regulator-name = "3P3V";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-always-on;
+	};
+
+	reg_vddio_codec: regulator-2V5 {
+		compatible = "regulator-fixed";
+		regulator-name = "2P5V";
+		regulator-min-microvolt = <2500000>;
+		regulator-max-microvolt = <2500000>;
+		regulator-always-on;
+	};
+};
+
+&dspi0 {
+	bus-num = <0>;
+	status = "okay";
+
+	/* ADG704BRMZ 1:4 SPI mux/demux */
+	sja1105: ethernet-switch@1 {
+		reg = <0x1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nxp,sja1105t";
+		/* 12 MHz */
+		spi-max-frequency = <12000000>;
+		/* Sample data on trailing clock edge */
+		spi-cpha;
+		/* SPI controller settings for SJA1105 timing requirements */
+		fsl,spi-cs-sck-delay = <1000>;
+		fsl,spi-sck-cs-delay = <1000>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				/* ETH5 written on chassis */
+				label = "swp5";
+				phy-handle = <&rgmii_phy6>;
+				phy-mode = "rgmii-id";
+				reg = <0>;
+			};
+
+			port@1 {
+				/* ETH2 written on chassis */
+				label = "swp2";
+				phy-handle = <&rgmii_phy3>;
+				phy-mode = "rgmii-id";
+				reg = <1>;
+			};
+
+			port@2 {
+				/* ETH3 written on chassis */
+				label = "swp3";
+				phy-handle = <&rgmii_phy4>;
+				phy-mode = "rgmii-id";
+				reg = <2>;
+			};
+
+			port@3 {
+				/* ETH4 written on chassis */
+				label = "swp4";
+				phy-handle = <&rgmii_phy5>;
+				phy-mode = "rgmii-id";
+				reg = <3>;
+			};
+
+			port@4 {
+				/* Internal port connected to eth2 */
+				ethernet = <&enet2>;
+				phy-mode = "rgmii";
+				reg = <4>;
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
+		};
+	};
+};
+
+&enet0 {
+	tbi-handle = <&tbi0>;
+	phy-handle = <&sgmii_phy2>;
+	phy-mode = "sgmii";
+	status = "okay";
+};
+
+&enet1 {
+	tbi-handle = <&tbi1>;
+	phy-handle = <&sgmii_phy1>;
+	phy-mode = "sgmii";
+	status = "okay";
+};
+
+/* RGMII delays added via PCB traces */
+&enet2 {
+	phy-mode = "rgmii";
+	status = "okay";
+
+	fixed-link {
+		speed = <1000>;
+		full-duplex;
+	};
+};
+
+&esdhc {
+	status = "okay";
+};
+
+&i2c0 {
+	status = "okay";
+
+	/* 3 axis accelerometer */
+	accelerometer@1e {
+		compatible = "fsl,fxls8471";
+		position = <0>;
+		reg = <0x1e>;
+	};
+
+	/* Audio codec (SAI2) */
+	audio-codec@2a {
+		compatible = "fsl,sgtl5000";
+		VDDIO-supply = <&reg_vddio_codec>;
+		VDDA-supply = <&reg_vdda_codec>;
+		#sound-dai-cells = <0>;
+		clocks = <&sys_mclk>;
+		reg = <0x2a>;
+	};
+
+	/* Current sensing circuit for 1V VDDCORE PMIC rail */
+	current-sensor@44 {
+		compatible = "ti,ina220";
+		shunt-resistor = <1000>;
+		reg = <0x44>;
+	};
+
+	/* Current sensing circuit for 12V VCC rail */
+	current-sensor@45 {
+		compatible = "ti,ina220";
+		shunt-resistor = <1000>;
+		reg = <0x45>;
+	};
+
+	/* Thermal monitor - case */
+	temperature-sensor@48 {
+		compatible = "national,lm75";
+		reg = <0x48>;
+	};
+
+	/* Thermal monitor - chip */
+	temperature-sensor@4c {
+		compatible = "ti,tmp451";
+		reg = <0x4c>;
+	};
+
+	eeprom@51 {
+		compatible = "atmel,24c32";
+		reg = <0x51>;
+	};
+
+	/* Unsupported devices:
+	 * - FXAS21002C Gyroscope at 0x20
+	 * - TI ADS7924 4-channel ADC at 0x49
+	 */
+};
+
+&ifc {
+	status = "disabled";
+};
+
+&lpuart0 {
+	status = "okay";
+};
+
+&lpuart3 {
+	status = "okay";
+};
+
+&mdio0 {
+	/* AR8031 */
+	sgmii_phy1: ethernet-phy@1 {
+		reg = <0x1>;
+	};
+
+	/* AR8031 */
+	sgmii_phy2: ethernet-phy@2 {
+		reg = <0x2>;
+	};
+
+	/* BCM5464 quad PHY */
+	rgmii_phy3: ethernet-phy@3 {
+		reg = <0x3>;
+	};
+
+	rgmii_phy4: ethernet-phy@4 {
+		reg = <0x4>;
+	};
+
+	rgmii_phy5: ethernet-phy@5 {
+		reg = <0x5>;
+	};
+
+	rgmii_phy6: ethernet-phy@6 {
+		reg = <0x6>;
+	};
+
+	/* SGMII PCS for enet0 */
+	tbi0: tbi-phy@1f {
+		reg = <0x1f>;
+		device_type = "tbi-phy";
+	};
+};
+
+&mdio1 {
+	/* SGMII PCS for enet1 */
+	tbi1: tbi-phy@1f {
+		reg = <0x1f>;
+		device_type = "tbi-phy";
+	};
+};
+
+&qspi {
+	status = "okay";
+
+	flash@0 {
+		/* Rev. A uses 64MB flash, Rev. B & C use 32MB flash */
+		compatible = "jedec,spi-nor", "s25fl256s1", "s25fl512s";
+		spi-max-frequency = <20000000>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0>;
+
+		partitions {
+			compatible = "fixed-partitions";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			partition@0 {
+				label = "RCW";
+				reg = <0x0 0x40000>;
+			};
+
+			partition@40000 {
+				label = "U-Boot";
+				reg = <0x40000 0x300000>;
+			};
+
+			partition@340000 {
+				label = "U-Boot Env";
+				reg = <0x340000 0x100000>;
+			};
+		};
+	};
+};
+
+&sai2 {
+	status = "okay";
+};
+
+&sata {
+	status = "okay";
+};
+
+&uart0 {
+	status = "okay";
+};
-- 
2.17.1

