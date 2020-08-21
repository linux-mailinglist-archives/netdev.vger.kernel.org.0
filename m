Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C4E24CEDA
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgHUHSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbgHUHSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:18:22 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00C7C0612ED
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:21 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f7so1029447wrw.1
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7w3jE69M/e5e/80kesqbMY/Z/0HVdXG9NSX8Y6W1xc4=;
        b=YiZI5pLzZI5/jEU6hI6Ahuit8iLuJTNlIDoDhTz8w4icHiZokTBWxZL7BEBOFGYKfp
         DLyl9+y7diiZvjqBr4YmFUF5HtM9OSjokpbiJR3YQujobmuOHkPx+ZCYFj4almTunJus
         PwNzus7n2mgOozuanDA8NATcuOMlRF7JmLOjvh6W6bdtLLWxs+M7DIuUiySGZTtjHa5X
         6gLPcXs7q7hdMPybJrZcRllyPM46IM7wC+wH/cmmQvfuyCj/iHohO/IheQ868oJfkcpL
         gSsEsTEsx0ilnQiPgEenoM8aFBGOPzo6bg4Rys2QspkpWTjKcjNR3XQnPEWPV4ac7A+l
         QmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7w3jE69M/e5e/80kesqbMY/Z/0HVdXG9NSX8Y6W1xc4=;
        b=DvmoOEt17zARpObTMda163gTgNRbS9gfZZNUdxK2VU3RVcICEThEf7NpuGW54LqPcL
         oXGQ+E75aE7AbC0Ir3X6Yu5dOAaMmIdRdJDUDX+qWAmEo6i7uCM8wLdyiWSPs57Doo+u
         XQuBppXNFP+2mU7DZtUZqi9UQms58VBBd2tLm8VkEKK3WzNDR1I8KTo6Ggle/0VAK9PX
         mKzjN49ZlaMehyzss82W11P0eHsUaEng78P+G4Va/IiHXygq77PZtU9rc79pMD25QAsB
         4iy9tKmayJduwTYrvIA2HXhgUa7njwrDcl0DiTxGRKSFIy2y1xMniXmfPHTx7L0/IxTL
         gH7g==
X-Gm-Message-State: AOAM530hpx0i5mB0ejs9dTWtJlE5aB3iApyCTFYuDZHHpfhczVUN0BNQ
        fA/Qnc2JZMeUrgvp5EB0A/iJSA==
X-Google-Smtp-Source: ABdhPJxUSUDPq3M8uao0qRBxZAxzyyVIFHGzofqo5byjgpz1iO0yVuhN9yWqk9RI93Dz3W0ALi5HZA==
X-Received: by 2002:adf:bb07:: with SMTP id r7mr1417390wrg.102.1597994240654;
        Fri, 21 Aug 2020 00:17:20 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:20 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
Subject: [PATCH 26/32] wireless: ath: wil6210: interrupt: Demote comment header which is clearly not kernel-doc
Date:   Fri, 21 Aug 2020 08:16:38 +0100
Message-Id: <20200821071644.109970-27-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 drivers/net/wireless/ath/wil6210/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index b1480b41cd3a0..f685bb62fbe7a 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -645,7 +645,7 @@ static irqreturn_t wil6210_irq_misc_thread(int irq, void *cookie)
 	return IRQ_HANDLED;
 }
 
-/**
+/*
  * thread IRQ handler
  */
 static irqreturn_t wil6210_thread_irq(int irq, void *cookie)
-- 
2.25.1

