Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D28414EF2
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbhIVRXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:23:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57404 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236701AbhIVRXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:23:08 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18MH9gnt018529;
        Wed, 22 Sep 2021 13:21:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=GbQtfpd2tsEbXEXXhPYCa3aqqGdu9jYMnwZTtyh2fts=;
 b=EVI/5RMqr4X/XFHgjuf3B3o+9d+XfKu5jfBQw8nv+QPqdcT1B2WlC99YcAwMRB+syV7y
 qswiwP8Cuzvm2MnJsjRwZOSItkAy5Rw04e3odzSkC3kJD9VeVmQzz7UOcqMOq6CtT1Ix
 8OyqU7mDLzfomfezA8+s/EdDXlToawGErtPAOtJIi/dUFU9oxXwcTpAzL7LHiPnCsGBe
 5jTracUWeKW2XBIDI4CCouZreJEB2jqEVEyk1vw0bzjXh/ctyW9aI6y+Y/udYwztNLIj
 Pb0Fmxso/Z4XdY+O4xxjwV0EoRB9YaURUYtAuxl1nzmdh6JMkibl/6IMFN5z+dJWbcij Rw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b87mr1puy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 13:21:35 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18MH1xjp015408;
        Wed, 22 Sep 2021 17:21:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3b7q6r1hqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 17:21:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18MHLT4H57541088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 17:21:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D14E042042;
        Wed, 22 Sep 2021 17:21:29 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75AEB4204B;
        Wed, 22 Sep 2021 17:21:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 17:21:29 +0000 (GMT)
From:   Guvenc Gulce <guvenc@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net] MAINTAINERS: remove Guvenc Gulce as net/smc maintainer
Date:   Wed, 22 Sep 2021 19:21:29 +0200
Message-Id: <20210922172129.773374-1-guvenc@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6gwdX00Fn6_uVr3VJmOeedYyioZTtvr2
X-Proofpoint-ORIG-GUID: 6gwdX00Fn6_uVr3VJmOeedYyioZTtvr2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_06,2021-09-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 phishscore=0 impostorscore=0 mlxlogscore=714 priorityscore=1501
 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109200000
 definitions=main-2109220114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove myself as net/smc maintainer, as I am
leaving IBM soon and can not maintain net/smc anymore.

Cc: Julian Wiedmann <jwi@linux.ibm.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index eeb4c70b3d5b..3c814976443e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16955,7 +16955,6 @@ F:	drivers/misc/sgi-xp/
 
 SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
 M:	Karsten Graul <kgraul@linux.ibm.com>
-M:	Guvenc Gulce <guvenc@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
-- 
2.25.1

