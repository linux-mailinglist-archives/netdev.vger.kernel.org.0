Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680C721F3E0
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgGNOXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:23:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2856 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728726AbgGNOX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:23:26 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EE3f1p180498;
        Tue, 14 Jul 2020 10:23:23 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 329apwfw19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 10:23:23 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EEGjub012807;
        Tue, 14 Jul 2020 14:23:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 327527ue75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 14:23:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EENEgs57278514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 14:23:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1A174C05E;
        Tue, 14 Jul 2020 14:23:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9399E4C059;
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
Subject: [PATCH net-next 07/10] s390/qeth: clean up a magic number in the OAT callback
Date:   Tue, 14 Jul 2020 16:23:02 +0200
Message-Id: <20200714142305.29297-8-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200714142305.29297-1-jwi@linux.ibm.com>
References: <20200714142305.29297-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_04:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the correct struct member instead of hardcoding its offset.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 31fa9ffc7cf4..c5ff7edb4ba1 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4839,7 +4839,6 @@ static int qeth_setadpparms_query_oat_cb(struct qeth_card *card,
 {
 	struct qeth_ipa_cmd *cmd = (struct qeth_ipa_cmd *)data;
 	struct qeth_qoat_priv *priv;
-	char *resdata;
 	int resdatalen;
 
 	QETH_CARD_TEXT(card, 3, "qoatcb");
@@ -4848,13 +4847,12 @@ static int qeth_setadpparms_query_oat_cb(struct qeth_card *card,
 
 	priv = (struct qeth_qoat_priv *)reply->param;
 	resdatalen = cmd->data.setadapterparms.hdr.cmdlength;
-	resdata = (char *)data + 28;
 
 	if (resdatalen > (priv->buffer_len - priv->response_len))
 		return -ENOSPC;
 
-	memcpy((priv->buffer + priv->response_len), resdata,
-		resdatalen);
+	memcpy(priv->buffer + priv->response_len,
+	       &cmd->data.setadapterparms.hdr, resdatalen);
 	priv->response_len += resdatalen;
 
 	if (cmd->data.setadapterparms.hdr.seq_no <
-- 
2.17.1

