Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D5A57E0B0
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiGVLQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiGVLQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:16:10 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555D02C66C;
        Fri, 22 Jul 2022 04:16:09 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26MBAuTr003822;
        Fri, 22 Jul 2022 11:16:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=yJIc1AM3rSxpZJstTK/fTk6iBbnn5yIUq3R0CXzbZd4=;
 b=HAkqqjRsHPYLXCkmlctOj+As/fRtmjydEWy+eu0THDiUqOCMYUEdFk4+4exThVK5CwgS
 SugwyiNHYdBqMUxJTgwXPM+F7dnUd7O7SPBESkfIFyyLmpjwxiTf92EgJz2No3UxOUL1
 RTSd/E7ITN2H0vXBtvLlhnKQfEto+5T3NxnjVNvi9ZV9a2AlAW7yCu7qxe8Ozvn8JVkV
 YP3UwD0rkuZ3Y6zmFkyDdj6qqvQPeEIKyP9okonnZ1aRdqOyEv37vsMzJj8O0XZPh5Ln
 OBluoMwKWNk2GkhHQgOi58UGrpyC7vDXlGmrr3451SdbZts6BZTrNJHBSkIPRbPaCHkA gA== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3hfe2gsv2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 11:15:59 +0000
Received: from pps.filterd (NASANPPMTA03.qualcomm.com [127.0.0.1])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 26MBFxfr010488;
        Fri, 22 Jul 2022 11:15:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NASANPPMTA03.qualcomm.com (PPS) with ESMTPS id 3hc6ru1skv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 11:15:59 +0000
Received: from NASANPPMTA03.qualcomm.com (NASANPPMTA03.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26MBFwHV010470;
        Fri, 22 Jul 2022 11:15:58 GMT
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA03.qualcomm.com (PPS) with ESMTPS id 26MBFwKF010464
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 11:15:58 +0000
Received: from zijuhu-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 22 Jul 2022 04:15:56 -0700
From:   Zijun Hu <quic_zijuhu@quicinc.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <luiz.von.dentz@intel.com>, <quic_zijuhu@quicinc.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v5] Bluetooth: hci_sync: Remove redundant func definition
Date:   Fri, 22 Jul 2022 19:15:52 +0800
Message-ID: <1658488552-24691-1-git-send-email-quic_zijuhu@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: IT3nYKRtRL254Cm1BkzBGbkPDBcCMxxZ
X-Proofpoint-GUID: IT3nYKRtRL254Cm1BkzBGbkPDBcCMxxZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-22_02,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207220048
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

both hci_request.c and hci_sync.c have the same definition for
disconnected_accept_list_entries(), so remove a redundant copy.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
---
v4->v5
 -move the func declaration from hci_request.h to hci_request.c
v2->v4
 -optimize commit message
v1->v2
 -remove the func copy within hci_request.c instead of hci_sync.c
 net/bluetooth/hci_request.c | 20 ++------------------
 net/bluetooth/hci_sync.c    |  2 +-
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 635cc5fb451e..69e30217c4e4 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -32,6 +32,8 @@
 #include "msft.h"
 #include "eir.h"
 
+extern bool disconnected_accept_list_entries(struct hci_dev *hdev);
+
 void hci_req_init(struct hci_request *req, struct hci_dev *hdev)
 {
 	skb_queue_head_init(&req->cmd_q);
@@ -1784,24 +1786,6 @@ int hci_update_random_address(struct hci_request *req, bool require_privacy,
 	return 0;
 }
 
-static bool disconnected_accept_list_entries(struct hci_dev *hdev)
-{
-	struct bdaddr_list *b;
-
-	list_for_each_entry(b, &hdev->accept_list, list) {
-		struct hci_conn *conn;
-
-		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &b->bdaddr);
-		if (!conn)
-			return true;
-
-		if (conn->state != BT_CONNECTED && conn->state != BT_CONFIG)
-			return true;
-	}
-
-	return false;
-}
-
 void __hci_req_update_scan(struct hci_request *req)
 {
 	struct hci_dev *hdev = req->hdev;
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 3067d94e7a8e..b44d0b4143e6 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2425,7 +2425,7 @@ int hci_write_fast_connectable_sync(struct hci_dev *hdev, bool enable)
 	return err;
 }
 
-static bool disconnected_accept_list_entries(struct hci_dev *hdev)
+bool disconnected_accept_list_entries(struct hci_dev *hdev)
 {
 	struct bdaddr_list *b;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

