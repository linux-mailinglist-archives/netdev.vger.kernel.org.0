Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A712448EC
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgHNLkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbgHNLkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:12 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D7AC06138B
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:04 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 184so7677034wmb.0
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u/mL6RqaAdBiLmuXVeHhJK3J3fsDrt9yKqZOgLAYFAw=;
        b=QqtBGyrStEAU+EDjLF4EzSj1gEM6DRPMeV7x1903UbO3EpPFG1JFPAQTSze1goS+qq
         XOhkvY830PVDitir20GP91+hgCD9Mwn8MfVpM310mjWrqwZyNZjM6ZX4Q9zGIQYeK8fV
         dwLS3JOv7qVRTh4ccwhI/PRSwDorU+9PlKI7Q3wWtq5LJyj3vJmcdEXOZFka1MhhepBF
         JQGrYsaZL1LP4JCDr+xjUYct0pJRhq7fcR0H4CVYbymxeg7kSyoB0kDWtMJkQt2tz8hW
         /3Roj44jhR0rscPXmkFkOQcloO7ZSVRL7Oj1wk0CElTEQY4yJfszYtqUaP+0mUSGmPUh
         OJgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u/mL6RqaAdBiLmuXVeHhJK3J3fsDrt9yKqZOgLAYFAw=;
        b=fqgZIaLy5VJDjBiibMcjzWgvabqY8dAmpaSTNx3iTqsPIu0EqRz5UZEMvK2o9dDIvh
         4EllPIGcRjpUX3lVBBZAMGS66tK6chA0H/bUCjjRNLIR5T29eg6m48FK4A90b6pNmYVg
         tg7LRihVGEcF9ELtWxM5IFijDysxYVV2D5t8Mb5vHnsMbeaOCIhiCAy9WQrrxaeuAvOq
         sUFP4jI3nNMGMRxBkRliSE+a5UfxPAroa/OJ/tWrpef5ZMDgx1tFcJNb6s57jy84VLti
         ceRPD7Yy65/NMjdLNu91gYkApuJ+Gbqrk/tEWGdBwtGg3LrpvZb5xnhjhk/NN5TFwUwx
         8yPA==
X-Gm-Message-State: AOAM530FQ2IprilkxKCyZOAciMx8Z+MnYTLh3e29bxCDpgDF6r67A1sp
        jRFdFsaGCiRuxFVd8GyniUh2Rw==
X-Google-Smtp-Source: ABdhPJwadpwV0cMVShI8hxVfz4uE1ct+D58aY3i6FzV24SvCOAOYjR1k5+EDY64SlNSW+1v2bm9+Nw==
X-Received: by 2002:a1c:e0d7:: with SMTP id x206mr2372137wmg.91.1597405203683;
        Fri, 14 Aug 2020 04:40:03 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:03 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 14/30] net: wireless: intel: iwlegacy: common: Remove set but not used variable 'len'
Date:   Fri, 14 Aug 2020 12:39:17 +0100
Message-Id: <20200814113933.1903438-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlegacy/common.c: In function ‘il_enqueue_hcmd’:
 drivers/net/wireless/intel/iwlegacy/common.c:3126:6: warning: variable ‘len’ set but not used [-Wunused-but-set-variable]

Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index f78e062df572a..ff00c50db7c46 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -3123,7 +3123,6 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	struct il_cmd_meta *out_meta;
 	dma_addr_t phys_addr;
 	unsigned long flags;
-	int len;
 	u32 idx;
 	u16 fix_size;
 
@@ -3182,9 +3181,6 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	    cpu_to_le16(QUEUE_TO_SEQ(il->cmd_queue) | IDX_TO_SEQ(q->write_ptr));
 	if (cmd->flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
-	len = sizeof(struct il_device_cmd);
-	if (idx == TFD_CMD_SLOTS)
-		len = IL_MAX_CMD_SIZE;
 
 #ifdef CONFIG_IWLEGACY_DEBUG
 	switch (out_cmd->hdr.cmd) {
-- 
2.25.1

