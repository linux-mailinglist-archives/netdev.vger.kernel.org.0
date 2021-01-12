Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69ED2F3850
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406688AbhALSPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:15:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59276 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392090AbhALSP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 13:15:27 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CICoN7058322
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:14:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PhpKVwed9z+R5dX0zRkPuI404i6VnpqDNtQmMLdIf6I=;
 b=Blff56MXEnH9r5KZVrnGWN++TN4UmWcShhHssGqSpWuo7S5rPSAJcp3HCFbT6Zc+m1af
 Id/SPWJXuX43LiYfP+iQkMVqaKtsYZNVdvnH+HPse/ls5Oaug9zxM2UhrNy07e/jtnoc
 d+hG4Y9PZDss3WmjbOHJ6qEx0bUR+zPoIRmDDhpQFBzdknIITwMrOLf+5PD1jyjnu5V2
 avsLPwYbOk4cnN7qUTURE4hzo3pkY+5kpY4j41EWPGYlaeFx0un07Rj+1s0O7x7YFD5M
 BJv+yJh4lohIT1QMST7GStba/6vG1xm0QnGZ8CdSRf+/iIOUFdlb99T0khy98TYd7MAw 1Q== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361gugg1kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:14:45 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CIC7ro008141
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:14:45 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 35y448yws4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:14:45 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CIEj7a26935584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 18:14:45 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDC08B2067;
        Tue, 12 Jan 2021 18:14:44 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41815B2064;
        Tue, 12 Jan 2021 18:14:44 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.179.93])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 18:14:44 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com
Subject: [PATCH net-next v2 2/7] ibmvnic: update reset function prototypes
Date:   Tue, 12 Jan 2021 10:14:36 -0800
Message-Id: <20210112181441.206545-3-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112181441.206545-1-sukadev@linux.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101120103
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

