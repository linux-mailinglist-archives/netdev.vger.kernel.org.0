Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 000BF19633F
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 04:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgC1DFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 23:05:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49186 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbgC1DFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 23:05:03 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E2458E00FEB29AF03126;
        Sat, 28 Mar 2020 11:04:55 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Sat, 28 Mar 2020
 11:04:47 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <madalin.bucur@nxp.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] dpaa_eth: Make dpaa_a050385_wa static
Date:   Sat, 28 Mar 2020 11:04:15 +0800
Message-ID: <20200328030415.19044-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:

drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:2065:5:
 warning: symbol 'dpaa_a050385_wa' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 46039d80bb43..2cd1f8efdfa3 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2062,7 +2062,7 @@ static inline int dpaa_xmit(struct dpaa_priv *priv,
 }
 
 #ifdef CONFIG_DPAA_ERRATUM_A050385
-int dpaa_a050385_wa(struct net_device *net_dev, struct sk_buff **s)
+static int dpaa_a050385_wa(struct net_device *net_dev, struct sk_buff **s)
 {
 	struct dpaa_priv *priv = netdev_priv(net_dev);
 	struct sk_buff *new_skb, *skb = *s;
-- 
2.17.1


