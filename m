Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFD23A3D79
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhFKHrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:47:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38424 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231197AbhFKHrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:47:15 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B7XRNk039244;
        Fri, 11 Jun 2021 03:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FfPPFT56obPV+TpfSbFIZElS+5wHT04vpGdPzaYNbSU=;
 b=J+4v5Rd+srLXd1D4JcVFrdjRb5d0oImc9008L7d/jIJiy2fExIfVKDkzFPhFmYRFJxXC
 KVIVZb/FDpNBbcHz8cYvEp4rN6prphsH/WyheOCOxK10cL+vjBLXDP/oD+fblPD3JZT7
 BEQdNc8ueDBwthLlaQBkCWJ8ELMx5URDdPlCozAbVlmORovUC0mz83KQVNNdDn0AF/7N
 NLNXspn46OC7DQ4r2H6YD+odKaQn+wnBfHIkP988ugRXnPX/3xE4/dG7ksMBXDxTDklj
 R6yv28lCbGAR7QWA1glpqyUYnHynByhGPdDlSYGeC2K+uS5M4HHsOntFdqX5UqGorMOh 0g== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3943ca8gy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 03:45:15 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B7hncf016802;
        Fri, 11 Jun 2021 07:45:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3900w8k99g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 07:45:13 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B7j9lJ28246384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 07:45:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B94711C050;
        Fri, 11 Jun 2021 07:45:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 576EE11C05C;
        Fri, 11 Jun 2021 07:45:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Jun 2021 07:45:09 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: [PATCH net-next 1/2] net/af_iucv: clean up some forward declarations
Date:   Fri, 11 Jun 2021 09:45:01 +0200
Message-Id: <20210611074502.1719233-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611074502.1719233-1-jwi@linux.ibm.com>
References: <20210611074502.1719233-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bM1TJFUfaLhODJXAHxF_c7BSbub7GpWC
X-Proofpoint-GUID: bM1TJFUfaLhODJXAHxF_c7BSbub7GpWC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106110048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The forward declarations for the iucv_handler callbacks are causing
various compile warnings with gcc-11. Reshuffle the code to get rid
of these prototypes.

Reported-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/iucv/af_iucv.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 0fdb389c3390..44453b35c7b7 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -44,6 +44,7 @@ static struct proto iucv_proto = {
 };
 
 static struct iucv_interface *pr_iucv;
+static struct iucv_handler af_iucv_handler;
 
 /* special AF_IUCV IPRM messages */
 static const u8 iprm_shutdown[8] =
@@ -91,28 +92,11 @@ static void iucv_sock_close(struct sock *sk);
 
 static void afiucv_hs_callback_txnotify(struct sock *sk, enum iucv_tx_notify);
 
-/* Call Back functions */
-static void iucv_callback_rx(struct iucv_path *, struct iucv_message *);
-static void iucv_callback_txdone(struct iucv_path *, struct iucv_message *);
-static void iucv_callback_connack(struct iucv_path *, u8 *);
-static int iucv_callback_connreq(struct iucv_path *, u8 *, u8 *);
-static void iucv_callback_connrej(struct iucv_path *, u8 *);
-static void iucv_callback_shutdown(struct iucv_path *, u8 *);
-
 static struct iucv_sock_list iucv_sk_list = {
 	.lock = __RW_LOCK_UNLOCKED(iucv_sk_list.lock),
 	.autobind_name = ATOMIC_INIT(0)
 };
 
-static struct iucv_handler af_iucv_handler = {
-	.path_pending	  = iucv_callback_connreq,
-	.path_complete	  = iucv_callback_connack,
-	.path_severed	  = iucv_callback_connrej,
-	.message_pending  = iucv_callback_rx,
-	.message_complete = iucv_callback_txdone,
-	.path_quiesced	  = iucv_callback_shutdown,
-};
-
 static inline void high_nmcpy(unsigned char *dst, char *src)
 {
        memcpy(dst, src, 8);
@@ -1817,6 +1801,15 @@ static void iucv_callback_shutdown(struct iucv_path *path, u8 ipuser[16])
 	bh_unlock_sock(sk);
 }
 
+static struct iucv_handler af_iucv_handler = {
+	.path_pending		= iucv_callback_connreq,
+	.path_complete		= iucv_callback_connack,
+	.path_severed		= iucv_callback_connrej,
+	.message_pending	= iucv_callback_rx,
+	.message_complete	= iucv_callback_txdone,
+	.path_quiesced		= iucv_callback_shutdown,
+};
+
 /***************** HiperSockets transport callbacks ********************/
 static void afiucv_swap_src_dest(struct sk_buff *skb)
 {
-- 
2.25.1

