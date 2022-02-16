Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5AD84B8222
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 08:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiBPHua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 02:50:30 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiBPHuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 02:50:25 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF0F65CD
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 23:50:00 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nKF46-000364-Uv; Wed, 16 Feb 2022 08:49:30 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nKF45-00FBc1-Au; Wed, 16 Feb 2022 08:49:29 +0100
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
Subject: [PATCH v5 8/9] ARM: dts: tegra20/30: fix ethernet node name for different tegra boards
Date:   Wed, 16 Feb 2022 08:49:26 +0100
Message-Id: <20220216074927.3619425-9-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220216074927.3619425-1-o.rempel@pengutronix.de>
References: <20220216074927.3619425-1-o.rempel@pengutronix.de>
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
"asix" or "smsc" as required by Ethernet controller devicetree schema:
 Documentation/devicetree/bindings/net/ethernet-controller.yaml

This patch can potentially affect boot loaders patching against full
node path instead of using device aliases.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/boot/dts/tegra20-colibri.dtsi | 2 +-
 arch/arm/boot/dts/tegra30-colibri.dtsi | 2 +-
 arch/arm/boot/dts/tegra30-ouya.dts     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-colibri.dtsi b/arch/arm/boot/dts/tegra20-colibri.dtsi
index 1eefb9ee4ac8..8ebd8afc857d 100644
--- a/arch/arm/boot/dts/tegra20-colibri.dtsi
+++ b/arch/arm/boot/dts/tegra20-colibri.dtsi
@@ -691,7 +691,7 @@ usb@c5004000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		asix@1 {
+		ethernet@1 {
 			compatible = "usbb95,772b";
 			reg = <1>;
 			local-mac-address = [00 00 00 00 00 00];
diff --git a/arch/arm/boot/dts/tegra30-colibri.dtsi b/arch/arm/boot/dts/tegra30-colibri.dtsi
index be691a1c33a1..22231d450b1b 100644
--- a/arch/arm/boot/dts/tegra30-colibri.dtsi
+++ b/arch/arm/boot/dts/tegra30-colibri.dtsi
@@ -960,7 +960,7 @@ usb@7d004000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		asix@1 {
+		ethernet@1 {
 			compatible = "usbb95,772b";
 			reg = <1>;
 			local-mac-address = [00 00 00 00 00 00];
diff --git a/arch/arm/boot/dts/tegra30-ouya.dts b/arch/arm/boot/dts/tegra30-ouya.dts
index a5cfbab5f565..e58dda4f9d2c 100644
--- a/arch/arm/boot/dts/tegra30-ouya.dts
+++ b/arch/arm/boot/dts/tegra30-ouya.dts
@@ -4553,7 +4553,7 @@ usb@7d004000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		smsc@2 { /* SMSC 10/100T Ethernet Controller */
+		ethernet@2 { /* SMSC 10/100T Ethernet Controller */
 			compatible = "usb424,9e00";
 			reg = <2>;
 			local-mac-address = [00 11 22 33 44 55];
-- 
2.30.2

