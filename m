Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D3828788C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbgJHPyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731616AbgJHPym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:42 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55857C0613D2;
        Thu,  8 Oct 2020 08:54:42 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x13so1717427pfa.9;
        Thu, 08 Oct 2020 08:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bDXcWG42L1DQJJEQBNag+HEwRQGmNYoD8z2OOioRgrE=;
        b=Z2q2XVM2vVN1dIoSaBEL0u7UmpvCcjx5H/k+aaBLZ3e/C5oCxwux86qXWflH+O7zBE
         iDmYrYzaL3j2JZev1j/iJGqxA8h0oEEPGlk1z4CJPTUwfWjN9nWqlSijuDF7dbalCCZ6
         c8mNhEpdvz/s2KUIgkx3O51JKbMnPMeO8qq3eZ30KcuVatMvEkNa6QGXNjG225mgTlIr
         MXpyChiZdSC5VI7MWtkkx2/6hjNPnkQV3YIqY0xPkQ5W4gcDY/boIR1yqZb3XXGLqs7l
         AFFku+t9/j2q0K9tFToC2GOBq1/JfMJYEVZpuyzcmHZnoucyZUqeITd1wod6vkJfDazr
         8+0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bDXcWG42L1DQJJEQBNag+HEwRQGmNYoD8z2OOioRgrE=;
        b=ejSXCNI5YqftS0HdrIy8KHyFbOusIIOeBtQgqbqAfAZSAlL9+I68gubcTbTLOtlCkQ
         kLqX/E5wbb++/OtLoMd8HGXSLe0LaQGzjc4/JDuJrdshuYXXdBQzLVMDgNJ0bpVsxoqo
         xC2URYBk+Htr5C2n1zPbPZMKvva7n9IJ0K9u1v+/fAkteEVki3HcqE1CTkUXv0839ImT
         5YKVQNXxBAUOUL1gANEqSdmbNLYfwLUopMei9Mehxp6w0M05ALUrMJC9Wg6L/yfj5Jzu
         Kz+6mbsPLscnGJIXfoiypVw/j8Tni59KbrGfceMgKLDoqNhhNkQh7aFjLH7BzL4jjn8p
         R7Cg==
X-Gm-Message-State: AOAM531+mJNX15CHnD1QDbzfyuyv7VmUk2RPSkEic7KSq5pS3Gnxgd/4
        OWr2I8UepEbPiIjuzrjyu/HI3IFhOL0=
X-Google-Smtp-Source: ABdhPJzBh0fea8npME1X5JAtWjMml9m+QVa05+kzI02kEt9pd72UA/kaxJR/i+Rpfr2OAq5P3pJmFg==
X-Received: by 2002:a63:7a55:: with SMTP id j21mr3567235pgn.218.1602172481030;
        Thu, 08 Oct 2020 08:54:41 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:40 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 045/117] iwlwifi: set rs_sta_dbgfs_stats_table_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:57 +0000
Message-Id: <20201008155209.18025-45-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 8ca151b568b6 ("iwlwifi: add the MVM driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 97289236f2e1..5b81cb1bdd3b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -3951,6 +3951,7 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = rs_sta_dbgfs_stats_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t rs_sta_dbgfs_drv_tx_stats_read(struct file *file,
-- 
2.17.1

