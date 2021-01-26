Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A23304D85
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732318AbhAZXK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731757AbhAZS5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 13:57:49 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE046C0613D6
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 10:57:08 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id h11so35678541ioh.11
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 10:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f5b9KtQ7d1H/fGZmXHlccfFZMdiZGMJ/JFXTwWf9F8s=;
        b=SQiMsUM5JIXhmTm3jtoiBCRusm96VGeuMvXqKZWmLUfK0c77z/w8h4EuYJv4GlGpR7
         MHGoSEkcClv9bX5yiMeXboUJDbsYc5SKoh5KJgBlKM4Y/83gZHWonLlJlQ8GoMw/CjrR
         xUdkZLtTcEdyyP128msMDrp0E6tpGBsxxasr/LcaBnU2NxmDMpOJmelMHDouCTcGoyVZ
         p2M1RQKSzahGqJ84gzomRM7qhraN7GJpFKt+g4jsJQcaFKCrRdnRTzEzO26/vcI+dHuA
         czmh5wAvftP+Lqj7HNALeV43fnsblLRUkx3LS61xZ+aZ5S7dXVG1ZM5K9arGXzUuLXGP
         Emyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f5b9KtQ7d1H/fGZmXHlccfFZMdiZGMJ/JFXTwWf9F8s=;
        b=lrfnWZuukyWKgox8NR7wC/QuzxZdwEz+h9bStIEv70D3lreqQp++GJ7D+qHjtl/saH
         QbktaZsdHA1uUugsHCV8Q5YRMwRs9TOkQHBUo2TOPeN3ZgMxSKvTrZIR8qr4EW9+LRZJ
         txob1G9UFGQZVOl0keddwaxStu08zDbc9Fdn1W5wUr19t+QYMbyEvwMmZhBc3pPdbiww
         PTlPvqemSkCWgcuq933mOoaspMtdA/mdiTfhva6v6T3FM3T29q2Fdt5E92C5TdeLT3ZQ
         j8Sfl5KISiJOFzvr9xwvnylUS7o6WWQfcz+53WodZdhKw9nvHgmuevwSJnpnL7Qmr08O
         z8eA==
X-Gm-Message-State: AOAM532Nu0rXGVoDkWqQjFPM5HGgy7PMYKnKa2Hz9EKvlYMTkVJ4FdTX
        DW6Gu0Ft6+GgHKBiL4bK6c6bVQ==
X-Google-Smtp-Source: ABdhPJxqomMueYH1MDVu+WTtNg3uo6M1NU0RcKw1VF44PVGCCb96A52T0358uKQI+XDEulYR50C5nw==
X-Received: by 2002:a05:6e02:1202:: with SMTP id a2mr5859544ilq.21.1611687428356;
        Tue, 26 Jan 2021 10:57:08 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l14sm13060681ilh.58.2021.01.26.10.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 10:57:07 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/6] net: ipa: rename "tag status" symbols
Date:   Tue, 26 Jan 2021 12:56:58 -0600
Message-Id: <20210126185703.29087-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210126185703.29087-1-elder@linaro.org>
References: <20210126185703.29087-1-elder@linaro.org>
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

