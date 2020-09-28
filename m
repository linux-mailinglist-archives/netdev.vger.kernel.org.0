Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4C827A524
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 03:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgI1BNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 21:13:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19322 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726406AbgI1BNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 21:13:34 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S130w8020946
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 21:13:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=b0sr1g1UW/gJWU1e0Cku8mUeF7cbW06IEpdqFdTwHdY=;
 b=Uo0WwwB5H+k9HQ58Xug4NIhf73EDcCc2ezNM+sjA+KATqU15zA3+QrDp+gsdHCvfAeAg
 wUwLsL8/U1Yc60cZ5YG2KJGULj/fO9LZL7YXaA6AepqTf/GTQbx7Td8/yWXB4bn06G0g
 PnJLQAIh27OmHmEljZzkOdJQtSLp+7zC5l7f8WTxEv1yt0zoFxpLuQR/thBjtWvAHxXA
 3ZlEezfS51RIQMVPffFEjLUBm5A5ji40GyKDpZ3BCcYS4WTkFfESsQ6KduK4RiSRyAMd
 ra67dSfkA8mhTGix4zCuHIknU5hJGqenDgFVOgtb4kvTMHeFcmCY5B3efSSZW6iIo56Y Zg== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33u5d30pad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 21:13:34 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08S18DvJ023081
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:13:32 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 33sw98pjgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:13:32 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08S1DWBo39322066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 01:13:32 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DAB4AC059;
        Mon, 28 Sep 2020 01:13:32 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AD1CAC062;
        Mon, 28 Sep 2020 01:13:32 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.151.55])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 01:13:32 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next 3/5] ibmvnic: rename send_map_query to send_query_map
Date:   Sun, 27 Sep 2020 20:13:28 -0500
Message-Id: <20200928011330.79774-4-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200928011330.79774-1-ljp@linux.ibm.com>
References: <20200928011330.79774-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-27_18:2020-09-24,2020-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=1 malwarescore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 impostorscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280004
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new name send_query_map pairs with handle_query_map_rsp.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 928ad9e98afa..1ab321e69075 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -97,7 +97,7 @@ static int pending_scrq(struct ibmvnic_adapter *,
 static union sub_crq *ibmvnic_next_scrq(struct ibmvnic_adapter *,
 					struct ibmvnic_sub_crq_queue *);
 static int ibmvnic_poll(struct napi_struct *napi, int data);
-static void send_map_query(struct ibmvnic_adapter *adapter);
+static void send_query_map(struct ibmvnic_adapter *adapter);
 static int send_request_map(struct ibmvnic_adapter *, dma_addr_t, __be32, u8);
 static int send_request_unmap(struct ibmvnic_adapter *, u8);
 static int send_login(struct ibmvnic_adapter *adapter);
@@ -1113,7 +1113,7 @@ static int init_resources(struct ibmvnic_adapter *adapter)
 	if (rc)
 		return rc;
 
-	send_map_query(adapter);
+	send_query_map(adapter);
 
 	rc = init_rx_pools(netdev);
 	if (rc)
@@ -3825,7 +3825,7 @@ static int send_request_unmap(struct ibmvnic_adapter *adapter, u8 map_id)
 	return ibmvnic_send_crq(adapter, &crq);
 }
 
-static void send_map_query(struct ibmvnic_adapter *adapter)
+static void send_query_map(struct ibmvnic_adapter *adapter)
 {
 	union ibmvnic_crq crq;
 
-- 
2.23.0

