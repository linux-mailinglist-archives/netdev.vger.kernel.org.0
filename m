Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9045734BDA4
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 19:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhC1RbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 13:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbhC1RbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 13:31:17 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020A1C061762
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:17 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id w2so8880088ilj.12
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/iBlc7XULwydl69GlWkk2zwyP9UzVLKQKKpqET83DZA=;
        b=x5rvBLvExRPTwQzxQ3NhmCq4uTdUFO52pHfGpkQuLBRw2V9bA//4xuYRh6rkKbVLao
         XHJLbmhtTZVIz9Egufb6wS3BUxa3YRsKlwSIgitO5tZOTM3lRQvVOM13+XYjDFibcn6b
         GnDJntz9RhIaDBIVDE/PnSj7f+X3WgKqKjoGhuTzox1+dLI+cY9RTjyyK7/8hGRs9c2r
         VX0s2GKfLkRUBGQoDqfEYl43K4+T4uRZfBKStX7JLGg95Y+MXH5E7X9zAZNdLv5qgILv
         bf3BQOkgkXfNTHOaO6cHYzs+aQnwicI+bDPXJiB9DwZjUti8bEMo/WvQAuinS5TPA8NM
         +ioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/iBlc7XULwydl69GlWkk2zwyP9UzVLKQKKpqET83DZA=;
        b=lDljsbQEoXOZYsUnZ5x7PU+n9IWeIe8RQUmGTtwiNvul/NHRoErwBlx+F8maZdBC27
         TZl724g+vBBh9i3HPp2g546IWrUzhhSMlt5EHYmXdGFP/YtkUgmw2+zIOb+8xppIv8pP
         oOiXzvIJBqw5xaa/P8pBl68uR6TkDeEYfMcrouAW6vUh37I03fUV3lf7qZyzaqnHrdj3
         +9T+V52MTbtkLqqF6Pm9bFiIKrinZqX20ric7Kq/GcRXllAbg4vG79mwsBTBve4ZWAU6
         1eTrFjpVyDCWUu5VcVVggijxCYnH0NBpJiQDdQNGGCmyZ4MZZA0CP4L7s1mUGFL7tnXe
         ruoA==
X-Gm-Message-State: AOAM530dxzejotREGj+wP5lwFbHfOpZGA0nRPrhMgOrod6b8bygk4TZ6
        7EIr+Ghtie4EYEuXJDr1as7chbr6IcaZhham
X-Google-Smtp-Source: ABdhPJy8rqofNSfI+pCe+9g8lXmL7nSVNcrpzmGefeOupeO92wEf1DMAWFtGKLi4f99itYDO071b4Q==
X-Received: by 2002:a92:1a4b:: with SMTP id z11mr17969039ill.261.1616952676376;
        Sun, 28 Mar 2021 10:31:16 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d22sm8014422iof.48.2021.03.28.10.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 10:31:16 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/7] net: ipa: fix all kernel-doc warnings
Date:   Sun, 28 Mar 2021 12:31:05 -0500
Message-Id: <20210328173111.3399063-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210328173111.3399063-1-elder@linaro.org>
References: <20210328173111.3399063-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix all warnings produced when running:
  scripts/kernel-doc -none drivers/net/ipa/*.[ch]

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_private.h   |  2 +-
 drivers/net/ipa/gsi_trans.h     |  5 +++--
 drivers/net/ipa/ipa.h           |  7 ++++---
 drivers/net/ipa/ipa_cmd.h       | 19 +++++++++++++------
 drivers/net/ipa/ipa_endpoint.h  | 18 +++++++++++++++---
 drivers/net/ipa/ipa_interrupt.h |  1 +
 drivers/net/ipa/ipa_mem.h       |  2 +-
 drivers/net/ipa/ipa_qmi.h       | 14 +++++++++-----
 drivers/net/ipa/ipa_smp2p.h     |  2 +-
 drivers/net/ipa/ipa_table.h     |  3 ++-
 10 files changed, 50 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
index 1785c9d3344d1..ed7bc26f85e9a 100644
--- a/drivers/net/ipa/gsi_private.h
+++ b/drivers/net/ipa/gsi_private.h
@@ -100,7 +100,7 @@ void gsi_channel_doorbell(struct gsi_channel *channel);
 /**
  * gsi_ring_virt() - Return virtual address for a ring entry
  * @ring:	Ring whose address is to be translated
- * @addr:	Index (slot number) of entry
+ * @index:	Index (slot number) of entry
  */
 void *gsi_ring_virt(struct gsi_ring *ring, u32 index);
 
diff --git a/drivers/net/ipa/gsi_trans.h b/drivers/net/ipa/gsi_trans.h
index 3a4ab8a94d827..17fd1822d8a9f 100644
--- a/drivers/net/ipa/gsi_trans.h
+++ b/drivers/net/ipa/gsi_trans.h
@@ -71,7 +71,7 @@ struct gsi_trans {
 
 /**
  * gsi_trans_pool_init() - Initialize a pool of structures for transactions
- * @gsi:	GSI pointer
+ * @pool:	GSI transaction poll pointer
  * @size:	Size of elements in the pool
  * @count:	Minimum number of elements in the pool
  * @max_alloc:	Maximum number of elements allocated at a time from pool
@@ -123,7 +123,8 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 void *gsi_trans_pool_alloc_dma(struct gsi_trans_pool *pool, dma_addr_t *addr);
 
 /**
- * gsi_trans_pool_exit() - Inverse of gsi_trans_pool_init()
+ * gsi_trans_pool_exit_dma() - Inverse of gsi_trans_pool_init_dma()
+ * @dev:	Device used for DMA
  * @pool:	Pool pointer
  */
 void gsi_trans_pool_exit_dma(struct device *dev, struct gsi_trans_pool *pool);
diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 8020776313716..e7ff376cb5b7d 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -44,6 +44,8 @@ enum ipa_flag {
  * @version:		IPA hardware version
  * @pdev:		Platform device
  * @completion:		Used to signal pipeline clear transfer complete
+ * @nb:			Notifier block used for remoteproc SSR
+ * @notifier:		Remoteproc SSR notifier
  * @smp2p:		SMP2P information
  * @clock:		IPA clocking information
  * @table_addr:		DMA address of filter/route table content
@@ -58,13 +60,12 @@ enum ipa_flag {
  * @mem_size:		Total size (bytes) of memory at @mem_virt
  * @mem:		Array of IPA-local memory region descriptors
  * @imem_iova:		I/O virtual address of IPA region in IMEM
- * @imem_size;		Size of IMEM region
+ * @imem_size:		Size of IMEM region
  * @smem_iova:		I/O virtual address of IPA region in SMEM
- * @smem_size;		Size of SMEM region
+ * @smem_size:		Size of SMEM region
  * @zero_addr:		DMA address of preallocated zero-filled memory
  * @zero_virt:		Virtual address of preallocated zero-filled memory
  * @zero_size:		Size (bytes) of preallocated zero-filled memory
- * @wakeup_source:	Wakeup source information
  * @available:		Bit mask indicating endpoints hardware supports
  * @filter_map:		Bit mask indicating endpoints that support filtering
  * @initialized:	Bit mask indicating endpoints initialized
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index 6dd3d35cf315d..b99262281f41c 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -20,11 +20,18 @@ struct gsi_channel;
 /**
  * enum ipa_cmd_opcode:	IPA immediate commands
  *
+ * @IPA_CMD_IP_V4_FILTER_INIT:	Initialize IPv4 filter table
+ * @IPA_CMD_IP_V6_FILTER_INIT:	Initialize IPv6 filter table
+ * @IPA_CMD_IP_V4_ROUTING_INIT:	Initialize IPv4 routing table
+ * @IPA_CMD_IP_V6_ROUTING_INIT:	Initialize IPv6 routing table
+ * @IPA_CMD_HDR_INIT_LOCAL:	Initialize IPA-local header memory
+ * @IPA_CMD_REGISTER_WRITE:	Register write performed by IPA
+ * @IPA_CMD_IP_PACKET_INIT:	Set up next packet's destination endpoint
+ * @IPA_CMD_DMA_SHARED_MEM:	DMA command performed by IPA
+ * @IPA_CMD_IP_PACKET_TAG_STATUS: Have next packet generate tag * status
+ * @IPA_CMD_NONE:		Special (invalid) "not a command" value
+ *
  * All immediate commands are issued using the AP command TX endpoint.
- * The numeric values here are the opcodes for IPA v3.5.1 hardware.
- *
- * IPA_CMD_NONE is a special (invalid) value that's used to indicate
- * a request is *not* an immediate command.
  */
 enum ipa_cmd_opcode {
 	IPA_CMD_NONE			= 0x0,
@@ -96,7 +103,7 @@ static inline bool ipa_cmd_data_valid(struct ipa *ipa)
  *
  * Return:	0 if successful, or a negative error code
  */
-int ipa_cmd_pool_init(struct gsi_channel *gsi_channel, u32 tre_count);
+int ipa_cmd_pool_init(struct gsi_channel *channel, u32 tre_count);
 
 /**
  * ipa_cmd_pool_exit() - Inverse of ipa_cmd_pool_init()
@@ -124,7 +131,7 @@ void ipa_cmd_table_init_add(struct gsi_trans *trans, enum ipa_cmd_opcode opcode,
 
 /**
  * ipa_cmd_hdr_init_local_add() - Add a header init command to a transaction
- * @ipa:	IPA structure
+ * @trans:	GSI transaction
  * @offset:	Offset of header memory in IPA local space
  * @size:	Size of header memory
  * @addr:	DMA address of buffer to be written from
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index c6c55ea35394f..0d410b0504562 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -41,8 +41,20 @@ enum ipa_endpoint_name {
 
 /**
  * struct ipa_endpoint - IPA endpoint information
- * @channel_id:	EP's GSI channel
- * @evt_ring_id: EP's GSI channel event ring
+ * @ipa:		IPA pointer
+ * @ee_id:		Execution environmnent endpoint is associated with
+ * @channel_id:		GSI channel used by the endpoint
+ * @endpoint_id:	IPA endpoint number
+ * @toward_ipa:		Endpoint direction (true = TX, false = RX)
+ * @data:		Endpoint configuration data
+ * @trans_tre_max:	Maximum number of TRE descriptors per transaction
+ * @evt_ring_id:	GSI event ring used by the endpoint
+ * @netdev:		Network device pointer, if endpoint uses one
+ * @replenish_enabled:	Whether receive buffer replenishing is enabled
+ * @replenish_ready:	Number of replenish transactions without doorbell
+ * @replenish_saved:	Replenish requests held while disabled
+ * @replenish_backlog:	Number of buffers needed to fill hardware queue
+ * @replenish_work:	Work item used for repeated replenish failures
  */
 struct ipa_endpoint {
 	struct ipa *ipa;
@@ -52,7 +64,7 @@ struct ipa_endpoint {
 	bool toward_ipa;
 	const struct ipa_endpoint_config_data *data;
 
-	u32 trans_tre_max;	/* maximum descriptors per transaction */
+	u32 trans_tre_max;
 	u32 evt_ring_id;
 
 	/* Net device this endpoint is associated with, if any */
diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
index b5d63a0cd19e4..d5c486a6800d9 100644
--- a/drivers/net/ipa/ipa_interrupt.h
+++ b/drivers/net/ipa/ipa_interrupt.h
@@ -24,6 +24,7 @@ typedef void (*ipa_irq_handler_t)(struct ipa *ipa, enum ipa_irq_id irq_id);
 
 /**
  * ipa_interrupt_add() - Register a handler for an IPA interrupt type
+ * @interrupt:	IPA interrupt structure
  * @irq_id:	IPA interrupt type
  * @handler:	Handler function for the interrupt
  *
diff --git a/drivers/net/ipa/ipa_mem.h b/drivers/net/ipa/ipa_mem.h
index f82e8939622bb..df61ef48df365 100644
--- a/drivers/net/ipa/ipa_mem.h
+++ b/drivers/net/ipa/ipa_mem.h
@@ -77,7 +77,7 @@ enum ipa_mem_id {
  * struct ipa_mem - IPA local memory region description
  * @offset:		offset in IPA memory space to base of the region
  * @size:		size in bytes base of the region
- * @canary_count	# 32-bit "canary" values that precede region
+ * @canary_count:	Number of 32-bit "canary" values that precede region
  */
 struct ipa_mem {
 	u32 offset;
diff --git a/drivers/net/ipa/ipa_qmi.h b/drivers/net/ipa/ipa_qmi.h
index 3993687593d0c..b6f2055d35a68 100644
--- a/drivers/net/ipa/ipa_qmi.h
+++ b/drivers/net/ipa/ipa_qmi.h
@@ -13,11 +13,15 @@ struct ipa;
 
 /**
  * struct ipa_qmi - QMI state associated with an IPA
- * @client_handle	- used to send an QMI requests to the modem
- * @server_handle	- used to handle QMI requests from the modem
- * @initialized		- whether QMI initialization has completed
- * @indication_register_received - tracks modem request receipt
- * @init_driver_response_received - tracks modem response receipt
+ * @client_handle:	Used to send an QMI requests to the modem
+ * @server_handle:	Used to handle QMI requests from the modem
+ * @modem_sq:		QMAP socket address for the modem QMI server
+ * @init_driver_work:	Work structure used for INIT_DRIVER message handling
+ * @initial_boot:	True if first boot has not yet completed
+ * @uc_ready:		True once DRIVER_INIT_COMPLETE request received
+ * @modem_ready:	True when INIT_DRIVER response received
+ * @indication_requested: True when INDICATION_REGISTER request received
+ * @indication_sent:	True when INIT_COMPLETE indication sent
  */
 struct ipa_qmi {
 	struct qmi_handle client_handle;
diff --git a/drivers/net/ipa/ipa_smp2p.h b/drivers/net/ipa/ipa_smp2p.h
index bf0e4063cfd96..20319438a8419 100644
--- a/drivers/net/ipa/ipa_smp2p.h
+++ b/drivers/net/ipa/ipa_smp2p.h
@@ -28,7 +28,7 @@ void ipa_smp2p_exit(struct ipa *ipa);
 
 /**
  * ipa_smp2p_disable() - Prevent "ipa-setup-ready" interrupt handling
- * @IPA:	IPA pointer
+ * @ipa:	IPA pointer
  *
  * Prevent handling of the "setup ready" interrupt from the modem.
  * This is used before initiating shutdown of the driver.
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 889c2e93b1223..e14108ed62bdd 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -24,7 +24,7 @@ struct ipa;
 /**
  * ipa_table_valid() - Validate route and filter table memory regions
  * @ipa:	IPA pointer
-
+ *
  * Return:	true if all regions are valid, false otherwise
  */
 bool ipa_table_valid(struct ipa *ipa);
@@ -32,6 +32,7 @@ bool ipa_table_valid(struct ipa *ipa);
 /**
  * ipa_filter_map_valid() - Validate a filter table endpoint bitmap
  * @ipa:	IPA pointer
+ * @filter_mask: Filter table endpoint bitmap to check
  *
  * Return:	true if all regions are valid, false otherwise
  */
-- 
2.27.0

