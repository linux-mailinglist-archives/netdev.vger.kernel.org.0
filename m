Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D75816161A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgBQPZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:25:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728631AbgBQPZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:25:08 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HFJIIp133001
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 10:25:07 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6adqxsvm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 10:25:06 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <ubraun@linux.ibm.com>;
        Mon, 17 Feb 2020 15:25:04 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 15:25:03 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HFOxsM60424238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 15:24:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35F9FA4051;
        Mon, 17 Feb 2020 15:24:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E78AAA4055;
        Mon, 17 Feb 2020 15:24:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 15:24:58 +0000 (GMT)
From:   Ursula Braun <ubraun@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com
Subject: [PATCH net-next 4/6] net/smc: remove unused parameter of smc_lgr_terminate()
Date:   Mon, 17 Feb 2020 16:24:53 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200217152455.15341-1-ubraun@linux.ibm.com>
References: <20200217152455.15341-1-ubraun@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20021715-4275-0000-0000-000003A2D44E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021715-4276-0000-0000-000038B6D913
Message-Id: <20200217152455.15341-5-ubraun@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_10:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=3 priorityscore=1501 adultscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002170126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

The soft parameter of smc_lgr_terminate() is not used and obsolete.
Remove it.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_clc.c  |  2 +-
 net/smc/smc_core.c | 18 ++++++++----------
 net/smc/smc_core.h |  2 +-
 net/smc/smc_llc.c  |  2 +-
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 86cccc24e52e..aee9ccfa99c2 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -349,7 +349,7 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 		smc->peer_diagnosis = ntohl(dclc->peer_diagnosis);
 		if (((struct smc_clc_msg_decline *)buf)->hdr.flag) {
 			smc->conn.lgr->sync_err = 1;
-			smc_lgr_terminate(smc->conn.lgr, true);
+			smc_lgr_terminate(smc->conn.lgr);
 		}
 	}
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 9b92b52952dd..53b6afbb1d93 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -229,7 +229,7 @@ static void smc_lgr_terminate_work(struct work_struct *work)
 	struct smc_link_group *lgr = container_of(work, struct smc_link_group,
 						  terminate_work);
 
-	smc_lgr_terminate(lgr, true);
+	smc_lgr_terminate(lgr);
 }
 
 /* create a new SMC link group */
@@ -581,7 +581,10 @@ static void smc_lgr_cleanup(struct smc_link_group *lgr)
 	}
 }
 
-/* terminate link group */
+/* terminate link group
+ * @soft: true if link group shutdown can take its time
+ *	  false if immediate link group shutdown is required
+ */
 static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 {
 	struct smc_connection *conn;
@@ -619,11 +622,8 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 		smc_lgr_free(lgr);
 }
 
-/* unlink and terminate link group
- * @soft: true if link group shutdown can take its time
- *	  false if immediate link group shutdown is required
- */
-void smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
+/* unlink and terminate link group */
+void smc_lgr_terminate(struct smc_link_group *lgr)
 {
 	spinlock_t *lgr_lock;
 
@@ -633,11 +633,9 @@ void smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 		spin_unlock_bh(lgr_lock);
 		return;	/* lgr already terminating */
 	}
-	if (!soft)
-		lgr->freeing = 1;
 	list_del_init(&lgr->list);
 	spin_unlock_bh(lgr_lock);
-	__smc_lgr_terminate(lgr, soft);
+	__smc_lgr_terminate(lgr, true);
 }
 
 /* Called when IB port is terminated */
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index c472e12951d1..094d43c24345 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -296,7 +296,7 @@ struct smc_clc_msg_accept_confirm;
 struct smc_clc_msg_local;
 
 void smc_lgr_forget(struct smc_link_group *lgr);
-void smc_lgr_terminate(struct smc_link_group *lgr, bool soft);
+void smc_lgr_terminate(struct smc_link_group *lgr);
 void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport);
 void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid,
 			unsigned short vlan);
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index a9f6431dd69a..b134a08c929e 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -614,7 +614,7 @@ static void smc_llc_testlink_work(struct work_struct *work)
 	rc = wait_for_completion_interruptible_timeout(&link->llc_testlink_resp,
 						       SMC_LLC_WAIT_TIME);
 	if (rc <= 0) {
-		smc_lgr_terminate(smc_get_lgr(link), true);
+		smc_lgr_terminate(smc_get_lgr(link));
 		return;
 	}
 	next_interval = link->llc_testlink_time;
-- 
2.17.1

