Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F42364D04
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 23:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhDSV0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 17:26:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15802 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230033AbhDSVZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 17:25:59 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13JL3FNT142737
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 17:25:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=NdwRBypMgaU/5xIv6Gupy9n2e8w3/fVNvLw+uSYkum0=;
 b=JRyYViQ1lRUT9CWyBBfX+L0ge/+iEWwOy3Hl/atZRSWM+3z5uwv/y4or8nC9KOGW/DcS
 6hI4NpJq+wYC+abxbeb/WroKzSzwV/yuIKT9WTm3Hp0P2xbsyS0VCw+FuJaR8sV36JKd
 4Wa/4033k/cpAHALr21ckq43ImVPAnodMkMSe9GhjnLjU5irUpOzBfvTFxzE1eOPg3Tz
 CYqXjVwF8YKrm3csdmGX2cjFFNmep3nCwltwbUZvxv6vch/JmAlCar8ZyqzfCTET+NbE
 oztwoNdH7RaPI1Z3pYwtWrIcyPVJaHLhXoPbmiXNTCNdQD0sekaTNgiKG4UJGe2nfkSU cQ== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 380ck6qkx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 17:25:29 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13JLBO5F020531
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 21:25:28 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma03dal.us.ibm.com with ESMTP id 37yqaa27kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 21:25:28 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13JLPQvo32571866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Apr 2021 21:25:26 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B34CD7805C;
        Mon, 19 Apr 2021 21:25:26 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46E057805F;
        Mon, 19 Apr 2021 21:25:26 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.80.206.123])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 19 Apr 2021 21:25:26 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net] MAINTAINERS: update
Date:   Mon, 19 Apr 2021 16:25:25 -0500
Message-Id: <20210419212525.12894-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Mj2pJxjRFCyydcB8r_mmX0MgR68mZQZl
X-Proofpoint-ORIG-GUID: Mj2pJxjRFCyydcB8r_mmX0MgR68mZQZl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-19_11:2021-04-19,2021-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=890 adultscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1011 bulkscore=0 mlxscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104190145
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am making this change again since I received the following instruction.

"As an IBM employee, you are not allowed to use your gmail account to work
in any way on VNIC. You are not allowed to use your personal email account
as a "hobby". You are an IBM employee 100% of the time.
Please remove yourself completely from the maintainers file.
I grant you a 1 time exception on contributions to VNIC to make this
change."

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 95e6766718b0..933a6f3c2369 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8526,7 +8526,6 @@ IBM Power SRIOV Virtual NIC Device Driver
 M:	Dany Madden <drt@linux.ibm.com>
 M:	Sukadev Bhattiprolu <sukadev@linux.ibm.com>
 R:	Thomas Falcon <tlfalcon@linux.ibm.com>
-R:	Lijun Pan <lijunp213@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/ibm/ibmvnic.*
-- 
2.23.0

