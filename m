Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635B325FB47
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 15:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbgIGNZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 09:25:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11225 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729582AbgIGNXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 09:23:43 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 95A4421A398E2E88E7D6;
        Mon,  7 Sep 2020 21:23:36 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Mon, 7 Sep 2020
 21:23:27 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <yangyingliang@huawei.com>
Subject: [PATCH net-next] netlink: add spaces around '&' in netlink_recvmsg()
Date:   Mon, 7 Sep 2020 21:21:44 +0800
Message-ID: <20200907132144.3144704-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spaces preferred around '&'.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/netlink/af_netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index d2d1448274f5..5a86bf4f80b1 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1929,12 +1929,12 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	struct scm_cookie scm;
 	struct sock *sk = sock->sk;
 	struct netlink_sock *nlk = nlk_sk(sk);
-	int noblock = flags&MSG_DONTWAIT;
+	int noblock = flags & MSG_DONTWAIT;
 	size_t copied;
 	struct sk_buff *skb, *data_skb;
 	int err, ret;
 
-	if (flags&MSG_OOB)
+	if (flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
 	copied = 0;
-- 
2.25.1

