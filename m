Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A20611BA1
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 22:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJ1Uhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 16:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJ1Uhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 16:37:39 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4033F2347B3
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 13:37:38 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SKSkjI001555;
        Fri, 28 Oct 2022 20:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=a6Ke+InNOb0hHiYxtWxMzvHsUMhQt/dPk02a0Iq0wTE=;
 b=cJhca6Gg6NjFJJGsjIUAoSJuTzAoLiRVkc29ffv/D56Ma1eEzjbUa2WSB1XQ3SV6/VxB
 wyKPiytSN+bqYrx9rxXnj5GPvnOKH8//8HSVIVVDE3lkbzziOCNrq4jOYCYuufZ63IyH
 b4eBL2IFlx5XMizGqjdYOeHxu0YWiqh6eozNc8LbbBk+sH3Fht3uBTVYjY9kmBoIzOaE
 NBAM+QN+ArM73aJD/m/3WrB4g41S4M+Ql2FANZYb7Rg9nN4TiAqFC0m4SqHJV95cByoB
 P4Q8WDfetYm7nGNd0SUFUNj51FTWBrB9Yv8m8ZIszNa3Hf3AbCnLRQldKdg20qqpiuLY +A== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kgp57g7v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Oct 2022 20:37:32 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29SKZLgp024431;
        Fri, 28 Oct 2022 20:37:31 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3kfahyhcnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Oct 2022 20:37:31 +0000
Received: from smtpav05.wdc07v.mail.ibm.com ([9.208.128.117])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29SKbTs58323664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 20:37:30 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BB3A58043;
        Fri, 28 Oct 2022 20:37:29 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91F4A58053;
        Fri, 28 Oct 2022 20:37:27 +0000 (GMT)
Received: from fledgling.ibm.com.com (unknown [9.160.37.48])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 28 Oct 2022 20:37:27 +0000 (GMT)
From:   Rick Lindsley <ricklind@us.ibm.com>
To:     haren@linux.ibm.com, nnac123@linux.ibm.com, danymadden@us.ibm.com,
        tlfalcon@linux.ibm.com, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] Change maintainers for vnic driver
Date:   Fri, 28 Oct 2022 13:35:11 -0700
Message-Id: <20221028203509.4070154-1-ricklind@us.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: l9xRDQwx0DSlI-y0B2msHQY5G87vcuXy
X-Proofpoint-ORIG-GUID: l9xRDQwx0DSlI-y0B2msHQY5G87vcuXy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_10,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 clxscore=1011 mlxlogscore=813 bulkscore=0 impostorscore=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280129
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changed maintainers for vnic driver, since Dany has new responsibilities.
Also added Nick Child as reviewer.

Signed-off-by: Rick Lindsley <ricklind@us.ibm.com>

---
 MAINTAINERS | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 10c1344b4473..d5a5e776febb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9775,7 +9775,10 @@ S:	Supported
 F:	drivers/pci/hotplug/rpaphp*
 
 IBM Power SRIOV Virtual NIC Device Driver
-M:	Dany Madden <drt@linux.ibm.com>
+M:	Haren Myneni <haren@linux.ibm.com>
+M:	Rick Lindsley <ricklind@linux.ibm.com>
+R:	Nick Child <nnac123@linux.ibm.com>
+R:	Dany Madden <danymadden@us.ibm.com>
 R:	Thomas Falcon <tlfalcon@linux.ibm.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-- 
2.31.1

