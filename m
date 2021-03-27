Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E44634B3CB
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 03:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhC0C0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 22:26:41 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14624 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhC0C0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 22:26:10 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6jMV56rtz1BFd4;
        Sat, 27 Mar 2021 10:24:06 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Sat, 27 Mar 2021
 10:26:05 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-sctp@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgarzare@redhat.com>, <jhansen@vmware.com>,
        <colin.king@canonical.com>, <nslusarek@gmx.net>,
        <andraprs@amazon.com>, <alex.popov@linux.com>,
        <santosh.shilimkar@oracle.com>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>
Subject: [PATCH -next 3/3] net: vsock: Fix a typo
Date:   Sat, 27 Mar 2021 10:27:24 +0800
Message-ID: <20210327022724.241376-4-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210327022724.241376-1-luwei32@huawei.com>
References: <20210327022724.241376-1-luwei32@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify "occured" to "occurred" in net/vmw_vsock/af_vsock.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 5546710d8ac1..01eebfecf1d7 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1854,7 +1854,7 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
 		/* Recvmsg is supposed to return 0 if a peer performs an
 		 * orderly shutdown. Differentiate between that case and when a
-		 * peer has not connected or a local shutdown occured with the
+		 * peer has not connected or a local shutdown occurred with the
 		 * SOCK_DONE flag.
 		 */
 		if (sock_flag(sk, SOCK_DONE))
-- 
2.17.1

