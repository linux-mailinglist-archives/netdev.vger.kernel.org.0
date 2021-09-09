Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEF8404747
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 10:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhIIIvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 04:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbhIIIvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 04:51:05 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D601C0613CF
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 01:49:56 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:7d44:646d:3ffb:9bbf])
        by albert.telenet-ops.be with bizsmtp
        id rkpq2500Z3eH4vN06kpqrR; Thu, 09 Sep 2021 10:49:54 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkj-003Cqt-Ur; Thu, 09 Sep 2021 10:49:49 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkj-00Aj5q-8A; Thu, 09 Sep 2021 10:49:49 +0200
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
Subject: [PATCH 7/9] arm64: dts: renesas: Add compatible properties to AR8031 Ethernet PHYs
Date:   Thu,  9 Sep 2021 10:49:43 +0200
Message-Id: <3f1b58756f149f0c634c66abaecc88e699f4c3cc.1631174218.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1631174218.git.geert+renesas@glider.be>
References: <cover.1631174218.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible values to Ethernet PHY subnodes representing Atheros
AR8031 PHYs on RZ/G2 boards.  This allows software to identify the PHY
model at any time, regardless of the state of the PHY reset line.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
index 090dc9c4f57b5be1..a06cf770c12faa90 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
@@ -58,6 +58,8 @@ &avb {
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-id004d.d074",
+			     "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		interrupt-parent = <&gpio2>;
 		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
-- 
2.25.1

