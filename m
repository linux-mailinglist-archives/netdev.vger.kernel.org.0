Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A5B404759
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 10:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhIIIvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 04:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbhIIIvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 04:51:10 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16D2C0612A4
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 01:49:57 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:7d44:646d:3ffb:9bbf])
        by michel.telenet-ops.be with bizsmtp
        id rkpq2500D3eH4vN06kpqq1; Thu, 09 Sep 2021 10:49:56 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkj-003Cqu-TX; Thu, 09 Sep 2021 10:49:49 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkj-00Aj5x-8w; Thu, 09 Sep 2021 10:49:49 +0200
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
Subject: [PATCH 8/9] arm64: dts: renesas: Add compatible properties to KSZ9031 Ethernet PHYs
Date:   Thu,  9 Sep 2021 10:49:44 +0200
Message-Id: <07bd7e04dda9e84cde0664980f0b1a6d69e03109.1631174218.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1631174218.git.geert+renesas@glider.be>
References: <cover.1631174218.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible values to Ethernet PHY subnodes representing Micrel
KSZ9031 PHYs on R-Car Gen3 boards.  This allows software to identify the
PHY model at any time, regardless of the state of the PHY reset line.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
I could not verify the PHY revision number (least significant nibble of
the ID) on eagle, v3msk, conder, and v3hsk, due to lack of hardware.
---
 arch/arm64/boot/dts/renesas/draak.dtsi           | 2 ++
 arch/arm64/boot/dts/renesas/ebisu.dtsi           | 2 ++
 arch/arm64/boot/dts/renesas/r8a77970-eagle.dts   | 2 ++
 arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts   | 2 ++
 arch/arm64/boot/dts/renesas/r8a77980-condor.dts  | 2 ++
 arch/arm64/boot/dts/renesas/r8a77980-v3hsk.dts   | 2 ++
 arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts  | 2 ++
 arch/arm64/boot/dts/renesas/salvator-common.dtsi | 2 ++
 arch/arm64/boot/dts/renesas/ulcb.dtsi            | 2 ++
 9 files changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/draak.dtsi b/arch/arm64/boot/dts/renesas/draak.dtsi
index ff799ab73f8a479d..5f5a0bb2da86cc57 100644
--- a/arch/arm64/boot/dts/renesas/draak.dtsi
+++ b/arch/arm64/boot/dts/renesas/draak.dtsi
@@ -243,6 +243,8 @@ &avb {
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-id0022.1622",
+			     "ethernet-phy-ieee802.3-c22";
 		rxc-skew-ps = <1500>;
 		reg = <0>;
 		interrupt-parent = <&gpio5>;
diff --git a/arch/arm64/boot/dts/renesas/ebisu.dtsi b/arch/arm64/boot/dts/renesas/ebisu.dtsi
index 54f88bb7e5920296..0fdfc67cb965afd9 100644
--- a/arch/arm64/boot/dts/renesas/ebisu.dtsi
+++ b/arch/arm64/boot/dts/renesas/ebisu.dtsi
@@ -302,6 +302,8 @@ &avb {
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-id0022.1622",
+			     "ethernet-phy-ieee802.3-c22";
 		rxc-skew-ps = <1500>;
 		reg = <0>;
 		interrupt-parent = <&gpio2>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77970-eagle.dts b/arch/arm64/boot/dts/renesas/r8a77970-eagle.dts
index d24da54f312b9085..c7451973f8a5b2a7 100644
--- a/arch/arm64/boot/dts/renesas/r8a77970-eagle.dts
+++ b/arch/arm64/boot/dts/renesas/r8a77970-eagle.dts
@@ -92,6 +92,8 @@ &avb {
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-id0022.1622",
+			     "ethernet-phy-ieee802.3-c22";
 		rxc-skew-ps = <1500>;
 		reg = <0>;
 		interrupt-parent = <&gpio1>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts b/arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts
index 2426e533128ceb42..2f77ec4ed7e16166 100644
--- a/arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts
+++ b/arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts
@@ -107,6 +107,8 @@ &avb {
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-id0022.1622",
+			     "ethernet-phy-ieee802.3-c22";
 		rxc-skew-ps = <1500>;
 		reg = <0>;
 		interrupt-parent = <&gpio1>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77980-condor.dts b/arch/arm64/boot/dts/renesas/r8a77980-condor.dts
index edf7f2a2f958787c..4cb5bfa6932d5809 100644
--- a/arch/arm64/boot/dts/renesas/r8a77980-condor.dts
+++ b/arch/arm64/boot/dts/renesas/r8a77980-condor.dts
@@ -132,6 +132,8 @@ &gether {
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-id0022.1622",
+			     "ethernet-phy-ieee802.3-c22";
 		rxc-skew-ps = <1500>;
 		reg = <0>;
 		interrupt-parent = <&gpio4>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77980-v3hsk.dts b/arch/arm64/boot/dts/renesas/r8a77980-v3hsk.dts
index 7838dcee31362705..ca69d1b1d67af047 100644
--- a/arch/arm64/boot/dts/renesas/r8a77980-v3hsk.dts
+++ b/arch/arm64/boot/dts/renesas/r8a77980-v3hsk.dts
@@ -113,6 +113,8 @@ &gether {
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-id0022.1622",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		interrupt-parent = <&gpio4>;
 		interrupts = <23 IRQ_TYPE_LEVEL_LOW>;
diff --git a/arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts b/arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts
index dc671ff57ec7678a..e46dc9aa0a43a60f 100644
--- a/arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts
+++ b/arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts
@@ -27,6 +27,8 @@ &avb0 {
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-id0022.1622",
+			     "ethernet-phy-ieee802.3-c22";
 		rxc-skew-ps = <1500>;
 		reg = <0>;
 		interrupt-parent = <&gpio4>;
diff --git a/arch/arm64/boot/dts/renesas/salvator-common.dtsi b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
index de959f28ad6ce27b..04ba101a711119a4 100644
--- a/arch/arm64/boot/dts/renesas/salvator-common.dtsi
+++ b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
@@ -346,6 +346,8 @@ &avb {
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-id0022.1622",
+			     "ethernet-phy-ieee802.3-c22";
 		rxc-skew-ps = <1500>;
 		reg = <0>;
 		interrupt-parent = <&gpio2>;
diff --git a/arch/arm64/boot/dts/renesas/ulcb.dtsi b/arch/arm64/boot/dts/renesas/ulcb.dtsi
index 1f177af3eb9dfa37..7edffe7f8cfa326f 100644
--- a/arch/arm64/boot/dts/renesas/ulcb.dtsi
+++ b/arch/arm64/boot/dts/renesas/ulcb.dtsi
@@ -154,6 +154,8 @@ &avb {
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-id0022.1622",
+			     "ethernet-phy-ieee802.3-c22";
 		rxc-skew-ps = <1500>;
 		reg = <0>;
 		interrupt-parent = <&gpio2>;
-- 
2.25.1

