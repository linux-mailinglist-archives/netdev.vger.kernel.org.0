Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B97302DBB
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 22:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732698AbhAYVbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 16:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732666AbhAYVae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 16:30:34 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C166AC061756
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:29:53 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id y19so29620558iov.2
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f5b9KtQ7d1H/fGZmXHlccfFZMdiZGMJ/JFXTwWf9F8s=;
        b=m++7MR8AdVlVxjDtEqVpeCbjIjDCZqRIERMyyZfZibpzbkWsZYCH/PuCok20O7a8C3
         OfF/nw6IRs1/rlp7KVa1AnFExLJ5kFamjhhAbtglLMeTTq8tNo8s+7RZyWW1lY+YrAEu
         CUqEdJABVGfDWMymuOG9emDcX4CdHeuDWarvqz3sGB209rroawmlBBB41zdqFbPV0AG1
         QJ2VPAgd+qx86p4l6rEFpP2rC1Fqqj0bn2F4lylPIfs5aICXOAOGHl91ovpyRZntTA8W
         ABkycQJ+CaSYuDTt/1l2JBk/fMYRt30otCHx8XQL10KGZc6qoGpsaEAtGkiDpK0obqLL
         5W1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f5b9KtQ7d1H/fGZmXHlccfFZMdiZGMJ/JFXTwWf9F8s=;
        b=dU4HxyEgeDqA0kG2j5UQdGUtoVWhApKFVxo68ixMxw6X2mmvz6tcu/h6/Mdfi0jcyB
         GCcL1C4Y7hgsi9rq/jjtkngKhFnWtB+K3hWiMwhSKQEqNnPlphlWIWsJeJbhJUY8zAqH
         WbN5ylihw3zt/iQfI5WGiJBa5aTB5KgJLqRLOuDDS/nk0vb3hoZwNeU8i+YnuyOZLbI+
         r9dpSnL07KTarDH7HU1R0Oe6YzT2QxFyR+dvmvNb636VilqGNfw/eFOMJYDXAGXwTIaY
         ZuzmUiOzqFtIrQLdE2cHIXGL62Zu3AoWmoUn3Gnbjd7MBLECRFSXJPaLIFMvBg66k1i7
         s+ww==
X-Gm-Message-State: AOAM5321BOj28sGMAJAyij46xTd+7cr9UGkWS7Ez9J0qh6YryurI4PjE
        2mSKjKM/U7XG+I8dGsKfVpvVBA==
X-Google-Smtp-Source: ABdhPJzhfOb7kPEyIUoJUnlpF+ZSHhzuA6+ibNuEhsXU1bi489tjEiFWOmVLB9MGUpDdchtVATbN8w==
X-Received: by 2002:a05:6e02:20ca:: with SMTP id 10mr338512ilq.14.1611610193125;
        Mon, 25 Jan 2021 13:29:53 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o18sm11136241ioa.39.2021.01.25.13.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 13:29:52 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: ipa: rename "tag status" symbols
Date:   Mon, 25 Jan 2021 15:29:42 -0600
Message-Id: <20210125212947.17097-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210125212947.17097-1-elder@linaro.org>
References: <20210125212947.17097-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a set of functions and symbols related to performing
"tag_process" immediate commands to clear the IPA pipeline.  The
name is related to one of the commands issued when doing this, but
it doesn't really convey the overall purpose of taking this action.

The purpose is to take some steps to "clear out" the hardware
pipeline, and to wait until that process completes, to ensure the
IPA hardware is in a well-defined state.

Rename these symbols to use "pipeline_clear" in their names instead.
Add some comments to explain a bit more about what's going on.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c      | 26 ++++++++++++++++++--------
 drivers/net/ipa/ipa_cmd.h      | 17 +++++++----------
 drivers/net/ipa/ipa_endpoint.c |  6 +++---
 3 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 002e514485100..27630244512d8 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -567,33 +567,43 @@ static void ipa_cmd_transfer_add(struct gsi_trans *trans, u16 size)
 			  direction, opcode);
 }
 
-void ipa_cmd_tag_process_add(struct gsi_trans *trans)
+/* Add immediate commands to a transaction to clear the hardware pipeline */
+void ipa_cmd_pipeline_clear_add(struct gsi_trans *trans)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
 	struct ipa_endpoint *endpoint;
 
-	endpoint = ipa->name_map[IPA_ENDPOINT_AP_LAN_RX];
-
+	/* Issue a no-op register write command (mask 0 means no write) */
 	ipa_cmd_register_write_add(trans, 0, 0, 0, true);
+
+	/* Send a data packet through the IPA pipeline.  The packet_init
+	 * command says to send the next packet directly to the exception
+	 * endpoint without any other IPA processing.  The tag_status
+	 * command requests that status be generated on completion of
+	 * that transfer, and that it will contain the given tag value.
+	 * Finally, the transfer command sends a small packet of data
+	 * (instead of a command) using the command endpoint.
+	 */
+	endpoint = ipa->name_map[IPA_ENDPOINT_AP_LAN_RX];
 	ipa_cmd_ip_packet_init_add(trans, endpoint->endpoint_id);
 	ipa_cmd_ip_tag_status_add(trans, 0xcba987654321);
 	ipa_cmd_transfer_add(trans, 4);
 }
 
-/* Returns the number of commands required for the tag process */
-u32 ipa_cmd_tag_process_count(void)
+/* Returns the number of commands required to clear the pipeline */
+u32 ipa_cmd_pipeline_clear_count(void)
 {
 	return 4;
 }
 
-void ipa_cmd_tag_process(struct ipa *ipa)
+void ipa_cmd_pipeline_clear(struct ipa *ipa)
 {
-	u32 count = ipa_cmd_tag_process_count();
+	u32 count = ipa_cmd_pipeline_clear_count();
 	struct gsi_trans *trans;
 
 	trans = ipa_cmd_trans_alloc(ipa, count);
 	if (trans) {
-		ipa_cmd_tag_process_add(trans);
+		ipa_cmd_pipeline_clear_add(trans);
 		gsi_trans_commit_wait(trans);
 	} else {
 		dev_err(&ipa->pdev->dev,
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index 4ed09c486abc1..a41a58cc2c5ac 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -157,26 +157,23 @@ void ipa_cmd_dma_shared_mem_add(struct gsi_trans *trans, u32 offset,
 				u16 size, dma_addr_t addr, bool toward_ipa);
 
 /**
- * ipa_cmd_tag_process_add() - Add IPA tag process commands to a transaction
+ * ipa_cmd_pipeline_clear_add() - Add pipeline clear commands to a transaction
  * @trans:	GSI transaction
  */
-void ipa_cmd_tag_process_add(struct gsi_trans *trans);
+void ipa_cmd_pipeline_clear_add(struct gsi_trans *trans);
 
 /**
- * ipa_cmd_tag_process_add_count() - Number of commands in a tag process
+ * ipa_cmd_pipeline_clear_count() - # commands required to clear pipeline
  *
  * Return:	The number of elements to allocate in a transaction
- *		to hold tag process commands
+ *		to hold commands to clear the pipeline
  */
-u32 ipa_cmd_tag_process_count(void);
+u32 ipa_cmd_pipeline_clear_count(void);
 
 /**
- * ipa_cmd_tag_process() - Perform a tag process
- *
- * @Return:	The number of elements to allocate in a transaction
- *		to hold tag process commands
+ * ipa_cmd_pipeline_clear() - Clear the hardware pipeline
  */
-void ipa_cmd_tag_process(struct ipa *ipa);
+void ipa_cmd_pipeline_clear(struct ipa *ipa);
 
 /**
  * ipa_cmd_trans_alloc() - Allocate a transaction for the command TX endpoint
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 688a3dd40510a..39ae0dd4e0471 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -399,7 +399,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 	 * That won't happen, and we could be more precise, but this is fine
 	 * for now.  We need to end the transaction with a "tag process."
 	 */
-	count = hweight32(initialized) + ipa_cmd_tag_process_count();
+	count = hweight32(initialized) + ipa_cmd_pipeline_clear_count();
 	trans = ipa_cmd_trans_alloc(ipa, count);
 	if (!trans) {
 		dev_err(&ipa->pdev->dev,
@@ -428,7 +428,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 		ipa_cmd_register_write_add(trans, offset, 0, ~0, false);
 	}
 
-	ipa_cmd_tag_process_add(trans);
+	ipa_cmd_pipeline_clear_add(trans);
 
 	/* XXX This should have a 1 second timeout */
 	gsi_trans_commit_wait(trans);
@@ -1564,7 +1564,7 @@ void ipa_endpoint_suspend(struct ipa *ipa)
 	if (ipa->modem_netdev)
 		ipa_modem_suspend(ipa->modem_netdev);
 
-	ipa_cmd_tag_process(ipa);
+	ipa_cmd_pipeline_clear(ipa);
 
 	ipa_endpoint_suspend_one(ipa->name_map[IPA_ENDPOINT_AP_LAN_RX]);
 	ipa_endpoint_suspend_one(ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX]);
-- 
2.20.1

