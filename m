Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD884187A72
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 08:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgCQH27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 03:28:59 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:53692 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgCQH26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 03:28:58 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02H7Srub069328;
        Tue, 17 Mar 2020 02:28:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584430133;
        bh=i/TegccITaPMoMi6UVP/BPk+ArR8UaOpWaWzIsURoBI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=do6ckJEuMxysbv/pppNA8U/OnmMYIcCq+jzaNC927oiZTNjO3bLROBXS0ZpQv9Aap
         fc8iHVoocBdtjNmJRtj8+Fg/5PhXQ9r7/MSgKB675YfeCiAxo+hlFCQFFI+4zcnZIp
         j6zPOnM14EaMhqdYeSc7UqW1CDnk38bHkuileDpI=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02H7Sr2U070626;
        Tue, 17 Mar 2020 02:28:53 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Mar 2020 02:28:53 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Mar 2020 02:28:52 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02H7Sprs069777;
        Tue, 17 Mar 2020 02:28:52 -0500
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
Subject: [PATCH net-next v4 09/11] arm64: dts: ti: k3-j721e-mcu: add mcu cpsw nuss node
Date:   Tue, 17 Mar 2020 09:27:37 +0200
Message-ID: <20200317072739.23950-10-grygorii.strashko@ti.com>
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

Add DT node for The TI J721E MCU SoC Gigabit Ethernet
subsystem (MCU CPSW NUSS).

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../boot/dts/ti/k3-j721e-mcu-wakeup.dtsi      | 49 +++++++++++++++++++
 arch/arm64/boot/dts/ti/k3-j721e.dtsi          |  1 +
 2 files changed, 50 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
index 6f961d5f077a..dc047273f101 100644
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

