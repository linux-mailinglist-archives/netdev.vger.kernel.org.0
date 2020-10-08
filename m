Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D152878BC
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbgJHPz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730575AbgJHPzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:53 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9D7C0613D4;
        Thu,  8 Oct 2020 08:55:53 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id e10so4358699pfj.1;
        Thu, 08 Oct 2020 08:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MUOJtcoeHkrEZ8Vav7ZL7Q15Y/6HQsrxjKQS1gC0RJU=;
        b=JNEBQA2ftXxvHb7utTJV+KO+5PInJUiByozA3QP81SVHYuGY4q8pU1fke1WW4lnLDk
         7M12U+HBAv+ycqkNiriIhTZuQJcztLBb+FgRQ7GaLujT1Kz6jSHiK8lGkTyVUnAxo0Uw
         0wMb11XFvhGTWM/+vLX2/TheUGdZGKx71B4G6nQ4a2qMfaOiRWRJsJAt5H8SnoW/FuDs
         vzXrmXAd5ji5XMoqhONYoePWqnZ/K5i9qkOG1WU9LWt2uF72AQKlflIYNZYrjLKAHdup
         ly4ueMrcMavjD87F3guKhCx8FG/QLrtVG0yFlgU3AOiaPCTMsW9ckyn9FS1X9ZO3isdC
         xVbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MUOJtcoeHkrEZ8Vav7ZL7Q15Y/6HQsrxjKQS1gC0RJU=;
        b=Kw8ggXPxuBH5aYqHQA1avya1TR2MnmXdKjyvHtoemtx8pqnS8nuQ326Fcue53XTAzV
         9HvZGKCtTkpZLKA02FahZrv6i3jOwlT3FT4p2jJo/IujyNiJi/Ft37kGtDfRpJxjQ7gW
         IoUnPsqVvUOrXB20cDQCPHnh67//k2n4JzICAEVSaL9fxy+raSltDo8B18W8phSYnknR
         etKKFeP3qHKyh29Fb4T13nUCOfgOAoEa1ZXBEHRm21LvP2sG2zCkbBknL+lj+K8rvvDv
         xvRF5dUxcaYFvGha29SMb9nqLRsUsISdvZBO93y2QYQi5OeCoh/nQEnDP+bbO1vqA0wZ
         nTZw==
X-Gm-Message-State: AOAM5321dukQQCqA5ZdrQfg8KIrTMIva13ygzWvsNqsG+nolh6vExu9D
        ZT2fcRsYrP5RaIn/xecKgfI=
X-Google-Smtp-Source: ABdhPJzUen4dMdURtbhv61qgK4dvdlhrcGEXc5Xu7LWcBz5+Lzt9lo4Bi5U9oinaE6UQndlibhXo5A==
X-Received: by 2002:a17:90a:9b89:: with SMTP id g9mr8960231pjp.123.1602172552829;
        Thu, 08 Oct 2020 08:55:52 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:52 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 068/117] ath10k: set fops_pktlog_filter.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:20 +0000
Message-Id: <20201008155209.18025-68-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 90174455ae05 ("ath10k: add support to configure pktlog filter")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index e8250a665433..78bbb0380323 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1911,7 +1911,8 @@ static ssize_t ath10k_read_pktlog_filter(struct file *file, char __user *ubuf,
 static const struct file_operations fops_pktlog_filter = {
 	.read = ath10k_read_pktlog_filter,
 	.write = ath10k_write_pktlog_filter,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t ath10k_write_quiet_period(struct file *file,
-- 
2.17.1

