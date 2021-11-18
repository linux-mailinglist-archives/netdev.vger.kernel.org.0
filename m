Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50923456029
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhKRQJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:09:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232972AbhKRQJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 11:09:33 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIFqUt2028051;
        Thu, 18 Nov 2021 16:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/IhvQj2Fa6FZkptWk6PK75G6NmwRbpEE47cArgqqfXs=;
 b=R7hd+LJ037rvSILj5l7TQAaZBtZiJb6iaY+1Xs9NaKbz+JSeBbMujcP32KVHr504vdef
 xnHyR3yiv0EaCuRaxEybKsHr+0GRefmhhnO4FJ2olOUXLsHQqdj7X2u7ryyhfuWzOrLB
 +kidxD6KAsSIsWFF8Dwu4gB2Bqq6sqacqdm9CIJs1YsqCVASAApqVv68BFZBCVpXXkkF
 EWSEQRgit1Jy5531pHvzpXlqmnouU/P9ZmfQNLYj4pJleYHYxt9VNKbV0GQ3R45jH94r
 QsfyzjjyOTMBdztAoPcSQ0fSH5vfPFrDHeM5p2tThcpEdFKDMjihznIBdSIXkW0d2p6u ZA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdsuy0eaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:06:32 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AIG3vX5028376;
        Thu, 18 Nov 2021 16:06:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ca50bqse9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:06:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AIFxPhn60490202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 15:59:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E09C3AE055;
        Thu, 18 Nov 2021 16:06:24 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3BF6AE045;
        Thu, 18 Nov 2021 16:06:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Nov 2021 16:06:24 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 3/6] net/af_iucv: fix kernel doc comments
Date:   Thu, 18 Nov 2021 17:06:04 +0100
Message-Id: <20211118160607.2245947-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211118160607.2245947-1-kgraul@linux.ibm.com>
References: <20211118160607.2245947-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4VQu6Iur0JzKmiMjKeRMteHmyWhkd74T
X-Proofpoint-ORIG-GUID: 4VQu6Iur0JzKmiMjKeRMteHmyWhkd74T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 phishscore=0
 bulkscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

Fix kernel doc comments where appropriate, or remove incorrect kernel
doc indicators.

Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/iucv/af_iucv.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 18316ee3c692..996ccf3665e3 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -142,7 +142,7 @@ static inline size_t iucv_msg_length(struct iucv_message *msg)
  * iucv_sock_in_state() - check for specific states
  * @sk:		sock structure
  * @state:	first iucv sk state
- * @state:	second iucv sk state
+ * @state2:	second iucv sk state
  *
  * Returns true if the socket in either in the first or second state.
  */
@@ -172,7 +172,7 @@ static inline int iucv_below_msglim(struct sock *sk)
 			(atomic_read(&iucv->pendings) <= 0));
 }
 
-/**
+/*
  * iucv_sock_wake_msglim() - Wake up thread waiting on msg limit
  */
 static void iucv_sock_wake_msglim(struct sock *sk)
@@ -187,7 +187,7 @@ static void iucv_sock_wake_msglim(struct sock *sk)
 	rcu_read_unlock();
 }
 
-/**
+/*
  * afiucv_hs_send() - send a message through HiperSockets transport
  */
 static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
@@ -1831,9 +1831,9 @@ static void afiucv_swap_src_dest(struct sk_buff *skb)
 	memset(skb->data, 0, ETH_HLEN);
 }
 
-/**
+/*
  * afiucv_hs_callback_syn - react on received SYN
- **/
+ */
 static int afiucv_hs_callback_syn(struct sock *sk, struct sk_buff *skb)
 {
 	struct af_iucv_trans_hdr *trans_hdr = iucv_trans_hdr(skb);
@@ -1896,9 +1896,9 @@ static int afiucv_hs_callback_syn(struct sock *sk, struct sk_buff *skb)
 	return NET_RX_SUCCESS;
 }
 
-/**
+/*
  * afiucv_hs_callback_synack() - react on received SYN-ACK
- **/
+ */
 static int afiucv_hs_callback_synack(struct sock *sk, struct sk_buff *skb)
 {
 	struct iucv_sock *iucv = iucv_sk(sk);
@@ -1917,9 +1917,9 @@ static int afiucv_hs_callback_synack(struct sock *sk, struct sk_buff *skb)
 	return NET_RX_SUCCESS;
 }
 
-/**
+/*
  * afiucv_hs_callback_synfin() - react on received SYN_FIN
- **/
+ */
 static int afiucv_hs_callback_synfin(struct sock *sk, struct sk_buff *skb)
 {
 	struct iucv_sock *iucv = iucv_sk(sk);
@@ -1937,9 +1937,9 @@ static int afiucv_hs_callback_synfin(struct sock *sk, struct sk_buff *skb)
 	return NET_RX_SUCCESS;
 }
 
-/**
+/*
  * afiucv_hs_callback_fin() - react on received FIN
- **/
+ */
 static int afiucv_hs_callback_fin(struct sock *sk, struct sk_buff *skb)
 {
 	struct iucv_sock *iucv = iucv_sk(sk);
@@ -1960,9 +1960,9 @@ static int afiucv_hs_callback_fin(struct sock *sk, struct sk_buff *skb)
 	return NET_RX_SUCCESS;
 }
 
-/**
+/*
  * afiucv_hs_callback_win() - react on received WIN
- **/
+ */
 static int afiucv_hs_callback_win(struct sock *sk, struct sk_buff *skb)
 {
 	struct iucv_sock *iucv = iucv_sk(sk);
@@ -1978,9 +1978,9 @@ static int afiucv_hs_callback_win(struct sock *sk, struct sk_buff *skb)
 	return NET_RX_SUCCESS;
 }
 
-/**
+/*
  * afiucv_hs_callback_rx() - react on received data
- **/
+ */
 static int afiucv_hs_callback_rx(struct sock *sk, struct sk_buff *skb)
 {
 	struct iucv_sock *iucv = iucv_sk(sk);
@@ -2022,11 +2022,11 @@ static int afiucv_hs_callback_rx(struct sock *sk, struct sk_buff *skb)
 	return NET_RX_SUCCESS;
 }
 
-/**
+/*
  * afiucv_hs_rcv() - base function for arriving data through HiperSockets
  *                   transport
  *                   called from netif RX softirq
- **/
+ */
 static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct packet_type *pt, struct net_device *orig_dev)
 {
@@ -2128,10 +2128,10 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 	return err;
 }
 
-/**
+/*
  * afiucv_hs_callback_txnotify() - handle send notifications from HiperSockets
  *                                 transport
- **/
+ */
 static void afiucv_hs_callback_txnotify(struct sock *sk, enum iucv_tx_notify n)
 {
 	struct iucv_sock *iucv = iucv_sk(sk);
-- 
2.25.1

