Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B45404758
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 10:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhIIIvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 04:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbhIIIvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 04:51:07 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934EFC06179A
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 01:49:57 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:7d44:646d:3ffb:9bbf])
        by michel.telenet-ops.be with bizsmtp
        id rkpq2500C3eH4vN06kpqq0; Thu, 09 Sep 2021 10:49:56 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkj-003Cqs-Ti; Thu, 09 Sep 2021 10:49:49 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkj-00Aj5j-7O; Thu, 09 Sep 2021 10:49:49 +0200
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
Subject: [PATCH 6/9] ARM: dts: renesas: Add compatible properties to uPD6061x Ethernet PHYs
Date:   Thu,  9 Sep 2021 10:49:42 +0200
Message-Id: <335a1dfea905369da683e122e41e08ca1c5f90f7.1631174218.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1631174218.git.geert+renesas@glider.be>
References: <cover.1631174218.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible values to Ethernet PHY subnodes representing Renesas
uPD60610 or uPD60611 PHYs on RZ/A1 boards.  This allows software to
identify the PHY model at any time, regardless of the state of the PHY
reset line.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/boot/dts/r7s72100-genmai.dts  | 2 ++
 arch/arm/boot/dts/r7s72100-rskrza1.dts | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/r7s72100-genmai.dts b/arch/arm/boot/dts/r7s72100-genmai.dts
index 07d611d2b7b52756..1e8447176b1051f3 100644
--- a/arch/arm/boot/dts/r7s72100-genmai.dts
+++ b/arch/arm/boot/dts/r7s72100-genmai.dts
@@ -108,6 +108,8 @@ &ether {
 	renesas,no-ether-link;
 	phy-handle = <&phy0>;
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-idb824.2814",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 	};
 };
diff --git a/arch/arm/boot/dts/r7s72100-rskrza1.dts b/arch/arm/boot/dts/r7s72100-rskrza1.dts
index 8363f5e9a4acc275..9bfa7d8e2888b9ee 100644
--- a/arch/arm/boot/dts/r7s72100-rskrza1.dts
+++ b/arch/arm/boot/dts/r7s72100-rskrza1.dts
@@ -193,6 +193,8 @@ &ether {
 	renesas,no-ether-link;
 	phy-handle = <&phy0>;
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-idb824.2814",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 	};
 };
-- 
2.25.1

