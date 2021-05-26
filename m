Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A63391678
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 13:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhEZLtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 07:49:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3979 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbhEZLt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 07:49:29 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FqpyB6y98zQrwC;
        Wed, 26 May 2021 19:44:18 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 19:47:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 26 May 2021 19:47:56 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 03/10] net: wan: fix an code style issue about "foo* bar"
Date:   Wed, 26 May 2021 19:44:48 +0800
Message-ID: <1622029495-30357-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622029495-30357-1-git-send-email-huangguangbin2@huawei.com>
References: <1622029495-30357-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Fix the checkpatch error as "foo* bar" and should be "foo *bar",
and "(foo*)" should be "(foo *)".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_fr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 96e4a89fa923..4a6172cca682 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -159,7 +159,7 @@ static inline void dlci_to_q922(u8 *hdr, u16 dlci)
 	hdr[1] = ((dlci << 4) & 0xF0) | 0x01;
 }
 
-static inline struct frad_state* state(hdlc_device *hdlc)
+static inline struct frad_state *state(hdlc_device *hdlc)
 {
 	return(struct frad_state *)(hdlc->state);
 }
@@ -1090,7 +1090,7 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 		dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 		eth_hw_addr_random(dev);
 	} else {
-		*(__be16*)dev->dev_addr = htons(dlci);
+		*(__be16 *)dev->dev_addr = htons(dlci);
 		dlci_to_q922(dev->broadcast, dlci);
 	}
 	dev->netdev_ops = &pvc_ops;
-- 
2.8.1

