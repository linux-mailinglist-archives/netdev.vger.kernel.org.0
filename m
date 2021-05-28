Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01623942CA
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbhE1Mny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:43:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42500 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235491AbhE1Mns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:43:48 -0400
Received: from mail-ua1-f71.google.com ([209.85.222.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmbob-0007xn-4D
        for netdev@vger.kernel.org; Fri, 28 May 2021 12:42:13 +0000
Received: by mail-ua1-f71.google.com with SMTP id c27-20020ab0079b0000b0290217cf59726cso1849418uaf.10
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:42:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5rn4epAcNH1Mik4gARYYfuC/XhUWwqVwYBKCtmf4Gqs=;
        b=N+V9Wwq9+HFBJJ0VU+HbmDwkGSz/B6GEKKSE2/Vqww5qF7ELkZdpM7quVycAHCwb8f
         erjaotoV43M+2Ip2fthFOblv8cpxVcLP40lIcu8+PWSTAdkabejQ/M3LFvBOTcGq8M52
         wbp286XSMkCgmbAkG8nqRVvqg9tdhf+Kp2jgNdhm6+wHzel/lb7DTi1pblF6vSg3Ugo+
         c0V2LouIgKTKaqXtCHxw6Mudt8dKfPYeHuyycT4m3FuQJNLqYObZB4GVYAYaJWZ5JPen
         ULc5Pf7ir9k+lutaAjUS3/gAbVrI9bOUz6v/HSh4JKkZY/V9vRB1wTt8Ay5bcdzv4wGy
         xJrA==
X-Gm-Message-State: AOAM5303plJCWjWcSNhS7UUXccNSEZQkW9F4AjchHsB5RrMymk6TH1gL
        5JrlkCJP7Q0VhhBsVA5FiitkMTBfwYtUapfOm6bUM0Ys2U9zErFjnzUL25DOcCOWhAZrzX4m4AU
        3IjjZ+q2V0ML0mGZiwT/Jr8q6dPEKal2nZw==
X-Received: by 2002:a67:f489:: with SMTP id o9mr6659008vsn.47.1622205731738;
        Fri, 28 May 2021 05:42:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7U4c+zsR2eMX8uGtXZTl5loFQdOdjHKdIFeosX2oE3JmTuGdnSEfaAP46EceGx8B3kXxW1A==
X-Received: by 2002:a67:f489:: with SMTP id o9mr6658995vsn.47.1622205731595;
        Fri, 28 May 2021 05:42:11 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id b35sm782328uae.20.2021.05.28.05.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 05:42:11 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] nfc: port100: correct kerneldoc for structure
Date:   Fri, 28 May 2021 08:41:51 -0400
Message-Id: <20210528124200.79655-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
References: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port100_in_rf_setting structure does not contain valid kerneldoc
docummentation, unlike the port100_tg_rf_setting structure.  Correct the
kerneldoc to fix W=1 warnings:

    warning: This comment starts with '/**', but isn't a kernel-doc comment.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/port100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 8e4d355dc3ae..4df926cc37d0 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -94,7 +94,7 @@ struct port100;
 typedef void (*port100_send_async_complete_t)(struct port100 *dev, void *arg,
 					      struct sk_buff *resp);
 
-/**
+/*
  * Setting sets structure for in_set_rf command
  *
  * @in_*_set_number: Represent the entry indexes in the port-100 RF Base Table.
@@ -145,7 +145,7 @@ static const struct port100_in_rf_setting in_rf_settings[] = {
 };
 
 /**
- * Setting sets structure for tg_set_rf command
+ * struct port100_tg_rf_setting - Setting sets structure for tg_set_rf command
  *
  * @tg_set_number: Represents the entry index in the port-100 RF Base Table.
  *                 This table contains multiple RF setting sets required for RF
-- 
2.27.0

