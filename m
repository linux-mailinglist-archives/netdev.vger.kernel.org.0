Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D539F4B558
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 11:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731563AbfFSJsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 05:48:35 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:37479 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731498AbfFSJse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 05:48:34 -0400
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 75B7520001E;
        Wed, 19 Jun 2019 09:48:29 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v3 14/16] ARM: dts: sunxi: Switch from phy-mode to phy-connection-type
Date:   Wed, 19 Jun 2019 11:47:23 +0200
Message-Id: <50f869f466acb110c5924d7e8a67087fd97106fd.1560937626.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
References: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy-mode device tree property has been deprecated in favor of
phy-connection-type, let's replace it.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

---

Changes from v2:
  - new patch
---
 arch/arm/boot/dts/sun6i-a31-colombus.dts          | 2 +-
 arch/arm/boot/dts/sun6i-a31-hummingbird.dts       | 2 +-
 arch/arm/boot/dts/sun6i-a31-i7.dts                | 2 +-
 arch/arm/boot/dts/sun6i-a31-m9.dts                | 2 +-
 arch/arm/boot/dts/sun6i-a31-mele-a1000g-quad.dts  | 2 +-
 arch/arm/boot/dts/sun6i-a31s-cs908.dts            | 2 +-
 arch/arm/boot/dts/sun6i-a31s-sina31s.dts          | 2 +-
 arch/arm/boot/dts/sun6i-a31s-sinovoip-bpi-m2.dts  | 2 +-
 arch/arm/boot/dts/sun7i-a20-bananapi-m1-plus.dts  | 2 +-
 arch/arm/boot/dts/sun7i-a20-bananapi.dts          | 2 +-
 arch/arm/boot/dts/sun7i-a20-bananapro.dts         | 2 +-
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts       | 2 +-
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts        | 2 +-
 arch/arm/boot/dts/sun7i-a20-hummingbird.dts       | 2 +-
 arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts         | 2 +-
 arch/arm/boot/dts/sun7i-a20-icnova-swac.dts       | 2 +-
 arch/arm/boot/dts/sun7i-a20-itead-ibox.dts        | 2 +-
 arch/arm/boot/dts/sun7i-a20-lamobo-r1.dts         | 4 ++--
 arch/arm/boot/dts/sun7i-a20-m3.dts                | 2 +-
 arch/arm/boot/dts/sun7i-a20-olimex-som-evb.dts    | 2 +-
 arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts | 2 +-
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime.dts    | 2 +-
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts   | 2 +-
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts   | 2 +-
 arch/arm/boot/dts/sun7i-a20-orangepi-mini.dts     | 2 +-
 arch/arm/boot/dts/sun7i-a20-orangepi.dts          | 2 +-
 arch/arm/boot/dts/sun7i-a20-pcduino3-nano.dts     | 2 +-
 arch/arm/boot/dts/sun7i-a20-pcduino3.dts          | 2 +-
 arch/arm/boot/dts/sun7i-a20-wits-pro-a20-dkt.dts  | 2 +-
 arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts      | 2 +-
 arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts  | 2 +-
 arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts | 2 +-
 arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts | 2 +-
 arch/arm/boot/dts/sun9i-a80-cubieboard4.dts       | 2 +-
 arch/arm/boot/dts/sun9i-a80-optimus.dts           | 2 +-
 35 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/arm/boot/dts/sun6i-a31-colombus.dts b/arch/arm/boot/dts/sun6i-a31-colombus.dts
index 50092b0bd0fe..403b734fbfab 100644
--- a/arch/arm/boot/dts/sun6i-a31-colombus.dts
+++ b/arch/arm/boot/dts/sun6i-a31-colombus.dts
@@ -77,7 +77,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun6i-a31-hummingbird.dts b/arch/arm/boot/dts/sun6i-a31-hummingbird.dts
index 7c611ddbaf2f..50ab6fe08fd8 100644
--- a/arch/arm/boot/dts/sun6i-a31-hummingbird.dts
+++ b/arch/arm/boot/dts/sun6i-a31-hummingbird.dts
@@ -154,7 +154,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun6i-a31-i7.dts b/arch/arm/boot/dts/sun6i-a31-i7.dts
index ebb0b4710afb..75451e40d086 100644
--- a/arch/arm/boot/dts/sun6i-a31-i7.dts
+++ b/arch/arm/boot/dts/sun6i-a31-i7.dts
@@ -118,7 +118,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_mii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun6i-a31-m9.dts b/arch/arm/boot/dts/sun6i-a31-m9.dts
index 4910c6ccf2f7..ffa6b4bfcebe 100644
--- a/arch/arm/boot/dts/sun6i-a31-m9.dts
+++ b/arch/arm/boot/dts/sun6i-a31-m9.dts
@@ -85,7 +85,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_mii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	phy-supply = <&reg_dldo1>;
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/sun6i-a31-mele-a1000g-quad.dts b/arch/arm/boot/dts/sun6i-a31-mele-a1000g-quad.dts
index 703e1c19b407..d1a898ee3fec 100644
--- a/arch/arm/boot/dts/sun6i-a31-mele-a1000g-quad.dts
+++ b/arch/arm/boot/dts/sun6i-a31-mele-a1000g-quad.dts
@@ -85,7 +85,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_mii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	phy-supply = <&reg_dldo1>;
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/sun6i-a31s-cs908.dts b/arch/arm/boot/dts/sun6i-a31s-cs908.dts
index 6e9ec3f1695e..3c641def1e18 100644
--- a/arch/arm/boot/dts/sun6i-a31s-cs908.dts
+++ b/arch/arm/boot/dts/sun6i-a31s-cs908.dts
@@ -68,7 +68,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_mii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	status = "okay";
 	phy1: ethernet-phy@1 {
 		reg = <1>;
diff --git a/arch/arm/boot/dts/sun6i-a31s-sina31s.dts b/arch/arm/boot/dts/sun6i-a31s-sina31s.dts
index c92779bc8f85..d2cecf2259eb 100644
--- a/arch/arm/boot/dts/sun6i-a31s-sina31s.dts
+++ b/arch/arm/boot/dts/sun6i-a31s-sina31s.dts
@@ -116,7 +116,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_mii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	phy-supply = <&reg_dldo1>;
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/sun6i-a31s-sinovoip-bpi-m2.dts b/arch/arm/boot/dts/sun6i-a31s-sinovoip-bpi-m2.dts
index e993b2d8ddd0..46842f5af1d2 100644
--- a/arch/arm/boot/dts/sun6i-a31s-sinovoip-bpi-m2.dts
+++ b/arch/arm/boot/dts/sun6i-a31s-sinovoip-bpi-m2.dts
@@ -93,7 +93,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	phy-supply = <&reg_dldo1>;
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/sun7i-a20-bananapi-m1-plus.dts b/arch/arm/boot/dts/sun7i-a20-bananapi-m1-plus.dts
index c601ecf5ab35..b1aa80c5dd79 100644
--- a/arch/arm/boot/dts/sun7i-a20-bananapi-m1-plus.dts
+++ b/arch/arm/boot/dts/sun7i-a20-bananapi-m1-plus.dts
@@ -130,7 +130,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	phy-supply = <&reg_gmac_3v3>;
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/sun7i-a20-bananapi.dts b/arch/arm/boot/dts/sun7i-a20-bananapi.dts
index c5730b30a15d..dc22c22d935c 100644
--- a/arch/arm/boot/dts/sun7i-a20-bananapi.dts
+++ b/arch/arm/boot/dts/sun7i-a20-bananapi.dts
@@ -132,7 +132,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	phy-supply = <&reg_gmac_3v3>;
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/sun7i-a20-bananapro.dts b/arch/arm/boot/dts/sun7i-a20-bananapro.dts
index 86f4ebb77703..923dd76ce25d 100644
--- a/arch/arm/boot/dts/sun7i-a20-bananapro.dts
+++ b/arch/arm/boot/dts/sun7i-a20-bananapro.dts
@@ -110,7 +110,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	phy-supply = <&reg_gmac_3v3>;
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
index e322f0f06003..c5e3b6d2c66c 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
@@ -116,7 +116,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_mii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
index a8f7f63fdde1..f23395092b5b 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
@@ -151,7 +151,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun7i-a20-hummingbird.dts b/arch/arm/boot/dts/sun7i-a20-hummingbird.dts
index 322717cb0b9a..3fbf5dc1623f 100644
--- a/arch/arm/boot/dts/sun7i-a20-hummingbird.dts
+++ b/arch/arm/boot/dts/sun7i-a20-hummingbird.dts
@@ -101,7 +101,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	phy-supply = <&reg_gmac_vdd>;
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts b/arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts
index 8a610dacb983..89ba9dc696ca 100644
--- a/arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts
+++ b/arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts
@@ -116,7 +116,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_mii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	phy-supply = <&reg_gmac_3v3>;
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/sun7i-a20-icnova-swac.dts b/arch/arm/boot/dts/sun7i-a20-icnova-swac.dts
index a20e91c8dbe5..04b97c5d5730 100644
--- a/arch/arm/boot/dts/sun7i-a20-icnova-swac.dts
+++ b/arch/arm/boot/dts/sun7i-a20-icnova-swac.dts
@@ -77,7 +77,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_mii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun7i-a20-itead-ibox.dts b/arch/arm/boot/dts/sun7i-a20-itead-ibox.dts
index c27567c0b027..ff3ab8dbedeb 100644
--- a/arch/arm/boot/dts/sun7i-a20-itead-ibox.dts
+++ b/arch/arm/boot/dts/sun7i-a20-itead-ibox.dts
@@ -98,7 +98,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_mii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun7i-a20-lamobo-r1.dts b/arch/arm/boot/dts/sun7i-a20-lamobo-r1.dts
index 3e170cfac86a..3814921a13a0 100644
--- a/arch/arm/boot/dts/sun7i-a20-lamobo-r1.dts
+++ b/arch/arm/boot/dts/sun7i-a20-lamobo-r1.dts
@@ -120,7 +120,7 @@
 &gmac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	phy-supply = <&reg_gmac_3v3>;
 	status = "okay";
 	/delete-property/#address-cells;
@@ -173,7 +173,7 @@
 					reg = <8>;
 					label = "cpu";
 					ethernet = <&gmac>;
-					phy-mode = "rgmii-txid";
+					phy-connection-type = "rgmii-txid";
 					fixed-link {
 						speed = <1000>;
 						full-duplex;
diff --git a/arch/arm/boot/dts/sun7i-a20-m3.dts b/arch/arm/boot/dts/sun7i-a20-m3.dts
index bde0ef783e71..52b56281b46c 100644
--- a/arch/arm/boot/dts/sun7i-a20-m3.dts
+++ b/arch/arm/boot/dts/sun7i-a20-m3.dts
@@ -83,7 +83,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_mii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun7i-a20-olimex-som-evb.dts b/arch/arm/boot/dts/sun7i-a20-olimex-som-evb.dts
index f419b9ee9d1e..09e4a7635c04 100644
--- a/arch/arm/boot/dts/sun7i-a20-olimex-som-evb.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olimex-som-evb.dts
@@ -112,7 +112,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts b/arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts
index d3d03b7ffb1a..928bad7b98c6 100644
--- a/arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olimex-som204-evb.dts
@@ -106,7 +106,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy3>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	phy-supply = <&reg_vcc3v3>;
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime.dts
index 70a883276d34..0a0f125ee2da 100644
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime.dts
@@ -107,7 +107,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_mii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
index 0fe657e062a7..ebf32437ab5f 100644
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
@@ -112,7 +112,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
index 559736961b54..b9e903d61d8e 100644
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
@@ -119,7 +119,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_mii_pins>, <&gmac_txerr>;
 	phy-handle = <&phy1>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun7i-a20-orangepi-mini.dts b/arch/arm/boot/dts/sun7i-a20-orangepi-mini.dts
index a94ff50bcf73..f2d395e62785 100644
--- a/arch/arm/boot/dts/sun7i-a20-orangepi-mini.dts
+++ b/arch/arm/boot/dts/sun7i-a20-orangepi-mini.dts
@@ -121,7 +121,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	phy-supply = <&reg_gmac_3v3>;
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/sun7i-a20-orangepi.dts b/arch/arm/boot/dts/sun7i-a20-orangepi.dts
index 956579a10b5f..617695ceeee3 100644
--- a/arch/arm/boot/dts/sun7i-a20-orangepi.dts
+++ b/arch/arm/boot/dts/sun7i-a20-orangepi.dts
@@ -97,7 +97,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	phy-supply = <&reg_gmac_3v3>;
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/sun7i-a20-pcduino3-nano.dts b/arch/arm/boot/dts/sun7i-a20-pcduino3-nano.dts
index 993fb97d19df..ce59db45c6ea 100644
--- a/arch/arm/boot/dts/sun7i-a20-pcduino3-nano.dts
+++ b/arch/arm/boot/dts/sun7i-a20-pcduino3-nano.dts
@@ -115,7 +115,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun7i-a20-pcduino3.dts b/arch/arm/boot/dts/sun7i-a20-pcduino3.dts
index 02e321523d0e..c7c1573b6612 100644
--- a/arch/arm/boot/dts/sun7i-a20-pcduino3.dts
+++ b/arch/arm/boot/dts/sun7i-a20-pcduino3.dts
@@ -123,7 +123,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_mii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun7i-a20-wits-pro-a20-dkt.dts b/arch/arm/boot/dts/sun7i-a20-wits-pro-a20-dkt.dts
index 9dfe7e2a08cc..9f89faec0e07 100644
--- a/arch/arm/boot/dts/sun7i-a20-wits-pro-a20-dkt.dts
+++ b/arch/arm/boot/dts/sun7i-a20-wits-pro-a20-dkt.dts
@@ -82,7 +82,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
diff --git a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
index 9d34eabba121..823e6d42a8f1 100644
--- a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
@@ -131,7 +131,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_sw>;
 	phy-handle = <&rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	allwinner,rx-delay-ps = <700>;
 	allwinner,tx-delay-ps = <700>;
 	status = "okay";
diff --git a/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts b/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts
index ea299d3d84d0..d98fe7074148 100644
--- a/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts
@@ -168,7 +168,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_dldo4>;
 	phy-handle = <&rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts b/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts
index 42d62d1ba1dc..6245927065b2 100644
--- a/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts
+++ b/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts
@@ -129,7 +129,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	phy-supply = <&reg_dc1sw>;
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts b/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
index 15c22b06fc4b..f4b54cb3a231 100644
--- a/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
+++ b/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
@@ -120,7 +120,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	phy-supply = <&reg_dc1sw>;
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts b/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts
index 650890b049e2..dfd6ba7e8faa 100644
--- a/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts
+++ b/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts
@@ -129,7 +129,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	phy-supply = <&reg_cldo1>;
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/sun9i-a80-optimus.dts b/arch/arm/boot/dts/sun9i-a80-optimus.dts
index 03ad25534f20..c80532fe6c03 100644
--- a/arch/arm/boot/dts/sun9i-a80-optimus.dts
+++ b/arch/arm/boot/dts/sun9i-a80-optimus.dts
@@ -124,7 +124,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	phy-supply = <&reg_cldo1>;
 	status = "okay";
 
-- 
git-series 0.9.1
