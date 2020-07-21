Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9DC227C7D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgGUKF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 06:05:59 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:43131 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgGUKF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 06:05:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595325958; x=1626861958;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V7QA9fOBK/Nnfx+GsuG3sKtcsrkZjHyHbu6bk9klVhM=;
  b=q2ejHHr+DCb9L+nJhXCQ8+TCpItJf+aLeRDBHyIlpoR9FzM9ZjHkK0Ya
   QTPDFKwo98f/ihoHW3hz0ughRUKZ/Gx73+l/tUts9sEOijSh42w1tdhmn
   JBdNRrsC5fWwH7JQk3EN0RrdMgrvGSEMqhpksCnXZjY04O9c7xUm8sdMH
   3LXUzOW3EKDosp4gjbQWti3QkyDfydyZz7ITC+ZFbMQVnvFPGfdBopXFk
   C6O+dixw69BTIKf3piYMCwbXAKarX6ewXZkrply+1gn/AttnbOirI6wbT
   CVSN3JzVg87hT7cDLCzditMuOdT9Oyl55uiZtsq+Me9PeTXczKk3LNq3X
   Q==;
IronPort-SDR: Z4fx6oc9z02gAoIOJw4m5Bk7jUwcKj0hH+5StqWXfUAeAGiBMnetAEg3z+qO5+vYuB411xOjCH
 2EzBejowIXaXG+UCEk1N9d/U5JIUFikrXxxdodWpJqiMYpA1Y0RSfqS0L3bsI9VHfV93F1DiF3
 BSZX8/bZIBVGZwA83BgKAx6UcYioSwMoI4+arY8iXMzARE9DejxL9I9QhuPQmDhnoOhnje1McL
 i0gHEqhdnnXzZcfzsL4eTgesB3rhHOD07sjTbvmik/vn1qs/zbBEp9pP7wO6nbNMN1wjibl2Gs
 yXQ=
X-IronPort-AV: E=Sophos;i="5.75,378,1589266800"; 
   d="scan'208";a="84004761"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 03:05:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 03:05:52 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 03:04:33 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next 4/7] ARM: dts: at91: sama5d2: add an mdio sub-node to macb
Date:   Tue, 21 Jul 2020 13:02:31 +0300
Message-ID: <20200721100234.1302910-5-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
References: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
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
---
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

