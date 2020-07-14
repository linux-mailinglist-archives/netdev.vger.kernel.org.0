Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960A521F3DC
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgGNOXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:23:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726934AbgGNOXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:23:22 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EE2xml084503;
        Tue, 14 Jul 2020 10:23:20 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3298eakv9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 10:23:20 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EEGsUi012853;
        Tue, 14 Jul 2020 14:23:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 327527ue76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 14:23:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EENFow60358980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 14:23:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A4864C040;
        Tue, 14 Jul 2020 14:23:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED0BF4C062;
        Tue, 14 Jul 2020 14:23:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 14:23:14 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 08/10] s390/qeth: cleanup OAT code
Date:   Tue, 14 Jul 2020 16:23:03 +0200
Message-Id: <20200714142305.29297-9-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200714142305.29297-1-jwi@linux.ibm.com>
References: <20200714142305.29297-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_04:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=2
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While initially just trying to fix up the indentation, condense a few
lines and get rid of a goto label.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 40 ++++++++++---------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index c5ff7edb4ba1..053a25e34e4b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4835,17 +4835,17 @@ static int qeth_snmp_command(struct qeth_card *card, char __user *udata)
 }
 
 static int qeth_setadpparms_query_oat_cb(struct qeth_card *card,
-		struct qeth_reply *reply, unsigned long data)
+					 struct qeth_reply *reply,
+					 unsigned long data)
 {
 	struct qeth_ipa_cmd *cmd = (struct qeth_ipa_cmd *)data;
-	struct qeth_qoat_priv *priv;
+	struct qeth_qoat_priv *priv = reply->param;
 	int resdatalen;
 
 	QETH_CARD_TEXT(card, 3, "qoatcb");
 	if (qeth_setadpparms_inspect_rc(cmd))
 		return -EIO;
 
-	priv = (struct qeth_qoat_priv *)reply->param;
 	resdatalen = cmd->data.setadapterparms.hdr.cmdlength;
 
 	if (resdatalen > (priv->buffer_len - priv->response_len))
@@ -4873,24 +4873,17 @@ static int qeth_query_oat_command(struct qeth_card *card, char __user *udata)
 
 	QETH_CARD_TEXT(card, 3, "qoatcmd");
 
-	if (!qeth_adp_supported(card, IPA_SETADP_QUERY_OAT)) {
-		rc = -EOPNOTSUPP;
-		goto out;
-	}
+	if (!qeth_adp_supported(card, IPA_SETADP_QUERY_OAT))
+		return -EOPNOTSUPP;
 
-	if (copy_from_user(&oat_data, udata,
-	    sizeof(struct qeth_query_oat_data))) {
-			rc = -EFAULT;
-			goto out;
-	}
+	if (copy_from_user(&oat_data, udata, sizeof(oat_data)))
+		return -EFAULT;
 
 	priv.buffer_len = oat_data.buffer_len;
 	priv.response_len = 0;
 	priv.buffer = vzalloc(oat_data.buffer_len);
-	if (!priv.buffer) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	if (!priv.buffer)
+		return -ENOMEM;
 
 	iob = qeth_get_adapter_cmd(card, IPA_SETADP_QUERY_OAT,
 				   SETADP_DATA_SIZEOF(query_oat));
@@ -4902,28 +4895,19 @@ static int qeth_query_oat_command(struct qeth_card *card, char __user *udata)
 	oat_req = &cmd->data.setadapterparms.data.query_oat;
 	oat_req->subcmd_code = oat_data.command;
 
-	rc = qeth_send_ipa_cmd(card, iob, qeth_setadpparms_query_oat_cb,
-			       &priv);
+	rc = qeth_send_ipa_cmd(card, iob, qeth_setadpparms_query_oat_cb, &priv);
 	if (!rc) {
 		tmp = is_compat_task() ? compat_ptr(oat_data.ptr) :
 					 u64_to_user_ptr(oat_data.ptr);
-
-		if (copy_to_user(tmp, priv.buffer,
-		    priv.response_len)) {
-			rc = -EFAULT;
-			goto out_free;
-		}
-
 		oat_data.response_len = priv.response_len;
 
-		if (copy_to_user(udata, &oat_data,
-		    sizeof(struct qeth_query_oat_data)))
+		if (copy_to_user(tmp, priv.buffer, priv.response_len) ||
+		    copy_to_user(udata, &oat_data, sizeof(oat_data)))
 			rc = -EFAULT;
 	}
 
 out_free:
 	vfree(priv.buffer);
-out:
 	return rc;
 }
 
-- 
2.17.1

