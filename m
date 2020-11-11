Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3C62AF188
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgKKNFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgKKNFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:05:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40514C0613D4
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:05:12 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kcpoE-000306-S9; Wed, 11 Nov 2020 14:05:10 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        devicetree@vger.kernel.org
Subject: [net v2 1/4] ARM: dts: imx: fix can fsl,stop-mode
Date:   Wed, 11 Nov 2020 14:05:04 +0100
Message-Id: <20201111130507.1560881-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201111130507.1560881-1-mkl@pengutronix.de>
References: <[net v2 0/4] arm: imx: flexcan: fix yaml bindings and DTs>
 <20201111130507.1560881-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit:

    d9b081e3fc4b can: flexcan: remove ack_grp and ack_bit handling from driver

the 4th and 5th value of the property "fsl,stop-mode" aren't used anymore. With
the conversion of the flexcan binding to yaml this raises the following error
during dtbs_check:

arch/arm/boot/dts/imx6dl-apf6dev.dt.yaml: flexcan@2090000: fsl,stop-mode:0: [1, 52, 28, 16, 17] is too long
    From schema: Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml

This patch fixes the error by removing the obsolete values.

Cc: Shawn Guo <shawnguo@kernel.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 4 ++--
 arch/arm/boot/dts/imx6sx.dtsi  | 4 ++--
 arch/arm/boot/dts/imx6ul.dtsi  | 4 ++--
 arch/arm/boot/dts/imx7s.dtsi   | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 7a8837cbe21b..bc98b63922b0 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -549,7 +549,7 @@ can1: flexcan@2090000 {
 				clocks = <&clks IMX6QDL_CLK_CAN1_IPG>,
 					 <&clks IMX6QDL_CLK_CAN1_SERIAL>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x34 28 0x10 17>;
+				fsl,stop-mode = <&gpr 0x34 28>;
 				status = "disabled";
 			};
 
@@ -560,7 +560,7 @@ can2: flexcan@2094000 {
 				clocks = <&clks IMX6QDL_CLK_CAN2_IPG>,
 					 <&clks IMX6QDL_CLK_CAN2_SERIAL>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x34 29 0x10 18>;
+				fsl,stop-mode = <&gpr 0x34 29>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index dfdca1804f9f..6c604c38c790 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -463,7 +463,7 @@ flexcan1: can@2090000 {
 				clocks = <&clks IMX6SX_CLK_CAN1_IPG>,
 					 <&clks IMX6SX_CLK_CAN1_SERIAL>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x10 1 0x10 17>;
+				fsl,stop-mode = <&gpr 0x10 1>;
 				status = "disabled";
 			};
 
@@ -474,7 +474,7 @@ flexcan2: can@2094000 {
 				clocks = <&clks IMX6SX_CLK_CAN2_IPG>,
 					 <&clks IMX6SX_CLK_CAN2_SERIAL>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x10 2 0x10 18>;
+				fsl,stop-mode = <&gpr 0x10 2>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index d7d9f3e46b92..713a4bb341db 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -430,7 +430,7 @@ can1: flexcan@2090000 {
 				clocks = <&clks IMX6UL_CLK_CAN1_IPG>,
 					 <&clks IMX6UL_CLK_CAN1_SERIAL>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x10 1 0x10 17>;
+				fsl,stop-mode = <&gpr 0x10 1>;
 				status = "disabled";
 			};
 
@@ -441,7 +441,7 @@ can2: flexcan@2094000 {
 				clocks = <&clks IMX6UL_CLK_CAN2_IPG>,
 					 <&clks IMX6UL_CLK_CAN2_SERIAL>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x10 2 0x10 18>;
+				fsl,stop-mode = <&gpr 0x10 2>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 84d9cc13afb9..b58262acba11 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -971,7 +971,7 @@ flexcan1: can@30a00000 {
 				clocks = <&clks IMX7D_CLK_DUMMY>,
 					<&clks IMX7D_CAN1_ROOT_CLK>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x10 1 0x10 17>;
+				fsl,stop-mode = <&gpr 0x10 1>;
 				status = "disabled";
 			};
 
@@ -982,7 +982,7 @@ flexcan2: can@30a10000 {
 				clocks = <&clks IMX7D_CLK_DUMMY>,
 					<&clks IMX7D_CAN2_ROOT_CLK>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x10 2 0x10 18>;
+				fsl,stop-mode = <&gpr 0x10 2>;
 				status = "disabled";
 			};
 

base-commit: e87d24fce924bfcef9714bbaeb1514162420052e
-- 
2.28.0

