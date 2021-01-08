Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119362EEDC0
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 08:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbhAHHNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 02:13:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27664 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbhAHHNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 02:13:30 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10877Fe1032764
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 02:12:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7JnI0BcSSehVPyjrAi23FDxhEH/ka+SJFy+f0BDmxGA=;
 b=qiLeNM6MZmiI1udZPJTGA8rGWoQiQjupG4udUhWDDjdI6K6QCPuWO/x+zjQ7OCA1ZFiz
 +WASExP2pH7uosDrV3V5JC1W12uLdv6lQm9YjApsxtaAj0QHguDoZL9am61MqOizopQ2
 qIEwOliwMQyfr3+6PEyr24fmrJwpSEmhtc2vcI3uasbJ7CeAXrTzM38uAIpzGOCHVboM
 Hz8hDhHZf2Wno0Yla/+jZ3Jb1Ik9tU2UR2g4Nf4NVaTWSNue7ICALmsWnTpiDedNN4iB
 RK5UvLPeogMRm8kGIk06U5xZf+ojKDf4K1r2J/BJf9IgJQgoxg7Ng0qIwu/ASjVrvNhw Pw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35xj600t7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 02:12:48 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1086rPlG022574
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 07:12:47 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04wdc.us.ibm.com with ESMTP id 35tgfaa3hq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 07:12:47 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1087CkZK9503386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Jan 2021 07:12:46 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E51D7805C;
        Fri,  8 Jan 2021 07:12:46 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 870C778067;
        Fri,  8 Jan 2021 07:12:45 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.139.161])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  8 Jan 2021 07:12:45 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        sukadev@linux.ibm.com
Subject: [PATCH 7/7] ibmvnic: add comments about adapter->state_lock
Date:   Thu,  7 Jan 2021 23:12:36 -0800
Message-Id: <20210108071236.123769-8-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108071236.123769-1-sukadev@linux.ibm.com>
References: <20210108071236.123769-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-08_04:2021-01-07,2021-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some comments, notes and TODOs about ->state_lock and RTNL.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
Note:	This is fixing lot of comments so not identifying fixes. It
  	"seems" to fit this patch set but can send to net-next if
	necessary.

 drivers/net/ethernet/ibm/ibmvnic.c | 58 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/ibm/ibmvnic.h | 51 +++++++++++++++++++++++++-
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 236ec2456a38..1aae730ddafd 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1202,6 +1202,14 @@ static int ibmvnic_open(struct net_device *netdev)
 
 	/* If device failover is pending, just set device state and return.
 	 * Device operation will be handled by reset routine.
+	 *
+	 * Note that ->failover_pending is not protected by ->state_lock
+	 * because the tasklet (executing ibmvnic_handle_crq()) cannot
+	 * block. Even otherwise this can deadlock due to CRQs issued in
+	 * ibmvnic_open().
+	 *
+	 * We check failover_pending again at the end in case of errors.
+	 * so its okay if we miss the change to true here.
 	 */
 	if (adapter->failover_pending) {
 		adapter->state = VNIC_OPEN;
@@ -1380,6 +1388,9 @@ static int ibmvnic_close(struct net_device *netdev)
 
 	/* If device failover is pending, just set device state and return.
 	 * Device operation will be handled by reset routine.
+	 *
+	 * Note that ->failover_pending is not protected by ->state_lock
+	 * See comments in ibmvnic_open().
 	 */
 	if (adapter->failover_pending) {
 		adapter->state = VNIC_CLOSED;
@@ -1930,6 +1941,14 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
+	/*
+	 * TODO: Can this race with a reset? The reset could briefly
+	 *       set state to PROBED causing us to skip setting the
+	 *       mac address. When reset complets, we set the old mac
+	 *       address? Can we check ->resetting bit instead and
+	 *       save the new mac address in adapter->mac_addr
+	 *       so reset function can set it when it is done?
+	 */
 	if (adapter->state != VNIC_PROBED) {
 		ether_addr_copy(adapter->mac_addr, addr->sa_data);
 		rc = __ibmvnic_set_mac(netdev, addr->sa_data);
@@ -1941,6 +1960,14 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
 /**
  * do_change_param_reset returns zero if we are able to keep processing reset
  * events, or non-zero if we hit a fatal error and must halt.
+ *
+ * Notes:
+ * 	- Regardless of success/failure, this function restores adapter state
+ * 	  to what as it was on entry. In case of failure, it is assumed that
+ * 	  a new hard-reset will be attempted.
+ *	- Caller must hold the rtnl lock before calling and release upon
+ *	  return.
+ *
  */
 static int do_change_param_reset(struct ibmvnic_adapter *adapter,
 				 enum ibmvnic_reset_reason reason)
@@ -2039,6 +2066,11 @@ static int do_change_param_reset(struct ibmvnic_adapter *adapter,
 /**
  * do_reset returns zero if we are able to keep processing reset events, or
  * non-zero if we hit a fatal error and must halt.
+ *
+ * Notes:
+ * 	- Regardless of success/failure, this function restores adapter state
+ * 	  to what as it was on entry. In case of failure, it is assumed that
+ * 	  a new hard-reset will be attempted.
  */
 static int do_reset(struct ibmvnic_adapter *adapter,
 		    enum ibmvnic_reset_reason reason)
@@ -2237,6 +2269,17 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	return rc;
 }
 
+/**
+ * Perform a hard reset possibly because a prior reset encountered
+ * an error.
+ *
+ * Notes:
+ * 	- Regardless of success/failure, this function restores adapter state
+ * 	  to what as it was on entry. In case of failure, it is assumed that
+ * 	  a new hard-reset will be attempted.
+ *	- Caller must hold the rtnl lock before calling and release upon
+ *	  return.
+ */
 static int do_hard_reset(struct ibmvnic_adapter *adapter,
 			 enum ibmvnic_reset_reason reason)
 {
@@ -2651,6 +2694,11 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 		frames_processed++;
 	}
 
+	/* TODO: Can this race with reset and/or is release_rx_pools()?
+	 *       Is that why we check for VNIC_CLOSING? What if we go to
+	 *       CLOSING just after we check? We cannot take ->state_lock
+	 *       since we are in interrupt context.
+	 */
 	if (adapter->state != VNIC_CLOSING &&
 	    ((atomic_read(&adapter->rx_pool[scrq_num].available) <
 	      adapter->req_rx_add_entries_per_subcrq / 2) ||
@@ -5358,6 +5406,9 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 	}
 
 	if (adapter->from_passive_init) {
+		/* ibmvnic_reset_init() is always called with ->state_lock
+		 * held except from ibmvnic_probe(), so safe to update state.
+		 */
 		adapter->state = VNIC_OPEN;
 		adapter->from_passive_init = false;
 		return -1;
@@ -5531,6 +5582,9 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	adapter->state = VNIC_REMOVING;
 	spin_unlock_irqrestore(&adapter->remove_lock, rmflags);
 
+	/* drop state_lock so __ibmvnic_reset() can make progress
+	 * during flush_work()
+	 */
 	mutex_unlock(&adapter->state_lock);
 
 	flush_work(&adapter->ibmvnic_reset);
@@ -5546,6 +5600,9 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	release_stats_token(adapter);
 	release_stats_buffers(adapter);
 
+	/* Adapter going away. There better be no one checking ->state
+	 * or getting state_lock now TODO: Do we need the REMOVED state?
+	 */
 	adapter->state = VNIC_REMOVED;
 	mutex_destroy(&adapter->state_lock);
 	rtnl_unlock();
@@ -5627,6 +5684,7 @@ static int ibmvnic_resume(struct device *dev)
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
+	/* resuming from power-down so ignoring state_lock */
 	if (adapter->state != VNIC_OPEN)
 		return 0;
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index ac79dfa76333..d79bc9444c9f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -963,6 +963,55 @@ struct ibmvnic_tunables {
 	u64 mtu;
 };
 
+/**
+ * ->state_lock:
+ *  	Mutex to serialize read/write of adapter->state field specially
+ *  	between open and reset functions. If rtnl also needs to be held,
+ *  	acquire rtnl first and then state_lock (to be consistent with
+ *  	functions that enter ibmvnic with rtnl already held).
+ *
+ *  	In general, ->state_lock must be held for all read/writes to the
+ *  	state field. Exceptions are:
+ *  	- checks for VNIC_PROBING state - since the adapter is itself
+ *  	  under construction and because we never go _back_ to PROBING.
+ *
+ *  	- in debug messages involving ->state
+ *
+ *  	- in ibmvnic_tx_interrupt(), ibmvnic_rx_interrupt() because
+ *  	  a) this is a mutex and b) no (known) impact of getting a stale
+ *  	  state (i.e we will likely recover on the next interrupt).
+ *
+ *  	- ibmvnic_resume() - we are resuming from a power-down state?
+ *
+ *  	- ibmvnic_reset() - see ->remove_lock below.
+ *
+ *  	Besides these, there are couple of TODOs in ibmvnic_poll() and
+ *  	ibmvnic_set_mac() that need to be investigated separately.
+ *
+ *  ->remove_lock
+ *  	A spin lock used to serialize ibmvnic_reset() and ibmvnic_remove().
+ *  	ibmvnic_reset() can be called from a tasklet which cannot block,
+ *  	so it cannot use the ->state_lock. The only states ibmvnic_reset()
+ *  	checks for are PROBING, REMOVING and REMOVED. PROBING can be ignored
+ *  	as mentioned above. On entering REMOVING state, ibmvnic_reset()
+ *  	will skip scheduling resets for the adapter.
+ *
+ *  ->pending_resets[], ->next_reset:
+ *  	A "queue" of pending resets, implemented as a simple array. Resets
+ *  	are not frequent and even when they do occur, we will usually have
+ *  	just 1 or 2 entries in the queue at any time. Note that we don't
+ *  	need/allow duplicates in the queue. In the worst case, we would have
+ *  	VNIC_RESET_MAX-1 entries (but that means adapter is processing all
+ *  	valid types of resets at once!) so the slight overhead of the array
+ *  	is probably acceptable.
+ *
+ *  	We could still use a linked list but then have to deal with allocation
+ *  	failure when scheduling a reset. We sometimes enqueue reset from a
+ *  	tasklet so cannot block when we have allocation failure. Trying to
+ *  	close the adapter on failure requires us to hold the state_lock, which
+ *  	then cannot be a mutex (tasklet cannot block) - i.e complicates locking
+ *  	just for the occasional memory allocation failure.
+ */
 struct ibmvnic_adapter {
 	struct vio_dev *vdev;
 	struct net_device *netdev;
@@ -1098,6 +1147,6 @@ struct ibmvnic_adapter {
 	struct ibmvnic_tunables desired;
 	struct ibmvnic_tunables fallback;
 
-	/* Used for serialization of state field */
+	/* see block comments above */
 	struct mutex state_lock;
 };
-- 
2.26.2

