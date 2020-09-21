Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B76C272608
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgIUNqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgIUNqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6F2C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:04 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8o-0003ED-OV; Mon, 21 Sep 2020 15:46:02 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 03/38] can: include: fix spelling mistakes
Date:   Mon, 21 Sep 2020 15:45:22 +0200
Message-Id: <20200921134557.2251383-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134557.2251383-1-mkl@pengutronix.de>
References: <20200921134557.2251383-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes spelling erros found by "codespell" in the
include/linux/can subtree.

Link: https://lore.kernel.org/r/20200915223527.1417033-4-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/linux/can/core.h | 2 +-
 include/linux/can/dev.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/can/core.h b/include/linux/can/core.h
index e20a0cd09ba5..7da9f1f82e8e 100644
--- a/include/linux/can/core.h
+++ b/include/linux/can/core.h
@@ -2,7 +2,7 @@
 /*
  * linux/can/core.h
  *
- * Protoypes and definitions for CAN protocol modules using the PF_CAN core
+ * Prototypes and definitions for CAN protocol modules using the PF_CAN core
  *
  * Authors: Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
  *          Urs Thuermann   <urs.thuermann@volkswagen.de>
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 5e3d45525bd3..516892566ac9 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -108,7 +108,7 @@ static inline bool can_skb_headroom_valid(struct net_device *dev,
 
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
-		/* preform proper loopback on capable devices */
+		/* perform proper loopback on capable devices */
 		if (dev->flags & IFF_ECHO)
 			skb->pkt_type = PACKET_LOOPBACK;
 		else
-- 
2.28.0

