Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 599AB136E01
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgAJN11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:27:27 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:33396 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727874AbgAJN11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 08:27:27 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7524780059;
        Fri, 10 Jan 2020 13:27:25 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 10 Jan 2020 13:27:20 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 4/9] sfc: move various functions
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Message-ID: <cec1a298-3fe7-a5c3-7490-c60839ac6a6b@solarflare.com>
Date:   Fri, 10 Jan 2020 13:27:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25158.003
X-TM-AS-Result: No-5.267000-8.000000-10
X-TMASE-MatchedRID: GK1I8dluVn6h9oPbMj7PPPCoOvLLtsMh7qPKKDEKjrIGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc5aBeN7o13CD7rC27CKHcBxNDrSVZCgbStrTWaGefu3pAQsw9A3PIlLa3A
        6hcNu8nDo3VsvuZ936M0CjKwcYFKxltWAy648k/xsExK7i/Tm06+LpFmmk3oAOF0RIPSotdMcQo
        TKCLE09Wdy8F9gKiEdyQA7dQEiQ1JlOqEvi1x67Qe06kQGFaIWyiKgKtIyB4rLPKykcur4n2zkk
        6oK3QRZFpdsGPF4e5395Ot0PMSatuVsdeNpdvi/hI7tQ/PFU9N7xIKEgZq/AeOeTF42zeolwaOq
        ae+SkG2ZO1URQec1gCPKoyMf3YI+dohsSPGTO+FWfOVCJoTbWgl4bPfy+SGvIS2LNsBlD7FAafc
        xQhn7e3w9yt5z/fWEQQHZX2QdSQFccQ8eam5EfTl/1fD/GopdkvL+Ti49jcrEQdG7H66TyH4gKq
        42LRYksFfp8Op4nDLZYIEsjIWZ8kdi41oy8RVobuwYgHp3Ezt+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.267000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25158.003
X-MDID: 1578662846-irhQF5FCpbiX
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c             | 21 ++--------
 drivers/net/ethernet/sfc/efx.c              | 11 -----
 drivers/net/ethernet/sfc/efx_common.c       | 10 +++++
 drivers/net/ethernet/sfc/efx_common.h       |  2 +
 drivers/net/ethernet/sfc/mcdi.h             |  2 -
 drivers/net/ethernet/sfc/mcdi_functions.c   | 23 +++++++++++
 drivers/net/ethernet/sfc/mcdi_functions.h   |  1 +
 drivers/net/ethernet/sfc/mcdi_port.c        | 45 ---------------------
 drivers/net/ethernet/sfc/mcdi_port_common.c | 45 +++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi_port_common.h |  3 ++
 drivers/net/ethernet/sfc/siena.c            |  1 +
 11 files changed, 88 insertions(+), 76 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index dc037dd927f8..6853b5cb3ac8 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -277,24 +277,9 @@ static int efx_ef10_init_datapath_caps(struct efx_nic *efx)
 		u8 vi_window_mode = MCDI_BYTE(outbuf,
 				GET_CAPABILITIES_V3_OUT_VI_WINDOW_MODE);
 
-		switch (vi_window_mode) {
-		case MC_CMD_GET_CAPABILITIES_V3_OUT_VI_WINDOW_MODE_8K:
-			efx->vi_stride = 8192;
-			break;
-		case MC_CMD_GET_CAPABILITIES_V3_OUT_VI_WINDOW_MODE_16K:
-			efx->vi_stride = 16384;
-			break;
-		case MC_CMD_GET_CAPABILITIES_V3_OUT_VI_WINDOW_MODE_64K:
-			efx->vi_stride = 65536;
-			break;
-		default:
-			netif_err(efx, probe, efx->net_dev,
-				  "Unrecognised VI window mode %d\n",
-				  vi_window_mode);
-			return -EIO;
-		}
-		netif_dbg(efx, probe, efx->net_dev, "vi_stride = %u\n",
-			  efx->vi_stride);
+		rc = efx_mcdi_window_mode_to_stride(efx, vi_window_mode);
+		if (rc)
+			return rc;
 	} else {
 		/* keep default VI stride */
 		netif_dbg(efx, probe, efx->net_dev,
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 4affae76b03c..7ad97090ab52 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -692,17 +692,6 @@ int efx_net_stop(struct net_device *net_dev)
 	return 0;
 }
 
-/* Context: process, dev_base_lock or RTNL held, non-blocking. */
-static void efx_net_stats(struct net_device *net_dev,
-			  struct rtnl_link_stats64 *stats)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	spin_lock_bh(&efx->stats_lock);
-	efx->type->update_stats(efx, NULL, stats);
-	spin_unlock_bh(&efx->stats_lock);
-}
-
 /* Context: netif_tx_lock held, BHs disabled. */
 static void efx_watchdog(struct net_device *net_dev, unsigned int txqueue)
 {
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 33b523b6d0a8..0875507efd0a 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -454,6 +454,16 @@ void efx_stop_all(struct efx_nic *efx)
 	efx_stop_datapath(efx);
 }
 
+/* Context: process, dev_base_lock or RTNL held, non-blocking. */
+void efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	spin_lock_bh(&efx->stats_lock);
+	efx->type->update_stats(efx, NULL, stats);
+	spin_unlock_bh(&efx->stats_lock);
+}
+
 /* Push loopback/power/transmit disable settings to the PHY, and reconfigure
  * the MAC appropriately. All other PHY configuration changes are pushed
  * through phy_op->set_settings(), and pushed asynchronously to the MAC
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index e03404d1dc0a..32a23ec9b104 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -21,6 +21,8 @@ void efx_fini_struct(struct efx_nic *efx);
 void efx_start_all(struct efx_nic *efx);
 void efx_stop_all(struct efx_nic *efx);
 
+void efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats);
+
 int efx_create_reset_workqueue(void);
 void efx_queue_reset_work(struct efx_nic *efx);
 void efx_flush_reset_workqueue(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 65e454a062f7..54a45010b576 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -348,8 +348,6 @@ void efx_mcdi_port_remove(struct efx_nic *efx);
 int efx_mcdi_port_reconfigure(struct efx_nic *efx);
 u32 efx_mcdi_phy_get_caps(struct efx_nic *efx);
 void efx_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev);
-int efx_mcdi_set_mac(struct efx_nic *efx);
-#define EFX_MC_STATS_GENERATION_INVALID ((__force __le64)(-1))
 void efx_mcdi_mac_start_stats(struct efx_nic *efx);
 void efx_mcdi_mac_stop_stats(struct efx_nic *efx);
 void efx_mcdi_mac_pull_stats(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index f022e2b9e975..0f571864df22 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -347,3 +347,26 @@ void efx_mcdi_rx_fini(struct efx_rx_queue *rx_queue)
 	efx_mcdi_display_error(efx, MC_CMD_FINI_RXQ, MC_CMD_FINI_RXQ_IN_LEN,
 			       outbuf, outlen, rc);
 }
+
+int efx_mcdi_window_mode_to_stride(struct efx_nic *efx, u8 vi_window_mode)
+{
+	switch (vi_window_mode) {
+	case MC_CMD_GET_CAPABILITIES_V3_OUT_VI_WINDOW_MODE_8K:
+		efx->vi_stride = 8192;
+		break;
+	case MC_CMD_GET_CAPABILITIES_V3_OUT_VI_WINDOW_MODE_16K:
+		efx->vi_stride = 16384;
+		break;
+	case MC_CMD_GET_CAPABILITIES_V3_OUT_VI_WINDOW_MODE_64K:
+		efx->vi_stride = 65536;
+		break;
+	default:
+		netif_err(efx, probe, efx->net_dev,
+			  "Unrecognised VI window mode %d\n",
+			  vi_window_mode);
+		return -EIO;
+	}
+	netif_dbg(efx, probe, efx->net_dev, "vi_stride = %u\n",
+		  efx->vi_stride);
+	return 0;
+}
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.h b/drivers/net/ethernet/sfc/mcdi_functions.h
index 3c9e760238e7..0396294bfdcd 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.h
+++ b/drivers/net/ethernet/sfc/mcdi_functions.h
@@ -26,5 +26,6 @@ int efx_mcdi_rx_probe(struct efx_rx_queue *rx_queue);
 void efx_mcdi_rx_init(struct efx_rx_queue *rx_queue);
 void efx_mcdi_rx_remove(struct efx_rx_queue *rx_queue);
 void efx_mcdi_rx_fini(struct efx_rx_queue *rx_queue);
+int efx_mcdi_window_mode_to_stride(struct efx_nic *efx, u8 vi_window_mode);
 
 #endif
diff --git a/drivers/net/ethernet/sfc/mcdi_port.c b/drivers/net/ethernet/sfc/mcdi_port.c
index 0db6068a668d..a5785205c32b 100644
--- a/drivers/net/ethernet/sfc/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/mcdi_port.c
@@ -708,51 +708,6 @@ void efx_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev)
 	efx_link_status_changed(efx);
 }
 
-int efx_mcdi_set_mac(struct efx_nic *efx)
-{
-	u32 fcntl;
-	MCDI_DECLARE_BUF(cmdbytes, MC_CMD_SET_MAC_IN_LEN);
-
-	BUILD_BUG_ON(MC_CMD_SET_MAC_OUT_LEN != 0);
-
-	/* This has no effect on EF10 */
-	ether_addr_copy(MCDI_PTR(cmdbytes, SET_MAC_IN_ADDR),
-			efx->net_dev->dev_addr);
-
-	MCDI_SET_DWORD(cmdbytes, SET_MAC_IN_MTU,
-			EFX_MAX_FRAME_LEN(efx->net_dev->mtu));
-	MCDI_SET_DWORD(cmdbytes, SET_MAC_IN_DRAIN, 0);
-
-	/* Set simple MAC filter for Siena */
-	MCDI_POPULATE_DWORD_1(cmdbytes, SET_MAC_IN_REJECT,
-			      SET_MAC_IN_REJECT_UNCST, efx->unicast_filter);
-
-	MCDI_POPULATE_DWORD_1(cmdbytes, SET_MAC_IN_FLAGS,
-			      SET_MAC_IN_FLAG_INCLUDE_FCS,
-			      !!(efx->net_dev->features & NETIF_F_RXFCS));
-
-	switch (efx->wanted_fc) {
-	case EFX_FC_RX | EFX_FC_TX:
-		fcntl = MC_CMD_FCNTL_BIDIR;
-		break;
-	case EFX_FC_RX:
-		fcntl = MC_CMD_FCNTL_RESPOND;
-		break;
-	default:
-		fcntl = MC_CMD_FCNTL_OFF;
-		break;
-	}
-	if (efx->wanted_fc & EFX_FC_AUTO)
-		fcntl = MC_CMD_FCNTL_AUTO;
-	if (efx->fc_disable)
-		fcntl = MC_CMD_FCNTL_OFF;
-
-	MCDI_SET_DWORD(cmdbytes, SET_MAC_IN_FCNTL, fcntl);
-
-	return efx_mcdi_rpc(efx, MC_CMD_SET_MAC, cmdbytes, sizeof(cmdbytes),
-			    NULL, 0, NULL);
-}
-
 bool efx_mcdi_mac_check_fault(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 3b1c559246b4..0f3237fc68af 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -474,6 +474,51 @@ int efx_mcdi_phy_test_alive(struct efx_nic *efx)
 	return 0;
 }
 
+int efx_mcdi_set_mac(struct efx_nic *efx)
+{
+	u32 fcntl;
+	MCDI_DECLARE_BUF(cmdbytes, MC_CMD_SET_MAC_IN_LEN);
+
+	BUILD_BUG_ON(MC_CMD_SET_MAC_OUT_LEN != 0);
+
+	/* This has no effect on EF10 */
+	ether_addr_copy(MCDI_PTR(cmdbytes, SET_MAC_IN_ADDR),
+			efx->net_dev->dev_addr);
+
+	MCDI_SET_DWORD(cmdbytes, SET_MAC_IN_MTU,
+		       EFX_MAX_FRAME_LEN(efx->net_dev->mtu));
+	MCDI_SET_DWORD(cmdbytes, SET_MAC_IN_DRAIN, 0);
+
+	/* Set simple MAC filter for Siena */
+	MCDI_POPULATE_DWORD_1(cmdbytes, SET_MAC_IN_REJECT,
+			      SET_MAC_IN_REJECT_UNCST, efx->unicast_filter);
+
+	MCDI_POPULATE_DWORD_1(cmdbytes, SET_MAC_IN_FLAGS,
+			      SET_MAC_IN_FLAG_INCLUDE_FCS,
+			      !!(efx->net_dev->features & NETIF_F_RXFCS));
+
+	switch (efx->wanted_fc) {
+	case EFX_FC_RX | EFX_FC_TX:
+		fcntl = MC_CMD_FCNTL_BIDIR;
+		break;
+	case EFX_FC_RX:
+		fcntl = MC_CMD_FCNTL_RESPOND;
+		break;
+	default:
+		fcntl = MC_CMD_FCNTL_OFF;
+		break;
+	}
+	if (efx->wanted_fc & EFX_FC_AUTO)
+		fcntl = MC_CMD_FCNTL_AUTO;
+	if (efx->fc_disable)
+		fcntl = MC_CMD_FCNTL_OFF;
+
+	MCDI_SET_DWORD(cmdbytes, SET_MAC_IN_FCNTL, fcntl);
+
+	return efx_mcdi_rpc(efx, MC_CMD_SET_MAC, cmdbytes, sizeof(cmdbytes),
+			    NULL, 0, NULL);
+}
+
 /* Get physical port number (EF10 only; on Siena it is same as PF number) */
 int efx_mcdi_port_get_number(struct efx_nic *efx)
 {
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.h b/drivers/net/ethernet/sfc/mcdi_port_common.h
index 10772de94b2c..6b08a2b7eddf 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.h
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.h
@@ -28,6 +28,8 @@ struct efx_mcdi_phy_data {
 	u32 forced_cap;
 };
 
+#define EFX_MC_STATS_GENERATION_INVALID ((__force __le64)(-1))
+
 int efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg);
 void efx_link_set_advertising(struct efx_nic *efx,
 			      const unsigned long *advertising);
@@ -48,6 +50,7 @@ bool efx_mcdi_phy_poll(struct efx_nic *efx);
 int efx_mcdi_phy_get_fecparam(struct efx_nic *efx,
 			      struct ethtool_fecparam *fec);
 int efx_mcdi_phy_test_alive(struct efx_nic *efx);
+int efx_mcdi_set_mac(struct efx_nic *efx);
 int efx_mcdi_port_get_number(struct efx_nic *efx);
 
 #endif
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index 810f6fc8a937..baa464161626 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -21,6 +21,7 @@
 #include "workarounds.h"
 #include "mcdi.h"
 #include "mcdi_pcol.h"
+#include "mcdi_port_common.h"
 #include "selftest.h"
 #include "siena_sriov.h"
 
-- 
2.20.1


