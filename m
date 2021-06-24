Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E709E3B261A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 06:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhFXEST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 00:18:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230062AbhFXEQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 00:16:15 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O42ncO056753
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MvRM0bmNm8mAUbTF96qQ97Pk6bEYy4zn9ku7T5IAd1E=;
 b=UiP71dsRGLbeirc/gAyoThPq4N0mU/dgDt5vNW3dsFerSUtt31NlXAg+LEVXPT/8VUCS
 yzM3X9XKxh3xN+vWjL4V4DS5g79NdDGzbbeiw8kfySnJNAZAT4mcOWi9j6ySGywLfb6F
 Aw+wrtsqbszzxS5Fm2c2bOsJkOg4UiZ5w9r0MoZ3o2kyEYFXhzFXIzeRRDptK0tDgWxd
 q4VSqDRlnJTep+XPBSc8g7tk5tVD2Bcx3m1woY8RwqmW9eI2x5on+C7IST/aH0IFVFvq
 VDVawtMjSvu/F47LHLA2mA1mnv1ikHE++XExOXnmloppBwWoLeniGG0aWIlJBaJ21K0B /w== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39cj3ah33h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:29 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15O48r9P022348
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:28 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 39bds22u05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:28 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15O4DR2v7799252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 04:13:27 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51C2F6A04F;
        Thu, 24 Jun 2021 04:13:27 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E8B66A04D;
        Thu, 24 Jun 2021 04:13:26 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.145.253])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 04:13:26 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com,
        Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com
Subject: [PATCH net 7/7] ibmvnic: parenthesize a check
Date:   Wed, 23 Jun 2021 21:13:16 -0700
Message-Id: <20210624041316.567622-8-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624041316.567622-1-sukadev@linux.ibm.com>
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P2mTNblo3Hk9A_J8fhUXAyBgEp7LlI8O
X-Proofpoint-ORIG-GUID: P2mTNblo3Hk9A_J8fhUXAyBgEp7LlI8O
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_14:2021-06-23,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 mlxlogscore=786 lowpriorityscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parenthesize a check to be more explicit and to fix a sparse warning
seen on some distros.

Fixes: 91dc5d2553fbf ("ibmvnic: fix miscellaneous checks")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 363a5d5503ad..697b9714fc76 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3367,7 +3367,7 @@ static int enable_scrq_irq(struct ibmvnic_adapter *adapter,
 		/* H_EOI would fail with rc = H_FUNCTION when running
 		 * in XIVE mode which is expected, but not an error.
 		 */
-		if (rc && rc != H_FUNCTION)
+		if (rc && (rc != H_FUNCTION))
 			dev_err(dev, "H_EOI FAILED irq 0x%llx. rc=%ld\n",
 				val, rc);
 	}
-- 
2.31.1

