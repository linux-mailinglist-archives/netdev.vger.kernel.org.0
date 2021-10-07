Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809A1425E4F
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240736AbhJGU7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:59:24 -0400
Received: from mout.perfora.net ([74.208.4.196]:44889 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233710AbhJGU7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 16:59:17 -0400
Received: from toolbox.toradex.int ([66.171.181.186]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0M39aj-1moK5A3U5n-00syLw;
 Thu, 07 Oct 2021 22:57:12 +0200
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
Subject: [PATCH v3 3/3] ARM: dts: mvebu: add device tree for netgear gs110emx switch
Date:   Thu,  7 Oct 2021 22:56:59 +0200
Message-Id: <20211007205659.702842-4-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211007205659.702842-1-marcel@ziswiler.com>
References: <20211007205659.702842-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:tgmhfyb9YQfohJgoUoTc33T0wgfevcvW2MYJd3jThHgrnHJR7vk
 8Ag8QiTmmpk7wLF7h2tftZYhSzYpKmaUHds0fIyYzk2nZELVMgHm+Rj8FU9mp/JzlVuk8LY
 hE4jRnG8s2A4MiyGcd2CsP4W5A/agsvg2sJXzTgsW6BoHKz1htqX4DxcS1zKwRsnUE2Ivs1
 5EzHa/2C9xeZ/TRzlgwNw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PghSg628fok=:Qy8ynGkmnXCFQYa72mFG1F
 ODDFziIsIJ+/iiiVojnS4ctpE6+6bx7LU0FX7sLaBCvxonobMknJETcFNxXBKFqPbLBfrLeea
 Dln5fatfviI2ltHYmQk40O/2HioVgJr+K8RK/il/h6AonSpVK1KIzjRzfv7UckizcHWXxhye+
 PaNuMqIZOFfGjLgSqYWipJuhMICDp3qVz+fPBxRIAu71KrG4zHUu+awic48HScwFP1/XYA+Ks
 EDPIhd9BLHPVY2hrpt4o6bB6g1hXToieU75VAc2NXTfsTerVUam4sihthk/cWCsiUyQoFbm8A
 zez7Az2ReiLKFfBjB3W1Rp1Z10KMbLwpM+cUt/IZyDnJUeLzztMcrC5LsFhdZ7nAdDV9iWfPv
 6i/guqL41s30Xu57Vt4c3kFaxGffGaBaRZSzPehcdUp2+FTNVu1YyGjEYFKSOI7pWav61WrIJ
 bw9rs3HFCTH4URBbHXygftrnuzT1OBH5iprN4Ktc/cR9agnPzr1yNvWw6JgPkRbnIHqim6YuT
 8bqulGF4ltZyqlcuoMnqnUqDqu3yN5POwDyiMzw+0MOyZHPzQQYWspjTEa8f0Kc7hvlmIaUSX
 7FAP5DOKRCAgXe3Gb63Y8sFRWfD0syDbxWxffRw7ls+7k+2wylS2fM4GvbTTVvJdllXRwuU1y
 wmGRCeF6JnaW1ExsXtBBIPBLjyCPOdjdG3dAS+T298/jAcmuu9YzTIY4PvscrD3IOhUFQViyv
 HW5xd6DoIZ9mbcnmwZh7Bkrwg2A9yw0Emg+2Hg==
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

Changes in v3:
- Got rid of unused 3.3 volt regulator as suggested by Andrew.
- Got rid of partitioning comment.
- Added switch interrupt GPIO configuration.

Changes in v2:
- Send previous first patch separately to netdev mailing list as
  suggested by Andrew.
- Fix numbering of the PHY labels as suggested by Andrew.

 arch/arm/boot/dts/Makefile                    |   1 +
 .../boot/dts/armada-381-netgear-gs110emx.dts  | 295 ++++++++++++++++++
 2 files changed, 296 insertions(+)
 create mode 100644 arch/arm/boot/dts/armada-381-netgear-gs110emx.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 2deb4b1ecaecd..699e2d2230127 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -1395,6 +1395,7 @@ dtb-$(CONFIG_MACH_ARMADA_370) += \
 dtb-$(CONFIG_MACH_ARMADA_375) += \
 	armada-375-db.dtb
 dtb-$(CONFIG_MACH_ARMADA_38X) += \
+	armada-381-netgear-gs110emx.dtb \
 	armada-382-rd-ac3x-48g4x2xl.dtb \
 	armada-385-atl-x530.dtb\
 	armada-385-clearfog-gtr-s4.dtb \
diff --git a/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts b/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
new file mode 100644
index 0000000000000..0a961116a1f9d
--- /dev/null
+++ b/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
@@ -0,0 +1,295 @@
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
+		#interrupt-cells = <2>;
+		interrupt-controller;
+		interrupt-parent = <&gpio1>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
+		pinctrl-0 = <&switch_interrupt_pins>;
+		pinctrl-names = "default";
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
+
+	switch_interrupt_pins: switch-interrupt-pins {
+		marvell,pins = "mpp39";
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

