Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB5E1C6EE0
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgEFLFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:05:10 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50156 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727893AbgEFLFJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 07:05:09 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 877F32AC311049E5CA69;
        Wed,  6 May 2020 19:05:07 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 19:04:59 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] net: socionext: Fix use correct return type for ndo_start_xmit()
Date:   Wed, 6 May 2020 19:04:59 +0800
Message-ID: <1588763099-15812-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.251.152]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The method ndo_start_xmit() returns a value of type netdev_tx_t. Fix
the ndo function to use the correct type.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/ethernet/socionext/sni_ave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 67ddf78..f263844 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1394,7 +1394,7 @@ static int ave_stop(struct net_device *ndev)
 	return 0;
 }
 
-static int ave_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t ave_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct ave_private *priv = netdev_priv(ndev);
 	u32 proc_idx, done_idx, ndesc, cmdsts;
-- 
1.8.3.1


