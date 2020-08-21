Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABC124CECB
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgHUHSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgHUHRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:17:35 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47849C06135D
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:07 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id t2so593701wma.0
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uRZo+OG6Hd5tjRCL+cwaRg6WHGd80eBlrZKkRkAZZvs=;
        b=DcJZ8hQuk3gXQzYslkEoyZk0qTBTtF15SsfmdbCXmT9nU9YfRu3E+/wBeN+h5q6Txj
         FtiLDeoyJbltQE3Rn7axv5cnMowyLL3kuBGy/XJtyM2ge9881DXMGyuVPWusS0ARYyBg
         eFkIdoqXiDBIvzk1X4q8njFkWFVOUgbf5shy6OZ5MJQ13QhAhP9QH9UdnwY3W5Og8QaU
         hzBfaJc2Tq/Qfecz3YGb161a0ELTxNlWjUJwpSNZihi65q//hBpkulMvQPC8z0fqq2nm
         RBvpYrWOl9cDf8+Zqqg4NYSVWOiXURNPQ/E+QkRMWAm5gEmiCAdutmupABe8EIrC4hW3
         zgZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uRZo+OG6Hd5tjRCL+cwaRg6WHGd80eBlrZKkRkAZZvs=;
        b=Jav2p0m3A5LRHBliRU0RImkXGcJVaOPVxlKR/6UgLAt2RfnmLNB8czqnJLsHIBX8ab
         nApv7MkmsTIUplf2aCLU+1ql216QXc9eGPkIT5gN2aQJXd8W6tNfsm6IgIISMgND2MCd
         1zirF0jjYsU6/RJek+iIAyW3pkls0efAduAq0P5b6bggjxALRfpuWMQQxPdjDGb5mkIi
         qUq6Xauc1ucSHqULRMrYxqmKhjDyI9uJ4Acm9Uod+eU59ajI2ABo83bw125+ff2WcaAf
         cW7TqgC1IB6XyvwDcKUkG9piFImBjOJWRJKdxnT20Rib9lT8v167Xw+o67Y1nVzZVG9J
         mnYw==
X-Gm-Message-State: AOAM532VrREnycZwOb4ilNGYZfhkW5BZVlRukvHUiZQXxjkbNmI2UE9T
        nDMK+OzBJ4aK8il4vM9k96x4WQ==
X-Google-Smtp-Source: ABdhPJza77UpXiyptnjv7Xy9ikVYPOoyWvokXCayEgAe9rtsBs748aPsyicusAEfnDA1SFz42C3f7Q==
X-Received: by 2002:a1c:b145:: with SMTP id a66mr1737268wmf.133.1597994225950;
        Fri, 21 Aug 2020 00:17:05 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:05 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 14/32] wireless: rsi: rsi_91x_coex: File headers are not suitable for kernel-doc
Date:   Fri, 21 Aug 2020 08:16:26 +0100
Message-Id: <20200821071644.109970-15-lee.jones@linaro.org>
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

 drivers/net/wireless/rsi/rsi_91x_coex.c:24: warning: Function parameter or member 'coex_cb' not described in 'rsi_coex_determine_coex_q'

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/rsi/rsi_91x_coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_coex.c b/drivers/net/wireless/rsi/rsi_91x_coex.c
index c8ba148f8c6cf..a0c5d02ae88cf 100644
--- a/drivers/net/wireless/rsi/rsi_91x_coex.c
+++ b/drivers/net/wireless/rsi/rsi_91x_coex.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2018 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.25.1

