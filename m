Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C6521D5CE
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 14:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgGMMYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 08:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729143AbgGMMYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 08:24:24 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AF2C061794
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 05:24:22 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k23so13141451iom.10
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 05:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rH+4EOsPVO/2tJdOHNE0zk/1CcnMU6zw9H/LxhbEyTc=;
        b=msAM6U/Bfam0NMVOxcFCEtZoD8iq14qog8IW9seSGRKtDQEsU8CqEpFqJgKVuEWTrC
         VJoPs8Vrv5THImPC7fitB5krn6X6FeJI4u2oe/Uk/ZPMbQyVTw+TDNdlMIROm/CoWVsr
         19fv9r+PD/jZZnrL/GP77gDywob1j/3CnfyfoqkRnJs+mVFevb1OMrr2YR07nJgeqRXE
         XWqfv0uQDsMYtzCCI6DJOoDgfXU5Dwuvx+4xDuMYF/nmNRFI/hIH/lF2Kt6BxGWoSok+
         2kjti6svyVwn8AOwlVDpOtX+itixKPctJjou8ZKoffJaR4+cM1Rszj/J6vgVi23jPgao
         QF/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rH+4EOsPVO/2tJdOHNE0zk/1CcnMU6zw9H/LxhbEyTc=;
        b=k2TrZJbRdP+opE7drBjnZ9kCZOF7MNjRVdSEklvCtRdbfI4rdeBtDYrOSe/5KbSvXd
         CZmwLLjYSG7j3h50RvB01QKrB0ytupaKBIEaIuYeiv69IPdfDlf7LG44eIPlk+sGUMCJ
         uKvOKKa4v2iWNStKxQicQ5yaRGQkuTDD2AUKQRTSGEgyGZ1B+cBnuXwWJIzwKElAp/xu
         sziqgJbhK/JbYKI+Aa4SedeH8F/Dg/m1vN9OJvMzA8ppAOHutqyrqXxy8WC42mYzRu1w
         DFjZbY6YwS+FvVwsbRpANZWmp1YakYnatRuaQd5vCIRRXzARU6PTiegeJnJO4iZcNyk9
         fuRA==
X-Gm-Message-State: AOAM530rFIG0O2K/beX3fNnkpnIn5/fR+Gj3Gbv1W5ajXyMqEgK0KQ1A
        NIerJiNjaQD1EP1lZA/Kpnh0Jw==
X-Google-Smtp-Source: ABdhPJy1WZ/25DLMYpRhcS2CY+M/5ujJqonihJs7RJ6DHKvk6hw9xWjCoG0LNAoiHZgQ/smzwIXFBA==
X-Received: by 2002:a5d:8f04:: with SMTP id f4mr60452011iof.33.1594643061890;
        Mon, 13 Jul 2020 05:24:21 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u5sm8501038ili.33.2020.07.13.05.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 05:24:20 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: fix kerneldoc comments
Date:   Mon, 13 Jul 2020 07:24:18 -0500
Message-Id: <20200713122418.505734-1-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit affects comments (and in one case, whitespace) only.

Throughout the IPA code, return statements are documented using
"@Return:", whereas they should use "Return:" instead.  Fix these
mistakes.

In function definitions, some parameters are missing their comment
to describe them.  And in structure definitions, some fields are
missing their comment to describe them.  Add these missing
descriptions.

Some arguments changed name and type along the way, but their
descriptions were not updated (an endpoint pointer is now used in
many places that previously used an endpoint ID).  Fix these
incorrect parameter descriptions.

In the description for the ipa_clock structure, one field had a
semicolon instead of a colon in its description.  Fix this.

Add a missing function description for ipa_gsi_endpoint_data_empty().

All of these issues were identified when building with "W=1".

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c           |  6 +++---
 drivers/net/ipa/gsi.h           | 12 ++++++------
 drivers/net/ipa/gsi_private.h   |  6 +++---
 drivers/net/ipa/gsi_trans.h     | 12 ++++++------
 drivers/net/ipa/ipa_clock.c     |  2 +-
 drivers/net/ipa/ipa_clock.h     |  2 +-
 drivers/net/ipa/ipa_cmd.h       | 10 +++++-----
 drivers/net/ipa/ipa_endpoint.c  |  9 +++++++--
 drivers/net/ipa/ipa_gsi.h       | 13 +++++++++++--
 drivers/net/ipa/ipa_interrupt.h |  2 +-
 drivers/net/ipa/ipa_main.c      |  8 +++++---
 drivers/net/ipa/ipa_mem.c       |  7 +++++--
 drivers/net/ipa/ipa_smp2p.h     |  2 +-
 drivers/net/ipa/ipa_table.c     |  3 ++-
 drivers/net/ipa/ipa_table.h     |  4 ++--
 drivers/net/ipa/ipa_uc.c        |  5 +++++
 16 files changed, 64 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 1ab41e0e134e..0e63d35320aa 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1363,7 +1363,7 @@ static void gsi_channel_update(struct gsi_channel *channel)
  * gsi_channel_poll_one() - Return a single completed transaction on a channel
  * @channel:	Channel to be polled
  *
- * @Return:	Transaction pointer, or null if none are available
+ * Return:	Transaction pointer, or null if none are available
  *
  * This function returns the first entry on a channel's completed transaction
  * list.  If that list is empty, the hardware is consulted to determine
@@ -1393,8 +1393,8 @@ static struct gsi_trans *gsi_channel_poll_one(struct gsi_channel *channel)
  * gsi_channel_poll() - NAPI poll function for a channel
  * @napi:	NAPI structure for the channel
  * @budget:	Budget supplied by NAPI core
-
- * @Return:	 Number of items polled (<= budget)
+ *
+ * Return:	Number of items polled (<= budget)
  *
  * Single transactions completed by hardware are polled until either
  * the budget is exhausted, or there are no more.  Each transaction
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 90a02194e7ad..061312773df0 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -167,7 +167,7 @@ struct gsi {
  * @gsi:	Address of GSI structure embedded in an IPA structure
  * @legacy:	Set up for legacy hardware
  *
- * @Return:	0 if successful, or a negative error code
+ * Return:	0 if successful, or a negative error code
  *
  * Performs initialization that must wait until the GSI hardware is
  * ready (including firmware loaded).
@@ -185,7 +185,7 @@ void gsi_teardown(struct gsi *gsi);
  * @gsi:	GSI pointer
  * @channel_id:	Channel whose limit is to be returned
  *
- * @Return:	 The maximum number of TREs oustanding on the channel
+ * Return:	 The maximum number of TREs oustanding on the channel
  */
 u32 gsi_channel_tre_max(struct gsi *gsi, u32 channel_id);
 
@@ -194,7 +194,7 @@ u32 gsi_channel_tre_max(struct gsi *gsi, u32 channel_id);
  * @gsi:	GSI pointer
  * @channel_id:	Channel whose limit is to be returned
  *
- * @Return:	 The maximum TRE count per transaction on the channel
+ * Return:	 The maximum TRE count per transaction on the channel
  */
 u32 gsi_channel_trans_tre_max(struct gsi *gsi, u32 channel_id);
 
@@ -203,7 +203,7 @@ u32 gsi_channel_trans_tre_max(struct gsi *gsi, u32 channel_id);
  * @gsi:	GSI pointer
  * @channel_id:	Channel to start
  *
- * @Return:	0 if successful, or a negative error code
+ * Return:	0 if successful, or a negative error code
  */
 int gsi_channel_start(struct gsi *gsi, u32 channel_id);
 
@@ -212,7 +212,7 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id);
  * @gsi:	GSI pointer returned by gsi_setup()
  * @channel_id:	Channel to stop
  *
- * @Return:	0 if successful, or a negative error code
+ * Return:	0 if successful, or a negative error code
  */
 int gsi_channel_stop(struct gsi *gsi, u32 channel_id);
 
@@ -238,7 +238,7 @@ int gsi_channel_resume(struct gsi *gsi, u32 channel_id, bool start);
  * @gsi:	Address of GSI structure embedded in an IPA structure
  * @pdev:	IPA platform device
  *
- * @Return:	0 if successful, or a negative error code
+ * Return:	0 if successful, or a negative error code
  *
  * Early stage initialization of the GSI subsystem, performing tasks
  * that can be done before the GSI hardware is ready to use.
diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
index b57d0198ebc1..1785c9d3344d 100644
--- a/drivers/net/ipa/gsi_private.h
+++ b/drivers/net/ipa/gsi_private.h
@@ -44,7 +44,7 @@ void gsi_trans_complete(struct gsi_trans *trans);
  * @channel:	Channel associated with the transaction
  * @index:	Index of the TRE having a transaction
  *
- * @Return:	The GSI transaction pointer associated with the TRE index
+ * Return:	The GSI transaction pointer associated with the TRE index
  */
 struct gsi_trans *gsi_channel_trans_mapped(struct gsi_channel *channel,
 					   u32 index);
@@ -53,7 +53,7 @@ struct gsi_trans *gsi_channel_trans_mapped(struct gsi_channel *channel,
  * gsi_channel_trans_complete() - Return a channel's next completed transaction
  * @channel:	Channel whose next transaction is to be returned
  *
- * @Return:	The next completed transaction, or NULL if nothing new
+ * Return:	The next completed transaction, or NULL if nothing new
  */
 struct gsi_trans *gsi_channel_trans_complete(struct gsi_channel *channel);
 
@@ -76,7 +76,7 @@ void gsi_channel_trans_cancel_pending(struct gsi_channel *channel);
  * @gsi:	GSI pointer
  * @channel_id:	Channel number
  *
- * @Return:	0 if successful, or -ENOMEM on allocation failure
+ * Return:	0 if successful, or -ENOMEM on allocation failure
  *
  * Creates and sets up information for managing transactions on a channel
  */
diff --git a/drivers/net/ipa/gsi_trans.h b/drivers/net/ipa/gsi_trans.h
index 1477fc15b30a..4d4606b5fa95 100644
--- a/drivers/net/ipa/gsi_trans.h
+++ b/drivers/net/ipa/gsi_trans.h
@@ -75,7 +75,7 @@ struct gsi_trans {
  * @count:	Minimum number of elements in the pool
  * @max_alloc:	Maximum number of elements allocated at a time from pool
  *
- * @Return:	0 if successful, or a negative error code
+ * Return:	0 if successful, or a negative error code
  */
 int gsi_trans_pool_init(struct gsi_trans_pool *pool, size_t size, u32 count,
 			u32 max_alloc);
@@ -85,7 +85,7 @@ int gsi_trans_pool_init(struct gsi_trans_pool *pool, size_t size, u32 count,
  * @pool:	Pool pointer
  * @count:	Number of elements to allocate from the pool
  *
- * @Return:	Virtual address of element(s) allocated from the pool
+ * Return:	Virtual address of element(s) allocated from the pool
  */
 void *gsi_trans_pool_alloc(struct gsi_trans_pool *pool, u32 count);
 
@@ -103,7 +103,7 @@ void gsi_trans_pool_exit(struct gsi_trans_pool *pool);
  * @count:	Minimum number of elements in the pool
  * @max_alloc:	Maximum number of elements allocated at a time from pool
  *
- * @Return:	0 if successful, or a negative error code
+ * Return:	0 if successful, or a negative error code
  *
  * Structures in this pool reside in DMA-coherent memory.
  */
@@ -115,7 +115,7 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
  * @pool:	DMA pool pointer
  * @addr:	DMA address "handle" associated with the allocation
  *
- * @Return:	Virtual address of element allocated from the pool
+ * Return:	Virtual address of element allocated from the pool
  *
  * Only one element at a time may be allocated from a DMA pool.
  */
@@ -134,7 +134,7 @@ void gsi_trans_pool_exit_dma(struct device *dev, struct gsi_trans_pool *pool);
  * @tre_count:	Number of elements in the transaction
  * @direction:	DMA direction for entire SGL (or DMA_NONE)
  *
- * @Return:	A GSI transaction structure, or a null pointer if all
+ * Return:	A GSI transaction structure, or a null pointer if all
  *		available transactions are in use
  */
 struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
@@ -175,7 +175,7 @@ int gsi_trans_page_add(struct gsi_trans *trans, struct page *page, u32 size,
  * @trans:	Transaction
  * @skb:	Socket buffer for transfer (outbound)
  *
- * @Return:	0, or -EMSGSIZE if socket data won't fit in transaction.
+ * Return:	0, or -EMSGSIZE if socket data won't fit in transaction.
  */
 int gsi_trans_skb_add(struct gsi_trans *trans, struct sk_buff *skb);
 
diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 0fbc8b1bdf41..398f2e47043d 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -44,7 +44,7 @@
 /**
  * struct ipa_clock - IPA clocking information
  * @count:		Clocking reference count
- * @mutex;		Protects clock enable/disable
+ * @mutex:		Protects clock enable/disable
  * @core:		IPA core clock
  * @memory_path:	Memory interconnect
  * @imem_path:		Internal memory interconnect
diff --git a/drivers/net/ipa/ipa_clock.h b/drivers/net/ipa/ipa_clock.h
index 0f4e2877a6df..1d70f1de3875 100644
--- a/drivers/net/ipa/ipa_clock.h
+++ b/drivers/net/ipa/ipa_clock.h
@@ -22,7 +22,7 @@ u32 ipa_clock_rate(struct ipa *ipa);
  * ipa_clock_init() - Initialize IPA clocking
  * @dev:	IPA device
  *
- * @Return:	A pointer to an ipa_clock structure, or a pointer-coded error
+ * Return:	A pointer to an ipa_clock structure, or a pointer-coded error
  */
 struct ipa_clock *ipa_clock_init(struct device *dev);
 
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index 1a646e0264a0..f7e6f87facf7 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -61,7 +61,7 @@ struct ipa_cmd_info {
  * @ipv6:	- Whether the table is for IPv6 or IPv4
  * @hashed:	- Whether the table is hashed or non-hashed
  *
- * @Return:	true if region is valid, false otherwise
+ * Return:	true if region is valid, false otherwise
  */
 bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
 			    bool route, bool ipv6, bool hashed);
@@ -70,7 +70,7 @@ bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
  * ipa_cmd_data_valid() - Validate command-realted configuration is valid
  * @ipa:	- IPA pointer
  *
- * @Return:	true if assumptions required for command are valid
+ * Return:	true if assumptions required for command are valid
  */
 bool ipa_cmd_data_valid(struct ipa *ipa);
 
@@ -95,7 +95,7 @@ static inline bool ipa_cmd_data_valid(struct ipa *ipa)
  * @channel:	AP->IPA command TX GSI channel pointer
  * @tre_count:	Number of pool elements to allocate
  *
- * @Return:	0 if successful, or a negative error code
+ * Return:	0 if successful, or a negative error code
  */
 int ipa_cmd_pool_init(struct gsi_channel *gsi_channel, u32 tre_count);
 
@@ -166,7 +166,7 @@ void ipa_cmd_tag_process_add(struct gsi_trans *trans);
 /**
  * ipa_cmd_tag_process_add_count() - Number of commands in a tag process
  *
- * @Return:	The number of elements to allocate in a transaction
+ * Return:	The number of elements to allocate in a transaction
  *		to hold tag process commands
  */
 u32 ipa_cmd_tag_process_count(void);
@@ -184,7 +184,7 @@ void ipa_cmd_tag_process(struct ipa *ipa);
  * @ipa:	IPA pointer
  * @tre_count:	Number of elements in the transaction
  *
- * @Return:	A GSI transaction structure, or a null pointer if all
+ * Return:	A GSI transaction structure, or a null pointer if all
  *		available transactions are in use
  */
 struct gsi_trans *ipa_cmd_trans_alloc(struct ipa *ipa, u32 tre_count);
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 9de81d85682e..b7efd7c95e9c 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -349,7 +349,7 @@ static void ipa_endpoint_force_close(struct ipa_endpoint *endpoint)
 
 /**
  * ipa_endpoint_suspend_aggr() - Emulate suspend interrupt
- * @endpoint_id:	Endpoint on which to emulate a suspend
+ * @endpoint:	Endpoint on which to emulate a suspend
  *
  *  Emulate suspend IPA interrupt to unsuspend an endpoint suspended
  *  with an open aggregation frame.  This is to work around a hardware
@@ -499,6 +499,9 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 }
 
 /**
+ * ipa_endpoint_init_hdr() - Initialize HDR endpoint configuration register
+ * @endpoint:	Endpoint pointer
+ *
  * We program QMAP endpoints so each packet received is preceded by a QMAP
  * header structure.  The QMAP header contains a 1-byte mux_id and 2-byte
  * packet size field, and we have the IPA hardware populate both for each
@@ -921,6 +924,8 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
 
 /**
  * ipa_endpoint_replenish() - Replenish the Rx packets cache.
+ * @endpoint:	Endpoint to be replenished
+ * @count:	Number of buffers to send to hardware
  *
  * Allocate RX packet wrapper structures with maximal socket buffers
  * for an endpoint.  These are supplied to the hardware, which fills
@@ -1231,7 +1236,7 @@ void ipa_endpoint_default_route_clear(struct ipa *ipa)
  * on its underlying GSI channel, a special sequence of actions must be
  * taken to ensure the IPA pipeline is properly cleared.
  *
- * @Return:	0 if successful, or a negative error code
+ * Return:	0 if successful, or a negative error code
  */
 static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
 {
diff --git a/drivers/net/ipa/ipa_gsi.h b/drivers/net/ipa/ipa_gsi.h
index 0a40f3dc55fc..c02cb6f3a2e1 100644
--- a/drivers/net/ipa/ipa_gsi.h
+++ b/drivers/net/ipa/ipa_gsi.h
@@ -43,9 +43,9 @@ void ipa_gsi_trans_release(struct gsi_trans *trans);
  */
 void ipa_gsi_channel_tx_queued(struct gsi *gsi, u32 channel_id, u32 count,
 			       u32 byte_count);
+
 /**
- * ipa_gsi_trans_complete() - GSI transaction completion callback
-ipa_gsi_channel_tx_completed()
+ * ipa_gsi_channel_tx_completed() - GSI transaction completion callback
  * @gsi:	GSI pointer
  * @channel_id:	Channel number
  * @count:	Number of transactions completed since last report
@@ -57,6 +57,15 @@ ipa_gsi_channel_tx_completed()
 void ipa_gsi_channel_tx_completed(struct gsi *gsi, u32 channel_id, u32 count,
 				  u32 byte_count);
 
+/* ipa_gsi_endpoint_data_empty() - Empty endpoint config data test
+ * @data:	endpoint configuration data
+ *
+ * Determines whether an endpoint configuration data entry is empty,
+ * meaning it contains no valid configuration information and should
+ * be ignored.
+ *
+ * Return:	true if empty; false otherwise
+ */
 bool ipa_gsi_endpoint_data_empty(const struct ipa_gsi_endpoint_data *data);
 
 #endif /* _IPA_GSI_TRANS_H_ */
diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
index d4f4c1c9f0b1..727e9c5044d1 100644
--- a/drivers/net/ipa/ipa_interrupt.h
+++ b/drivers/net/ipa/ipa_interrupt.h
@@ -104,7 +104,7 @@ void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt);
  * ipa_interrupt_setup() - Set up the IPA interrupt framework
  * @ipa:	IPA pointer
  *
- * @Return:	Pointer to IPA SMP2P info, or a pointer-coded error
+ * Return:	Pointer to IPA SMP2P info, or a pointer-coded error
  */
 struct ipa_interrupt *ipa_interrupt_setup(struct ipa *ipa);
 
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 27a869df3a4b..1fdfec41e442 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -277,6 +277,7 @@ static void ipa_idle_indication_cfg(struct ipa *ipa,
 
 /**
  * ipa_hardware_dcd_config() - Enable dynamic clock division on IPA
+ * @ipa:	IPA pointer
  *
  * Configures when the IPA signals it is idle to the global clock
  * controller, which can respond by scalling down the clock to
@@ -495,6 +496,7 @@ static void ipa_resource_deconfig(struct ipa *ipa)
 /**
  * ipa_config() - Configure IPA hardware
  * @ipa:	IPA pointer
+ * @data:	IPA configuration data
  *
  * Perform initialization requiring IPA clock to be enabled.
  */
@@ -686,7 +688,7 @@ static void ipa_validate_build(void)
  * ipa_probe() - IPA platform driver probe function
  * @pdev:	Platform device pointer
  *
- * @Return:	0 if successful, or a negative error code (possibly
+ * Return:	0 if successful, or a negative error code (possibly
  *		EPROBE_DEFER)
  *
  * This is the main entry point for the IPA driver.  Initialization proceeds
@@ -902,7 +904,7 @@ static int ipa_remove(struct platform_device *pdev)
  * ipa_suspend() - Power management system suspend callback
  * @dev:	IPA device structure
  *
- * @Return:	Zero
+ * Return:	Always returns zero
  *
  * Called by the PM framework when a system suspend operation is invoked.
  */
@@ -920,7 +922,7 @@ static int ipa_suspend(struct device *dev)
  * ipa_resume() - Power management system resume callback
  * @dev:	IPA device structure
  *
- * @Return:	Always returns 0
+ * Return:	Always returns 0
  *
  * Called by the PM framework when a system resume operation is invoked.
  */
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 3ef814119aab..2d45c444a67f 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -41,6 +41,7 @@ ipa_mem_zero_region_add(struct gsi_trans *trans, const struct ipa_mem *mem)
 
 /**
  * ipa_mem_setup() - Set up IPA AP and modem shared memory areas
+ * @ipa:	IPA pointer
  *
  * Set up the shared memory regions in IPA local memory.  This involves
  * zero-filling memory regions, and in the case of header memory, telling
@@ -52,7 +53,7 @@ ipa_mem_zero_region_add(struct gsi_trans *trans, const struct ipa_mem *mem)
  * The AP informs the modem where its portions of memory are located
  * in a QMI exchange that occurs at modem startup.
  *
- * @Return:	0 if successful, or a negative error code
+ * Return:	0 if successful, or a negative error code
  */
 int ipa_mem_setup(struct ipa *ipa)
 {
@@ -137,8 +138,9 @@ static bool ipa_mem_valid(struct ipa *ipa, enum ipa_mem_id mem_id)
 
 /**
  * ipa_mem_config() - Configure IPA shared memory
+ * @ipa:	IPA pointer
  *
- * @Return:	0 if successful, or a negative error code
+ * Return:	0 if successful, or a negative error code
  */
 int ipa_mem_config(struct ipa *ipa)
 {
@@ -238,6 +240,7 @@ void ipa_mem_deconfig(struct ipa *ipa)
 
 /**
  * ipa_mem_zero_modem() - Zero IPA-local memory regions owned by the modem
+ * @ipa:	IPA pointer
  *
  * Zero regions of IPA-local memory used by the modem.  These are configured
  * (and initially zeroed) by ipa_mem_setup(), but if the modem crashes and
diff --git a/drivers/net/ipa/ipa_smp2p.h b/drivers/net/ipa/ipa_smp2p.h
index 1f65cdc9d406..bf0e4063cfd9 100644
--- a/drivers/net/ipa/ipa_smp2p.h
+++ b/drivers/net/ipa/ipa_smp2p.h
@@ -15,7 +15,7 @@ struct ipa;
  * @ipa:	IPA pointer
  * @modem_init:	Whether the modem is responsible for GSI initialization
  *
- * @Return:	0 if successful, or a negative error code
+ * Return:	0 if successful, or a negative error code
  *
  */
 int ipa_smp2p_init(struct ipa *ipa, bool modem_init);
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 9df2a3e78c98..2098ca2f2c90 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -505,7 +505,7 @@ void ipa_table_teardown(struct ipa *ipa)
 
 /**
  * ipa_filter_tuple_zero() - Zero an endpoint's hashed filter tuple
- * @endpoint_id:	Endpoint whose filter hash tuple should be zeroed
+ * @endpoint:	Endpoint whose filter hash tuple should be zeroed
  *
  * Endpoint must be for the AP (not modem) and support filtering. Updates
  * the filter hash values without changing route ones.
@@ -560,6 +560,7 @@ static bool ipa_route_id_modem(u32 route_id)
 
 /**
  * ipa_route_tuple_zero() - Zero a hashed route table entry tuple
+ * @ipa:	IPA pointer
  * @route_id:	Route table entry whose hash tuple should be zeroed
  *
  * Updates the route hash values without changing filter ones.
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 64ea0221441a..78038d14fcea 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -25,7 +25,7 @@ struct ipa;
  * ipa_table_valid() - Validate route and filter table memory regions
  * @ipa:	IPA pointer
 
- * @Return:	true if all regions are valid, false otherwise
+ * Return:	true if all regions are valid, false otherwise
  */
 bool ipa_table_valid(struct ipa *ipa);
 
@@ -33,7 +33,7 @@ bool ipa_table_valid(struct ipa *ipa);
  * ipa_filter_map_valid() - Validate a filter table endpoint bitmap
  * @ipa:	IPA pointer
  *
- * @Return:	true if all regions are valid, false otherwise
+ * Return:	true if all regions are valid, false otherwise
  */
 bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask);
 
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 9f9980ec2ed3..1a0b04e0ab74 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -41,19 +41,24 @@
 /**
  * struct ipa_uc_mem_area - AP/microcontroller shared memory area
  * @command:		command code (AP->microcontroller)
+ * @reserved0:		reserved bytes; avoid reading or writing
  * @command_param:	low 32 bits of command parameter (AP->microcontroller)
  * @command_param_hi:	high 32 bits of command parameter (AP->microcontroller)
  *
  * @response:		response code (microcontroller->AP)
+ * @reserved1:		reserved bytes; avoid reading or writing
  * @response_param:	response parameter (microcontroller->AP)
  *
  * @event:		event code (microcontroller->AP)
+ * @reserved2:		reserved bytes; avoid reading or writing
  * @event_param:	event parameter (microcontroller->AP)
  *
  * @first_error_address: address of first error-source on SNOC
  * @hw_state:		state of hardware (including error type information)
  * @warning_counter:	counter of non-fatal hardware errors
+ * @reserved3:		reserved bytes; avoid reading or writing
  * @interface_version:	hardware-reported interface version
+ * @reserved4:		reserved bytes; avoid reading or writing
  *
  * A shared memory area at the base of IPA resident memory is used for
  * communication with the microcontroller.  The region is 128 bytes in
-- 
2.25.1

