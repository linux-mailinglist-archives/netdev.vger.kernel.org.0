Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5D54B55F
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 11:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731571AbfFSJsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 05:48:47 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:49257 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731498AbfFSJsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 05:48:46 -0400
X-Originating-IP: 90.88.23.150
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 9D2141BF223;
        Wed, 19 Jun 2019 09:48:32 +0000 (UTC)
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
Subject: [PATCH v3 15/16] ARM: dts: sunxi: h3/h5: Switch from phy-mode to phy-connection-type
Date:   Wed, 19 Jun 2019 11:47:24 +0200
Message-Id: <b972da9d2751fa0868421a20a1232d9131c87ffc.1560937626.git-series.maxime.ripard@bootlin.com>
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
 arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts                    | 2 +-
 arch/arm/boot/dts/sun8i-h3-beelink-x2.dts                            | 2 +-
 arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts                      | 2 +-
 arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts                        | 2 +-
 arch/arm/boot/dts/sun8i-h3-nanopi-m1.dts                             | 2 +-
 arch/arm/boot/dts/sun8i-h3-nanopi-neo.dts                            | 2 +-
 arch/arm/boot/dts/sun8i-h3-orangepi-2.dts                            | 2 +-
 arch/arm/boot/dts/sun8i-h3-orangepi-one.dts                          | 2 +-
 arch/arm/boot/dts/sun8i-h3-orangepi-pc.dts                           | 2 +-
 arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts                         | 2 +-
 arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts                       | 2 +-
 arch/arm/boot/dts/sun8i-h3-rervision-dvk.dts                         | 2 +-
 arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi                        | 2 +-
 arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi                     | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5-emlid-neutis-n5-devboard.dts | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo-plus2.dts         | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts              | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts             | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts           | 2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts       | 2 +-
 20 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts b/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
index f19ed981da9d..671f21e1b771 100644
--- a/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
+++ b/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
@@ -126,7 +126,7 @@
 
 &emac {
 	phy-handle = <&int_mii_phy>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	allwinner,leds-active-low;
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sun8i-h3-beelink-x2.dts b/arch/arm/boot/dts/sun8i-h3-beelink-x2.dts
index ac9e26b1d906..782aac0cd2fe 100644
--- a/arch/arm/boot/dts/sun8i-h3-beelink-x2.dts
+++ b/arch/arm/boot/dts/sun8i-h3-beelink-x2.dts
@@ -127,7 +127,7 @@
 
 &emac {
 	phy-handle = <&int_mii_phy>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	allwinner,leds-active-low;
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts b/arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts
index ff0a7a952e0c..59ac1d349afa 100644
--- a/arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts
+++ b/arch/arm/boot/dts/sun8i-h3-mapleboard-mp130.dts
@@ -77,7 +77,7 @@
 
 &emac {
 	phy-handle = <&int_mii_phy>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	allwinner,leds-active-low;
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts b/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
index 4ba533b0340f..54cfa753853f 100644
--- a/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
+++ b/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
@@ -96,7 +96,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sun8i-h3-nanopi-m1.dts b/arch/arm/boot/dts/sun8i-h3-nanopi-m1.dts
index 69243dcb30a6..e53458bf8c46 100644
--- a/arch/arm/boot/dts/sun8i-h3-nanopi-m1.dts
+++ b/arch/arm/boot/dts/sun8i-h3-nanopi-m1.dts
@@ -76,7 +76,7 @@
 
 &emac {
 	phy-handle = <&int_mii_phy>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	allwinner,leds-active-low;
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sun8i-h3-nanopi-neo.dts b/arch/arm/boot/dts/sun8i-h3-nanopi-neo.dts
index 9f33f6fae595..744b35e4f50b 100644
--- a/arch/arm/boot/dts/sun8i-h3-nanopi-neo.dts
+++ b/arch/arm/boot/dts/sun8i-h3-nanopi-neo.dts
@@ -53,7 +53,7 @@
 
 &emac {
 	phy-handle = <&int_mii_phy>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	allwinner,leds-active-low;
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sun8i-h3-orangepi-2.dts b/arch/arm/boot/dts/sun8i-h3-orangepi-2.dts
index 597c425d08ec..61ee3790ec94 100644
--- a/arch/arm/boot/dts/sun8i-h3-orangepi-2.dts
+++ b/arch/arm/boot/dts/sun8i-h3-orangepi-2.dts
@@ -129,7 +129,7 @@
 
 &emac {
 	phy-handle = <&int_mii_phy>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	allwinner,leds-active-low;
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sun8i-h3-orangepi-one.dts b/arch/arm/boot/dts/sun8i-h3-orangepi-one.dts
index 4759ba3f2986..adf5c2508b80 100644
--- a/arch/arm/boot/dts/sun8i-h3-orangepi-one.dts
+++ b/arch/arm/boot/dts/sun8i-h3-orangepi-one.dts
@@ -131,7 +131,7 @@
 
 &emac {
 	phy-handle = <&int_mii_phy>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	allwinner,leds-active-low;
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sun8i-h3-orangepi-pc.dts b/arch/arm/boot/dts/sun8i-h3-orangepi-pc.dts
index 5aff8ecc66cb..4b7d8692eb38 100644
--- a/arch/arm/boot/dts/sun8i-h3-orangepi-pc.dts
+++ b/arch/arm/boot/dts/sun8i-h3-orangepi-pc.dts
@@ -131,7 +131,7 @@
 
 &emac {
 	phy-handle = <&int_mii_phy>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	allwinner,leds-active-low;
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts b/arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts
index 97f497854e05..49885968ca3d 100644
--- a/arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts
+++ b/arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts
@@ -85,7 +85,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts b/arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts
index 6dbf7b2e0c13..33c7df1ae939 100644
--- a/arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts
+++ b/arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts
@@ -67,7 +67,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/sun8i-h3-rervision-dvk.dts b/arch/arm/boot/dts/sun8i-h3-rervision-dvk.dts
index 4738f3a9efe4..b5bf16a0ce97 100644
--- a/arch/arm/boot/dts/sun8i-h3-rervision-dvk.dts
+++ b/arch/arm/boot/dts/sun8i-h3-rervision-dvk.dts
@@ -54,7 +54,7 @@
 
 &emac {
 	phy-handle = <&int_mii_phy>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	allwinner,leds-active-low;
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi b/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
index 39263e74fbb5..c13f56f7aeb6 100644
--- a/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
+++ b/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
@@ -126,7 +126,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi b/arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi
index 19b3b23cfaa8..d6a47c63cae4 100644
--- a/arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi
+++ b/arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi
@@ -150,7 +150,7 @@
 
 &emac {
 	phy-handle = <&int_mii_phy>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	allwinner,leds-active-low;
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-emlid-neutis-n5-devboard.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-emlid-neutis-n5-devboard.dts
index c924090331d0..d15f994b59eb 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-emlid-neutis-n5-devboard.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-emlid-neutis-n5-devboard.dts
@@ -91,7 +91,7 @@
 
 &emac {
 	phy-handle = <&int_mii_phy>;
-	phy-mode = "mii";
+	phy-connection-type = "mii";
 	allwinner,leds-active-low;
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo-plus2.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo-plus2.dts
index 1c7dde84e54d..2914d62dbe8a 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo-plus2.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo-plus2.dts
@@ -135,7 +135,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
index 57a6f45036c1..5b20ae3edcdf 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
@@ -114,7 +114,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts
index e126c1c9f05c..a9cce14b8341 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts
@@ -157,7 +157,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts
index d9b3ed257088..80e9dd67316e 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts
@@ -164,7 +164,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts
index db6ea7b58999..5a7bc3aa5ae4 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts
@@ -72,7 +72,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii";
 	status = "okay";
 };
 
-- 
git-series 0.9.1
