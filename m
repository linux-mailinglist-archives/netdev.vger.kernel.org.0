Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F0E1600A4
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 22:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgBOVSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 16:18:30 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:34900 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgBOVSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 16:18:02 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 9D7EA29ADF; Sat, 15 Feb 2020 16:18:01 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <c21a6263e31a1d994c1ae02f1f73e51d23dc2101.1581800613.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1581800613.git.fthain@telegraphics.com.au>
References: <cover.1581800613.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net-next 1/7] net/sonic: Remove obsolete comment
Date:   Sun, 16 Feb 2020 08:03:32 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comment is meaningless since mark_bh() was removed a long time ago.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 31be3ba66877..e01273654f81 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -594,11 +594,6 @@ static void sonic_rx(struct net_device *dev)
 
 	if (rbe)
 		SONIC_WRITE(SONIC_ISR, SONIC_INT_RBE);
-	/*
-	 * If any worth-while packets have been received, netif_rx()
-	 * has done a mark_bh(NET_BH) for us and will work on them
-	 * when we get to the bottom-half routine.
-	 */
 }
 
 
-- 
2.24.1

