Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0FFF8941
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 08:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKLHB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 02:01:29 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6636 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbfKLHB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 02:01:28 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2B98ECBF9F1093A356DD;
        Tue, 12 Nov 2019 15:01:26 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Tue, 12 Nov 2019
 15:01:16 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <vishal@chelsio.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH net-next v2] cxgb4: make function 'cxgb4_mqprio_free_hw_resources' static
Date:   Tue, 12 Nov 2019 15:08:40 +0800
Message-ID: <1573542520-126327-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warnings:

drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c:242:6: warning: symbol 'cxgb4_mqprio_free_hw_resources' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 2d0cb84dd973 ("cxgb4: add ETHOFLD hardware queue support")
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
v1->v2: add Fixes tag
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index 143cb1f..3880784 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -239,7 +239,7 @@ static int cxgb4_mqprio_alloc_hw_resources(struct net_device *dev)
 	return ret;
 }

-void cxgb4_mqprio_free_hw_resources(struct net_device *dev)
+static void cxgb4_mqprio_free_hw_resources(struct net_device *dev)
 {
 	struct port_info *pi = netdev2pinfo(dev);
 	struct adapter *adap = netdev2adap(dev);
--
2.7.4

