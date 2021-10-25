Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7154439323
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 11:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbhJYJ7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 05:59:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48674 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232735AbhJYJ7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 05:59:36 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P9hZeQ002427;
        Mon, 25 Oct 2021 09:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=h0xWfZWs4/y4r3LV8jOOJvvFPNBL3byX14AsEKPTwY4=;
 b=VtF7faEvOgXUljCt0T3fQGbH8san0NcW3y4azpphTOLc91B+2sciSrkexDsoSJJGeL9I
 geem2hM1cwrltdSxFbuoOvYj9WswIfEO6S11tMXsN7l4jCQ1dwGiV/Ni9Vp2D+TkZzph
 WABJJQTacchFDA8vsnaeUKhSLB1qUVx4sfmyffIYJeSNcOIvAF4mBvtKwKsF/W4HrX3y
 SIdFZbSu/rRT6rzhpkDi1QMknuDt0mp8CnFR+7zhkIOvnCR3TgmX3JM7rJThVjy2wX6V
 hPzFHk5RaGv4rgIoQnqDLc+1ct4ubcy66/BQHRuv09x20+bQ5FJJDjw8KcZGKy93hpFL dw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bwt6s88r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P9h1N7017192;
        Mon, 25 Oct 2021 09:57:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3bwqst9pyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P9v6P12491094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 09:57:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D93E611C054;
        Mon, 25 Oct 2021 09:57:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95FCD11C050;
        Mon, 25 Oct 2021 09:57:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 09:57:06 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 8/9] s390/qeth: fix kernel doc comments
Date:   Mon, 25 Oct 2021 11:56:57 +0200
Message-Id: <20211025095658.3527635-9-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025095658.3527635-1-jwi@linux.ibm.com>
References: <20211025095658.3527635-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: scWCEL8AdbNHt7bAocjgYyBBQlYgogEg
X-Proofpoint-ORIG-GUID: scWCEL8AdbNHt7bAocjgYyBBQlYgogEg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_03,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 impostorscore=0 adultscore=0 bulkscore=0 priorityscore=1501 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110250058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

Fix kernel doc comments and remove incorrect kernel doc indicators.

Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 10 +++++-----
 drivers/s390/net/qeth_l3_main.c   |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index df0b96a3943c..6e410497826a 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1925,9 +1925,9 @@ static struct qeth_cmd_buffer *qeth_mpc_alloc_cmd(struct qeth_card *card,
  * @card:			qeth_card structure pointer
  * @iob:			qeth_cmd_buffer pointer
  * @reply_cb:			callback function pointer
- * @cb_card:			pointer to the qeth_card structure
- * @cb_reply:			pointer to the qeth_reply structure
- * @cb_cmd:			pointer to the original iob for non-IPA
+ *  cb_card:			pointer to the qeth_card structure
+ *  cb_reply:			pointer to the qeth_reply structure
+ *  cb_cmd:			pointer to the original iob for non-IPA
  *				commands, or to the qeth_ipa_cmd structure
  *				for the IPA commands.
  * @reply_param:		private pointer passed to the callback
@@ -3034,7 +3034,7 @@ static int qeth_send_ipa_cmd_cb(struct qeth_card *card,
 	return (cmd->hdr.return_code) ? -EIO : 0;
 }
 
-/**
+/*
  * qeth_send_ipa_cmd() - send an IPA command
  *
  * See qeth_send_control_data() for explanation of the arguments.
@@ -3776,7 +3776,7 @@ static void qeth_qdio_output_handler(struct ccw_device *ccwdev,
 	qeth_schedule_recovery(card);
 }
 
-/**
+/*
  * Note: Function assumes that we have 4 outbound queues.
  */
 int qeth_get_priority_queue(struct qeth_card *card, struct sk_buff *skb)
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index b68942e86666..48a886f7af62 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -492,7 +492,7 @@ int qeth_l3_setrouting_v6(struct qeth_card *card)
  * IP address takeover related functions
  */
 
-/**
+/*
  * qeth_l3_update_ipato() - Update 'takeover' property, for all NORMAL IPs.
  *
  * Caller must hold ip_lock.
-- 
2.25.1

