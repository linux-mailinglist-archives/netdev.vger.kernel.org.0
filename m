Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508AB3114AA
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbhBEWLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhBEOjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:39:22 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58A2C06178A
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 08:17:03 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id o63so4866859pgo.6
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 08:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BhwlK/0Dz6i4rhS6CqV6gw/YDZHe+oacHIsDYWLXy98=;
        b=dxsc59SI0AuVp21DeuNlA0S1J6fxGcsD79lrJ3GIAleQLDgbdb0Qw05LV88tf08Yhs
         fS5mWCsuhBwW2FTebY5vzp+M3LwoheeZ5g/t/lxqxowpZnoqUrLQc7D+hdEb4XTJpqjd
         ItDp4IBr8FTfC2ReRMncoTOyWR6t9ZIYs/7Sa0asyRIhCneC9hMMU2eof5Www3ULX+ue
         XgbRVmwYZFx7MqLW29X4xGsiel5evXIuzeLcgSLRHYgIYO3NLgHqifvFXXGJR7l9TDPM
         PvlJMQvMCQ32KVNDQh4YDAeP3UFTov+EiwN2LwPGoxMtYjTUO8mdsfzVkRbaiF9eETY4
         FGjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BhwlK/0Dz6i4rhS6CqV6gw/YDZHe+oacHIsDYWLXy98=;
        b=mO3kF0qDfeCf0HWd6nmrOfW9lWlvQftRNsKuY2O6aqWonhdchGOgUMlSRtxDgDmJYW
         DYshe27NfR2hpitXi5Eych6Xu4LRv9IuLnUaXH1e4avbG1YjEh2yDP8tj9803IHR1YJ1
         d5dQTyNAdeNjkczqaSbljNWO4+YGbE22c8DBxHcOFo+laX3OrAoOAP7CBNNr9Ez7+WGJ
         tijiR/wAb8zW0auIwaiAd3CeePZCkevG1vKikb/dfVlH9chIvOGK2MaFT2/Kn1fzMmVO
         Lxrs5rsweRT62ePy2E+EATzl2KvdQ433LYA/a/doxgosczdkzoEXiw7jeWcDnhh+e1No
         yrUw==
X-Gm-Message-State: AOAM533RiKLfCk6A/jkgQEd6ruNNltKXI+OOmgcd1n7cCCW/+r/rc8yj
        hpY1WoYN4stvTC0No5W8MFBYcvh9AESUlg==
X-Google-Smtp-Source: ABdhPJy6wIqHoHiKtIqB71xXqwmBj60qAcV5vTT+B/MYVAGxJOOOyTU4hvdUUJviOy+gJqhTq7V5yA==
X-Received: by 2002:a92:c5c5:: with SMTP id s5mr4110654ilt.111.1612535917823;
        Fri, 05 Feb 2021 06:38:37 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h9sm4136882ili.43.2021.02.05.06.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:38:37 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/7] net: ipa: remove two unused register definitions
Date:   Fri,  5 Feb 2021 08:38:26 -0600
Message-Id: <20210205143829.16271-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205143829.16271-1-elder@linaro.org>
References: <20210205143829.16271-1-elder@linaro.org>
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

