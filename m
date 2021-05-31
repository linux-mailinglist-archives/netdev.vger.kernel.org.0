Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C21395666
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhEaHls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:41:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60647 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhEaHlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:41:05 -0400
Received: from mail-wm1-f72.google.com ([209.85.128.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lncWD-0003AU-1J
        for netdev@vger.kernel.org; Mon, 31 May 2021 07:39:25 +0000
Received: by mail-wm1-f72.google.com with SMTP id l18-20020a05600c4f12b02901921c0f2098so3893744wmq.0
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=edJlbbhDO28RmalfYtPxF+agVQnBc9uKOzw55MZRkiU=;
        b=CEctU7IdeITH81E7QuelXTi990J+zHBcK/UHwZDeFpQsrz5wstoeLw1oLDP1pR2DGs
         zrnV5HVzawbsqqVXdqW4Byyu40oVz+iLVU3NokUrDTpqcs735OIrkpw/NA0UYmgyH+pR
         XI57QEtPLMnhwnf3d09ig3tlI1cQ1gLXKI2AZJJXcQKeBMmI17tIkXmUirDDD60ZKA6g
         6gUTn8FNbMM1q2+KXdxW1NvfW8Q8xrMSEqORIeFsipA6RKvwt+zb1mcMHTNy3ODHYKyS
         +mcaeKrrP1H3afzshW+tEPTHHd4kCMNl6CDKnwsH1beZAoq1+XC2nsElOBjzpTmIyV/h
         vjRg==
X-Gm-Message-State: AOAM533gWLm8oao52KDHhIny4m+OSL0n5Wu3ErxpxcFeEJCCtwt3Sik6
        b3Ysu/NHFIP7z2cK+jE0ICaK3NkICNByloXiXDaibCEnD1nFd8rEOiEprv7yOO5+7f9ZvNEWSpP
        LaZr7VO7y0POm2e31eBkGURq5CwZbar2EUQ==
X-Received: by 2002:adf:e3c8:: with SMTP id k8mr20361124wrm.212.1622446764458;
        Mon, 31 May 2021 00:39:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhrRG0xVTTRKmEPbpAveb22Wz/57NL6TRG+5R1+rJ9+T+fewiXUT5mJUt4uwtoCVIYndAGjw==
X-Received: by 2002:adf:e3c8:: with SMTP id k8mr20361115wrm.212.1622446764356;
        Mon, 31 May 2021 00:39:24 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id a1sm9168911wrg.92.2021.05.31.00.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 00:39:23 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 11/11] nfc: st95hf: fix indentation to tabs
Date:   Mon, 31 May 2021 09:39:02 +0200
Message-Id: <20210531073902.7111-7-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
References: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use tabs to indent instead of spaces. No functional change.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/st95hf/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 0d99181b6ce3..2dc788c363fd 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -1057,8 +1057,8 @@ static const struct spi_device_id st95hf_id[] = {
 MODULE_DEVICE_TABLE(spi, st95hf_id);
 
 static const struct of_device_id st95hf_spi_of_match[] __maybe_unused = {
-        { .compatible = "st,st95hf" },
-        { },
+	{ .compatible = "st,st95hf" },
+	{},
 };
 MODULE_DEVICE_TABLE(of, st95hf_spi_of_match);
 
-- 
2.27.0

