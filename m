Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F9862EA7D
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbiKRAoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234080AbiKRAoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:44:12 -0500
X-Greylist: delayed 1693 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Nov 2022 16:44:11 PST
Received: from finn.localdomain (finn.gateworks.com [108.161.129.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F358248EC;
        Thu, 17 Nov 2022 16:44:08 -0800 (PST)
Received: from 068-189-091-139.biz.spectrum.com ([68.189.91.139] helo=tharvey.pdc.gateworks.com)
        by finn.localdomain with esmtp (Exim 4.93)
        (envelope-from <tharvey@gateworks.com>)
        id 1ovp2v-000nxs-GZ; Fri, 18 Nov 2022 00:15:53 +0000
From:   Tim Harvey <tharvey@gateworks.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH 3/3] arm64: dts: imx8m*-venice: add dp83867 PHY LED mode configuration
Date:   Thu, 17 Nov 2022 16:15:48 -0800
Message-Id: <20221118001548.635752-4-tharvey@gateworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221118001548.635752-1-tharvey@gateworks.com>
References: <20221118001548.635752-1-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add configuration for dp83867 PHY LED mode via ti,led-modes property.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi | 6 ++++++
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts  | 6 ++++++
 arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts  | 6 ++++++
 3 files changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
index c305e325d007..bb9928153ff0 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
@@ -111,6 +111,12 @@ ethphy0: ethernet-phy@0 {
 			reg = <0>;
 			ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
 			ti,tx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
+			ti,led-modes = <
+				DP83867_LED_SEL_LINK
+				DP83867_LED_SEL_LINK_1000BT
+				DP83867_LED_SEL_LINK_ACT
+				DP83867_LED_SEL_LINK
+			>;
 			tx-fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
 			rx-fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
 		};
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts
index 11481e09c75b..d7de555cf5e1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts
@@ -253,6 +253,12 @@ ethphy0: ethernet-phy@0 {
 			reg = <0>;
 			ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
 			ti,tx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
+			ti,led-modes = <
+				DP83867_LED_SEL_LINK
+				DP83867_LED_SEL_LINK_1000BT
+				DP83867_LED_SEL_LINK_ACT
+				DP83867_LED_SEL_LINK
+			>;
 			tx-fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
 			rx-fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
 		};
diff --git a/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts b/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts
index 97582db71ca8..8e61966c8dd0 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts
@@ -248,6 +248,12 @@ ethphy0: ethernet-phy@0 {
 			reg = <0>;
 			ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
 			ti,tx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
+			ti,led-modes = <
+				DP83867_LED_SEL_LINK
+				DP83867_LED_SEL_LINK_1000BT
+				DP83867_LED_SEL_LINK_ACT
+				DP83867_LED_SEL_LINK
+			>;
 			tx-fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
 			rx-fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
 		};
-- 
2.25.1

