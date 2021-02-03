Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8721430DE34
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 16:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhBCPci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 10:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbhBCP3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 10:29:47 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09ECEC0617A7
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 07:29:05 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id n201so1305359iod.12
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 07:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BhwlK/0Dz6i4rhS6CqV6gw/YDZHe+oacHIsDYWLXy98=;
        b=jMZs86uVyvZ/BUdRF50YnogWNWfr84cD8rDT5RKFqR/Z1eu/C7fSq1YMvVGkWgplOd
         wAcghBWHu84bvcOXKk+/sZmV0ItuVTH/bRH+UV+koNY4C2ksxWpTJFugcfmLnZlU6rr5
         qgMbhF0495K9ItQEE3vGMDGHhEt7aGaEvt0hw6JCSrGGWD98b7MIRgI0qYsJavti2nat
         PRIk3SHfbMV89F6W9cwLbD2eYBhQ4c7hf04gWfxJRzUTGIhqBdZ2BF2U2q8K6zCZUJPo
         fq6qG1AiNXZ+tsYfuujwfk41jIcCrDt6XATZl9Y2l9U6wqSOjjIzghe47X53YwKh8olh
         3xsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BhwlK/0Dz6i4rhS6CqV6gw/YDZHe+oacHIsDYWLXy98=;
        b=OQJdnSYAY0CLiVVft/rLF1p9zj9GWw95ttdZBRixubzLb8RIj6nnoA/cgE49jZYsYV
         IepO9vM1zSQ3GvOnP4PCiW3lK5jJwGI8OAlLcuPIAEvkTtHRWRonLixYyScVsfWkrAhS
         +inqcrlMRRfOBUhtwXN+j4EoDhaSFcvPTKO5ckH6oE/lvHa3YHaVoYx6WXDvQ/ObfnXd
         QyWSXhZBORaxKTXH92lor9nPTTat+RE0O2XbcWaqjAi05Ff4P1AQb+FXahaoJvMqUAKk
         hA2fSjZzL5+wofV9fsqwD2gkmX8+CEEzLtxga8XcQZIr8C/7PyVJEYaq1/gdGOwV5MZu
         i8Og==
X-Gm-Message-State: AOAM531jPCOV4yxxlHZrZsnBhNSbFpHEJx5v4b+yq9hMREkfNWvXFVDs
        vH7EWcD44ilx532JhNwG5byCtRxde9meSg==
X-Google-Smtp-Source: ABdhPJznmQp/8oNQh/yQFUjES5HS0W1g4rv4rgBKTEIWj0Yy6ie9Y+mUiEoRWXoUFEF4AjyGeao7Pw==
X-Received: by 2002:a02:c909:: with SMTP id t9mr3431290jao.125.1612366144556;
        Wed, 03 Feb 2021 07:29:04 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a15sm1119774ilb.11.2021.02.03.07.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 07:29:03 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/7] net: ipa: remove two unused register definitions
Date:   Wed,  3 Feb 2021 09:28:52 -0600
Message-Id: <20210203152855.11866-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210203152855.11866-1-elder@linaro.org>
References: <20210203152855.11866-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We do not support inter-EE channel or event ring commands.  Inter-EE
interrupts are disabled (and never re-enabled) for all channels and
event rings, so we have no need for the GSI registers that clear
those interrupt conditions.  So remove their definitions.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_reg.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 0e138bbd82053..299456e70f286 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -59,16 +59,6 @@
 #define GSI_INTER_EE_N_SRC_EV_CH_IRQ_OFFSET(ee) \
 			(0x0000c01c + 0x1000 * (ee))
 
-#define GSI_INTER_EE_SRC_CH_IRQ_CLR_OFFSET \
-			GSI_INTER_EE_N_SRC_CH_IRQ_CLR_OFFSET(GSI_EE_AP)
-#define GSI_INTER_EE_N_SRC_CH_IRQ_CLR_OFFSET(ee) \
-			(0x0000c028 + 0x1000 * (ee))
-
-#define GSI_INTER_EE_SRC_EV_CH_IRQ_CLR_OFFSET \
-			GSI_INTER_EE_N_SRC_EV_CH_IRQ_CLR_OFFSET(GSI_EE_AP)
-#define GSI_INTER_EE_N_SRC_EV_CH_IRQ_CLR_OFFSET(ee) \
-			(0x0000c02c + 0x1000 * (ee))
-
 #define GSI_CH_C_CNTXT_0_OFFSET(ch) \
 		GSI_EE_N_CH_C_CNTXT_0_OFFSET((ch), GSI_EE_AP)
 #define GSI_EE_N_CH_C_CNTXT_0_OFFSET(ch, ee) \
-- 
2.20.1

