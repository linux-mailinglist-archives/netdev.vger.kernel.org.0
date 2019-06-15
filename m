Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B09B46F9A
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 12:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfFOKjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 06:39:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41114 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfFOKjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 06:39:17 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so5007785wrm.8;
        Sat, 15 Jun 2019 03:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P/QzgniEGEGclZRpn0KBLWO6OR92A4BDuZ9FnJJVEA8=;
        b=AlwC1tIRdEsAvi9VVVpHVrUDgkd8VLGzLgaMll9PnQSGv07Pe2vtxIA5N5sa7FsK4A
         ogctEvFj/2UQNv+OCPc1MY1BZmqc75dANmN5GPWp87gpSX45JyHnt0GSOGH/ik1LBG8L
         jjPNqzWbzZi8U2sW1kNzvwbXo3iBEIy+zsmcz56B+MJILExti5aVzJZfA2wSavQtrQNO
         tTbCGpk2n8Liq4IGjGaYipznJwoOoQIVbEcbfBQQUcHrYJ4gf+6dHC8PgfR/SdzuEbVI
         7MUhILIiS2VjtnzyBEWuhO0dQwhVmwS7fgY0zmMhfTAUz3YJfT0bHx8Q+35A/0gBrshn
         HjzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P/QzgniEGEGclZRpn0KBLWO6OR92A4BDuZ9FnJJVEA8=;
        b=Kbo+gGSliC/0LuiUQuSBgihGE+rO9+UkG/XyYf0zUzZC/nOOMmICjjejSXSYoP4Sz/
         NJxPjClNtVrJl0IM0R/8ZIIOftZT74mkze+YXMtNiFWOTGQU+htOJ2s0zDqF8rHzragM
         tmGkiyDNZQp+AZyzlQL2lzsQfCWNE9BhzfEO0bSUMZREgy8LYGBHYzkRmzDpE7PemVBo
         ad0wKO/8I3XU5mCkIn6P2pCCoxvf4/7I1fVsSpR3gHGnil24KC0nSqrnPqQfMnEHMPZ2
         DsY+YjE6WozhcCYskXtSYEKFARU9XQcfExOshVWHLK+qCFXg+KdfNCZkfh+NxIoOXk2l
         8nag==
X-Gm-Message-State: APjAAAXyo1gD1N7ASeGaGlQJ/70NWOPNcWvZ5Ofjk5hlycZ5O+Sp834e
        s246LGKD5A54U1/F5p2qing=
X-Google-Smtp-Source: APXvYqxwZcfDY15BDA87kog2PnIW1s/kC9IFZFwJu8gtBOIDtptJuvKR7G46QVBVuO6F98UWNpQdYQ==
X-Received: by 2002:a5d:4087:: with SMTP id o7mr54775869wrp.277.1560595155210;
        Sat, 15 Jun 2019 03:39:15 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C20E00A9A405DFDBBC0790.dip0.t-ipconnect.de. [2003:f1:33c2:e00:a9a4:5df:dbbc:790])
        by smtp.googlemail.com with ESMTPSA id o126sm12209031wmo.31.2019.06.15.03.39.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 03:39:14 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        robin.murphy@arm.com, narmstrong@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 2/4] ARM: dts: meson: switch to the generic Ethernet PHY reset bindings
Date:   Sat, 15 Jun 2019 12:38:30 +0200
Message-Id: <20190615103832.5126-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190615103832.5126-1-martin.blumenstingl@googlemail.com>
References: <20190615103832.5126-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The snps,reset-gpio bindings are deprecated in favour of the generic
"Ethernet PHY reset" bindings.

Replace snps,reset-gpio from the &ethmac node with reset-gpios in the
ethernet-phy node. The old snps,reset-active-low property is now encoded
directly as GPIO flag inside the reset-gpios property.

snps,reset-delays-us is converted to reset-assert-us and
reset-deassert-us. reset-assert-us is the second cell from
snps,reset-delays-us while reset-deassert-us was the third cell.
Instead of blindly copying the old values (which seems strange since
they gave the PHY one second to come out of reset) over this also
updates the delays based on the datasheets:
- RTL8211F PHY on the Odroid-C1 and MXIII-Plus needs a 10ms assert
  delay (the datasheet mentions: "For a complete PHY reset, this pin
  must be asserted low for at least 10ms") and a 30ms deassert delay
  (the datasheet mentions: "Wait for a further 30ms (for internal
  circuits settling time) before accessing the PHY register"). The
  old settings used 10ms for assert and 1000ms for deassert.
- IP101GR PHY on the EC-100 and MXQ needs a 10ms assert delay (the
  datasheet mentions: "Trst | Reset period | 10ms") and a 10ms deassert
  delay as well (the datasheet mentions: "Tclk_MII_rdy | MII/RMII clock
  output ready after reset released | 10ms")). The old settings used
  10ms for assert and 1000ms for deassert.

No functional changes intended.

Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm/boot/dts/meson8b-ec100.dts       | 9 +++++----
 arch/arm/boot/dts/meson8b-mxq.dts         | 9 +++++----
 arch/arm/boot/dts/meson8b-odroidc1.dts    | 9 +++++----
 arch/arm/boot/dts/meson8m2-mxiii-plus.dts | 8 ++++----
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/arm/boot/dts/meson8b-ec100.dts b/arch/arm/boot/dts/meson8b-ec100.dts
index 9bf4249cb60d..96d239d8334e 100644
--- a/arch/arm/boot/dts/meson8b-ec100.dts
+++ b/arch/arm/boot/dts/meson8b-ec100.dts
@@ -234,10 +234,6 @@
 	phy-handle = <&eth_phy0>;
 	phy-mode = "rmii";
 
-	snps,reset-gpio = <&gpio GPIOH_4 0>;
-	snps,reset-delays-us = <0 10000 1000000>;
-	snps,reset-active-low;
-
 	mdio {
 		compatible = "snps,dwmac-mdio";
 		#address-cells = <1>;
@@ -246,6 +242,11 @@
 		eth_phy0: ethernet-phy@0 {
 			/* IC Plus IP101A/G (0x02430c54) */
 			reg = <0>;
+
+			reset-assert-us = <10000>;
+			reset-deassert-us = <10000>;
+			reset-gpios = <&gpio GPIOH_4 GPIO_ACTIVE_LOW>;
+
 			icplus,select-interrupt;
 			interrupt-parent = <&gpio_intc>;
 			/* GPIOH_3 */
diff --git a/arch/arm/boot/dts/meson8b-mxq.dts b/arch/arm/boot/dts/meson8b-mxq.dts
index ef602ab45efd..bb27b34eb346 100644
--- a/arch/arm/boot/dts/meson8b-mxq.dts
+++ b/arch/arm/boot/dts/meson8b-mxq.dts
@@ -91,10 +91,6 @@
 	phy-handle = <&eth_phy0>;
 	phy-mode = "rmii";
 
-	snps,reset-gpio = <&gpio GPIOH_4 0>;
-	snps,reset-delays-us = <0 10000 1000000>;
-	snps,reset-active-low;
-
 	mdio {
 		compatible = "snps,dwmac-mdio";
 		#address-cells = <1>;
@@ -103,6 +99,11 @@
 		eth_phy0: ethernet-phy@0 {
 			/* IC Plus IP101A/G (0x02430c54) */
 			reg = <0>;
+
+			reset-assert-us = <10000>;
+			reset-deassert-us = <10000>;
+			reset-gpios = <&gpio GPIOH_4 GPIO_ACTIVE_LOW>;
+
 			icplus,select-interrupt;
 			interrupt-parent = <&gpio_intc>;
 			/* GPIOH_3 */
diff --git a/arch/arm/boot/dts/meson8b-odroidc1.dts b/arch/arm/boot/dts/meson8b-odroidc1.dts
index 018695b2b83a..86c4614e0a38 100644
--- a/arch/arm/boot/dts/meson8b-odroidc1.dts
+++ b/arch/arm/boot/dts/meson8b-odroidc1.dts
@@ -176,10 +176,6 @@
 &ethmac {
 	status = "okay";
 
-	snps,reset-gpio = <&gpio GPIOH_4 GPIO_ACTIVE_HIGH>;
-	snps,reset-active-low;
-	snps,reset-delays-us = <0 10000 30000>;
-
 	pinctrl-0 = <&eth_rgmii_pins>;
 	pinctrl-names = "default";
 
@@ -195,6 +191,11 @@
 		/* Realtek RTL8211F (0x001cc916) */
 		eth_phy: ethernet-phy@0 {
 			reg = <0>;
+
+			reset-assert-us = <10000>;
+			reset-deassert-us = <30000>;
+			reset-gpios = <&gpio GPIOH_4 GPIO_ACTIVE_LOW>;
+
 			interrupt-parent = <&gpio_intc>;
 			/* GPIOH_3 */
 			interrupts = <17 IRQ_TYPE_LEVEL_LOW>;
diff --git a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
index 59b07a55e461..d54477b1001c 100644
--- a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
+++ b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
@@ -73,10 +73,6 @@
 
 	amlogic,tx-delay-ns = <4>;
 
-	snps,reset-gpio = <&gpio GPIOH_4 0>;
-	snps,reset-delays-us = <0 10000 1000000>;
-	snps,reset-active-low;
-
 	mdio {
 		compatible = "snps,dwmac-mdio";
 		#address-cells = <1>;
@@ -85,6 +81,10 @@
 		eth_phy0: ethernet-phy@0 {
 			/* Realtek RTL8211F (0x001cc916) */
 			reg = <0>;
+
+			reset-assert-us = <10000>;
+			reset-deassert-us = <30000>;
+			reset-gpios = <&gpio GPIOH_4 GPIO_ACTIVE_LOW>;
 		};
 	};
 };
-- 
2.22.0

