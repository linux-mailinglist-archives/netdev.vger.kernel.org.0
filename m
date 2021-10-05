Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56308421EA8
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhJEGGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:06:00 -0400
Received: from mout.perfora.net ([74.208.4.194]:56301 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232405AbhJEGFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 02:05:55 -0400
Received: from toolbox.soleil.gust ([63.147.84.106]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0Md2do-1mFPue23gQ-00IDmR;
 Tue, 05 Oct 2021 08:03:50 +0200
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
Subject: [PATCH v1 4/4] ARM: dts: mvebu: add device tree for netgear gs110emx switch
Date:   Tue,  5 Oct 2021 08:03:34 +0200
Message-Id: <20211005060334.203818-5-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211005060334.203818-1-marcel@ziswiler.com>
References: <20211005060334.203818-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:uK5vcLb1GP24U6qIBEzVLUa9DVIFBWAH2JWb6ncTKrB6U9qdJk1
 BffoqWvYF57R649ATeQROdK0TVbg5Eatr4uerN2zmBTNpo3Ip5J+AygciMbgVKaPK/iCoyx
 Vo+3rbIs6C7uCQE+FdlTmWkscjeW+yX8FSiQtSXjFt456wqgKCF/IWHmUz10NlK8TrREmQB
 bBzxIKD+5ZfEeQdxAHrQQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+0khJ/3ANeE=:4skKWLnKQVKjha/CNo0hvP
 GSQTXTgThNFilxz1N6pN7ieVLBOeEHEWyv18YWPQMQHN9M0nfn9XAUlDzKAWMtbzozP6Bj61r
 k+zY45ARd94M5CDyNDqHcEbI3G5E6ywDwm2IVKUvP+a60bwQABjz8ck/lCEtfPHI6K27uPpVg
 56Q9zO67Y7J0R1wTE3h1r9qpBnEeClwmxeQzIc1s0v2MdRf5N/MBm1P6tqMjcbM3w37Uxm/WN
 DkEuWIvGGb4NFWx6PzsFdtMtDpR9PnpiRTsIiRwN3axP7KEWaZpUaWvIeiH9rSaUWDwzZjwYW
 OGqWQv22EuRCeBasHw/4gmpBXmBPVgt/xuWEQL3/kVXJvgiElC8RzS6T4ywtqUj8ZlCJK1Rme
 wsh7ZjlB3vtYgOw/nezFrVGvfEkoRm1zDJEJTvO3ydCKvmRWqDixPKt9a+VskoqZhb9dMXVpd
 PyRsJGXZxLuYCNhpZ+dJjJBLEfWXqJwoDcTbtoVZ5XuZa5e/vfk0G8bmicgo65Zt6cIFlAn7b
 kLQNTSVGkQ5Gty2swotHPJiYdyNClyoIKDoKRGqSrr1kFt9fK/lObheYzfwSgBd/iH5PvMhoj
 ESGA0g0PtRnukPHjSUOV1DRyemG0YURccYpLKSffjWSTtlIB+ogrmClaXsBzX9zZLB+24M5DT
 VE1HGe1hjvVaJYXBC6e1NOWsG+WTxfg7iMkBxJAqtWJJngNFsSNIZ8s6VT323IGpuzI+eTUeR
 5UE3bCvW65UoHj4T+M0llR5dSxUY8i9uxeddOA==
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
index 0000000000000..e37baeb12bd01
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
+			switch0phy0: switch0phy0@1 {
+				reg = <0x1>;
+			};
+
+			switch0phy1: switch0phy1@2 {
+				reg = <0x2>;
+			};
+
+			switch0phy2: switch0phy2@3 {
+				reg = <0x3>;
+			};
+
+			switch0phy3: switch0phy3@4 {
+				reg = <0x4>;
+			};
+
+			switch0phy4: switch0phy4@5 {
+				reg = <0x5>;
+			};
+
+			switch0phy5: switch0phy5@6 {
+				reg = <0x6>;
+			};
+
+			switch0phy6: switch0phy6@7 {
+				reg = <0x7>;
+			};
+
+			switch0phy7: switch0phy7@8 {
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
+				phy-handle = <&switch0phy0>;
+				reg = <1>;
+			};
+
+			port@2 {
+				label = "lan2";
+				phy-handle = <&switch0phy1>;
+				reg = <2>;
+			};
+
+			port@3 {
+				label = "lan3";
+				phy-handle = <&switch0phy2>;
+				reg = <3>;
+			};
+
+			port@4 {
+				label = "lan4";
+				phy-handle = <&switch0phy3>;
+				reg = <4>;
+			};
+
+			port@5 {
+				label = "lan5";
+				phy-handle = <&switch0phy4>;
+				reg = <5>;
+			};
+
+			port@6 {
+				label = "lan6";
+				phy-handle = <&switch0phy5>;
+				reg = <6>;
+			};
+
+			port@7 {
+				label = "lan7";
+				phy-handle = <&switch0phy6>;
+				reg = <7>;
+			};
+
+			port@8 {
+				label = "lan8";
+				phy-handle = <&switch0phy7>;
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

