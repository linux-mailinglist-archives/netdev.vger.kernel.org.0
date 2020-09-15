Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE33E269A7A
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 02:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgIOAgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 20:36:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725997AbgIOAgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 20:36:54 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08F0VRxw105841;
        Mon, 14 Sep 2020 20:36:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=BxLsjVda+7HYLveHXJd4jo821tGRHm8VY+B8ytp0LAM=;
 b=NKjD5SSF6JT1jH8w/eJEM0rjbey3CArmuFCe6aTbKH75CZIMkQqdn0ElAxqkQa/J1TGq
 4V9B4NYRVspezdzfh/QWcGzV5n+UdvPDzfZj/epYczDUP9cJyiv2vtjaVYqJF4KNtu9c
 WE+x28boFtV/jjkHZs2hBXxNn0KQpxjQYlFiGUCnAOqL2cgNkcZMzPsAVA3Ti6yIBsTv
 wdIyEtzUbkHxE01cDr6hE0/GiR4wbdHihgA53p/XhfCGQdQ++rojXvb4cKAgpD3B1pwK
 bii6mlSty06w/y6uVLTlYazrfdKPTw/FCLuVmBK7uWrX7e1AVwbL/tfYq2E9U+LI7SkI XQ== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jjv38e53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 20:36:48 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08F0SWvO030792;
        Tue, 15 Sep 2020 00:36:47 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 33gny98k0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 00:36:47 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08F0agpJ26411328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 00:36:42 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 256C013604F;
        Tue, 15 Sep 2020 00:36:46 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6EF1136053;
        Tue, 15 Sep 2020 00:36:45 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 15 Sep 2020 00:36:45 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Dany Madden <drt@linux.ibm.com>
Subject: [PATCH net] ibmvnic: update MAINTAINERS
Date:   Mon, 14 Sep 2020 20:35:35 -0400
Message-Id: <20200915003535.819585-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_09:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1011 priorityscore=1501 bulkscore=0 spamscore=0 mlxlogscore=825
 impostorscore=0 suspectscore=1 malwarescore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140184
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update supporters for IBM Power SRIOV Virtual NIC Device Driver. 
Thomas Falcon is moving on to other works. Dany Madden, Lijun Pan 
and Sukadev Bhattiprolu are the current supporters.

Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2783a5f68d2c..923c69ad4eec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8315,7 +8315,9 @@ S:	Supported
 F:	drivers/pci/hotplug/rpaphp*
 
 IBM Power SRIOV Virtual NIC Device Driver
-M:	Thomas Falcon <tlfalcon@linux.ibm.com>
+M:	Dany Madden <drt@linux.ibm.com>
+M:	Lijun Pan <ljp@linux.ibm.com>
+M:	Sukadev Bhattiprolu <sukadev@linux.ibm.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/ibm/ibmvnic.*
-- 
2.18.2

