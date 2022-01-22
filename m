Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B814A496985
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 03:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbiAVC7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 21:59:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41470 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232051AbiAVC72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 21:59:28 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20M1cFmF014002
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 02:59:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=P5zQipyAIcTiTlfLk0VYs7czzwheQFTLG72jH+iYouo=;
 b=KREMFwapzrIDBhxWlZHgr+XM+UkID04QSwwSFjhufm0iGS+RGexDLVe+e7R6HBZQz0vI
 Y6NOAIe8qUyg9wFNgrqtKwO+DWA5VE1jiyaQYOT9xORVShAlawK7DatxaYnOQazy3ULl
 dvqy0T+NiGTHT12oA5HiKEXBAR0+Di4a0KgEwhHfzHJpG+hyaiziajc/sxKvNJFw+WTY
 Jq8ORBwvemEPHlsF0HMNXhiwr+ObMT3LWH+hkHPYb2WtsoXdvwRre/YM+YZ6Tu/oyC3g
 MIgH9prq4JyanxjtRSaTHO5KvOtnx8F5cZ8s18FxyiZCePw3tMENyy7horCuq0bgkSBZ BA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dr1w403vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 02:59:28 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20M2uhQZ012629
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 02:59:27 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 3dr9j8r16s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 02:59:27 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20M2xPhU37487000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Jan 2022 02:59:25 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E6B328060;
        Sat, 22 Jan 2022 02:59:25 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B65162805A;
        Sat, 22 Jan 2022 02:59:24 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.135.77])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 22 Jan 2022 02:59:24 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net 4/4] ibmvnic: remove unused ->wait_capability
Date:   Fri, 21 Jan 2022 18:59:21 -0800
Message-Id: <20220122025921.199446-4-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220122025921.199446-1-sukadev@linux.ibm.com>
References: <20220122025921.199446-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pFE28F2mRXUY8RiFQdWqtHmijRKt6vMx
X-Proofpoint-ORIG-GUID: pFE28F2mRXUY8RiFQdWqtHmijRKt6vMx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201220010
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With previous bug fix, ->wait_capability flag is no longer needed and can
be removed.

Fixes: 249168ad07cd ("ibmvnic: Make CRQ interrupt tasklet wait for all capabilities crqs")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 38 +++++++++++-------------------
 drivers/net/ethernet/ibm/ibmvnic.h |  1 -
 2 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 682a440151a8..8ed0b95147db 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4876,10 +4876,8 @@ static void handle_request_cap_rsp(union ibmvnic_crq *crq,
 	}
 
 	/* Done receiving requested capabilities, query IP offload support */
-	if (atomic_read(&adapter->running_cap_crqs) == 0) {
-		adapter->wait_capability = false;
+	if (atomic_read(&adapter->running_cap_crqs) == 0)
 		send_query_ip_offload(adapter);
-	}
 }
 
 static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
@@ -5177,10 +5175,8 @@ static void handle_query_cap_rsp(union ibmvnic_crq *crq,
 	}
 
 out:
-	if (atomic_read(&adapter->running_cap_crqs) == 0) {
-		adapter->wait_capability = false;
+	if (atomic_read(&adapter->running_cap_crqs) == 0)
 		send_request_cap(adapter, 0);
-	}
 }
 
 static int send_query_phys_parms(struct ibmvnic_adapter *adapter)
@@ -5476,27 +5472,21 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
 	struct ibmvnic_crq_queue *queue = &adapter->crq;
 	union ibmvnic_crq *crq;
 	unsigned long flags;
-	bool done = false;
 
 	spin_lock_irqsave(&queue->lock, flags);
-	while (!done) {
-		/* Pull all the valid messages off the CRQ */
-		while ((crq = ibmvnic_next_crq(adapter)) != NULL) {
-			/* This barrier makes sure ibmvnic_next_crq()'s
-			 * crq->generic.first & IBMVNIC_CRQ_CMD_RSP is loaded
-			 * before ibmvnic_handle_crq()'s
-			 * switch(gen_crq->first) and switch(gen_crq->cmd).
-			 */
-			dma_rmb();
-			ibmvnic_handle_crq(crq, adapter);
-			crq->generic.first = 0;
-		}
+
+	/* Pull all the valid messages off the CRQ */
+	while ((crq = ibmvnic_next_crq(adapter)) != NULL) {
+		/* This barrier makes sure ibmvnic_next_crq()'s
+		 * crq->generic.first & IBMVNIC_CRQ_CMD_RSP is loaded
+		 * before ibmvnic_handle_crq()'s
+		 * switch(gen_crq->first) and switch(gen_crq->cmd).
+		 */
+		dma_rmb();
+		ibmvnic_handle_crq(crq, adapter);
+		crq->generic.first = 0;
 	}
-	/* if capabilities CRQ's were sent in this tasklet, the following
-	 * tasklet must wait until all responses are received
-	 */
-	if (atomic_read(&adapter->running_cap_crqs) != 0)
-		adapter->wait_capability = true;
+
 	spin_unlock_irqrestore(&queue->lock, flags);
 }
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index b8e42f67d897..a80f94e161ad 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -921,7 +921,6 @@ struct ibmvnic_adapter {
 	int login_rsp_buf_sz;
 
 	atomic_t running_cap_crqs;
-	bool wait_capability;
 
 	struct ibmvnic_sub_crq_queue **tx_scrq ____cacheline_aligned;
 	struct ibmvnic_sub_crq_queue **rx_scrq ____cacheline_aligned;
-- 
2.27.0

