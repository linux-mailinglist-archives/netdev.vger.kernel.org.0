Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43594EE8C
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 20:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfFUSOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 14:14:38 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:45840 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFUSOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 14:14:37 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5LIEKUe064094;
        Fri, 21 Jun 2019 13:14:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561140861;
        bh=c567k59bl9GhUXD6MZLrFuS7siN1KwQDSBU2GK/glqk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=De1k8mvxYmhXLaUHCvxvXNCQHoWcAiRLGtowdkWPtsRTGuMOnxKVCIXg7J4f5KkeZ
         i3lYTBiN/kVeZH8b7dfeVHU5yUHlT7q6gFVzH5sJBB6jmBGolBdp1EhcZCLRITRWU1
         Gl8Nyrz6fRbaAe2sgd1r0klsJYAmR1+teAITBsqg=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5LIEK80003544
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Jun 2019 13:14:20 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 21
 Jun 2019 13:14:20 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 21 Jun 2019 13:14:20 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5LIEJd2114017;
        Fri, 21 Jun 2019 13:14:20 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v4 net-next 10/11] ARM: dts: am57xx-idk: add dt nodes for new cpsw switch dev driver
Date:   Fri, 21 Jun 2019 21:13:13 +0300
Message-ID: <20190621181314.20778-11-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190621181314.20778-1-grygorii.strashko@ti.com>
References: <20190621181314.20778-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DT nodes for new cpsw switch dev driver.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/boot/dts/am571x-idk.dts         | 28 +++++++++++++
 arch/arm/boot/dts/am572x-idk.dts         |  5 +++
 arch/arm/boot/dts/am574x-idk.dts         |  5 +++
 arch/arm/boot/dts/am57xx-idk-common.dtsi |  2 +-
 arch/arm/boot/dts/dra7-l4.dtsi           | 53 ++++++++++++++++++++++++
 5 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am571x-idk.dts b/arch/arm/boot/dts/am571x-idk.dts
index 66116ad3f9f4..9262e008c968 100644
--- a/arch/arm/boot/dts/am571x-idk.dts
+++ b/arch/arm/boot/dts/am571x-idk.dts
@@ -194,3 +194,31 @@
 	pinctrl-1 = <&mmc2_pins_hs>;
 	pinctrl-2 = <&mmc2_pins_ddr_rev20 &mmc2_iodelay_ddr_conf>;
 };
+
+&mac_sw {
+	pinctrl-names = "default", "sleep";
+	status = "okay";
+};
+
+&cpsw_port1 {
+	phy-handle = <&ethphy0_sw>;
+	phy-mode = "rgmii";
+	ti,dual_emac_pvid = <1>;
+};
+
+&cpsw_port2 {
+	phy-handle = <&ethphy1_sw>;
+	phy-mode = "rgmii";
+	ti,dual_emac_pvid = <2>;
+};
+
+&davinci_mdio_sw {
+	ethphy0_sw: ethernet-phy@0 {
+		reg = <0>;
+	};
+
+	ethphy1_sw: ethernet-phy@1 {
+		reg = <1>;
+	};
+};
+
diff --git a/arch/arm/boot/dts/am572x-idk.dts b/arch/arm/boot/dts/am572x-idk.dts
index 4f835222c266..1664866c46d5 100644
--- a/arch/arm/boot/dts/am572x-idk.dts
+++ b/arch/arm/boot/dts/am572x-idk.dts
@@ -35,3 +35,8 @@
 	pinctrl-1 = <&mmc2_pins_hs>;
 	pinctrl-2 = <&mmc2_pins_ddr_rev20>;
 };
+
+&mac {
+	status = "okay";
+	dual_emac;
+};
\ No newline at end of file
diff --git a/arch/arm/boot/dts/am574x-idk.dts b/arch/arm/boot/dts/am574x-idk.dts
index dc5141c35610..f4834296bd54 100644
--- a/arch/arm/boot/dts/am574x-idk.dts
+++ b/arch/arm/boot/dts/am574x-idk.dts
@@ -40,3 +40,8 @@
 	pinctrl-1 = <&mmc2_pins_default>;
 	pinctrl-2 = <&mmc2_pins_default>;
 };
+
+&mac {
+	status = "okay";
+	dual_emac;
+};
\ No newline at end of file
diff --git a/arch/arm/boot/dts/am57xx-idk-common.dtsi b/arch/arm/boot/dts/am57xx-idk-common.dtsi
index f7bd26458915..5c7663699efa 100644
--- a/arch/arm/boot/dts/am57xx-idk-common.dtsi
+++ b/arch/arm/boot/dts/am57xx-idk-common.dtsi
@@ -367,7 +367,7 @@
 };
 
 &mac {
-	status = "okay";
+//	status = "okay";
 	dual_emac;
 };
 
diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
index fe9f0bc29fec..2bd750c95328 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -3122,6 +3122,59 @@
 					phys = <&phy_gmii_sel 2>;
 				};
 			};
+
+			mac_sw: ethernet_switch@0 {
+				compatible = "ti,dra7-cpsw-switch","ti,cpsw-switch";
+				reg = <0x0 0x4000>;
+				ranges = <0 0 0x4000>;
+				clocks = <&gmac_main_clk>;
+				clock-names = "fck";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				syscon = <&scm_conf>;
+				status = "disabled";
+
+				interrupts = <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "rx_thresh", "rx", "tx", "misc";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					cpsw_port1: port@1 {
+						reg = <1>;
+						ti,label = "port1";
+						/* Filled in by U-Boot */
+						mac-address = [ 00 00 00 00 00 00 ];
+						phys = <&phy_gmii_sel 1>;
+					};
+
+					cpsw_port2: port@2 {
+						reg = <2>;
+						ti,label = "port2";
+						/* Filled in by U-Boot */
+						mac-address = [ 00 00 00 00 00 00 ];
+						phys = <&phy_gmii_sel 2>;
+					};
+				};
+
+				davinci_mdio_sw: mdio@1000 {
+					compatible = "ti,cpsw-mdio","ti,davinci_mdio";
+					#address-cells = <1>;
+					#size-cells = <0>;
+					ti,hwmods = "davinci_mdio";
+					bus_freq = <1000000>;
+					reg = <0x1000 0x100>;
+				};
+
+				cpts {
+					clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 25>;
+					clock-names = "cpts";
+				};
+			};
 		};
 	};
 };
-- 
2.17.1

