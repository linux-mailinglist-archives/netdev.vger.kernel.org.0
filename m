Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A00AA7C303
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 15:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387958AbfGaNMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 09:12:06 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:40050 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387636AbfGaNMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 09:12:05 -0400
Received: from ramsan ([84.194.98.4])
        by xavier.telenet-ops.be with bizsmtp
        id jRC42000405gfCL01RC4H6; Wed, 31 Jul 2019 15:12:04 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoOh-00014Q-U1; Wed, 31 Jul 2019 15:12:03 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoOh-0004Mt-R2; Wed, 31 Jul 2019 15:12:03 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Felix Fietkau <nbd@openwrt.org>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net: mediatek: Drop unneeded dependency on NET_VENDOR_MEDIATEK
Date:   Wed, 31 Jul 2019 15:12:02 +0200
Message-Id: <20190731131202.16749-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The whole block is protected by "if NET_VENDOR_MEDIATEK", so there is
no need for individual driver config symbols to duplicate this
dependency.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/mediatek/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index 263cd0909fe0de39..1f7fff81f24dbb96 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -9,7 +9,6 @@ if NET_VENDOR_MEDIATEK
 
 config NET_MEDIATEK_SOC
 	tristate "MediaTek SoC Gigabit Ethernet support"
-	depends on NET_VENDOR_MEDIATEK
 	select PHYLIB
 	---help---
 	  This driver supports the gigabit ethernet MACs in the
-- 
2.17.1

