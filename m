Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EA23AC46B
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 09:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhFRHDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 03:03:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21908 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229816AbhFRHDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 03:03:44 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I6Wkbb151864;
        Fri, 18 Jun 2021 03:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=3Y/QAFCVp/tbF3uU+dnCZ4rNEFIIjcqp7i+8Q9YyBs4=;
 b=WIGmNXfzXqmosz7e9Glp4B0CjWmM/37i7keO4PmnBTIXslq+Tz7Wriv23kssomU3QAj6
 2AfEkojp930BxgESR0sBugn1fC7UMNmAbF0t6nR3Ssq7zElH8kcn0P6wBNOUnivPq5Y0
 5q+JulALFCpD/J0DabFozrY/+P8AApvMrtf9JuMncICvQSl8XtsEFTn9KfKXB9R8lsjq
 sxtci4wJYdq8HMD4Pp3V7hUj5R/NNcw8nkXgQZtMOvqrQjpTIOi9hx32f5jLQhpcWLqn
 TDM1DiQ51RhXLsVInqUXrMM+LSq6foNgQIgLn26tr98UJvm7rO8kqs5v7XZTf+S7slBS TQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 398jmmen8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 03:01:31 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15I6uosA000371;
        Fri, 18 Jun 2021 07:01:29 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 394m6hu4qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 07:01:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15I71QjP33358212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 07:01:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9214942042;
        Fri, 18 Jun 2021 07:01:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 578C14204B;
        Fri, 18 Jun 2021 07:01:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Jun 2021 07:01:26 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Guvenc Gulce <guvenc@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net] MAINTAINERS: add Guvenc as SMC maintainer
Date:   Fri, 18 Jun 2021 09:00:30 +0200
Message-Id: <20210618070030.2326320-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lesYsBQDwGiSUuoYYcFaOkJw88WXzxHp
X-Proofpoint-GUID: lesYsBQDwGiSUuoYYcFaOkJw88WXzxHp
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_17:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxlogscore=833 phishscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106180037
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Guvenc as maintainer for Shared Memory Communications (SMC)
Sockets.

Cc: Julian Wiedmann <jwi@linux.ibm.com>
Acked-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 183cc61e2dc0..5046e55dc7f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16571,6 +16571,7 @@ F:	drivers/misc/sgi-xp/
 
 SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
 M:	Karsten Graul <kgraul@linux.ibm.com>
+M:	Guvenc Gulce <guvenc@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
-- 
2.25.1

