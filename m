Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D28ED1A4CDF
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 02:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgDKAUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 20:20:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42366 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgDKAUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 20:20:10 -0400
Received: by mail-wr1-f65.google.com with SMTP id j2so4044047wrs.9;
        Fri, 10 Apr 2020 17:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=agKMMUEnxz6VY0lkHl06TnhHs+ST6griE6g5IoxABZ4=;
        b=WkejCNHLvfgBnKU7wOp7VoMf0V8w5oKiBuxl4TSpcyytvmQK+bK5BNCA+grUsP0dol
         ltA8Uy5e7T4Q6u2wyQ198noHzKzIOKFmW9xkHvik3RppQC3+L6aW5h4qhvFtvrs/gWHz
         rIQHYyNl7aNzZS+KLFQAuLvT+bLmvYrBYa6ha7LPRA6qTpiIF1X/twDJI2qGFbl+U0cR
         J78dHZfLU6oedEGbJ7MpGZzTGmSpbkSeeyKhwSaQie6xYg47wJw2h0S/uKEDVG3GVFyM
         AudpQfbmcExiS/TnHDdlfB4CZ3PpvNMVooDDdrbVcJ/OJbCxpFBKLFrduYa9VHXktRL9
         iHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=agKMMUEnxz6VY0lkHl06TnhHs+ST6griE6g5IoxABZ4=;
        b=URh/fNKK3MZJjcByp8UfuCZEhTiLEinYhV6/MZfu1aKUoswTh5ijqLFxkGIVXuIaFT
         Sn7RCgsDOHtIkiFIiI4xlP/mvlcb3jfE/gMCgLUReQMxXUkflGGYIGijy6MOneDwRrYr
         vqGEhOLrRcYwxcEAg0w8jbZgAsfrupcM84eMxfus9G/LsWySmJ4hlSyYGiUOVl4zQG1K
         g/VlUKfOvVqAndRviohUlTHUdXsZbxX0s3K771ocOcXw4olCwHq7M1NCEBthAIGRQDke
         msV2pMHof8dBoaROOYbw4+YQcj3ZRB+kgE+ucVWJFOiJOFA31h/4IDX1524HLnmRBLJ6
         /Gbw==
X-Gm-Message-State: AGi0PuYTYc1GWKzqoBBx+XEVGJTR4aHoqrUkzPXMJU1M9xQ/J4mvmh7A
        nLwhmSBsGlbGLwS6AEwGCI7/3DsPoMQ/
X-Google-Smtp-Source: APiQypKtUhTN6JrNR0HHq9eQB8JauCAxv3amDtUoNn0cEwEHclvopkR8/cBSPWuPpv4WmZeuWo4IlQ==
X-Received: by 2002:a5d:4a11:: with SMTP id m17mr6816815wrq.125.1586564408662;
        Fri, 10 Apr 2020 17:20:08 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-14-153.as13285.net. [2.102.14.153])
        by smtp.gmail.com with ESMTPSA id b191sm5091594wmd.39.2020.04.10.17.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 17:20:08 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org (open list:MEDIATEK MT76 WIRELESS LAN
        DRIVER), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH 2/9]  mt76: remove unnecessary annotations
Date:   Sat, 11 Apr 2020 01:19:26 +0100
Message-Id: <20200411001933.10072-3-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200411001933.10072-1-jbi.octave@gmail.com>
References: <0/9>
 <20200411001933.10072-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse report warnings at mt76_tx_status_unlock() and mt76_tx_status_lock()

warning: context imbalance in mt76_tx_status_lock() - wrong count at exit
warning: context imbalance in mt76_tx_status_unlock() - unexpected unlock

The root cause is the additional __acquire(&dev->status_list.lock)
and __release(&dev->status_list.unlock) called
 from inside mt76_tx_status_lock() and mt76_tx_status_unlock().

Remove __acquire(&dev->status_list.lock) annotation
Remove __releases(&dev->status_list.unlock)
Correct &dev->status_list.unlock to &dev->status_list.lock
	-unlock not defined in the sk_buff_head struct

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 7ee91d946882..7581ba9c2e95 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -101,18 +101,16 @@ mt76_tx_status_lock(struct mt76_dev *dev, struct sk_buff_head *list)
 {
 	__skb_queue_head_init(list);
 	spin_lock_bh(&dev->status_list.lock);
-	__acquire(&dev->status_list.lock);
 }
 EXPORT_SYMBOL_GPL(mt76_tx_status_lock);
 
 void
 mt76_tx_status_unlock(struct mt76_dev *dev, struct sk_buff_head *list)
-		      __releases(&dev->status_list.unlock)
+		      __releases(&dev->status_list.lock)
 {
 	struct sk_buff *skb;
 
 	spin_unlock_bh(&dev->status_list.lock);
-	__release(&dev->status_list.unlock);
 
 	while ((skb = __skb_dequeue(list)) != NULL)
 		ieee80211_tx_status(dev->hw, skb);
-- 
2.24.1

