Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A70E25D946
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbgIDNIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:08:50 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10814 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729297AbgIDNIs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 09:08:48 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D072199F3E3C63284F16;
        Fri,  4 Sep 2020 21:08:44 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 4 Sep 2020
 21:08:40 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <willemb@google.com>,
        <john.ogness@linutronix.de>, <maowenan@huawei.com>,
        <jrosen@cisco.com>, <arnd@arndb.de>, <colin.king@canonical.com>,
        <edumazet@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net/packet: Remove unused macro BLOCK_PRIV
Date:   Fri, 4 Sep 2020 21:06:08 +0800
Message-ID: <20200904130608.19869-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPDU_TYPE_TCN is never used after it was introduced.
So better to remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
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

