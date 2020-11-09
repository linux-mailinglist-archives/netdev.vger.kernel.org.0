Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C8A2AB1F5
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 08:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgKIH5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 02:57:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43690 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729637AbgKIH5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 02:57:22 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A97WQaK021940;
        Mon, 9 Nov 2020 02:57:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=ByslKY+TUoIKeS/20S/+taNqE9BvCXY0yA7lhOi9uZs=;
 b=GcUQxjuPrf/GYdlGHoPeQJUGFMXqLVigQQ/1Nz//pAh9c0koQz1MvxnhSzwAvoEucyIl
 FeoRo1FvXWdSNGaVuskDf50UgZkbsqjiBj+X46HmITZZiENmavKSnRi7IpJcNQlNMX1D
 lZIh+U2TNuZ/ekvhgnu/qgYV4R4sYsBIoTg1ZjThzF7e4ddGJ4Ieft9h2QOF03MjkObS
 mzLX2qkKQMv/sWnsqdd6ZEOeCPxxoWwRmoEouwUKtvhgUYZdIOk6PjILWBmnFsCfkGQc
 5UQWt/QbgkRq3Bbs0G9GZJevnSBXZIC9bE63NChMeCzK6kKi1ZEeWd90faalTRCWKzDP yQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34p9kcssep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 02:57:19 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A97sCEU010164;
        Mon, 9 Nov 2020 07:57:17 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 34q08401bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 07:57:17 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A97vEbZ60293430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Nov 2020 07:57:14 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43A26A4057;
        Mon,  9 Nov 2020 07:57:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0858A4040;
        Mon,  9 Nov 2020 07:57:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Nov 2020 07:57:13 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
Subject: [PATCH net v2 2/2] MAINTAINERS: remove Ursula Braun as s390 network maintainer
Date:   Mon,  9 Nov 2020 08:57:06 +0100
Message-Id: <20201109075706.56573-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201109075706.56573-1-jwi@linux.ibm.com>
References: <20201109075706.56573-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_02:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=762 bulkscore=0 suspectscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011090042
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
index cd123d0a6a2d..fa11fe773df5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15246,7 +15246,6 @@ F:	drivers/iommu/s390-iommu.c
 S390 IUCV NETWORK LAYER
 M:	Julian Wiedmann <jwi@linux.ibm.com>
 M:	Karsten Graul <kgraul@linux.ibm.com>
-M:	Ursula Braun <ubraun@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
@@ -15257,7 +15256,6 @@ F:	net/iucv/
 S390 NETWORK DRIVERS
 M:	Julian Wiedmann <jwi@linux.ibm.com>
 M:	Karsten Graul <kgraul@linux.ibm.com>
-M:	Ursula Braun <ubraun@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
@@ -15828,7 +15826,6 @@ S:	Maintained
 F:	drivers/misc/sgi-xp/
 
 SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
-M:	Ursula Braun <ubraun@linux.ibm.com>
 M:	Karsten Graul <kgraul@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
-- 
2.17.1

