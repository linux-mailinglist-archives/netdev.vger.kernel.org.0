Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6AA2D3E65
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgLIJSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:18:22 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8968 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbgLIJSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:18:21 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CrWdw4gtSzhpfY;
        Wed,  9 Dec 2020 17:17:08 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 17:17:25 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: marvell: prestera: simplify the return expression of prestera_port_close()
Date:   Wed, 9 Dec 2020 17:17:51 +0800
Message-ID: <20201209091751.20097-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 0f20e0788cce..13bd58dafc6c 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -93,15 +93,10 @@ static int prestera_port_open(struct net_device *dev)
 static int prestera_port_close(struct net_device *dev)
 {
 	struct prestera_port *port = netdev_priv(dev);
-	int err;
 
 	netif_stop_queue(dev);
 
-	err = prestera_hw_port_state_set(port, false);
-	if (err)
-		return err;
-
-	return 0;
+	return prestera_hw_port_state_set(port, false);
 }
 
 static netdev_tx_t prestera_port_xmit(struct sk_buff *skb,
-- 
2.22.0

