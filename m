Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4988E38C814
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhEUNax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:30:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234235AbhEUNaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 09:30:46 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LDMnAg129094;
        Fri, 21 May 2021 09:29:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=qbyLSEYxo2Punq/yUmuYxrOa5tjum0XaNxmcY8b1kuE=;
 b=JvkNwQlDVciNu1YieagyjI1rbmChdtQT/5FwACSpAhcHSBATSBxvMwvZ3kv4poyBmQIb
 VkjB3FYCyr05i0U+M37F09hY3kafHuCPp6b8K4w0dSKrCygQQ5jPzuiiJQmX27PDUqvm
 sZ4IuYmICKiebPme3sVcE2hEnE13lbnfgcKcS2VFaptCtdUOlVQngdv/jCSSlwhUnKuG
 uErbbfq6GyHLDaJ+cKtFSF/h8zprg/MGcqwr5+ohQJVnq1KXRzy9O8c+Dweu+erKz8w3
 PL8fUFJWNAxVHtTQf8nAgdVz/dKdEAhxolVZhM5onkptUPC0hz1zMq+ED9d8yNlB74Jb AQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38pdpsr44b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 09:29:19 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14LDSkCH031653;
        Fri, 21 May 2021 13:29:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 38j5x7u5uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 13:29:17 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14LDTEx729557180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 13:29:14 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 449F842047;
        Fri, 21 May 2021 13:29:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F04DE4204B;
        Fri, 21 May 2021 13:29:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 May 2021 13:29:13 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] MAINTAINERS: s390/net: add netdev list
Date:   Fri, 21 May 2021 15:28:56 +0200
Message-Id: <20210521132856.1573533-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XXimO-eE9j9LHoGF5cy1zlAMOpeMVLx_
X-Proofpoint-GUID: XXimO-eE9j9LHoGF5cy1zlAMOpeMVLx_
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-21_04:2021-05-20,2021-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 mlxlogscore=703 clxscore=1011
 adultscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210077
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Discussions for network-related code should include the netdev list.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c1cb2e38ae2e..88722efd94a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15944,6 +15944,7 @@ S390 IUCV NETWORK LAYER
 M:	Julian Wiedmann <jwi@linux.ibm.com>
 M:	Karsten Graul <kgraul@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
+L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
 F:	drivers/s390/net/*iucv*
@@ -15954,6 +15955,7 @@ S390 NETWORK DRIVERS
 M:	Julian Wiedmann <jwi@linux.ibm.com>
 M:	Karsten Graul <kgraul@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
+L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
 F:	drivers/s390/net/
-- 
2.25.1

