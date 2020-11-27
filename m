Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747FD2C6B08
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 18:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732515AbgK0Rxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 12:53:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732451AbgK0Rxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 12:53:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606499624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=qO38NSfxZWa4WAPrmeDJabPo497l111qJuCqqB4b5gM=;
        b=FEMA5U+IHBrEWxieVLOkceABAS48PFNjMxXdvgBOnXvT9lRlhy3cDIlkFt9PAx09goZXjs
        cOiLrTLJ28j9cAp61HaZgrf6CiobEFGcJTxqGjo6kjwI1vhi0Ey7ayKb8E8FXt7XVI0laB
        Ga2LRg7YsXLVee8wKx77qeo6jb1eo2E=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-hY13fGojMvuu749gblIRfA-1; Fri, 27 Nov 2020 12:53:42 -0500
X-MC-Unique: hY13fGojMvuu749gblIRfA-1
Received: by mail-qt1-f197.google.com with SMTP id t22so3660058qtq.2
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 09:53:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qO38NSfxZWa4WAPrmeDJabPo497l111qJuCqqB4b5gM=;
        b=DtvVGkyMQJ6CbTcmSyLa/JuPZpoqwuArGkaOwCo9uBZICqZ9dQnw1tW1mk9zk3BIqo
         LO2JYnY3jOF4Y7RrizxZuC0tD7OoaV02rHz/LbETIan2dJPDsNGqodRGVQrqjYHqN9EI
         qziumCRrji/cCpGl7KhjhW5aN+QVIFsbwZ23roFDXAOKDClnK9VFryM4hbWE2OY/FSo2
         gy2yvSmAyRIbPkjVTsoxgbTkSTaBNIO70YYZMjfQ3BF5jpzepYuv353HdpXR1RxqHoNq
         6qE/Src71Uv2M+RA+NK3JpB1x9tpARWONXAdLhCiwE0P/Dxq+YGAAOmeOIUNl0rzbT00
         n90g==
X-Gm-Message-State: AOAM5336+avBO9BcREZdehuX0M7A6ajOkUy+i+7hjkM2HqqTb8U2Nz//
        S7EHz6BEDtWf+V70R2OAEzpeysKrkmy4yXiRTDJV1qM3l6aNr+PwVHj1Re54g9R+lVug53xt7P/
        ZzQCKyyg4gL2jhtJs
X-Received: by 2002:a05:6214:5cd:: with SMTP id t13mr9508303qvz.56.1606499622094;
        Fri, 27 Nov 2020 09:53:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwfH2VXvTvUj9haJRf6OI04GWQ+Bz6Iu0NjOaH9CUGPlGii6j/onExY9XycfKuzXq4xhmDsZA==
X-Received: by 2002:a05:6214:5cd:: with SMTP id t13mr9508283qvz.56.1606499621938;
        Fri, 27 Nov 2020 09:53:41 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id t126sm6425935qkh.133.2020.11.27.09.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 09:53:41 -0800 (PST)
From:   trix@redhat.com
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] net: ath9k: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 09:53:36 -0800
Message-Id: <20201127175336.2752730-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/ath/ath9k/common-debug.c | 2 +-
 drivers/net/wireless/ath/ath9k/dfs_debug.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-debug.c b/drivers/net/wireless/ath/ath9k/common-debug.c
index 53ca4b063eb9..7aefb79f6bed 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.c
+++ b/drivers/net/wireless/ath/ath9k/common-debug.c
@@ -189,7 +189,7 @@ static ssize_t read_file_phy_err(struct file *file, char __user *user_buf,
 {
 #define PHY_ERR(s, p) \
 	len += scnprintf(buf + len, size - len, "%22s : %10u\n", s, \
-			 rxstats->phy_err_stats[p]);
+			 rxstats->phy_err_stats[p])
 
 	struct ath_rx_stats *rxstats = file->private_data;
 	char *buf;
diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.c b/drivers/net/wireless/ath/ath9k/dfs_debug.c
index 3251c9abe270..2a79c2fa8415 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.c
@@ -26,7 +26,7 @@ static struct ath_dfs_pool_stats dfs_pool_stats = { 0 };
 
 #define ATH9K_DFS_STAT(s, p) \
 	len += scnprintf(buf + len, size - len, "%28s : %10u\n", s, \
-			 sc->debug.stats.dfs_stats.p);
+			 sc->debug.stats.dfs_stats.p)
 #define ATH9K_DFS_POOL_STAT(s, p) \
 	len += scnprintf(buf + len, size - len, "%28s : %10u\n", s, \
 			 dfs_pool_stats.p);
-- 
2.18.4

