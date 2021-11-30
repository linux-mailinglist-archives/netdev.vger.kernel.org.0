Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188F2462AD8
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 04:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhK3DHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 22:07:42 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:28190 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhK3DHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 22:07:41 -0500
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J36TD2WDhz8vK4;
        Tue, 30 Nov 2021 11:02:24 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 11:04:21 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 30 Nov
 2021 11:04:20 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <jk@codeconstruct.com.au>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH -next] mctp: test: use kfree_skb() instead of kfree()
Date:   Tue, 30 Nov 2021 11:11:00 +0800
Message-ID: <20211130031100.768032-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kfree_skb() instead of kfree() to free sk_buff.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/mctp/test/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mctp/test/utils.c b/net/mctp/test/utils.c
index cc6b8803aa9d..7b7918702592 100644
--- a/net/mctp/test/utils.c
+++ b/net/mctp/test/utils.c
@@ -12,7 +12,7 @@
 static netdev_tx_t mctp_test_dev_tx(struct sk_buff *skb,
 				    struct net_device *ndev)
 {
-	kfree(skb);
+	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
 
-- 
2.25.1

