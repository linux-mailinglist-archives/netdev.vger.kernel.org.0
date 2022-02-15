Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0DD4B686F
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 11:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbiBOKA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 05:00:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbiBOKAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 05:00:52 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7051310E077
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 02:00:43 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nJudB-0001tI-OY; Tue, 15 Feb 2022 11:00:21 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nJud9-009fwZ-G4; Tue, 15 Feb 2022 11:00:19 +0100
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
Subject: [PATCH v4 5/8] ARM: dts: exynos: fix ethernet node name for different odroid boards
Date:   Tue, 15 Feb 2022 11:00:15 +0100
Message-Id: <20220215100018.2306046-6-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220215100018.2306046-1-o.rempel@pengutronix.de>
References: <20220215100018.2306046-1-o.rempel@pengutronix.de>
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
"usbether" as required by Ethernet controller devicetree schema:
 Documentation/devicetree/bindings/net/ethernet-controller.yaml

Also fix compatible for this device as required by USB device schema:
 Documentation/devicetree/bindings/usb/usb-device.yaml
  The textual representation of VID and PID shall be in lower case hexadecimal
  with leading zeroes suppressed.

Without compatible fix, we won't be able to validate this device nodes.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/boot/dts/exynos4412-odroidu3.dts       | 4 ++--
 arch/arm/boot/dts/exynos4412-odroidx.dts        | 8 ++++----
 arch/arm/boot/dts/exynos5410-odroidxu.dts       | 4 ++--
 arch/arm/boot/dts/exynos5422-odroidxu3-lite.dts | 6 +++---
 arch/arm/boot/dts/exynos5422-odroidxu3.dts      | 6 +++---
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
index efaf7533e84f..36c369c42b77 100644
--- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
@@ -119,8 +119,8 @@ &ehci {
 	phys = <&exynos_usbphy 2>, <&exynos_usbphy 3>;
 	phy-names = "hsic0", "hsic1";
 
-	ethernet: usbether@2 {
-		compatible = "usb0424,9730";
+	ethernet: ethernet@2 {
+		compatible = "usb424,9730";
 		reg = <2>;
 		local-mac-address = [00 00 00 00 00 00]; /* Filled in by a bootloader */
 	};
diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts b/arch/arm/boot/dts/exynos4412-odroidx.dts
index 440135d0ff2a..ba46baf9117f 100644
--- a/arch/arm/boot/dts/exynos4412-odroidx.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
@@ -70,19 +70,19 @@ &ehci {
 	phy-names = "hsic0";
 
 	hub@2 {
-		compatible = "usb0424,3503";
+		compatible = "usb424,3503";
 		reg = <2>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 
 		hub@1 {
-			compatible = "usb0424,9514";
+			compatible = "usb424,9514";
 			reg = <1>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-			ethernet: usbether@1 {
-				compatible = "usb0424,ec00";
+			ethernet: ethernet@1 {
+				compatible = "usb424,ec00";
 				reg = <1>;
 				/* Filled in by a bootloader */
 				local-mac-address = [00 00 00 00 00 00];
diff --git a/arch/arm/boot/dts/exynos5410-odroidxu.dts b/arch/arm/boot/dts/exynos5410-odroidxu.dts
index 884fef55836c..4c7039e771db 100644
--- a/arch/arm/boot/dts/exynos5410-odroidxu.dts
+++ b/arch/arm/boot/dts/exynos5410-odroidxu.dts
@@ -675,8 +675,8 @@ &usbhost2 {
 	#address-cells = <1>;
 	#size-cells = <0>;
 
-	ethernet: usbether@2 {
-		compatible = "usb0424,9730";
+	ethernet: ethernet@2 {
+		compatible = "usb424,9730";
 		reg = <2>;
 		local-mac-address = [00 00 00 00 00 00]; /* Filled in by a bootloader */
 	};
diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3-lite.dts b/arch/arm/boot/dts/exynos5422-odroidxu3-lite.dts
index 62c5928aa994..e3154a1cae23 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3-lite.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-lite.dts
@@ -113,13 +113,13 @@ &usbhost2 {
 	#size-cells = <0>;
 
 	hub@1 {
-		compatible = "usb0424,9514";
+		compatible = "usb424,9514";
 		reg = <1>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		ethernet: usbether@1 {
-			compatible = "usb0424,ec00";
+		ethernet: ethernet@1 {
+			compatible = "usb424,ec00";
 			reg = <1>;
 			local-mac-address = [00 00 00 00 00 00]; /* Filled in by a bootloader */
 		};
diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3.dts b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
index cecaeb69e623..a378d4937ff7 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
@@ -80,13 +80,13 @@ &usbhost2 {
 	#size-cells = <0>;
 
 	hub@1 {
-		compatible = "usb0424,9514";
+		compatible = "usb424,9514";
 		reg = <1>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		ethernet: usbether@1 {
-			compatible = "usb0424,ec00";
+		ethernet: ethernet@1 {
+			compatible = "usb424,ec00";
 			reg = <1>;
 			local-mac-address = [00 00 00 00 00 00]; /* Filled in by a bootloader */
 		};
-- 
2.30.2

