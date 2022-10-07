Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2135F7466
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 08:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiJGGzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 02:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJGGzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 02:55:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB56C31DE8;
        Thu,  6 Oct 2022 23:54:59 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29769VtN000863;
        Fri, 7 Oct 2022 06:54:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=+3s0q2l3k+pmPIa6yJMupwL3AFUDNzwzuPb4CD4qF+Y=;
 b=IR1wiBnajJLf4KevyYEZuw8bMBnq4gOapQyVsXf4UFXkrC68bzNpn/9azAR7iuXg9ngT
 588rmaONNRHg7X1kkXHJ6PQDprNhVMFyi7f1VNC4bewfuv00gwrhGRbXdHd/S2TKEaRi
 rv97KULNYlKhTg2zmYRcMwGNIIKDnXUkNqTe/Hrk/VbCd2gw1A4lqtdFcQEJSqCrj9Dh
 nKer7kb/V0Cr8a8Xbb21o+QVhiLaXFiVBWIllthl/ipnj1U3n4V6wkYTyM0Eiq6+WhfF
 GAZLchcxrwAjOSLtiKTap7qXHb87AfdgTi7bT19+2BYXQFtyUJ4e2b12/6rsZo4vUTUA ug== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k2dvdjfhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 06:54:55 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2976nxUI017307;
        Fri, 7 Oct 2022 06:54:53 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3jxd68x1an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 06:54:52 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2976snRB655944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Oct 2022 06:54:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70F9142042;
        Fri,  7 Oct 2022 06:54:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC58C42041;
        Fri,  7 Oct 2022 06:54:45 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.163.62.72])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  7 Oct 2022 06:54:45 +0000 (GMT)
From:   Wenjia Zhang <wenjia@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
Subject: [PATCH] MAINTAINERS: add Jan as SMC maintainer
Date:   Fri,  7 Oct 2022 08:54:36 +0200
Message-Id: <20221007065436.33915-1-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.35.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OGx9crK4XHUs6v6pBOs_OO2fnEOYL3L7
X-Proofpoint-ORIG-GUID: OGx9crK4XHUs6v6pBOs_OO2fnEOYL3L7
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-06_05,2022-10-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 mlxlogscore=831 suspectscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210070039
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Jan as maintainer for Shared Memory Communications (SMC)
Sockets.

Acked-by: Jan Karcher <jaka@linux.ibm.com>
Acked-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9ca84cb5ab4a..b7105db9fe6c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18487,6 +18487,7 @@ F:	drivers/misc/sgi-xp/
 SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
 M:	Karsten Graul <kgraul@linux.ibm.com>
 M:	Wenjia Zhang <wenjia@linux.ibm.com>
+M:	Jan Karcher <jaka@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
-- 
2.35.2

