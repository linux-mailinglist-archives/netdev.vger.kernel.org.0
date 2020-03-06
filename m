Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0175517B827
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 09:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgCFIN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 03:13:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbgCFINZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 03:13:25 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02689uc4127046
        for <netdev@vger.kernel.org>; Fri, 6 Mar 2020 03:13:25 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yk4jps74y-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 03:13:24 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 6 Mar 2020 08:13:21 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Mar 2020 08:13:18 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0268DHiL40108418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Mar 2020 08:13:17 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68B00A405F;
        Fri,  6 Mar 2020 08:13:17 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F039A4068;
        Fri,  6 Mar 2020 08:13:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Mar 2020 08:13:17 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/2] s390/qeth: remove VNICC callback parameter struct
Date:   Fri,  6 Mar 2020 09:13:11 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306081311.50635-1-jwi@linux.ibm.com>
References: <20200306081311.50635-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20030608-0020-0000-0000-000003B1013F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030608-0021-0000-0000-00002209409F
Message-Id: <20200306081311.50635-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-06_02:2020-03-05,2020-03-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=955
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 clxscore=1015 spamscore=0 suspectscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060057
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After recent cleanups this is just a complicated wrapper around an u32*.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 9972d96820f3..0bf5e7133229 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1567,23 +1567,11 @@ static int qeth_l2_vnicc_makerc(struct qeth_card *card, u16 ipa_rc)
 	return rc;
 }
 
-/* generic VNICC request call back control */
-struct _qeth_l2_vnicc_request_cbctl {
-	struct {
-		union{
-			u32 *sup_cmds;
-			u32 *timeout;
-		};
-	} result;
-};
-
 /* generic VNICC request call back */
 static int qeth_l2_vnicc_request_cb(struct qeth_card *card,
 				    struct qeth_reply *reply,
 				    unsigned long data)
 {
-	struct _qeth_l2_vnicc_request_cbctl *cbctl =
-		(struct _qeth_l2_vnicc_request_cbctl *) reply->param;
 	struct qeth_ipa_cmd *cmd = (struct qeth_ipa_cmd *) data;
 	struct qeth_ipacmd_vnicc *rep = &cmd->data.vnicc;
 	u32 sub_cmd = cmd->data.vnicc.hdr.sub_command;
@@ -1596,9 +1584,9 @@ static int qeth_l2_vnicc_request_cb(struct qeth_card *card,
 	card->options.vnicc.cur_chars = rep->vnicc_cmds.enabled;
 
 	if (sub_cmd == IPA_VNICC_QUERY_CMDS)
-		*cbctl->result.sup_cmds = rep->data.query_cmds.sup_cmds;
+		*(u32 *)reply->param = rep->data.query_cmds.sup_cmds;
 	else if (sub_cmd == IPA_VNICC_GET_TIMEOUT)
-		*cbctl->result.timeout = rep->data.getset_timeout.timeout;
+		*(u32 *)reply->param = rep->data.getset_timeout.timeout;
 
 	return 0;
 }
@@ -1639,7 +1627,6 @@ static int qeth_l2_vnicc_query_chars(struct qeth_card *card)
 static int qeth_l2_vnicc_query_cmds(struct qeth_card *card, u32 vnic_char,
 				    u32 *sup_cmds)
 {
-	struct _qeth_l2_vnicc_request_cbctl cbctl;
 	struct qeth_cmd_buffer *iob;
 
 	QETH_CARD_TEXT(card, 2, "vniccqcm");
@@ -1650,10 +1637,7 @@ static int qeth_l2_vnicc_query_cmds(struct qeth_card *card, u32 vnic_char,
 
 	__ipa_cmd(iob)->data.vnicc.data.query_cmds.vnic_char = vnic_char;
 
-	/* prepare callback control */
-	cbctl.result.sup_cmds = sup_cmds;
-
-	return qeth_send_ipa_cmd(card, iob, qeth_l2_vnicc_request_cb, &cbctl);
+	return qeth_send_ipa_cmd(card, iob, qeth_l2_vnicc_request_cb, sup_cmds);
 }
 
 /* VNICC enable/disable characteristic request */
@@ -1677,7 +1661,6 @@ static int qeth_l2_vnicc_getset_timeout(struct qeth_card *card, u32 vnicc,
 					u32 cmd, u32 *timeout)
 {
 	struct qeth_vnicc_getset_timeout *getset_timeout;
-	struct _qeth_l2_vnicc_request_cbctl cbctl;
 	struct qeth_cmd_buffer *iob;
 
 	QETH_CARD_TEXT(card, 2, "vniccgst");
@@ -1692,11 +1675,7 @@ static int qeth_l2_vnicc_getset_timeout(struct qeth_card *card, u32 vnicc,
 	if (cmd == IPA_VNICC_SET_TIMEOUT)
 		getset_timeout->timeout = *timeout;
 
-	/* prepare callback control */
-	if (cmd == IPA_VNICC_GET_TIMEOUT)
-		cbctl.result.timeout = timeout;
-
-	return qeth_send_ipa_cmd(card, iob, qeth_l2_vnicc_request_cb, &cbctl);
+	return qeth_send_ipa_cmd(card, iob, qeth_l2_vnicc_request_cb, timeout);
 }
 
 /* set current VNICC flag state; called from sysfs store function */
-- 
2.17.1

