Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A06C2A9671
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 13:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgKFMuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 07:50:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31636 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727258AbgKFMuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 07:50:20 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6CWNPH167691;
        Fri, 6 Nov 2020 07:50:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=s5tgr6K5eJosaeBuZ5BF4PrqR+Rsk4mT8Q9l7QcUGjE=;
 b=TDIQ9cZqLuFSAjJ6QSf8K7H85g+QRH965O20L0b6XekjxRwynY+kDjsNnOEwnR3CnUHW
 6+fuWk7umhXmtXp9W+cY9WGRdslDyLQtw2Efpi/IpK60TvjXdmj153fpfw+BwOEMoAJb
 lGwWSEYL/nXgfOj96b7e1DZhBysRZtE2F9dqfnJTLaRlsJeEHHALLDhB0B5guj8e+WKu
 Fh6xxP/ZQox49jfHdPCZ6xSQ5n2PJoJQzEas0BlPzhoLH4gkTcLCJcT5XSr48JC5kDv2
 HIlxYihFCB13WVh4udzzrAlAMIRUW0JCZ6A+WAci7jUCzHkRrEYHmBdZj0NRe26p1N6K 2w== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34mhywfa7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 07:50:16 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A6CVg91009630;
        Fri, 6 Nov 2020 12:50:14 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 34h0f6uba1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 12:50:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A6CoBHx8782352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Nov 2020 12:50:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C166A4054;
        Fri,  6 Nov 2020 12:50:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18EFAA405C;
        Fri,  6 Nov 2020 12:50:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Nov 2020 12:50:11 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
Subject: [PATCH net 2/2] MAINTAINERS: remove Ursula Braun as s390 network maintainer
Date:   Fri,  6 Nov 2020 13:50:08 +0100
Message-Id: <20201106125008.36478-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106125008.36478-1-jwi@linux.ibm.com>
References: <20201106125008.36478-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_04:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=750 suspectscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

I am retiring soon. Thus this patch removes myself from the
MAINTAINERS file (s390 network).

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
[jwi: fix up the subject]
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 MAINTAINERS | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e73636b75f29..d4462d7e2077 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15259,7 +15259,6 @@ F:	drivers/iommu/s390-iommu.c
 S390 IUCV NETWORK LAYER
 M:	Julian Wiedmann <jwi@linux.ibm.com>
 M:	Karsten Graul <kgraul@linux.ibm.com>
-M:	Ursula Braun <ubraun@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
@@ -15270,7 +15269,6 @@ F:	net/iucv/
 S390 NETWORK DRIVERS
 M:	Julian Wiedmann <jwi@linux.ibm.com>
 M:	Karsten Graul <kgraul@linux.ibm.com>
-M:	Ursula Braun <ubraun@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
@@ -15844,7 +15842,6 @@ S:	Maintained
 F:	drivers/misc/sgi-xp/
 
 SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
-M:	Ursula Braun <ubraun@linux.ibm.com>
 M:	Karsten Graul <kgraul@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
-- 
2.17.1

