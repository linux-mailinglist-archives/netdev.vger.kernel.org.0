Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792471C509C
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgEEImD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:42:03 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3792 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbgEEImC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 04:42:02 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 132FA4D18162402A46E4;
        Tue,  5 May 2020 16:41:59 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 16:41:53 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <jhofstee@victronenergy.com>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] can: c_can: Remove unused inline function
Date:   Tue, 5 May 2020 16:41:49 +0800
Message-ID: <20200505084149.23848-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 524369e2391f ("can: c_can: remove obsolete STRICT_FRAME_ORDERING Kconfig option")
left behind this, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
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
2.17.1


