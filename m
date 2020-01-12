Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5EC213870E
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 17:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgALQcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 11:32:16 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:50624 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729253AbgALQcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 11:32:15 -0500
Received: from ramsan ([84.195.182.253])
        by xavier.telenet-ops.be with bizsmtp
        id pUYC2100o5USYZQ01UYDvz; Sun, 12 Jan 2020 17:32:13 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iqg9s-0007mR-RZ; Sun, 12 Jan 2020 17:32:12 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iqg9s-0004lo-Op; Sun, 12 Jan 2020 17:32:12 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] net: amd: a2065: Kill Sun LANCE relics
Date:   Sun, 12 Jan 2020 17:32:11 +0100
Message-Id: <20200112163211.18295-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused fields, copied from the Sun LANCE driver eons ago.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/ethernet/amd/a2065.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/a2065.c b/drivers/net/ethernet/amd/a2065.c
index 212fe72a190bcca6..1b025a33b4642f8b 100644
--- a/drivers/net/ethernet/amd/a2065.c
+++ b/drivers/net/ethernet/amd/a2065.c
@@ -118,10 +118,6 @@ struct lance_private {
 	int auto_select;	      /* cable-selection by carrier */
 	unsigned short busmaster_regval;
 
-#ifdef CONFIG_SUNLANCE
-	struct Linux_SBus_DMA *ledma; /* if set this points to ledma and arch=4m */
-	int burst_sizes;	      /* ledma SBus burst sizes */
-#endif
 	struct timer_list         multicast_timer;
 	struct net_device	  *dev;
 };
-- 
2.17.1

