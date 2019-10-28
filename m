Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2912E7909
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbfJ1TNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:13:09 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37202 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729730AbfJ1TNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:13:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id p1so7551767pgi.4;
        Mon, 28 Oct 2019 12:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=CgcQlM5VLCXCNyfNxz6Q2XQFojiEUKbWR1CtYMYCie4=;
        b=lyIFkDoJnC8Z2LPIiCcX8Bm2LQhPW6iHZwPkIMIw2QreWTRQEJl6ElcuwvsbfIt2Pl
         Z7f0YvEoJRXe/VPB8s6EQqeBGIWdGfkld2NHRHJ35uk/F8OaAAW47Ps/Av5eazEjD+An
         6PH96HiDTsF0HlU5rF8xcDcHbdTpTFB+3m65AL5Lh5RAd0K8QevBCFdbqIQnXT9WgPw0
         x7LJmC1ypRWJME7QYAb2+PaasAqEki0J9ymj50ePWkgzRlNg7YLE3e0lH8BJUCXYXWTI
         Lqt5JC/Jj0sSrPSIpG3Di+2FMNRyiBj+G8i9TTQfQUIZwfm0sNgkULJKQD7+8Pq8Yzew
         mmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=CgcQlM5VLCXCNyfNxz6Q2XQFojiEUKbWR1CtYMYCie4=;
        b=K4dcN5L2JNv56MJaf5LiJ1UpPWSaJfaRDqu2dWfFbS5rYpbETTcWe1liljRMLmN5rd
         sbin8nifwfz3HTCMS98xUXjH52tFq5OahkxmHD6uVgL+2Kade7h9jD/ECA3Kkn2dW4Aq
         a+CZMQpTDJ+25MtMRanLEHbYespLSYGD0BUAOAlVL6xt69aze4olg9gQfSZxYWiJJra7
         DHyL5jiE1dTuowad6tVUNpaRnwSDz9iXbqfRsSGZLq0HTaJ1wYs2JuPaCCDM/17sPsS7
         ex++kOVSTTMZFPmvOcV2mCrcLHFXUskSDSQEhnl1fshLChkhYPfTwb4Ja7FafAKl1mRz
         nQbA==
X-Gm-Message-State: APjAAAXKayhVH25DmLRMwPA5RnTCsKIyKG0BQRPTNMlpPlM87Wrd1YdS
        x1orb3c6tSvsC+MEYPJ66Pk=
X-Google-Smtp-Source: APXvYqzgrcUnqmrda+MVYp4HuNS7YIINeAgPJFZJDnRCLKbsdypzwML326SsLcgem4CrN/TaVHcT+g==
X-Received: by 2002:a17:90a:749:: with SMTP id s9mr1032746pje.135.1572289988287;
        Mon, 28 Oct 2019 12:13:08 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id t9sm275740pjq.21.2019.10.28.12.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 12:13:07 -0700 (PDT)
Date:   Tue, 29 Oct 2019 00:42:59 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, tglx@linutronix.de,
        saurav.girepunje@gmail.com, allison@lohutok.net,
        swinslow@gmail.com, mcgrof@kernel.org,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] b43: Fix use true/false for bool type variable.
Message-ID: <20191028191259.GA27369@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use true/false for bool type variables assignment.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/net/wireless/broadcom/b43/dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wireless/broadcom/b43/dma.c
index 31bf71a80c26..9733c64bf978 100644
--- a/drivers/net/wireless/broadcom/b43/dma.c
+++ b/drivers/net/wireless/broadcom/b43/dma.c
@@ -1400,7 +1400,7 @@ int b43_dma_tx(struct b43_wldev *dev, struct sk_buff *skb)
 		/* This TX ring is full. */
 		unsigned int skb_mapping = skb_get_queue_mapping(skb);
 		ieee80211_stop_queue(dev->wl->hw, skb_mapping);
-		dev->wl->tx_queue_stopped[skb_mapping] = 1;
+		dev->wl->tx_queue_stopped[skb_mapping] = true;
 		ring->stopped = true;
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
 			b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
@@ -1566,7 +1566,7 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 	}
 
 	if (dev->wl->tx_queue_stopped[ring->queue_prio]) {
-		dev->wl->tx_queue_stopped[ring->queue_prio] = 0;
+		dev->wl->tx_queue_stopped[ring->queue_prio] = false;
 	} else {
 		/* If the driver queue is running wake the corresponding
 		 * mac80211 queue. */
-- 
2.20.1

