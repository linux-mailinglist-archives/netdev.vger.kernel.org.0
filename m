Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058BF55E96E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347120AbiF1OAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347059AbiF1OAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:00:13 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52A6A36690
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 07:00:11 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 40BAB320102;
        Tue, 28 Jun 2022 15:00:11 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o6BlC-0008I7-5e;
        Tue, 28 Jun 2022 15:00:10 +0100
Subject: [PATCH net-next v2 07/10] sfc: Move EF100 efx_nic_type structs to the
 end of the file
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jonathan.s.cooper@amd.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Tue, 28 Jun 2022 15:00:10 +0100
Message-ID: <165642481005.31669.15765852401252619274.stgit@palantir17.mph.net>
In-Reply-To: <165642465886.31669.17429834766693417246.stgit@palantir17.mph.net>
References: <165642465886.31669.17429834766693417246.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Cooper <jonathan.s.cooper@amd.com>

This avoids a forward declaration in a subsequent patch.

Signed-off-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Co-developed-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c |  344 +++++++++++++++++-----------------
 1 file changed, 172 insertions(+), 172 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index b2536d2c218a..fcbc9de1bbf2 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -704,178 +704,6 @@ static unsigned int efx_ef100_recycle_ring_size(const struct efx_nic *efx)
 	return 10 * EFX_RECYCLE_RING_SIZE_10G;
 }
 
-/*	NIC level access functions
- */
-#define EF100_OFFLOAD_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_RXCSUM |	\
-	NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_NTUPLE | \
-	NETIF_F_RXHASH | NETIF_F_RXFCS | NETIF_F_TSO_ECN | NETIF_F_RXALL | \
-	NETIF_F_HW_VLAN_CTAG_TX)
-
-const struct efx_nic_type ef100_pf_nic_type = {
-	.revision = EFX_REV_EF100,
-	.is_vf = false,
-	.probe = ef100_probe_pf,
-	.offload_features = EF100_OFFLOAD_FEATURES,
-	.mcdi_max_ver = 2,
-	.mcdi_request = ef100_mcdi_request,
-	.mcdi_poll_response = ef100_mcdi_poll_response,
-	.mcdi_read_response = ef100_mcdi_read_response,
-	.mcdi_poll_reboot = ef100_mcdi_poll_reboot,
-	.mcdi_reboot_detected = ef100_mcdi_reboot_detected,
-	.irq_enable_master = efx_port_dummy_op_void,
-	.irq_test_generate = efx_ef100_irq_test_generate,
-	.irq_disable_non_ev = efx_port_dummy_op_void,
-	.push_irq_moderation = efx_channel_dummy_op_void,
-	.min_interrupt_mode = EFX_INT_MODE_MSIX,
-	.map_reset_reason = ef100_map_reset_reason,
-	.map_reset_flags = ef100_map_reset_flags,
-	.reset = ef100_reset,
-
-	.check_caps = ef100_check_caps,
-
-	.ev_probe = ef100_ev_probe,
-	.ev_init = ef100_ev_init,
-	.ev_fini = efx_mcdi_ev_fini,
-	.ev_remove = efx_mcdi_ev_remove,
-	.irq_handle_msi = ef100_msi_interrupt,
-	.ev_process = ef100_ev_process,
-	.ev_read_ack = ef100_ev_read_ack,
-	.ev_test_generate = efx_ef100_ev_test_generate,
-	.tx_probe = ef100_tx_probe,
-	.tx_init = ef100_tx_init,
-	.tx_write = ef100_tx_write,
-	.tx_enqueue = ef100_enqueue_skb,
-	.rx_probe = efx_mcdi_rx_probe,
-	.rx_init = efx_mcdi_rx_init,
-	.rx_remove = efx_mcdi_rx_remove,
-	.rx_write = ef100_rx_write,
-	.rx_packet = __ef100_rx_packet,
-	.rx_buf_hash_valid = ef100_rx_buf_hash_valid,
-	.fini_dmaq = efx_fini_dmaq,
-	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
-	.filter_table_probe = ef100_filter_table_up,
-	.filter_table_restore = efx_mcdi_filter_table_restore,
-	.filter_table_remove = ef100_filter_table_down,
-	.filter_insert = efx_mcdi_filter_insert,
-	.filter_remove_safe = efx_mcdi_filter_remove_safe,
-	.filter_get_safe = efx_mcdi_filter_get_safe,
-	.filter_clear_rx = efx_mcdi_filter_clear_rx,
-	.filter_count_rx_used = efx_mcdi_filter_count_rx_used,
-	.filter_get_rx_id_limit = efx_mcdi_filter_get_rx_id_limit,
-	.filter_get_rx_ids = efx_mcdi_filter_get_rx_ids,
-#ifdef CONFIG_RFS_ACCEL
-	.filter_rfs_expire_one = efx_mcdi_filter_rfs_expire_one,
-#endif
-
-	.get_phys_port_id = efx_ef100_get_phys_port_id,
-
-	.rx_prefix_size = ESE_GZ_RX_PKT_PREFIX_LEN,
-	.rx_hash_offset = ESF_GZ_RX_PREFIX_RSS_HASH_LBN / 8,
-	.rx_ts_offset = ESF_GZ_RX_PREFIX_PARTIAL_TSTAMP_LBN / 8,
-	.rx_hash_key_size = 40,
-	.rx_pull_rss_config = efx_mcdi_rx_pull_rss_config,
-	.rx_push_rss_config = efx_mcdi_pf_rx_push_rss_config,
-	.rx_push_rss_context_config = efx_mcdi_rx_push_rss_context_config,
-	.rx_pull_rss_context_config = efx_mcdi_rx_pull_rss_context_config,
-	.rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
-	.rx_recycle_ring_size = efx_ef100_recycle_ring_size,
-
-	.reconfigure_mac = ef100_reconfigure_mac,
-	.reconfigure_port = efx_mcdi_port_reconfigure,
-	.test_nvram = efx_new_mcdi_nvram_test_all,
-	.describe_stats = ef100_describe_stats,
-	.start_stats = efx_mcdi_mac_start_stats,
-	.update_stats = ef100_update_stats,
-	.pull_stats = efx_mcdi_mac_pull_stats,
-	.stop_stats = efx_mcdi_mac_stop_stats,
-#ifdef CONFIG_SFC_SRIOV
-	.sriov_configure = efx_ef100_sriov_configure,
-#endif
-
-	/* Per-type bar/size configuration not used on ef100. Location of
-	 * registers is defined by extended capabilities.
-	 */
-	.mem_bar = NULL,
-	.mem_map_size = NULL,
-
-};
-
-const struct efx_nic_type ef100_vf_nic_type = {
-	.revision = EFX_REV_EF100,
-	.is_vf = true,
-	.probe = ef100_probe_vf,
-	.offload_features = EF100_OFFLOAD_FEATURES,
-	.mcdi_max_ver = 2,
-	.mcdi_request = ef100_mcdi_request,
-	.mcdi_poll_response = ef100_mcdi_poll_response,
-	.mcdi_read_response = ef100_mcdi_read_response,
-	.mcdi_poll_reboot = ef100_mcdi_poll_reboot,
-	.mcdi_reboot_detected = ef100_mcdi_reboot_detected,
-	.irq_enable_master = efx_port_dummy_op_void,
-	.irq_test_generate = efx_ef100_irq_test_generate,
-	.irq_disable_non_ev = efx_port_dummy_op_void,
-	.push_irq_moderation = efx_channel_dummy_op_void,
-	.min_interrupt_mode = EFX_INT_MODE_MSIX,
-	.map_reset_reason = ef100_map_reset_reason,
-	.map_reset_flags = ef100_map_reset_flags,
-	.reset = ef100_reset,
-	.check_caps = ef100_check_caps,
-	.ev_probe = ef100_ev_probe,
-	.ev_init = ef100_ev_init,
-	.ev_fini = efx_mcdi_ev_fini,
-	.ev_remove = efx_mcdi_ev_remove,
-	.irq_handle_msi = ef100_msi_interrupt,
-	.ev_process = ef100_ev_process,
-	.ev_read_ack = ef100_ev_read_ack,
-	.ev_test_generate = efx_ef100_ev_test_generate,
-	.tx_probe = ef100_tx_probe,
-	.tx_init = ef100_tx_init,
-	.tx_write = ef100_tx_write,
-	.tx_enqueue = ef100_enqueue_skb,
-	.rx_probe = efx_mcdi_rx_probe,
-	.rx_init = efx_mcdi_rx_init,
-	.rx_remove = efx_mcdi_rx_remove,
-	.rx_write = ef100_rx_write,
-	.rx_packet = __ef100_rx_packet,
-	.rx_buf_hash_valid = ef100_rx_buf_hash_valid,
-	.fini_dmaq = efx_fini_dmaq,
-	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
-	.filter_table_probe = ef100_filter_table_up,
-	.filter_table_restore = efx_mcdi_filter_table_restore,
-	.filter_table_remove = ef100_filter_table_down,
-	.filter_insert = efx_mcdi_filter_insert,
-	.filter_remove_safe = efx_mcdi_filter_remove_safe,
-	.filter_get_safe = efx_mcdi_filter_get_safe,
-	.filter_clear_rx = efx_mcdi_filter_clear_rx,
-	.filter_count_rx_used = efx_mcdi_filter_count_rx_used,
-	.filter_get_rx_id_limit = efx_mcdi_filter_get_rx_id_limit,
-	.filter_get_rx_ids = efx_mcdi_filter_get_rx_ids,
-#ifdef CONFIG_RFS_ACCEL
-	.filter_rfs_expire_one = efx_mcdi_filter_rfs_expire_one,
-#endif
-
-	.rx_prefix_size = ESE_GZ_RX_PKT_PREFIX_LEN,
-	.rx_hash_offset = ESF_GZ_RX_PREFIX_RSS_HASH_LBN / 8,
-	.rx_ts_offset = ESF_GZ_RX_PREFIX_PARTIAL_TSTAMP_LBN / 8,
-	.rx_hash_key_size = 40,
-	.rx_pull_rss_config = efx_mcdi_rx_pull_rss_config,
-	.rx_push_rss_config = efx_mcdi_pf_rx_push_rss_config,
-	.rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
-	.rx_recycle_ring_size = efx_ef100_recycle_ring_size,
-
-	.reconfigure_mac = ef100_reconfigure_mac,
-	.test_nvram = efx_new_mcdi_nvram_test_all,
-	.describe_stats = ef100_describe_stats,
-	.start_stats = efx_mcdi_mac_start_stats,
-	.update_stats = ef100_update_stats,
-	.pull_stats = efx_mcdi_mac_pull_stats,
-	.stop_stats = efx_mcdi_mac_stop_stats,
-
-	.mem_bar = NULL,
-	.mem_map_size = NULL,
-
-};
-
 static int compare_versions(const char *a, const char *b)
 {
 	int a_major, a_minor, a_point, a_patch;
@@ -1303,3 +1131,175 @@ void ef100_remove(struct efx_nic *efx)
 	kfree(nic_data);
 	efx->nic_data = NULL;
 }
+
+/*	NIC level access functions
+ */
+#define EF100_OFFLOAD_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_RXCSUM |	\
+	NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_NTUPLE | \
+	NETIF_F_RXHASH | NETIF_F_RXFCS | NETIF_F_TSO_ECN | NETIF_F_RXALL | \
+	NETIF_F_HW_VLAN_CTAG_TX)
+
+const struct efx_nic_type ef100_pf_nic_type = {
+	.revision = EFX_REV_EF100,
+	.is_vf = false,
+	.probe = ef100_probe_pf,
+	.offload_features = EF100_OFFLOAD_FEATURES,
+	.mcdi_max_ver = 2,
+	.mcdi_request = ef100_mcdi_request,
+	.mcdi_poll_response = ef100_mcdi_poll_response,
+	.mcdi_read_response = ef100_mcdi_read_response,
+	.mcdi_poll_reboot = ef100_mcdi_poll_reboot,
+	.mcdi_reboot_detected = ef100_mcdi_reboot_detected,
+	.irq_enable_master = efx_port_dummy_op_void,
+	.irq_test_generate = efx_ef100_irq_test_generate,
+	.irq_disable_non_ev = efx_port_dummy_op_void,
+	.push_irq_moderation = efx_channel_dummy_op_void,
+	.min_interrupt_mode = EFX_INT_MODE_MSIX,
+	.map_reset_reason = ef100_map_reset_reason,
+	.map_reset_flags = ef100_map_reset_flags,
+	.reset = ef100_reset,
+
+	.check_caps = ef100_check_caps,
+
+	.ev_probe = ef100_ev_probe,
+	.ev_init = ef100_ev_init,
+	.ev_fini = efx_mcdi_ev_fini,
+	.ev_remove = efx_mcdi_ev_remove,
+	.irq_handle_msi = ef100_msi_interrupt,
+	.ev_process = ef100_ev_process,
+	.ev_read_ack = ef100_ev_read_ack,
+	.ev_test_generate = efx_ef100_ev_test_generate,
+	.tx_probe = ef100_tx_probe,
+	.tx_init = ef100_tx_init,
+	.tx_write = ef100_tx_write,
+	.tx_enqueue = ef100_enqueue_skb,
+	.rx_probe = efx_mcdi_rx_probe,
+	.rx_init = efx_mcdi_rx_init,
+	.rx_remove = efx_mcdi_rx_remove,
+	.rx_write = ef100_rx_write,
+	.rx_packet = __ef100_rx_packet,
+	.rx_buf_hash_valid = ef100_rx_buf_hash_valid,
+	.fini_dmaq = efx_fini_dmaq,
+	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
+	.filter_table_probe = ef100_filter_table_up,
+	.filter_table_restore = efx_mcdi_filter_table_restore,
+	.filter_table_remove = ef100_filter_table_down,
+	.filter_insert = efx_mcdi_filter_insert,
+	.filter_remove_safe = efx_mcdi_filter_remove_safe,
+	.filter_get_safe = efx_mcdi_filter_get_safe,
+	.filter_clear_rx = efx_mcdi_filter_clear_rx,
+	.filter_count_rx_used = efx_mcdi_filter_count_rx_used,
+	.filter_get_rx_id_limit = efx_mcdi_filter_get_rx_id_limit,
+	.filter_get_rx_ids = efx_mcdi_filter_get_rx_ids,
+#ifdef CONFIG_RFS_ACCEL
+	.filter_rfs_expire_one = efx_mcdi_filter_rfs_expire_one,
+#endif
+
+	.get_phys_port_id = efx_ef100_get_phys_port_id,
+
+	.rx_prefix_size = ESE_GZ_RX_PKT_PREFIX_LEN,
+	.rx_hash_offset = ESF_GZ_RX_PREFIX_RSS_HASH_LBN / 8,
+	.rx_ts_offset = ESF_GZ_RX_PREFIX_PARTIAL_TSTAMP_LBN / 8,
+	.rx_hash_key_size = 40,
+	.rx_pull_rss_config = efx_mcdi_rx_pull_rss_config,
+	.rx_push_rss_config = efx_mcdi_pf_rx_push_rss_config,
+	.rx_push_rss_context_config = efx_mcdi_rx_push_rss_context_config,
+	.rx_pull_rss_context_config = efx_mcdi_rx_pull_rss_context_config,
+	.rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
+	.rx_recycle_ring_size = efx_ef100_recycle_ring_size,
+
+	.reconfigure_mac = ef100_reconfigure_mac,
+	.reconfigure_port = efx_mcdi_port_reconfigure,
+	.test_nvram = efx_new_mcdi_nvram_test_all,
+	.describe_stats = ef100_describe_stats,
+	.start_stats = efx_mcdi_mac_start_stats,
+	.update_stats = ef100_update_stats,
+	.pull_stats = efx_mcdi_mac_pull_stats,
+	.stop_stats = efx_mcdi_mac_stop_stats,
+#ifdef CONFIG_SFC_SRIOV
+	.sriov_configure = efx_ef100_sriov_configure,
+#endif
+
+	/* Per-type bar/size configuration not used on ef100. Location of
+	 * registers is defined by extended capabilities.
+	 */
+	.mem_bar = NULL,
+	.mem_map_size = NULL,
+
+};
+
+const struct efx_nic_type ef100_vf_nic_type = {
+	.revision = EFX_REV_EF100,
+	.is_vf = true,
+	.probe = ef100_probe_vf,
+	.offload_features = EF100_OFFLOAD_FEATURES,
+	.mcdi_max_ver = 2,
+	.mcdi_request = ef100_mcdi_request,
+	.mcdi_poll_response = ef100_mcdi_poll_response,
+	.mcdi_read_response = ef100_mcdi_read_response,
+	.mcdi_poll_reboot = ef100_mcdi_poll_reboot,
+	.mcdi_reboot_detected = ef100_mcdi_reboot_detected,
+	.irq_enable_master = efx_port_dummy_op_void,
+	.irq_test_generate = efx_ef100_irq_test_generate,
+	.irq_disable_non_ev = efx_port_dummy_op_void,
+	.push_irq_moderation = efx_channel_dummy_op_void,
+	.min_interrupt_mode = EFX_INT_MODE_MSIX,
+	.map_reset_reason = ef100_map_reset_reason,
+	.map_reset_flags = ef100_map_reset_flags,
+	.reset = ef100_reset,
+	.check_caps = ef100_check_caps,
+	.ev_probe = ef100_ev_probe,
+	.ev_init = ef100_ev_init,
+	.ev_fini = efx_mcdi_ev_fini,
+	.ev_remove = efx_mcdi_ev_remove,
+	.irq_handle_msi = ef100_msi_interrupt,
+	.ev_process = ef100_ev_process,
+	.ev_read_ack = ef100_ev_read_ack,
+	.ev_test_generate = efx_ef100_ev_test_generate,
+	.tx_probe = ef100_tx_probe,
+	.tx_init = ef100_tx_init,
+	.tx_write = ef100_tx_write,
+	.tx_enqueue = ef100_enqueue_skb,
+	.rx_probe = efx_mcdi_rx_probe,
+	.rx_init = efx_mcdi_rx_init,
+	.rx_remove = efx_mcdi_rx_remove,
+	.rx_write = ef100_rx_write,
+	.rx_packet = __ef100_rx_packet,
+	.rx_buf_hash_valid = ef100_rx_buf_hash_valid,
+	.fini_dmaq = efx_fini_dmaq,
+	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
+	.filter_table_probe = ef100_filter_table_up,
+	.filter_table_restore = efx_mcdi_filter_table_restore,
+	.filter_table_remove = ef100_filter_table_down,
+	.filter_insert = efx_mcdi_filter_insert,
+	.filter_remove_safe = efx_mcdi_filter_remove_safe,
+	.filter_get_safe = efx_mcdi_filter_get_safe,
+	.filter_clear_rx = efx_mcdi_filter_clear_rx,
+	.filter_count_rx_used = efx_mcdi_filter_count_rx_used,
+	.filter_get_rx_id_limit = efx_mcdi_filter_get_rx_id_limit,
+	.filter_get_rx_ids = efx_mcdi_filter_get_rx_ids,
+#ifdef CONFIG_RFS_ACCEL
+	.filter_rfs_expire_one = efx_mcdi_filter_rfs_expire_one,
+#endif
+
+	.rx_prefix_size = ESE_GZ_RX_PKT_PREFIX_LEN,
+	.rx_hash_offset = ESF_GZ_RX_PREFIX_RSS_HASH_LBN / 8,
+	.rx_ts_offset = ESF_GZ_RX_PREFIX_PARTIAL_TSTAMP_LBN / 8,
+	.rx_hash_key_size = 40,
+	.rx_pull_rss_config = efx_mcdi_rx_pull_rss_config,
+	.rx_push_rss_config = efx_mcdi_pf_rx_push_rss_config,
+	.rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
+	.rx_recycle_ring_size = efx_ef100_recycle_ring_size,
+
+	.reconfigure_mac = ef100_reconfigure_mac,
+	.test_nvram = efx_new_mcdi_nvram_test_all,
+	.describe_stats = ef100_describe_stats,
+	.start_stats = efx_mcdi_mac_start_stats,
+	.update_stats = ef100_update_stats,
+	.pull_stats = efx_mcdi_mac_pull_stats,
+	.stop_stats = efx_mcdi_mac_stop_stats,
+
+	.mem_bar = NULL,
+	.mem_map_size = NULL,
+
+};


