Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881CF2815AB
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388166AbgJBOts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:49:48 -0400
Received: from inva021.nxp.com ([92.121.34.21]:55290 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387984AbgJBOtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:49:47 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7B951200138;
        Fri,  2 Oct 2020 16:49:45 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6FA73200D3F;
        Fri,  2 Oct 2020 16:49:45 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 208F6202AC;
        Fri,  2 Oct 2020 16:49:45 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     shawnguo@kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RESEND net-next 1/9] arm64: dts: ls1088a: add external MDIO device nodes
Date:   Fri,  2 Oct 2020 17:48:39 +0300
Message-Id: <20201002144847.13793-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002144847.13793-1-ioana.ciornei@nxp.com>
References: <20201002144847.13793-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the external MDIO device nodes found in the WRIOP global memory
region. This is needed for management of external PHYs.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
index 169f4742ae3b..22544e3b7737 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
@@ -654,6 +654,24 @@ ptp-timer@8b95000 {
 			fsl,extts-fifo;
 		};
 
+		emdio1: mdio@0x8B96000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8B96000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+		};
+
+		emdio2: mdio@0x8B97000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8B97000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+		};
+
 		cluster1_core0_watchdog: wdt@c000000 {
 			compatible = "arm,sp805-wdt", "arm,primecell";
 			reg = <0x0 0xc000000 0x0 0x1000>;
-- 
2.28.0

