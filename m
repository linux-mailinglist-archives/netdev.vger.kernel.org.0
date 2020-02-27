Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 129EE172499
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgB0RI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:08:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54578 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729761AbgB0RI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:08:28 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01RH6RqQ043940
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 12:08:27 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydcp68scy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 12:08:27 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Feb 2020 17:08:25 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Feb 2020 17:08:24 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01RH8MnA51314776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 17:08:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D361A4060;
        Thu, 27 Feb 2020 17:08:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A9F3A405B;
        Thu, 27 Feb 2020 17:08:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 17:08:22 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 1/8] s390/qeth: remove dead code in qeth_l3_iqd_read_initial_mac()
Date:   Thu, 27 Feb 2020 18:08:09 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200227170816.101286-1-jwi@linux.ibm.com>
References: <20200227170816.101286-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20022717-0020-0000-0000-000003AE3353
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022717-0021-0000-0000-0000220653A4
Message-Id: <20200227170816.101286-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_05:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 adultscore=0 bulkscore=0 mlxscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

card->info.unique_id is always 0 for IQD devices, so don't bother with
copying it into the 0-initialized cmd.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 317d56647a4a..1c953981f73f 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -930,7 +930,6 @@ static int qeth_l3_iqd_read_initial_mac(struct qeth_card *card)
 {
 	int rc = 0;
 	struct qeth_cmd_buffer *iob;
-	struct qeth_ipa_cmd *cmd;
 
 	QETH_CARD_TEXT(card, 2, "hsrmac");
 
@@ -938,9 +937,6 @@ static int qeth_l3_iqd_read_initial_mac(struct qeth_card *card)
 				 IPA_DATA_SIZEOF(create_destroy_addr));
 	if (!iob)
 		return -ENOMEM;
-	cmd = __ipa_cmd(iob);
-	*((__u16 *) &cmd->data.create_destroy_addr.unique_id[6]) =
-			card->info.unique_id;
 
 	rc = qeth_send_ipa_cmd(card, iob, qeth_l3_iqd_read_initial_mac_cb,
 				NULL);
-- 
2.17.1

