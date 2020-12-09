Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D686A2D4368
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732507AbgLINhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:37:51 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9569 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732043AbgLINhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:37:37 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CrdNs6HL6zLyjK;
        Wed,  9 Dec 2020 21:36:13 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 21:36:48 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-afs@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: ethernet: ti: convert comma to semicolon
Date:   Wed, 9 Dec 2020 21:37:16 +0800
Message-ID: <20201209133716.1290-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/ti/davinci_mdio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index 702fdc393da0..cfff3d48807a 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -381,9 +381,9 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 	}
 
 	data->bus->name		= dev_name(dev);
-	data->bus->read		= davinci_mdio_read,
-	data->bus->write	= davinci_mdio_write,
-	data->bus->reset	= davinci_mdio_reset,
+	data->bus->read		= davinci_mdio_read;
+	data->bus->write	= davinci_mdio_write;
+	data->bus->reset	= davinci_mdio_reset;
 	data->bus->parent	= dev;
 	data->bus->priv		= data;
 
-- 
2.22.0

