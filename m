Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8B91DA0AB
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgESTKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:10:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727046AbgESTKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:10:23 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04JJ2uB1156790;
        Tue, 19 May 2020 15:10:21 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312age0fxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 15:10:21 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04JJ6WoH009712;
        Tue, 19 May 2020 19:10:19 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 313xehj6r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 19:10:19 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04JJAGff58458440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 19:10:16 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1D53A405D;
        Tue, 19 May 2020 19:10:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 808DFA4057;
        Tue, 19 May 2020 19:10:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 May 2020 19:10:16 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/5] net/af_iucv: remove a redundant zero initialization
Date:   Tue, 19 May 2020 21:10:11 +0200
Message-Id: <20200519191012.65438-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200519191012.65438-1-jwi@linux.ibm.com>
References: <20200519191012.65438-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-19_08:2020-05-19,2020-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=955 clxscore=1015 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 cotscore=-2147483648
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

txmsg is declared as {0}, no need to clear individual fields later on.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/iucv/af_iucv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index b02470a04c50..799dcf5483de 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -996,7 +996,6 @@ static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	/* initialize defaults */
 	cmsg_done   = 0;	/* check for duplicate headers */
-	txmsg.class = 0;
 
 	/* iterate over control messages */
 	for_each_cmsghdr(cmsg, msg) {
-- 
2.17.1

