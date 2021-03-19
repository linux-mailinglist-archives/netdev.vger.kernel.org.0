Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8723134119A
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 01:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhCSAtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 20:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbhCSAsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 20:48:50 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C18C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:50 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r17so2555154pgi.0
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1+8DMDzmPGV9CsSy99MQgiTN28n2Q7iZRaPhh3XiXWo=;
        b=mE7QeCg28kkJH/3NpOddBAERrR8P7Y7tif7q55qttNJdcR8M/yqLjTHtPfNP8ERw6Y
         s7h0L5t1//BBiLjnUgEGimfFA5gI0lfhMcqk2UPscIlGBUuH10LiL+H/O6dR6ulAfLfh
         CVVKcVs3g5nM8UEza/qG1gksIkA4lIolmeHwzrlLCLA7E1kS13qSWJVNMPJkl27kE3fC
         LKcF/Wy7hQIl0lbjvrFlscU1TOfJOtoCk0Wfshz8iF/h6o9agRjdHowIVdqOKQvywzUv
         Hzq172W1VeuKT63ednqFLgz5qrITKuuO7glhi8mLoacDfm0LehGmjcKvD44rv9lioHF6
         sq9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1+8DMDzmPGV9CsSy99MQgiTN28n2Q7iZRaPhh3XiXWo=;
        b=CbP9ntYdo6PnpQx9Rmu/Poi1Z4Pd3nK3KD6nbh3HCCE7wvHY53Wt+HlHjBFlgIb4gU
         T67lF/+TwLlJw/5W2aezPvrcUKiTorjmD3c6fm+6gTkgIeQGwdOiseDqQl5q1M37LI0L
         R8dVtufovEplQD1UZr2KJN2tQLrNQ7dzcKwOH2+scYv3VDd69EzVvT8de/FIW3eV4mNA
         +CFEvntsrr3SX7FfU7Oja3p1iHiPU3kI4LEpYIS/JG0gh/NLRbK8FUhAd5DRAE6GH7pR
         5eSyq64EjWmRadUpsy7svfm7nBscAxiNqvbKUA9Ihd36T2M//kI6Lay/66oYww4YI6Le
         aQ0A==
X-Gm-Message-State: AOAM5322F05ZxGv7SbDR+rAnA+OHvj8k59YK4o+3u/4MyJEqHBbpldJO
        4PPo+eCXOlMyIpZNBKCuNyfnqjNe26+XCQ==
X-Google-Smtp-Source: ABdhPJz2+w4AkYk9tKCMtNmNQ2Ldt3R1Acw1md2NO0maRUQFXVzvYzTlP1pamnHksVt4Kci8DScBTQ==
X-Received: by 2002:a63:a547:: with SMTP id r7mr9564385pgu.186.1616114929195;
        Thu, 18 Mar 2021 17:48:49 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i7sm3592949pfq.184.2021.03.18.17.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 17:48:48 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/7] ionic: code cleanup details
Date:   Thu, 18 Mar 2021 17:48:04 -0700
Message-Id: <20210319004810.4825-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210319004810.4825-1-snelson@pensando.io>
References: <20210319004810.4825-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Catch a couple of missing macro name uses, fix a couple
of misspellings, etc.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  8 ++----
 .../net/ethernet/pensando/ionic/ionic_if.h    | 26 +++++++++----------
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 23 +++++++---------
 3 files changed, 25 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 0832bedcb3b4..9df4b9df7a82 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -29,11 +29,9 @@ static void ionic_get_stats_strings(struct ionic_lif *lif, u8 *buf)
 static void ionic_get_stats(struct net_device *netdev,
 			    struct ethtool_stats *stats, u64 *buf)
 {
-	struct ionic_lif *lif;
+	struct ionic_lif *lif = netdev_priv(netdev);
 	u32 i;
 
-	lif = netdev_priv(netdev);
-
 	memset(buf, 0, stats->n_stats * sizeof(*buf));
 	for (i = 0; i < ionic_num_stats_grps; i++)
 		ionic_stats_groups[i].get_values(lif, &buf);
@@ -264,12 +262,10 @@ static int ionic_set_link_ksettings(struct net_device *netdev,
 				    const struct ethtool_link_ksettings *ks)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_dev *idev = &lif->ionic->idev;
 	struct ionic *ionic = lif->ionic;
-	struct ionic_dev *idev;
 	int err = 0;
 
-	idev = &lif->ionic->idev;
-
 	/* set autoneg */
 	if (ks->base.autoneg != idev->port_info->config.an_enable) {
 		mutex_lock(&ionic->dev_cmd_lock);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 31ccfcdc2b0a..40bd72bb5148 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -320,7 +320,7 @@ struct ionic_lif_identify_comp {
 /**
  * enum ionic_lif_capability - LIF capabilities
  * @IONIC_LIF_CAP_ETH:     LIF supports Ethernet
- * @IONIC_LIF_CAP_RDMA:    LIF support RDMA
+ * @IONIC_LIF_CAP_RDMA:    LIF supports RDMA
  */
 enum ionic_lif_capability {
 	IONIC_LIF_CAP_ETH        = BIT(0),
@@ -404,7 +404,7 @@ union ionic_lif_config {
  *     @max_ucast_filters:  Number of perfect unicast addresses supported
  *     @max_mcast_filters:  Number of perfect multicast addresses supported
  *     @min_frame_size:     Minimum size of frames to be sent
- *     @max_frame_size:     Maximim size of frames to be sent
+ *     @max_frame_size:     Maximum size of frames to be sent
  *     @config:             LIF config struct with features, mtu, mac, q counts
  *
  * @rdma:                RDMA identify structure
@@ -692,7 +692,7 @@ enum ionic_txq_desc_opcode {
  *                      checksums are also updated.
  *
  *                   IONIC_TXQ_DESC_OPCODE_TSO:
- *                      Device preforms TCP segmentation offload
+ *                      Device performs TCP segmentation offload
  *                      (TSO).  @hdr_len is the number of bytes
  *                      to the end of TCP header (the offset to
  *                      the TCP payload).  @mss is the desired
@@ -982,13 +982,13 @@ struct ionic_rxq_comp {
 };
 
 enum ionic_pkt_type {
-	IONIC_PKT_TYPE_NON_IP     = 0x000,
-	IONIC_PKT_TYPE_IPV4       = 0x001,
-	IONIC_PKT_TYPE_IPV4_TCP   = 0x003,
-	IONIC_PKT_TYPE_IPV4_UDP   = 0x005,
-	IONIC_PKT_TYPE_IPV6       = 0x008,
-	IONIC_PKT_TYPE_IPV6_TCP   = 0x018,
-	IONIC_PKT_TYPE_IPV6_UDP   = 0x028,
+	IONIC_PKT_TYPE_NON_IP		= 0x00,
+	IONIC_PKT_TYPE_IPV4		= 0x01,
+	IONIC_PKT_TYPE_IPV4_TCP		= 0x03,
+	IONIC_PKT_TYPE_IPV4_UDP		= 0x05,
+	IONIC_PKT_TYPE_IPV6		= 0x08,
+	IONIC_PKT_TYPE_IPV6_TCP		= 0x18,
+	IONIC_PKT_TYPE_IPV6_UDP		= 0x28,
 	/* below types are only used if encap offloads are enabled on lif */
 	IONIC_PKT_TYPE_ENCAP_NON_IP	= 0x40,
 	IONIC_PKT_TYPE_ENCAP_IPV4	= 0x41,
@@ -1331,7 +1331,7 @@ enum ionic_stats_ctl_cmd {
  * @IONIC_PORT_ATTR_STATE:      Port state attribute
  * @IONIC_PORT_ATTR_SPEED:      Port speed attribute
  * @IONIC_PORT_ATTR_MTU:        Port MTU attribute
- * @IONIC_PORT_ATTR_AUTONEG:    Port autonegotation attribute
+ * @IONIC_PORT_ATTR_AUTONEG:    Port autonegotiation attribute
  * @IONIC_PORT_ATTR_FEC:        Port FEC attribute
  * @IONIC_PORT_ATTR_PAUSE:      Port pause attribute
  * @IONIC_PORT_ATTR_LOOPBACK:   Port loopback attribute
@@ -1951,8 +1951,8 @@ enum ionic_qos_sched_type {
  * @pfc_cos:		Priority-Flow Control class of service
  * @dwrr_weight:	QoS class scheduling weight
  * @strict_rlmt:	Rate limit for strict priority scheduling
- * @rw_dot1q_pcp:	Rewrite dot1q pcp to this value	(valid iff F_RW_DOT1Q_PCP)
- * @rw_ip_dscp:		Rewrite ip dscp to this value	(valid iff F_RW_IP_DSCP)
+ * @rw_dot1q_pcp:	Rewrite dot1q pcp to value (valid iff F_RW_DOT1Q_PCP)
+ * @rw_ip_dscp:		Rewrite ip dscp to value (valid iff F_RW_IP_DSCP)
  * @dot1q_pcp:		Dot1q pcp value
  * @ndscp:		Number of valid dscp values in the ip_dscp field
  * @ip_dscp:		IP dscp values
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 48d3c7685b6c..7ee6d2dbbb34 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -124,19 +124,16 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 	link_up = link_status == IONIC_PORT_OPER_STATUS_UP;
 
 	if (link_up) {
-		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev)) {
+		if (netdev->flags & IFF_UP && netif_running(netdev)) {
 			mutex_lock(&lif->queue_lock);
 			ionic_start_queues(lif);
 			mutex_unlock(&lif->queue_lock);
 		}
 
 		if (!netif_carrier_ok(netdev)) {
-			u32 link_speed;
-
 			ionic_port_identify(lif->ionic);
-			link_speed = le32_to_cpu(lif->info->status.link_speed);
 			netdev_info(netdev, "Link up - %d Gbps\n",
-				    link_speed / 1000);
+				    le32_to_cpu(lif->info->status.link_speed) / 1000);
 			netif_carrier_on(netdev);
 		}
 	} else {
@@ -145,7 +142,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 			netif_carrier_off(netdev);
 		}
 
-		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev)) {
+		if (netdev->flags & IFF_UP && netif_running(netdev)) {
 			mutex_lock(&lif->queue_lock);
 			ionic_stop_queues(lif);
 			mutex_unlock(&lif->queue_lock);
@@ -839,7 +836,7 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 
 	switch (le16_to_cpu(comp->event.ecode)) {
 	case IONIC_EVENT_LINK_CHANGE:
-		ionic_link_status_check_request(lif, false);
+		ionic_link_status_check_request(lif, CAN_NOT_SLEEP);
 		break;
 	case IONIC_EVENT_RESET:
 		work = kzalloc(sizeof(*work), GFP_ATOMIC);
@@ -1443,7 +1440,7 @@ static int ionic_start_queues_reconfig(struct ionic_lif *lif)
 	 */
 	err = ionic_txrx_init(lif);
 	mutex_unlock(&lif->queue_lock);
-	ionic_link_status_check_request(lif, true);
+	ionic_link_status_check_request(lif, CAN_SLEEP);
 	netif_device_attach(lif->netdev);
 
 	return err;
@@ -1863,7 +1860,7 @@ static int ionic_open(struct net_device *netdev)
 
 	err = ionic_txrx_init(lif);
 	if (err)
-		goto err_out;
+		goto err_txrx_free;
 
 	err = netif_set_real_num_tx_queues(netdev, lif->nxqs);
 	if (err)
@@ -1884,7 +1881,7 @@ static int ionic_open(struct net_device *netdev)
 
 err_txrx_deinit:
 	ionic_txrx_deinit(lif);
-err_out:
+err_txrx_free:
 	ionic_txrx_free(lif);
 	return err;
 }
@@ -2356,7 +2353,7 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	swap(lif->nxqs, qparam->nxqs);
 
 err_out_reinit_unlock:
-	/* re-init the queues, but don't loose an error code */
+	/* re-init the queues, but don't lose an error code */
 	if (err)
 		ionic_start_queues_reconfig(lif);
 	else
@@ -2605,7 +2602,7 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	}
 
 	clear_bit(IONIC_LIF_F_FW_RESET, lif->state);
-	ionic_link_status_check_request(lif, true);
+	ionic_link_status_check_request(lif, CAN_SLEEP);
 	netif_device_attach(lif->netdev);
 	dev_info(ionic->dev, "FW Up: LIFs restarted\n");
 
@@ -2976,7 +2973,7 @@ int ionic_lif_register(struct ionic_lif *lif)
 		return err;
 	}
 
-	ionic_link_status_check_request(lif, true);
+	ionic_link_status_check_request(lif, CAN_SLEEP);
 	lif->registered = true;
 	ionic_lif_set_netdev_info(lif);
 
-- 
2.17.1

