Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCFD34B3CC
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 03:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhC0C0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 22:26:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14566 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhC0C0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 22:26:14 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F6jLt0GpVzPqhm;
        Sat, 27 Mar 2021 10:23:34 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Sat, 27 Mar 2021
 10:26:03 +0800
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
Subject: [PATCH -next 1/3] net: rds: Fix a typo
Date:   Sat, 27 Mar 2021 10:27:22 +0800
Message-ID: <20210327022724.241376-2-luwei32@huawei.com>
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

Modify "beween" to "between" in net/rds/send.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/rds/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 985d0b7713ac..53444397de66 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1225,7 +1225,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		}
 		/* If the socket is already bound to a link local address,
 		 * it can only send to peers on the same link.  But allow
-		 * communicating beween link local and non-link local address.
+		 * communicating between link local and non-link local address.
 		 */
 		if (scope_id != rs->rs_bound_scope_id) {
 			if (!scope_id) {
-- 
2.17.1

