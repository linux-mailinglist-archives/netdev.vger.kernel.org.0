Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E501DD6BA
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730387AbgEUTJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:09:49 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:13580 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730133AbgEUTJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590088187; x=1621624187;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=WaFd1RhWASM4HbYYX/JElnmDgOfd0WESgkvpPJFft3U=;
  b=g51YesBBrgRwmVyA0wbCYyCcrO6cBsY7zLmVixPNWDs9kL/kANKh86b6
   xr3Ih4ZejQtDa4RbLsLDQLzPEwyBqap+dw1j/eCD1qwBudO6TmqlU+psH
   DhQeLLkHqFa2Y0gzTTXBU5O+8JC2pTwV87O04/X1v1TO4eLPQAL6jqjTm
   U=;
IronPort-SDR: 7oaTJg3qptRFoej2wCElyy8xYO0Ub/a8S8YtfX319Z1Ipd3q2If4QC4uP0iaTiTEqrs5yYIRpY
 ullPb+NS4g/Q==
X-IronPort-AV: E=Sophos;i="5.73,418,1583193600"; 
   d="scan'208";a="31646429"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 21 May 2020 19:09:42 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 47B6DA1DCE;
        Thu, 21 May 2020 19:09:41 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:09:07 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:09:07 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.27) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 21 May 2020 19:09:04 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 09/15] net: ena: cosmetic: fix spelling and grammar mistakes in comments
Date:   Thu, 21 May 2020 22:08:28 +0300
Message-ID: <1590088114-381-10-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590088114-381-1-git-send-email-akiyano@amazon.com>
References: <1590088114-381-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

fix spelling and grammar mistakes in comments in ena_com.h,
ena_com.c and ena_netdev.c

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c    |  2 +-
 drivers/net/ethernet/amazon/ena/ena_com.h    | 30 ++++++++++----------
 drivers/net/ethernet/amazon/ena/ena_netdev.c |  2 +-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index e2025eb86984..d47821655d61 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -772,7 +772,7 @@ static int ena_com_wait_and_process_admin_cq_interrupts(struct ena_comp_ctx *com
 			if (admin_queue->auto_polling)
 				admin_queue->polling = true;
 		} else {
-			pr_err("The ena device doesn't send a completion for the admin cmd %d status %d\n",
+			pr_err("The ena device didn't send a completion for the admin cmd %d status %d\n",
 			       comp_ctx->cmd_opcode, comp_ctx->status);
 		}
 		/* Check if shifted to polling mode.
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 13a1b7812c46..bd65ae205f8d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -393,7 +393,7 @@ struct ena_aenq_handlers {
  */
 int ena_com_mmio_reg_read_request_init(struct ena_com_dev *ena_dev);
 
-/* ena_com_set_mmio_read_mode - Enable/disable the mmio reg read mechanism
+/* ena_com_set_mmio_read_mode - Enable/disable the indirect mmio reg read mechanism
  * @ena_dev: ENA communication layer struct
  * @readless_supported: readless mode (enable/disable)
  */
@@ -515,7 +515,7 @@ void ena_com_set_admin_auto_polling_mode(struct ena_com_dev *ena_dev,
 /* ena_com_admin_q_comp_intr_handler - admin queue interrupt handler
  * @ena_dev: ENA communication layer struct
  *
- * This method go over the admin completion queue and wake up all the pending
+ * This method goes over the admin completion queue and wakes up all the pending
  * threads that wait on the commands wait event.
  *
  * @note: Should be called after MSI-X interrupt.
@@ -525,7 +525,7 @@ void ena_com_admin_q_comp_intr_handler(struct ena_com_dev *ena_dev);
 /* ena_com_aenq_intr_handler - AENQ interrupt handler
  * @ena_dev: ENA communication layer struct
  *
- * This method go over the async event notification queue and call the proper
+ * This method goes over the async event notification queue and calls the proper
  * aenq handler.
  */
 void ena_com_aenq_intr_handler(struct ena_com_dev *dev, void *data);
@@ -542,14 +542,14 @@ void ena_com_abort_admin_commands(struct ena_com_dev *ena_dev);
 /* ena_com_wait_for_abort_completion - Wait for admin commands abort.
  * @ena_dev: ENA communication layer struct
  *
- * This method wait until all the outstanding admin commands will be completed.
+ * This method waits until all the outstanding admin commands are completed.
  */
 void ena_com_wait_for_abort_completion(struct ena_com_dev *ena_dev);
 
 /* ena_com_validate_version - Validate the device parameters
  * @ena_dev: ENA communication layer struct
  *
- * This method validate the device parameters are the same as the saved
+ * This method verifies the device parameters are the same as the saved
  * parameters in ena_dev.
  * This method is useful after device reset, to validate the device mac address
  * and the device offloads are the same as before the reset.
@@ -689,7 +689,7 @@ int ena_com_set_hash_function(struct ena_com_dev *ena_dev);
  *
  * Retrieve the hash function from the device.
  *
- * @note: If the caller called ena_com_fill_hash_function but didn't flash
+ * @note: If the caller called ena_com_fill_hash_function but didn't flush
  * it to the device, the new configuration will be lost.
  *
  * @return: 0 on Success and negative value otherwise.
@@ -703,7 +703,7 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
  *
  * Retrieve the hash key.
  *
- * @note: If the caller called ena_com_fill_hash_key but didn't flash
+ * @note: If the caller called ena_com_fill_hash_key but didn't flush
  * it to the device, the new configuration will be lost.
  *
  * @return: 0 on Success and negative value otherwise.
@@ -743,7 +743,7 @@ int ena_com_set_hash_ctrl(struct ena_com_dev *ena_dev);
  *
  * Retrieve the hash control from the device.
  *
- * @note, If the caller called ena_com_fill_hash_ctrl but didn't flash
+ * @note: If the caller called ena_com_fill_hash_ctrl but didn't flush
  * it to the device, the new configuration will be lost.
  *
  * @return: 0 on Success and negative value otherwise.
@@ -795,7 +795,7 @@ int ena_com_indirect_table_set(struct ena_com_dev *ena_dev);
  *
  * Retrieve the RSS indirection table from the device.
  *
- * @note: If the caller called ena_com_indirect_table_fill_entry but didn't flash
+ * @note: If the caller called ena_com_indirect_table_fill_entry but didn't flush
  * it to the device, the new configuration will be lost.
  *
  * @return: 0 on Success and negative value otherwise.
@@ -821,14 +821,14 @@ int ena_com_allocate_debug_area(struct ena_com_dev *ena_dev,
 /* ena_com_delete_debug_area - Free the debug area resources.
  * @ena_dev: ENA communication layer struct
  *
- * Free the allocate debug area.
+ * Free the allocated debug area.
  */
 void ena_com_delete_debug_area(struct ena_com_dev *ena_dev);
 
 /* ena_com_delete_host_info - Free the host info resources.
  * @ena_dev: ENA communication layer struct
  *
- * Free the allocate host info.
+ * Free the allocated host info.
  */
 void ena_com_delete_host_info(struct ena_com_dev *ena_dev);
 
@@ -869,9 +869,9 @@ int ena_com_destroy_io_cq(struct ena_com_dev *ena_dev,
  * @cmd_completion: command completion return value.
  * @cmd_comp_size: command completion size.
 
- * Submit an admin command and then wait until the device will return a
+ * Submit an admin command and then wait until the device returns a
  * completion.
- * The completion will be copyed into cmd_comp.
+ * The completion will be copied into cmd_comp.
  *
  * @return - 0 on success, negative value on failure.
  */
@@ -934,7 +934,7 @@ unsigned int ena_com_get_nonadaptive_moderation_interval_rx(struct ena_com_dev *
 /* ena_com_config_dev_mode - Configure the placement policy of the device.
  * @ena_dev: ENA communication layer struct
  * @llq_features: LLQ feature descriptor, retrieve via
- *                ena_com_get_dev_attr_feat.
+ *		   ena_com_get_dev_attr_feat.
  * @ena_llq_config: The default driver LLQ parameters configurations
  */
 int ena_com_config_dev_mode(struct ena_com_dev *ena_dev,
@@ -960,7 +960,7 @@ static inline void ena_com_disable_adaptive_moderation(struct ena_com_dev *ena_d
  * @intr_reg: interrupt register to update.
  * @rx_delay_interval: Rx interval in usecs
  * @tx_delay_interval: Tx interval in usecs
- * @unmask: unask enable/disable
+ * @unmask: unmask enable/disable
  *
  * Prepare interrupt update register with the supplied parameters.
  */
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0999fe3310fb..0349e0305608 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4190,7 +4190,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	calc_queue_ctx.get_feat_ctx = &get_feat_ctx;
 	calc_queue_ctx.pdev = pdev;
 
-	/* Initial Tx and RX interrupt delay. Assumes 1 usec granularity.
+	/* Initial TX and RX interrupt delay. Assumes 1 usec granularity.
 	 * Updated during device initialization with the real granularity
 	 */
 	ena_dev->intr_moder_tx_interval = ENA_INTR_INITIAL_TX_INTERVAL_USECS;
-- 
2.23.1

