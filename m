Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABCD1148C39
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 17:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388563AbgAXQe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 11:34:29 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:60510 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387551AbgAXQe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 11:34:29 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6BB756C00C4;
        Fri, 24 Jan 2020 16:34:22 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 24 Jan 2020 16:34:16 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH v2 net-next 1/3] sfc: rename mcdi filtering functions/structs
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <bd446796-af44-148d-5cc2-23b0cd770494@solarflare.com>
Message-ID: <71c9cd1d-8eb3-e8a2-c570-cbbfd356e898@solarflare.com>
Date:   Fri, 24 Jan 2020 16:34:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <bd446796-af44-148d-5cc2-23b0cd770494@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25186.003
X-TM-AS-Result: No-10.379500-8.000000-10
X-TMASE-MatchedRID: zoWRxPXkaF7oV3o5SLrUYvGSfx66m+aMeouvej40T4gd0WOKRkwsh3lo
        OvA4aBJJrdoLblq9S5oYXDtt8hcavrhh/IK6O5SRPS2a8KDKuXx7xIKEgZq/AYwnGKAoIKJLXWj
        vA8TpWFj5ZsqO5ZgLGZf1EF8dUCKB8VHgTnw7NShHAa5T9Fxbli9Xl/s/QdUMuXED6mZp0b+wV7
        nfUWvsNJwsMiEmmRZzaD5n048aELXUNmgmRKOtrs36paW7ZnFoMVx/3ZYby79eOpN49cSJ3RX0C
        /Gbw7IjwxdbIYn61qWP9aElA3hZZ8yB+MYaW/KQPlrzaogdiJxJ4iN6CGH/M3xOX3FGv4IO3VhC
        XjP25gQeaa1Clu1UucVDpPV0Bo5Zm/zfUniRcsVIcJTn2HkqsW9Xf86cwKVaV4i674aSi3wHWE1
        QDpRvmSgRsjesVhHfUZOPhy91qnH81yTTTVDjvBXCv0BjRkS9Z/rAPfrtWC09sqLLthPZCuml/E
        2CK49bDE/1MkAf0dbniA36f6y3d9kPVp3JBnY+F9p7X9UAWGW5ouJiWapZ99DE+G2E0QU33c00l
        AOLPF6qAInjn/m+DC+RWfSImaSL1g7S1fm4He0WGaCgD30OglJAsn89ih94I8VPrDO8ZmKf6eu+
        NowNgSmnqbB0p3kwIJ/Q4I0/+CsNKpiUoeCS//SG/+sPtZVkmdrHMkUHHq/AJMh4mAwEGyW/ZZW
        DOccH4p4eUTSRNOKbZkVCatrPSEyFChF/DndaLCDCajDZWp1JaD67iKvY0/nqcdWkRgUefjMV1k
        cGGWuRC2bW8UQOqaqoC+cmIWKe10G5DxR2TN+eAiCmPx4NwLTrdaH1ZWqCKPfQRTd/WW8XvQkGi
        3tjz46HM5rqDwqtlExlQIQeRG0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.379500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25186.003
X-MDID: 1579883665-2A6Ab8ljT5Oz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor style fixes included due to name lengths changing.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c | 564 ++++++++++++++++----------------
 1 file changed, 285 insertions(+), 279 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 82063212cac4..6285a0f14c07 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -45,7 +45,7 @@ enum {
  * Huntington has a single 8K filter table shared between all filter
  * types and both ports.
  */
-#define HUNT_FILTER_TBL_ROWS 8192
+#define EFX_MCDI_FILTER_TBL_ROWS 8192
 
 #define EFX_EF10_FILTER_ID_INVALID 0xffff
 
@@ -58,7 +58,7 @@ struct efx_ef10_vlan {
 	u16 vid;
 };
 
-enum efx_ef10_default_filters {
+enum efx_mcdi_filter_default_filters {
 	EFX_EF10_BCAST,
 	EFX_EF10_UCDEF,
 	EFX_EF10_MCDEF,
@@ -79,7 +79,7 @@ enum efx_ef10_default_filters {
 };
 
 /* Per-VLAN filters information */
-struct efx_ef10_filter_vlan {
+struct efx_mcdi_filter_vlan {
 	struct list_head list;
 	u16 vid;
 	u16 uc[EFX_EF10_FILTER_DEV_UC_MAX];
@@ -87,11 +87,11 @@ struct efx_ef10_filter_vlan {
 	u16 default_filters[EFX_EF10_NUM_DEFAULT_FILTERS];
 };
 
-struct efx_ef10_dev_addr {
+struct efx_mcdi_dev_addr {
 	u8 addr[ETH_ALEN];
 };
 
-struct efx_ef10_filter_table {
+struct efx_mcdi_filter_table {
 /* The MCDI match masks supported by this fw & hw, in order of priority */
 	u32 rx_match_mcdi_flags[
 		MC_CMD_GET_PARSER_DISP_INFO_OUT_SUPPORTED_MATCHES_MAXNUM * 2];
@@ -107,8 +107,8 @@ struct efx_ef10_filter_table {
 		u64 handle;		/* firmware handle */
 	} *entry;
 /* Shadow of net_device address lists, guarded by mac_lock */
-	struct efx_ef10_dev_addr dev_uc_list[EFX_EF10_FILTER_DEV_UC_MAX];
-	struct efx_ef10_dev_addr dev_mc_list[EFX_EF10_FILTER_DEV_MC_MAX];
+	struct efx_mcdi_dev_addr dev_uc_list[EFX_EF10_FILTER_DEV_UC_MAX];
+	struct efx_mcdi_dev_addr dev_mc_list[EFX_EF10_FILTER_DEV_MC_MAX];
 	int dev_uc_count;
 	int dev_mc_count;
 	bool uc_promisc;
@@ -123,28 +123,28 @@ struct efx_ef10_filter_table {
 /* An arbitrary search limit for the software hash table */
 #define EFX_EF10_FILTER_SEARCH_LIMIT 200
 
-static void efx_ef10_rx_free_indir_table(struct efx_nic *efx);
-static void efx_ef10_filter_table_remove(struct efx_nic *efx);
-static int efx_ef10_filter_add_vlan(struct efx_nic *efx, u16 vid);
-static void efx_ef10_filter_del_vlan_internal(struct efx_nic *efx,
-					      struct efx_ef10_filter_vlan *vlan);
-static void efx_ef10_filter_del_vlan(struct efx_nic *efx, u16 vid);
+static void efx_mcdi_rx_free_indir_table(struct efx_nic *efx);
+static void efx_mcdi_filter_table_remove(struct efx_nic *efx);
+static int efx_mcdi_filter_add_vlan(struct efx_nic *efx, u16 vid);
+static void efx_mcdi_filter_del_vlan_internal(struct efx_nic *efx,
+					      struct efx_mcdi_filter_vlan *vlan);
+static void efx_mcdi_filter_del_vlan(struct efx_nic *efx, u16 vid);
 static int efx_ef10_set_udp_tnl_ports(struct efx_nic *efx, bool unloading);
 
 static u32 efx_ef10_filter_get_unsafe_id(u32 filter_id)
 {
 	WARN_ON_ONCE(filter_id == EFX_EF10_FILTER_ID_INVALID);
-	return filter_id & (HUNT_FILTER_TBL_ROWS - 1);
+	return filter_id & (EFX_MCDI_FILTER_TBL_ROWS - 1);
 }
 
 static unsigned int efx_ef10_filter_get_unsafe_pri(u32 filter_id)
 {
-	return filter_id / (HUNT_FILTER_TBL_ROWS * 2);
+	return filter_id / (EFX_MCDI_FILTER_TBL_ROWS * 2);
 }
 
 static u32 efx_ef10_make_filter_id(unsigned int pri, u16 idx)
 {
-	return pri * HUNT_FILTER_TBL_ROWS * 2 + idx;
+	return pri * EFX_MCDI_FILTER_TBL_ROWS * 2 + idx;
 }
 
 static int efx_ef10_get_warm_boot_count(struct efx_nic *efx)
@@ -547,7 +547,7 @@ static int efx_ef10_add_vlan(struct efx_nic *efx, u16 vid)
 	if (efx->filter_state) {
 		mutex_lock(&efx->mac_lock);
 		down_write(&efx->filter_sem);
-		rc = efx_ef10_filter_add_vlan(efx, vlan->vid);
+		rc = efx_mcdi_filter_add_vlan(efx, vlan->vid);
 		up_write(&efx->filter_sem);
 		mutex_unlock(&efx->mac_lock);
 		if (rc)
@@ -576,7 +576,7 @@ static void efx_ef10_del_vlan_internal(struct efx_nic *efx,
 
 	if (efx->filter_state) {
 		down_write(&efx->filter_sem);
-		efx_ef10_filter_del_vlan(efx, vlan->vid);
+		efx_mcdi_filter_del_vlan(efx, vlan->vid);
 		up_write(&efx->filter_sem);
 	}
 
@@ -1039,7 +1039,7 @@ static void efx_ef10_remove(struct efx_nic *efx)
 
 	efx_mcdi_mon_remove(efx);
 
-	efx_ef10_rx_free_indir_table(efx);
+	efx_mcdi_rx_free_indir_table(efx);
 
 	if (nic_data->wc_membase)
 		iounmap(nic_data->wc_membase);
@@ -1427,7 +1427,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 	return 0;
 }
 
-static void efx_ef10_reset_mc_allocations(struct efx_nic *efx)
+static void efx_ef10_table_reset_mc_allocations(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 #ifdef CONFIG_SFC_SRIOV
@@ -1508,7 +1508,7 @@ static int efx_ef10_reset(struct efx_nic *efx, enum reset_type reset_type)
 	 */
 	if ((reset_type == RESET_TYPE_ALL ||
 	     reset_type == RESET_TYPE_MCDI_TIMEOUT) && !rc)
-		efx_ef10_reset_mc_allocations(efx);
+		efx_ef10_table_reset_mc_allocations(efx);
 	return rc;
 }
 
@@ -2124,7 +2124,7 @@ static void efx_ef10_mcdi_reboot_detected(struct efx_nic *efx)
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 
 	/* All our allocations have been reset */
-	efx_ef10_reset_mc_allocations(efx);
+	efx_ef10_table_reset_mc_allocations(efx);
 
 	/* The datapath firmware might have been changed */
 	nic_data->must_check_datapath_caps = true;
@@ -2513,7 +2513,8 @@ static void efx_ef10_tx_write(struct efx_tx_queue *tx_queue)
 					 RSS_MODE_HASH_ADDRS << MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_UDP_IPV6_RSS_MODE_LBN |\
 					 RSS_MODE_HASH_ADDRS << MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_OTHER_IPV6_RSS_MODE_LBN)
 
-static int efx_ef10_get_rss_flags(struct efx_nic *efx, u32 context, u32 *flags)
+static int efx_mcdi_get_rss_context_flags(struct efx_nic *efx, u32 context,
+					  u32 *flags)
 {
 	/* Firmware had a bug (sfc bug 61952) where it would not actually
 	 * fill in the flags field in the response to MC_CMD_RSS_CONTEXT_GET_FLAGS.
@@ -2559,15 +2560,15 @@ static int efx_ef10_get_rss_flags(struct efx_nic *efx, u32 context, u32 *flags)
  * Defaults are 4-tuple for TCP and 2-tuple for UDP and other-IP, so we
  * just need to set the UDP ports flags (for both IP versions).
  */
-static void efx_ef10_set_rss_flags(struct efx_nic *efx,
-				   struct efx_rss_context *ctx)
+static void efx_mcdi_set_rss_context_flags(struct efx_nic *efx,
+					   struct efx_rss_context *ctx)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_LEN);
 	u32 flags;
 
 	BUILD_BUG_ON(MC_CMD_RSS_CONTEXT_SET_FLAGS_OUT_LEN != 0);
 
-	if (efx_ef10_get_rss_flags(efx, ctx->context_id, &flags) != 0)
+	if (efx_mcdi_get_rss_context_flags(efx, ctx->context_id, &flags) != 0)
 		return;
 	MCDI_SET_DWORD(inbuf, RSS_CONTEXT_SET_FLAGS_IN_RSS_CONTEXT_ID,
 		       ctx->context_id);
@@ -2580,9 +2581,9 @@ static void efx_ef10_set_rss_flags(struct efx_nic *efx,
 		ctx->rx_hash_udp_4tuple = true;
 }
 
-static int efx_ef10_alloc_rss_context(struct efx_nic *efx, bool exclusive,
-				      struct efx_rss_context *ctx,
-				      unsigned *context_size)
+static int efx_mcdi_filter_alloc_rss_context(struct efx_nic *efx, bool exclusive,
+					     struct efx_rss_context *ctx,
+					     unsigned *context_size)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_RSS_CONTEXT_ALLOC_IN_LEN);
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_RSS_CONTEXT_ALLOC_OUT_LEN);
@@ -2628,12 +2629,12 @@ static int efx_ef10_alloc_rss_context(struct efx_nic *efx, bool exclusive,
 
 	if (nic_data->datapath_caps &
 	    1 << MC_CMD_GET_CAPABILITIES_OUT_ADDITIONAL_RSS_MODES_LBN)
-		efx_ef10_set_rss_flags(efx, ctx);
+		efx_mcdi_set_rss_context_flags(efx, ctx);
 
 	return 0;
 }
 
-static int efx_ef10_free_rss_context(struct efx_nic *efx, u32 context)
+static int efx_mcdi_filter_free_rss_context(struct efx_nic *efx, u32 context)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_RSS_CONTEXT_FREE_IN_LEN);
 
@@ -2643,8 +2644,8 @@ static int efx_ef10_free_rss_context(struct efx_nic *efx, u32 context)
 			    NULL, 0, NULL);
 }
 
-static int efx_ef10_populate_rss_table(struct efx_nic *efx, u32 context,
-				       const u32 *rx_indir_table, const u8 *key)
+static int efx_mcdi_filter_populate_rss_table(struct efx_nic *efx, u32 context,
+					      const u32 *rx_indir_table, const u8 *key)
 {
 	MCDI_DECLARE_BUF(tablebuf, MC_CMD_RSS_CONTEXT_SET_TABLE_IN_LEN);
 	MCDI_DECLARE_BUF(keybuf, MC_CMD_RSS_CONTEXT_SET_KEY_IN_LEN);
@@ -2681,23 +2682,25 @@ static int efx_ef10_populate_rss_table(struct efx_nic *efx, u32 context,
 			    sizeof(keybuf), NULL, 0, NULL);
 }
 
-static void efx_ef10_rx_free_indir_table(struct efx_nic *efx)
+static void efx_mcdi_rx_free_indir_table(struct efx_nic *efx)
 {
 	int rc;
 
 	if (efx->rss_context.context_id != EFX_MCDI_RSS_CONTEXT_INVALID) {
-		rc = efx_ef10_free_rss_context(efx, efx->rss_context.context_id);
+		rc = efx_mcdi_filter_free_rss_context(efx,
+						   efx->rss_context.context_id);
 		WARN_ON(rc != 0);
 	}
 	efx->rss_context.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 }
 
-static int efx_ef10_rx_push_shared_rss_config(struct efx_nic *efx,
-					      unsigned *context_size)
+static int efx_mcdi_filter_rx_push_shared_rss_config(struct efx_nic *efx,
+						     unsigned *context_size)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	int rc = efx_ef10_alloc_rss_context(efx, false, &efx->rss_context,
-					    context_size);
+	int rc = efx_mcdi_filter_alloc_rss_context(efx, false,
+						   &efx->rss_context,
+						   context_size);
 
 	if (rc != 0)
 		return rc;
@@ -2707,9 +2710,9 @@ static int efx_ef10_rx_push_shared_rss_config(struct efx_nic *efx,
 	return 0;
 }
 
-static int efx_ef10_rx_push_exclusive_rss_config(struct efx_nic *efx,
-						 const u32 *rx_indir_table,
-						 const u8 *key)
+static int efx_mcdi_filter_rx_push_exclusive_rss_config(struct efx_nic *efx,
+						        const u32 *rx_indir_table,
+						        const u8 *key)
 {
 	u32 old_rx_rss_context = efx->rss_context.context_id;
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
@@ -2717,22 +2720,24 @@ static int efx_ef10_rx_push_exclusive_rss_config(struct efx_nic *efx,
 
 	if (efx->rss_context.context_id == EFX_MCDI_RSS_CONTEXT_INVALID ||
 	    !nic_data->rx_rss_context_exclusive) {
-		rc = efx_ef10_alloc_rss_context(efx, true, &efx->rss_context,
-						NULL);
+		rc = efx_mcdi_filter_alloc_rss_context(efx, true,
+						       &efx->rss_context,
+						       NULL);
 		if (rc == -EOPNOTSUPP)
 			return rc;
 		else if (rc != 0)
 			goto fail1;
 	}
 
-	rc = efx_ef10_populate_rss_table(efx, efx->rss_context.context_id,
-					 rx_indir_table, key);
+	rc = efx_mcdi_filter_populate_rss_table(efx,
+						efx->rss_context.context_id,
+						rx_indir_table, key);
 	if (rc != 0)
 		goto fail2;
 
 	if (efx->rss_context.context_id != old_rx_rss_context &&
 	    old_rx_rss_context != EFX_MCDI_RSS_CONTEXT_INVALID)
-		WARN_ON(efx_ef10_free_rss_context(efx, old_rx_rss_context) != 0);
+		WARN_ON(efx_mcdi_filter_free_rss_context(efx, old_rx_rss_context) != 0);
 	nic_data->rx_rss_context_exclusive = true;
 	if (rx_indir_table != efx->rss_context.rx_indir_table)
 		memcpy(efx->rss_context.rx_indir_table, rx_indir_table,
@@ -2745,7 +2750,7 @@ static int efx_ef10_rx_push_exclusive_rss_config(struct efx_nic *efx,
 
 fail2:
 	if (old_rx_rss_context != efx->rss_context.context_id) {
-		WARN_ON(efx_ef10_free_rss_context(efx, efx->rss_context.context_id) != 0);
+		WARN_ON(efx_mcdi_filter_free_rss_context(efx, efx->rss_context.context_id) != 0);
 		efx->rss_context.context_id = old_rx_rss_context;
 	}
 fail1:
@@ -2753,7 +2758,7 @@ static int efx_ef10_rx_push_exclusive_rss_config(struct efx_nic *efx,
 	return rc;
 }
 
-static int efx_ef10_rx_push_rss_context_config(struct efx_nic *efx,
+static int efx_mcdi_rx_push_rss_context_config(struct efx_nic *efx,
 					       struct efx_rss_context *ctx,
 					       const u32 *rx_indir_table,
 					       const u8 *key)
@@ -2763,16 +2768,16 @@ static int efx_ef10_rx_push_rss_context_config(struct efx_nic *efx,
 	WARN_ON(!mutex_is_locked(&efx->rss_lock));
 
 	if (ctx->context_id == EFX_MCDI_RSS_CONTEXT_INVALID) {
-		rc = efx_ef10_alloc_rss_context(efx, true, ctx, NULL);
+		rc = efx_mcdi_filter_alloc_rss_context(efx, true, ctx, NULL);
 		if (rc)
 			return rc;
 	}
 
 	if (!rx_indir_table) /* Delete this context */
-		return efx_ef10_free_rss_context(efx, ctx->context_id);
+		return efx_mcdi_filter_free_rss_context(efx, ctx->context_id);
 
-	rc = efx_ef10_populate_rss_table(efx, ctx->context_id,
-					 rx_indir_table, key);
+	rc = efx_mcdi_filter_populate_rss_table(efx, ctx->context_id,
+						rx_indir_table, key);
 	if (rc)
 		return rc;
 
@@ -2783,7 +2788,7 @@ static int efx_ef10_rx_push_rss_context_config(struct efx_nic *efx,
 	return 0;
 }
 
-static int efx_ef10_rx_pull_rss_context_config(struct efx_nic *efx,
+static int efx_mcdi_rx_pull_rss_context_config(struct efx_nic *efx,
 					       struct efx_rss_context *ctx)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_RSS_CONTEXT_GET_TABLE_IN_LEN);
@@ -2835,17 +2840,17 @@ static int efx_ef10_rx_pull_rss_context_config(struct efx_nic *efx,
 	return 0;
 }
 
-static int efx_ef10_rx_pull_rss_config(struct efx_nic *efx)
+static int efx_mcdi_rx_pull_rss_config(struct efx_nic *efx)
 {
 	int rc;
 
 	mutex_lock(&efx->rss_lock);
-	rc = efx_ef10_rx_pull_rss_context_config(efx, &efx->rss_context);
+	rc = efx_mcdi_rx_pull_rss_context_config(efx, &efx->rss_context);
 	mutex_unlock(&efx->rss_lock);
 	return rc;
 }
 
-static void efx_ef10_rx_restore_rss_contexts(struct efx_nic *efx)
+static void efx_mcdi_rx_restore_rss_contexts(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	struct efx_rss_context *ctx;
@@ -2860,7 +2865,7 @@ static void efx_ef10_rx_restore_rss_contexts(struct efx_nic *efx)
 		/* previous NIC RSS context is gone */
 		ctx->context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 		/* so try to allocate a new one */
-		rc = efx_ef10_rx_push_rss_context_config(efx, ctx,
+		rc = efx_mcdi_rx_push_rss_context_config(efx, ctx,
 							 ctx->rx_indir_table,
 							 ctx->rx_hash_key);
 		if (rc)
@@ -2872,7 +2877,7 @@ static void efx_ef10_rx_restore_rss_contexts(struct efx_nic *efx)
 	nic_data->must_restore_rss_contexts = false;
 }
 
-static int efx_ef10_pf_rx_push_rss_config(struct efx_nic *efx, bool user,
+static int efx_mcdi_pf_rx_push_rss_config(struct efx_nic *efx, bool user,
 					  const u32 *rx_indir_table,
 					  const u8 *key)
 {
@@ -2884,7 +2889,7 @@ static int efx_ef10_pf_rx_push_rss_config(struct efx_nic *efx, bool user,
 	if (!key)
 		key = efx->rss_context.rx_hash_key;
 
-	rc = efx_ef10_rx_push_exclusive_rss_config(efx, rx_indir_table, key);
+	rc = efx_mcdi_filter_rx_push_exclusive_rss_config(efx, rx_indir_table, key);
 
 	if (rc == -ENOBUFS && !user) {
 		unsigned context_size;
@@ -2897,7 +2902,8 @@ static int efx_ef10_pf_rx_push_rss_config(struct efx_nic *efx, bool user,
 			mismatch = rx_indir_table[i] !=
 				ethtool_rxfh_indir_default(i, efx->rss_spread);
 
-		rc = efx_ef10_rx_push_shared_rss_config(efx, &context_size);
+		rc = efx_mcdi_filter_rx_push_shared_rss_config(efx,
+							       &context_size);
 		if (rc == 0) {
 			if (context_size != efx->rss_spread)
 				netif_warn(efx, probe, efx->net_dev,
@@ -2921,7 +2927,7 @@ static int efx_ef10_pf_rx_push_rss_config(struct efx_nic *efx, bool user,
 	return rc;
 }
 
-static int efx_ef10_vf_rx_push_rss_config(struct efx_nic *efx, bool user,
+static int efx_mcdi_vf_rx_push_rss_config(struct efx_nic *efx, bool user,
 					  const u32 *rx_indir_table
 					  __attribute__ ((unused)),
 					  const u8 *key
@@ -2931,7 +2937,7 @@ static int efx_ef10_vf_rx_push_rss_config(struct efx_nic *efx, bool user,
 		return -EOPNOTSUPP;
 	if (efx->rss_context.context_id != EFX_MCDI_RSS_CONTEXT_INVALID)
 		return 0;
-	return efx_ef10_rx_push_shared_rss_config(efx, NULL);
+	return efx_mcdi_filter_rx_push_shared_rss_config(efx, NULL);
 }
 
 /* This creates an entry in the RX descriptor queue */
@@ -3711,7 +3717,7 @@ static bool efx_ef10_filter_is_exclusive(const struct efx_filter_spec *spec)
 }
 
 static struct efx_filter_spec *
-efx_ef10_filter_entry_spec(const struct efx_ef10_filter_table *table,
+efx_ef10_filter_entry_spec(const struct efx_mcdi_filter_table *table,
 			   unsigned int filter_idx)
 {
 	return (struct efx_filter_spec *)(table->entry[filter_idx].spec &
@@ -3719,14 +3725,14 @@ efx_ef10_filter_entry_spec(const struct efx_ef10_filter_table *table,
 }
 
 static unsigned int
-efx_ef10_filter_entry_flags(const struct efx_ef10_filter_table *table,
+efx_ef10_filter_entry_flags(const struct efx_mcdi_filter_table *table,
 			   unsigned int filter_idx)
 {
 	return table->entry[filter_idx].spec & EFX_EF10_FILTER_FLAGS;
 }
 
 static void
-efx_ef10_filter_set_entry(struct efx_ef10_filter_table *table,
+efx_ef10_filter_set_entry(struct efx_mcdi_filter_table *table,
 			  unsigned int filter_idx,
 			  const struct efx_filter_spec *spec,
 			  unsigned int flags)
@@ -3832,7 +3838,7 @@ efx_ef10_filter_push_prep_set_match_fields(struct efx_nic *efx,
 		       match_fields);
 }
 
-static void efx_ef10_filter_push_prep(struct efx_nic *efx,
+static void efx_mcdi_filter_push_prep(struct efx_nic *efx,
 				      const struct efx_filter_spec *spec,
 				      efx_dword_t *inbuf, u64 handle,
 				      struct efx_rss_context *ctx,
@@ -3881,7 +3887,7 @@ static void efx_ef10_filter_push_prep(struct efx_nic *efx,
 		MCDI_SET_DWORD(inbuf, FILTER_OP_IN_RX_CONTEXT, ctx->context_id);
 }
 
-static int efx_ef10_filter_push(struct efx_nic *efx,
+static int efx_mcdi_filter_push(struct efx_nic *efx,
 				const struct efx_filter_spec *spec, u64 *handle,
 				struct efx_rss_context *ctx, bool replacing)
 {
@@ -3890,7 +3896,7 @@ static int efx_ef10_filter_push(struct efx_nic *efx,
 	size_t outlen;
 	int rc;
 
-	efx_ef10_filter_push_prep(efx, spec, inbuf, *handle, ctx, replacing);
+	efx_mcdi_filter_push_prep(efx, spec, inbuf, *handle, ctx, replacing);
 	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_FILTER_OP, inbuf, sizeof(inbuf),
 				outbuf, sizeof(outbuf), &outlen);
 	if (rc && spec->priority != EFX_FILTER_PRI_HINT)
@@ -3903,7 +3909,7 @@ static int efx_ef10_filter_push(struct efx_nic *efx,
 	return rc;
 }
 
-static u32 efx_ef10_filter_mcdi_flags_from_spec(const struct efx_filter_spec *spec)
+static u32 efx_mcdi_filter_mcdi_flags_from_spec(const struct efx_filter_spec *spec)
 {
 	enum efx_encap_type encap_type = efx_filter_get_encap_type(spec);
 	unsigned int match_flags = spec->match_flags;
@@ -3963,10 +3969,10 @@ static u32 efx_ef10_filter_mcdi_flags_from_spec(const struct efx_filter_spec *sp
 	return mcdi_flags;
 }
 
-static int efx_ef10_filter_pri(struct efx_ef10_filter_table *table,
+static int efx_mcdi_filter_pri(struct efx_mcdi_filter_table *table,
 			       const struct efx_filter_spec *spec)
 {
-	u32 mcdi_flags = efx_ef10_filter_mcdi_flags_from_spec(spec);
+	u32 mcdi_flags = efx_mcdi_filter_mcdi_flags_from_spec(spec);
 	unsigned int match_pri;
 
 	for (match_pri = 0;
@@ -3978,13 +3984,13 @@ static int efx_ef10_filter_pri(struct efx_ef10_filter_table *table,
 	return -EPROTONOSUPPORT;
 }
 
-static s32 efx_ef10_filter_insert_locked(struct efx_nic *efx,
+static s32 efx_mcdi_filter_insert_locked(struct efx_nic *efx,
 					 struct efx_filter_spec *spec,
 					 bool replace_equal)
 {
 	DECLARE_BITMAP(mc_rem_map, EFX_EF10_FILTER_SEARCH_LIMIT);
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	struct efx_ef10_filter_table *table;
+	struct efx_mcdi_filter_table *table;
 	struct efx_filter_spec *saved_spec;
 	struct efx_rss_context *ctx = NULL;
 	unsigned int match_pri, hash;
@@ -4008,7 +4014,7 @@ static s32 efx_ef10_filter_insert_locked(struct efx_nic *efx,
 		goto out_unlock;
 	}
 
-	rc = efx_ef10_filter_pri(table, spec);
+	rc = efx_mcdi_filter_pri(table, spec);
 	if (rc < 0)
 		goto out_unlock;
 	match_pri = rc;
@@ -4039,7 +4045,7 @@ static s32 efx_ef10_filter_insert_locked(struct efx_nic *efx,
 	 * else a free slot to insert at.
 	 */
 	for (depth = 1; depth < EFX_EF10_FILTER_SEARCH_LIMIT; depth++) {
-		i = (hash + depth) & (HUNT_FILTER_TBL_ROWS - 1);
+		i = (hash + depth) & (EFX_MCDI_FILTER_TBL_ROWS - 1);
 		saved_spec = efx_ef10_filter_entry_spec(table, i);
 
 		if (!saved_spec) {
@@ -4109,7 +4115,7 @@ static s32 efx_ef10_filter_insert_locked(struct efx_nic *efx,
 	efx_ef10_filter_set_entry(table, ins_index, saved_spec, priv_flags);
 
 	/* Actually insert the filter on the HW */
-	rc = efx_ef10_filter_push(efx, spec, &table->entry[ins_index].handle,
+	rc = efx_mcdi_filter_push(efx, spec, &table->entry[ins_index].handle,
 				  ctx, replacing);
 
 	if (rc == -EINVAL && nic_data->must_realloc_vis)
@@ -4156,7 +4162,7 @@ static s32 efx_ef10_filter_insert_locked(struct efx_nic *efx,
 			if (!test_bit(depth, mc_rem_map))
 				continue;
 
-			i = (hash + depth) & (HUNT_FILTER_TBL_ROWS - 1);
+			i = (hash + depth) & (EFX_MCDI_FILTER_TBL_ROWS - 1);
 			saved_spec = efx_ef10_filter_entry_spec(table, i);
 			priv_flags = efx_ef10_filter_entry_flags(table, i);
 
@@ -4191,20 +4197,20 @@ static s32 efx_ef10_filter_insert_locked(struct efx_nic *efx,
 	return rc;
 }
 
-static s32 efx_ef10_filter_insert(struct efx_nic *efx,
+static s32 efx_mcdi_filter_insert(struct efx_nic *efx,
 				  struct efx_filter_spec *spec,
 				  bool replace_equal)
 {
 	s32 ret;
 
 	down_read(&efx->filter_sem);
-	ret = efx_ef10_filter_insert_locked(efx, spec, replace_equal);
+	ret = efx_mcdi_filter_insert_locked(efx, spec, replace_equal);
 	up_read(&efx->filter_sem);
 
 	return ret;
 }
 
-static void efx_ef10_filter_update_rx_scatter(struct efx_nic *efx)
+static void efx_mcdi_update_rx_scatter(struct efx_nic *efx)
 {
 	/* no need to do anything here on EF10 */
 }
@@ -4216,12 +4222,12 @@ static void efx_ef10_filter_update_rx_scatter(struct efx_nic *efx)
  * Caller must hold efx->filter_sem for read, and efx->filter_state->lock
  * for write.
  */
-static int efx_ef10_filter_remove_internal(struct efx_nic *efx,
+static int efx_mcdi_filter_remove_internal(struct efx_nic *efx,
 					   unsigned int priority_mask,
 					   u32 filter_id, bool by_index)
 {
 	unsigned int filter_idx = efx_ef10_filter_get_unsafe_id(filter_id);
-	struct efx_ef10_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	MCDI_DECLARE_BUF(inbuf,
 			 MC_CMD_FILTER_OP_IN_HANDLE_OFST +
 			 MC_CMD_FILTER_OP_IN_HANDLE_LEN);
@@ -4232,7 +4238,7 @@ static int efx_ef10_filter_remove_internal(struct efx_nic *efx,
 	spec = efx_ef10_filter_entry_spec(table, filter_idx);
 	if (!spec ||
 	    (!by_index &&
-	     efx_ef10_filter_pri(table, spec) !=
+	     efx_mcdi_filter_pri(table, spec) !=
 	     efx_ef10_filter_get_unsafe_pri(filter_id)))
 		return -ENOENT;
 
@@ -4258,7 +4264,7 @@ static int efx_ef10_filter_remove_internal(struct efx_nic *efx,
 				   EFX_FILTER_FLAG_RX_RSS : 0));
 		new_spec.dmaq_id = 0;
 		new_spec.rss_context = 0;
-		rc = efx_ef10_filter_push(efx, &new_spec,
+		rc = efx_mcdi_filter_push(efx, &new_spec,
 					  &table->entry[filter_idx].handle,
 					  &efx->rss_context,
 					  true);
@@ -4291,17 +4297,17 @@ static int efx_ef10_filter_remove_internal(struct efx_nic *efx,
 	return rc;
 }
 
-static int efx_ef10_filter_remove_safe(struct efx_nic *efx,
+static int efx_mcdi_filter_remove_safe(struct efx_nic *efx,
 				       enum efx_filter_priority priority,
 				       u32 filter_id)
 {
-	struct efx_ef10_filter_table *table;
+	struct efx_mcdi_filter_table *table;
 	int rc;
 
 	down_read(&efx->filter_sem);
 	table = efx->filter_state;
 	down_write(&table->lock);
-	rc = efx_ef10_filter_remove_internal(efx, 1U << priority, filter_id,
+	rc = efx_mcdi_filter_remove_internal(efx, 1U << priority, filter_id,
 					     false);
 	up_write(&table->lock);
 	up_read(&efx->filter_sem);
@@ -4309,28 +4315,28 @@ static int efx_ef10_filter_remove_safe(struct efx_nic *efx,
 }
 
 /* Caller must hold efx->filter_sem for read */
-static void efx_ef10_filter_remove_unsafe(struct efx_nic *efx,
+static void efx_mcdi_filter_remove_unsafe(struct efx_nic *efx,
 					  enum efx_filter_priority priority,
 					  u32 filter_id)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 
 	if (filter_id == EFX_EF10_FILTER_ID_INVALID)
 		return;
 
 	down_write(&table->lock);
-	efx_ef10_filter_remove_internal(efx, 1U << priority, filter_id,
+	efx_mcdi_filter_remove_internal(efx, 1U << priority, filter_id,
 					true);
 	up_write(&table->lock);
 }
 
-static int efx_ef10_filter_get_safe(struct efx_nic *efx,
-				    enum efx_filter_priority priority,
-				    u32 filter_id, struct efx_filter_spec *spec)
+static int efx_mcdi_filter_get_safe(struct efx_nic *efx,
+			     	    enum efx_filter_priority priority,
+			     	    u32 filter_id, struct efx_filter_spec *spec)
 {
 	unsigned int filter_idx = efx_ef10_filter_get_unsafe_id(filter_id);
 	const struct efx_filter_spec *saved_spec;
-	struct efx_ef10_filter_table *table;
+	struct efx_mcdi_filter_table *table;
 	int rc;
 
 	down_read(&efx->filter_sem);
@@ -4338,7 +4344,7 @@ static int efx_ef10_filter_get_safe(struct efx_nic *efx,
 	down_read(&table->lock);
 	saved_spec = efx_ef10_filter_entry_spec(table, filter_idx);
 	if (saved_spec && saved_spec->priority == priority &&
-	    efx_ef10_filter_pri(table, saved_spec) ==
+	    efx_mcdi_filter_pri(table, saved_spec) ==
 	    efx_ef10_filter_get_unsafe_pri(filter_id)) {
 		*spec = *saved_spec;
 		rc = 0;
@@ -4350,10 +4356,10 @@ static int efx_ef10_filter_get_safe(struct efx_nic *efx,
 	return rc;
 }
 
-static int efx_ef10_filter_clear_rx(struct efx_nic *efx,
-				    enum efx_filter_priority priority)
+static int efx_mcdi_filter_clear_rx(struct efx_nic *efx,
+			     	    enum efx_filter_priority priority)
 {
-	struct efx_ef10_filter_table *table;
+	struct efx_mcdi_filter_table *table;
 	unsigned int priority_mask;
 	unsigned int i;
 	int rc;
@@ -4364,8 +4370,8 @@ static int efx_ef10_filter_clear_rx(struct efx_nic *efx,
 	down_read(&efx->filter_sem);
 	table = efx->filter_state;
 	down_write(&table->lock);
-	for (i = 0; i < HUNT_FILTER_TBL_ROWS; i++) {
-		rc = efx_ef10_filter_remove_internal(efx, priority_mask,
+	for (i = 0; i < EFX_MCDI_FILTER_TBL_ROWS; i++) {
+		rc = efx_mcdi_filter_remove_internal(efx, priority_mask,
 						     i, true);
 		if (rc && rc != -ENOENT)
 			break;
@@ -4377,17 +4383,17 @@ static int efx_ef10_filter_clear_rx(struct efx_nic *efx,
 	return rc;
 }
 
-static u32 efx_ef10_filter_count_rx_used(struct efx_nic *efx,
+static u32 efx_mcdi_filter_count_rx_used(struct efx_nic *efx,
 					 enum efx_filter_priority priority)
 {
-	struct efx_ef10_filter_table *table;
+	struct efx_mcdi_filter_table *table;
 	unsigned int filter_idx;
 	s32 count = 0;
 
 	down_read(&efx->filter_sem);
 	table = efx->filter_state;
 	down_read(&table->lock);
-	for (filter_idx = 0; filter_idx < HUNT_FILTER_TBL_ROWS; filter_idx++) {
+	for (filter_idx = 0; filter_idx < EFX_MCDI_FILTER_TBL_ROWS; filter_idx++) {
 		if (table->entry[filter_idx].spec &&
 		    efx_ef10_filter_entry_spec(table, filter_idx)->priority ==
 		    priority)
@@ -4398,18 +4404,18 @@ static u32 efx_ef10_filter_count_rx_used(struct efx_nic *efx,
 	return count;
 }
 
-static u32 efx_ef10_filter_get_rx_id_limit(struct efx_nic *efx)
+static u32 efx_mcdi_filter_get_rx_id_limit(struct efx_nic *efx)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 
-	return table->rx_match_count * HUNT_FILTER_TBL_ROWS * 2;
+	return table->rx_match_count * EFX_MCDI_FILTER_TBL_ROWS * 2;
 }
 
-static s32 efx_ef10_filter_get_rx_ids(struct efx_nic *efx,
+static s32 efx_mcdi_filter_get_rx_ids(struct efx_nic *efx,
 				      enum efx_filter_priority priority,
 				      u32 *buf, u32 size)
 {
-	struct efx_ef10_filter_table *table;
+	struct efx_mcdi_filter_table *table;
 	struct efx_filter_spec *spec;
 	unsigned int filter_idx;
 	s32 count = 0;
@@ -4418,7 +4424,7 @@ static s32 efx_ef10_filter_get_rx_ids(struct efx_nic *efx,
 	table = efx->filter_state;
 	down_read(&table->lock);
 
-	for (filter_idx = 0; filter_idx < HUNT_FILTER_TBL_ROWS; filter_idx++) {
+	for (filter_idx = 0; filter_idx < EFX_MCDI_FILTER_TBL_ROWS; filter_idx++) {
 		spec = efx_ef10_filter_entry_spec(table, filter_idx);
 		if (spec && spec->priority == priority) {
 			if (count == size) {
@@ -4427,7 +4433,7 @@ static s32 efx_ef10_filter_get_rx_ids(struct efx_nic *efx,
 			}
 			buf[count++] =
 				efx_ef10_make_filter_id(
-					efx_ef10_filter_pri(table, spec),
+					efx_mcdi_filter_pri(table, spec),
 					filter_idx);
 		}
 	}
@@ -4438,11 +4444,11 @@ static s32 efx_ef10_filter_get_rx_ids(struct efx_nic *efx,
 
 #ifdef CONFIG_RFS_ACCEL
 
-static bool efx_ef10_filter_rfs_expire_one(struct efx_nic *efx, u32 flow_id,
+static bool efx_mcdi_filter_rfs_expire_one(struct efx_nic *efx, u32 flow_id,
 					   unsigned int filter_idx)
 {
 	struct efx_filter_spec *spec, saved_spec;
-	struct efx_ef10_filter_table *table;
+	struct efx_mcdi_filter_table *table;
 	struct efx_arfs_rule *rule = NULL;
 	bool ret = true, force = false;
 	u16 arfs_id;
@@ -4487,7 +4493,7 @@ static bool efx_ef10_filter_rfs_expire_one(struct efx_nic *efx, u32 flow_id,
 	 * the rule is not removed by efx_rps_hash_del() below.
 	 */
 	if (ret)
-		ret = efx_ef10_filter_remove_internal(efx, 1U << spec->priority,
+		ret = efx_mcdi_filter_remove_internal(efx, 1U << spec->priority,
 						      filter_idx, true) == 0;
 	/* While we can't safely dereference rule (we dropped the lock), we can
 	 * still test it for NULL.
@@ -4506,7 +4512,7 @@ static bool efx_ef10_filter_rfs_expire_one(struct efx_nic *efx, u32 flow_id,
 
 #endif /* CONFIG_RFS_ACCEL */
 
-static int efx_ef10_filter_match_flags_from_mcdi(bool encap, u32 mcdi_flags)
+static int efx_mcdi_filter_match_flags_from_mcdi(bool encap, u32 mcdi_flags)
 {
 	int match_flags = 0;
 
@@ -4563,12 +4569,12 @@ static int efx_ef10_filter_match_flags_from_mcdi(bool encap, u32 mcdi_flags)
 	return match_flags;
 }
 
-static void efx_ef10_filter_cleanup_vlans(struct efx_nic *efx)
+static void efx_mcdi_filter_cleanup_vlans(struct efx_nic *efx)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
-	struct efx_ef10_filter_vlan *vlan, *next_vlan;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_vlan *vlan, *next_vlan;
 
-	/* See comment in efx_ef10_filter_table_remove() */
+	/* See comment in efx_mcdi_filter_table_remove() */
 	if (!efx_rwsem_assert_write_locked(&efx->filter_sem))
 		return;
 
@@ -4576,10 +4582,10 @@ static void efx_ef10_filter_cleanup_vlans(struct efx_nic *efx)
 		return;
 
 	list_for_each_entry_safe(vlan, next_vlan, &table->vlan_list, list)
-		efx_ef10_filter_del_vlan_internal(efx, vlan);
+		efx_mcdi_filter_del_vlan_internal(efx, vlan);
 }
 
-static bool efx_ef10_filter_match_supported(struct efx_ef10_filter_table *table,
+static bool efx_mcdi_filter_match_supported(struct efx_mcdi_filter_table *table,
 					    bool encap,
 					    enum efx_filter_match_flags match_flags)
 {
@@ -4589,7 +4595,7 @@ static bool efx_ef10_filter_match_supported(struct efx_ef10_filter_table *table,
 	for (match_pri = 0;
 	     match_pri < table->rx_match_count;
 	     match_pri++) {
-		mf = efx_ef10_filter_match_flags_from_mcdi(encap,
+		mf = efx_mcdi_filter_match_flags_from_mcdi(encap,
 				table->rx_match_mcdi_flags[match_pri]);
 		if (mf == match_flags)
 			return true;
@@ -4599,8 +4605,8 @@ static bool efx_ef10_filter_match_supported(struct efx_ef10_filter_table *table,
 }
 
 static int
-efx_ef10_filter_table_probe_matches(struct efx_nic *efx,
-				    struct efx_ef10_filter_table *table,
+efx_mcdi_filter_table_probe_matches(struct efx_nic *efx,
+				    struct efx_mcdi_filter_table *table,
 				    bool encap)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_PARSER_DISP_INFO_IN_LEN);
@@ -4629,7 +4635,7 @@ efx_ef10_filter_table_probe_matches(struct efx_nic *efx,
 				outbuf,
 				GET_PARSER_DISP_INFO_OUT_SUPPORTED_MATCHES,
 				pd_match_pri);
-		rc = efx_ef10_filter_match_flags_from_mcdi(encap, mcdi_flags);
+		rc = efx_mcdi_filter_match_flags_from_mcdi(encap, mcdi_flags);
 		if (rc < 0) {
 			netif_dbg(efx, probe, efx->net_dev,
 				  "%s: fw flags %#x pri %u not supported in driver\n",
@@ -4647,11 +4653,11 @@ efx_ef10_filter_table_probe_matches(struct efx_nic *efx,
 	return 0;
 }
 
-static int efx_ef10_filter_table_probe(struct efx_nic *efx)
+static int efx_mcdi_filter_table_probe(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	struct net_device *net_dev = efx->net_dev;
-	struct efx_ef10_filter_table *table;
+	struct efx_mcdi_filter_table *table;
 	struct efx_ef10_vlan *vlan;
 	int rc;
 
@@ -4666,18 +4672,18 @@ static int efx_ef10_filter_table_probe(struct efx_nic *efx)
 		return -ENOMEM;
 
 	table->rx_match_count = 0;
-	rc = efx_ef10_filter_table_probe_matches(efx, table, false);
+	rc = efx_mcdi_filter_table_probe_matches(efx, table, false);
 	if (rc)
 		goto fail;
 	if (nic_data->datapath_caps &
 		   (1 << MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN))
-		rc = efx_ef10_filter_table_probe_matches(efx, table, true);
+		rc = efx_mcdi_filter_table_probe_matches(efx, table, true);
 	if (rc)
 		goto fail;
 	if ((efx_supported_features(efx) & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-	    !(efx_ef10_filter_match_supported(table, false,
+	    !(efx_mcdi_filter_match_supported(table, false,
 		(EFX_FILTER_MATCH_OUTER_VID | EFX_FILTER_MATCH_LOC_MAC)) &&
-	      efx_ef10_filter_match_supported(table, false,
+	      efx_mcdi_filter_match_supported(table, false,
 		(EFX_FILTER_MATCH_OUTER_VID | EFX_FILTER_MATCH_LOC_MAC_IG)))) {
 		netif_info(efx, probe, net_dev,
 			   "VLAN filters are not supported in this firmware variant\n");
@@ -4686,7 +4692,7 @@ static int efx_ef10_filter_table_probe(struct efx_nic *efx)
 		net_dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 	}
 
-	table->entry = vzalloc(array_size(HUNT_FILTER_TBL_ROWS,
+	table->entry = vzalloc(array_size(EFX_MCDI_FILTER_TBL_ROWS,
 					  sizeof(*table->entry)));
 	if (!table->entry) {
 		rc = -ENOMEM;
@@ -4702,7 +4708,7 @@ static int efx_ef10_filter_table_probe(struct efx_nic *efx)
 	efx->filter_state = table;
 
 	list_for_each_entry(vlan, &nic_data->vlan_list, list) {
-		rc = efx_ef10_filter_add_vlan(efx, vlan->vid);
+		rc = efx_mcdi_filter_add_vlan(efx, vlan->vid);
 		if (rc)
 			goto fail_add_vlan;
 	}
@@ -4710,7 +4716,7 @@ static int efx_ef10_filter_table_probe(struct efx_nic *efx)
 	return 0;
 
 fail_add_vlan:
-	efx_ef10_filter_cleanup_vlans(efx);
+	efx_mcdi_filter_cleanup_vlans(efx);
 	efx->filter_state = NULL;
 fail:
 	kfree(table);
@@ -4718,14 +4724,14 @@ static int efx_ef10_filter_table_probe(struct efx_nic *efx)
 }
 
 /* Caller must hold efx->filter_sem for read if race against
- * efx_ef10_filter_table_remove() is possible
+ * efx_mcdi_filter_table_remove() is possible
  */
-static void efx_ef10_filter_table_restore(struct efx_nic *efx)
+static void efx_mcdi_filter_table_restore(struct efx_nic *efx)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	unsigned int invalid_filters = 0, failed = 0;
-	struct efx_ef10_filter_vlan *vlan;
+	struct efx_mcdi_filter_vlan *vlan;
 	struct efx_filter_spec *spec;
 	struct efx_rss_context *ctx;
 	unsigned int filter_idx;
@@ -4744,12 +4750,12 @@ static void efx_ef10_filter_table_restore(struct efx_nic *efx)
 	down_write(&table->lock);
 	mutex_lock(&efx->rss_lock);
 
-	for (filter_idx = 0; filter_idx < HUNT_FILTER_TBL_ROWS; filter_idx++) {
+	for (filter_idx = 0; filter_idx < EFX_MCDI_FILTER_TBL_ROWS; filter_idx++) {
 		spec = efx_ef10_filter_entry_spec(table, filter_idx);
 		if (!spec)
 			continue;
 
-		mcdi_flags = efx_ef10_filter_mcdi_flags_from_spec(spec);
+		mcdi_flags = efx_mcdi_filter_mcdi_flags_from_spec(spec);
 		match_pri = 0;
 		while (match_pri < table->rx_match_count &&
 		       table->rx_match_mcdi_flags[match_pri] != mcdi_flags)
@@ -4779,7 +4785,7 @@ static void efx_ef10_filter_table_restore(struct efx_nic *efx)
 			}
 		}
 
-		rc = efx_ef10_filter_push(efx, spec,
+		rc = efx_mcdi_filter_push(efx, spec,
 					  &table->entry[filter_idx].handle,
 					  ctx, false);
 		if (rc)
@@ -4816,15 +4822,15 @@ static void efx_ef10_filter_table_restore(struct efx_nic *efx)
 		nic_data->must_restore_filters = false;
 }
 
-static void efx_ef10_filter_table_remove(struct efx_nic *efx)
+static void efx_mcdi_filter_table_remove(struct efx_nic *efx)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_FILTER_OP_EXT_IN_LEN);
 	struct efx_filter_spec *spec;
 	unsigned int filter_idx;
 	int rc;
 
-	efx_ef10_filter_cleanup_vlans(efx);
+	efx_mcdi_filter_cleanup_vlans(efx);
 	efx->filter_state = NULL;
 	/* If we were called without locking, then it's not safe to free
 	 * the table as others might be using it.  So we just WARN, leak
@@ -4838,7 +4844,7 @@ static void efx_ef10_filter_table_remove(struct efx_nic *efx)
 	if (!table)
 		return;
 
-	for (filter_idx = 0; filter_idx < HUNT_FILTER_TBL_ROWS; filter_idx++) {
+	for (filter_idx = 0; filter_idx < EFX_MCDI_FILTER_TBL_ROWS; filter_idx++) {
 		spec = efx_ef10_filter_entry_spec(table, filter_idx);
 		if (!spec)
 			continue;
@@ -4862,9 +4868,9 @@ static void efx_ef10_filter_table_remove(struct efx_nic *efx)
 	kfree(table);
 }
 
-static void efx_ef10_filter_mark_one_old(struct efx_nic *efx, uint16_t *id)
+static void efx_mcdi_filter_mark_one_old(struct efx_nic *efx, uint16_t *id)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	unsigned int filter_idx;
 
 	efx_rwsem_assert_write_locked(&table->lock);
@@ -4881,38 +4887,38 @@ static void efx_ef10_filter_mark_one_old(struct efx_nic *efx, uint16_t *id)
 }
 
 /* Mark old per-VLAN filters that may need to be removed */
-static void _efx_ef10_filter_vlan_mark_old(struct efx_nic *efx,
-					   struct efx_ef10_filter_vlan *vlan)
+static void _efx_mcdi_filter_vlan_mark_old(struct efx_nic *efx,
+					   struct efx_mcdi_filter_vlan *vlan)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	unsigned int i;
 
 	for (i = 0; i < table->dev_uc_count; i++)
-		efx_ef10_filter_mark_one_old(efx, &vlan->uc[i]);
+		efx_mcdi_filter_mark_one_old(efx, &vlan->uc[i]);
 	for (i = 0; i < table->dev_mc_count; i++)
-		efx_ef10_filter_mark_one_old(efx, &vlan->mc[i]);
+		efx_mcdi_filter_mark_one_old(efx, &vlan->mc[i]);
 	for (i = 0; i < EFX_EF10_NUM_DEFAULT_FILTERS; i++)
-		efx_ef10_filter_mark_one_old(efx, &vlan->default_filters[i]);
+		efx_mcdi_filter_mark_one_old(efx, &vlan->default_filters[i]);
 }
 
 /* Mark old filters that may need to be removed.
  * Caller must hold efx->filter_sem for read if race against
- * efx_ef10_filter_table_remove() is possible
+ * efx_mcdi_filter_table_remove() is possible
  */
-static void efx_ef10_filter_mark_old(struct efx_nic *efx)
+static void efx_mcdi_filter_mark_old(struct efx_nic *efx)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
-	struct efx_ef10_filter_vlan *vlan;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_vlan *vlan;
 
 	down_write(&table->lock);
 	list_for_each_entry(vlan, &table->vlan_list, list)
-		_efx_ef10_filter_vlan_mark_old(efx, vlan);
+		_efx_mcdi_filter_vlan_mark_old(efx, vlan);
 	up_write(&table->lock);
 }
 
-static void efx_ef10_filter_uc_addr_list(struct efx_nic *efx)
+static void efx_mcdi_filter_uc_addr_list(struct efx_nic *efx)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	struct net_device *net_dev = efx->net_dev;
 	struct netdev_hw_addr *uc;
 	unsigned int i;
@@ -4932,9 +4938,9 @@ static void efx_ef10_filter_uc_addr_list(struct efx_nic *efx)
 	table->dev_uc_count = i;
 }
 
-static void efx_ef10_filter_mc_addr_list(struct efx_nic *efx)
+static void efx_mcdi_filter_mc_addr_list(struct efx_nic *efx)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	struct net_device *net_dev = efx->net_dev;
 	struct netdev_hw_addr *mc;
 	unsigned int i;
@@ -4956,12 +4962,12 @@ static void efx_ef10_filter_mc_addr_list(struct efx_nic *efx)
 	table->dev_mc_count = i;
 }
 
-static int efx_ef10_filter_insert_addr_list(struct efx_nic *efx,
-					    struct efx_ef10_filter_vlan *vlan,
+static int efx_mcdi_filter_insert_addr_list(struct efx_nic *efx,
+					    struct efx_mcdi_filter_vlan *vlan,
 					    bool multicast, bool rollback)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
-	struct efx_ef10_dev_addr *addr_list;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
+	struct efx_mcdi_dev_addr *addr_list;
 	enum efx_filter_flags filter_flags;
 	struct efx_filter_spec spec;
 	u8 baddr[ETH_ALEN];
@@ -4987,7 +4993,7 @@ static int efx_ef10_filter_insert_addr_list(struct efx_nic *efx,
 		EFX_WARN_ON_PARANOID(ids[i] != EFX_EF10_FILTER_ID_INVALID);
 		efx_filter_init_rx(&spec, EFX_FILTER_PRI_AUTO, filter_flags, 0);
 		efx_filter_set_eth_local(&spec, vlan->vid, addr_list[i].addr);
-		rc = efx_ef10_filter_insert_locked(efx, &spec, true);
+		rc = efx_mcdi_filter_insert_locked(efx, &spec, true);
 		if (rc < 0) {
 			if (rollback) {
 				netif_info(efx, drv, efx->net_dev,
@@ -4995,7 +5001,7 @@ static int efx_ef10_filter_insert_addr_list(struct efx_nic *efx,
 					   rc);
 				/* Fall back to promiscuous */
 				for (j = 0; j < i; j++) {
-					efx_ef10_filter_remove_unsafe(
+					efx_mcdi_filter_remove_unsafe(
 						efx, EFX_FILTER_PRI_AUTO,
 						ids[j]);
 					ids[j] = EFX_EF10_FILTER_ID_INVALID;
@@ -5016,13 +5022,13 @@ static int efx_ef10_filter_insert_addr_list(struct efx_nic *efx,
 		efx_filter_init_rx(&spec, EFX_FILTER_PRI_AUTO, filter_flags, 0);
 		eth_broadcast_addr(baddr);
 		efx_filter_set_eth_local(&spec, vlan->vid, baddr);
-		rc = efx_ef10_filter_insert_locked(efx, &spec, true);
+		rc = efx_mcdi_filter_insert_locked(efx, &spec, true);
 		if (rc < 0) {
 			netif_warn(efx, drv, efx->net_dev,
 				   "Broadcast filter insert failed rc=%d\n", rc);
 			/* Fall back to promiscuous */
 			for (j = 0; j < i; j++) {
-				efx_ef10_filter_remove_unsafe(
+				efx_mcdi_filter_remove_unsafe(
 					efx, EFX_FILTER_PRI_AUTO,
 					ids[j]);
 				ids[j] = EFX_EF10_FILTER_ID_INVALID;
@@ -5037,8 +5043,8 @@ static int efx_ef10_filter_insert_addr_list(struct efx_nic *efx,
 	return 0;
 }
 
-static int efx_ef10_filter_insert_def(struct efx_nic *efx,
-				      struct efx_ef10_filter_vlan *vlan,
+static int efx_mcdi_filter_insert_def(struct efx_nic *efx,
+				      struct efx_mcdi_filter_vlan *vlan,
 				      enum efx_encap_type encap_type,
 				      bool multicast, bool rollback)
 {
@@ -5072,7 +5078,7 @@ static int efx_ef10_filter_insert_def(struct efx_nic *efx,
 	if (vlan->vid != EFX_FILTER_VID_UNSPEC)
 		efx_filter_set_eth_local(&spec, vlan->vid, NULL);
 
-	rc = efx_ef10_filter_insert_locked(efx, &spec, true);
+	rc = efx_mcdi_filter_insert_locked(efx, &spec, true);
 	if (rc < 0) {
 		const char *um = multicast ? "Multicast" : "Unicast";
 		const char *encap_name = "";
@@ -5102,7 +5108,7 @@ static int efx_ef10_filter_insert_def(struct efx_nic *efx,
 			       encap_name, encap_ipv, um, rc);
 	} else if (multicast) {
 		/* mapping from encap types to default filter IDs (multicast) */
-		static enum efx_ef10_default_filters map[] = {
+		static enum efx_mcdi_filter_default_filters map[] = {
 			[EFX_ENCAP_TYPE_NONE] = EFX_EF10_MCDEF,
 			[EFX_ENCAP_TYPE_VXLAN] = EFX_EF10_VXLAN4_MCDEF,
 			[EFX_ENCAP_TYPE_NVGRE] = EFX_EF10_NVGRE4_MCDEF,
@@ -5132,14 +5138,14 @@ static int efx_ef10_filter_insert_def(struct efx_nic *efx,
 					   filter_flags, 0);
 			eth_broadcast_addr(baddr);
 			efx_filter_set_eth_local(&spec, vlan->vid, baddr);
-			rc = efx_ef10_filter_insert_locked(efx, &spec, true);
+			rc = efx_mcdi_filter_insert_locked(efx, &spec, true);
 			if (rc < 0) {
 				netif_warn(efx, drv, efx->net_dev,
 					   "Broadcast filter insert failed rc=%d\n",
 					   rc);
 				if (rollback) {
 					/* Roll back the mc_def filter */
-					efx_ef10_filter_remove_unsafe(
+					efx_mcdi_filter_remove_unsafe(
 							efx, EFX_FILTER_PRI_AUTO,
 							*id);
 					*id = EFX_EF10_FILTER_ID_INVALID;
@@ -5156,7 +5162,7 @@ static int efx_ef10_filter_insert_def(struct efx_nic *efx,
 		rc = 0;
 	} else {
 		/* mapping from encap types to default filter IDs (unicast) */
-		static enum efx_ef10_default_filters map[] = {
+		static enum efx_mcdi_filter_default_filters map[] = {
 			[EFX_ENCAP_TYPE_NONE] = EFX_EF10_UCDEF,
 			[EFX_ENCAP_TYPE_VXLAN] = EFX_EF10_VXLAN4_UCDEF,
 			[EFX_ENCAP_TYPE_NVGRE] = EFX_EF10_NVGRE4_UCDEF,
@@ -5185,19 +5191,19 @@ static int efx_ef10_filter_insert_def(struct efx_nic *efx,
 }
 
 /* Remove filters that weren't renewed. */
-static void efx_ef10_filter_remove_old(struct efx_nic *efx)
+static void efx_mcdi_filter_remove_old(struct efx_nic *efx)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	int remove_failed = 0;
 	int remove_noent = 0;
 	int rc;
 	int i;
 
 	down_write(&table->lock);
-	for (i = 0; i < HUNT_FILTER_TBL_ROWS; i++) {
+	for (i = 0; i < EFX_MCDI_FILTER_TBL_ROWS; i++) {
 		if (READ_ONCE(table->entry[i].spec) &
 		    EFX_EF10_FILTER_FLAG_AUTO_OLD) {
-			rc = efx_ef10_filter_remove_internal(efx,
+			rc = efx_mcdi_filter_remove_internal(efx,
 					1U << EFX_FILTER_PRI_AUTO, i, true);
 			if (rc == -ENOENT)
 				remove_noent++;
@@ -5230,7 +5236,7 @@ static int efx_ef10_vport_set_mac_address(struct efx_nic *efx)
 	efx_device_detach_sync(efx);
 	efx_net_stop(efx->net_dev);
 	down_write(&efx->filter_sem);
-	efx_ef10_filter_table_remove(efx);
+	efx_mcdi_filter_table_remove(efx);
 	up_write(&efx->filter_sem);
 
 	rc = efx_ef10_vadaptor_free(efx, nic_data->vport_id);
@@ -5262,7 +5268,7 @@ static int efx_ef10_vport_set_mac_address(struct efx_nic *efx)
 		goto reset_nic;
 restore_filters:
 	down_write(&efx->filter_sem);
-	rc2 = efx_ef10_filter_table_probe(efx);
+	rc2 = efx_mcdi_filter_table_probe(efx);
 	up_write(&efx->filter_sem);
 	if (rc2)
 		goto reset_nic;
@@ -5284,12 +5290,12 @@ static int efx_ef10_vport_set_mac_address(struct efx_nic *efx)
 }
 
 /* Caller must hold efx->filter_sem for read if race against
- * efx_ef10_filter_table_remove() is possible
+ * efx_mcdi_filter_table_remove() is possible
  */
-static void efx_ef10_filter_vlan_sync_rx_mode(struct efx_nic *efx,
-					      struct efx_ef10_filter_vlan *vlan)
+static void efx_mcdi_filter_vlan_sync_rx_mode(struct efx_nic *efx,
+					      struct efx_mcdi_filter_vlan *vlan)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 
 	/* Do not install unspecified VID if VLAN filtering is enabled.
@@ -5300,32 +5306,32 @@ static void efx_ef10_filter_vlan_sync_rx_mode(struct efx_nic *efx,
 
 	/* Insert/renew unicast filters */
 	if (table->uc_promisc) {
-		efx_ef10_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_NONE,
+		efx_mcdi_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_NONE,
 					   false, false);
-		efx_ef10_filter_insert_addr_list(efx, vlan, false, false);
+		efx_mcdi_filter_insert_addr_list(efx, vlan, false, false);
 	} else {
 		/* If any of the filters failed to insert, fall back to
 		 * promiscuous mode - add in the uc_def filter.  But keep
 		 * our individual unicast filters.
 		 */
-		if (efx_ef10_filter_insert_addr_list(efx, vlan, false, false))
-			efx_ef10_filter_insert_def(efx, vlan,
+		if (efx_mcdi_filter_insert_addr_list(efx, vlan, false, false))
+			efx_mcdi_filter_insert_def(efx, vlan,
 						   EFX_ENCAP_TYPE_NONE,
 						   false, false);
 	}
-	efx_ef10_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_VXLAN,
+	efx_mcdi_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_VXLAN,
 				   false, false);
-	efx_ef10_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_VXLAN |
+	efx_mcdi_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_VXLAN |
 					      EFX_ENCAP_FLAG_IPV6,
 				   false, false);
-	efx_ef10_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_NVGRE,
+	efx_mcdi_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_NVGRE,
 				   false, false);
-	efx_ef10_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_NVGRE |
+	efx_mcdi_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_NVGRE |
 					      EFX_ENCAP_FLAG_IPV6,
 				   false, false);
-	efx_ef10_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_GENEVE,
+	efx_mcdi_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_GENEVE,
 				   false, false);
-	efx_ef10_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_GENEVE |
+	efx_mcdi_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_GENEVE |
 					      EFX_ENCAP_FLAG_IPV6,
 				   false, false);
 
@@ -5335,18 +5341,18 @@ static void efx_ef10_filter_vlan_sync_rx_mode(struct efx_nic *efx,
 	 */
 	if (nic_data->workaround_26807 &&
 	    table->mc_promisc_last != table->mc_promisc)
-		efx_ef10_filter_remove_old(efx);
+		efx_mcdi_filter_remove_old(efx);
 	if (table->mc_promisc) {
 		if (nic_data->workaround_26807) {
 			/* If we failed to insert promiscuous filters, rollback
 			 * and fall back to individual multicast filters
 			 */
-			if (efx_ef10_filter_insert_def(efx, vlan,
+			if (efx_mcdi_filter_insert_def(efx, vlan,
 						       EFX_ENCAP_TYPE_NONE,
 						       true, true)) {
 				/* Changing promisc state, so remove old filters */
-				efx_ef10_filter_remove_old(efx);
-				efx_ef10_filter_insert_addr_list(efx, vlan,
+				efx_mcdi_filter_remove_old(efx);
+				efx_mcdi_filter_insert_addr_list(efx, vlan,
 								 true, false);
 			}
 		} else {
@@ -5354,11 +5360,11 @@ static void efx_ef10_filter_vlan_sync_rx_mode(struct efx_nic *efx,
 			 * rollback.  Regardless, also insert the mc_list,
 			 * unless it's incomplete due to overflow
 			 */
-			efx_ef10_filter_insert_def(efx, vlan,
+			efx_mcdi_filter_insert_def(efx, vlan,
 						   EFX_ENCAP_TYPE_NONE,
 						   true, false);
 			if (!table->mc_overflow)
-				efx_ef10_filter_insert_addr_list(efx, vlan,
+				efx_mcdi_filter_insert_addr_list(efx, vlan,
 								 true, false);
 		}
 	} else {
@@ -5367,42 +5373,42 @@ static void efx_ef10_filter_vlan_sync_rx_mode(struct efx_nic *efx,
 		 * that fails, roll back again and insert as many of our
 		 * individual multicast filters as we can.
 		 */
-		if (efx_ef10_filter_insert_addr_list(efx, vlan, true, true)) {
+		if (efx_mcdi_filter_insert_addr_list(efx, vlan, true, true)) {
 			/* Changing promisc state, so remove old filters */
 			if (nic_data->workaround_26807)
-				efx_ef10_filter_remove_old(efx);
-			if (efx_ef10_filter_insert_def(efx, vlan,
+				efx_mcdi_filter_remove_old(efx);
+			if (efx_mcdi_filter_insert_def(efx, vlan,
 						       EFX_ENCAP_TYPE_NONE,
 						       true, true))
-				efx_ef10_filter_insert_addr_list(efx, vlan,
+				efx_mcdi_filter_insert_addr_list(efx, vlan,
 								 true, false);
 		}
 	}
-	efx_ef10_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_VXLAN,
+	efx_mcdi_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_VXLAN,
 				   true, false);
-	efx_ef10_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_VXLAN |
+	efx_mcdi_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_VXLAN |
 					      EFX_ENCAP_FLAG_IPV6,
 				   true, false);
-	efx_ef10_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_NVGRE,
+	efx_mcdi_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_NVGRE,
 				   true, false);
-	efx_ef10_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_NVGRE |
+	efx_mcdi_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_NVGRE |
 					      EFX_ENCAP_FLAG_IPV6,
 				   true, false);
-	efx_ef10_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_GENEVE,
+	efx_mcdi_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_GENEVE,
 				   true, false);
-	efx_ef10_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_GENEVE |
+	efx_mcdi_filter_insert_def(efx, vlan, EFX_ENCAP_TYPE_GENEVE |
 					      EFX_ENCAP_FLAG_IPV6,
 				   true, false);
 }
 
 /* Caller must hold efx->filter_sem for read if race against
- * efx_ef10_filter_table_remove() is possible
+ * efx_mcdi_filter_table_remove() is possible
  */
-static void efx_ef10_filter_sync_rx_mode(struct efx_nic *efx)
+static void efx_mcdi_filter_sync_rx_mode(struct efx_nic *efx)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	struct net_device *net_dev = efx->net_dev;
-	struct efx_ef10_filter_vlan *vlan;
+	struct efx_mcdi_filter_vlan *vlan;
 	bool vlan_filter;
 
 	if (!efx_dev_registered(efx))
@@ -5411,14 +5417,14 @@ static void efx_ef10_filter_sync_rx_mode(struct efx_nic *efx)
 	if (!table)
 		return;
 
-	efx_ef10_filter_mark_old(efx);
+	efx_mcdi_filter_mark_old(efx);
 
 	/* Copy/convert the address lists; add the primary station
 	 * address and broadcast address
 	 */
 	netif_addr_lock_bh(net_dev);
-	efx_ef10_filter_uc_addr_list(efx);
-	efx_ef10_filter_mc_addr_list(efx);
+	efx_mcdi_filter_uc_addr_list(efx);
+	efx_mcdi_filter_mc_addr_list(efx);
 	netif_addr_unlock_bh(net_dev);
 
 	/* If VLAN filtering changes, all old filters are finally removed.
@@ -5428,20 +5434,20 @@ static void efx_ef10_filter_sync_rx_mode(struct efx_nic *efx)
 	vlan_filter = !!(net_dev->features & NETIF_F_HW_VLAN_CTAG_FILTER);
 	if (table->vlan_filter != vlan_filter) {
 		table->vlan_filter = vlan_filter;
-		efx_ef10_filter_remove_old(efx);
+		efx_mcdi_filter_remove_old(efx);
 	}
 
 	list_for_each_entry(vlan, &table->vlan_list, list)
-		efx_ef10_filter_vlan_sync_rx_mode(efx, vlan);
+		efx_mcdi_filter_vlan_sync_rx_mode(efx, vlan);
 
-	efx_ef10_filter_remove_old(efx);
+	efx_mcdi_filter_remove_old(efx);
 	table->mc_promisc_last = table->mc_promisc;
 }
 
-static struct efx_ef10_filter_vlan *efx_ef10_filter_find_vlan(struct efx_nic *efx, u16 vid)
+static struct efx_mcdi_filter_vlan *efx_mcdi_filter_find_vlan(struct efx_nic *efx, u16 vid)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
-	struct efx_ef10_filter_vlan *vlan;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_vlan *vlan;
 
 	WARN_ON(!rwsem_is_locked(&efx->filter_sem));
 
@@ -5453,16 +5459,16 @@ static struct efx_ef10_filter_vlan *efx_ef10_filter_find_vlan(struct efx_nic *ef
 	return NULL;
 }
 
-static int efx_ef10_filter_add_vlan(struct efx_nic *efx, u16 vid)
+static int efx_mcdi_filter_add_vlan(struct efx_nic *efx, u16 vid)
 {
-	struct efx_ef10_filter_table *table = efx->filter_state;
-	struct efx_ef10_filter_vlan *vlan;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
+	struct efx_mcdi_filter_vlan *vlan;
 	unsigned int i;
 
 	if (!efx_rwsem_assert_write_locked(&efx->filter_sem))
 		return -EINVAL;
 
-	vlan = efx_ef10_filter_find_vlan(efx, vid);
+	vlan = efx_mcdi_filter_find_vlan(efx, vid);
 	if (WARN_ON(vlan)) {
 		netif_err(efx, drv, efx->net_dev,
 			  "VLAN %u already added\n", vid);
@@ -5485,52 +5491,52 @@ static int efx_ef10_filter_add_vlan(struct efx_nic *efx, u16 vid)
 	list_add_tail(&vlan->list, &table->vlan_list);
 
 	if (efx_dev_registered(efx))
-		efx_ef10_filter_vlan_sync_rx_mode(efx, vlan);
+		efx_mcdi_filter_vlan_sync_rx_mode(efx, vlan);
 
 	return 0;
 }
 
-static void efx_ef10_filter_del_vlan_internal(struct efx_nic *efx,
-					      struct efx_ef10_filter_vlan *vlan)
+static void efx_mcdi_filter_del_vlan_internal(struct efx_nic *efx,
+					      struct efx_mcdi_filter_vlan *vlan)
 {
 	unsigned int i;
 
-	/* See comment in efx_ef10_filter_table_remove() */
+	/* See comment in efx_mcdi_filter_table_remove() */
 	if (!efx_rwsem_assert_write_locked(&efx->filter_sem))
 		return;
 
 	list_del(&vlan->list);
 
 	for (i = 0; i < ARRAY_SIZE(vlan->uc); i++)
-		efx_ef10_filter_remove_unsafe(efx, EFX_FILTER_PRI_AUTO,
+		efx_mcdi_filter_remove_unsafe(efx, EFX_FILTER_PRI_AUTO,
 					      vlan->uc[i]);
 	for (i = 0; i < ARRAY_SIZE(vlan->mc); i++)
-		efx_ef10_filter_remove_unsafe(efx, EFX_FILTER_PRI_AUTO,
+		efx_mcdi_filter_remove_unsafe(efx, EFX_FILTER_PRI_AUTO,
 					      vlan->mc[i]);
 	for (i = 0; i < EFX_EF10_NUM_DEFAULT_FILTERS; i++)
 		if (vlan->default_filters[i] != EFX_EF10_FILTER_ID_INVALID)
-			efx_ef10_filter_remove_unsafe(efx, EFX_FILTER_PRI_AUTO,
+			efx_mcdi_filter_remove_unsafe(efx, EFX_FILTER_PRI_AUTO,
 						      vlan->default_filters[i]);
 
 	kfree(vlan);
 }
 
-static void efx_ef10_filter_del_vlan(struct efx_nic *efx, u16 vid)
+static void efx_mcdi_filter_del_vlan(struct efx_nic *efx, u16 vid)
 {
-	struct efx_ef10_filter_vlan *vlan;
+	struct efx_mcdi_filter_vlan *vlan;
 
-	/* See comment in efx_ef10_filter_table_remove() */
+	/* See comment in efx_mcdi_filter_table_remove() */
 	if (!efx_rwsem_assert_write_locked(&efx->filter_sem))
 		return;
 
-	vlan = efx_ef10_filter_find_vlan(efx, vid);
+	vlan = efx_mcdi_filter_find_vlan(efx, vid);
 	if (!vlan) {
 		netif_err(efx, drv, efx->net_dev,
 			  "VLAN %u not found in filter state\n", vid);
 		return;
 	}
 
-	efx_ef10_filter_del_vlan_internal(efx, vlan);
+	efx_mcdi_filter_del_vlan_internal(efx, vlan);
 }
 
 static int efx_ef10_set_mac_address(struct efx_nic *efx)
@@ -5545,7 +5551,7 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 
 	mutex_lock(&efx->mac_lock);
 	down_write(&efx->filter_sem);
-	efx_ef10_filter_table_remove(efx);
+	efx_mcdi_filter_table_remove(efx);
 
 	ether_addr_copy(MCDI_PTR(inbuf, VADAPTOR_SET_MAC_IN_MACADDR),
 			efx->net_dev->dev_addr);
@@ -5554,7 +5560,7 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_VADAPTOR_SET_MAC, inbuf,
 				sizeof(inbuf), NULL, 0, NULL);
 
-	efx_ef10_filter_table_probe(efx);
+	efx_mcdi_filter_table_probe(efx);
 	up_write(&efx->filter_sem);
 	mutex_unlock(&efx->mac_lock);
 
@@ -5616,14 +5622,14 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 
 static int efx_ef10_mac_reconfigure(struct efx_nic *efx)
 {
-	efx_ef10_filter_sync_rx_mode(efx);
+	efx_mcdi_filter_sync_rx_mode(efx);
 
 	return efx_mcdi_set_mac(efx);
 }
 
 static int efx_ef10_mac_reconfigure_vf(struct efx_nic *efx)
 {
-	efx_ef10_filter_sync_rx_mode(efx);
+	efx_mcdi_filter_sync_rx_mode(efx);
 
 	return 0;
 }
@@ -6338,8 +6344,8 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.tx_remove = efx_mcdi_tx_remove,
 	.tx_write = efx_ef10_tx_write,
 	.tx_limit_len = efx_ef10_tx_limit_len,
-	.rx_push_rss_config = efx_ef10_vf_rx_push_rss_config,
-	.rx_pull_rss_config = efx_ef10_rx_pull_rss_config,
+	.rx_push_rss_config = efx_mcdi_vf_rx_push_rss_config,
+	.rx_pull_rss_config = efx_mcdi_rx_pull_rss_config,
 	.rx_probe = efx_mcdi_rx_probe,
 	.rx_init = efx_mcdi_rx_init,
 	.rx_remove = efx_mcdi_rx_remove,
@@ -6352,19 +6358,19 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.ev_process = efx_ef10_ev_process,
 	.ev_read_ack = efx_ef10_ev_read_ack,
 	.ev_test_generate = efx_ef10_ev_test_generate,
-	.filter_table_probe = efx_ef10_filter_table_probe,
-	.filter_table_restore = efx_ef10_filter_table_restore,
-	.filter_table_remove = efx_ef10_filter_table_remove,
-	.filter_update_rx_scatter = efx_ef10_filter_update_rx_scatter,
-	.filter_insert = efx_ef10_filter_insert,
-	.filter_remove_safe = efx_ef10_filter_remove_safe,
-	.filter_get_safe = efx_ef10_filter_get_safe,
-	.filter_clear_rx = efx_ef10_filter_clear_rx,
-	.filter_count_rx_used = efx_ef10_filter_count_rx_used,
-	.filter_get_rx_id_limit = efx_ef10_filter_get_rx_id_limit,
-	.filter_get_rx_ids = efx_ef10_filter_get_rx_ids,
+	.filter_table_probe = efx_mcdi_filter_table_probe,
+	.filter_table_restore = efx_mcdi_filter_table_restore,
+	.filter_table_remove = efx_mcdi_filter_table_remove,
+	.filter_update_rx_scatter = efx_mcdi_update_rx_scatter,
+	.filter_insert = efx_mcdi_filter_insert,
+	.filter_remove_safe = efx_mcdi_filter_remove_safe,
+	.filter_get_safe = efx_mcdi_filter_get_safe,
+	.filter_clear_rx = efx_mcdi_filter_clear_rx,
+	.filter_count_rx_used = efx_mcdi_filter_count_rx_used,
+	.filter_get_rx_id_limit = efx_mcdi_filter_get_rx_id_limit,
+	.filter_get_rx_ids = efx_mcdi_filter_get_rx_ids,
 #ifdef CONFIG_RFS_ACCEL
-	.filter_rfs_expire_one = efx_ef10_filter_rfs_expire_one,
+	.filter_rfs_expire_one = efx_mcdi_filter_rfs_expire_one,
 #endif
 #ifdef CONFIG_SFC_MTD
 	.mtd_probe = efx_port_dummy_op_int,
@@ -6394,7 +6400,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.timer_period_max = 1 << ERF_DD_EVQ_IND_TIMER_VAL_WIDTH,
 	.offload_features = EF10_OFFLOAD_FEATURES,
 	.mcdi_max_ver = 2,
-	.max_rx_ip_filters = HUNT_FILTER_TBL_ROWS,
+	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
 	.hwtstamp_filters = 1 << HWTSTAMP_FILTER_NONE |
 			    1 << HWTSTAMP_FILTER_ALL,
 	.rx_hash_key_size = 40,
@@ -6447,11 +6453,11 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.tx_remove = efx_mcdi_tx_remove,
 	.tx_write = efx_ef10_tx_write,
 	.tx_limit_len = efx_ef10_tx_limit_len,
-	.rx_push_rss_config = efx_ef10_pf_rx_push_rss_config,
-	.rx_pull_rss_config = efx_ef10_rx_pull_rss_config,
-	.rx_push_rss_context_config = efx_ef10_rx_push_rss_context_config,
-	.rx_pull_rss_context_config = efx_ef10_rx_pull_rss_context_config,
-	.rx_restore_rss_contexts = efx_ef10_rx_restore_rss_contexts,
+	.rx_push_rss_config = efx_mcdi_pf_rx_push_rss_config,
+	.rx_pull_rss_config = efx_mcdi_rx_pull_rss_config,
+	.rx_push_rss_context_config = efx_mcdi_rx_push_rss_context_config,
+	.rx_pull_rss_context_config = efx_mcdi_rx_pull_rss_context_config,
+	.rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
 	.rx_probe = efx_mcdi_rx_probe,
 	.rx_init = efx_mcdi_rx_init,
 	.rx_remove = efx_mcdi_rx_remove,
@@ -6464,19 +6470,19 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.ev_process = efx_ef10_ev_process,
 	.ev_read_ack = efx_ef10_ev_read_ack,
 	.ev_test_generate = efx_ef10_ev_test_generate,
-	.filter_table_probe = efx_ef10_filter_table_probe,
-	.filter_table_restore = efx_ef10_filter_table_restore,
-	.filter_table_remove = efx_ef10_filter_table_remove,
-	.filter_update_rx_scatter = efx_ef10_filter_update_rx_scatter,
-	.filter_insert = efx_ef10_filter_insert,
-	.filter_remove_safe = efx_ef10_filter_remove_safe,
-	.filter_get_safe = efx_ef10_filter_get_safe,
-	.filter_clear_rx = efx_ef10_filter_clear_rx,
-	.filter_count_rx_used = efx_ef10_filter_count_rx_used,
-	.filter_get_rx_id_limit = efx_ef10_filter_get_rx_id_limit,
-	.filter_get_rx_ids = efx_ef10_filter_get_rx_ids,
+	.filter_table_probe = efx_mcdi_filter_table_probe,
+	.filter_table_restore = efx_mcdi_filter_table_restore,
+	.filter_table_remove = efx_mcdi_filter_table_remove,
+	.filter_update_rx_scatter = efx_mcdi_update_rx_scatter,
+	.filter_insert = efx_mcdi_filter_insert,
+	.filter_remove_safe = efx_mcdi_filter_remove_safe,
+	.filter_get_safe = efx_mcdi_filter_get_safe,
+	.filter_clear_rx = efx_mcdi_filter_clear_rx,
+	.filter_count_rx_used = efx_mcdi_filter_count_rx_used,
+	.filter_get_rx_id_limit = efx_mcdi_filter_get_rx_id_limit,
+	.filter_get_rx_ids = efx_mcdi_filter_get_rx_ids,
 #ifdef CONFIG_RFS_ACCEL
-	.filter_rfs_expire_one = efx_ef10_filter_rfs_expire_one,
+	.filter_rfs_expire_one = efx_mcdi_filter_rfs_expire_one,
 #endif
 #ifdef CONFIG_SFC_MTD
 	.mtd_probe = efx_ef10_mtd_probe,
@@ -6529,7 +6535,7 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.timer_period_max = 1 << ERF_DD_EVQ_IND_TIMER_VAL_WIDTH,
 	.offload_features = EF10_OFFLOAD_FEATURES,
 	.mcdi_max_ver = 2,
-	.max_rx_ip_filters = HUNT_FILTER_TBL_ROWS,
+	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
 	.hwtstamp_filters = 1 << HWTSTAMP_FILTER_NONE |
 			    1 << HWTSTAMP_FILTER_ALL,
 	.rx_hash_key_size = 40,
-- 
2.20.1


