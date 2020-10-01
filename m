Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A20280509
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732858AbgJARVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:21:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732274AbgJARVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:21:36 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091H3KjD078400;
        Thu, 1 Oct 2020 13:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=3yWLCbkJHiGDQe/MQScLS8xP3ZedKNsWUuK0nz/c9II=;
 b=NLHaOrKEFIkHvj18MzAtRaWPC4WLFfZa/vq9pJ6kBpWPygTIM1F6Pjk2x6ga/ZWgmXr2
 BodAzVUNcTpL98m1UgVo8DQvGx+nuQQQylvvFKCOEy1ldLpWoQnhNhd5AD/a/TYJZ3ng
 jV6jM6Ru3keS1oXbEsybIvz7yWAV0a8gcVqYQZzhGQWcm2Hj4U90pAKXWrmh+16FmnzW
 dnIm30wkY0kt+WYWPiNFJqoe9sxhhqunRoieeaENsC1gPA3Pqu7rYURy0aVWNEBpMrZ8
 7fS4djMktY3npZjdSxu4WOEZoNJDzqPbZuSQ0LbZqgxRdypaL/hW8YnUJtysZbRoyeo1 8Q== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33wk03rthq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 13:21:34 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 091H2Cj1019613;
        Thu, 1 Oct 2020 17:21:32 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 33v6mgtagg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 17:21:32 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 091HLTQN33489280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 17:21:29 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46C92A405C;
        Thu,  1 Oct 2020 17:21:29 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF262A4062;
        Thu,  1 Oct 2020 17:21:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Oct 2020 17:21:28 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/2] net/iucv: fix indentation in __iucv_message_receive()
Date:   Thu,  1 Oct 2020 19:21:27 +0200
Message-Id: <20201001172127.98541-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001172127.98541-1-jwi@linux.ibm.com>
References: <20201001172127.98541-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_06:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 adultscore=0 impostorscore=0 mlxlogscore=576 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smatch complains about
net/iucv/iucv.c:1119 __iucv_message_receive() warn: inconsistent indenting

While touching this line, also make the return logic consistent and thus
get rid of a goto label.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/iucv/iucv.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index cd2e468852e7..349c6ac3313f 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -1116,10 +1116,9 @@ int __iucv_message_receive(struct iucv_path *path, struct iucv_message *msg,
 	if (msg->flags & IUCV_IPRMDATA)
 		return iucv_message_receive_iprmdata(path, msg, flags,
 						     buffer, size, residual);
-	 if (cpumask_empty(&iucv_buffer_cpumask)) {
-		rc = -EIO;
-		goto out;
-	}
+	if (cpumask_empty(&iucv_buffer_cpumask))
+		return -EIO;
+
 	parm = iucv_param[smp_processor_id()];
 	memset(parm, 0, sizeof(union iucv_param));
 	parm->db.ipbfadr1 = (u32)(addr_t) buffer;
@@ -1135,7 +1134,6 @@ int __iucv_message_receive(struct iucv_path *path, struct iucv_message *msg,
 		if (residual)
 			*residual = parm->db.ipbfln1f;
 	}
-out:
 	return rc;
 }
 EXPORT_SYMBOL(__iucv_message_receive);
-- 
2.17.1

