Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018073529E7
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 12:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbhDBKtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 06:49:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15534 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhDBKtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 06:49:03 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FBcDC4fFYzNs7v;
        Fri,  2 Apr 2021 18:46:19 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.498.0; Fri, 2 Apr 2021
 18:48:59 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/Bluetooth - delete unneeded variable initialization
Date:   Fri, 2 Apr 2021 18:46:29 +0800
Message-ID: <1617360389-42664-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete unneeded variable initialization.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 net/bluetooth/6lowpan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index cff4944..ee4b0ec 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -692,7 +692,7 @@ static struct l2cap_chan *add_peer_chan(struct l2cap_chan *chan,
 static int setup_netdev(struct l2cap_chan *chan, struct lowpan_btle_dev **dev)
 {
 	struct net_device *netdev;
-	int err = 0;
+	int err;
 
 	netdev = alloc_netdev(LOWPAN_PRIV_SIZE(sizeof(struct lowpan_btle_dev)),
 			      IFACE_NAME_TEMPLATE, NET_NAME_UNKNOWN,
-- 
2.8.1

