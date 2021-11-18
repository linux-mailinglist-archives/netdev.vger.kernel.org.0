Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25B245602B
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhKRQJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:09:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232944AbhKRQJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 11:09:36 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIFIV2R005279;
        Thu, 18 Nov 2021 16:06:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rLo4Ltix64CtLgrw5QeXdiiKZ6IBVW6Hc4yNNKq6s1w=;
 b=h4bU0LGmE/y02M5T5pY94Aon9mLvcf09hy09l/LoET9byBQLCoKvo/xyz65JvglQMuwh
 wBMjzeT0T5bedeA+G0y4q9JpX86qx9K5slhu8eN0512Xvi4oaNy2IEA1DxzGnhShA9ei
 9V/WcJaZXyliiaUD8EOc+Ej9xe8z9ycxWhqoL8GRtATHkBszr9LCamgfhKC8LSja9M7T
 tN2bPpdFM2aPv0PAaRbOqy5r2ReuZjY4OsdPttv+dvrM8NcaSorymGakEn36GZ0I7USt
 9XP83TQ3FJ3zUxvsXgvtH7IxCGPedRuXTTbll7Koy3kjJSTSszLiO42v59phi5CuIcF2 5w== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cds8n9gg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:06:34 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AIG3wtq028423;
        Thu, 18 Nov 2021 16:06:31 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3ca50bqsdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:06:30 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AIG6O7941091462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 16:06:24 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8381AE05A;
        Thu, 18 Nov 2021 16:06:24 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D152AE051;
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
Subject: [PATCH net-next 2/6] net/iucv: fix kernel doc comments
Date:   Thu, 18 Nov 2021 17:06:03 +0100
Message-Id: <20211118160607.2245947-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211118160607.2245947-1-kgraul@linux.ibm.com>
References: <20211118160607.2245947-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hdD-kb7Fmw4UEDsAj9M8YgUlA6XLjUtF
X-Proofpoint-ORIG-GUID: hdD-kb7Fmw4UEDsAj9M8YgUlA6XLjUtF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=479 clxscore=1015 priorityscore=1501
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111180089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

Fix kernel doc comments where appropriate or remove incorrect kernel
doc indicators.
Also move kernel doc comments directly before functions.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/iucv/iucv.c | 124 ++++++++++++++++++++++++------------------------
 1 file changed, 62 insertions(+), 62 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index f3343a8541a5..8f4d49a7d3e8 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -276,8 +276,8 @@ static union iucv_param *iucv_param[NR_CPUS];
 static union iucv_param *iucv_param_irq[NR_CPUS];
 
 /**
- * iucv_call_b2f0
- * @code: identifier of IUCV call to CP.
+ * __iucv_call_b2f0
+ * @command: identifier of IUCV call to CP.
  * @parm: pointer to a struct iucv_parm block
  *
  * Calls CP to execute IUCV commands.
@@ -309,7 +309,7 @@ static inline int iucv_call_b2f0(int command, union iucv_param *parm)
 	return ccode == 1 ? parm->ctrl.iprcode : ccode;
 }
 
-/**
+/*
  * iucv_query_maxconn
  *
  * Determines the maximum number of connections that may be established.
@@ -493,8 +493,8 @@ static void iucv_retrieve_cpu(void *data)
 	cpumask_clear_cpu(cpu, &iucv_buffer_cpumask);
 }
 
-/**
- * iucv_setmask_smp
+/*
+ * iucv_setmask_mp
  *
  * Allow iucv interrupts on all cpus.
  */
@@ -512,7 +512,7 @@ static void iucv_setmask_mp(void)
 	cpus_read_unlock();
 }
 
-/**
+/*
  * iucv_setmask_up
  *
  * Allow iucv interrupts on a single cpu.
@@ -529,7 +529,7 @@ static void iucv_setmask_up(void)
 		smp_call_function_single(cpu, iucv_block_cpu, NULL, 1);
 }
 
-/**
+/*
  * iucv_enable
  *
  * This function makes iucv ready for use. It allocates the pathid
@@ -564,7 +564,7 @@ static int iucv_enable(void)
 	return rc;
 }
 
-/**
+/*
  * iucv_disable
  *
  * This function shuts down iucv. It disables iucv interrupts, retrieves
@@ -1347,8 +1347,9 @@ EXPORT_SYMBOL(iucv_message_send);
  * @srccls: source class of message
  * @buffer: address of send buffer or address of struct iucv_array
  * @size: length of send buffer
- * @ansbuf: address of answer buffer or address of struct iucv_array
+ * @answer: address of answer buffer or address of struct iucv_array
  * @asize: size of reply buffer
+ * @residual: ignored
  *
  * This function transmits data to another application. Data to be
  * transmitted is in a buffer. The receiver of the send is expected to
@@ -1400,13 +1401,6 @@ int iucv_message_send2way(struct iucv_path *path, struct iucv_message *msg,
 }
 EXPORT_SYMBOL(iucv_message_send2way);
 
-/**
- * iucv_path_pending
- * @data: Pointer to external interrupt buffer
- *
- * Process connection pending work item. Called from tasklet while holding
- * iucv_table_lock.
- */
 struct iucv_path_pending {
 	u16 ippathid;
 	u8  ipflags1;
@@ -1420,6 +1414,13 @@ struct iucv_path_pending {
 	u8  res4[3];
 } __packed;
 
+/**
+ * iucv_path_pending
+ * @data: Pointer to external interrupt buffer
+ *
+ * Process connection pending work item. Called from tasklet while holding
+ * iucv_table_lock.
+ */
 static void iucv_path_pending(struct iucv_irq_data *data)
 {
 	struct iucv_path_pending *ipp = (void *) data;
@@ -1461,13 +1462,6 @@ static void iucv_path_pending(struct iucv_irq_data *data)
 	iucv_sever_pathid(ipp->ippathid, error);
 }
 
-/**
- * iucv_path_complete
- * @data: Pointer to external interrupt buffer
- *
- * Process connection complete work item. Called from tasklet while holding
- * iucv_table_lock.
- */
 struct iucv_path_complete {
 	u16 ippathid;
 	u8  ipflags1;
@@ -1481,6 +1475,13 @@ struct iucv_path_complete {
 	u8  res4[3];
 } __packed;
 
+/**
+ * iucv_path_complete
+ * @data: Pointer to external interrupt buffer
+ *
+ * Process connection complete work item. Called from tasklet while holding
+ * iucv_table_lock.
+ */
 static void iucv_path_complete(struct iucv_irq_data *data)
 {
 	struct iucv_path_complete *ipc = (void *) data;
@@ -1492,13 +1493,6 @@ static void iucv_path_complete(struct iucv_irq_data *data)
 		path->handler->path_complete(path, ipc->ipuser);
 }
 
-/**
- * iucv_path_severed
- * @data: Pointer to external interrupt buffer
- *
- * Process connection severed work item. Called from tasklet while holding
- * iucv_table_lock.
- */
 struct iucv_path_severed {
 	u16 ippathid;
 	u8  res1;
@@ -1511,6 +1505,13 @@ struct iucv_path_severed {
 	u8  res5[3];
 } __packed;
 
+/**
+ * iucv_path_severed
+ * @data: Pointer to external interrupt buffer
+ *
+ * Process connection severed work item. Called from tasklet while holding
+ * iucv_table_lock.
+ */
 static void iucv_path_severed(struct iucv_irq_data *data)
 {
 	struct iucv_path_severed *ips = (void *) data;
@@ -1528,13 +1529,6 @@ static void iucv_path_severed(struct iucv_irq_data *data)
 	}
 }
 
-/**
- * iucv_path_quiesced
- * @data: Pointer to external interrupt buffer
- *
- * Process connection quiesced work item. Called from tasklet while holding
- * iucv_table_lock.
- */
 struct iucv_path_quiesced {
 	u16 ippathid;
 	u8  res1;
@@ -1547,6 +1541,13 @@ struct iucv_path_quiesced {
 	u8  res5[3];
 } __packed;
 
+/**
+ * iucv_path_quiesced
+ * @data: Pointer to external interrupt buffer
+ *
+ * Process connection quiesced work item. Called from tasklet while holding
+ * iucv_table_lock.
+ */
 static void iucv_path_quiesced(struct iucv_irq_data *data)
 {
 	struct iucv_path_quiesced *ipq = (void *) data;
@@ -1556,13 +1557,6 @@ static void iucv_path_quiesced(struct iucv_irq_data *data)
 		path->handler->path_quiesced(path, ipq->ipuser);
 }
 
-/**
- * iucv_path_resumed
- * @data: Pointer to external interrupt buffer
- *
- * Process connection resumed work item. Called from tasklet while holding
- * iucv_table_lock.
- */
 struct iucv_path_resumed {
 	u16 ippathid;
 	u8  res1;
@@ -1575,6 +1569,13 @@ struct iucv_path_resumed {
 	u8  res5[3];
 } __packed;
 
+/**
+ * iucv_path_resumed
+ * @data: Pointer to external interrupt buffer
+ *
+ * Process connection resumed work item. Called from tasklet while holding
+ * iucv_table_lock.
+ */
 static void iucv_path_resumed(struct iucv_irq_data *data)
 {
 	struct iucv_path_resumed *ipr = (void *) data;
@@ -1584,13 +1585,6 @@ static void iucv_path_resumed(struct iucv_irq_data *data)
 		path->handler->path_resumed(path, ipr->ipuser);
 }
 
-/**
- * iucv_message_complete
- * @data: Pointer to external interrupt buffer
- *
- * Process message complete work item. Called from tasklet while holding
- * iucv_table_lock.
- */
 struct iucv_message_complete {
 	u16 ippathid;
 	u8  ipflags1;
@@ -1606,6 +1600,13 @@ struct iucv_message_complete {
 	u8  res2[3];
 } __packed;
 
+/**
+ * iucv_message_complete
+ * @data: Pointer to external interrupt buffer
+ *
+ * Process message complete work item. Called from tasklet while holding
+ * iucv_table_lock.
+ */
 static void iucv_message_complete(struct iucv_irq_data *data)
 {
 	struct iucv_message_complete *imc = (void *) data;
@@ -1624,13 +1625,6 @@ static void iucv_message_complete(struct iucv_irq_data *data)
 	}
 }
 
-/**
- * iucv_message_pending
- * @data: Pointer to external interrupt buffer
- *
- * Process message pending work item. Called from tasklet while holding
- * iucv_table_lock.
- */
 struct iucv_message_pending {
 	u16 ippathid;
 	u8  ipflags1;
@@ -1653,6 +1647,13 @@ struct iucv_message_pending {
 	u8  res2[3];
 } __packed;
 
+/**
+ * iucv_message_pending
+ * @data: Pointer to external interrupt buffer
+ *
+ * Process message pending work item. Called from tasklet while holding
+ * iucv_table_lock.
+ */
 static void iucv_message_pending(struct iucv_irq_data *data)
 {
 	struct iucv_message_pending *imp = (void *) data;
@@ -1673,7 +1674,7 @@ static void iucv_message_pending(struct iucv_irq_data *data)
 	}
 }
 
-/**
+/*
  * iucv_tasklet_fn:
  *
  * This tasklet loops over the queue of irq buffers created by
@@ -1717,7 +1718,7 @@ static void iucv_tasklet_fn(unsigned long ignored)
 	spin_unlock(&iucv_table_lock);
 }
 
-/**
+/*
  * iucv_work_fn:
  *
  * This work function loops over the queue of path pending irq blocks
@@ -1748,9 +1749,8 @@ static void iucv_work_fn(struct work_struct *work)
 	spin_unlock_bh(&iucv_table_lock);
 }
 
-/**
+/*
  * iucv_external_interrupt
- * @code: irq code
  *
  * Handles external interrupts coming in from CP.
  * Places the interrupt buffer on a queue and schedules iucv_tasklet_fn().
-- 
2.25.1

