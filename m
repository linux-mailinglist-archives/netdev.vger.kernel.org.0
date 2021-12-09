Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639D046EB6C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239951AbhLIPjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:39:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35728 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234492AbhLIPjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 10:39:33 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9FRmIR005017;
        Thu, 9 Dec 2021 15:35:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=tOxvwVBBJYKeBkWLLdqRTh3gpNj9EkW44GL8kpDN4nc=;
 b=BipimZF71I8xhnavwZ7+1iK+3lAdq7NxR5TSlwAZLn/tQdYBiCMGY1U3+Kv3JHC4ZEiH
 6Hk6+ZVD4bT3Xed3ZSHoCjEURkdVktUccJXObf6ObVP10QskgcAas/e7Vo+ZgtMHa9xl
 9hATC/buDiNloxeRS6C256HnnKTG1OC0SD+tkk/91yhWKiRcEYFFRTpq9Q8YS4Gp1FRQ
 Kz/TsRNxZEu7lTEakKmQPtJUjIAyxBm0RfU09Bo//lvOuhAfJ+9okAZXO6hgw4qfglWS
 n80m2JeAHBcAMYz9YFGZIaA3xo+ASCHkFN55kfk6K2mXB58lNiX3CPkutANzdUdDfYkh Zg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cum1qrrhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:35:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9FXwg4025409;
        Thu, 9 Dec 2021 15:35:53 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3cqyyajyp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:35:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9FZolg28115276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 15:35:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D98EAE06E;
        Thu,  9 Dec 2021 15:35:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9DDDAE045;
        Thu,  9 Dec 2021 15:35:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 15:35:49 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH] MAINTAINERS: s390/net: remove myself as maintainer
Date:   Thu,  9 Dec 2021 16:35:46 +0100
Message-Id: <20211209153546.1152921-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: E8QdBocmNiaxo0BzIGQzuyNEnVI8GLGL
X-Proofpoint-GUID: E8QdBocmNiaxo0BzIGQzuyNEnVI8GLGL
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_06,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 mlxlogscore=633 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0 impostorscore=0
 clxscore=1011 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I won't have access to the relevant HW and docs much longer.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e51081b6708..6dd20c31d875 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16623,7 +16623,6 @@ W:	http://www.ibm.com/developerworks/linux/linux390/
 F:	drivers/iommu/s390-iommu.c
 
 S390 IUCV NETWORK LAYER
-M:	Julian Wiedmann <jwi@linux.ibm.com>
 M:	Alexandra Winter <wintera@linux.ibm.com>
 M:	Wenjia Zhang <wenjia@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
@@ -16635,7 +16634,6 @@ F:	include/net/iucv/
 F:	net/iucv/
 
 S390 NETWORK DRIVERS
-M:	Julian Wiedmann <jwi@linux.ibm.com>
 M:	Alexandra Winter <wintera@linux.ibm.com>
 M:	Wenjia Zhang <wenjia@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
-- 
2.32.0

