Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343E92DBBD3
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 08:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgLPHGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 02:06:40 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9893 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgLPHGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 02:06:40 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CwmNZ42FKz79Zl;
        Wed, 16 Dec 2020 15:05:18 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Wed, 16 Dec 2020 15:05:48 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: rds: Change PF_INET to AF_INET
Date:   Wed, 16 Dec 2020 15:06:20 +0800
Message-ID: <20201216070620.16063-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By bsd codestyle, change PF_INET to AF_INET.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/rds/rdma_transport.c | 4 ++--
 net/rds/tcp_listen.c     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 5f741e51b4ba..04102dbc04d2 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -249,7 +249,7 @@ static int rds_rdma_listen_init(void)
 #endif
 	struct sockaddr_in sin;
 
-	sin.sin_family = PF_INET;
+	sin.sin_family = AF_INET;
 	sin.sin_addr.s_addr = htonl(INADDR_ANY);
 	sin.sin_port = htons(RDS_PORT);
 	ret = rds_rdma_listen_init_common(rds_rdma_cm_event_handler,
@@ -259,7 +259,7 @@ static int rds_rdma_listen_init(void)
 		return ret;
 
 #if IS_ENABLED(CONFIG_IPV6)
-	sin6.sin6_family = PF_INET6;
+	sin6.sin6_family = AF_INET6;
 	sin6.sin6_addr = in6addr_any;
 	sin6.sin6_port = htons(RDS_CM_PORT);
 	sin6.sin6_scope_id = 0;
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 101cf14215a0..8dc71aee4691 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -281,7 +281,7 @@ struct socket *rds_tcp_listen_init(struct net *net, bool isv6)
 
 	if (isv6) {
 		sin6 = (struct sockaddr_in6 *)&ss;
-		sin6->sin6_family = PF_INET6;
+		sin6->sin6_family = AF_INET6;
 		sin6->sin6_addr = in6addr_any;
 		sin6->sin6_port = (__force u16)htons(RDS_TCP_PORT);
 		sin6->sin6_scope_id = 0;
@@ -289,7 +289,7 @@ struct socket *rds_tcp_listen_init(struct net *net, bool isv6)
 		addr_len = sizeof(*sin6);
 	} else {
 		sin = (struct sockaddr_in *)&ss;
-		sin->sin_family = PF_INET;
+		sin->sin_family = AF_INET;
 		sin->sin_addr.s_addr = INADDR_ANY;
 		sin->sin_port = (__force u16)htons(RDS_TCP_PORT);
 		addr_len = sizeof(*sin);
-- 
2.22.0

