Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E4F42380C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237416AbhJFGfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:35:43 -0400
Received: from mout.perfora.net ([74.208.4.196]:50739 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237311AbhJFGfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 02:35:39 -0400
Received: from toolbox.soleil.gust ([63.147.84.106]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1N2ma8-1mvDpm3x4W-0138uO;
 Wed, 06 Oct 2021 08:33:31 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Frank Rowand <frowand.list@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Olof Johansson <olof@lixom.net>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        soc@kernel.org
Subject: [PATCH v2 3/3] ARM: dts: mvebu: add device tree for netgear gs110emx switch
Date:   Wed,  6 Oct 2021 08:33:21 +0200
Message-Id: <20211006063321.351882-4-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211006063321.351882-1-marcel@ziswiler.com>
References: <20211006063321.351882-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:fTitiDCQxhzc/pb9GpA1O5wtUb19ssH3YOftOIY9jP92wQsu5pj
 LJAajS2qnr2aqNc4UFZTIUV6L3g2klPQQ20EocJtzwZpKr5Dl1/2WPPaXmBB9/QJExYLbWq
 +Tw17fUVOT5PSBC5nDl6wacizb1J72j5/Gvexyik1RJpvY19TZcGUzbysL3qKZJ7xbw/lOJ
 fl54OWr8DXvtyZzGSKg3g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mBDwxUgv+d4=:h2quqc2/1aQWuxcYS9aW5S
 QvrLV4sFrxeS+Y1yxi6QiRwi///pe8MT/JFLJ8gktvSNPFreQrqhVnvYrKcxpy2Y6iIx78MH9
 U5ggZfYXiX2AsuEvQB76mjdJRgnAX7NjrpbakxvgpUVZt5sJRMjdzQISfMx9pZDbi0HD32dss
 L5u9uXN1FaxVqT9jgWySiVv5S4Pis2apEbq2ZIhsItY1UyJCQjZwGdNHeArfTkftTyCRGslFj
 zdDYgDtvxVMHzPRFykjiFnUy9oTJfcrIfWbj6eGe9q/y52nT6iOzL7VYXeltu+IJb8QVKCt7J
 n+kZAexX0tVZ1BMsHSY4NRrBTmib9cphrPBhEdqLTBL5kj/Vx3lCsOLtg6ewXTaaVte4niNxd
 NE93YXg8DGGpyQ/uARhg86THR2+cuBV2SrokJA7GrOb3rr3IroAQJgWWC6yzl2CnT/I778Kkf
 052fSfMrYJVr1FPnQbVbllh1i/hFPGym5IynGsTVPrhQNIWW9U17hdJa3WkI1VLcXhJEJHlDr
 B6kQLseXbX4wgREYUsTUQML2gen6PlVxpb1ajeHTLdsd1q3ukmfMT0ddEkTmUEiELc56lzRQz
 mqLffvr/aaBMdi1tA6ThAobKwzlGNtWGO/0Uau+NE+2Nlx5k/xW/GKEnKqlD/QRpL/tknTmCG
 50H7QXlAEPdljrLEEcRW9cmBVcW9y/QIlNefTlX7DcTbZTlO+WVOGPAkwuJTegGnF0h0Kln19
 h2f2fMNK93IuDeAkguINAM+DuHYE/ll+B3dhdQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the device tree for a Netgear GS110EMX switch featuring 8 Gigabit
ports and 2 Multi-Gig ports (100M/1G/2.5G/5G/10G). An 88E6390X switch
sits at its core connecting to two 88X3310P 10G PHYs. The control plane
is handled by an 88F6811 Armada 381 SoC.

The following functionality is tested:
- 8 gigabit Ethernet ports connecting via 88E6390X to the 88F6811
- serial console UART
- 128 MB commercial grade DDR3L SDRAM
- 16 MB serial SPI NOR flash

The two 88X3310P 10G PHYs while detected during boot seem neither to
detect any link nor pass any traffic.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>

---

Changes in v2:
- Fix numbering of the PHY labels as suggested by Andrew.

 arch/arm/boot/dts/Makefile                    |   1 +
 .../boot/dts/armada-381-netgear-gs110emx.dts  | 293 ++++++++++++++++++
 2 files changed, 294 insertions(+)
 create mode 100644 arch/arm/boot/dts/armada-381-netgear-gs110emx.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 5ffab04866654..e2fcb55c99c6b 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -1392,6 +1392,7 @@ dtb-$(CONFIG_MACH_ARMADA_370) += \
 dtb-$(CONFIG_MACH_ARMADA_375) += \
 	armada-375-db.dtb
 dtb-$(CONFIG_MACH_ARMADA_38X) += \
+	armada-381-netgear-gs110emx.dtb \
 	armada-382-rd-ac3x-48g4x2xl.dtb \
 	armada-385-atl-x530.dtb\
 	armada-385-clearfog-gtr-s4.dtb \
diff --git a/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts b/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
new file mode 100644
index 0000000000000..cf635cdff9160
--- /dev/null
+++ b/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
@@ -0,0 +1,293 @@
+// SPDX-License-Identifier: GPL-2.0-or-later OR MIT
+/* Copyright (c) 2021, Marcel Ziswiler <marcel@ziswiler.com> */
+
+/dts-v1/;
+#include "armada-385.dtsi"
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/input/input.h>
+
+/ {
+	model = "Netgear GS110EMX";
+	compatible = "netgear,gs110emx", "marvell,armada380";
+
+	aliases {
+		/* So that mvebu u-boot can update the MAC addresses */
+		ethernet1 = &eth0;
+	};
+
+	chosen {
+		stdout-path = "serial0:115200n8";
+	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+		pinctrl-0 = <&front_button_pins>;
+		pinctrl-names = "default";
+
+		factory_default {
+			label = "Factory Default";
+			gpios = <&gpio1 6 GPIO_ACTIVE_LOW>;
+			linux,code = <KEY_RESTART>;
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x08000000>; /* 128 MB */
+	};
+
+	reg_3p3v: regulator-3p3v {
+		compatible = "regulator-fixed";
+		regulator-always-on;
+		regulator-max-microvolt = <3300000>;
+		regulator-min-microvolt = <3300000>;
+		regulator-name = "3P3V";
+	};
+
+	soc {
+		ranges = <MBUS_ID(0xf0, 0x01) 0 0xf1000000 0x100000
+			  MBUS_ID(0x01, 0x1d) 0 0xfff00000 0x100000
+			  MBUS_ID(0x09, 0x19) 0 0xf1100000 0x10000
+			  MBUS_ID(0x09, 0x15) 0 0xf1110000 0x10000
+			  MBUS_ID(0x0c, 0x04) 0 0xf1200000 0x100000>;
+
+		internal-regs {
+			rtc@a3800 {
+				/*
+				 * If the rtc doesn't work, run "date reset"
+				 * twice in u-boot.
+				 */
+				status = "okay";
+			};
+		};
+	};
+};
+
+&eth0 {
+	/* ethernet@70000 */
+	bm,pool-long = <0>;
+	bm,pool-short = <1>;
+	buffer-manager = <&bm>;
+	phy-mode = "rgmii-id";
+	pinctrl-0 = <&ge0_rgmii_pins>;
+	pinctrl-names = "default";
+	status = "okay";
+
+	fixed-link {
+		full-duplex;
+		pause;
+		speed = <1000>;
+	};
+};
+
+&mdio {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mdio_pins>;
+	status = "okay";
+
+	switch@0 {
+		compatible = "marvell,mv88e6190";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0>;
+
+		mdio {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			switch0phy1: switch0phy1@1 {
+				reg = <0x1>;
+			};
+
+			switch0phy2: switch0phy2@2 {
+				reg = <0x2>;
+			};
+
+			switch0phy3: switch0phy3@3 {
+				reg = <0x3>;
+			};
+
+			switch0phy4: switch0phy4@4 {
+				reg = <0x4>;
+			};
+
+			switch0phy5: switch0phy5@5 {
+				reg = <0x5>;
+			};
+
+			switch0phy6: switch0phy6@6 {
+				reg = <0x6>;
+			};
+
+			switch0phy7: switch0phy7@7 {
+				reg = <0x7>;
+			};
+
+			switch0phy8: switch0phy8@8 {
+				reg = <0x8>;
+			};
+		};
+
+		mdio-external {
+			compatible = "marvell,mv88e6xxx-mdio-external";
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			phy1: ethernet-phy@b {
+				reg = <0xb>;
+				compatible = "ethernet-phy-ieee802.3-c45";
+			};
+
+			phy2: ethernet-phy@c {
+				reg = <0xc>;
+				compatible = "ethernet-phy-ieee802.3-c45";
+			};
+		};
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				ethernet = <&eth0>;
+				label = "cpu";
+				reg = <0>;
+
+				fixed-link {
+					full-duplex;
+					pause;
+					speed = <1000>;
+				};
+			};
+
+			port@1 {
+				label = "lan1";
+				phy-handle = <&switch0phy1>;
+				reg = <1>;
+			};
+
+			port@2 {
+				label = "lan2";
+				phy-handle = <&switch0phy2>;
+				reg = <2>;
+			};
+
+			port@3 {
+				label = "lan3";
+				phy-handle = <&switch0phy3>;
+				reg = <3>;
+			};
+
+			port@4 {
+				label = "lan4";
+				phy-handle = <&switch0phy4>;
+				reg = <4>;
+			};
+
+			port@5 {
+				label = "lan5";
+				phy-handle = <&switch0phy5>;
+				reg = <5>;
+			};
+
+			port@6 {
+				label = "lan6";
+				phy-handle = <&switch0phy6>;
+				reg = <6>;
+			};
+
+			port@7 {
+				label = "lan7";
+				phy-handle = <&switch0phy7>;
+				reg = <7>;
+			};
+
+			port@8 {
+				label = "lan8";
+				phy-handle = <&switch0phy8>;
+				reg = <8>;
+			};
+
+			port@9 {
+				/* 88X3310P external phy */
+				label = "lan9";
+				phy-handle = <&phy1>;
+				phy-mode = "xaui";
+				reg = <9>;
+			};
+
+			port@a {
+				/* 88X3310P external phy */
+				label = "lan10";
+				phy-handle = <&phy2>;
+				phy-mode = "xaui";
+				reg = <0xa>;
+			};
+		};
+	};
+};
+
+&pinctrl {
+	front_button_pins: front-button-pins {
+		marvell,pins = "mpp38";
+		marvell,function = "gpio";
+	};
+};
+
+&spi0 {
+	pinctrl-0 = <&spi0_pins>;
+	pinctrl-names = "default";
+	status = "okay";
+
+	spi-flash@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "jedec,spi-nor";
+		reg = <0>; /* Chip select 0 */
+		spi-max-frequency = <3000000>;
+//mtdparts=spi0.0:1m(boot),64k(env),64k(rsv),9m(image0),3m(config),-(debug)
+
+		partitions {
+			compatible = "fixed-partitions";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			partition@0 {
+				label = "boot";
+				read-only;
+				reg = <0x00000000 0x00100000>;
+			};
+
+			partition@100000 {
+				label = "env";
+				reg = <0x00100000 0x00010000>;
+			};
+
+			partition@200000 {
+				label = "rsv";
+				reg = <0x00110000 0x00010000>;
+			};
+
+			partition@300000 {
+				label = "image0";
+				reg = <0x00120000 0x00900000>;
+			};
+
+			partition@400000 {
+				label = "config";
+				reg = <0x00a20000 0x00300000>;
+			};
+
+			partition@480000 {
+				label = "debug";
+				reg = <0x00d20000 0x002e0000>;
+			};
+		};
+	};
+};
+
+&uart0 {
+	pinctrl-0 = <&uart0_pins>;
+	pinctrl-names = "default";
+	status = "okay";
+};
-- 
2.26.2

