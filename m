Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742C4264A55
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgIJQwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:52:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26988 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726899AbgIJQtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:49:23 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AGVBX5021422;
        Thu, 10 Sep 2020 12:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=SdMfayADkgyBhFx3qgxSd2H5buHR5auaayUviJmKrDY=;
 b=DlwkgLlM8MmhmWvXHm+KtD8bzUk3HkKpLzUG8NuOzQxOj6ubWpWOMGehAcFOmgkrugwV
 0VxclUci0v8Mk1gJ+gjKOkuBZaFIUIQf0Po7I13POQOVr0zGgWusCp7nmt1/JG/V2cGG
 FCPgkOIqs7LMGNFFqTOw7uJ+VSBsR+xkNWbXdymexUpS9ttFz7fFT1TFJSQZxgDvQ8Bt
 TLU+KMOZw8NczRW8tm1IJGMzf3TY5oHa4NyOo/et82L8Sx9TSO0pYqScV/n6q26EAJDc
 Y8HesNRqvy81PoGca5IG7908QDLDwK4JHTeUNm+V0Q2le1cG7lusnDSXEbfOb46BeEr5 pw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33fqev16tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 12:49:04 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AGl8UZ021995;
        Thu, 10 Sep 2020 16:49:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 33c2a8bkjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 16:49:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AGmxgk30998878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 16:48:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F9F94C046;
        Thu, 10 Sep 2020 16:48:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A4FE4C052;
        Thu, 10 Sep 2020 16:48:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 16:48:59 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 02/10] net/smc: introduce better field names
Date:   Thu, 10 Sep 2020 18:48:21 +0200
Message-Id: <20200910164829.65426-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910164829.65426-1-kgraul@linux.ibm.com>
References: <20200910164829.65426-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_04:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=3 clxscore=1015 bulkscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009100148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

Field names "srv_first_contact" and "cln_first_contact" are misleading,
since they apply to both, server and client. Rename them to
"first_contact_peer" and "first_contact_local".
Rename "ism_gid" by the more precise name "ism_peer_gid".
Rename version constant "SMC_CLC_V1" into "SMC_V1".
No functional change.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 66 +++++++++++++++++++++++-----------------------
 net/smc/smc.h      |  2 ++
 net/smc/smc_clc.c  | 16 +++++------
 net/smc/smc_clc.h  |  3 +--
 net/smc/smc_core.c | 16 +++++------
 net/smc/smc_core.h |  9 +++----
 6 files changed, 55 insertions(+), 57 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 7212de4da71d..8f6472f4ae21 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -523,11 +523,11 @@ static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code)
 
 /* abort connecting */
 static int smc_connect_abort(struct smc_sock *smc, int reason_code,
-			     int local_contact)
+			     int local_first)
 {
 	bool is_smcd = smc->conn.lgr->is_smcd;
 
-	if (local_contact == SMC_FIRST_CONTACT)
+	if (local_first)
 		smc_lgr_cleanup_early(&smc->conn);
 	else
 		smc_conn_free(&smc->conn);
@@ -615,7 +615,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 	ini->is_smcd = false;
 	ini->ib_lcl = &aclc->lcl;
 	ini->ib_clcqpn = ntoh24(aclc->qpn);
-	ini->srv_first_contact = aclc->hdr.flag;
+	ini->first_contact_peer = aclc->hdr.flag;
 
 	mutex_lock(&smc_client_lgr_pending);
 	reason_code = smc_conn_create(smc, ini);
@@ -626,7 +626,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 
 	smc_conn_save_peer_info(smc, aclc);
 
-	if (ini->cln_first_contact == SMC_FIRST_CONTACT) {
+	if (ini->first_contact_local) {
 		link = smc->conn.lnk;
 	} else {
 		/* set link that was assigned by server */
@@ -643,51 +643,51 @@ static int smc_connect_rdma(struct smc_sock *smc,
 		}
 		if (!link)
 			return smc_connect_abort(smc, SMC_CLC_DECL_NOSRVLINK,
-						 ini->cln_first_contact);
+						 ini->first_contact_local);
 		smc->conn.lnk = link;
 	}
 
 	/* create send buffer and rmb */
 	if (smc_buf_create(smc, false))
 		return smc_connect_abort(smc, SMC_CLC_DECL_MEM,
-					 ini->cln_first_contact);
+					 ini->first_contact_local);
 
-	if (ini->cln_first_contact == SMC_FIRST_CONTACT)
+	if (ini->first_contact_local)
 		smc_link_save_peer_info(link, aclc);
 
 	if (smc_rmb_rtoken_handling(&smc->conn, link, aclc))
 		return smc_connect_abort(smc, SMC_CLC_DECL_ERR_RTOK,
-					 ini->cln_first_contact);
+					 ini->first_contact_local);
 
 	smc_close_init(smc);
 	smc_rx_init(smc);
 
-	if (ini->cln_first_contact == SMC_FIRST_CONTACT) {
+	if (ini->first_contact_local) {
 		if (smc_ib_ready_link(link))
 			return smc_connect_abort(smc, SMC_CLC_DECL_ERR_RDYLNK,
-						 ini->cln_first_contact);
+						 ini->first_contact_local);
 	} else {
 		if (smcr_lgr_reg_rmbs(link, smc->conn.rmb_desc))
 			return smc_connect_abort(smc, SMC_CLC_DECL_ERR_REGRMB,
-						 ini->cln_first_contact);
+						 ini->first_contact_local);
 	}
 	smc_rmb_sync_sg_for_device(&smc->conn);
 
 	reason_code = smc_clc_send_confirm(smc);
 	if (reason_code)
 		return smc_connect_abort(smc, reason_code,
-					 ini->cln_first_contact);
+					 ini->first_contact_local);
 
 	smc_tx_init(smc);
 
-	if (ini->cln_first_contact == SMC_FIRST_CONTACT) {
+	if (ini->first_contact_local) {
 		/* QP confirmation over RoCE fabric */
 		smc_llc_flow_initiate(link->lgr, SMC_LLC_FLOW_ADD_LINK);
 		reason_code = smcr_clnt_conf_first_link(smc);
 		smc_llc_flow_stop(link->lgr, &link->lgr->llc_flow_lcl);
 		if (reason_code)
 			return smc_connect_abort(smc, reason_code,
-						 ini->cln_first_contact);
+						 ini->first_contact_local);
 	}
 	mutex_unlock(&smc_client_lgr_pending);
 
@@ -707,8 +707,8 @@ static int smc_connect_ism(struct smc_sock *smc,
 	int rc = 0;
 
 	ini->is_smcd = true;
-	ini->ism_gid = aclc->gid;
-	ini->srv_first_contact = aclc->hdr.flag;
+	ini->ism_peer_gid = aclc->gid;
+	ini->first_contact_peer = aclc->hdr.flag;
 
 	/* there is only one lgr role for SMC-D; use server lock */
 	mutex_lock(&smc_server_lgr_pending);
@@ -724,7 +724,7 @@ static int smc_connect_ism(struct smc_sock *smc,
 		return smc_connect_abort(smc, (rc == -ENOSPC) ?
 					      SMC_CLC_DECL_MAX_DMB :
 					      SMC_CLC_DECL_MEM,
-					 ini->cln_first_contact);
+					 ini->first_contact_local);
 
 	smc_conn_save_peer_info(smc, aclc);
 	smc_close_init(smc);
@@ -733,7 +733,7 @@ static int smc_connect_ism(struct smc_sock *smc,
 
 	rc = smc_clc_send_confirm(smc);
 	if (rc)
-		return smc_connect_abort(smc, rc, ini->cln_first_contact);
+		return smc_connect_abort(smc, rc, ini->first_contact_local);
 	mutex_unlock(&smc_server_lgr_pending);
 
 	smc_copy_sock_settings_to_clc(smc);
@@ -1127,10 +1127,10 @@ static void smc_listen_out_err(struct smc_sock *new_smc)
 
 /* listen worker: decline and fall back if possible */
 static void smc_listen_decline(struct smc_sock *new_smc, int reason_code,
-			       int local_contact)
+			       bool local_first)
 {
 	/* RDMA setup failed, switch back to TCP */
-	if (local_contact == SMC_FIRST_CONTACT)
+	if (local_first)
 		smc_lgr_cleanup_early(&new_smc->conn);
 	else
 		smc_conn_free(&new_smc->conn);
@@ -1190,7 +1190,7 @@ static int smc_listen_ism_init(struct smc_sock *new_smc,
 	int rc;
 
 	pclc_smcd = smc_get_clc_msg_smcd(pclc);
-	ini->ism_gid = pclc_smcd->gid;
+	ini->ism_peer_gid = pclc_smcd->gid;
 	rc = smc_conn_create(new_smc, ini);
 	if (rc)
 		return rc;
@@ -1199,7 +1199,7 @@ static int smc_listen_ism_init(struct smc_sock *new_smc,
 	if (smc_ism_cantalk(new_smc->conn.lgr->peer_gid,
 			    new_smc->conn.lgr->vlan_id,
 			    new_smc->conn.lgr->smcd)) {
-		if (ini->cln_first_contact == SMC_FIRST_CONTACT)
+		if (ini->first_contact_local)
 			smc_lgr_cleanup_early(&new_smc->conn);
 		else
 			smc_conn_free(&new_smc->conn);
@@ -1209,7 +1209,7 @@ static int smc_listen_ism_init(struct smc_sock *new_smc,
 	/* Create send and receive buffers */
 	rc = smc_buf_create(new_smc, true);
 	if (rc) {
-		if (ini->cln_first_contact == SMC_FIRST_CONTACT)
+		if (ini->first_contact_local)
 			smc_lgr_cleanup_early(&new_smc->conn);
 		else
 			smc_conn_free(&new_smc->conn);
@@ -1221,11 +1221,11 @@ static int smc_listen_ism_init(struct smc_sock *new_smc,
 }
 
 /* listen worker: register buffers */
-static int smc_listen_rdma_reg(struct smc_sock *new_smc, int local_contact)
+static int smc_listen_rdma_reg(struct smc_sock *new_smc, bool local_first)
 {
 	struct smc_connection *conn = &new_smc->conn;
 
-	if (local_contact != SMC_FIRST_CONTACT) {
+	if (!local_first) {
 		if (smcr_lgr_reg_rmbs(conn->lnk, conn->rmb_desc))
 			return SMC_CLC_DECL_ERR_REGRMB;
 	}
@@ -1237,12 +1237,12 @@ static int smc_listen_rdma_reg(struct smc_sock *new_smc, int local_contact)
 /* listen worker: finish RDMA setup */
 static int smc_listen_rdma_finish(struct smc_sock *new_smc,
 				  struct smc_clc_msg_accept_confirm *cclc,
-				  int local_contact)
+				  bool local_first)
 {
 	struct smc_link *link = new_smc->conn.lnk;
 	int reason_code = 0;
 
-	if (local_contact == SMC_FIRST_CONTACT)
+	if (local_first)
 		smc_link_save_peer_info(link, cclc);
 
 	if (smc_rmb_rtoken_handling(&new_smc->conn, link, cclc)) {
@@ -1250,7 +1250,7 @@ static int smc_listen_rdma_finish(struct smc_sock *new_smc,
 		goto decline;
 	}
 
-	if (local_contact == SMC_FIRST_CONTACT) {
+	if (local_first) {
 		if (smc_ib_ready_link(link)) {
 			reason_code = SMC_CLC_DECL_ERR_RDYLNK;
 			goto decline;
@@ -1265,7 +1265,7 @@ static int smc_listen_rdma_finish(struct smc_sock *new_smc,
 	return 0;
 
 decline:
-	smc_listen_decline(new_smc, reason_code, local_contact);
+	smc_listen_decline(new_smc, reason_code, local_first);
 	return reason_code;
 }
 
@@ -1358,13 +1358,13 @@ static void smc_listen_work(struct work_struct *work)
 		rc = smc_listen_rdma_init(new_smc, &ini);
 		if (rc)
 			goto out_unlock;
-		rc = smc_listen_rdma_reg(new_smc, ini.cln_first_contact);
+		rc = smc_listen_rdma_reg(new_smc, ini.first_contact_local);
 		if (rc)
 			goto out_unlock;
 	}
 
 	/* send SMC Accept CLC message */
-	rc = smc_clc_send_accept(new_smc, ini.cln_first_contact);
+	rc = smc_clc_send_accept(new_smc, ini.first_contact_local);
 	if (rc)
 		goto out_unlock;
 
@@ -1384,7 +1384,7 @@ static void smc_listen_work(struct work_struct *work)
 	/* finish worker */
 	if (!ism_supported) {
 		rc = smc_listen_rdma_finish(new_smc, &cclc,
-					    ini.cln_first_contact);
+					    ini.first_contact_local);
 		mutex_unlock(&smc_server_lgr_pending);
 		if (rc)
 			return;
@@ -1396,7 +1396,7 @@ static void smc_listen_work(struct work_struct *work)
 out_unlock:
 	mutex_unlock(&smc_server_lgr_pending);
 out_decl:
-	smc_listen_decline(new_smc, rc, ini.cln_first_contact);
+	smc_listen_decline(new_smc, rc, ini.first_contact_local);
 }
 
 static void smc_tcp_listen_work(struct work_struct *work)
diff --git a/net/smc/smc.h b/net/smc/smc.h
index f38144f83f54..356f39532bf3 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -18,6 +18,8 @@
 
 #include "smc_ib.h"
 
+#define SMC_V1		1		/* SMC version V1 */
+
 #define SMCPROTO_SMC		0	/* SMC protocol, IPv4 */
 #define SMCPROTO_SMC6		1	/* SMC protocol, IPv6 */
 
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 779f4142a11d..c30fad120089 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -320,7 +320,7 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 	}
 	datlen = ntohs(clcm->length);
 	if ((len < sizeof(struct smc_clc_msg_hdr)) ||
-	    (clcm->version < SMC_CLC_V1) ||
+	    (clcm->version < SMC_V1) ||
 	    ((clcm->type != SMC_CLC_DECLINE) &&
 	     (clcm->type != expected_type))) {
 		smc->sk.sk_err = EPROTO;
@@ -389,7 +389,7 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info)
 	memcpy(dclc.hdr.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
 	dclc.hdr.type = SMC_CLC_DECLINE;
 	dclc.hdr.length = htons(sizeof(struct smc_clc_msg_decline));
-	dclc.hdr.version = SMC_CLC_V1;
+	dclc.hdr.version = SMC_V1;
 	dclc.hdr.flag = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ? 1 : 0;
 	if ((!smc->conn.lgr || !smc->conn.lgr->is_smcd) &&
 	    smc_ib_is_valid_local_systemid())
@@ -434,7 +434,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
 	memset(&pclc, 0, sizeof(pclc));
 	memcpy(pclc.hdr.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
 	pclc.hdr.type = SMC_CLC_PROPOSAL;
-	pclc.hdr.version = SMC_CLC_V1;		/* SMC version */
+	pclc.hdr.version = SMC_V1;		/* SMC version */
 	pclc.hdr.path = smc_type;
 	if (smc_type == SMC_TYPE_R || smc_type == SMC_TYPE_B) {
 		/* add SMC-R specifics */
@@ -499,8 +499,8 @@ int smc_clc_send_confirm(struct smc_sock *smc)
 	/* send SMC Confirm CLC msg */
 	memset(&cclc, 0, sizeof(cclc));
 	cclc.hdr.type = SMC_CLC_CONFIRM;
-	cclc.hdr.version = SMC_CLC_V1;		/* SMC version */
-	if (smc->conn.lgr->is_smcd) {
+	cclc.hdr.version = SMC_V1;		/* SMC version */
+	if (conn->lgr->is_smcd) {
 		/* SMC-D specific settings */
 		memcpy(cclc.hdr.eyecatcher, SMCD_EYECATCHER,
 		       sizeof(SMCD_EYECATCHER));
@@ -557,7 +557,7 @@ int smc_clc_send_confirm(struct smc_sock *smc)
 }
 
 /* send CLC ACCEPT message across internal TCP socket */
-int smc_clc_send_accept(struct smc_sock *new_smc, int srv_first_contact)
+int smc_clc_send_accept(struct smc_sock *new_smc, bool srv_first_contact)
 {
 	struct smc_connection *conn = &new_smc->conn;
 	struct smc_clc_msg_accept_confirm aclc;
@@ -568,11 +568,11 @@ int smc_clc_send_accept(struct smc_sock *new_smc, int srv_first_contact)
 
 	memset(&aclc, 0, sizeof(aclc));
 	aclc.hdr.type = SMC_CLC_ACCEPT;
-	aclc.hdr.version = SMC_CLC_V1;		/* SMC version */
+	aclc.hdr.version = SMC_V1;		/* SMC version */
 	if (srv_first_contact)
 		aclc.hdr.flag = 1;
 
-	if (new_smc->conn.lgr->is_smcd) {
+	if (conn->lgr->is_smcd) {
 		/* SMC-D specific settings */
 		aclc.hdr.length = htons(SMCD_CLC_ACCEPT_CONFIRM_LEN);
 		memcpy(aclc.hdr.eyecatcher, SMCD_EYECATCHER,
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index cf7b45306f4e..f98ca84ef2fe 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -22,7 +22,6 @@
 #define SMC_CLC_CONFIRM		0x03
 #define SMC_CLC_DECLINE		0x04
 
-#define SMC_CLC_V1		0x1		/* SMC version                */
 #define SMC_TYPE_R		0		/* SMC-R only		      */
 #define SMC_TYPE_D		1		/* SMC-D only		      */
 #define SMC_TYPE_N		2		/* neither SMC-R nor SMC-D    */
@@ -200,6 +199,6 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info);
 int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
 			  struct smc_init_info *ini);
 int smc_clc_send_confirm(struct smc_sock *smc);
-int smc_clc_send_accept(struct smc_sock *smc, int srv_first_contact);
+int smc_clc_send_accept(struct smc_sock *smc, bool srv_first_contact);
 
 #endif
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index a406627b1d55..c02e58002782 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -418,7 +418,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	if (ini->is_smcd) {
 		/* SMC-D specific settings */
 		get_device(&ini->ism_dev->dev);
-		lgr->peer_gid = ini->ism_gid;
+		lgr->peer_gid = ini->ism_peer_gid;
 		lgr->smcd = ini->ism_dev;
 		lgr_list = &ini->ism_dev->lgr_list;
 		lgr_lock = &lgr->smcd->lgr_lock;
@@ -1296,9 +1296,9 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 
 	lgr_list = ini->is_smcd ? &ini->ism_dev->lgr_list : &smc_lgr_list.list;
 	lgr_lock = ini->is_smcd ? &ini->ism_dev->lgr_lock : &smc_lgr_list.lock;
-	ini->cln_first_contact = SMC_FIRST_CONTACT;
+	ini->first_contact_local = 1;
 	role = smc->listen_smc ? SMC_SERV : SMC_CLNT;
-	if (role == SMC_CLNT && ini->srv_first_contact)
+	if (role == SMC_CLNT && ini->first_contact_peer)
 		/* create new link group as well */
 		goto create;
 
@@ -1307,14 +1307,14 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 	list_for_each_entry(lgr, lgr_list, list) {
 		write_lock_bh(&lgr->conns_lock);
 		if ((ini->is_smcd ?
-		     smcd_lgr_match(lgr, ini->ism_dev, ini->ism_gid) :
+		     smcd_lgr_match(lgr, ini->ism_dev, ini->ism_peer_gid) :
 		     smcr_lgr_match(lgr, ini->ib_lcl, role, ini->ib_clcqpn)) &&
 		    !lgr->sync_err &&
 		    lgr->vlan_id == ini->vlan_id &&
 		    (role == SMC_CLNT || ini->is_smcd ||
 		     lgr->conns_num < SMC_RMBS_PER_LGR_MAX)) {
 			/* link group found */
-			ini->cln_first_contact = SMC_REUSE_CONTACT;
+			ini->first_contact_local = 0;
 			conn->lgr = lgr;
 			rc = smc_lgr_register_conn(conn, false);
 			write_unlock_bh(&lgr->conns_lock);
@@ -1328,8 +1328,8 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 	if (rc)
 		return rc;
 
-	if (role == SMC_CLNT && !ini->srv_first_contact &&
-	    ini->cln_first_contact == SMC_FIRST_CONTACT) {
+	if (role == SMC_CLNT && !ini->first_contact_peer &&
+	    ini->first_contact_local) {
 		/* Server reuses a link group, but Client wants to start
 		 * a new one
 		 * send out_of_sync decline, reason synchr. error
@@ -1338,7 +1338,7 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 	}
 
 create:
-	if (ini->cln_first_contact == SMC_FIRST_CONTACT) {
+	if (ini->first_contact_local) {
 		rc = smc_lgr_create(smc, ini);
 		if (rc)
 			goto out;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 1c4d5439d0ff..d70da797f495 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -137,9 +137,6 @@ struct smc_link {
 #define SMC_LINKS_PER_LGR_MAX	3
 #define SMC_SINGLE_LINK		0
 
-#define SMC_FIRST_CONTACT	1		/* first contact to a peer */
-#define SMC_REUSE_CONTACT	0		/* follow-on contact to a peer*/
-
 /* tx/rx buffer list element for sndbufs list and rmbs list of a lgr */
 struct smc_buf_desc {
 	struct list_head	list;
@@ -294,9 +291,9 @@ struct smc_clc_msg_local;
 
 struct smc_init_info {
 	u8			is_smcd;
+	u8			first_contact_peer;
+	u8			first_contact_local;
 	unsigned short		vlan_id;
-	int			srv_first_contact;
-	int			cln_first_contact;
 	/* SMC-R */
 	struct smc_clc_msg_local *ib_lcl;
 	struct smc_ib_device	*ib_dev;
@@ -304,7 +301,7 @@ struct smc_init_info {
 	u8			ib_port;
 	u32			ib_clcqpn;
 	/* SMC-D */
-	u64			ism_gid;
+	u64			ism_peer_gid;
 	struct smcd_dev		*ism_dev;
 };
 
-- 
2.17.1

