Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EBC418217
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 14:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245155AbhIYMyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 08:54:02 -0400
Received: from mx24.baidu.com ([111.206.215.185]:44488 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244836AbhIYMyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 08:54:01 -0400
Received: from BJHW-MAIL-EX04.internal.baidu.com (unknown [10.127.64.14])
        by Forcepoint Email with ESMTPS id 0DF67B3AD95A37BB727A;
        Sat, 25 Sep 2021 20:52:25 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-MAIL-EX04.internal.baidu.com (10.127.64.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 25 Sep 2021 20:52:24 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 25 Sep 2021 20:52:24 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] FDDI: defxx: Fix function names in coments
Date:   Sat, 25 Sep 2021 20:52:07 +0800
Message-ID: <20210925125209.1700-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex01.internal.baidu.com (10.127.64.11) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dma_xxx_xxx() instead of pci_xxx_xxx(),
because the pci function wrappers are not called here.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/fddi/defxx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/fddi/defxx.c b/drivers/net/fddi/defxx.c
index 6d1e3f49a3d3..5810e8473789 100644
--- a/drivers/net/fddi/defxx.c
+++ b/drivers/net/fddi/defxx.c
@@ -1028,7 +1028,7 @@ static void dfx_bus_config_check(DFX_board_t *bp)
  *						or read adapter MAC address
  *
  * Assumptions:
- *   Memory allocated from pci_alloc_consistent() call is physically
+ *   Memory allocated from dma_alloc_coherent() call is physically
  *   contiguous, locked memory.
  *
  * Side Effects:
@@ -3249,7 +3249,7 @@ static void dfx_rcv_queue_process(
  *   is contained in a single physically contiguous buffer
  *   in which the virtual address of the start of packet
  *   (skb->data) can be converted to a physical address
- *   by using pci_map_single().
+ *   by using dma_map_single().
  *
  *   Since the adapter architecture requires a three byte
  *   packet request header to prepend the start of packet,
@@ -3402,7 +3402,7 @@ static netdev_tx_t dfx_xmt_queue_pkt(struct sk_buff *skb,
 	 *			skb->data.
 	 *		 6. The physical address of the start of packet
 	 *			can be determined from the virtual address
-	 *			by using pci_map_single() and is only 32-bits
+	 *			by using dma_map_single() and is only 32-bits
 	 *			wide.
 	 */
 
-- 
2.25.1

