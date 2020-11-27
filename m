Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26FD2C66F1
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 14:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgK0Ndk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 08:33:40 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:2994 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730425AbgK0Ndh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 08:33:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606484017; x=1638020017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IUnuGdc+Gwk7DAt1ZunPUaR11DhnnKboAQycNJ0VtbU=;
  b=p4kCHYr1/3JiWtZ06l2E85DRPNWK1etkWABmNmniR/r8J6XQxwNzOKZC
   wAadJ1ouaSESFNQHhLffvfQkA4iDKyRdg9c8oHuG7/JXwdnR0WBQ7pVEq
   zg2lFdH9aw/ZVdVC41TDK3ZohrAc0tx/NqcQNayMQGEl6ZRHzAg4nDFXr
   KXbN5F0kCQzFnyySgrkRzWkpKPFQnKiLENRG1LKjbxpuBe/xqsRsKQMJ5
   tE7P0ggvf2Bq1KM6tR8NKjEpt5HNuUlbAMdqhNpdNt4AJAtLDTQoOQVFh
   GIE06zBMMUjT91z2ayeZX7aP1Qb8R1sSKNzNavj2wVb4wYY102SeGxkN+
   g==;
IronPort-SDR: 2KOYvkDU6tHiMCWpJ7Txtmn59W4ZdNcS7GJBDLZicq/zLe67OI/TnJAtdXXlsFrUf1Qa06d9CC
 58oZS9AnCveczXAt5L1KAu/11xdKgN7BYoEzWE6c2eo4IidBPvq3QabaIbm2VQDESCt0Bup//1
 UqmP+FAkk+Q9vCLW/nBR2s8wUDN4cJP1tpmlzyQwqyBnv6JBKBO1kgjagpAsNXzNUYXPtakAV1
 Rqx3j+zu+5ZP4xwfVmNx6e01dB9Y+eAK9bWbS0/WUDHuWN42880unLdng2J6PXUMXl14HhmdQR
 MvI=
X-IronPort-AV: E=Sophos;i="5.78,374,1599548400"; 
   d="scan'208";a="95050366"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Nov 2020 06:33:36 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 27 Nov 2020 06:33:35 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 27 Nov 2020 06:33:32 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [RFC PATCH 3/3] arm64: dts: sparx5: Add the Sparx5 switch node
Date:   Fri, 27 Nov 2020 14:33:07 +0100
Message-ID: <20201127133307.2969817-4-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127133307.2969817-1-steen.hegelund@microchip.com>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides switchdev support for the Microship Sparx5 PCB134 and PCB135
reference boards.

This commit depends on the following series currently on their way
into the kernel:

- Sparx5 SerDes Driver
  Link: https://lore.kernel.org/r/20201123114234.2292766-1-steen.hegelund@microchip.com/

- Serial GPIO Controller
  Link: https://lore.kernel.org/r/20201113145151.68900-1-lars.povlsen@microchip.com/

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 arch/arm64/boot/dts/microchip/sparx5.dtsi     | 364 +++++++++++
 .../dts/microchip/sparx5_pcb134_board.dtsi    | 424 ++++++++++--
 .../dts/microchip/sparx5_pcb135_board.dtsi    | 602 +++++++++++++++++-
 3 files changed, 1330 insertions(+), 60 deletions(-)

diff --git a/arch/arm64/boot/dts/microchip/sparx5.dtsi b/arch/arm64/boot/dts/microchip/sparx5.dtsi
index 08d0c2fe208e..8119ea1029e0 100644
--- a/arch/arm64/boot/dts/microchip/sparx5.dtsi
+++ b/arch/arm64/boot/dts/microchip/sparx5.dtsi
@@ -267,6 +267,21 @@ emmc_pins: emmc-pins {
 					"GPIO_46", "GPIO_47";
 				function = "emmc";
 			};
+
+			miim1_pins: miim1-pins {
+				pins = "GPIO_56", "GPIO_57";
+				function = "miim";
+			};
+
+			miim2_pins: miim2-pins {
+				pins = "GPIO_58", "GPIO_59";
+				function = "miim";
+			};
+
+			miim3_pins: miim3-pins {
+				pins = "GPIO_52", "GPIO_53";
+				function = "miim";
+			};
 		};
 
 		sgpio0: gpio@61101036c {
@@ -379,6 +394,44 @@ tmon0: tmon@610508110 {
 			clocks = <&ahb_clk>;
 		};
 
+		mdio0: mdio@6110102b0 {
+			compatible = "mscc,ocelot-miim";
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x6 0x110102b0 0x24>;
+		};
+
+		mdio1: mdio@6110102d4 {
+			compatible = "mscc,ocelot-miim";
+			status = "disabled";
+			pinctrl-0 = <&miim1_pins>;
+			pinctrl-names = "default";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x6 0x110102d4 0x24>;
+		};
+
+		mdio2: mdio@6110102f8 {
+			compatible = "mscc,ocelot-miim";
+			status = "disabled";
+			pinctrl-0 = <&miim2_pins>;
+			pinctrl-names = "default";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x6 0x110102d4 0x24>;
+		};
+
+		mdio3: mdio@61101031c {
+			compatible = "mscc,ocelot-miim";
+			status = "disabled";
+			pinctrl-0 = <&miim3_pins>;
+			pinctrl-names = "default";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x6 0x1101031c 0x24>;
+		};
+
 		serdes: serdes@10808000 {
 			compatible = "microchip,sparx5-serdes";
 			#phy-cells = <1>;
@@ -574,5 +627,316 @@ serdes: serdes@10808000 {
 				"sd_lane_25g_32";
 		};
 
+		switch: switch@600000000 {
+			compatible = "microchip,sparx5-switch";
+			reg =	<0x6 0x10004000 0x4000>, /* dev2g5_0 */
+				<0x6 0x10008000 0x4000>, /* dev5g_0 */
+				<0x6 0x1000c000 0x4000>, /* pcs5g_br_0 */
+				<0x6 0x10010000 0x4000>, /* dev2g5_1 */
+				<0x6 0x10014000 0x4000>, /* dev5g_1 */
+				<0x6 0x10018000 0x4000>, /* pcs5g_br_1 */
+				<0x6 0x1001c000 0x4000>, /* dev2g5_2 */
+				<0x6 0x10020000 0x4000>, /* dev5g_2 */
+				<0x6 0x10024000 0x4000>, /* pcs5g_br_2 */
+				<0x6 0x10028000 0x4000>, /* dev2g5_6 */
+				<0x6 0x1002c000 0x4000>, /* dev5g_6 */
+				<0x6 0x10030000 0x4000>, /* pcs5g_br_6 */
+				<0x6 0x10034000 0x4000>, /* dev2g5_7 */
+				<0x6 0x10038000 0x4000>, /* dev5g_7 */
+				<0x6 0x1003c000 0x4000>, /* pcs5g_br_7 */
+				<0x6 0x10040000 0x4000>, /* dev2g5_8 */
+				<0x6 0x10044000 0x4000>, /* dev5g_8 */
+				<0x6 0x10048000 0x4000>, /* pcs5g_br_8 */
+				<0x6 0x1004c000 0x4000>, /* dev2g5_9 */
+				<0x6 0x10050000 0x4000>, /* dev5g_9 */
+				<0x6 0x10054000 0x4000>, /* pcs5g_br_9 */
+				<0x6 0x10058000 0x4000>, /* dev2g5_10 */
+				<0x6 0x1005c000 0x4000>, /* dev5g_10 */
+				<0x6 0x10060000 0x4000>, /* pcs5g_br_10 */
+				<0x6 0x10064000 0x4000>, /* dev2g5_11 */
+				<0x6 0x10068000 0x4000>, /* dev5g_11 */
+				<0x6 0x1006c000 0x4000>, /* pcs5g_br_11 */
+				<0x6 0x10070000 0x4000>, /* dev2g5_12 */
+				<0x6 0x10074000 0x4000>, /* dev10g_0 */
+				<0x6 0x10078000 0x4000>, /* pcs10g_br_0 */
+				<0x6 0x1007c000 0x4000>, /* dev2g5_14 */
+				<0x6 0x10080000 0x4000>, /* dev10g_2 */
+				<0x6 0x10084000 0x4000>, /* pcs10g_br_2 */
+				<0x6 0x10088000 0x4000>, /* dev2g5_15 */
+				<0x6 0x1008c000 0x4000>, /* dev10g_3 */
+				<0x6 0x10090000 0x4000>, /* pcs10g_br_3 */
+				<0x6 0x10094000 0x4000>, /* dev2g5_16 */
+				<0x6 0x10098000 0x4000>, /* dev2g5_17 */
+				<0x6 0x1009c000 0x4000>, /* dev2g5_18 */
+				<0x6 0x100a0000 0x4000>, /* dev2g5_19 */
+				<0x6 0x100a4000 0x4000>, /* dev2g5_20 */
+				<0x6 0x100a8000 0x4000>, /* dev2g5_21 */
+				<0x6 0x100ac000 0x4000>, /* dev2g5_22 */
+				<0x6 0x100b0000 0x4000>, /* dev2g5_23 */
+				<0x6 0x100b4000 0x4000>, /* dev2g5_32 */
+				<0x6 0x100b8000 0x4000>, /* dev2g5_33 */
+				<0x6 0x100bc000 0x4000>, /* dev2g5_34 */
+				<0x6 0x100c0000 0x4000>, /* dev2g5_35 */
+				<0x6 0x100c4000 0x4000>, /* dev2g5_36 */
+				<0x6 0x100c8000 0x4000>, /* dev2g5_37 */
+				<0x6 0x100cc000 0x4000>, /* dev2g5_38 */
+				<0x6 0x100d0000 0x4000>, /* dev2g5_39 */
+				<0x6 0x100d4000 0x4000>, /* dev2g5_40 */
+				<0x6 0x100d8000 0x4000>, /* dev2g5_41 */
+				<0x6 0x100dc000 0x4000>, /* dev2g5_42 */
+				<0x6 0x100e0000 0x4000>, /* dev2g5_43 */
+				<0x6 0x100e4000 0x4000>, /* dev2g5_44 */
+				<0x6 0x100e8000 0x4000>, /* dev2g5_45 */
+				<0x6 0x100ec000 0x4000>, /* dev2g5_46 */
+				<0x6 0x100f0000 0x4000>, /* dev2g5_47 */
+				<0x6 0x100f4000 0x4000>, /* dev2g5_57 */
+				<0x6 0x100f8000 0x4000>, /* dev25g_1 */
+				<0x6 0x100fc000 0x4000>, /* pcs25g_br_1 */
+				<0x6 0x10104000 0x4000>, /* dev2g5_59 */
+				<0x6 0x10108000 0x4000>, /* dev25g_3 */
+				<0x6 0x1010c000 0x4000>, /* pcs25g_br_3 */
+				<0x6 0x10114000 0x4000>, /* dev2g5_60 */
+				<0x6 0x10118000 0x4000>, /* dev25g_4 */
+				<0x6 0x1011c000 0x4000>, /* pcs25g_br_4 */
+				<0x6 0x10124000 0x4000>, /* dev2g5_64 */
+				<0x6 0x10128000 0x4000>, /* dev5g_64 */
+				<0x6 0x1012c000 0x4000>, /* pcs5g_br_64 */
+				<0x6 0x10130000 0x2d0000>, /* port_conf */
+				<0x6 0x10404000 0x4000>, /* dev2g5_3 */
+				<0x6 0x10408000 0x4000>, /* dev5g_3 */
+				<0x6 0x1040c000 0x4000>, /* pcs5g_br_3 */
+				<0x6 0x10410000 0x4000>, /* dev2g5_4 */
+				<0x6 0x10414000 0x4000>, /* dev5g_4 */
+				<0x6 0x10418000 0x4000>, /* pcs5g_br_4 */
+				<0x6 0x1041c000 0x4000>, /* dev2g5_5 */
+				<0x6 0x10420000 0x4000>, /* dev5g_5 */
+				<0x6 0x10424000 0x4000>, /* pcs5g_br_5 */
+				<0x6 0x10428000 0x4000>, /* dev2g5_13 */
+				<0x6 0x1042c000 0x4000>, /* dev10g_1 */
+				<0x6 0x10430000 0x4000>, /* pcs10g_br_1 */
+				<0x6 0x10434000 0x4000>, /* dev2g5_24 */
+				<0x6 0x10438000 0x4000>, /* dev2g5_25 */
+				<0x6 0x1043c000 0x4000>, /* dev2g5_26 */
+				<0x6 0x10440000 0x4000>, /* dev2g5_27 */
+				<0x6 0x10444000 0x4000>, /* dev2g5_28 */
+				<0x6 0x10448000 0x4000>, /* dev2g5_29 */
+				<0x6 0x1044c000 0x4000>, /* dev2g5_30 */
+				<0x6 0x10450000 0x4000>, /* dev2g5_31 */
+				<0x6 0x10454000 0x4000>, /* dev2g5_48 */
+				<0x6 0x10458000 0x4000>, /* dev10g_4 */
+				<0x6 0x1045c000 0x4000>, /* pcs10g_br_4 */
+				<0x6 0x10460000 0x4000>, /* dev2g5_49 */
+				<0x6 0x10464000 0x4000>, /* dev10g_5 */
+				<0x6 0x10468000 0x4000>, /* pcs10g_br_5 */
+				<0x6 0x1046c000 0x4000>, /* dev2g5_50 */
+				<0x6 0x10470000 0x4000>, /* dev10g_6 */
+				<0x6 0x10474000 0x4000>, /* pcs10g_br_6 */
+				<0x6 0x10478000 0x4000>, /* dev2g5_51 */
+				<0x6 0x1047c000 0x4000>, /* dev10g_7 */
+				<0x6 0x10480000 0x4000>, /* pcs10g_br_7 */
+				<0x6 0x10484000 0x4000>, /* dev2g5_52 */
+				<0x6 0x10488000 0x4000>, /* dev10g_8 */
+				<0x6 0x1048c000 0x4000>, /* pcs10g_br_8 */
+				<0x6 0x10490000 0x4000>, /* dev2g5_53 */
+				<0x6 0x10494000 0x4000>, /* dev10g_9 */
+				<0x6 0x10498000 0x4000>, /* pcs10g_br_9 */
+				<0x6 0x1049c000 0x4000>, /* dev2g5_54 */
+				<0x6 0x104a0000 0x4000>, /* dev10g_10 */
+				<0x6 0x104a4000 0x4000>, /* pcs10g_br_10 */
+				<0x6 0x104a8000 0x4000>, /* dev2g5_55 */
+				<0x6 0x104ac000 0x4000>, /* dev10g_11 */
+				<0x6 0x104b0000 0x4000>, /* pcs10g_br_11 */
+				<0x6 0x104b4000 0x4000>, /* dev2g5_56 */
+				<0x6 0x104b8000 0x4000>, /* dev25g_0 */
+				<0x6 0x104bc000 0x4000>, /* pcs25g_br_0 */
+				<0x6 0x104c4000 0x4000>, /* dev2g5_58 */
+				<0x6 0x104c8000 0x4000>, /* dev25g_2 */
+				<0x6 0x104cc000 0x4000>, /* pcs25g_br_2 */
+				<0x6 0x104d4000 0x4000>, /* dev2g5_61 */
+				<0x6 0x104d8000 0x4000>, /* dev25g_5 */
+				<0x6 0x104dc000 0x4000>, /* pcs25g_br_5 */
+				<0x6 0x104e4000 0x4000>, /* dev2g5_62 */
+				<0x6 0x104e8000 0x4000>, /* dev25g_6 */
+				<0x6 0x104ec000 0x4000>, /* pcs25g_br_6 */
+				<0x6 0x104f4000 0x4000>, /* dev2g5_63 */
+				<0x6 0x104f8000 0x4000>, /* dev25g_7 */
+				<0x6 0x104fc000 0x4000>, /* pcs25g_br_7 */
+				<0x6 0x10504000 0x4000>, /* dsm */
+				<0x6 0x10600000 0x200000>, /* asm */
+				<0x6 0x11010000 0x10000>, /* gcb */
+				<0x6 0x11030000 0x10000>, /* qs */
+				<0x6 0x11050000 0x10000>, /* ana_acl */
+				<0x6 0x11060000 0x10000>, /* lrn */
+				<0x6 0x11080000 0x10000>, /* vcap_super */
+				<0x6 0x110a0000 0x10000>, /* qsys */
+				<0x6 0x110b0000 0x10000>, /* qfwd */
+				<0x6 0x110c0000 0x10000>, /* xqs */
+				<0x6 0x11100000 0x100000>, /* clkgen */
+				<0x6 0x11200000 0x40000>, /* ana_ac_pol */
+				<0x6 0x11280000 0x40000>, /* qres */
+				<0x6 0x112c0000 0x140000>, /* eacl */
+				<0x6 0x11400000 0x80000>, /* ana_cl */
+				<0x6 0x11480000 0x80000>, /* ana_l3 */
+				<0x6 0x11580000 0x80000>, /* hsch */
+				<0x6 0x11600000 0x80000>, /* rew */
+				<0x6 0x11800000 0x100000>, /* ana_l2 */
+				<0x6 0x11900000 0x100000>, /* ana_ac */
+				<0x6 0x11a00000 0x100000>; /* vop */
+			reg-names =
+				"dev2g5_0",
+				"dev5g_0",
+				"pcs5g_br_0",
+				"dev2g5_1",
+				"dev5g_1",
+				"pcs5g_br_1",
+				"dev2g5_2",
+				"dev5g_2",
+				"pcs5g_br_2",
+				"dev2g5_6",
+				"dev5g_6",
+				"pcs5g_br_6",
+				"dev2g5_7",
+				"dev5g_7",
+				"pcs5g_br_7",
+				"dev2g5_8",
+				"dev5g_8",
+				"pcs5g_br_8",
+				"dev2g5_9",
+				"dev5g_9",
+				"pcs5g_br_9",
+				"dev2g5_10",
+				"dev5g_10",
+				"pcs5g_br_10",
+				"dev2g5_11",
+				"dev5g_11",
+				"pcs5g_br_11",
+				"dev2g5_12",
+				"dev10g_0",
+				"pcs10g_br_0",
+				"dev2g5_14",
+				"dev10g_2",
+				"pcs10g_br_2",
+				"dev2g5_15",
+				"dev10g_3",
+				"pcs10g_br_3",
+				"dev2g5_16",
+				"dev2g5_17",
+				"dev2g5_18",
+				"dev2g5_19",
+				"dev2g5_20",
+				"dev2g5_21",
+				"dev2g5_22",
+				"dev2g5_23",
+				"dev2g5_32",
+				"dev2g5_33",
+				"dev2g5_34",
+				"dev2g5_35",
+				"dev2g5_36",
+				"dev2g5_37",
+				"dev2g5_38",
+				"dev2g5_39",
+				"dev2g5_40",
+				"dev2g5_41",
+				"dev2g5_42",
+				"dev2g5_43",
+				"dev2g5_44",
+				"dev2g5_45",
+				"dev2g5_46",
+				"dev2g5_47",
+				"dev2g5_57",
+				"dev25g_1",
+				"pcs25g_br_1",
+				"dev2g5_59",
+				"dev25g_3",
+				"pcs25g_br_3",
+				"dev2g5_60",
+				"dev25g_4",
+				"pcs25g_br_4",
+				"dev2g5_64",
+				"dev5g_64",
+				"pcs5g_br_64",
+				"port_conf",
+				"dev2g5_3",
+				"dev5g_3",
+				"pcs5g_br_3",
+				"dev2g5_4",
+				"dev5g_4",
+				"pcs5g_br_4",
+				"dev2g5_5",
+				"dev5g_5",
+				"pcs5g_br_5",
+				"dev2g5_13",
+				"dev10g_1",
+				"pcs10g_br_1",
+				"dev2g5_24",
+				"dev2g5_25",
+				"dev2g5_26",
+				"dev2g5_27",
+				"dev2g5_28",
+				"dev2g5_29",
+				"dev2g5_30",
+				"dev2g5_31",
+				"dev2g5_48",
+				"dev10g_4",
+				"pcs10g_br_4",
+				"dev2g5_49",
+				"dev10g_5",
+				"pcs10g_br_5",
+				"dev2g5_50",
+				"dev10g_6",
+				"pcs10g_br_6",
+				"dev2g5_51",
+				"dev10g_7",
+				"pcs10g_br_7",
+				"dev2g5_52",
+				"dev10g_8",
+				"pcs10g_br_8",
+				"dev2g5_53",
+				"dev10g_9",
+				"pcs10g_br_9",
+				"dev2g5_54",
+				"dev10g_10",
+				"pcs10g_br_10",
+				"dev2g5_55",
+				"dev10g_11",
+				"pcs10g_br_11",
+				"dev2g5_56",
+				"dev25g_0",
+				"pcs25g_br_0",
+				"dev2g5_58",
+				"dev25g_2",
+				"pcs25g_br_2",
+				"dev2g5_61",
+				"dev25g_5",
+				"pcs25g_br_5",
+				"dev2g5_62",
+				"dev25g_6",
+				"pcs25g_br_6",
+				"dev2g5_63",
+				"dev25g_7",
+				"pcs25g_br_7",
+				"dsm",
+				"asm",
+				"gcb",
+				"qs",
+				"ana_acl",
+				"lrn",
+				"vcap_super",
+				"qsys",
+				"qfwd",
+				"xqs",
+				"clkgen",
+				"ana_ac_pol",
+				"qres",
+				"eacl",
+				"ana_cl",
+				"ana_l3",
+				"hsch",
+				"rew",
+				"ana_l2",
+				"ana_ac",
+				"vop";
+			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+		};
 	};
 };
diff --git a/arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi b/arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi
index 6820579448d0..f8623be51b57 100644
--- a/arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi
+++ b/arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi
@@ -7,30 +7,6 @@
 #include "sparx5_pcb_common.dtsi"
 
 /{
-	aliases {
-	    i2c0   = &i2c0;
-	    i2c100 = &i2c100;
-	    i2c101 = &i2c101;
-	    i2c102 = &i2c102;
-	    i2c103 = &i2c103;
-	    i2c104 = &i2c104;
-	    i2c105 = &i2c105;
-	    i2c106 = &i2c106;
-	    i2c107 = &i2c107;
-	    i2c108 = &i2c108;
-	    i2c109 = &i2c109;
-	    i2c110 = &i2c110;
-	    i2c111 = &i2c111;
-	    i2c112 = &i2c112;
-	    i2c113 = &i2c113;
-	    i2c114 = &i2c114;
-	    i2c115 = &i2c115;
-	    i2c116 = &i2c116;
-	    i2c117 = &i2c117;
-	    i2c118 = &i2c118;
-	    i2c119 = &i2c119;
-	};
-
 	gpio-restart {
 		compatible = "gpio-restart";
 		gpios = <&gpio 37 GPIO_ACTIVE_LOW>;
@@ -328,6 +304,11 @@ gpio@1 {
 	};
 };
 
+&sgpio2 {
+	status = "okay";
+	microchip,sgpio-port-ranges = <0 0>, <11 31>;
+};
+
 &gpio {
 	i2cmux_pins_i: i2cmux-pins-i {
 	       pins = "GPIO_16", "GPIO_17", "GPIO_18", "GPIO_19",
@@ -415,9 +396,9 @@ i2c0_emux: i2c0-emux@0 {
 
 &i2c0_imux {
 	pinctrl-names =
-		"i2c100", "i2c101", "i2c102", "i2c103",
-		"i2c104", "i2c105", "i2c106", "i2c107",
-		"i2c108", "i2c109", "i2c110", "i2c111", "idle";
+		"i2c_sfp1", "i2c_sfp2", "i2c_sfp3", "i2c_sfp4",
+		"i2c_sfp5", "i2c_sfp6", "i2c_sfp7", "i2c_sfp8",
+		"i2c_sfp9", "i2c_sfp10", "i2c_sfp11", "i2c_sfp12", "idle";
 	pinctrl-0 = <&i2cmux_0>;
 	pinctrl-1 = <&i2cmux_1>;
 	pinctrl-2 = <&i2cmux_2>;
@@ -431,62 +412,62 @@ &i2c0_imux {
 	pinctrl-10 = <&i2cmux_10>;
 	pinctrl-11 = <&i2cmux_11>;
 	pinctrl-12 = <&i2cmux_pins_i>;
-	i2c100: i2c_sfp1 {
+	i2c_sfp1: i2c_sfp1 {
 		reg = <0x0>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c101: i2c_sfp2 {
+	i2c_sfp2: i2c_sfp2 {
 		reg = <0x1>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c102: i2c_sfp3 {
+	i2c_sfp3: i2c_sfp3 {
 		reg = <0x2>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c103: i2c_sfp4 {
+	i2c_sfp4: i2c_sfp4 {
 		reg = <0x3>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c104: i2c_sfp5 {
+	i2c_sfp5: i2c_sfp5 {
 		reg = <0x4>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c105: i2c_sfp6 {
+	i2c_sfp6: i2c_sfp6 {
 		reg = <0x5>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c106: i2c_sfp7 {
+	i2c_sfp7: i2c_sfp7 {
 		reg = <0x6>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c107: i2c_sfp8 {
+	i2c_sfp8: i2c_sfp8 {
 		reg = <0x7>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c108: i2c_sfp9 {
+	i2c_sfp9: i2c_sfp9 {
 		reg = <0x8>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c109: i2c_sfp10 {
+	i2c_sfp10: i2c_sfp10 {
 		reg = <0x9>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c110: i2c_sfp11 {
+	i2c_sfp11: i2c_sfp11 {
 		reg = <0xa>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c111: i2c_sfp12 {
+	i2c_sfp12: i2c_sfp12 {
 		reg = <0xb>;
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -499,44 +480,393 @@ &gpio 60 GPIO_ACTIVE_HIGH
 		     &gpio 61 GPIO_ACTIVE_HIGH
 		     &gpio 54 GPIO_ACTIVE_HIGH>;
 	idle-state = <0x8>;
-	i2c112: i2c_sfp13 {
+	i2c_sfp13: i2c_sfp13 {
 		reg = <0x0>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c113: i2c_sfp14 {
+	i2c_sfp14: i2c_sfp14 {
 		reg = <0x1>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c114: i2c_sfp15 {
+	i2c_sfp15: i2c_sfp15 {
 		reg = <0x2>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c115: i2c_sfp16 {
+	i2c_sfp16: i2c_sfp16 {
 		reg = <0x3>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c116: i2c_sfp17 {
+	i2c_sfp17: i2c_sfp17 {
 		reg = <0x4>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c117: i2c_sfp18 {
+	i2c_sfp18: i2c_sfp18 {
 		reg = <0x5>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c118: i2c_sfp19 {
+	i2c_sfp19: i2c_sfp19 {
 		reg = <0x6>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c119: i2c_sfp20 {
+	i2c_sfp20: i2c_sfp20 {
 		reg = <0x7>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
 };
+
+&mdio3 {
+	status = "ok";
+	phy64: ethernet-phy@64 {
+		reg = <28>;
+	};
+};
+
+&axi {
+	sfp_eth12: sfp-eth12 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp1>;
+		tx-disable-gpios   = <&sgpio_out2 11 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 11 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 11 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 12 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth13: sfp-eth13 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp2>;
+		tx-disable-gpios   = <&sgpio_out2 12 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 12 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 12 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 13 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth14: sfp-eth14 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp3>;
+		tx-disable-gpios   = <&sgpio_out2 13 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 13 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 13 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 14 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth15: sfp-eth15 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp4>;
+		tx-disable-gpios   = <&sgpio_out2 14 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 14 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 14 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 15 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth48: sfp-eth48 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp5>;
+		tx-disable-gpios   = <&sgpio_out2 15 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 15 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 15 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 16 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth49: sfp-eth49 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp6>;
+		tx-disable-gpios   = <&sgpio_out2 16 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 16 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 16 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 17 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth50: sfp-eth50 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp7>;
+		tx-disable-gpios   = <&sgpio_out2 17 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 17 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 17 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 18 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth51: sfp-eth51 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp8>;
+		tx-disable-gpios   = <&sgpio_out2 18 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 18 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 18 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 19 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth52: sfp-eth52 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp9>;
+		tx-disable-gpios   = <&sgpio_out2 19 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 19 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 19 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 20 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth53: sfp-eth53 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp10>;
+		tx-disable-gpios   = <&sgpio_out2 20 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 20 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 20 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 21 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth54: sfp-eth54 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp11>;
+		tx-disable-gpios   = <&sgpio_out2 21 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 21 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 21 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 22 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth55: sfp-eth55 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp12>;
+		tx-disable-gpios   = <&sgpio_out2 22 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 22 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 22 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 23 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth56: sfp-eth56 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp13>;
+		tx-disable-gpios   = <&sgpio_out2 23 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 23 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 23 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 24 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth57: sfp-eth57 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp14>;
+		tx-disable-gpios   = <&sgpio_out2 24 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 24 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 24 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 25 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth58: sfp-eth58 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp15>;
+		tx-disable-gpios   = <&sgpio_out2 25 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 25 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 25 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 26 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth59: sfp-eth59 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp16>;
+		tx-disable-gpios   = <&sgpio_out2 26 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 26 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 26 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 27 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth60: sfp-eth60 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp17>;
+		tx-disable-gpios   = <&sgpio_out2 27 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 27 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 27 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 28 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth61: sfp-eth61 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp18>;
+		tx-disable-gpios   = <&sgpio_out2 28 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 28 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 28 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 29 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth62: sfp-eth62 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp19>;
+		tx-disable-gpios   = <&sgpio_out2 29 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 29 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 29 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 30 0 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth63: sfp-eth63 {
+		compatible	   = "sff,sfp";
+		i2c-bus	   = <&i2c_sfp20>;
+		tx-disable-gpios   = <&sgpio_out2 30 1 GPIO_ACTIVE_LOW>;
+		los-gpios	   = <&sgpio_in2 30 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios	   = <&sgpio_in2 30 2 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios	   = <&sgpio_in2 31 0 GPIO_ACTIVE_HIGH>;
+	};
+};
+
+&switch {
+	ethernet-ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		/* 10G SFPs */
+		port12: port@12 {
+			reg = <12>;
+			max-speed = <10000>;
+			phys = <&serdes 13>;
+			sfp = <&sfp_eth12>;
+			sd_sgpio = <301>;
+			managed = "in-band-status";
+		};
+		port13: port@13 {
+			reg = <13>;
+			/* Example: CU SFP, 1G speed */
+			max-speed = <10000>;
+			phys = <&serdes 14>;
+			sfp = <&sfp_eth13>;
+			sd_sgpio = <305>;
+			managed = "in-band-status";
+		};
+		port14: port@14 {
+			reg = <14>;
+			max-speed = <10000>;
+			phys = <&serdes 15>;
+			sfp = <&sfp_eth14>;
+			sd_sgpio = <309>;
+			managed = "in-band-status";
+		};
+		port15: port@15 {
+			reg = <15>;
+			max-speed = <10000>;
+			phys = <&serdes 16>;
+			sfp = <&sfp_eth15>;
+			sd_sgpio = <313>;
+			managed = "in-band-status";
+		};
+		port48: port@48 {
+			reg = <48>;
+			max-speed = <10000>;
+			phys = <&serdes 17>;
+			sfp = <&sfp_eth48>;
+			sd_sgpio = <317>;
+			managed = "in-band-status";
+		};
+		port49: port@49 {
+			reg = <49>;
+			max-speed = <10000>;
+			phys = <&serdes 18>;
+			sfp = <&sfp_eth49>;
+			sd_sgpio = <321>;
+			managed = "in-band-status";
+		};
+		port50: port@50 {
+			reg = <50>;
+			max-speed = <10000>;
+			phys = <&serdes 19>;
+			sfp = <&sfp_eth50>;
+			sd_sgpio = <325>;
+			managed = "in-band-status";
+		};
+		port51: port@51 {
+			reg = <51>;
+			max-speed = <10000>;
+			phys = <&serdes 20>;
+			sfp = <&sfp_eth51>;
+			sd_sgpio = <329>;
+			managed = "in-band-status";
+		};
+		port52: port@52 {
+			reg = <52>;
+			max-speed = <10000>;
+			phys = <&serdes 21>;
+			sfp = <&sfp_eth52>;
+			sd_sgpio = <333>;
+			managed = "in-band-status";
+		};
+		port53: port@53 {
+			reg = <53>;
+			max-speed = <10000>;
+			phys = <&serdes 22>;
+			sfp = <&sfp_eth53>;
+			sd_sgpio = <337>;
+			managed = "in-band-status";
+		};
+		port54: port@54 {
+			reg = <54>;
+			max-speed = <10000>;
+			phys = <&serdes 23>;
+			sfp = <&sfp_eth54>;
+			sd_sgpio = <341>;
+			managed = "in-band-status";
+		};
+		port55: port@55 {
+			reg = <55>;
+			max-speed = <10000>;
+			phys = <&serdes 24>;
+			sfp = <&sfp_eth55>;
+			sd_sgpio = <345>;
+			managed = "in-band-status";
+		};
+		/* 25G SFPs */
+		port56: port@56 {
+			reg = <56>;
+			max-speed = <10000>;
+			phys = <&serdes 25>;
+			sfp = <&sfp_eth56>;
+			sd_sgpio = <349>;
+			managed = "in-band-status";
+		};
+		port57: port@57 {
+			reg = <57>;
+			max-speed = <10000>;
+			phys = <&serdes 26>;
+			sfp = <&sfp_eth57>;
+			sd_sgpio = <353>;
+			managed = "in-band-status";
+		};
+		port58: port@58 {
+			reg = <58>;
+			max-speed = <10000>;
+			phys = <&serdes 27>;
+			sfp = <&sfp_eth58>;
+			sd_sgpio = <357>;
+			managed = "in-band-status";
+		};
+		port59: port@59 {
+			reg = <59>;
+			max-speed = <10000>;
+			phys = <&serdes 28>;
+			sfp = <&sfp_eth59>;
+			sd_sgpio = <361>;
+			managed = "in-band-status";
+		};
+		port60: port@60 {
+			reg = <60>;
+			max-speed = <10000>;
+			phys = <&serdes 29>;
+			sfp = <&sfp_eth60>;
+			sd_sgpio = <365>;
+			managed = "in-band-status";
+		};
+		port61: port@61 {
+			reg = <61>;
+			max-speed = <10000>;
+			phys = <&serdes 30>;
+			sfp = <&sfp_eth61>;
+			sd_sgpio = <369>;
+			managed = "in-band-status";
+		};
+		port62: port@62 {
+			reg = <62>;
+			max-speed = <10000>;
+			phys = <&serdes 31>;
+			sfp = <&sfp_eth62>;
+			sd_sgpio = <373>;
+			managed = "in-band-status";
+		};
+		port63: port@63 {
+			reg = <63>;
+			max-speed = <10000>;
+			phys = <&serdes 32>;
+			sfp = <&sfp_eth63>;
+			sd_sgpio = <377>;
+			managed = "in-band-status";
+		};
+		/* Finally the Management interface */
+		port64: port@64 {
+			reg = <64>;
+			max-speed = <1000>;
+			phys = <&serdes 0>;
+			phy-handle = <&phy64>;
+			phy-mode = "sgmii";
+		};
+	};
+};
diff --git a/arch/arm64/boot/dts/microchip/sparx5_pcb135_board.dtsi b/arch/arm64/boot/dts/microchip/sparx5_pcb135_board.dtsi
index e28c6dd16377..69e136c7bb9c 100644
--- a/arch/arm64/boot/dts/microchip/sparx5_pcb135_board.dtsi
+++ b/arch/arm64/boot/dts/microchip/sparx5_pcb135_board.dtsi
@@ -7,14 +7,6 @@
 #include "sparx5_pcb_common.dtsi"
 
 /{
-	aliases {
-	    i2c0   = &i2c0;
-	    i2c152 = &i2c152;
-	    i2c153 = &i2c153;
-	    i2c154 = &i2c154;
-	    i2c155 = &i2c155;
-	};
-
 	gpio-restart {
 		compatible = "gpio-restart";
 		gpios = <&gpio 37 GPIO_ACTIVE_LOW>;
@@ -138,6 +130,11 @@ gpio@1 {
 	};
 };
 
+&sgpio2 {
+	status = "okay";
+	microchip,sgpio-port-ranges = <0 0>, <16 18>, <28 31>;
+};
+
 &axi {
 	i2c0_imux: i2c0-imux@0 {
 		compatible = "i2c-mux-pinctrl";
@@ -149,31 +146,610 @@ i2c0_imux: i2c0-imux@0 {
 
 &i2c0_imux {
 	pinctrl-names =
-		"i2c152", "i2c153", "i2c154", "i2c155",
+		"i2c_sfp1", "i2c_sfp2", "i2c_sfp3", "i2c_sfp4",
 		"idle";
 	pinctrl-0 = <&i2cmux_s29>;
 	pinctrl-1 = <&i2cmux_s30>;
 	pinctrl-2 = <&i2cmux_s31>;
 	pinctrl-3 = <&i2cmux_s32>;
 	pinctrl-4 = <&i2cmux_pins_i>;
-	i2c152: i2c_sfp1 {
+	i2c_sfp1: i2c_sfp1 {
 		reg = <0x0>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c153: i2c_sfp2 {
+	i2c_sfp2: i2c_sfp2 {
 		reg = <0x1>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c154: i2c_sfp3 {
+	i2c_sfp3: i2c_sfp3 {
 		reg = <0x2>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
-	i2c155: i2c_sfp4 {
+	i2c_sfp4: i2c_sfp4 {
 		reg = <0x3>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
 };
+
+&axi {
+	sfp_eth60: sfp-eth60 {
+		compatible	   = "sff,sfp";
+		i2c-bus            = <&i2c_sfp1>;
+		tx-disable-gpios   = <&sgpio_out2 28 0 GPIO_ACTIVE_LOW>;
+		rate-select0-gpios = <&sgpio_out2 28 1 GPIO_ACTIVE_HIGH>;
+		los-gpios          = <&sgpio_in2 28 0 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios     = <&sgpio_in2 28 1 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios     = <&sgpio_in2 28 2 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth61: sfp-eth61 {
+		compatible         = "sff,sfp";
+		i2c-bus            = <&i2c_sfp2>;
+		tx-disable-gpios   = <&sgpio_out2 29 0 GPIO_ACTIVE_LOW>;
+		rate-select0-gpios = <&sgpio_out2 29 1 GPIO_ACTIVE_HIGH>;
+		los-gpios          = <&sgpio_in2 29 0 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios     = <&sgpio_in2 29 1 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios     = <&sgpio_in2 29 2 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth62: sfp-eth62 {
+		compatible         = "sff,sfp";
+		i2c-bus            = <&i2c_sfp3>;
+		tx-disable-gpios   = <&sgpio_out2 30 0 GPIO_ACTIVE_LOW>;
+		rate-select0-gpios = <&sgpio_out2 30 1 GPIO_ACTIVE_HIGH>;
+		los-gpios          = <&sgpio_in2 30 0 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios     = <&sgpio_in2 30 1 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios     = <&sgpio_in2 30 2 GPIO_ACTIVE_HIGH>;
+	};
+	sfp_eth63: sfp-eth63 {
+		compatible         = "sff,sfp";
+		i2c-bus            = <&i2c_sfp4>;
+		tx-disable-gpios   = <&sgpio_out2 31 0 GPIO_ACTIVE_LOW>;
+		rate-select0-gpios = <&sgpio_out2 31 1 GPIO_ACTIVE_HIGH>;
+		los-gpios          = <&sgpio_in2 31 0 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios     = <&sgpio_in2 31 1 GPIO_ACTIVE_LOW>;
+		tx-fault-gpios     = <&sgpio_in2 31 2 GPIO_ACTIVE_HIGH>;
+	};
+};
+
+&mdio0 {
+	status = "ok";
+	phy0: ethernet-phy@0 {
+		reg = <0>;
+	};
+	phy1: ethernet-phy@1 {
+		reg = <1>;
+	};
+	phy2: ethernet-phy@2 {
+		reg = <2>;
+	};
+	phy3: ethernet-phy@3 {
+		reg = <3>;
+	};
+	phy4: ethernet-phy@4 {
+		reg = <4>;
+	};
+	phy5: ethernet-phy@5 {
+		reg = <5>;
+	};
+	phy6: ethernet-phy@6 {
+		reg = <6>;
+	};
+	phy7: ethernet-phy@7 {
+		reg = <7>;
+	};
+	phy8: ethernet-phy@8 {
+		reg = <8>;
+	};
+	phy9: ethernet-phy@9 {
+		reg = <9>;
+	};
+	phy10: ethernet-phy@10 {
+		reg = <10>;
+	};
+	phy11: ethernet-phy@11 {
+		reg = <11>;
+	};
+	phy12: ethernet-phy@12 {
+		reg = <12>;
+	};
+	phy13: ethernet-phy@13 {
+		reg = <13>;
+	};
+	phy14: ethernet-phy@14 {
+		reg = <14>;
+	};
+	phy15: ethernet-phy@15 {
+		reg = <15>;
+	};
+	phy16: ethernet-phy@16 {
+		reg = <16>;
+	};
+	phy17: ethernet-phy@17 {
+		reg = <17>;
+	};
+	phy18: ethernet-phy@18 {
+		reg = <18>;
+	};
+	phy19: ethernet-phy@19 {
+		reg = <19>;
+	};
+	phy20: ethernet-phy@20 {
+		reg = <20>;
+	};
+	phy21: ethernet-phy@21 {
+		reg = <21>;
+	};
+	phy22: ethernet-phy@22 {
+		reg = <22>;
+	};
+	phy23: ethernet-phy@23 {
+		reg = <23>;
+	};
+};
+
+&mdio1 {
+	status = "ok";
+	phy24: ethernet-phy@24 {
+		reg = <0>;
+	};
+	phy25: ethernet-phy@25 {
+		reg = <1>;
+	};
+	phy26: ethernet-phy@26 {
+		reg = <2>;
+	};
+	phy27: ethernet-phy@27 {
+		reg = <3>;
+	};
+	phy28: ethernet-phy@28 {
+		reg = <4>;
+	};
+	phy29: ethernet-phy@29 {
+		reg = <5>;
+	};
+	phy30: ethernet-phy@30 {
+		reg = <6>;
+	};
+	phy31: ethernet-phy@31 {
+		reg = <7>;
+	};
+	phy32: ethernet-phy@32 {
+		reg = <8>;
+	};
+	phy33: ethernet-phy@33 {
+		reg = <9>;
+	};
+	phy34: ethernet-phy@34 {
+		reg = <10>;
+	};
+	phy35: ethernet-phy@35 {
+		reg = <11>;
+	};
+	phy36: ethernet-phy@36 {
+		reg = <12>;
+	};
+	phy37: ethernet-phy@37 {
+		reg = <13>;
+	};
+	phy38: ethernet-phy@38 {
+		reg = <14>;
+	};
+	phy39: ethernet-phy@39 {
+		reg = <15>;
+	};
+	phy40: ethernet-phy@40 {
+		reg = <16>;
+	};
+	phy41: ethernet-phy@41 {
+		reg = <17>;
+	};
+	phy42: ethernet-phy@42 {
+		reg = <18>;
+	};
+	phy43: ethernet-phy@43 {
+		reg = <19>;
+	};
+	phy44: ethernet-phy@44 {
+		reg = <20>;
+	};
+	phy45: ethernet-phy@45 {
+		reg = <21>;
+	};
+	phy46: ethernet-phy@46 {
+		reg = <22>;
+	};
+	phy47: ethernet-phy@47 {
+		reg = <23>;
+	};
+};
+
+&mdio3 {
+	status = "ok";
+	phy64: ethernet-phy@64 {
+		reg = <28>;
+	};
+};
+
+&switch {
+	ethernet-ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port0: port@0 {
+			reg = <0>;
+			max-speed = <1000>;
+			phys = <&serdes 13>;
+			phy-handle = <&phy0>;
+			phy-mode = "qsgmii";
+		};
+		port1: port@1 {
+			reg = <1>;
+			max-speed = <1000>;
+			phys = <&serdes 13>;
+			phy-handle = <&phy1>;
+			phy-mode = "qsgmii";
+		};
+		port2: port@2 {
+			reg = <2>;
+			max-speed = <1000>;
+			phys = <&serdes 13>;
+			phy-handle = <&phy2>;
+			phy-mode = "qsgmii";
+		};
+		port3: port@3 {
+			reg = <3>;
+			max-speed = <1000>;
+			phys = <&serdes 13>;
+			phy-handle = <&phy3>;
+			phy-mode = "qsgmii";
+		};
+		port4: port@4 {
+			reg = <4>;
+			max-speed = <1000>;
+			phys = <&serdes 14>;
+			phy-handle = <&phy4>;
+			phy-mode = "qsgmii";
+		};
+		port5: port@5 {
+			reg = <5>;
+			max-speed = <1000>;
+			phys = <&serdes 14>;
+			phy-handle = <&phy5>;
+			phy-mode = "qsgmii";
+		};
+		port6: port@6 {
+			reg = <6>;
+			max-speed = <1000>;
+			phys = <&serdes 14>;
+			phy-handle = <&phy6>;
+			phy-mode = "qsgmii";
+		};
+		port7: port@7 {
+			reg = <7>;
+			max-speed = <1000>;
+			phys = <&serdes 14>;
+			phy-handle = <&phy7>;
+			phy-mode = "qsgmii";
+		};
+		port8: port@8 {
+			reg = <8>;
+			max-speed = <1000>;
+			phys = <&serdes 15>;
+			phy-handle = <&phy8>;
+			phy-mode = "qsgmii";
+		};
+		port9: port@9 {
+			reg = <9>;
+			max-speed = <1000>;
+			phys = <&serdes 15>;
+			phy-handle = <&phy9>;
+			phy-mode = "qsgmii";
+		};
+		port10: port@10 {
+			reg = <10>;
+			max-speed = <1000>;
+			phys = <&serdes 15>;
+			phy-handle = <&phy10>;
+			phy-mode = "qsgmii";
+		};
+		port11: port@11 {
+			reg = <11>;
+			max-speed = <1000>;
+			phys = <&serdes 15>;
+			phy-handle = <&phy11>;
+			phy-mode = "qsgmii";
+		};
+		port12: port@12 {
+			reg = <12>;
+			max-speed = <1000>;
+			phys = <&serdes 16>;
+			phy-handle = <&phy12>;
+			phy-mode = "qsgmii";
+		};
+		port13: port@13 {
+			reg = <13>;
+			max-speed = <1000>;
+			phys = <&serdes 16>;
+			phy-handle = <&phy13>;
+			phy-mode = "qsgmii";
+		};
+		port14: port@14 {
+			reg = <14>;
+			max-speed = <1000>;
+			phys = <&serdes 16>;
+			phy-handle = <&phy14>;
+			phy-mode = "qsgmii";
+		};
+		port15: port@15 {
+			reg = <15>;
+			max-speed = <1000>;
+			phys = <&serdes 16>;
+			phy-handle = <&phy15>;
+			phy-mode = "qsgmii";
+		};
+		port16: port@16 {
+			reg = <16>;
+			max-speed = <1000>;
+			phys = <&serdes 17>;
+			phy-handle = <&phy16>;
+			phy-mode = "qsgmii";
+		};
+		port17: port@17 {
+			reg = <17>;
+			max-speed = <1000>;
+			phys = <&serdes 17>;
+			phy-handle = <&phy17>;
+			phy-mode = "qsgmii";
+		};
+		port18: port@18 {
+			reg = <18>;
+			max-speed = <1000>;
+			phys = <&serdes 17>;
+			phy-handle = <&phy18>;
+			phy-mode = "qsgmii";
+		};
+		port19: port@19 {
+			reg = <19>;
+			max-speed = <1000>;
+			phys = <&serdes 17>;
+			phy-handle = <&phy19>;
+			phy-mode = "qsgmii";
+		};
+		port20: port@20 {
+			reg = <20>;
+			max-speed = <1000>;
+			phys = <&serdes 18>;
+			phy-handle = <&phy20>;
+			phy-mode = "qsgmii";
+		};
+		port21: port@21 {
+			reg = <21>;
+			max-speed = <1000>;
+			phys = <&serdes 18>;
+			phy-handle = <&phy21>;
+			phy-mode = "qsgmii";
+		};
+		port22: port@22 {
+			reg = <22>;
+			max-speed = <1000>;
+			phys = <&serdes 18>;
+			phy-handle = <&phy22>;
+			phy-mode = "qsgmii";
+		};
+		port23: port@23 {
+			reg = <23>;
+			max-speed = <1000>;
+			phys = <&serdes 18>;
+			phy-handle = <&phy23>;
+			phy-mode = "qsgmii";
+		};
+		port24: port@24 {
+			reg = <24>;
+			max-speed = <1000>;
+			phys = <&serdes 19>;
+			phy-handle = <&phy24>;
+			phy-mode = "qsgmii";
+		};
+		port25: port@25 {
+			reg = <25>;
+			max-speed = <1000>;
+			phys = <&serdes 19>;
+			phy-handle = <&phy25>;
+			phy-mode = "qsgmii";
+		};
+		port26: port@26 {
+			reg = <26>;
+			max-speed = <1000>;
+			phys = <&serdes 19>;
+			phy-handle = <&phy26>;
+			phy-mode = "qsgmii";
+		};
+		port27: port@27 {
+			reg = <27>;
+			max-speed = <1000>;
+			phys = <&serdes 19>;
+			phy-handle = <&phy27>;
+			phy-mode = "qsgmii";
+		};
+		port28: port@28 {
+			reg = <28>;
+			max-speed = <1000>;
+			phys = <&serdes 20>;
+			phy-handle = <&phy28>;
+			phy-mode = "qsgmii";
+		};
+		port29: port@29 {
+			reg = <29>;
+			max-speed = <1000>;
+			phys = <&serdes 20>;
+			phy-handle = <&phy29>;
+			phy-mode = "qsgmii";
+		};
+		port30: port@30 {
+			reg = <30>;
+			max-speed = <1000>;
+			phys = <&serdes 20>;
+			phy-handle = <&phy30>;
+			phy-mode = "qsgmii";
+		};
+		port31: port@31 {
+			reg = <31>;
+			max-speed = <1000>;
+			phys = <&serdes 20>;
+			phy-handle = <&phy31>;
+			phy-mode = "qsgmii";
+		};
+		port32: port@32 {
+			reg = <32>;
+			max-speed = <1000>;
+			phys = <&serdes 21>;
+			phy-handle = <&phy32>;
+			phy-mode = "qsgmii";
+		};
+		port33: port@33 {
+			reg = <33>;
+			max-speed = <1000>;
+			phys = <&serdes 21>;
+			phy-handle = <&phy33>;
+			phy-mode = "qsgmii";
+		};
+		port34: port@34 {
+			reg = <34>;
+			max-speed = <1000>;
+			phys = <&serdes 21>;
+			phy-handle = <&phy34>;
+			phy-mode = "qsgmii";
+		};
+		port35: port@35 {
+			reg = <35>;
+			max-speed = <1000>;
+			phys = <&serdes 21>;
+			phy-handle = <&phy35>;
+			phy-mode = "qsgmii";
+		};
+		port36: port@36 {
+			reg = <36>;
+			max-speed = <1000>;
+			phys = <&serdes 22>;
+			phy-handle = <&phy36>;
+			phy-mode = "qsgmii";
+		};
+		port37: port@37 {
+			reg = <37>;
+			max-speed = <1000>;
+			phys = <&serdes 22>;
+			phy-handle = <&phy37>;
+			phy-mode = "qsgmii";
+		};
+		port38: port@38 {
+			reg = <38>;
+			max-speed = <1000>;
+			phys = <&serdes 22>;
+			phy-handle = <&phy38>;
+			phy-mode = "qsgmii";
+		};
+		port39: port@39 {
+			reg = <39>;
+			max-speed = <1000>;
+			phys = <&serdes 22>;
+			phy-handle = <&phy39>;
+			phy-mode = "qsgmii";
+		};
+		port40: port@40 {
+			reg = <40>;
+			max-speed = <1000>;
+			phys = <&serdes 23>;
+			phy-handle = <&phy40>;
+			phy-mode = "qsgmii";
+		};
+		port41: port@41 {
+			reg = <41>;
+			max-speed = <1000>;
+			phys = <&serdes 23>;
+			phy-handle = <&phy41>;
+			phy-mode = "qsgmii";
+		};
+		port42: port@42 {
+			reg = <42>;
+			max-speed = <1000>;
+			phys = <&serdes 23>;
+			phy-handle = <&phy42>;
+			phy-mode = "qsgmii";
+		};
+		port43: port@43 {
+			reg = <43>;
+			max-speed = <1000>;
+			phys = <&serdes 23>;
+			phy-handle = <&phy43>;
+			phy-mode = "qsgmii";
+		};
+		port44: port@44 {
+			reg = <44>;
+			max-speed = <1000>;
+			phys = <&serdes 24>;
+			phy-handle = <&phy44>;
+			phy-mode = "qsgmii";
+		};
+		port45: port@45 {
+			reg = <45>;
+			max-speed = <1000>;
+			phys = <&serdes 24>;
+			phy-handle = <&phy45>;
+			phy-mode = "qsgmii";
+		};
+		port46: port@46 {
+			reg = <46>;
+			max-speed = <1000>;
+			phys = <&serdes 24>;
+			phy-handle = <&phy46>;
+			phy-mode = "qsgmii";
+		};
+		port47: port@47 {
+			reg = <47>;
+			max-speed = <1000>;
+			phys = <&serdes 24>;
+			phy-handle = <&phy47>;
+			phy-mode = "qsgmii";
+		};
+		/* Then the 25G interfaces */
+		port60: port@60 {
+			reg = <60>;
+			max-speed = <25000>;
+			phys = <&serdes 29>;
+			sfp = <&sfp_eth60>;
+			managed = "in-band-status";
+		};
+		port61: port@61 {
+			reg = <61>;
+			max-speed = <25000>;
+			phys = <&serdes 30>;
+			sfp = <&sfp_eth61>;
+			managed = "in-band-status";
+		};
+		port62: port@62 {
+			reg = <62>;
+			max-speed = <25000>;
+			phys = <&serdes 31>;
+			sfp = <&sfp_eth62>;
+			managed = "in-band-status";
+		};
+		port63: port@63 {
+			reg = <63>;
+			max-speed = <25000>;
+			phys = <&serdes 32>;
+			sfp = <&sfp_eth63>;
+			managed = "in-band-status";
+		};
+		/* Finally the Management interface */
+		port64: port@64 {
+			reg = <64>;
+			max-speed = <1000>;
+			phys = <&serdes 0>;
+			phy-handle = <&phy64>;
+			phy-mode = "sgmii";
+		};
+	};
+};
-- 
2.29.2

