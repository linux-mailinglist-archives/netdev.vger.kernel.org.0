Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0B5633BE1
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbiKVLyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbiKVLyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:54:50 -0500
Received: from inva021.nxp.com (inva021.nxp.com [92.121.34.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B7B252BF;
        Tue, 22 Nov 2022 03:54:49 -0800 (PST)
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 58BAD200CE9;
        Tue, 22 Nov 2022 12:54:48 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 216C9200D2A;
        Tue, 22 Nov 2022 12:54:48 +0100 (CET)
Received: from local (shlinux2.ap.freescale.net [10.192.224.44])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 44F8E183ABEF;
        Tue, 22 Nov 2022 19:54:46 +0800 (+08)
From:   haibo.chen@nxp.com
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        haibo.chen@nxp.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 3/3] arm64: dts: imx93: add flexcan nodes
Date:   Tue, 22 Nov 2022 19:32:32 +0800
Message-Id: <1669116752-4260-3-git-send-email-haibo.chen@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1669116752-4260-1-git-send-email-haibo.chen@nxp.com>
References: <1669116752-4260-1-git-send-email-haibo.chen@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

Add flexcan1 and flexcan2 nodes.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
---
 arch/arm64/boot/dts/freescale/imx93.dtsi | 28 ++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index 5d79663b3b84..6808321ed809 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -223,6 +223,20 @@ lpuart2: serial@44390000 {
 				status = "disabled";
 			};
 
+			flexcan1: can@443a0000 {
+				compatible = "fsl,imx93-flexcan";
+				reg = <0x443a0000 0x10000>;
+				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk IMX93_CLK_BUS_AON>,
+					 <&clk IMX93_CLK_CAN1_GATE>;
+				clock-names = "ipg", "per";
+				assigned-clocks = <&clk IMX93_CLK_CAN1>;
+				assigned-clock-parents = <&clk IMX93_CLK_SYS_PLL_PFD1_DIV2>;
+				assigned-clock-rates = <40000000>;
+				fsl,clk-source = /bits/ 8 <0>;
+				status = "disabled";
+			};
+
 			iomuxc: pinctrl@443c0000 {
 				compatible = "fsl,imx93-iomuxc";
 				reg = <0x443c0000 0x10000>;
@@ -393,6 +407,20 @@ lpuart6: serial@425a0000 {
 				status = "disabled";
 			};
 
+			flexcan2: can@425b0000 {
+				compatible = "fsl,imx93-flexcan";
+				reg = <0x425b0000 0x10000>;
+				interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk IMX93_CLK_BUS_WAKEUP>,
+					 <&clk IMX93_CLK_CAN2_GATE>;
+				clock-names = "ipg", "per";
+				assigned-clocks = <&clk IMX93_CLK_CAN2>;
+				assigned-clock-parents = <&clk IMX93_CLK_SYS_PLL_PFD1_DIV2>;
+				assigned-clock-rates = <40000000>;
+				fsl,clk-source = /bits/ 8 <0>;
+				status = "disabled";
+			};
+
 			lpuart7: serial@42690000 {
 				compatible = "fsl,imx93-lpuart", "fsl,imx7ulp-lpuart";
 				reg = <0x42690000 0x1000>;
-- 
2.34.1

