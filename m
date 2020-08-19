Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725F7249481
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 07:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgHSFfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 01:35:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18668 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbgHSFfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 01:35:20 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J5WZIx078428;
        Wed, 19 Aug 2020 01:35:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=H8hBoiZlNF67Lah+17S5EUflHemRCDXK7B7kUiUqJSc=;
 b=pOny/mV8OsoZB7iMX9Gf2548IY8LSa1dPWvZPhGl+YfUNFI57lGcexa0qPtOrhZtQthU
 kn7JPFBU7Ye7BARUoH4fD5W/tcdzIN8pWJ5N+mt1gTMULbwhLUZj6XNII1wytfKf3/SK
 aoll70LkrCndII7qGWdA2Wwt/9UlaUljQHNVJ7HQLR+BLAfyY/zCs6O68q7+XjTDTW5d
 lHU1FG/hrm1bf7ACAkfaBNrvyabtqqRRIEp/WtwGi9FkvTw0ry39dnih72LQi2OavMCi
 nkeuDiAIY7isDPFjjdEzCjA4mWZiWuSJxrKrxasHddLgm6sQszYfcOBHV5fInsSuAJaj +w== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304nv25ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 01:35:15 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07J5Yk4T029063;
        Wed, 19 Aug 2020 05:35:15 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 3304tkhew9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 05:35:15 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07J5ZFq448431428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 05:35:15 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC12FAC05B;
        Wed, 19 Aug 2020 05:35:14 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C91AAC059;
        Wed, 19 Aug 2020 05:35:14 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.160.104.33])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 05:35:14 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next 4/5] ibmvnic: remove never executed if statement
Date:   Wed, 19 Aug 2020 00:35:11 -0500
Message-Id: <20200819053512.3619-5-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200819053512.3619-1-ljp@linux.ibm.com>
References: <20200819053512.3619-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_02:2020-08-18,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=1
 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190042
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
index e366fd42a8c4..280358dce8ba 100644
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

