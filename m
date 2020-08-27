Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B82253F3C
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 09:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgH0Hdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 03:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgH0Hdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 03:33:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B41C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 00:33:42 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a5so4324119wrm.6
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 00:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F4SNZL7u3gsccSrH9enIbNris8FkjNdKg3vRM/mztQ8=;
        b=jiVdNZJS6G6mRGnoApq6x7rhaMrP5CpwQRu/J86z8nt0BBGwgLx+xyvHyKxHAKwNAr
         538iAMWR8RgpOKM0Mzzno8FRySnbmkt4bSObtiCUkUFjC8rwK9HK+Z9OEvXEZP+xFznS
         L1LtEdT/I6K8TOvQ3EZ+p2/CVF6F7ZJevrzGNj0TuQGKuaY3WJt54oFxoysND5H7x/oI
         cecNxrfvCIasE1Hqc4kbaglFRcG0jbFSvM0h/n4rn3MIGPNcPCy6+wEneWuwNsD5g4xB
         fmpp5aRGSlS0dH4omYNXCwn2g6BKdl9jvRUz5dY2y0zU4XCDWg/0hcwZMf7Jd8u/f/82
         c88A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F4SNZL7u3gsccSrH9enIbNris8FkjNdKg3vRM/mztQ8=;
        b=R+B9GZ57SqlkCIvXRrL6DGtSsFuYtr8BTJJozUU7jGEvNK92ofA7F3m/edamclJACo
         VazEdWqAWrsh+Txu8snhn8lBw3rxsTtMeL6lYcfMtkDmyrNudSUvm+ZOquRh+YHJOP/e
         wtFur6k9OJgJLokcGwTisNZKST2mgqTjNWQHwDWIn/pEWma+oBJhV7wdfc9Xw0r9rLga
         yigDP34xhsw1Re8mKoJE9ABdko+CkWG5s2OsVUw6Oh2ZZNxNERAZ8GhZuJXwwdNRsIpz
         eDLxylRxooBhqLIjGPaT4KCy/Vv1o1xrdLki37oWAqqwC8oSTW0geYfVToopbMSpKmSB
         g0vg==
X-Gm-Message-State: AOAM532pkyKqycbf20wVKTHree1HDHeGXdcPCeeNmTRAOB8Af+kHurkd
        GaETsBrzOyV2ifxe+WrFHgtB5Q==
X-Google-Smtp-Source: ABdhPJyLPr8Poc+iauPjlNDZlprbbAwIUcSiR5o9HkXyG3UWwuL2iq1ZiMZGdJwH3JNAxdj6Wz6h8Q==
X-Received: by 2002:adf:828e:: with SMTP id 14mr3285866wrc.217.1598513620817;
        Thu, 27 Aug 2020 00:33:40 -0700 (PDT)
Received: from dell ([91.110.221.141])
        by smtp.gmail.com with ESMTPSA id g17sm3996446wrr.28.2020.08.27.00.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 00:33:39 -0700 (PDT)
Date:   Thu, 27 Aug 2020 08:33:38 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        wil6210@qti.qualcomm.com
Subject: [PATCH v2 26/32] wireless: ath: wil6210: interrupt: Demote comment
 header which is clearly not kernel-doc
Message-ID: <20200827073338.GS3248864@dell>
References: <20200821071644.109970-1-lee.jones@linaro.org>
 <20200821071644.109970-27-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821071644.109970-27-lee.jones@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/wil6210/interrupt.c:652: warning: Function parameter or member 'irq' not described in 'wil6210_thread_irq'
 drivers/net/wireless/ath/wil6210/interrupt.c:652: warning: Function parameter or member 'cookie' not described in 'wil6210_thread_irq'

Cc: Maya Erez <merez@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: wil6210@qti.qualcomm.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index b1480b41cd3a0..d13d081fdcc6f 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -645,9 +645,7 @@ static irqreturn_t wil6210_irq_misc_thread(int irq, void *cookie)
 	return IRQ_HANDLED;
 }
 
-/**
- * thread IRQ handler
- */
+/* thread IRQ handler */
 static irqreturn_t wil6210_thread_irq(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-- 
2.25.1
