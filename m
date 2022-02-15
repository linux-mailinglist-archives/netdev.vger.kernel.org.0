Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA284B657B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 09:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbiBOIKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 03:10:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235140AbiBOIKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 03:10:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3B62E082
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 00:10:08 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nJsu4-0002EJ-5T; Tue, 15 Feb 2022 09:09:40 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nJsu2-009UlU-9s; Tue, 15 Feb 2022 09:09:38 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Tony Lindgren <tony@atomide.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH v3 6/8] ARM: dts: omap3/4/5: fix ethernet node name for different OMAP boards
Date:   Tue, 15 Feb 2022 09:09:35 +0100
Message-Id: <20220215080937.2263111-6-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220215080937.2263111-1-o.rempel@pengutronix.de>
References: <20220215080937.2263111-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The node name of Ethernet controller should be "ethernet" instead of
"usbether"

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/boot/dts/omap3-beagle-xm.dts     | 2 +-
 arch/arm/boot/dts/omap4-panda-common.dtsi | 2 +-
 arch/arm/boot/dts/omap5-igep0050.dts      | 2 +-
 arch/arm/boot/dts/omap5-uevm.dts          | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
index a858ebfa1500..35eced6521ef 100644
--- a/arch/arm/boot/dts/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
@@ -370,7 +370,7 @@ hub@2 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		ethernet: usbether@1 {
+		ethernet: ethernet@1 {
 			compatible = "usb424,ec00";
 			reg = <1>;
 		};
diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 609a8dea946b..518652a599bd 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -558,7 +558,7 @@ hub@1 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		ethernet: usbether@1 {
+		ethernet: ethernet@1 {
 			compatible = "usb424,ec00";
 			reg = <1>;
 		};
diff --git a/arch/arm/boot/dts/omap5-igep0050.dts b/arch/arm/boot/dts/omap5-igep0050.dts
index 76e499d89d24..3851120857d7 100644
--- a/arch/arm/boot/dts/omap5-igep0050.dts
+++ b/arch/arm/boot/dts/omap5-igep0050.dts
@@ -128,7 +128,7 @@ hub@2 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		ethernet: usbether@3 {
+		ethernet: ethernet@3 {
 			compatible = "usb424,7500";
 			reg = <3>;
 		};
diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index 51d5fcae5081..453da9f18a99 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -209,7 +209,7 @@ hub@2 {
 		#size-cells = <0>;
 	};
 
-	ethernet: usbether@3 {
+	ethernet: ethernet@3 {
 		compatible = "usb424,9730";
 		reg = <3>;
 	};
-- 
2.30.2

