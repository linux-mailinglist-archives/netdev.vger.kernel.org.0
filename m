Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B27394FD2
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 08:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhE3G3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 02:29:35 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2106 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhE3G3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 02:29:20 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ft7df6ddwzWqS7;
        Sun, 30 May 2021 14:23:02 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:41 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:41 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 10/10] net: sealevel: fix the alignment issue
Date:   Sun, 30 May 2021 14:24:34 +0800
Message-ID: <1622355874-18933-11-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622355874-18933-1-git-send-email-huangguangbin2@huawei.com>
References: <1622355874-18933-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Alignment should match open parenthesis.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/sealevel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/sealevel.c b/drivers/net/wan/sealevel.c
index 60028cfaaab5..4403e219ca03 100644
--- a/drivers/net/wan/sealevel.c
+++ b/drivers/net/wan/sealevel.c
@@ -135,7 +135,7 @@ static int sealevel_ioctl(struct net_device *d, struct ifreq *ifr, int cmd)
 /*	Passed network frames, fire them downwind. */
 
 static netdev_tx_t sealevel_queue_xmit(struct sk_buff *skb,
-					     struct net_device *d)
+				       struct net_device *d)
 {
 	return z8530_queue_xmit(dev_to_chan(d)->chan, skb);
 }
-- 
2.8.1

