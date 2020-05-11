Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD611CD9CE
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgEKM2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:28:32 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:38840 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728084AbgEKM2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:28:31 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9A7C02004D;
        Mon, 11 May 2020 12:28:29 +0000 (UTC)
Received: from us4-mdac16-10.at1.mdlocal (unknown [10.110.49.192])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9B45F800A3;
        Mon, 11 May 2020 12:28:29 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.9])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2CB40100072;
        Mon, 11 May 2020 12:28:29 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D2124580077;
        Mon, 11 May 2020 12:28:28 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 May
 2020 13:28:24 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 1/8] sfc: move vport_id to struct efx_nic
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Message-ID: <3c1d729f-e9d6-1f28-bba3-429fa368e2bd@solarflare.com>
Date:   Mon, 11 May 2020 13:28:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25412.003
X-TM-AS-Result: No-13.658700-8.000000-10
X-TMASE-MatchedRID: dARgauwPvtYfs6+GayVk3fgAhuaFie7SSWg+u4ir2NNjLp8Cm8vwFwoe
        RRhCZWIBnvBWG5GT8Jdw5T4Iaj538mJZXQNDzktSGjzBgnFZvQ5caNB/u5yQq6uPvo9L6iaIIqm
        Bfx8U8pnRkO/NjySKHJBn3dCbIPvndQ7q2iLB02+qDSBu0tUhr3316REeU5CRh19HA2YmPg1v57
        Saw7/JOgVgJPeVoo1fHx0vMFFLlvWNBnVioBmwYWFdfLBMkul8NV9S7O+u3KZGM2uNXRqsUlP/j
        QIxrWZIuUiKiiymDZwJanOooGMDfMk5DoLS5FXGogGd8wIUGIJKgIbix5+XxD2yosu2E9kKAGle
        XRTdRFGucSJjn5zXbb2elKEoCgKdg83Zr5OBrdIWqJ/PBjhtWpnaxzJFBx6vn16ev4OGXQZVBTx
        VtaxF+JozoVrmuhaSP5zyOvOAp95oai+EYvM3lmsi7j4330URELbqrOgWzyfg91xayX4L801zo9
        VwQLtwtLSk5XwoIsETus3vaVuwOkCNNxx1aIBVNDrSVZCgbSu0Kkhb3AaXpkP2I+K5e/OB6bTc8
        Gbqmtni8zVgXoAltkWL4rBlm20vjaPj0W1qn0Q7AFczfjr/7FsA4CNFRqz/1FvANKsLth7sck8Q
        YTYA7CVWehqjYCZVjshRgJB3nWs=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--13.658700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25412.003
X-MDID: 1589200109-8lVGeX3pk4v7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove some usage of ef10-specific nic_data structs from common MCDI
 functions, in preparation for using them from a non-EF10 driver.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c           | 16 +++++++-------
 drivers/net/ethernet/sfc/ef10_sriov.c     | 27 +++++++++++------------
 drivers/net/ethernet/sfc/mcdi_filters.c   |  5 ++---
 drivers/net/ethernet/sfc/mcdi_functions.c |  8 ++-----
 drivers/net/ethernet/sfc/mcdi_port.c      |  7 ++----
 drivers/net/ethernet/sfc/net_driver.h     |  2 ++
 drivers/net/ethernet/sfc/nic.h            |  2 --
 7 files changed, 29 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 3f16bd807c6e..0ad311ff6796 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -553,7 +553,7 @@ static int efx_ef10_probe(struct efx_nic *efx)
 
 	efx->rss_context.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 
-	nic_data->vport_id = EVB_PORT_ID_ASSIGNED;
+	efx->vport_id = EVB_PORT_ID_ASSIGNED;
 
 	/* In case we're recovering from a crash (kexec), we want to
 	 * cancel any outstanding request by the previous user of this
@@ -1335,7 +1335,7 @@ static void efx_ef10_table_reset_mc_allocations(struct efx_nic *efx)
 
 	/* Driver-created vswitches and vports must be re-created */
 	nic_data->must_probe_vswitching = true;
-	nic_data->vport_id = EVB_PORT_ID_ASSIGNED;
+	efx->vport_id = EVB_PORT_ID_ASSIGNED;
 #ifdef CONFIG_SFC_SRIOV
 	if (nic_data->vf)
 		for (i = 0; i < efx->vf_count; i++)
@@ -3158,22 +3158,22 @@ static int efx_ef10_vport_set_mac_address(struct efx_nic *efx)
 	efx_mcdi_filter_table_remove(efx);
 	up_write(&efx->filter_sem);
 
-	rc = efx_ef10_vadaptor_free(efx, nic_data->vport_id);
+	rc = efx_ef10_vadaptor_free(efx, efx->vport_id);
 	if (rc)
 		goto restore_filters;
 
 	ether_addr_copy(mac_old, nic_data->vport_mac);
-	rc = efx_ef10_vport_del_mac(efx, nic_data->vport_id,
+	rc = efx_ef10_vport_del_mac(efx, efx->vport_id,
 				    nic_data->vport_mac);
 	if (rc)
 		goto restore_vadaptor;
 
-	rc = efx_ef10_vport_add_mac(efx, nic_data->vport_id,
+	rc = efx_ef10_vport_add_mac(efx, efx->vport_id,
 				    efx->net_dev->dev_addr);
 	if (!rc) {
 		ether_addr_copy(nic_data->vport_mac, efx->net_dev->dev_addr);
 	} else {
-		rc2 = efx_ef10_vport_add_mac(efx, nic_data->vport_id, mac_old);
+		rc2 = efx_ef10_vport_add_mac(efx, efx->vport_id, mac_old);
 		if (rc2) {
 			/* Failed to add original MAC, so clear vport_mac */
 			eth_zero_addr(nic_data->vport_mac);
@@ -3182,7 +3182,7 @@ static int efx_ef10_vport_set_mac_address(struct efx_nic *efx)
 	}
 
 restore_vadaptor:
-	rc2 = efx_ef10_vadaptor_alloc(efx, nic_data->vport_id);
+	rc2 = efx_ef10_vadaptor_alloc(efx, efx->vport_id);
 	if (rc2)
 		goto reset_nic;
 restore_filters:
@@ -3225,7 +3225,7 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 	ether_addr_copy(MCDI_PTR(inbuf, VADAPTOR_SET_MAC_IN_MACADDR),
 			efx->net_dev->dev_addr);
 	MCDI_SET_DWORD(inbuf, VADAPTOR_SET_MAC_IN_UPSTREAM_PORT_ID,
-		       nic_data->vport_id);
+		       efx->vport_id);
 	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_VADAPTOR_SET_MAC, inbuf,
 				sizeof(inbuf), NULL, 0, NULL);
 
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 4580b30caae1..21fa6c0e8873 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -232,15 +232,14 @@ static int efx_ef10_sriov_restore_vf_vswitching(struct efx_nic *efx)
 
 static int efx_ef10_vadaptor_alloc_set_features(struct efx_nic *efx)
 {
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	u32 port_flags;
 	int rc;
 
-	rc = efx_ef10_vadaptor_alloc(efx, nic_data->vport_id);
+	rc = efx_ef10_vadaptor_alloc(efx, efx->vport_id);
 	if (rc)
 		goto fail_vadaptor_alloc;
 
-	rc = efx_ef10_vadaptor_query(efx, nic_data->vport_id,
+	rc = efx_ef10_vadaptor_query(efx, efx->vport_id,
 				     &port_flags, NULL, NULL);
 	if (rc)
 		goto fail_vadaptor_query;
@@ -281,11 +280,11 @@ int efx_ef10_vswitching_probe_pf(struct efx_nic *efx)
 
 	rc = efx_ef10_vport_alloc(efx, EVB_PORT_ID_ASSIGNED,
 				  MC_CMD_VPORT_ALLOC_IN_VPORT_TYPE_NORMAL,
-				  EFX_EF10_NO_VLAN, &nic_data->vport_id);
+				  EFX_EF10_NO_VLAN, &efx->vport_id);
 	if (rc)
 		goto fail2;
 
-	rc = efx_ef10_vport_add_mac(efx, nic_data->vport_id, net_dev->dev_addr);
+	rc = efx_ef10_vport_add_mac(efx, efx->vport_id, net_dev->dev_addr);
 	if (rc)
 		goto fail3;
 	ether_addr_copy(nic_data->vport_mac, net_dev->dev_addr);
@@ -296,11 +295,11 @@ int efx_ef10_vswitching_probe_pf(struct efx_nic *efx)
 
 	return 0;
 fail4:
-	efx_ef10_vport_del_mac(efx, nic_data->vport_id, nic_data->vport_mac);
+	efx_ef10_vport_del_mac(efx, efx->vport_id, nic_data->vport_mac);
 	eth_zero_addr(nic_data->vport_mac);
 fail3:
-	efx_ef10_vport_free(efx, nic_data->vport_id);
-	nic_data->vport_id = EVB_PORT_ID_ASSIGNED;
+	efx_ef10_vport_free(efx, efx->vport_id);
+	efx->vport_id = EVB_PORT_ID_ASSIGNED;
 fail2:
 	efx_ef10_vswitch_free(efx, EVB_PORT_ID_ASSIGNED);
 fail1:
@@ -355,22 +354,22 @@ void efx_ef10_vswitching_remove_pf(struct efx_nic *efx)
 
 	efx_ef10_sriov_free_vf_vswitching(efx);
 
-	efx_ef10_vadaptor_free(efx, nic_data->vport_id);
+	efx_ef10_vadaptor_free(efx, efx->vport_id);
 
-	if (nic_data->vport_id == EVB_PORT_ID_ASSIGNED)
+	if (efx->vport_id == EVB_PORT_ID_ASSIGNED)
 		return; /* No vswitch was ever created */
 
 	if (!is_zero_ether_addr(nic_data->vport_mac)) {
-		efx_ef10_vport_del_mac(efx, nic_data->vport_id,
+		efx_ef10_vport_del_mac(efx, efx->vport_id,
 				       efx->net_dev->dev_addr);
 		eth_zero_addr(nic_data->vport_mac);
 	}
-	efx_ef10_vport_free(efx, nic_data->vport_id);
-	nic_data->vport_id = EVB_PORT_ID_ASSIGNED;
+	efx_ef10_vport_free(efx, efx->vport_id);
+	efx->vport_id = EVB_PORT_ID_ASSIGNED;
 
 	/* Only free the vswitch if no VFs are assigned */
 	if (!pci_vfs_assigned(efx->pci_dev))
-		efx_ef10_vswitch_free(efx, nic_data->vport_id);
+		efx_ef10_vswitch_free(efx, efx->vport_id);
 }
 
 void efx_ef10_vswitching_remove_vf(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 4310ae5bd898..e6268556b030 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -186,7 +186,6 @@ static void efx_mcdi_filter_push_prep(struct efx_nic *efx,
 				      struct efx_rss_context *ctx,
 				      bool replacing)
 {
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	u32 flags = spec->flags;
 
 	memset(inbuf, 0, MC_CMD_FILTER_OP_EXT_IN_LEN);
@@ -211,7 +210,7 @@ static void efx_mcdi_filter_push_prep(struct efx_nic *efx,
 		efx_mcdi_filter_push_prep_set_match_fields(efx, spec, inbuf);
 	}
 
-	MCDI_SET_DWORD(inbuf, FILTER_OP_IN_PORT_ID, nic_data->vport_id);
+	MCDI_SET_DWORD(inbuf, FILTER_OP_IN_PORT_ID, efx->vport_id);
 	MCDI_SET_DWORD(inbuf, FILTER_OP_IN_RX_DEST,
 		       spec->dmaq_id == EFX_FILTER_RX_DMAQ_ID_DROP ?
 		       MC_CMD_FILTER_OP_IN_RX_DEST_DROP :
@@ -1944,7 +1943,7 @@ static int efx_mcdi_filter_alloc_rss_context(struct efx_nic *efx, bool exclusive
 		return -EOPNOTSUPP;
 
 	MCDI_SET_DWORD(inbuf, RSS_CONTEXT_ALLOC_IN_UPSTREAM_PORT_ID,
-		       nic_data->vport_id);
+		       efx->vport_id);
 	MCDI_SET_DWORD(inbuf, RSS_CONTEXT_ALLOC_IN_TYPE, alloc_type);
 	MCDI_SET_DWORD(inbuf, RSS_CONTEXT_ALLOC_IN_NUM_QUEUES, rss_spread);
 
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index dcfe78b0fa5a..962d8395d958 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -168,21 +168,18 @@ int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
 	size_t entries = tx_queue->txd.buf.len / EFX_BUF_SIZE;
 	struct efx_channel *channel = tx_queue->channel;
 	struct efx_nic *efx = tx_queue->efx;
-	struct efx_ef10_nic_data *nic_data;
 	dma_addr_t dma_addr;
 	size_t inlen;
 	int rc, i;
 
 	BUILD_BUG_ON(MC_CMD_INIT_TXQ_OUT_LEN != 0);
 
-	nic_data = efx->nic_data;
-
 	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_SIZE, tx_queue->ptr_mask + 1);
 	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_TARGET_EVQ, channel->channel);
 	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_LABEL, tx_queue->queue);
 	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_INSTANCE, tx_queue->queue);
 	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_OWNER_ID, 0);
-	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_PORT_ID, nic_data->vport_id);
+	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_PORT_ID, efx->vport_id);
 
 	dma_addr = tx_queue->txd.buf.dma_addr;
 
@@ -276,7 +273,6 @@ void efx_mcdi_rx_init(struct efx_rx_queue *rx_queue)
 	struct efx_channel *channel = efx_rx_queue_channel(rx_queue);
 	size_t entries = rx_queue->rxd.buf.len / EFX_BUF_SIZE;
 	struct efx_nic *efx = rx_queue->efx;
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	dma_addr_t dma_addr;
 	size_t inlen;
 	int rc;
@@ -295,7 +291,7 @@ void efx_mcdi_rx_init(struct efx_rx_queue *rx_queue)
 			      INIT_RXQ_IN_FLAG_PREFIX, 1,
 			      INIT_RXQ_IN_FLAG_TIMESTAMP, 1);
 	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_OWNER_ID, 0);
-	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_PORT_ID, nic_data->vport_id);
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_PORT_ID, efx->vport_id);
 
 	dma_addr = rx_queue->rxd.buf.dma_addr;
 
diff --git a/drivers/net/ethernet/sfc/mcdi_port.c b/drivers/net/ethernet/sfc/mcdi_port.c
index ab5227b13ae6..b807871d8f69 100644
--- a/drivers/net/ethernet/sfc/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/mcdi_port.c
@@ -722,11 +722,8 @@ static int efx_mcdi_mac_stats(struct efx_nic *efx,
 			      MAC_STATS_IN_PERIOD_MS, period);
 	MCDI_SET_DWORD(inbuf, MAC_STATS_IN_DMA_LEN, dma_len);
 
-	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0) {
-		struct efx_ef10_nic_data *nic_data = efx->nic_data;
-
-		MCDI_SET_DWORD(inbuf, MAC_STATS_IN_PORT_ID, nic_data->vport_id);
-	}
+	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0)
+		MCDI_SET_DWORD(inbuf, MAC_STATS_IN_PORT_ID, efx->vport_id);
 
 	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_MAC_STATS, inbuf, sizeof(inbuf),
 				NULL, 0, NULL);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index b084e623b5f4..d43f22c8f31c 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -887,6 +887,7 @@ struct efx_async_filter_insertion {
  * @rss_context: Main RSS context.  Its @list member is the head of the list of
  *	RSS contexts created by user requests
  * @rss_lock: Protects custom RSS context software state in @rss_context.list
+ * @vport_id: The function's vport ID, only relevant for PFs
  * @int_error_count: Number of internal errors seen recently
  * @int_error_expire: Time at which error count will be expired
  * @irq_soft_enabled: Are IRQs soft-enabled? If not, IRQ handler will
@@ -1044,6 +1045,7 @@ struct efx_nic {
 	bool rx_scatter;
 	struct efx_rss_context rss_context;
 	struct mutex rss_lock;
+	u32 vport_id;
 
 	unsigned int_error_count;
 	unsigned long int_error_expire;
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index 6670fda8f35a..9e2e387a4b1c 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -385,7 +385,6 @@ enum {
  * %MC_CMD_GET_CAPABILITIES response)
  * @rx_dpcpu_fw_id: Firmware ID of the RxDPCPU
  * @tx_dpcpu_fw_id: Firmware ID of the TxDPCPU
- * @vport_id: The function's vport ID, only relevant for PFs
  * @must_probe_vswitching: Flag: vswitching has yet to be setup after MC reboot
  * @pf_index: The number for this PF, or the parent PF if this is a VF
 #ifdef CONFIG_SFC_SRIOV
@@ -423,7 +422,6 @@ struct efx_ef10_nic_data {
 	u32 datapath_caps2;
 	unsigned int rx_dpcpu_fw_id;
 	unsigned int tx_dpcpu_fw_id;
-	unsigned int vport_id;
 	bool must_probe_vswitching;
 	unsigned int pf_index;
 	u8 port_id[ETH_ALEN];

