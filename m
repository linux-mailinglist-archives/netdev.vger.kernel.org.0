Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAC43886AE
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344324AbhESFiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:38:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3020 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243122AbhESFgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:36:03 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FlM0r2f3dzNyr4;
        Wed, 19 May 2021 13:31:08 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:37 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 13/20] net: seeq: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:46 +0800
Message-ID: <1621402253-27200-14-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/seeq/ether3.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/seeq/ether3.c b/drivers/net/ethernet/seeq/ether3.c
index 65c9883..16a4cba 100644
--- a/drivers/net/ethernet/seeq/ether3.c
+++ b/drivers/net/ethernet/seeq/ether3.c
@@ -617,7 +617,7 @@ if (next_ptr < RX_START || next_ptr >= RX_END) {
  break;
 }
 		/*
- 		 * ignore our own packets...
+		 * ignore our own packets...
 	 	 */
 		if (!(*(unsigned long *)&dev->dev_addr[0] ^ *(unsigned long *)&addrs[2+6]) &&
 		    !(*(unsigned short *)&dev->dev_addr[4] ^ *(unsigned short *)&addrs[2+10])) {
@@ -672,7 +672,7 @@ if (next_ptr < RX_START || next_ptr >= RX_END) {
 	 */
 	if (!(ether3_inw(REG_STATUS) & STAT_RXON)) {
 		dev->stats.rx_dropped++;
-    		ether3_outw(next_ptr, REG_RECVPTR);
+		ether3_outw(next_ptr, REG_RECVPTR);
 		ether3_outw(priv(dev)->regs.command | CMD_RXON, REG_COMMAND);
 	}
 
@@ -690,11 +690,11 @@ static void ether3_tx(struct net_device *dev)
 	do {
 	    	unsigned long status;
 
-    		/*
+		/*
 	    	 * Read the packet header
-    		 */
+		 */
 	    	ether3_setbuffer(dev, buffer_read, tx_tail * 0x600);
-    		status = ether3_readlong(dev);
+		status = ether3_readlong(dev);
 
 		/*
 		 * Check to see if this packet has been transmitted
-- 
2.8.1

