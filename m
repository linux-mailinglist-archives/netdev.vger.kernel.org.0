Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEC4563943
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 20:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiGASmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 14:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiGASmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 14:42:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FCE28723;
        Fri,  1 Jul 2022 11:42:01 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 261ILuWf016936;
        Fri, 1 Jul 2022 18:41:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=1LdrGotNpWAEMNi1KYcWoFPRrX+N02uyi0vtrByAkl4=;
 b=m0p/0fPxnb5fmH2+fv4kxDMK9XDKF9z+9RcchqF5zgLvBuQBwHJOd7R83p0i/FFQ7jF6
 IjlI/P/xyf0g/QrpVhlm3zeyr2CdfVayQZiccU2mS+qgFViqwRWrPY3ad2IIwsPo2vb2
 FgILMg1AhDRYuGPS2GtR1rNk5v2x6gEfghl7JWOU3/RFNiXxwh7XwrdKsnaLPInusAKZ
 xJgklsRFd3tCcWfMZbLmawo4z6sPnjy5COs305HRRTNJxgIyTcYX+IpRddZcCwkdxLZf
 Cg+oRI7Efhzhsc6RH8VPxC5xA836WIFH0aLu4mTX3BwJJTXJkP426UTMl9qH6rhZqocs Ig== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h2650gg09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 18:41:57 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 261Ic9WJ005954;
        Fri, 1 Jul 2022 18:41:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3gwt08yheq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 18:41:55 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 261IfqUD24903958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Jul 2022 18:41:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D6725204F;
        Fri,  1 Jul 2022 18:41:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D94DC5204E;
        Fri,  1 Jul 2022 18:41:51 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net v2] MAINTAINERS: add Wenjia as SMC maintainer
Date:   Fri,  1 Jul 2022 20:41:43 +0200
Message-Id: <20220701184143.1216274-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XATUC9tOQjnMg2T28uUH33dyY5PG6-77
X-Proofpoint-GUID: XATUC9tOQjnMg2T28uUH33dyY5PG6-77
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-01_11,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 phishscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=868
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207010073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Wenjia as maintainer for Shared Memory Communications (SMC)
Sockets.

Acked-by: Wenjia Zhang <wenjia@linux.ibm.com>
Acked-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d4d3f37f64eb..53537b8d2d81 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18104,6 +18104,7 @@ F:	drivers/misc/sgi-xp/
 
 SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
 M:	Karsten Graul <kgraul@linux.ibm.com>
+M:	Wenjia Zhang <wenjia@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
-- 
2.34.1

