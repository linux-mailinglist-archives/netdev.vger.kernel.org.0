Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EAF20F41C
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733309AbgF3MEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:04:01 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:43396 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729647AbgF3MEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:04:00 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 41B23600A0;
        Tue, 30 Jun 2020 12:03:59 +0000 (UTC)
Received: from us4-mdac16-16.ut7.mdlocal (unknown [10.7.65.240])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 407C52009A;
        Tue, 30 Jun 2020 12:03:59 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.38])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B52911C0051;
        Tue, 30 Jun 2020 12:03:55 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4C32D80007E;
        Tue, 30 Jun 2020 12:03:55 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:03:50 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 04/14] sfc: commonise miscellaneous efx functions
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <21ce6495-29b0-c1c8-3466-67102460e867@solarflare.com>
Date:   Tue, 30 Jun 2020 13:03:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25512.003
X-TM-AS-Result: No-10.536400-8.000000-10
X-TMASE-MatchedRID: tP5sLdsLyjjYRtu7Bnr/OY9Ha73XaFhEeouvej40T4gd0WOKRkwsh1ym
        Rv3NQjsEfGzuoVn0Vs6PQi9XuOWoOKjC6/MNUxOoimHWEC28pk0KJM4okvH5Xg6O6wNXWMUU/ny
        w33FD5lQe27BljbjQO4yn5jWT17sxZ7ukeil+NQjVsW2YGqoUtNxWLypmYlZzfkiy7TTogYbBEk
        MUA1VSdS9+Ya7In7FJlLTpMQ/pIHLrbEGb+5Q/eU+zv2ByYSDQb1d/zpzApVocNByoSo036aUTu
        BQ/WRv/sp4qMKo4oRiB3iStEtZmRFjAxBJHeoHdydRP56yRRA9n+sA9+u1YLacxvibtoCq3H0Gq
        6gh+ZlArcIfjsadOSDAbdH82TYhSDD20H1S9BwgqsMfMfrOZRUpFpc3bJiMeH1bhq4z+yfT1Xl/
        6Ik7tZvSAD91vCCekqX4vgQ9276gXNVPhBUtpsj42t8NRMRfEui/Hcpfcv4TUlVJM/QT13n43HV
        +1jEvweT+BhnIF+vrYGWnHlOFyXG5u+NE9AtLeqKTATIDI+7PUIkoTEP0J+W0K6xM6pD6N9z7eg
        Q4C/Voan/ZIv5yFM70aI6k8moG6+Dh1wKIt5dCeAiCmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0eP
        s7A07fyjtizU0rhjmJ+eVeo+RBDmR9/9AUbuqoyLSHljzAYxAiYCUPbS7WI=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.536400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593518636-wpV_hNWHHeXF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various left-over bits and pieces from efx.c that are needed by ef100.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        | 103 --------------------------
 drivers/net/ethernet/sfc/efx.h        |  26 -------
 drivers/net/ethernet/sfc/efx_common.c | 102 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_common.h |  36 +++++++++
 4 files changed, 138 insertions(+), 129 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 4c2d305089ce..41a2c972323e 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -593,109 +593,6 @@ int efx_net_stop(struct net_device *net_dev)
 	return 0;
 }
 
-/* Context: netif_tx_lock held, BHs disabled. */
-static void efx_watchdog(struct net_device *net_dev, unsigned int txqueue)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	netif_err(efx, tx_err, efx->net_dev,
-		  "TX stuck with port_enabled=%d: resetting channels\n",
-		  efx->port_enabled);
-
-	efx_schedule_reset(efx, RESET_TYPE_TX_WATCHDOG);
-}
-
-static int efx_set_mac_address(struct net_device *net_dev, void *data)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	struct sockaddr *addr = data;
-	u8 *new_addr = addr->sa_data;
-	u8 old_addr[6];
-	int rc;
-
-	if (!is_valid_ether_addr(new_addr)) {
-		netif_err(efx, drv, efx->net_dev,
-			  "invalid ethernet MAC address requested: %pM\n",
-			  new_addr);
-		return -EADDRNOTAVAIL;
-	}
-
-	/* save old address */
-	ether_addr_copy(old_addr, net_dev->dev_addr);
-	ether_addr_copy(net_dev->dev_addr, new_addr);
-	if (efx->type->set_mac_address) {
-		rc = efx->type->set_mac_address(efx);
-		if (rc) {
-			ether_addr_copy(net_dev->dev_addr, old_addr);
-			return rc;
-		}
-	}
-
-	/* Reconfigure the MAC */
-	mutex_lock(&efx->mac_lock);
-	efx_mac_reconfigure(efx);
-	mutex_unlock(&efx->mac_lock);
-
-	return 0;
-}
-
-/* Context: netif_addr_lock held, BHs disabled. */
-static void efx_set_rx_mode(struct net_device *net_dev)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	if (efx->port_enabled)
-		queue_work(efx->workqueue, &efx->mac_work);
-	/* Otherwise efx_start_port() will do this */
-}
-
-static int efx_set_features(struct net_device *net_dev, netdev_features_t data)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	int rc;
-
-	/* If disabling RX n-tuple filtering, clear existing filters */
-	if (net_dev->features & ~data & NETIF_F_NTUPLE) {
-		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
-		if (rc)
-			return rc;
-	}
-
-	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
-	 * If rx-fcs is changed, mac_reconfigure updates that too.
-	 */
-	if ((net_dev->features ^ data) & (NETIF_F_HW_VLAN_CTAG_FILTER |
-					  NETIF_F_RXFCS)) {
-		/* efx_set_rx_mode() will schedule MAC work to update filters
-		 * when a new features are finally set in net_dev.
-		 */
-		efx_set_rx_mode(net_dev);
-	}
-
-	return 0;
-}
-
-static int efx_get_phys_port_id(struct net_device *net_dev,
-				struct netdev_phys_item_id *ppid)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	if (efx->type->get_phys_port_id)
-		return efx->type->get_phys_port_id(efx, ppid);
-	else
-		return -EOPNOTSUPP;
-}
-
-static int efx_get_phys_port_name(struct net_device *net_dev,
-				  char *name, size_t len)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	if (snprintf(name, len, "p%u", efx->port_num) >= len)
-		return -EINVAL;
-	return 0;
-}
-
 static int efx_vlan_rx_add_vid(struct net_device *net_dev, __be16 proto, u16 vid)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index e8be786582c0..e7e7d8d1a07b 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -36,13 +36,6 @@ static inline void efx_rx_flush_packet(struct efx_channel *channel)
 		__efx_rx_packet(channel);
 }
 
-#define EFX_MAX_DMAQ_SIZE 4096UL
-#define EFX_DEFAULT_DMAQ_SIZE 1024UL
-#define EFX_MIN_DMAQ_SIZE 512UL
-
-#define EFX_MAX_EVQ_SIZE 16384UL
-#define EFX_MIN_EVQ_SIZE 512UL
-
 /* Maximum number of TCP segments we support for soft-TSO */
 #define EFX_TSO_MAX_SEGS	100
 
@@ -166,10 +159,6 @@ int efx_init_irq_moderation(struct efx_nic *efx, unsigned int tx_usecs,
 void efx_get_irq_moderation(struct efx_nic *efx, unsigned int *tx_usecs,
 			    unsigned int *rx_usecs, bool *rx_adaptive);
 
-/* Dummy PHY ops for PHY drivers */
-int efx_port_dummy_op_int(struct efx_nic *efx);
-void efx_port_dummy_op_void(struct efx_nic *efx);
-
 /* Update the generic software stats in the passed stats array */
 void efx_update_sw_stats(struct efx_nic *efx, u64 *stats);
 
@@ -196,21 +185,6 @@ static inline unsigned int efx_vf_size(struct efx_nic *efx)
 }
 #endif
 
-static inline void efx_schedule_channel(struct efx_channel *channel)
-{
-	netif_vdbg(channel->efx, intr, channel->efx->net_dev,
-		   "channel %d scheduling NAPI poll on CPU%d\n",
-		   channel->channel, raw_smp_processor_id());
-
-	napi_schedule(&channel->napi_str);
-}
-
-static inline void efx_schedule_channel_irq(struct efx_channel *channel)
-{
-	channel->event_test_cpu = raw_smp_processor_id();
-	efx_schedule_channel(channel);
-}
-
 static inline void efx_device_detach_sync(struct efx_nic *efx)
 {
 	struct net_device *dev = efx->net_dev;
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 88ade7f41819..251e37bc7048 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -162,6 +162,76 @@ static void efx_mac_work(struct work_struct *data)
 	mutex_unlock(&efx->mac_lock);
 }
 
+int efx_set_mac_address(struct net_device *net_dev, void *data)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	struct sockaddr *addr = data;
+	u8 *new_addr = addr->sa_data;
+	u8 old_addr[6];
+	int rc;
+
+	if (!is_valid_ether_addr(new_addr)) {
+		netif_err(efx, drv, efx->net_dev,
+			  "invalid ethernet MAC address requested: %pM\n",
+			  new_addr);
+		return -EADDRNOTAVAIL;
+	}
+
+	/* save old address */
+	ether_addr_copy(old_addr, net_dev->dev_addr);
+	ether_addr_copy(net_dev->dev_addr, new_addr);
+	if (efx->type->set_mac_address) {
+		rc = efx->type->set_mac_address(efx);
+		if (rc) {
+			ether_addr_copy(net_dev->dev_addr, old_addr);
+			return rc;
+		}
+	}
+
+	/* Reconfigure the MAC */
+	mutex_lock(&efx->mac_lock);
+	efx_mac_reconfigure(efx);
+	mutex_unlock(&efx->mac_lock);
+
+	return 0;
+}
+
+/* Context: netif_addr_lock held, BHs disabled. */
+void efx_set_rx_mode(struct net_device *net_dev)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	if (efx->port_enabled)
+		queue_work(efx->workqueue, &efx->mac_work);
+	/* Otherwise efx_start_port() will do this */
+}
+
+int efx_set_features(struct net_device *net_dev, netdev_features_t data)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	int rc;
+
+	/* If disabling RX n-tuple filtering, clear existing filters */
+	if (net_dev->features & ~data & NETIF_F_NTUPLE) {
+		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
+		if (rc)
+			return rc;
+	}
+
+	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
+	 * If rx-fcs is changed, mac_reconfigure updates that too.
+	 */
+	if ((net_dev->features ^ data) & (NETIF_F_HW_VLAN_CTAG_FILTER |
+					  NETIF_F_RXFCS)) {
+		/* efx_set_rx_mode() will schedule MAC work to update filters
+		 * when a new features are finally set in net_dev.
+		 */
+		efx_set_rx_mode(net_dev);
+	}
+
+	return 0;
+}
+
 /* This ensures that the kernel is kept informed (via
  * netif_carrier_on/off) of the link status, and also maintains the
  * link status's stop on the port's TX queue.
@@ -650,6 +720,18 @@ void efx_reset_down(struct efx_nic *efx, enum reset_type method)
 	efx->type->fini(efx);
 }
 
+/* Context: netif_tx_lock held, BHs disabled. */
+void efx_watchdog(struct net_device *net_dev, unsigned int txqueue)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	netif_err(efx, tx_err, efx->net_dev,
+		  "TX stuck with port_enabled=%d: resetting channels\n",
+		  efx->port_enabled);
+
+	efx_schedule_reset(efx, RESET_TYPE_TX_WATCHDOG);
+}
+
 /* This function will always ensure that the locks acquired in
  * efx_reset_down() are released. A failure return code indicates
  * that we were unable to reinitialise the hardware, and the
@@ -1221,3 +1303,23 @@ const struct pci_error_handlers efx_err_handlers = {
 	.slot_reset	= efx_io_slot_reset,
 	.resume		= efx_io_resume,
 };
+
+int efx_get_phys_port_id(struct net_device *net_dev,
+			 struct netdev_phys_item_id *ppid)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	if (efx->type->get_phys_port_id)
+		return efx->type->get_phys_port_id(efx, ppid);
+	else
+		return -EOPNOTSUPP;
+}
+
+int efx_get_phys_port_name(struct net_device *net_dev, char *name, size_t len)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	if (snprintf(name, len, "p%u", efx->port_num) >= len)
+		return -EINVAL;
+	return 0;
+}
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 68af2af3b5da..73c355fc2590 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -18,6 +18,13 @@ int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev,
 		    struct net_device *net_dev);
 void efx_fini_struct(struct efx_nic *efx);
 
+#define EFX_MAX_DMAQ_SIZE 4096UL
+#define EFX_DEFAULT_DMAQ_SIZE 1024UL
+#define EFX_MIN_DMAQ_SIZE 512UL
+
+#define EFX_MAX_EVQ_SIZE 16384UL
+#define EFX_MIN_EVQ_SIZE 512UL
+
 void efx_link_clear_advertising(struct efx_nic *efx);
 void efx_link_set_wanted_fc(struct efx_nic *efx, u8);
 
@@ -46,10 +53,15 @@ int efx_reconfigure_port(struct efx_nic *efx);
 
 int efx_try_recovery(struct efx_nic *efx);
 void efx_reset_down(struct efx_nic *efx, enum reset_type method);
+void efx_watchdog(struct net_device *net_dev, unsigned int txqueue);
 int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok);
 int efx_reset(struct efx_nic *efx, enum reset_type method);
 void efx_schedule_reset(struct efx_nic *efx, enum reset_type type);
 
+/* Dummy PHY ops for PHY drivers */
+int efx_port_dummy_op_int(struct efx_nic *efx);
+void efx_port_dummy_op_void(struct efx_nic *efx);
+
 static inline int efx_check_disabled(struct efx_nic *efx)
 {
 	if (efx->state == STATE_DISABLED || efx->state == STATE_RECOVERY) {
@@ -60,6 +72,21 @@ static inline int efx_check_disabled(struct efx_nic *efx)
 	return 0;
 }
 
+static inline void efx_schedule_channel(struct efx_channel *channel)
+{
+	netif_vdbg(channel->efx, intr, channel->efx->net_dev,
+		   "channel %d scheduling NAPI poll on CPU%d\n",
+		   channel->channel, raw_smp_processor_id());
+
+	napi_schedule(&channel->napi_str);
+}
+
+static inline void efx_schedule_channel_irq(struct efx_channel *channel)
+{
+	channel->event_test_cpu = raw_smp_processor_id();
+	efx_schedule_channel(channel);
+}
+
 #ifdef CONFIG_SFC_MCDI_LOGGING
 void efx_init_mcdi_logging(struct efx_nic *efx);
 void efx_fini_mcdi_logging(struct efx_nic *efx);
@@ -69,9 +96,18 @@ static inline void efx_fini_mcdi_logging(struct efx_nic *efx) {}
 #endif
 
 void efx_mac_reconfigure(struct efx_nic *efx);
+int efx_set_mac_address(struct net_device *net_dev, void *data);
+void efx_set_rx_mode(struct net_device *net_dev);
+int efx_set_features(struct net_device *net_dev, netdev_features_t data);
 void efx_link_status_changed(struct efx_nic *efx);
 unsigned int efx_xdp_max_mtu(struct efx_nic *efx);
 int efx_change_mtu(struct net_device *net_dev, int new_mtu);
 
 extern const struct pci_error_handlers efx_err_handlers;
+
+int efx_get_phys_port_id(struct net_device *net_dev,
+			 struct netdev_phys_item_id *ppid);
+
+int efx_get_phys_port_name(struct net_device *net_dev,
+			   char *name, size_t len);
 #endif

