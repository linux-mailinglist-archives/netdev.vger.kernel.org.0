Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003F43396DA
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 19:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhCLSpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 13:45:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233962AbhCLSpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 13:45:35 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CIXQEj063339
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 13:45:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Cmx/80GclWPESQwu9gO+Jwee57BaijdNP/T3Lg+g5Yo=;
 b=ATtKPmpV+O1xCROXFw6iglJUwvCYNcSUVidZNICrkiZmz/jMbzoJDOLkAqWb7C0wtEC2
 JV8QRBFsefjFxcg/oB+XW3ERA9xZZAMl10yaL1AKLt8ism58BWKCRpGBJ+JuYppFN3O+
 Ssmm1RD3C0ovM3ss8W/FnHMATafI8noct06GRMDT406h8sFLXuFIxqLYfTozETwjTHdt
 eRdEElZpw3eOXQT7fJHpmrNyuzNq/GkeIuJK56L3eXfuGQl/8RyBPND9fxqWPJaZXYME
 BqCK/a9CwuMd4kqx4crrty6xzstdOSnrMRsIpxE61anZir6843HGzgPVqG/oqcOm1sZP Pg== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 378an95u2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 13:45:34 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12CIRPbe032621
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 18:45:34 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 3768mhhmkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 18:45:33 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12CIjWEi31392218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 18:45:32 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6238A6A058;
        Fri, 12 Mar 2021 18:45:32 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2E506A04D;
        Fri, 12 Mar 2021 18:45:31 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.135.179])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 12 Mar 2021 18:45:31 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     tlfalcon@linux.ibm.com, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net] ibmvnic: update MAINTAINERS
Date:   Fri, 12 Mar 2021 12:45:30 -0600
Message-Id: <20210312184530.14962-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_06:2021-03-12,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom wrote most of the driver code and his experience is valuable to us.
Add him as a Reviewer so that patches will be Cc'ed and reviewed by him.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 47ae27ff6b4b..5a40554b2948 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8496,6 +8496,7 @@ IBM Power SRIOV Virtual NIC Device Driver
 M:	Dany Madden <drt@linux.ibm.com>
 M:	Lijun Pan <ljp@linux.ibm.com>
 M:	Sukadev Bhattiprolu <sukadev@linux.ibm.com>
+R:	Thomas Falcon <tlfalcon@linux.ibm.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/ibm/ibmvnic.*
-- 
2.23.0

