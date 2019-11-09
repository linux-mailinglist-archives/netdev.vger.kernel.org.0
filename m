Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7EEF5FE9
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 16:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfKIPRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 10:17:07 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:43252 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfKIPQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 10:16:49 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA9FGga9101322;
        Sat, 9 Nov 2019 09:16:42 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1573312602;
        bh=ev8TwWPRRUGNWW0e0DSMY6L3jAmXyGZdE2LhdK+82XU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=yBQyA14KlBubFpveu+k8o9FhRMMYazMjL7O3oOuidJjqwKoZ4jGNp0r5iosV85z7b
         EezgTwu0BKJ2cPo/qnRR582yC9114yfp3AEg29tla/ztMaVVFHPzNo873bdKungUxu
         8rF6wco1MNd2bZTISpyIn6VgK5p/7eTkgIfR5vxw=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA9FGglJ089020
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 9 Nov 2019 09:16:42 -0600
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Sat, 9 Nov
 2019 09:16:26 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Sat, 9 Nov 2019 09:16:26 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA9FGfJh048765;
        Sat, 9 Nov 2019 09:16:41 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v6 net-next 11/13] ARM: dts: dra7: add dt nodes for new cpsw switch dev driver
Date:   Sat, 9 Nov 2019 17:15:23 +0200
Message-ID: <20191109151525.18651-12-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109151525.18651-1-grygorii.strashko@ti.com>
References: <20191109151525.18651-1-grygorii.strashko@ti.com>
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
 arch/arm/boot/dts/dra7-l4.dtsi | 52 ++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
index 5cac2dd58241..2f3a19edc7af 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -3079,6 +3079,58 @@
 					phys = <&phy_gmii_sel 2>;
 				};
 			};
+
+			mac_sw: switch@0 {
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
+				ethernet-ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					cpsw_port1: port@1 {
+						reg = <1>;
+						label = "port1";
+						mac-address = [ 00 00 00 00 00 00 ];
+						phys = <&phy_gmii_sel 1>;
+					};
+
+					cpsw_port2: port@2 {
+						reg = <2>;
+						label = "port2";
+						mac-address = [ 00 00 00 00 00 00 ];
+						phys = <&phy_gmii_sel 2>;
+					};
+				};
+
+				davinci_mdio_sw: mdio@1000 {
+					compatible = "ti,cpsw-mdio","ti,davinci_mdio";
+					clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 0>;
+					clock-names = "fck";
+					#address-cells = <1>;
+					#size-cells = <0>;
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

