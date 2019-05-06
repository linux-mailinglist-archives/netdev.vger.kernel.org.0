Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE8CA14348
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 03:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfEFBIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 21:08:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33910 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfEFBIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 21:08:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id f7so4750125wrq.1;
        Sun, 05 May 2019 18:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FKTE+cin9FPr9rrkGNck3/B4OfvJ0E5J1uTuf06jUr0=;
        b=MehMSNyzIm3kJejGtxa1wWUuqoTT5OAVQGn9fTLAIffKTMQLBF+NbfWEbor8EuslcC
         iKIUF7ahkSIa0y41I/OT2kD80+GkBhtk6K2pgRrn/MZ/yhlbHjxNzQ18tcsjL7FLesi3
         NIDBLxN3V1n3LbdkMPhK7bNofEyByqeo2kskg2ITd0exWD4zcfnmRcrbBjXzu8bT10mP
         iG/EoXIRB+GTn9xlUjGOpfoz6aiJ1cHN7cBONIbwtl9AtnYXG8hGJGAwd83FLyPV0Wfh
         zz0Zu1d6FOH09WUcPgP1PJCXTyXem9vReqgvI/WuWToBVwAvoaShiMej0L3KtAo8YXkX
         rNMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FKTE+cin9FPr9rrkGNck3/B4OfvJ0E5J1uTuf06jUr0=;
        b=T72BjtYgZAJzcuKWp+EUEwxsVNiFzAdyPEaLb8IA/7DIF39IiSVhTSMuApvplI6hyK
         pi4sIlt1bGdexV1Yqt0eGZiXg2dQuIuASW4Yms5K/rHmqBZM2QJ590sglAzN/+nIe21t
         nOzE7ndqw7m5j8vBsu36ZeRd+qhmwMNrmNiLTJt0OIMUHXe+zSXDWd7PP0zjETB20jEN
         0uErjCZqO1h+cWZ3Pp0dbTR2FlcLK2az7084WDx9BMRkza/3WDOuZt52eGDMeM9Hmkj8
         bZP0KDsaeUi+FMb0cJlBWCeDp6ftCvQkv+FkAuM89G0r662lDhkFKwlOJVRufetNJSCt
         EQ7g==
X-Gm-Message-State: APjAAAWhHIKCrY2ClEKusGhHLtaVFl8egnIsefXx1F8u2j0d8yx3dj0x
        bTV0Ku0xaXqV+rl6/kdIchM=
X-Google-Smtp-Source: APXvYqzUAV/YDoSG4WtLzgy5WotRZ7dUv3Ed9/JUh+5zCDDk/CuWb3I8YDOI/iPHXky47Z359+REAg==
X-Received: by 2002:adf:f383:: with SMTP id m3mr2298118wro.164.1557104902871;
        Sun, 05 May 2019 18:08:22 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id z5sm20955384wre.70.2019.05.05.18.08.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 18:08:22 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org
Cc:     leoyang.li@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH] ARM: dts: Introduce the NXP LS1021A-TSN board
Date:   Mon,  6 May 2019 04:08:00 +0300
Message-Id: <20190506010800.2433-1-olteanv@gmail.com>
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
 arch/arm/boot/dts/Makefile        |   3 +-
 arch/arm/boot/dts/ls1021a-tsn.dts | 238 ++++++++++++++++++++++++++++++
 2 files changed, 240 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/ls1021a-tsn.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index f4f5aeaf3298..529f0150f6b4 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -593,7 +593,8 @@ dtb-$(CONFIG_SOC_IMX7ULP) += \
 dtb-$(CONFIG_SOC_LS1021A) += \
 	ls1021a-moxa-uc-8410a.dtb \
 	ls1021a-qds.dtb \
-	ls1021a-twr.dtb
+	ls1021a-twr.dtb \
+	ls1021a-tsn.dtb
 dtb-$(CONFIG_SOC_VF610) += \
 	vf500-colibri-eval-v3.dtb \
 	vf610-bk4.dtb \
diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
new file mode 100644
index 000000000000..5269486699bd
--- /dev/null
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -0,0 +1,238 @@
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
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		reg_3p3v: regulator@0 {
+			compatible = "regulator-fixed";
+			reg = <0>;
+			regulator-name = "3P3V";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+		reg_2p5v: regulator@1 {
+			compatible = "regulator-fixed";
+			reg = <1>;
+			regulator-name = "2P5V";
+			regulator-min-microvolt = <2500000>;
+			regulator-max-microvolt = <2500000>;
+			regulator-always-on;
+		};
+	};
+};
+
+&enet0 {
+	tbi-handle = <&tbi0>;
+	phy-handle = <&sgmii_phy2>;
+	phy-mode = "sgmii";
+	status = "ok";
+};
+
+&enet1 {
+	tbi-handle = <&tbi1>;
+	phy-handle = <&sgmii_phy1>;
+	phy-mode = "sgmii";
+	status = "ok";
+};
+
+/* RGMII delays added via PCB traces */
+&enet2 {
+	phy-mode = "rgmii";
+	status = "ok";
+	fixed-link {
+		speed = <1000>;
+		full-duplex;
+	};
+};
+
+&dspi0 {
+	bus-num = <0>;
+	status = "ok";
+
+	/* ADG704BRMZ 1:4 mux/demux */
+	tsn_switch: sja1105@1 {
+		reg = <0x1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nxp,sja1105t";
+		/* 12 MHz */
+		spi-max-frequency = <12000000>;
+		/* Sample data on trailing clock edge */
+		spi-cpha;
+		fsl,spi-cs-sck-delay = <1000>;
+		fsl,spi-sck-cs-delay = <1000>;
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			port@0 {
+				/* ETH5 written on chassis */
+				label = "swp5";
+				phy-handle = <&rgmii_phy6>;
+				phy-mode = "rgmii-id";
+				reg = <0>;
+			};
+			port@1 {
+				/* ETH2 written on chassis */
+				label = "swp2";
+				phy-handle = <&rgmii_phy3>;
+				phy-mode = "rgmii-id";
+				reg = <1>;
+			};
+			port@2 {
+				/* ETH3 written on chassis */
+				label = "swp3";
+				phy-handle = <&rgmii_phy4>;
+				phy-mode = "rgmii-id";
+				reg = <2>;
+			};
+			port@3 {
+				/* ETH4 written on chassis */
+				phy-handle = <&rgmii_phy5>;
+				label = "swp4";
+				phy-mode = "rgmii-id";
+				reg = <3>;
+			};
+			port@4 {
+				/* Internal port connected to eth2 */
+				ethernet = <&enet2>;
+				phy-mode = "rgmii";
+				reg = <4>;
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
+		};
+	};
+};
+
+&mdio0 {
+	/* AR8031 */
+	sgmii_phy1: ethernet-phy@1 {
+		reg = <0x1>;
+	};
+	/* AR8031 */
+	sgmii_phy2: ethernet-phy@2 {
+		reg = <0x2>;
+	};
+	/* BCM5464 */
+	rgmii_phy3: ethernet-phy@3 {
+		reg = <0x3>;
+	};
+	rgmii_phy4: ethernet-phy@4 {
+		reg = <0x4>;
+	};
+	rgmii_phy5: ethernet-phy@5 {
+		reg = <0x5>;
+	};
+	rgmii_phy6: ethernet-phy@6 {
+		reg = <0x6>;
+	};
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
+&i2c0 {
+	status = "ok";
+
+	/* 3 axis accelerometer */
+	accelerometer@1e {
+		compatible = "fsl,fxls8471";
+		reg = <0x1e>;
+		position = <0>;
+	};
+	/* Gyroscope is at 0x20 but not supported */
+	/* Audio codec (SAI2) */
+	codec@2a {
+		#sound-dai-cells = <0>;
+		compatible = "fsl,sgtl5000";
+		reg = <0x2a>;
+		VDDA-supply = <&reg_3p3v>;
+		VDDIO-supply = <&reg_2p5v>;
+		clocks = <&sys_mclk>;
+	};
+	/* Current sensing circuit for 1V VDDCORE PMIC rail */
+	current-sensor@44 {
+		compatible = "ti,ina220";
+		reg = <0x44>;
+		shunt-resistor = <1000>;
+	};
+	/* Current sensing circuit for 12V VCC rail */
+	current-sensor@45 {
+		compatible = "ti,ina220";
+		reg = <0x45>;
+		shunt-resistor = <1000>;
+	};
+	/* Thermal monitor - case */
+	temperature-sensor@48 {
+		compatible = "national,lm75";
+		reg = <0x48>;
+	};
+	/* Thermal monitor - chip */
+	temperature-sensor@4c {
+		compatible = "ti,tmp451";
+		reg = <0x4c>;
+	};
+	/* 4-channel ADC */
+	adc@49 {
+		compatible = "ad7924";
+		reg = <0x49>;
+	};
+};
+
+&ifc {
+	status = "disabled";
+};
+
+&esdhc {
+	status = "ok";
+};
+
+&uart0 {
+	status = "ok";
+};
+
+&lpuart0 {
+	status = "ok";
+};
+
+&lpuart3 {
+	status = "ok";
+};
+
+&sai2 {
+	status = "ok";
+};
+
+&sata {
+	status = "ok";
+};
-- 
2.17.1

