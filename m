Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCC126EF92
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbgIRCgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:36:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15408 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728833AbgIRCMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:12:50 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08I22OAo051705
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 22:12:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=uR9HUMSTAE+HdC7DoB128D5n4S2DQj6D+ZdtK36bs4M=;
 b=c8r65Jq0xi+l7cuKU5hzA8JL0Mm/VVTz+2/ONULQrRK+m9Cn/uX9i+Kw/+tJPqOjPimJ
 hg3elfaSYG+tlS2+yFkFvm5IdEWF4xgTma9ecNQ7rAcrb/RcIc8CYx1w/J0ApuIU9OhT
 b9U6fD5UZHiYMjAMMJBqo9qTFzmfWn+35vO56EgzJ6S7F4etKKAs5UoB50P9637FKyY8
 vhCZmDeH89hEoHTE20rdyW00iHmJb0cReTc6NWfIBq5H+hYbugDnyIt5YWRMfmYFcoBP
 wMMbZngTROMWDSRYkGeIzyG4qrH50RjPPLd442Yt4VYGD4oUm8wEj40DblAWYN5dtmqK nA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33mhv02sy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 22:12:48 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08I2BmIk020040
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 02:12:47 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma05wdc.us.ibm.com with ESMTP id 33k6q18r75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 02:12:47 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08I2ClxW40829376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 02:12:47 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 647D2112062;
        Fri, 18 Sep 2020 02:12:47 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0816B112061;
        Fri, 18 Sep 2020 02:12:47 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.133.140])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 18 Sep 2020 02:12:46 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next] Revert "ibmvnic: remove never executed if statement"
Date:   Thu, 17 Sep 2020 21:12:46 -0500
Message-Id: <20200918021246.22600-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_20:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0 malwarescore=0
 bulkscore=0 clxscore=1015 adultscore=0 suspectscore=1 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180013
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 550f4d46aff6fe57c9b1c6719c3c9de2237d7ac2.

adapter->from_passive_init may be changed in ibmvnic_handle_crq
while ibmvnic_reset_init is waiting for the completion of
adapter->init_done.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index e2a3c4bf00c9..6d320be47e60 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5047,6 +5047,12 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 		return adapter->init_done_rc;
 	}
 
+	if (adapter->from_passive_init) {
+		adapter->state = VNIC_OPEN;
+		adapter->from_passive_init = false;
+		return -1;
+	}
+
 	if (reset &&
 	    test_bit(0, &adapter->resetting) && !adapter->wait_for_reset &&
 	    adapter->reset_reason != VNIC_RESET_MOBILITY) {
-- 
2.23.0

