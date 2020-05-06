Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3972F1C7035
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgEFMWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:22:01 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60598 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727804AbgEFMWA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 08:22:00 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 40910A34282DF0023709;
        Wed,  6 May 2020 20:21:57 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 20:21:49 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] net: cpmac: Fix use correct return type for ndo_start_xmit()
Date:   Wed, 6 May 2020 20:21:45 +0800
Message-ID: <1588767705-14952-1-git-send-email-wangyunjian@huawei.com>
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
 drivers/net/ethernet/ti/cpmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpmac.c
index a530afe..c207151 100644
--- a/drivers/net/ethernet/ti/cpmac.c
+++ b/drivers/net/ethernet/ti/cpmac.c
@@ -532,7 +532,7 @@ static int cpmac_poll(struct napi_struct *napi, int budget)
 
 }
 
-static int cpmac_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t cpmac_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	int queue;
 	unsigned int len;
-- 
1.8.3.1


