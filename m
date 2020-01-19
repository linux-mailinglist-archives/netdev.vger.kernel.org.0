Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49A01420BA
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 00:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgASXQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 18:16:32 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49720 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728851AbgASXQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 18:16:31 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id AE5D123EC1; Sun, 19 Jan 2020 18:16:30 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <7c1882e66d4caf9ecda6d9b534036dd340e8bde2.1579474569.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579474569.git.fthain@telegraphics.com.au>
References: <cover.1579474569.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net 01/19] net/sonic: Remove obsolete comment
Date:   Mon, 20 Jan 2020 09:56:09 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This comment is meaningless since mark_bh() was removed a long time ago.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index b339125b2f09..657b5327baf9 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -501,11 +501,6 @@ static void sonic_rx(struct net_device *dev)
 		lp->eol_rx = entry;
 		lp->cur_rx = entry = (entry + 1) & SONIC_RDS_MASK;
 	}
-	/*
-	 * If any worth-while packets have been received, netif_rx()
-	 * has done a mark_bh(NET_BH) for us and will work on them
-	 * when we get to the bottom-half routine.
-	 */
 }
 
 
-- 
2.24.1

