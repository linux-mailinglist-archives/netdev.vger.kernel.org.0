Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C92281D6C
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 23:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgJBVIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 17:08:54 -0400
Received: from inva021.nxp.com ([92.121.34.21]:46960 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbgJBVIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 17:08:44 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 817C5200EE9;
        Fri,  2 Oct 2020 23:08:42 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 75468200178;
        Fri,  2 Oct 2020 23:08:42 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1560B202AC;
        Fri,  2 Oct 2020 23:08:42 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     shawnguo@kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 07/10] arm64: dts: ls2088ardb: add PHY nodes for the AQR405 PHYs
Date:   Sat,  3 Oct 2020 00:07:34 +0300
Message-Id: <20201002210737.27645-8-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002210737.27645-1-ioana.ciornei@nxp.com>
References: <20201002210737.27645-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Annotate the EMDIO2 node and describe the other 4 10GBASER PHYs found on
the LS2088ARDB board. Also, add phy-handles for DPMACs 5-8 to their
associated PHY.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../boot/dts/freescale/fsl-ls2088a-rdb.dts    | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts
index 0d1935fcd201..0492c9f76490 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts
@@ -39,6 +39,22 @@ &dpmac4 {
 	phy-handle = <&mdio1_phy4>;
 };
 
+&dpmac5 {
+	phy-handle = <&mdio2_phy1>;
+};
+
+&dpmac6 {
+	phy-handle = <&mdio2_phy2>;
+};
+
+&dpmac7 {
+	phy-handle = <&mdio2_phy3>;
+};
+
+&dpmac8 {
+	phy-handle = <&mdio2_phy4>;
+};
+
 &emdio1 {
 	status = "okay";
 
@@ -63,3 +79,32 @@ mdio1_phy4: emdio1_phy@4 {
 		phy-connection-type = "10gbase-r";
 	};
 };
+
+&emdio2 {
+	status = "okay";
+
+	mdio2_phy1: emdio2_phy@1 {
+		compatible = "ethernet-phy-id03a1.b4b0", "ethernet-phy-ieee802.3-c45";
+		interrupts = <0 1 0x4>;
+		reg = <0x0>;
+		phy-connection-type = "10gbase-r";
+	};
+	mdio2_phy2: emdio2_phy@2 {
+		compatible = "ethernet-phy-id03a1.b4b0", "ethernet-phy-ieee802.3-c45";
+		interrupts = <0 2 0x4>;
+		reg = <0x1>;
+		phy-connection-type = "10gbase-r";
+	};
+	mdio2_phy3: emdio2_phy@3 {
+		compatible = "ethernet-phy-id03a1.b4b0", "ethernet-phy-ieee802.3-c45";
+		interrupts = <0 4 0x4>;
+		reg = <0x2>;
+		phy-connection-type = "10gbase-r";
+	};
+	mdio2_phy4: emdio2_phy@4 {
+		compatible = "ethernet-phy-id03a1.b4b0", "ethernet-phy-ieee802.3-c45";
+		interrupts = <0 5 0x4>;
+		reg = <0x3>;
+		phy-connection-type = "10gbase-r";
+	};
+};
-- 
2.28.0

