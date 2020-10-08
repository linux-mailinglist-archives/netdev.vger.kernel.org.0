Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5166928787C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731357AbgJHPya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731347AbgJHPy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:26 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F0FC061755;
        Thu,  8 Oct 2020 08:54:26 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n9so4642388pgf.9;
        Thu, 08 Oct 2020 08:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aPA2QAnGhMDUdJK5y8jMZZbiJIgipLQypMRPcY4wieA=;
        b=iGgJ0J3R/CxBx+neusqxSD1FkvT+S1Kz7csHzxrMrC+PmshPp8Xo2JiKdgzGD6vuIF
         sLc+UZMKbFLwNjLSOYaE1/gVRL9go/OuZWifU5bG740nE9q49LXEiz61kBf4NiS73YpT
         kWDOltHyA5UMN2bL/B0qEGbBkqvZgEZzuy+KWsUUv8jOUHdR1/9ji3iObqpFJk73pUvt
         3OODASUQ1S5DP2kcpFRigFQfkS+ZgIa8hAgkxfyliufDGOkQ075Y156+h1niBFj9l3X7
         f+wACJR5761WKWdPntmAodgwcJvltQEtQQpIytFOR/uGVlYDw0oHKUajzxVRV1px7szo
         X45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aPA2QAnGhMDUdJK5y8jMZZbiJIgipLQypMRPcY4wieA=;
        b=W1ccMleC+6IRct7DrvDTNreAEknQIpxbKaPIfiOw6A4xCEjR7KeVm+vyDWYFSABpt+
         t70+OQKj7aBOByWLsv1U0GC7ifRc5HvxyUGvSQqwH4znWNZ3ZWuf7kfCGqqSsVuLF8pd
         lQetHLpgQPRCzZuw0lkw97AFw+NopWXlsRH2TuwxEJGUBX9x7JuP9FmjQpdhjp4kU9m2
         gZQGJGhXfJyLWvDxuDjaztl0/XgKW+Wx9ItlqnlxCB6yTObUeXQ8Ddp93WLaDIJVivnS
         XUoQMJu3rC91nsyQvrpsJj42ayVAkedxXl9v6jI12RGG6jrR/Al3CewZ9kwekb/kOxuX
         egYw==
X-Gm-Message-State: AOAM532Ofe9TLNE0yDGUygALz3i9kupT0cHj9HYbdoAoWM5CFBzBGc5S
        bxNlkttVvIzb6nh7jdxttzg=
X-Google-Smtp-Source: ABdhPJypYzQnSUA2G04bc7iq1fJrymQQ1dLk/u7pbYOumALwRWctezMNGKK86lfNyHHWK8GKebTILQ==
X-Received: by 2002:aa7:8249:0:b029:142:2501:3964 with SMTP id e9-20020aa782490000b029014225013964mr8283912pfn.41.1602172465697;
        Thu, 08 Oct 2020 08:54:25 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:24 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 040/117] iwlwifi: set rs_sta_dbgfs_stats_table_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:52 +0000
Message-Id: <20201008155209.18025-40-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 0209dc11c769 ("[PATCH] iwlwifi: add debugfs rate scale stats")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index d013203c7d5a..4075cb53bc73 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -3216,6 +3216,7 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = rs_sta_dbgfs_stats_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
-- 
2.17.1

