Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFA5187A65
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 08:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgCQH2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 03:28:44 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:44798 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgCQH2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 03:28:43 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02H7ScLU062555;
        Tue, 17 Mar 2020 02:28:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584430118;
        bh=HVHKkDaWEjb8uGXSqOrK8yyo/QsEo/4K0WPdPJl9YeM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=V4FxC1wWvaSHQa2F25jLrY/c4aVlEXa9/+r5nzwLcAz1AfhMgIl54C7XAvr5tw6B0
         3dVBiZCKz60hN1eCIjSMaOZdFN6FtHXseONIfKDirzWRTWEbZqH16cyKPZcE/amVG7
         Q1gipRSs1gOyjwl8S77BFmrZ9xgmBpHofLQ2i/zo=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02H7ScYm081317
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Mar 2020 02:28:38 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Mar 2020 02:28:38 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Mar 2020 02:28:38 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02H7SbYc092941;
        Tue, 17 Mar 2020 02:28:38 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v4 07/11] arm64: dts: ti: k3-am65-mcu: add cpsw nuss node
Date:   Tue, 17 Mar 2020 09:27:35 +0200
Message-ID: <20200317072739.23950-8-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200317072739.23950-1-grygorii.strashko@ti.com>
References: <20200317072739.23950-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DT node for the TI AM65x SoC Gigabit Ethernet two ports Switch
subsystem (CPSW NUSS).

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi | 49 +++++++++++++++++++++++++
 arch/arm64/boot/dts/ti/k3-am65.dtsi     |  1 +
 2 files changed, 50 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi b/arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi
index ad89f93f30e5..e645664f004e 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi
@@ -193,4 +193,53 @@
 			#size-cells = <0>;
 		};
 	};
+
+	mcu_cpsw: ethernet@46000000 {
+		compatible = "ti,am654-cpsw-nuss";
+		#address-cells = <2>;
+		#size-cells = <2>;
+		reg = <0x0 0x46000000 0x0 0x200000>;
+		reg-names = "cpsw_nuss";
+		ranges = <0x0 0x0 0x0 0x46000000 0x0 0x200000>;
+		dma-coherent;
+		clocks = <&k3_clks 5 10>;
+		clock-names = "fck";
+		power-domains = <&k3_pds 5 TI_SCI_PD_EXCLUSIVE>;
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
+			clocks = <&k3_clks 5 10>;
+			clock-names = "fck";
+			bus_freq = <1000000>;
+		};
+	};
 };
diff --git a/arch/arm64/boot/dts/ti/k3-am65.dtsi b/arch/arm64/boot/dts/ti/k3-am65.dtsi
index aea36e29dd32..5be75e430965 100644
--- a/arch/arm64/boot/dts/ti/k3-am65.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65.dtsi
@@ -30,6 +30,7 @@
 		i2c3 = &main_i2c1;
 		i2c4 = &main_i2c2;
 		i2c5 = &main_i2c3;
+		ethernet0 = &cpsw_port1;
 	};
 
 	chosen { };
-- 
2.17.1

