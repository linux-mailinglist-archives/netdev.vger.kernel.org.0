Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B7034B3CD
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 03:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhC0C0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 22:26:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14623 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhC0C0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 22:26:11 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6jMV5ZzZz1BFd5;
        Sat, 27 Mar 2021 10:24:06 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Sat, 27 Mar 2021
 10:26:04 +0800
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
Subject: [PATCH -next 2/3] net: sctp: Fix some typos
Date:   Sat, 27 Mar 2021 10:27:23 +0800
Message-ID: <20210327022724.241376-3-luwei32@huawei.com>
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

Modify "unkown" to "unknown" in net/sctp/sm_make_chunk.c and
Modify "orginal" to "original" in net/sctp/socket.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/sctp/sm_make_chunk.c | 2 +-
 net/sctp/socket.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index f77484df097b..54e6a708d06e 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3217,7 +3217,7 @@ bool sctp_verify_asconf(const struct sctp_association *asoc,
 				return false;
 			break;
 		default:
-			/* This is unkown to us, reject! */
+			/* This is unknown to us, reject! */
 			return false;
 		}
 	}
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a710917c5ac7..76a388b5021c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9327,7 +9327,7 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 	if (newsk->sk_flags & SK_FLAGS_TIMESTAMP)
 		net_enable_timestamp();
 
-	/* Set newsk security attributes from orginal sk and connection
+	/* Set newsk security attributes from original sk and connection
 	 * security attribute from ep.
 	 */
 	security_sctp_sk_clone(ep, sk, newsk);
-- 
2.17.1

