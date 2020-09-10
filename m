Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1FA263E4B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgIJHPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730201AbgIJG5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:57:55 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC39C06134B
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:14 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l9so4616446wme.3
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F4SNZL7u3gsccSrH9enIbNris8FkjNdKg3vRM/mztQ8=;
        b=wNMmsQ+FjmUb41jHniIimRBXAYxYZBPfjc0OAmv7yy+rkAU2vQpWyUCSWHpnSZHZQ3
         6FLbR7fHF7QSrGLvpYbjAhMw9XV+hNCuIoWer16Vy8D+AUdryZJUxluxkBASciRrGGkP
         rMVDSILqO4wp+sZ6aDEJyhRKuE0v6eEv7Wo3B5cdwMfv4TNC5+nS3Yg6TXIWhdy5+BOv
         LOdncogF6/wEjTM14GC6RdfkZ5bmzHvGmdYP/XqijNoIxk0I0Z4+vKnu25X16fG41Bvv
         gUDs9LUYkfBHbXLuVP/XzJ+JJ/2EPoxjGZyXfWcEW7twMAJHz4ILUcszEEvf2/mOQJrh
         NYVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F4SNZL7u3gsccSrH9enIbNris8FkjNdKg3vRM/mztQ8=;
        b=j4KBlBIiCW29ZqEIvsMfZkrEBYy9v3/xMG0WpkFn1ZcrAi7zg76M1WgI+yugjeSHPz
         hz4lpwLNn9Rn1FW3nnEdXh3OAiM4LT1FhEPGouQKw7+xji/1wst5bMTNvzpn/y3sbXEZ
         tKgjTfagys2yI8XsFO8mC9+3ybXf/Qtw22B9IOtaT/hAXqZQpBhIVoXTMFHCTsfkUHzO
         kzVjX3+9F0TNtF3QBL0K75oMJWaaFh+5qfLJcPRETxWv1/RPcuw2JTeys1HCVTBpEa5b
         LdnU0FYlkOq7gVjvMK+mrRhOMh9Vk+xNsnozrW3b4fxlRAu6HJDqh3XUsM55DUyft/09
         wBWA==
X-Gm-Message-State: AOAM530sMrpFDil+UJ20B8R55XDueOHwx+m33JhRsa/w3dPzHYwpT28s
        7GW5cyRwhXj9GmOJBQMqz/vUyA==
X-Google-Smtp-Source: ABdhPJyBUpBG+GQkJDKxyPXTXiLBDXsl5P46HlfF3R5neNBtG77N89AG8+GWMAblL6p2AxmzYiI29A==
X-Received: by 2002:a1c:2742:: with SMTP id n63mr6799933wmn.24.1599720913070;
        Wed, 09 Sep 2020 23:55:13 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:12 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
Subject: [PATCH 17/29] wil6210: interrupt: Demote comment header which is clearly not kernel-doc
Date:   Thu, 10 Sep 2020 07:54:19 +0100
Message-Id: <20200910065431.657636-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
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

