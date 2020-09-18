Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70382270453
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIRSsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:48:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726205AbgIRSsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:48:00 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08IIf0On008857
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 14:47:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=LSyd8pAu5u6unQzs2Lnv7DtEQ15Q6DQx2UUYYpxpY0M=;
 b=p2F7yfZxJE3AXvcz4mTKdvbc5pLgFarJaVcsY+plFjdgEQ//zMVkdK0xDAfDCgwWETSl
 HGf4SnSM9DCrsXAfvyRFeCXFgRV5ebtOhwgvOKzK0st4yLi5DAqO7hiJ/H2oC934hNRx
 f8z3E6ZRH89Jm1SfbQ+SSI0/s8Cpa+/O6wVrxUEsV4YeI9TFZHl1dN6BfvZMUZ9R0qiB
 mD2lgwvYI7jIQN9VsjAIzQ1TtwwgO5JOntxl+SnW8PdHApsw+0MwLCYsuP+T95RKrXFD
 tLiSPXYIOYKqEA7OZlQC1N5BP5Wi2QBwZYaDwZUCFRmvy049e6mimoRAeQVpJRcHVU2B VQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33n28n8cpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 14:47:59 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08IIlWtT013650
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 18:47:58 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 33k5wcxapf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 18:47:58 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08IIlvam38994220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 18:47:57 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 384366A054;
        Fri, 18 Sep 2020 18:47:57 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6D716A04D;
        Fri, 18 Sep 2020 18:47:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.65.231.127])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 18 Sep 2020 18:47:56 +0000 (GMT)
From:   Cristobal Forno <cforno12@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Cristobal Forno <cforno12@linux.ibm.com>
Subject: [PATCH] MAINTAINERS: Update ibmveth maintainer
Date:   Fri, 18 Sep 2020 13:47:43 -0500
Message-Id: <20200918184743.80406-1-cforno12@linux.ibm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-18_16:2020-09-16,2020-09-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=1 mlxlogscore=608 adultscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180148
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removed Thomas Falcon. Added myself (Cristobal Forno) as the maintainer of ibmveth.

Signed-off-by: Cristobal Forno <cforno12@linux.ibm.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d746519253c3..db6ca1364b88 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8344,7 +8344,7 @@ F:	arch/powerpc/platforms/powernv/copy-paste.h
 F:	arch/powerpc/platforms/powernv/vas*
 
 IBM Power Virtual Ethernet Device Driver
-M:	Thomas Falcon <tlfalcon@linux.ibm.com>
+M:	Cristobal Forno <cforno12@linux.ibm.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/ibm/ibmveth.*
-- 
2.28.0

