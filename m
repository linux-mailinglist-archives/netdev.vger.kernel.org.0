Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2680462D92
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 08:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239075AbhK3Hhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 02:37:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239069AbhK3Hhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 02:37:38 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AU7GKQx009070;
        Tue, 30 Nov 2021 07:34:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Ww8Rnk+fot3c4uZLcLIZn+HHxiZKFeiggFSY8l+uUI8=;
 b=VErYkslgh2nMPb7OUmnpjLsMKpNNp60zXyX77qP2VgGCNHwEL98w3Q56kuLD5S5E48P8
 Bb0b76gPxV4DSTc5kXS+5V5bSSAZ8mTASA5RPboVsDenwmdp/h+E6Z3g5Iqf9z1g89QQ
 0D2Zh+X+i2fXM6jV3Hw68EjBB9/Xgb+VApb+5JU9WR4fRRnk4VwKyQzWUjKb0spADu+S
 b9jeEzIhX0RE3wmoXQiSnsXg4MAA8ahUdqqGD9EnpQD0fzLP6Yp8O8a/hjrqWiF5ElEC
 asEtrDLVf4ZLmdzh/HuEVVuiYglk1W5pZw/xEA5wOMgHbWAz1Wl16IdjDMCOPW0OA3aO Fw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cnfe0ganu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 07:34:16 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AU7SUQF016905;
        Tue, 30 Nov 2021 07:34:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ckca9bjh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 07:34:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AU7Qid136569490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 07:26:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D8F74C05A;
        Tue, 30 Nov 2021 07:34:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCD644C064;
        Tue, 30 Nov 2021 07:34:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Nov 2021 07:34:10 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net] MAINTAINERS: s390/net: add Alexandra and Wenjia as maintainer
Date:   Tue, 30 Nov 2021 08:33:58 +0100
Message-Id: <20211130073358.4079471-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kpJdd5cwmL461rBVoh5S5AIBU8Hk3D2_
X-Proofpoint-ORIG-GUID: kpJdd5cwmL461rBVoh5S5AIBU8Hk3D2_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_05,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=633 malwarescore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111300040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Alexandra and Wenjia as maintainers for drivers/s390/net and iucv.
Also, remove myself as maintainer for these areas.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Acked-by: Alexandra Winter <wintera@linux.ibm.com>
Acked-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 MAINTAINERS | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 360e9aa0205d..43d8fac7fb7c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16623,7 +16623,8 @@ F:	drivers/iommu/s390-iommu.c
 
 S390 IUCV NETWORK LAYER
 M:	Julian Wiedmann <jwi@linux.ibm.com>
-M:	Karsten Graul <kgraul@linux.ibm.com>
+M:	Alexandra Winter <wintera@linux.ibm.com>
+M:	Wenjia Zhang <wenjia@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 L:	netdev@vger.kernel.org
 S:	Supported
@@ -16634,7 +16635,8 @@ F:	net/iucv/
 
 S390 NETWORK DRIVERS
 M:	Julian Wiedmann <jwi@linux.ibm.com>
-M:	Karsten Graul <kgraul@linux.ibm.com>
+M:	Alexandra Winter <wintera@linux.ibm.com>
+M:	Wenjia Zhang <wenjia@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 L:	netdev@vger.kernel.org
 S:	Supported
-- 
2.32.0

