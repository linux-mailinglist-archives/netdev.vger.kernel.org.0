Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DCB25E69E
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 10:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgIEIxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 04:53:39 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34558 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726320AbgIEIxi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 04:53:38 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2D783C827977FB1DA8A5;
        Sat,  5 Sep 2020 16:53:36 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Sat, 5 Sep 2020
 16:53:35 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <willemdebruijn.kernel@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <willemb@google.com>,
        <john.ogness@linutronix.de>, <maowenan@huawei.com>,
        <jrosen@cisco.com>, <arnd@arndb.de>, <colin.king@canonical.com>,
        <edumazet@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2] net/packet: Remove unused macro BLOCK_PRIV
Date:   Sat, 5 Sep 2020 16:50:58 +0800
Message-ID: <20200905085058.68312-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BLOCK_PRIV is never used after it was introduced.
So better to remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
v1->v2:
 Corrected the wrong comment
 net/packet/af_packet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index da8254e680f9..c430672c6a67 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -177,7 +177,6 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 #define BLOCK_LEN(x)		((x)->hdr.bh1.blk_len)
 #define BLOCK_SNUM(x)		((x)->hdr.bh1.seq_num)
 #define BLOCK_O2PRIV(x)	((x)->offset_to_priv)
-#define BLOCK_PRIV(x)		((void *)((char *)(x) + BLOCK_O2PRIV(x)))
 
 struct packet_sock;
 static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
-- 
2.17.1

