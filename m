Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E91834F5AD
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 03:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbhCaBE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 21:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbhCaBEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 21:04:25 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685CFC061574;
        Tue, 30 Mar 2021 18:04:24 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y2so7053101plg.5;
        Tue, 30 Mar 2021 18:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FG5gZ0ulUfG0IDpu0Of939TdFlC1gbz7SPQvo9HF6Rs=;
        b=WcR3+uVZC00pEsGjkzjMlB1ZPvieucyTAx6HYFK3n5Eq3VgdwY1jrm5W+ctXcwKvXn
         imQa4hDrLauxeLX7RKJAtkTABkjzHOJtOVDNjMIGl3qxmq0eRlAv5o3EPgpKpOaePOql
         QY13uSinoXSl/T8KNIjXRpMleFytFwv7qZhuB7zm/uuXOX41pWOeOqtsxx1yDVikkTTM
         kDQXCRsrMK93CIzGY6SxYBBr8kjP1PtwSCOkNSo4NBA9F9yBzUDp9dgpW3z2XSlaNa55
         9TeY585Fu1dxrhZqRbynbgkIj094HsR6jRMW6hogZY7BrXupSBS79cqIe7rIJSvJ8EMR
         2PJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FG5gZ0ulUfG0IDpu0Of939TdFlC1gbz7SPQvo9HF6Rs=;
        b=TJx8DwT91o7MNHPAwP/rzaxgMqnHZLspzmGO/yZLcSCwG31GjUfGwF9Bdenxa13Mdb
         xS3KX8HxiALuuXNHVb3/WOLbV8QdNLcWKmNzC0UswmySwRW+hlLsZ48ZQnHPBnabhwmH
         8YjlcVILa/2ZePi6nspmzJJx8HGWg7G05fpiBxrkL6Msfa2A1mWNNfeZ3XGkUp0xiCve
         0R0wLRoiD3SSQIlKFFFQ22Fq2g9Cq785TG5yWS2lNFNRWZ2n2cvdh+lqJUoGpRg3nDnl
         KQBatjqFqT5QQ/3yx+0/MipfmpO60C/nJqGaxVA8rNGS+S47vpr02LpNjzUR4BRYgNBM
         BE0g==
X-Gm-Message-State: AOAM531H6Ffv+fCvxCabSfqvyOK3cdCTuTVr2WlsJ/OaNKsuY1F8kiOz
        YQc3WR8iARfSxz+JuUXtQFKQZQm60lVWD91p
X-Google-Smtp-Source: ABdhPJyJdQX8ZFty6U12ktbNUWY59WHUrO+KyD9bluoctMuMAboVJ64mYQBwo6XBM2MTPtL0jbsuYA==
X-Received: by 2002:a17:903:230d:b029:e7:1052:a94d with SMTP id d13-20020a170903230db02900e71052a94dmr958353plh.0.1617152663809;
        Tue, 30 Mar 2021 18:04:23 -0700 (PDT)
Received: from localhost.localdomain (123-192-91-35.dynamic.kbronet.com.tw. [123.192.91.35])
        by smtp.gmail.com with ESMTPSA id q19sm215070pff.91.2021.03.30.18.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 18:04:23 -0700 (PDT)
From:   Eric Lin <dslin1010@gmail.com>
To:     romieu@fr.zoreil.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     gustavoars@kernel.org
Subject: [PATCH 1/2] net: ethernet: Fix typo of 'network' in comment
Date:   Wed, 31 Mar 2021 09:04:17 +0800
Message-Id: <20210331010418.1632816-1-dslin1010@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Eric Lin <dslin1010@gmail.com>
Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/via/via-velocity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index b65767f9e499..fecc4d7b00b0 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2525,7 +2525,7 @@ static int velocity_close(struct net_device *dev)
  *	@skb: buffer to transmit
  *	@dev: network device
  *
- *	Called by the networ layer to request a packet is queued to
+ *	Called by the network layer to request a packet is queued to
  *	the velocity. Returns zero on success.
  */
 static netdev_tx_t velocity_xmit(struct sk_buff *skb,
-- 
2.25.1

