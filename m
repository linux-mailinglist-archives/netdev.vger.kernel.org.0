Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE1D2A9DD6
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 20:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgKFTSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 14:18:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62352 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728165AbgKFTSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 14:18:42 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6J1dDP112242;
        Fri, 6 Nov 2020 14:18:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=ekMRd/BlIUY3PgPZIgZcd3bmR+YvqVLgjNXwwbqsfDU=;
 b=bElZF/4hNKrLDekBlwJk2xkir8CXf/kTY8W991+IKiZqoxetv1EpUf1rZMvp6srVMspM
 KGMuDzxzrBePE0dgpoWl7pqTwVw6wPtseWUaL7m+WcZzLFjZrUcTtqygpSXFcCYi+6tV
 TX1kD4JARhaUESsrE9csC/QyeP3Y8mt/q3pcPsrlDxxQiCzAJzJhgi2gVmVZTrpIn4TL
 Q0pRApnG04zJZVYiNacG2UKpS4P3vbMT+usNvrCNoVoIQkgauDfaWRNaSg0KzHVY9UzZ
 s+E6kVvlZjgDQA3iu9ln/hUatugAiKkEjJY3of8Pppym0pb+4NvGEUuLDnYm35YFUT6W /Q== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34n6h8cagc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 14:18:30 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A6JDZQO017203;
        Fri, 6 Nov 2020 19:18:30 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 34h02390n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 19:18:30 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A6JITIj65995074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Nov 2020 19:18:29 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65BB3112062;
        Fri,  6 Nov 2020 19:18:29 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10D23112061;
        Fri,  6 Nov 2020 19:18:29 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  6 Nov 2020 19:18:28 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Dany Madden <drt@linux.ibm.com>
Subject: [PATCH net-next] Revert ibmvnic merge do_change_param_reset into do_reset
Date:   Fri,  6 Nov 2020 14:17:45 -0500
Message-Id: <20201106191745.1679846-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 phishscore=0 clxscore=1011 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060132
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 16b5f5ce351f8709a6b518cc3cbf240c378305bf
where it restructures do_reset. There are patches being tested that
would require major rework if this is committed first. 

We will resend this after the other patches have been applied.

Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 147 ++++++++++++++++++++---------
 1 file changed, 104 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f4167de30461..af4dfbe28d56 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1826,6 +1826,86 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
 	return rc;
 }
 
+/**
+ * do_change_param_reset returns zero if we are able to keep processing reset
+ * events, or non-zero if we hit a fatal error and must halt.
+ */
+static int do_change_param_reset(struct ibmvnic_adapter *adapter,
+				 struct ibmvnic_rwi *rwi,
+				 u32 reset_state)
+{
+	struct net_device *netdev = adapter->netdev;
+	int i, rc;
+
+	netdev_dbg(adapter->netdev, "Change param resetting driver (%d)\n",
+		   rwi->reset_reason);
+
+	netif_carrier_off(netdev);
+	adapter->reset_reason = rwi->reset_reason;
+
+	ibmvnic_cleanup(netdev);
+
+	if (reset_state == VNIC_OPEN) {
+		rc = __ibmvnic_close(netdev);
+		if (rc)
+			return rc;
+	}
+
+	release_resources(adapter);
+	release_sub_crqs(adapter, 1);
+	release_crq_queue(adapter);
+
+	adapter->state = VNIC_PROBED;
+
+	rc = init_crq_queue(adapter);
+
+	if (rc) {
+		netdev_err(adapter->netdev,
+			   "Couldn't initialize crq. rc=%d\n", rc);
+		return rc;
+	}
+
+	rc = ibmvnic_reset_init(adapter, true);
+	if (rc)
+		return IBMVNIC_INIT_FAILED;
+
+	/* If the adapter was in PROBE state prior to the reset,
+	 * exit here.
+	 */
+	if (reset_state == VNIC_PROBED)
+		return 0;
+
+	rc = ibmvnic_login(netdev);
+	if (rc) {
+		adapter->state = reset_state;
+		return rc;
+	}
+
+	rc = init_resources(adapter);
+	if (rc)
+		return rc;
+
+	ibmvnic_disable_irqs(adapter);
+
+	adapter->state = VNIC_CLOSED;
+
+	if (reset_state == VNIC_CLOSED)
+		return 0;
+
+	rc = __ibmvnic_open(netdev);
+	if (rc)
+		return IBMVNIC_OPEN_FAILED;
+
+	/* refresh device's multicast list */
+	ibmvnic_set_multi(netdev);
+
+	/* kick napi */
+	for (i = 0; i < adapter->req_rx_queues; i++)
+		napi_schedule(&adapter->napi[i]);
+
+	return 0;
+}
+
 /**
  * do_reset returns zero if we are able to keep processing reset events, or
  * non-zero if we hit a fatal error and must halt.
@@ -1841,12 +1921,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	netdev_dbg(adapter->netdev, "Re-setting driver (%d)\n",
 		   rwi->reset_reason);
 
-	adapter->reset_reason = rwi->reset_reason;
-	/* requestor of VNIC_RESET_CHANGE_PARAM already has the rtnl lock */
-	if (!(adapter->reset_reason == VNIC_RESET_CHANGE_PARAM))
-		rtnl_lock();
+	rtnl_lock();
 
 	netif_carrier_off(netdev);
+	adapter->reset_reason = rwi->reset_reason;
 
 	old_num_rx_queues = adapter->req_rx_queues;
 	old_num_tx_queues = adapter->req_tx_queues;
@@ -1858,37 +1936,25 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	if (reset_state == VNIC_OPEN &&
 	    adapter->reset_reason != VNIC_RESET_MOBILITY &&
 	    adapter->reset_reason != VNIC_RESET_FAILOVER) {
-		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
-			rc = __ibmvnic_close(netdev);
-			if (rc)
-				goto out;
-		} else {
-			adapter->state = VNIC_CLOSING;
-
-			/* Release the RTNL lock before link state change and
-			 * re-acquire after the link state change to allow
-			 * linkwatch_event to grab the RTNL lock and run during
-			 * a reset.
-			 */
-			rtnl_unlock();
-			rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
-			rtnl_lock();
-			if (rc)
-				goto out;
+		adapter->state = VNIC_CLOSING;
 
-			if (adapter->state != VNIC_CLOSING) {
-				rc = -1;
-				goto out;
-			}
+		/* Release the RTNL lock before link state change and
+		 * re-acquire after the link state change to allow
+		 * linkwatch_event to grab the RTNL lock and run during
+		 * a reset.
+		 */
+		rtnl_unlock();
+		rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
+		rtnl_lock();
+		if (rc)
+			goto out;
 
-			adapter->state = VNIC_CLOSED;
+		if (adapter->state != VNIC_CLOSING) {
+			rc = -1;
+			goto out;
 		}
-	}
 
-	if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
-		release_resources(adapter);
-		release_sub_crqs(adapter, 1);
-		release_crq_queue(adapter);
+		adapter->state = VNIC_CLOSED;
 	}
 
 	if (adapter->reset_reason != VNIC_RESET_NON_FATAL) {
@@ -1897,9 +1963,7 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		 */
 		adapter->state = VNIC_PROBED;
 
-		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
-			rc = init_crq_queue(adapter);
-		} else if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
+		if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
 			rc = ibmvnic_reenable_crq_queue(adapter);
 			release_sub_crqs(adapter, 1);
 		} else {
@@ -1939,11 +2003,7 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 			goto out;
 		}
 
-		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
-			rc = init_resources(adapter);
-			if (rc)
-				goto out;
-		} else if (adapter->req_rx_queues != old_num_rx_queues ||
+		if (adapter->req_rx_queues != old_num_rx_queues ||
 		    adapter->req_tx_queues != old_num_tx_queues ||
 		    adapter->req_rx_add_entries_per_subcrq !=
 		    old_num_rx_slots ||
@@ -2004,9 +2064,7 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	rc = 0;
 
 out:
-	/* requestor of VNIC_RESET_CHANGE_PARAM should still hold the rtnl lock */
-	if (!(adapter->reset_reason == VNIC_RESET_CHANGE_PARAM))
-		rtnl_unlock();
+	rtnl_unlock();
 
 	return rc;
 }
@@ -2140,7 +2198,10 @@ static void __ibmvnic_reset(struct work_struct *work)
 		}
 		spin_unlock_irqrestore(&adapter->state_lock, flags);
 
-		if (adapter->force_reset_recovery) {
+		if (rwi->reset_reason == VNIC_RESET_CHANGE_PARAM) {
+			/* CHANGE_PARAM requestor holds rtnl_lock */
+			rc = do_change_param_reset(adapter, rwi, reset_state);
+		} else if (adapter->force_reset_recovery) {
 			/* Transport event occurred during previous reset */
 			if (adapter->wait_for_reset) {
 				/* Previous was CHANGE_PARAM; caller locked */
-- 
2.18.2

