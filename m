Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F02221A60
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 04:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgGPC54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 22:57:56 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44766 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726996AbgGPC5z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 22:57:55 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2522BDB9CB34A1741E1B;
        Thu, 16 Jul 2020 10:57:52 +0800 (CST)
Received: from huawei.com (10.164.155.96) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Thu, 16 Jul 2020
 10:57:45 +0800
From:   zhouxudong199 <zhouxudong8@huawei.com>
To:     <wensong@linux-vs.org>, <horms@verge.net.au>
CC:     <netdev@vger.kernel.org>, <lvs-devel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <zhouxudong8@huawei.com>,
        <rose.chen@huawei.com>, <zhaowei23@huawei.com>
Subject: [PATCH v3] ipvs: clean code for ip_vs_sync.c
Date:   Thu, 16 Jul 2020 02:57:38 +0000
Message-ID: <1594868258-37160-1-git-send-email-zhouxudong8@huawei.com>
X-Mailer: git-send-email 2.6.1.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.164.155.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use appropriate spaces around operators.

Signed-off-by: zhouxudong199 <zhouxudong8@huawei.com>
---
v1 -> v2:
add missing spaces after Signed-off-by and ipvs: in the subject.
i=0 changed to i = 0.

v2 -> v3:
move version changes after Signed-off-by.
change commit messages

 net/netfilter/ipvs/ip_vs_sync.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 605e0f6..885bab4 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1077,10 +1077,10 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
 	struct ip_vs_protocol *pp;
 	struct ip_vs_conn_param param;
 	__u32 flags;
-	unsigned int af, state, pe_data_len=0, pe_name_len=0;
-	__u8 *pe_data=NULL, *pe_name=NULL;
-	__u32 opt_flags=0;
-	int retc=0;
+	unsigned int af, state, pe_data_len = 0, pe_name_len = 0;
+	__u8 *pe_data = NULL, *pe_name = NULL;
+	__u32 opt_flags = 0;
+	int retc = 0;
 
 	s = (union ip_vs_sync_conn *) p;
 
@@ -1089,7 +1089,7 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
 		af = AF_INET6;
 		p += sizeof(struct ip_vs_sync_v6);
 #else
-		IP_VS_DBG(3,"BACKUP, IPv6 msg received, and IPVS is not compiled for IPv6\n");
+		IP_VS_DBG(3, "BACKUP, IPv6 msg received, and IPVS is not compiled for IPv6\n");
 		retc = 10;
 		goto out;
 #endif
@@ -1129,7 +1129,7 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
 			break;
 
 		case IPVS_OPT_PE_NAME:
-			if (ip_vs_proc_str(p, plen,&pe_name_len, &pe_name,
+			if (ip_vs_proc_str(p, plen, &pe_name_len, &pe_name,
 					   IP_VS_PENAME_MAXLEN, &opt_flags,
 					   IPVS_OPT_F_PE_NAME))
 				return -70;
@@ -1155,7 +1155,7 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
 	if (!(flags & IP_VS_CONN_F_TEMPLATE)) {
 		pp = ip_vs_proto_get(s->v4.protocol);
 		if (!pp) {
-			IP_VS_DBG(3,"BACKUP, Unsupported protocol %u\n",
+			IP_VS_DBG(3, "BACKUP, Unsupported protocol %u\n",
 				s->v4.protocol);
 			retc = 30;
 			goto out;
@@ -1232,7 +1232,7 @@ static void ip_vs_process_message(struct netns_ipvs *ipvs, __u8 *buffer,
 		msg_end = buffer + sizeof(struct ip_vs_sync_mesg);
 		nr_conns = m2->nr_conns;
 
-		for (i=0; i<nr_conns; i++) {
+		for (i = 0; i < nr_conns; i++) {
 			union ip_vs_sync_conn *s;
 			unsigned int size;
 			int retc;
@@ -1444,7 +1444,7 @@ static int bind_mcastif_addr(struct socket *sock, struct net_device *dev)
 	sin.sin_addr.s_addr  = addr;
 	sin.sin_port         = 0;
 
-	return sock->ops->bind(sock, (struct sockaddr*)&sin, sizeof(sin));
+	return sock->ops->bind(sock, (struct sockaddr *)&sin, sizeof(sin));
 }
 
 static void get_mcast_sockaddr(union ipvs_sockaddr *sa, int *salen,
-- 
2.6.1.windows.1


