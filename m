Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF615244608
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 09:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgHNH7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 03:59:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726780AbgHNH7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 03:59:33 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07E7mtDq054896;
        Fri, 14 Aug 2020 03:59:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=H8hBoiZlNF67Lah+17S5EUflHemRCDXK7B7kUiUqJSc=;
 b=Y3nvSHfUiq9NLgd2fIA3o3xct/xhk9GyfBXPs1920Ou+PTuEGAaJFa+b2EWIN/BBvmmy
 l76YO/MYn4fh3cCT9ihj66lfX83Yw242Go/AjxzIp/LzEKlUrR9KpUBP96+sqpKTm9rq
 S4++RS/VlDGEabkLOKjliOv+G3/CxxTYbdHkWg+38aG99KirtQFH+Cvdh9/C8PQWLMJf
 D/zebQ6jSQYlj6m5k5aLqyI7Ggm1i03+ti2TS8ZJUuDmdzb0yfS55+n8BqR36yFgaWyJ
 xLHdL0vK5L0A1ki4EwpKl4uBjmx33Sksk+GmNBf0ZyzDOilM+wwhmpz3gqrmhXIsEhuv uA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w6tu7h6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 03:59:25 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07E7t3hi013546;
        Fri, 14 Aug 2020 07:59:25 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 32skp9vn3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 07:59:25 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07E7xOEL35127680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 07:59:24 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A85C5AC05B;
        Fri, 14 Aug 2020 07:59:24 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F1A9AC059;
        Fri, 14 Aug 2020 07:59:24 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.160.68.30])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 14 Aug 2020 07:59:24 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 4/5] ibmvnic: remove never executed if statement
Date:   Fri, 14 Aug 2020 02:59:20 -0500
Message-Id: <20200814075921.88745-5-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200814075921.88745-1-ljp@linux.ibm.com>
References: <20200814075921.88745-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_02:2020-08-13,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=1
 impostorscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008140054
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

