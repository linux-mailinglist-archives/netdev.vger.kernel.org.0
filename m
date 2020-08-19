Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B7824A9B8
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgHSWwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:52:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3864 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726209AbgHSWwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:52:35 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JMXXeA121849;
        Wed, 19 Aug 2020 18:52:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tNOqLGP6A+0qxqSMt8yMmP7gRFO6NdEi2uxox3wqz20=;
 b=lvXhdGnPakhQUZ4iorsItcfP335lguntQhNCcvrUdbEdsfCb6tJLYJKIjqvK40bfIKY+
 x2+t0los1uafDQ26A06mBpLXMX2zhEb3aFEEEjbTlRVgMC2xbbJtAZ51K7454CCj3BAp
 8NEbj8xMmedmE4Z40Lbmk0CFSOQQVEMGwEFBxv50CphHmI158QvfWOFf4iiBJlEDx3I9
 2pICuRBk9nmcY7GLdp4apcwKrt3OMm79XRxMJ7yPAsVDm9N2ZxDNAvIgNjWa8AfLNZ+O
 Cmr6yFSyobQQS6XH3IUjfPNx9hJ7V8KAc3AeMRzdk4fqQxRF2Z5odEWkjwALzjqD5yh2 ng== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3310eyrnvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 18:52:32 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07JMoGlx000385;
        Wed, 19 Aug 2020 22:52:31 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3304scyegr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 22:52:31 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07JMqPnE61014408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 22:52:25 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E1EEBE054;
        Wed, 19 Aug 2020 22:52:30 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 827FCBE053;
        Wed, 19 Aug 2020 22:52:29 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.160.63.43])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 22:52:29 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next v2 3/4] ibmvnic: remove never executed if statement
Date:   Wed, 19 Aug 2020 17:52:25 -0500
Message-Id: <20200819225226.10152-4-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200819225226.10152-1-ljp@linux.ibm.com>
References: <20200819225226.10152-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 impostorscore=0 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 suspectscore=1
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190182
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the beginning of the function, from_passive_init is set false by
"adapter->from_passive_init = false;",
hence the if statement will never run.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 644352e5056d..4ca4647db72a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5000,12 +5000,6 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter)
 		return adapter->init_done_rc;
 	}
 
-	if (adapter->from_passive_init) {
-		adapter->state = VNIC_OPEN;
-		adapter->from_passive_init = false;
-		return -1;
-	}
-
 	if (test_bit(0, &adapter->resetting) && !adapter->wait_for_reset &&
 	    adapter->reset_reason != VNIC_RESET_MOBILITY) {
 		if (adapter->req_rx_queues != old_num_rx_queues ||
@@ -5059,12 +5053,6 @@ static int ibmvnic_init(struct ibmvnic_adapter *adapter)
 		return adapter->init_done_rc;
 	}
 
-	if (adapter->from_passive_init) {
-		adapter->state = VNIC_OPEN;
-		adapter->from_passive_init = false;
-		return -1;
-	}
-
 	rc = init_sub_crqs(adapter);
 	if (rc) {
 		dev_err(dev, "Initialization of sub crqs failed\n");
-- 
2.23.0

