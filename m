Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C6A40475A
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 10:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhIIIvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 04:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbhIIIvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 04:51:09 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62F2C0613D9
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 01:49:57 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:7d44:646d:3ffb:9bbf])
        by michel.telenet-ops.be with bizsmtp
        id rkpq2500A3eH4vN06kpqpz; Thu, 09 Sep 2021 10:49:56 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkj-003Cqn-Sb; Thu, 09 Sep 2021 10:49:49 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkj-00Aj54-3N; Thu, 09 Sep 2021 10:49:49 +0200
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
Subject: [PATCH 1/9] ARM: dts: renesas: Add compatible properties to KSZ8041 Ethernet PHYs
Date:   Thu,  9 Sep 2021 10:49:37 +0200
Message-Id: <f9e26625924f90eff34fe6f6f02b15fa272c5d80.1631174218.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1631174218.git.geert+renesas@glider.be>
References: <cover.1631174218.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible values to Ethernet PHY subnodes representing Micrel
KSZ8041 PHYs on RZ/G1 and R-Car Gen2 boards.  This allows software to
identify the PHY model at any time, regardless of the state of the PHY
reset line.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/boot/dts/r8a7743-sk-rzg1m.dts | 2 ++
 arch/arm/boot/dts/r8a7745-sk-rzg1e.dts | 2 ++
 arch/arm/boot/dts/r8a7790-lager.dts    | 2 ++
 arch/arm/boot/dts/r8a7790-stout.dts    | 2 ++
 arch/arm/boot/dts/r8a7791-koelsch.dts  | 2 ++
 arch/arm/boot/dts/r8a7791-porter.dts   | 2 ++
 arch/arm/boot/dts/r8a7793-gose.dts     | 2 ++
 arch/arm/boot/dts/r8a7794-alt.dts      | 2 ++
 arch/arm/boot/dts/r8a7794-silk.dts     | 2 ++
 9 files changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7743-sk-rzg1m.dts b/arch/arm/boot/dts/r8a7743-sk-rzg1m.dts
index 4ace117470e800f8..ce36cf404fa2b1c4 100644
--- a/arch/arm/boot/dts/r8a7743-sk-rzg1m.dts
+++ b/arch/arm/boot/dts/r8a7743-sk-rzg1m.dts
@@ -69,6 +69,8 @@ &ether {
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
+		compatible = "ethernet-phy-id0022.1537",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
 		interrupt-parent = <&irqc>;
 		interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
diff --git a/arch/arm/boot/dts/r8a7745-sk-rzg1e.dts b/arch/arm/boot/dts/r8a7745-sk-rzg1e.dts
index 59d1a9bfab05a27e..4ab6d3fcc857f7db 100644
--- a/arch/arm/boot/dts/r8a7745-sk-rzg1e.dts
+++ b/arch/arm/boot/dts/r8a7745-sk-rzg1e.dts
@@ -64,6 +64,8 @@ &ether {
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
+		compatible = "ethernet-phy-id0022.1537",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
 		interrupt-parent = <&irqc>;
 		interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index fa6d986b5d4632cf..57cd2fa722490b08 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -678,6 +678,8 @@ &ether {
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
+		compatible = "ethernet-phy-id0022.1537",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
 		interrupt-parent = <&irqc0>;
 		interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
diff --git a/arch/arm/boot/dts/r8a7790-stout.dts b/arch/arm/boot/dts/r8a7790-stout.dts
index d51f23572d7fc727..c802f9f13c18b837 100644
--- a/arch/arm/boot/dts/r8a7790-stout.dts
+++ b/arch/arm/boot/dts/r8a7790-stout.dts
@@ -199,6 +199,8 @@ &ether {
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
+		compatible = "ethernet-phy-id0022.1537",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
 		interrupt-parent = <&irqc0>;
 		interrupts = <1 IRQ_TYPE_LEVEL_LOW>;
diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index 2a8b6fd9095cceba..6e691b6cac05cdf4 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -637,6 +637,8 @@ &ether {
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
+		compatible = "ethernet-phy-id0022.1537",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
 		interrupt-parent = <&irqc0>;
 		interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
diff --git a/arch/arm/boot/dts/r8a7791-porter.dts b/arch/arm/boot/dts/r8a7791-porter.dts
index c6ef636965c16f39..38e2ab928707d99e 100644
--- a/arch/arm/boot/dts/r8a7791-porter.dts
+++ b/arch/arm/boot/dts/r8a7791-porter.dts
@@ -302,6 +302,8 @@ &ether {
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
+		compatible = "ethernet-phy-id0022.1537",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
 		interrupt-parent = <&irqc0>;
 		interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
diff --git a/arch/arm/boot/dts/r8a7793-gose.dts b/arch/arm/boot/dts/r8a7793-gose.dts
index 479e0fdf0c37311e..c8978f4f62e9f2dc 100644
--- a/arch/arm/boot/dts/r8a7793-gose.dts
+++ b/arch/arm/boot/dts/r8a7793-gose.dts
@@ -595,6 +595,8 @@ &ether {
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
+		compatible = "ethernet-phy-id0022.1537",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
 		interrupt-parent = <&irqc0>;
 		interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
diff --git a/arch/arm/boot/dts/r8a7794-alt.dts b/arch/arm/boot/dts/r8a7794-alt.dts
index f330d796a772c394..99d554fe3329eb7a 100644
--- a/arch/arm/boot/dts/r8a7794-alt.dts
+++ b/arch/arm/boot/dts/r8a7794-alt.dts
@@ -383,6 +383,8 @@ &ether {
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
+		compatible = "ethernet-phy-id0022.1537",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
 		interrupt-parent = <&irqc0>;
 		interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
diff --git a/arch/arm/boot/dts/r8a7794-silk.dts b/arch/arm/boot/dts/r8a7794-silk.dts
index cafa3046daa4baf4..92a76164432a8976 100644
--- a/arch/arm/boot/dts/r8a7794-silk.dts
+++ b/arch/arm/boot/dts/r8a7794-silk.dts
@@ -397,6 +397,8 @@ &ether {
 	status = "okay";
 
 	phy1: ethernet-phy@1 {
+		compatible = "ethernet-phy-id0022.1537",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
 		interrupt-parent = <&irqc0>;
 		interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
-- 
2.25.1

