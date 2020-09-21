Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B2D27260E
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgIUNqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727435AbgIUNqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9EEC0613DA
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:09 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8t-0003ED-JG; Mon, 21 Sep 2020 15:46:07 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, YueHaibing <yuehaibing@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 14/38] can: c_can: Remove unused inline function
Date:   Mon, 21 Sep 2020 15:45:33 +0200
Message-Id: <20200921134557.2251383-15-mkl@pengutronix.de>
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

From: YueHaibing <yuehaibing@huawei.com>

commit 524369e2391f ("can: c_can: remove obsolete STRICT_FRAME_ORDERING Kconfig option")
left behind this, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20200505084149.23848-1-yuehaibing@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 8e9f5620c9a2..1ccdbe89585b 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -356,15 +356,6 @@ static void c_can_setup_tx_object(struct net_device *dev, int iface,
 	}
 }
 
-static inline void c_can_activate_all_lower_rx_msg_obj(struct net_device *dev,
-						       int iface)
-{
-	int i;
-
-	for (i = C_CAN_MSG_OBJ_RX_FIRST; i <= C_CAN_MSG_RX_LOW_LAST; i++)
-		c_can_object_get(dev, iface, i, IF_COMM_CLR_NEWDAT);
-}
-
 static int c_can_handle_lost_msg_obj(struct net_device *dev,
 				     int iface, int objno, u32 ctrl)
 {
-- 
2.28.0

