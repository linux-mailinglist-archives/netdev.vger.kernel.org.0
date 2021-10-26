Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EEE43AF37
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhJZJm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbhJZJm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:42:26 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF625C061745;
        Tue, 26 Oct 2021 02:40:02 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id a20-20020a1c7f14000000b003231d13ee3cso2411549wmd.3;
        Tue, 26 Oct 2021 02:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5QoFAunNXrkyNvFxbVRJYsihg2i5r1k8Ybqq6ikLJ3g=;
        b=ZXXB+QOPywLnFAwKgACbCtjMTq6Ap+MfGDqZ1stTwz08N4vW4FfctMHEqbhGA/DCTM
         m7JFbjDG8nKkUan/T0tgopx1isFSyhhPrbzC0eI9xLwn0gNWKg5SDht2GhwkjDxB6kEC
         0NEitwrxF4aAclRQHlVtvtMo9SrvkuZzlrvWJ8wXu3djl00QoyfUxvO1Hkw/3U8gZMDj
         oklxqHI/MIje371m4sPm6yOvk3wult1PX4fj+e/oyrYOdNCugu3XSpdIjsenu2DOQOmh
         fujzqfngtxeJbI0hn5E/PI5hNqHCMNr38h+/LanidGueI45Qxy42kD/lTIF9ABTb6ZOT
         /mAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5QoFAunNXrkyNvFxbVRJYsihg2i5r1k8Ybqq6ikLJ3g=;
        b=TNojLP7+caDH2YOGsT/xCMyb5B7wDPYrM2yRjUBTBY5uqdRu6oD0ywIvs0EaeRce71
         TpTtWJoKOCjHXjIAsUcXNb2JpqS0jBg4jXkMLLS2VkA0cE7Yo0qJy2vyn+EXhp+OYCVm
         B5UnD+2SUUT2UqpALcNBfxUz6WrFzlrGMv3AhoJdtS5tdG80nVi5njZuyA2PpUCigsL9
         qL2RXBi0B+JJqQ2lV7tHOVVNXSr2tRHm6l1pTIrn1zVsUHr05rTUaJYhL77TWmdkSR/a
         /92BxzrGcvwWFjfcFf2hU247ti0qrSWpnJNg01CUOphbDS2IWgSx3bYu5WmMnOweHVwN
         Hccw==
X-Gm-Message-State: AOAM531WyiWTZN7i0bhKtf8mXqJipqgTl/IiHq25yZxWVt2j2q17w1x5
        kbfBCb0FMuFcCr+CNirwwHZn8eDVJQ==
X-Google-Smtp-Source: ABdhPJyz6e6bioTL9aOGAKb5wBzcpSZQmxD4ChEXaWsFbcuSw/5DqZcDWQnHHW1ElZaRHnPZh4m5qQ==
X-Received: by 2002:a05:600c:ac2:: with SMTP id c2mr54715469wmr.194.1635241201349;
        Tue, 26 Oct 2021 02:40:01 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id i14sm52084wmb.48.2021.10.26.02.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 02:40:01 -0700 (PDT)
From:   Colin Ian King <colin.i.king@googlemail.com>
X-Google-Original-From: Colin Ian King <colin.i.king@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: mac80211_hwsim: Fix spelling mistake "Droping" -> "Dropping"
Date:   Tue, 26 Oct 2021 10:40:00 +0100
Message-Id: <20211026094000.209463-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a comment, fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 23219f3747f8..0307a6677907 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1276,7 +1276,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
 	/* If the queue contains MAX_QUEUE skb's drop some */
 	if (skb_queue_len(&data->pending) >= MAX_QUEUE) {
-		/* Droping until WARN_QUEUE level */
+		/* Dropping until WARN_QUEUE level */
 		while (skb_queue_len(&data->pending) >= WARN_QUEUE) {
 			ieee80211_free_txskb(hw, skb_dequeue(&data->pending));
 			data->tx_dropped++;
-- 
2.32.0

