Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E68136AAB7
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhDZCmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:42:14 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37572 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbhDZCmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:42:13 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 0C5051F41EC4
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>, kernel@collabora.com
Subject: [PATCH 1/3] arm64: dts: rockchip: Remove unnecessary reset in rk3328.dtsi
Date:   Sun, 25 Apr 2021 23:41:16 -0300
Message-Id: <20210426024118.18717-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rockchip DWMAC glue driver uses the phy node (phy-handle)
reset specifier, and not a "mac-phy" reset specifier.

Remove it.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 5bab61784735..3ed69ecbcf3c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -916,8 +916,8 @@ gmac2phy: ethernet@ff550000 {
 			      "mac_clk_tx", "clk_mac_ref",
 			      "aclk_mac", "pclk_mac",
 			      "clk_macphy";
-		resets = <&cru SRST_GMAC2PHY_A>, <&cru SRST_MACPHY>;
-		reset-names = "stmmaceth", "mac-phy";
+		resets = <&cru SRST_GMAC2PHY_A>;
+		reset-names = "stmmaceth";
 		phy-mode = "rmii";
 		phy-handle = <&phy>;
 		snps,txpbl = <0x4>;
-- 
2.30.0

