Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E655427A521
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 03:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgI1BNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 21:13:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16154 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726500AbgI1BNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 21:13:33 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S12Ce1129881
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 21:13:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/QFEuQLZr5KzG+1L/TwWZZYc74fT7BE0ad73PolM/sY=;
 b=od4kf74RfXbvJOV91I51ruQrnj1FDH//kOlVa9UvCBbh3g59+E1xGN0xrrXwfd7cc6YN
 S19uQBV6psks22NPgSB0N7SWIGHEuCXkiMZKyrgbkmLp6qWA3Za870yUTSdl/8sdcYgx
 6m5B46WgM1tJ553lV7z73fnLdKADi01Ghe7RZl+Sy/KLlwADpKv037T1xsPw6qbA969D
 E9Zulw8aq7+iyD6pdxksWb+niUhPwXcTE+Kt4qIWe6zlrIbtY7Vg8UirqmhH2hOF1umv
 x2ZhIsbrxO7ikNZfnRH28how7QK4I1f4JIs7e3FXEOB6Hnsz93btl5CVmib8jJEDNkfs vg== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33u5h90h9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 21:13:33 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08S16t0M028597
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:13:32 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 33sw98pk97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:13:32 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08S1DVCe56754618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 01:13:31 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8220CAC05F;
        Mon, 28 Sep 2020 01:13:31 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EF48AC05E;
        Mon, 28 Sep 2020 01:13:31 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.151.55])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 01:13:31 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next 1/5] ibmvnic: rename send_cap_queries to send_query_cap
Date:   Sun, 27 Sep 2020 20:13:26 -0500
Message-Id: <20200928011330.79774-2-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200928011330.79774-1-ljp@linux.ibm.com>
References: <20200928011330.79774-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-27_18:2020-09-24,2020-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 clxscore=1011 suspectscore=1 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new name send_query_cap pairs with handle_query_cap_rsp.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a151ff37fda2..b4dc63cad4c5 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -101,7 +101,7 @@ static void send_map_query(struct ibmvnic_adapter *adapter);
 static int send_request_map(struct ibmvnic_adapter *, dma_addr_t, __be32, u8);
 static int send_request_unmap(struct ibmvnic_adapter *, u8);
 static int send_login(struct ibmvnic_adapter *adapter);
-static void send_cap_queries(struct ibmvnic_adapter *adapter);
+static void send_query_cap(struct ibmvnic_adapter *adapter);
 static int init_sub_crqs(struct ibmvnic_adapter *);
 static int init_sub_crq_irqs(struct ibmvnic_adapter *adapter);
 static int ibmvnic_reset_init(struct ibmvnic_adapter *, bool reset);
@@ -882,7 +882,7 @@ static int ibmvnic_login(struct net_device *netdev)
 				   "Received partial success, retrying...\n");
 			adapter->init_done_rc = 0;
 			reinit_completion(&adapter->init_done);
-			send_cap_queries(adapter);
+			send_query_cap(adapter);
 			if (!wait_for_completion_timeout(&adapter->init_done,
 							 timeout)) {
 				netdev_warn(netdev,
@@ -3836,7 +3836,7 @@ static void send_map_query(struct ibmvnic_adapter *adapter)
 }
 
 /* Send a series of CRQs requesting various capabilities of the VNIC server */
-static void send_cap_queries(struct ibmvnic_adapter *adapter)
+static void send_query_cap(struct ibmvnic_adapter *adapter)
 {
 	union ibmvnic_crq crq;
 
@@ -4747,7 +4747,7 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 			    be16_to_cpu(crq->version_exchange_rsp.version);
 		dev_info(dev, "Partner protocol version is %d\n",
 			 ibmvnic_version);
-		send_cap_queries(adapter);
+		send_query_cap(adapter);
 		break;
 	case QUERY_CAPABILITY_RSP:
 		handle_query_cap_rsp(crq, adapter);
-- 
2.23.0

