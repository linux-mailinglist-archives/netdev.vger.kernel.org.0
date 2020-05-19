Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E831DA0B0
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgESTK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:10:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726059AbgESTKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:10:24 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04JJ2fO8179305;
        Tue, 19 May 2020 15:10:22 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312btvfvqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 15:10:22 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04JJ6VMg009708;
        Tue, 19 May 2020 19:10:20 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 313xehj6r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 19:10:19 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04JJ94lt9175304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 19:09:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 246FAA4057;
        Tue, 19 May 2020 19:10:17 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7313A4069;
        Tue, 19 May 2020 19:10:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 May 2020 19:10:16 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 5/5] net/af_iucv: clean up function prototypes
Date:   Tue, 19 May 2020 21:10:12 +0200
Message-Id: <20200519191012.65438-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200519191012.65438-1-jwi@linux.ibm.com>
References: <20200519191012.65438-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-19_08:2020-05-19,2020-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 mlxlogscore=973
 impostorscore=0 spamscore=0 clxscore=1015 cotscore=-2147483648
 lowpriorityscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove a bunch of forward declarations (trivially shifting code around
where needed), and make a few functions static.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 include/net/iucv/af_iucv.h |   8 ---
 net/iucv/af_iucv.c         | 108 ++++++++++++++++++-------------------
 2 files changed, 51 insertions(+), 65 deletions(-)

diff --git a/include/net/iucv/af_iucv.h b/include/net/iucv/af_iucv.h
index 14a490246be9..9259ce2b22f3 100644
--- a/include/net/iucv/af_iucv.h
+++ b/include/net/iucv/af_iucv.h
@@ -158,12 +158,4 @@ struct iucv_sock_list {
 	atomic_t	  autobind_name;
 };
 
-__poll_t iucv_sock_poll(struct file *file, struct socket *sock,
-			    poll_table *wait);
-void iucv_sock_link(struct iucv_sock_list *l, struct sock *s);
-void iucv_sock_unlink(struct iucv_sock_list *l, struct sock *s);
-void iucv_accept_enqueue(struct sock *parent, struct sock *sk);
-void iucv_accept_unlink(struct sock *sk);
-struct sock *iucv_accept_dequeue(struct sock *parent, struct socket *newsock);
-
 #endif /* __IUCV_H */
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 799dcf5483de..ee0add15497d 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -37,8 +37,6 @@
 
 static char iucv_userid[80];
 
-static const struct proto_ops iucv_sock_ops;
-
 static struct proto iucv_proto = {
 	.name		= "AF_IUCV",
 	.owner		= THIS_MODULE,
@@ -86,13 +84,11 @@ do {									\
 	__ret;								\
 })
 
+static struct sock *iucv_accept_dequeue(struct sock *parent,
+					struct socket *newsock);
 static void iucv_sock_kill(struct sock *sk);
 static void iucv_sock_close(struct sock *sk);
 
-static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
-	struct packet_type *pt, struct net_device *orig_dev);
-static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
-		   struct sk_buff *skb, u8 flags);
 static void afiucv_hs_callback_txnotify(struct sk_buff *, enum iucv_tx_notify);
 
 /* Call Back functions */
@@ -331,6 +327,20 @@ static void iucv_sock_cleanup_listen(struct sock *parent)
 	parent->sk_state = IUCV_CLOSED;
 }
 
+static void iucv_sock_link(struct iucv_sock_list *l, struct sock *sk)
+{
+	write_lock_bh(&l->lock);
+	sk_add_node(sk, &l->head);
+	write_unlock_bh(&l->lock);
+}
+
+static void iucv_sock_unlink(struct iucv_sock_list *l, struct sock *sk)
+{
+	write_lock_bh(&l->lock);
+	sk_del_node_init(sk);
+	write_unlock_bh(&l->lock);
+}
+
 /* Kill socket (only if zapped and orphaned) */
 static void iucv_sock_kill(struct sock *sk)
 {
@@ -503,53 +513,7 @@ static struct sock *iucv_sock_alloc(struct socket *sock, int proto, gfp_t prio,
 	return sk;
 }
 
-/* Create an IUCV socket */
-static int iucv_sock_create(struct net *net, struct socket *sock, int protocol,
-			    int kern)
-{
-	struct sock *sk;
-
-	if (protocol && protocol != PF_IUCV)
-		return -EPROTONOSUPPORT;
-
-	sock->state = SS_UNCONNECTED;
-
-	switch (sock->type) {
-	case SOCK_STREAM:
-		sock->ops = &iucv_sock_ops;
-		break;
-	case SOCK_SEQPACKET:
-		/* currently, proto ops can handle both sk types */
-		sock->ops = &iucv_sock_ops;
-		break;
-	default:
-		return -ESOCKTNOSUPPORT;
-	}
-
-	sk = iucv_sock_alloc(sock, protocol, GFP_KERNEL, kern);
-	if (!sk)
-		return -ENOMEM;
-
-	iucv_sock_init(sk, NULL);
-
-	return 0;
-}
-
-void iucv_sock_link(struct iucv_sock_list *l, struct sock *sk)
-{
-	write_lock_bh(&l->lock);
-	sk_add_node(sk, &l->head);
-	write_unlock_bh(&l->lock);
-}
-
-void iucv_sock_unlink(struct iucv_sock_list *l, struct sock *sk)
-{
-	write_lock_bh(&l->lock);
-	sk_del_node_init(sk);
-	write_unlock_bh(&l->lock);
-}
-
-void iucv_accept_enqueue(struct sock *parent, struct sock *sk)
+static void iucv_accept_enqueue(struct sock *parent, struct sock *sk)
 {
 	unsigned long flags;
 	struct iucv_sock *par = iucv_sk(parent);
@@ -562,7 +526,7 @@ void iucv_accept_enqueue(struct sock *parent, struct sock *sk)
 	sk_acceptq_added(parent);
 }
 
-void iucv_accept_unlink(struct sock *sk)
+static void iucv_accept_unlink(struct sock *sk)
 {
 	unsigned long flags;
 	struct iucv_sock *par = iucv_sk(iucv_sk(sk)->parent);
@@ -575,7 +539,8 @@ void iucv_accept_unlink(struct sock *sk)
 	sock_put(sk);
 }
 
-struct sock *iucv_accept_dequeue(struct sock *parent, struct socket *newsock)
+static struct sock *iucv_accept_dequeue(struct sock *parent,
+					struct socket *newsock)
 {
 	struct iucv_sock *isk, *n;
 	struct sock *sk;
@@ -1406,8 +1371,8 @@ static inline __poll_t iucv_accept_poll(struct sock *parent)
 	return 0;
 }
 
-__poll_t iucv_sock_poll(struct file *file, struct socket *sock,
-			    poll_table *wait)
+static __poll_t iucv_sock_poll(struct file *file, struct socket *sock,
+			       poll_table *wait)
 {
 	struct sock *sk = sock->sk;
 	__poll_t mask = 0;
@@ -2291,6 +2256,35 @@ static const struct proto_ops iucv_sock_ops = {
 	.getsockopt	= iucv_sock_getsockopt,
 };
 
+static int iucv_sock_create(struct net *net, struct socket *sock, int protocol,
+			    int kern)
+{
+	struct sock *sk;
+
+	if (protocol && protocol != PF_IUCV)
+		return -EPROTONOSUPPORT;
+
+	sock->state = SS_UNCONNECTED;
+
+	switch (sock->type) {
+	case SOCK_STREAM:
+	case SOCK_SEQPACKET:
+		/* currently, proto ops can handle both sk types */
+		sock->ops = &iucv_sock_ops;
+		break;
+	default:
+		return -ESOCKTNOSUPPORT;
+	}
+
+	sk = iucv_sock_alloc(sock, protocol, GFP_KERNEL, kern);
+	if (!sk)
+		return -ENOMEM;
+
+	iucv_sock_init(sk, NULL);
+
+	return 0;
+}
+
 static const struct net_proto_family iucv_sock_family_ops = {
 	.family	= AF_IUCV,
 	.owner	= THIS_MODULE,
-- 
2.17.1

