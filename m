Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63441588FD7
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238090AbiHCPza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238259AbiHCPzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:55:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933FB5B06A
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 08:53:16 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273Fqkuo014991;
        Wed, 3 Aug 2022 15:53:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=nFLxJdw68knP+xDHSTMHp1gX78qdPaKMkNrvKqC85J4=;
 b=LlVv49fU2eZXMBaQvQo2U6u1T7g+cHoolAXu3fbJyToC+0vKUiFYTsXi5AS8BGLltZa6
 QuV/W0IBajEKS6su2jWDDPLWeJohVjEFZDikPKfvNH6bcIdvatVoHA1FxctwmpTg3X4x
 LJq07e27YHMdwuANEyWqT0ApsCdLRyMoc5rs95mSGghR1p9NAXQm2d6AmDZrKz09fHR0
 mO4eOiwTIKSUg1Pw8R38KlLjCTDM4dWip+FAyXfPdlWZlLymnHWcqPRMxg9YoaHFSeRS
 BN/uyko5s6aQnB3y61J7NsgWOHXeKs2ZhF76PsNwYRAN7c+VUnHrHkugChhqkUaLhSNj xg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqv22r0g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 15:53:11 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 273FqiNT019165;
        Wed, 3 Aug 2022 15:53:10 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 3hq6hyqrm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 15:53:10 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 273Fr9Mf3015206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Aug 2022 15:53:09 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4549AE060;
        Wed,  3 Aug 2022 15:53:09 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D98FAE062;
        Wed,  3 Aug 2022 15:53:09 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.211.111.3])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  3 Aug 2022 15:53:09 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH] MAINTAINERS: Update ibmveth maintainer
Date:   Wed,  3 Aug 2022 10:52:46 -0500
Message-Id: <20220803155246.39582-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DxLmRFzHwh2aetaNEw4qVmwLUexojgq7
X-Proofpoint-ORIG-GUID: DxLmRFzHwh2aetaNEw4qVmwLUexojgq7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=776 bulkscore=0 spamscore=0
 clxscore=1011 phishscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Nick Child as the maintainer of the IBM Power Virtual Ethernet
Device Driver, replacing Cristobal Forno.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2cfda104ba4e..4686e505b8e0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9555,7 +9555,7 @@ F:	arch/powerpc/platforms/powernv/copy-paste.h
 F:	arch/powerpc/platforms/powernv/vas*
 
 IBM Power Virtual Ethernet Device Driver
-M:	Cristobal Forno <cforno12@linux.ibm.com>
+M:	Nick Child <nnac123@linux.ibm.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/ibm/ibmveth.*
-- 
2.27.0

