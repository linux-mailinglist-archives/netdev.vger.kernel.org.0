Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBFD2AF187
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgKKNFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbgKKNFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:05:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A637C0613D6
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:05:13 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kcpoF-000306-CZ; Wed, 11 Nov 2020 14:05:11 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        devicetree@vger.kernel.org
Subject: [net v2 2/4] ARM: dts: imx: Change flexcan node name to "can"
Date:   Wed, 11 Nov 2020 14:05:05 +0100
Message-Id: <20201111130507.1560881-3-mkl@pengutronix.de>
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

Change i.MX SoCs nand node name from "flexcan" to "can" to be compliant with
yaml schema, it requires the nodename to be "can". This fixes the following
error found by dtbs_check:

arch/arm/boot/dts/imx6dl-apf6dev.dt.yaml: flexcan@2090000: $nodename:0: 'flexcan@2090000' does not match '^can(@.*)?$'
    From schema: Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml

Cc: Shawn Guo <shawnguo@kernel.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 4 ++--
 arch/arm/boot/dts/imx6ul.dtsi  | 4 ++--
 arch/arm/boot/dts/vfxxx.dtsi   | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index bc98b63922b0..7a1d39b58c8b 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -542,7 +542,7 @@ pwm4: pwm@208c000 {
 				status = "disabled";
 			};
 
-			can1: flexcan@2090000 {
+			can1: can@2090000 {
 				compatible = "fsl,imx6q-flexcan";
 				reg = <0x02090000 0x4000>;
 				interrupts = <0 110 IRQ_TYPE_LEVEL_HIGH>;
@@ -553,7 +553,7 @@ can1: flexcan@2090000 {
 				status = "disabled";
 			};
 
-			can2: flexcan@2094000 {
+			can2: can@2094000 {
 				compatible = "fsl,imx6q-flexcan";
 				reg = <0x02094000 0x4000>;
 				interrupts = <0 111 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 713a4bb341db..798a1c2a539e 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -423,7 +423,7 @@ pwm4: pwm@208c000 {
 				status = "disabled";
 			};
 
-			can1: flexcan@2090000 {
+			can1: can@2090000 {
 				compatible = "fsl,imx6ul-flexcan", "fsl,imx6q-flexcan";
 				reg = <0x02090000 0x4000>;
 				interrupts = <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>;
@@ -434,7 +434,7 @@ can1: flexcan@2090000 {
 				status = "disabled";
 			};
 
-			can2: flexcan@2094000 {
+			can2: can@2094000 {
 				compatible = "fsl,imx6ul-flexcan", "fsl,imx6q-flexcan";
 				reg = <0x02094000 0x4000>;
 				interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index 2259d11af721..acb1a9040e56 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -95,7 +95,7 @@ edma0: dma-controller@40018000 {
 				status = "disabled";
 			};
 
-			can0: flexcan@40020000 {
+			can0: can@40020000 {
 				compatible = "fsl,vf610-flexcan";
 				reg = <0x40020000 0x4000>;
 				interrupts = <58 IRQ_TYPE_LEVEL_HIGH>;
@@ -681,7 +681,7 @@ fec1: ethernet@400d1000 {
 				status = "disabled";
 			};
 
-			can1: flexcan@400d4000 {
+			can1: can@400d4000 {
 				compatible = "fsl,vf610-flexcan";
 				reg = <0x400d4000 0x4000>;
 				interrupts = <59 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.28.0

