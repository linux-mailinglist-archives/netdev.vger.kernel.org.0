Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EC51C8E4B
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgEGOYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:24:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64364 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbgEGOYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:24:33 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 047E2H67179639;
        Thu, 7 May 2020 10:24:32 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30u8t85phd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 10:24:31 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 047EJjAM022373;
        Thu, 7 May 2020 14:24:29 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 30s0g5mncn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 14:24:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 047EOQkj54526154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 May 2020 14:24:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 702B1A4064;
        Thu,  7 May 2020 14:24:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E282A4054;
        Thu,  7 May 2020 14:24:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 May 2020 14:24:26 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next] net/smc: remove set but not used variables 'del_llc, del_llc_resp'
Date:   Thu,  7 May 2020 16:24:06 +0200
Message-Id: <20200507142406.14638-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_08:2020-05-07,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 suspectscore=1 bulkscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 priorityscore=1501 phishscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fixes gcc '-Wunused-but-set-variable' warning:

net/smc/smc_llc.c: In function 'smc_llc_cli_conf_link':
net/smc/smc_llc.c:753:31: warning:
 variable 'del_llc' set but not used [-Wunused-but-set-variable]
  struct smc_llc_msg_del_link *del_llc;
                               ^
net/smc/smc_llc.c: In function 'smc_llc_process_srv_delete_link':
net/smc/smc_llc.c:1311:33: warning:
 variable 'del_llc_resp' set but not used [-Wunused-but-set-variable]
    struct smc_llc_msg_del_link *del_llc_resp;
                                 ^

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_llc.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 4cc583678ac7..391237b601fe 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -750,7 +750,6 @@ static int smc_llc_cli_conf_link(struct smc_link *link,
 				 enum smc_lgr_type lgr_new_t)
 {
 	struct smc_link_group *lgr = link->lgr;
-	struct smc_llc_msg_del_link *del_llc;
 	struct smc_llc_qentry *qentry = NULL;
 	int rc = 0;
 
@@ -764,7 +763,6 @@ static int smc_llc_cli_conf_link(struct smc_link *link,
 	}
 	if (qentry->msg.raw.hdr.common.type != SMC_LLC_CONFIRM_LINK) {
 		/* received DELETE_LINK instead */
-		del_llc = &qentry->msg.delete_link;
 		qentry->msg.raw.hdr.flags |= SMC_LLC_FLAG_RESP;
 		smc_llc_send_message(link, &qentry->msg);
 		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
@@ -1308,16 +1306,12 @@ static void smc_llc_process_srv_delete_link(struct smc_link_group *lgr)
 		 * enqueued DELETE_LINK request (forward it)
 		 */
 		if (!smc_llc_send_message(lnk, &qentry->msg)) {
-			struct smc_llc_msg_del_link *del_llc_resp;
 			struct smc_llc_qentry *qentry2;
 
 			qentry2 = smc_llc_wait(lgr, lnk, SMC_LLC_WAIT_TIME,
 					       SMC_LLC_DELETE_LINK);
-			if (!qentry2) {
-			} else {
-				del_llc_resp = &qentry2->msg.delete_link;
+			if (qentry2)
 				smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
-			}
 		}
 	}
 	smcr_link_clear(lnk_del, true);
-- 
2.17.1

