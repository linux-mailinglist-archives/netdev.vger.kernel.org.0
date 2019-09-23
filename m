Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7A7BADB3
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 08:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392813AbfIWGQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 02:16:49 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38600 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387519AbfIWGQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 02:16:49 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 89FF75DFB0AB82F2F953;
        Mon, 23 Sep 2019 14:16:47 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Mon, 23 Sep 2019
 14:16:36 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <claudiu.manoil@nxp.com>, <davem@davemloft.net>,
        <jakub.kicinski@netronome.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net] gianfar: Make reset_gfar static
Date:   Mon, 23 Sep 2019 14:16:03 +0800
Message-ID: <20190923061603.37064-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:

drivers/net/ethernet/freescale/gianfar.c:2070:6:
 warning: symbol 'reset_gfar' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/freescale/gianfar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 24bf7f6..51ad864 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2067,7 +2067,7 @@ static int gfar_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-void reset_gfar(struct net_device *ndev)
+static void reset_gfar(struct net_device *ndev)
 {
 	struct gfar_private *priv = netdev_priv(ndev);
 
-- 
2.7.4


