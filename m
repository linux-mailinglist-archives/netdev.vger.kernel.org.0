Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10A21DFB30
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 23:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388094AbgEWV1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 17:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387847AbgEWV1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 17:27:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6317C061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 14:27:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y189so13332361ybc.14
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 14:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=L7hPQvY2NIf4meJrg9SAHQ2svkS/4rdW/+N34fTKjso=;
        b=Hb4EWUiLNML4nAz2rpesxRQ3Xui71Qj89OfwfSHj9V4QiHPwZcMHwuf0RSOkNFix8D
         Cwb//Nc0K3oXE78uSX2KvrGQuwktkdmGND/sy466Tui/B056QjaGvSP1dtqoB0WvXthA
         0807ZieAJnvaQYOiZ7LWnTKoes3+17uK+7MCau8uULig1fq/FB8DH0GadbFtpxI4IsGR
         amCM8Hzpm8gp8ncdPu8egBC7VPFWX52gtuY+HOk+nkHYfA+44zO80L4OVWZi/HwdayDs
         xof3VJdd3Cq3INRQnW2tGnhDD0H+1jvrfr/xx2ZjJnz1KMwSCPjS/681DLnFQq6EL9Nf
         AhTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=L7hPQvY2NIf4meJrg9SAHQ2svkS/4rdW/+N34fTKjso=;
        b=djq1sPsQGLtH4ukvA8ysukRY0r4pVLEldPKK8+Az0nyJZ/AYylFgsyfzVf4A+Cs9SB
         xJ71Z5gdZr8WuLhbEOMD+qHVH8myLAAaLKlXbncob9WOMg3U6XPojFfI8oaFfVGRj9C/
         o+qIZSea7TZiM6oCubAhqv8wq6DBlGriKV9D1uNuA6lCsfDnf168gpzK7qMIYqYx2KGB
         rwLwE9iTiN5wNgzhsflmIX7oqEZ0s0p3nmHtYUiGVaMJ6n6tN3DcFwcqYM9Pin3TuBo4
         xcjzLBN2iVeKL2cHRyb/Seg0zH1YwmIdZU+jrvEDDIZpm7L2RDE7ERA4WWBRVf2OGlvt
         8oEA==
X-Gm-Message-State: AOAM531SHfR8aFPAT5IDXa8OLDcpf9zAPLG7cVqatY1ndTAwrnno8Bjg
        3YKhhptf4CQhUXKRglGJmZEUJtOBG/4u
X-Google-Smtp-Source: ABdhPJzlNWcVHOMWGwLCGzq9m9H3VHSJkfIikGT3epD7agMuS7DCu02ze0nAP7jyATxoOh5dWnFoWcT6Ewoe
X-Received: by 2002:a25:253:: with SMTP id 80mr18381858ybc.405.1590269266946;
 Sat, 23 May 2020 14:27:46 -0700 (PDT)
Date:   Sat, 23 May 2020 22:27:35 +0100
Message-Id: <20200523212735.32364-1-pterjan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH] atmel: Use shared constant for rfc1042 header
From:   Pascal Terjan <pterjan@google.com>
To:     Simon Kelley <simon@thekelleys.org.uk>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Pascal Terjan <pterjan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is one of the 9 drivers redefining rfc1042_header.

Signed-off-by: Pascal Terjan <pterjan@google.com>
---
 drivers/net/wireless/atmel/atmel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index 74538085cfb7..d5875836068c 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -798,7 +798,6 @@ static void tx_update_descriptor(struct atmel_private *priv, int is_bcast,
 
 static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)
 {
-	static const u8 SNAP_RFC1024[6] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
 	struct atmel_private *priv = netdev_priv(dev);
 	struct ieee80211_hdr header;
 	unsigned long flags;
@@ -853,7 +852,7 @@ static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if (priv->use_wpa)
-		memcpy(&header.addr4, SNAP_RFC1024, ETH_ALEN);
+		memcpy(&header.addr4, rfc1042_header, ETH_ALEN);
 
 	header.frame_control = cpu_to_le16(frame_ctl);
 	/* Copy the wireless header into the card */
-- 
2.27.0.rc0.183.gde8f92d652-goog

