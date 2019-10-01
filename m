Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8B35C2F04
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 10:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732979AbfJAIlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 04:41:06 -0400
Received: from hermes.aosc.io ([199.195.250.187]:52091 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbfJAIlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 04:41:06 -0400
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: icenowy@aosc.io)
        by hermes.aosc.io (Postfix) with ESMTPSA id 5F36E82B13;
        Tue,  1 Oct 2019 08:32:20 +0000 (UTC)
From:   Icenowy Zheng <icenowy@aosc.io>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, Icenowy Zheng <icenowy@aosc.io>
Subject: [PATCH 3/3] arm64: allwinner: a64: dts: apply hack for RTL8211E on Pine64+
Date:   Tue,  1 Oct 2019 16:29:12 +0800
Message-Id: <20191001082912.12905-4-icenowy@aosc.io>
In-Reply-To: <20191001082912.12905-1-icenowy@aosc.io>
References: <20191001082912.12905-1-icenowy@aosc.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the Pine64+ boards are known to use a batch of broken RTL8211E
PHYs. A magic number that is in an undocumented field of a register is
passed from Realtek via Pine64.

Add the property to apply the hack to the Pine64+ device tree.

Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts
index 24f1aac366d6..4d68f850d03a 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts
@@ -61,5 +61,6 @@
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		realtek,config-magic-for-pine64;
 	};
 };
-- 
2.21.0

