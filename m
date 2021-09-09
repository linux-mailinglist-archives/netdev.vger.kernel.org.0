Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C91F40475B
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 10:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhIIIvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 04:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbhIIIvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 04:51:08 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F719C06129E
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 01:49:57 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:7d44:646d:3ffb:9bbf])
        by michel.telenet-ops.be with bizsmtp
        id rkpq2500L3eH4vN06kpqq4; Thu, 09 Sep 2021 10:49:56 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkk-003Cqv-6f; Thu, 09 Sep 2021 10:49:50 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkj-00Aj65-9m; Thu, 09 Sep 2021 10:49:49 +0200
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
Subject: [PATCH 9/9] arm64: dts: renesas: Add compatible properties to RTL8211E Ethernet PHYs
Date:   Thu,  9 Sep 2021 10:49:45 +0200
Message-Id: <3b366e3dddd4d3cd7e89b92d3a8f78f6dc18e244.1631174218.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1631174218.git.geert+renesas@glider.be>
References: <cover.1631174218.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible values to Ethernet PHY subnodes representing Realtek
RTL8211E PHYs on RZ/G2 boards.  This allows software to identify the PHY
model at any time, regardless of the state of the PHY reset line.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm64/boot/dts/renesas/cat875.dtsi         | 2 ++
 arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/cat875.dtsi b/arch/arm64/boot/dts/renesas/cat875.dtsi
index 801ea54b027c43d9..a69d24e9c61db052 100644
--- a/arch/arm64/boot/dts/renesas/cat875.dtsi
+++ b/arch/arm64/boot/dts/renesas/cat875.dtsi
@@ -21,6 +21,8 @@ &avb {
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-id001c.c915",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		interrupt-parent = <&gpio2>;
 		interrupts = <21 IRQ_TYPE_LEVEL_LOW>;
diff --git a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
index dde3a07bc417c690..ad898c6db4e62df6 100644
--- a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
+++ b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
@@ -24,6 +24,8 @@ &avb {
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-id001c.c915",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		interrupt-parent = <&gpio2>;
 		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
-- 
2.25.1

