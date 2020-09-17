Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB52126D1E9
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 05:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgIQDty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 23:49:54 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49178 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbgIQDtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 23:49:53 -0400
X-Greylist: delayed 956 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 23:49:53 EDT
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3F4C8A0AF3D2D8A30130;
        Thu, 17 Sep 2020 11:33:56 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Thu, 17 Sep 2020
 11:33:47 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <yangyingliang@huawei.com>
Subject: [PATCH net-next] netlink: add spaces around '&' in netlink_recv/sendmsg()
Date:   Thu, 17 Sep 2020 11:32:23 +0800
Message-ID: <20200917033223.659862-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's hard to read the code without spaces around '&',
for better reading, add spaces around '&'.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/netlink/af_netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index d2d1448274f5..57a6318ec940 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1853,7 +1853,7 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct scm_cookie scm;
 	u32 netlink_skb_flags = 0;
 
-	if (msg->msg_flags&MSG_OOB)
+	if (msg->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
 	err = scm_send(sock, msg, &scm, true);
@@ -1916,7 +1916,7 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		refcount_inc(&skb->users);
 		netlink_broadcast(sk, skb, dst_portid, dst_group, GFP_KERNEL);
 	}
-	err = netlink_unicast(sk, skb, dst_portid, msg->msg_flags&MSG_DONTWAIT);
+	err = netlink_unicast(sk, skb, dst_portid, msg->msg_flags & MSG_DONTWAIT);
 
 out:
 	scm_destroy(&scm);
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

