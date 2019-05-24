Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4575296D9
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390906AbfEXLM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:12:56 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37655 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391007AbfEXLMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 07:12:39 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1hU87g-0000Ga-QJ; Fri, 24 May 2019 13:12:28 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1hU87e-0007G1-6N; Fri, 24 May 2019 13:12:26 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Chuanhong Guo <gch981213@gmail.com>,
        info@freifunk-bad-gandersheim.net
Subject: [PATCH v6 2/3] MIPS: ath79: ar9331: add Ethernet nodes
Date:   Fri, 24 May 2019 13:12:23 +0200
Message-Id: <20190524111224.24819-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524111224.24819-1-o.rempel@pengutronix.de>
References: <20190524111224.24819-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethernet nodes supported by ag71xx driver.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/mips/boot/dts/qca/ar9331.dtsi           | 26 ++++++++++++++++++++
 arch/mips/boot/dts/qca/ar9331_dpt_module.dts |  8 ++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/mips/boot/dts/qca/ar9331.dtsi b/arch/mips/boot/dts/qca/ar9331.dtsi
index 2bae201aa365..63a9f33aa43e 100644
--- a/arch/mips/boot/dts/qca/ar9331.dtsi
+++ b/arch/mips/boot/dts/qca/ar9331.dtsi
@@ -116,6 +116,32 @@
 			};
 		};
 
+		eth0: ethernet@19000000 {
+			compatible = "qca,ar9330-eth";
+			reg = <0x19000000 0x200>;
+			interrupts = <4>;
+
+			resets = <&rst 9>, <&rst 22>;
+			reset-names = "mac", "mdio";
+			clocks = <&pll ATH79_CLK_AHB>, <&pll ATH79_CLK_AHB>;
+			clock-names = "eth", "mdio";
+
+			status = "disabled";
+		};
+
+		eth1: ethernet@1a000000 {
+			compatible = "qca,ar9330-eth";
+			reg = <0x1a000000 0x200>;
+			interrupts = <5>;
+
+			resets = <&rst 13>, <&rst 23>;
+			reset-names = "mac", "mdio";
+			clocks = <&pll ATH79_CLK_AHB>, <&pll ATH79_CLK_AHB>;
+			clock-names = "eth", "mdio";
+
+			status = "disabled";
+		};
+
 		usb: usb@1b000100 {
 			compatible = "chipidea,usb2";
 			reg = <0x1b000000 0x200>;
diff --git a/arch/mips/boot/dts/qca/ar9331_dpt_module.dts b/arch/mips/boot/dts/qca/ar9331_dpt_module.dts
index e7af2cf5f4c1..77bab823eb3b 100644
--- a/arch/mips/boot/dts/qca/ar9331_dpt_module.dts
+++ b/arch/mips/boot/dts/qca/ar9331_dpt_module.dts
@@ -76,3 +76,11 @@
 		reg = <0>;
 	};
 };
+
+&eth0 {
+	status = "okay";
+};
+
+&eth1 {
+	status = "okay";
+};
-- 
2.20.1

