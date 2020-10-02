Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E823E281D69
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 23:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgJBVIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 17:08:50 -0400
Received: from inva020.nxp.com ([92.121.34.13]:60256 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgJBVIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 17:08:44 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 13ACF1A0D0D;
        Fri,  2 Oct 2020 23:08:42 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0731B1A0C69;
        Fri,  2 Oct 2020 23:08:42 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B3AE0202AC;
        Fri,  2 Oct 2020 23:08:41 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     shawnguo@kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 06/10] arm64: dts: ls2088ardb: add PHY nodes for the CS4340 PHYs
Date:   Sat,  3 Oct 2020 00:07:33 +0300
Message-Id: <20201002210737.27645-7-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002210737.27645-1-ioana.ciornei@nxp.com>
References: <20201002210737.27645-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Annotate the EMDIO1 node and describe the 4 10GBASER PHYs found on the
LS2088ARDB board. Also, add phy-handles for DPMACs 1-4 to their
associated PHY.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../boot/dts/freescale/fsl-ls2088a-rdb.dts    | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts
index f6b4d75a258b..0d1935fcd201 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls2088a-rdb.dts
@@ -22,3 +22,44 @@ chosen {
 		stdout-path = "serial1:115200n8";
 	};
 };
+
+&dpmac1 {
+	phy-handle = <&mdio1_phy1>;
+};
+
+&dpmac2 {
+	phy-handle = <&mdio1_phy2>;
+};
+
+&dpmac3 {
+	phy-handle = <&mdio1_phy3>;
+};
+
+&dpmac4 {
+	phy-handle = <&mdio1_phy4>;
+};
+
+&emdio1 {
+	status = "okay";
+
+	mdio1_phy1: emdio1_phy@1 {
+		compatible = "ethernet-phy-id13e5.1002";
+		reg = <0x10>;
+		phy-connection-type = "10gbase-r";
+	};
+	mdio1_phy2: emdio1_phy@2 {
+		compatible = "ethernet-phy-id13e5.1002";
+		reg = <0x11>;
+		phy-connection-type = "10gbase-r";
+	};
+	mdio1_phy3: emdio1_phy@3 {
+		compatible = "ethernet-phy-id13e5.1002";
+		reg = <0x12>;
+		phy-connection-type = "10gbase-r";
+	};
+	mdio1_phy4: emdio1_phy@4 {
+		compatible = "ethernet-phy-id13e5.1002";
+		reg = <0x13>;
+		phy-connection-type = "10gbase-r";
+	};
+};
-- 
2.28.0

