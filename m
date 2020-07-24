Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9585622C3BB
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 12:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgGXKvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 06:51:03 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:47401 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgGXKvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 06:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595587860; x=1627123860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v01tkWUdORXuHcdZgKdzCR2DYTMtnu+b8G1LhSG61YE=;
  b=OeA17bSAoev5BpBmxQyUkaQRI3K12JtjGID2Pj4WXRMj+egvgyk9ckGd
   JmI8bKTFRrdcYWvfmUrdW1Ce2RKfdGkwL6DoYCzkl3C0ROV38XFDlBLJe
   C9e8GdyNO+TdI0TOeCIuDus8DSLr7SkDnO4Av70w+CjIG6ub/KkyxRR2k
   +gVcGFJ9FGP9H9I2WzaYIYWaB+SS+4NIiYDc+qIVf4eqSMuafcYc65EiX
   Nt+MRoX7TQNMyxfzCshBJwtQ8gXaT8BXjK/bm7hKTA6VWtsNW8Y4Rccj8
   ppjyyB4TXucKVzceXUGXL0P066Xizg6t/DAFwlZsTi7g5Li/geHxBZjza
   Q==;
IronPort-SDR: SaqkwTbO/lkKuuZgOThH7to0C5oUJgcOqhkJDZoLdvT4D+sLmZv1fYRhF9BKLUsVU0v97CLspg
 wziDSJWUHFYoJBsrm8ehLQBc+nmRMeTB3eQYeNoIhngVJyIG/h2UfXBuRpSAnBwTA6n1HmzwC/
 fwzOqNxrjaySZFjRTRFa0HjM004JAFCRB4wvnXLRc3ZErLOv184mpSMqKJpnkFNyRlqAb2H+Y3
 AWTxMDV+N6hLD1XqhMQRmYxCGQNQ0WVSqUZtAFs6pCiP3c0fogIxmj9FxQQSR/EQEacFfUtlUZ
 Ey0=
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="88983317"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2020 03:50:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 03:50:19 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 24 Jul 2020 03:50:14 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next v3 4/7] ARM: dts: at91: sama5d2: add an mdio sub-node to macb
Date:   Fri, 24 Jul 2020 13:50:30 +0300
Message-ID: <20200724105033.2124881-5-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
References: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new macb bindings and add an mdio sub-node to contain all the
phy nodes.

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---

Changes in v3:
 - added tag from Florian

Changes in v2:
 - none

 arch/arm/boot/dts/at91-sama5d27_som1.dtsi   | 16 ++++++++++------
 arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi | 17 ++++++++++-------
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts   | 13 ++++++++-----
 arch/arm/boot/dts/at91-sama5d2_xplained.dts | 12 ++++++++----
 4 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d27_som1.dtsi b/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
index b1f994c0ae79..dfcee23dcce0 100644
--- a/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
+++ b/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
@@ -84,12 +84,16 @@ macb0: ethernet@f8008000 {
 				pinctrl-0 = <&pinctrl_macb0_default>;
 				phy-mode = "rmii";
 
-				ethernet-phy@0 {
-					reg = <0x0>;
-					interrupt-parent = <&pioA>;
-					interrupts = <PIN_PD31 IRQ_TYPE_LEVEL_LOW>;
-					pinctrl-names = "default";
-					pinctrl-0 = <&pinctrl_macb0_phy_irq>;
+				mdio {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					ethernet-phy@0 {
+						reg = <0x0>;
+						interrupt-parent = <&pioA>;
+						interrupts = <PIN_PD31 IRQ_TYPE_LEVEL_LOW>;
+						pinctrl-names = "default";
+						pinctrl-0 = <&pinctrl_macb0_phy_irq>;
+					};
 				};
 			};
 
diff --git a/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi b/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
index a06700e53e4c..9c4dce29d2fe 100644
--- a/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
+++ b/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
@@ -181,13 +181,16 @@ &macb0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_macb0_default>;
 	phy-mode = "rmii";
-
-	ethernet-phy@0 {
-		reg = <0x0>;
-		interrupt-parent = <&pioA>;
-		interrupts = <PIN_PB24 IRQ_TYPE_LEVEL_LOW>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&pinctrl_macb0_phy_irq>;
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		ethernet-phy@0 {
+			reg = <0x0>;
+			interrupt-parent = <&pioA>;
+			interrupts = <PIN_PB24 IRQ_TYPE_LEVEL_LOW>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_macb0_phy_irq>;
+		};
 	};
 };
 
diff --git a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
index c894c7c788a9..fc3375c43ef6 100644
--- a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
@@ -140,11 +140,14 @@ macb0: ethernet@f8008000 {
 				pinctrl-0 = <&pinctrl_macb0_default &pinctrl_macb0_phy_irq>;
 				phy-mode = "rmii";
 				status = "okay";
-
-				ethernet-phy@1 {
-					reg = <0x1>;
-					interrupt-parent = <&pioA>;
-					interrupts = <56 IRQ_TYPE_LEVEL_LOW>;
+				mdio {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					ethernet-phy@1 {
+						reg = <0x1>;
+						interrupt-parent = <&pioA>;
+						interrupts = <56 IRQ_TYPE_LEVEL_LOW>;
+					};
 				};
 			};
 
diff --git a/arch/arm/boot/dts/at91-sama5d2_xplained.dts b/arch/arm/boot/dts/at91-sama5d2_xplained.dts
index a927165ea7c2..a62f475d9d0a 100644
--- a/arch/arm/boot/dts/at91-sama5d2_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_xplained.dts
@@ -149,10 +149,14 @@ macb0: ethernet@f8008000 {
 				phy-mode = "rmii";
 				status = "okay";
 
-				ethernet-phy@1 {
-					reg = <0x1>;
-					interrupt-parent = <&pioA>;
-					interrupts = <PIN_PC9 IRQ_TYPE_LEVEL_LOW>;
+				mdio {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					ethernet-phy@1 {
+						reg = <0x1>;
+						interrupt-parent = <&pioA>;
+						interrupts = <PIN_PC9 IRQ_TYPE_LEVEL_LOW>;
+					};
 				};
 			};
 
-- 
2.25.1

