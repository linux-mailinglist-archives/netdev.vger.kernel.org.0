Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01ED9404750
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 10:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhIIIvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 04:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhIIIvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 04:51:06 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA7DC0613A4
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 01:49:56 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:7d44:646d:3ffb:9bbf])
        by laurent.telenet-ops.be with bizsmtp
        id rkpq250043eH4vN01kpqEw; Thu, 09 Sep 2021 10:49:54 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkj-003Cqp-N5; Thu, 09 Sep 2021 10:49:49 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkj-00Aj5O-4z; Thu, 09 Sep 2021 10:49:49 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Magnus Damm <magnus.damm@gmail.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3/9] ARM: dts: renesas: Add compatible properties to KSZ9031 Ethernet PHYs
Date:   Thu,  9 Sep 2021 10:49:39 +0200
Message-Id: <ce8ae6b199fa244315a008ae31891a808ca1948d.1631174218.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1631174218.git.geert+renesas@glider.be>
References: <cover.1631174218.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible values to Ethernet PHY subnodes representing Micrel
KSZ9031 PHYs on RZ/G1 boards. This allows software to identify the PHY
model at any time, regardless of the state of the PHY reset line.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
I could not verify the PHY revision number (least significant nibble of
the ID), due to lack of hardware.
---
 arch/arm/boot/dts/iwg20d-q7-common.dtsi     | 2 ++
 arch/arm/boot/dts/r8a7742-iwg21d-q7.dts     | 2 ++
 arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts | 2 ++
 arch/arm/boot/dts/r8a77470-iwg23s-sbc.dts   | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/iwg20d-q7-common.dtsi b/arch/arm/boot/dts/iwg20d-q7-common.dtsi
index bc857676d19104a1..849034a49a3f98e2 100644
--- a/arch/arm/boot/dts/iwg20d-q7-common.dtsi
+++ b/arch/arm/boot/dts/iwg20d-q7-common.dtsi
@@ -158,6 +158,8 @@ &avb {
 	status = "okay";
 
 	phy3: ethernet-phy@3 {
+		compatible = "ethernet-phy-id0022.1622",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <3>;
 		micrel,led-mode = <1>;
 	};
diff --git a/arch/arm/boot/dts/r8a7742-iwg21d-q7.dts b/arch/arm/boot/dts/r8a7742-iwg21d-q7.dts
index 94bf8a116b5242a9..a5a79cdbcd0ee09b 100644
--- a/arch/arm/boot/dts/r8a7742-iwg21d-q7.dts
+++ b/arch/arm/boot/dts/r8a7742-iwg21d-q7.dts
@@ -175,6 +175,8 @@ &avb {
 	status = "okay";
 
 	phy3: ethernet-phy@3 {
+		compatible = "ethernet-phy-id0022.1622",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <3>;
 		micrel,led-mode = <1>;
 	};
diff --git a/arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts b/arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts
index 73bd62d8a929e5da..c105932f642ea517 100644
--- a/arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts
+++ b/arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts
@@ -123,6 +123,8 @@ phy3: ethernet-phy@3 {
 	 * On some older versions of the platform (before R4.0) the phy address
 	 * may be 1 or 3. The address is fixed to 3 for R4.0 onwards.
 	 */
+		compatible = "ethernet-phy-id0022.1622",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <3>;
 		micrel,led-mode = <1>;
 	};
diff --git a/arch/arm/boot/dts/r8a77470-iwg23s-sbc.dts b/arch/arm/boot/dts/r8a77470-iwg23s-sbc.dts
index 8ac61b50aec03190..b024621c998103b2 100644
--- a/arch/arm/boot/dts/r8a77470-iwg23s-sbc.dts
+++ b/arch/arm/boot/dts/r8a77470-iwg23s-sbc.dts
@@ -79,6 +79,8 @@ &avb {
 	status = "okay";
 
 	phy3: ethernet-phy@3 {
+		compatible = "ethernet-phy-id0022.1622",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <3>;
 		interrupt-parent = <&gpio5>;
 		interrupts = <16 IRQ_TYPE_LEVEL_LOW>;
-- 
2.25.1

