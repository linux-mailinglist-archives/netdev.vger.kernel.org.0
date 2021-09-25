Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34A8418215
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 14:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245474AbhIYMwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 08:52:38 -0400
Received: from mx22.baidu.com ([220.181.50.185]:43518 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245445AbhIYMwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 08:52:37 -0400
Received: from BC-Mail-Ex03.internal.baidu.com (unknown [172.31.51.43])
        by Forcepoint Email with ESMTPS id 93E75E8EDA540F55C2AC;
        Sat, 25 Sep 2021 20:51:01 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex03.internal.baidu.com (172.31.51.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Sat, 25 Sep 2021 20:51:01 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 25 Sep 2021 20:51:00 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "Steve Glendinning" <steve.glendinning@shawell.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] net: sis: Fix a function name in comments
Date:   Sat, 25 Sep 2021 20:50:40 +0800
Message-ID: <20210925125042.1629-3-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210925125042.1629-1-caihuoqing@baidu.com>
References: <20210925125042.1629-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex01.internal.baidu.com (10.127.64.11) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dma_alloc_coherent() instead of pci_alloc_consistent(),
because only dma_alloc_coherent() is called here.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/sis/sis190.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sis/sis190.c b/drivers/net/ethernet/sis/sis190.c
index 3d1a18a01ce5..7e107407476a 100644
--- a/drivers/net/ethernet/sis/sis190.c
+++ b/drivers/net/ethernet/sis/sis190.c
@@ -1070,7 +1070,7 @@ static int sis190_open(struct net_device *dev)
 
 	/*
 	 * Rx and Tx descriptors need 256 bytes alignment.
-	 * pci_alloc_consistent() guarantees a stronger alignment.
+	 * dma_alloc_consistent() guarantees a stronger alignment.
 	 */
 	tp->TxDescRing = dma_alloc_coherent(&pdev->dev, TX_RING_BYTES,
 					    &tp->tx_dma, GFP_KERNEL);
-- 
2.25.1

