Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C84D2815AE
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388175AbgJBOtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:49:51 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47458 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387990AbgJBOtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:49:47 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D2CBE1A0136;
        Fri,  2 Oct 2020 16:49:45 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C5B071A004D;
        Fri,  2 Oct 2020 16:49:45 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 7DD1C202AC;
        Fri,  2 Oct 2020 16:49:45 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     shawnguo@kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RESEND net-next 2/9] arm64: dts: ls1088ardb: add QSGMII PHY nodes
Date:   Fri,  2 Oct 2020 17:48:40 +0300
Message-Id: <20201002144847.13793-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002144847.13793-1-ioana.ciornei@nxp.com>
References: <20201002144847.13793-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Annotate the external MDIO1 node and describe the 8 QSGMII PHYs found on
the LS1088ARDB board and add phy-handles for DPMACs 3-10 to its
associated PHY.  Also, add the internal PCS MDIO nodes for the internal
MDIO buses found on the LS1088A SoC along with their internal PCS PHY
and link the corresponding DPMAC to the PCS through the pcs-handle.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../boot/dts/freescale/fsl-ls1088a-rdb.dts    | 100 ++++++++++++++++++
 .../arm64/boot/dts/freescale/fsl-ls1088a.dtsi |  50 +++++++++
 2 files changed, 150 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
index 5633e59febc3..d7886b084f7f 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
@@ -17,6 +17,98 @@ / {
 	compatible = "fsl,ls1088a-rdb", "fsl,ls1088a";
 };
 
+&dpmac3 {
+	phy-handle = <&mdio1_phy5>;
+	phy-connection-type = "qsgmii";
+	managed = "in-band-status";
+	pcs-handle = <&pcs3_0>;
+};
+
+&dpmac4 {
+	phy-handle = <&mdio1_phy6>;
+	phy-connection-type = "qsgmii";
+	managed = "in-band-status";
+	pcs-handle = <&pcs3_1>;
+};
+
+&dpmac5 {
+	phy-handle = <&mdio1_phy7>;
+	phy-connection-type = "qsgmii";
+	managed = "in-band-status";
+	pcs-handle = <&pcs3_2>;
+};
+
+&dpmac6 {
+	phy-handle = <&mdio1_phy8>;
+	phy-connection-type = "qsgmii";
+	managed = "in-band-status";
+	pcs-handle = <&pcs3_3>;
+};
+
+&dpmac7 {
+	phy-handle = <&mdio1_phy1>;
+	phy-connection-type = "qsgmii";
+	managed = "in-band-status";
+	pcs-handle = <&pcs7_0>;
+};
+
+&dpmac8 {
+	phy-handle = <&mdio1_phy2>;
+	phy-connection-type = "qsgmii";
+	managed = "in-band-status";
+	pcs-handle = <&pcs7_1>;
+};
+
+&dpmac9 {
+	phy-handle = <&mdio1_phy3>;
+	phy-connection-type = "qsgmii";
+	managed = "in-band-status";
+	pcs-handle = <&pcs7_2>;
+};
+
+&dpmac10 {
+	phy-handle = <&mdio1_phy4>;
+	phy-connection-type = "qsgmii";
+	managed = "in-band-status";
+	pcs-handle = <&pcs7_3>;
+};
+
+&emdio1 {
+	status = "okay";
+
+	mdio1_phy1: emdio1_phy@1 {
+		reg = <0x1c>;
+	};
+
+	mdio1_phy2: emdio1_phy@2 {
+		reg = <0x1d>;
+	};
+
+	mdio1_phy3: emdio1_phy@3 {
+		reg = <0x1e>;
+	};
+
+	mdio1_phy4: emdio1_phy@4 {
+		reg = <0x1f>;
+	};
+
+	mdio1_phy5: emdio1_phy@5 {
+		reg = <0x0c>;
+	};
+
+	mdio1_phy6: emdio1_phy@6 {
+		reg = <0x0d>;
+	};
+
+	mdio1_phy7: emdio1_phy@7 {
+		reg = <0x0e>;
+	};
+
+	mdio1_phy8: emdio1_phy@8 {
+		reg = <0x0f>;
+	};
+};
+
 &i2c0 {
 	status = "okay";
 
@@ -87,6 +179,14 @@ &esdhc {
 	status = "okay";
 };
 
+&pcs_mdio3 {
+	status = "okay";
+};
+
+&pcs_mdio7 {
+	status = "okay";
+};
+
 &qspi {
 	status = "okay";
 
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
index 22544e3b7737..ad8679e58f9a 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
@@ -672,6 +672,56 @@ emdio2: mdio@0x8B97000 {
 			status = "disabled";
 		};
 
+		pcs_mdio3: mdio@8c0f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c0f000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs3_0: pcs-phy@0 {
+				reg = <0>;
+			};
+
+			pcs3_1: pcs-phy@1 {
+				reg = <1>;
+			};
+
+			pcs3_2: pcs-phy@2 {
+				reg = <2>;
+			};
+
+			pcs3_3: pcs-phy@3 {
+				reg = <3>;
+			};
+		};
+
+		pcs_mdio7: mdio@8c1f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c1f000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs7_0: pcs-phy@0 {
+				reg = <0>;
+			};
+
+			pcs7_1: pcs-phy@1 {
+				reg = <1>;
+			};
+
+			pcs7_2: pcs-phy@2 {
+				reg = <2>;
+			};
+
+			pcs7_3: pcs-phy@3 {
+				reg = <3>;
+			};
+		};
+
 		cluster1_core0_watchdog: wdt@c000000 {
 			compatible = "arm,sp805-wdt", "arm,primecell";
 			reg = <0x0 0xc000000 0x0 0x1000>;
-- 
2.28.0

