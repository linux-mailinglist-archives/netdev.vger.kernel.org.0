Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA41169012
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 16:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbgBVP6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 10:58:54 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:51330 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbgBVP6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 10:58:53 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01MFwpbh020457;
        Sat, 22 Feb 2020 09:58:51 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582387131;
        bh=7gOG68lQaWq6c+Fm3gWozt94N4p9t3c4pd76WGOE5DU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=en1Ev8LI9HhUHCkVbyMpQJaT4exebmbrzMWY6Sht+FiZddRvVK0tjzqmRnbm2qQoZ
         lYO28ExfDGq++h1qra5dUux//BAQvx0NjQnd333kfr1pOG0Z+awE+++51gCT2WNh0b
         Q1JHGrTRe67smUbwGCuAFKycF1XS3wOAnbilfmyQ=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01MFwp5O064160
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 22 Feb 2020 09:58:51 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Sat, 22
 Feb 2020 09:58:50 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Sat, 22 Feb 2020 09:58:50 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01MFwnMX112631;
        Sat, 22 Feb 2020 09:58:50 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Roger Quadros <rogerq@ti.com>, Tero Kristo <t-kristo@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
CC:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 8/9] arm64: dts: ti: k3-j721e-mcu: add mcu cpsw nuss node
Date:   Sat, 22 Feb 2020 17:57:51 +0200
Message-ID: <20200222155752.22021-9-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200222155752.22021-1-grygorii.strashko@ti.com>
References: <20200222155752.22021-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DT node for The TI J721E MCU SoC Gigabit Ethernet
subsystem (MCU CPSW2G NUSS).

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../boot/dts/ti/k3-j721e-mcu-wakeup.dtsi      | 49 +++++++++++++++++++
 arch/arm64/boot/dts/ti/k3-j721e.dtsi          |  1 +
 2 files changed, 50 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
index 9b3d10241a2e..b27ee15515a1 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
@@ -284,4 +284,53 @@
 			ti,sci-rm-range-rflow = <0x00>; /* GP RFLOW */
 		};
 	};
+
+	mcu_cpsw: ethernet@46000000 {
+		compatible = "ti,j721e-cpsw-nuss";
+		#address-cells = <2>;
+		#size-cells = <2>;
+		reg = <0x0 0x46000000 0x0 0x200000>;
+		reg-names = "cpsw_nuss";
+		ranges = <0x0 0x0 0x0 0x46000000 0x0 0x200000>;
+		dma-coherent;
+		clocks = <&k3_clks 18 22>;
+		clock-names = "fck";
+		power-domains = <&k3_pds 18 TI_SCI_PD_EXCLUSIVE>;
+
+		dmas = <&mcu_udmap 0xf000>,
+		       <&mcu_udmap 0xf001>,
+		       <&mcu_udmap 0xf002>,
+		       <&mcu_udmap 0xf003>,
+		       <&mcu_udmap 0xf004>,
+		       <&mcu_udmap 0xf005>,
+		       <&mcu_udmap 0xf006>,
+		       <&mcu_udmap 0xf007>,
+		       <&mcu_udmap 0x7000>;
+		dma-names = "tx0", "tx1", "tx2", "tx3",
+			    "tx4", "tx5", "tx6", "tx7",
+			    "rx";
+
+		ethernet-ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			cpsw_port1: port@1 {
+				reg = <1>;
+				ti,mac-only;
+				label = "port1";
+				ti,syscon-efuse = <&mcu_conf 0x200>;
+				phys = <&phy_gmii_sel 1>;
+			};
+		};
+
+		davinci_mdio: mdio@f00 {
+			compatible = "ti,cpsw-mdio","ti,davinci_mdio";
+			reg = <0x0 0xf00 0x0 0x100>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&k3_clks 18 22>;
+			clock-names = "fck";
+			bus_freq = <1000000>;
+		};
+	};
 };
diff --git a/arch/arm64/boot/dts/ti/k3-j721e.dtsi b/arch/arm64/boot/dts/ti/k3-j721e.dtsi
index 027bd1febafa..2f9a56d9b114 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e.dtsi
@@ -30,6 +30,7 @@
 		serial9 = &main_uart7;
 		serial10 = &main_uart8;
 		serial11 = &main_uart9;
+		ethernet0 = &cpsw_port1;
 	};
 
 	chosen { };
-- 
2.17.1

