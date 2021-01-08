Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB692EEDC1
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 08:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbhAHHNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 02:13:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726784AbhAHHNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 02:13:24 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10874AQv111316
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 02:12:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+0fXlY1uKfkACIJFfn0hZPwItaU+frH94OcQFsCVPCY=;
 b=Ab64X0GqQXE7m9yqErGjEcxW3aV6KY53h+uZEf5tRKMR5zLZGbXa8nycMbfmEL7jTUB8
 VVNVg8j6eDX1JmIS/b4UL8c7R6dhT22yQ8ONvmjywbID3M1il7/3UO8XKJsGMSIROGXn
 zBxluGG08cBS3UUMjrZorPnjaTtx7UvuGh6elrwuHtLuq+0DIlPz3lm6bAXOuRduyIZ9
 wU7m+SiBfjZBJQjfXBUolLFf+mBn+XsYU02FKRKO/BdJA+vlbvgouuM/si+FrgRnkck6
 vgrsocFBW2JwLvhkC4duU6AVl+WLEmNswFGw6lBQkCuHV4gHc0/D4+86a4/kXtPFlogQ xg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35xj0a16w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 02:12:43 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1087BkGE021247
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 07:12:42 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 35tgfa4nyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 07:12:42 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1087Ce2611534866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Jan 2021 07:12:40 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEC1378064;
        Fri,  8 Jan 2021 07:12:40 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CE7A7805C;
        Fri,  8 Jan 2021 07:12:40 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.139.161])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  8 Jan 2021 07:12:39 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        sukadev@linux.ibm.com
Subject: [PATCH 2/7] ibmvnic: update reset function prototypes
Date:   Thu,  7 Jan 2021 23:12:31 -0800
Message-Id: <20210108071236.123769-3-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108071236.123769-1-sukadev@linux.ibm.com>
References: <20210108071236.123769-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-08_04:2021-01-07,2021-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 clxscore=1011 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080036
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reset functions need just the 'reset reason' parameter and not
the ibmvnic_rwi list element. Update the functions so we can simplify
the handling of the ->rwi_list in a follow-on patch.

Fixes: 2770a7984db5 ("ibmvnic: Introduce hard reset recovery")

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 39 ++++++++++++++++--------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index d548779561fd..cd8108dbddec 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1929,17 +1929,17 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
  * events, or non-zero if we hit a fatal error and must halt.
  */
 static int do_change_param_reset(struct ibmvnic_adapter *adapter,
-				 struct ibmvnic_rwi *rwi,
+				 enum ibmvnic_reset_reason reason,
 				 u32 reset_state)
 {
 	struct net_device *netdev = adapter->netdev;
 	int i, rc;
 
 	netdev_dbg(adapter->netdev, "Change param resetting driver (%d)\n",
-		   rwi->reset_reason);
+		   reason);
 
 	netif_carrier_off(netdev);
-	adapter->reset_reason = rwi->reset_reason;
+	adapter->reset_reason = reason;
 
 	ibmvnic_cleanup(netdev);
 
@@ -2015,7 +2015,7 @@ static int do_change_param_reset(struct ibmvnic_adapter *adapter,
  * non-zero if we hit a fatal error and must halt.
  */
 static int do_reset(struct ibmvnic_adapter *adapter,
-		    struct ibmvnic_rwi *rwi, u32 reset_state)
+		    enum ibmvnic_reset_reason reason, u32 reset_state)
 {
 	u64 old_num_rx_queues, old_num_tx_queues;
 	u64 old_num_rx_slots, old_num_tx_slots;
@@ -2025,7 +2025,7 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	netdev_dbg(adapter->netdev,
 		   "[S:%d FOP:%d] Reset reason %d, reset_state %d\n",
 		   adapter->state, adapter->failover_pending,
-		   rwi->reset_reason, reset_state);
+		   reason, reset_state);
 
 	rtnl_lock();
 	/*
@@ -2033,11 +2033,11 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	 * This will ensure ibmvnic_open() has either completed or will
 	 * block until failover is complete.
 	 */
-	if (rwi->reset_reason == VNIC_RESET_FAILOVER)
+	if (reason == VNIC_RESET_FAILOVER)
 		adapter->failover_pending = false;
 
 	netif_carrier_off(netdev);
-	adapter->reset_reason = rwi->reset_reason;
+	adapter->reset_reason = reason;
 
 	old_num_rx_queues = adapter->req_rx_queues;
 	old_num_tx_queues = adapter->req_tx_queues;
@@ -2188,16 +2188,16 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 }
 
 static int do_hard_reset(struct ibmvnic_adapter *adapter,
-			 struct ibmvnic_rwi *rwi, u32 reset_state)
+			 enum ibmvnic_reset_reason reason, u32 reset_state)
 {
 	struct net_device *netdev = adapter->netdev;
 	int rc;
 
 	netdev_dbg(adapter->netdev, "Hard resetting driver (%d)\n",
-		   rwi->reset_reason);
+		   reason);
 
 	netif_carrier_off(netdev);
-	adapter->reset_reason = rwi->reset_reason;
+	adapter->reset_reason = reason;
 
 	ibmvnic_cleanup(netdev);
 	release_resources(adapter);
@@ -2278,6 +2278,7 @@ static struct ibmvnic_rwi *get_next_rwi(struct ibmvnic_adapter *adapter)
 
 static void __ibmvnic_reset(struct work_struct *work)
 {
+	enum ibmvnic_reset_reason reason;
 	struct ibmvnic_rwi *rwi;
 	struct ibmvnic_adapter *adapter;
 	bool saved_state = false;
@@ -2294,6 +2295,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 	}
 
 	rwi = get_next_rwi(adapter);
+	reason = rwi->reset_reason;
 	while (rwi) {
 		spin_lock_irqsave(&adapter->state_lock, flags);
 
@@ -2311,9 +2313,9 @@ static void __ibmvnic_reset(struct work_struct *work)
 		}
 		spin_unlock_irqrestore(&adapter->state_lock, flags);
 
-		if (rwi->reset_reason == VNIC_RESET_CHANGE_PARAM) {
+		if (reason == VNIC_RESET_CHANGE_PARAM) {
 			/* CHANGE_PARAM requestor holds rtnl_lock */
-			rc = do_change_param_reset(adapter, rwi, reset_state);
+			rc = do_change_param_reset(adapter, reason, reset_state);
 		} else if (adapter->force_reset_recovery) {
 			/*
 			 * Since we are doing a hard reset now, clear the
@@ -2326,11 +2328,11 @@ static void __ibmvnic_reset(struct work_struct *work)
 			if (adapter->wait_for_reset) {
 				/* Previous was CHANGE_PARAM; caller locked */
 				adapter->force_reset_recovery = false;
-				rc = do_hard_reset(adapter, rwi, reset_state);
+				rc = do_hard_reset(adapter, reason, reset_state);
 			} else {
 				rtnl_lock();
 				adapter->force_reset_recovery = false;
-				rc = do_hard_reset(adapter, rwi, reset_state);
+				rc = do_hard_reset(adapter, reason, reset_state);
 				rtnl_unlock();
 			}
 			if (rc) {
@@ -2341,9 +2343,9 @@ static void __ibmvnic_reset(struct work_struct *work)
 				set_current_state(TASK_UNINTERRUPTIBLE);
 				schedule_timeout(60 * HZ);
 			}
-		} else if (!(rwi->reset_reason == VNIC_RESET_FATAL &&
+		} else if (!(reason == VNIC_RESET_FATAL &&
 				adapter->from_passive_init)) {
-			rc = do_reset(adapter, rwi, reset_state);
+			rc = do_reset(adapter, reason, reset_state);
 		}
 		kfree(rwi);
 		adapter->last_reset_time = jiffies;
@@ -2352,9 +2354,10 @@ static void __ibmvnic_reset(struct work_struct *work)
 			netdev_dbg(adapter->netdev, "Reset failed, rc=%d\n", rc);
 
 		rwi = get_next_rwi(adapter);
+		reason = rwi->reset_reason;
 
-		if (rwi && (rwi->reset_reason == VNIC_RESET_FAILOVER ||
-			    rwi->reset_reason == VNIC_RESET_MOBILITY))
+		if (reason && (reason == VNIC_RESET_FAILOVER ||
+			       reason == VNIC_RESET_MOBILITY))
 			adapter->force_reset_recovery = true;
 	}
 
-- 
2.26.2

