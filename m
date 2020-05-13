Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6EB1D0A05
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 09:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbgEMHmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 03:42:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729681AbgEMHmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 03:42:45 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04D7VWTY190265;
        Wed, 13 May 2020 03:42:38 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3101m70yg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 03:42:38 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04D7eUos018653;
        Wed, 13 May 2020 07:42:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3100ub12s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 07:42:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04D7fMxX60293612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 07:41:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B22411C050;
        Wed, 13 May 2020 07:42:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C4DF11C058;
        Wed, 13 May 2020 07:42:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 May 2020 07:42:33 +0000 (GMT)
From:   Ursula Braun <ubraun@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, kgraul@linux.ibm.com,
        weiyongjun1@huawei.com, ubraun@linux.ibm.com
Subject: [PATCH net 2/2] MAINTAINERS: add Karsten Graul as S390 NETWORK DRIVERS maintainer
Date:   Wed, 13 May 2020 09:42:30 +0200
Message-Id: <20200513074230.967-3-ubraun@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200513074230.967-1-ubraun@linux.ibm.com>
References: <20200513074230.967-1-ubraun@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_02:2020-05-11,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=1 spamscore=0 cotscore=-2147483648
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=570 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130065
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Karsten as additional maintainer for drivers/s390/net .
One of his focal points is the ism driver.

Cc: Julian Wiedmann <jwi@linux.ibm.com>
Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 88bf36ab2b22..85894787825e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14644,6 +14644,7 @@ F:	drivers/iommu/s390-iommu.c
 
 S390 IUCV NETWORK LAYER
 M:	Julian Wiedmann <jwi@linux.ibm.com>
+M:	Karsten Graul <kgraul@linux.ibm.com>
 M:	Ursula Braun <ubraun@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
-- 
2.17.1

