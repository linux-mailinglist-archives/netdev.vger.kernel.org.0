Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6E93944B1
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbhE1O7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:59:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47225 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236892AbhE1O6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 10:58:43 -0400
Received: from mail-ua1-f72.google.com ([209.85.222.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmdv9-0004Kb-E7
        for netdev@vger.kernel.org; Fri, 28 May 2021 14:57:07 +0000
Received: by mail-ua1-f72.google.com with SMTP id j23-20020ab01d170000b029023ea6f67624so1828107uak.14
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 07:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=edJlbbhDO28RmalfYtPxF+agVQnBc9uKOzw55MZRkiU=;
        b=dh63pFZ0+eKpVYnM7ey/RWVyG/DQj+sxDhTeWLOQ1Eb2XMtcRjXzyYllyrZqIsKJGT
         6HwMR2Lf1ctdArH5k5dG2AmPvqf8DJBfbyQH9PVeTl5NUiMLzagZxoZJQQeiIii66POD
         LoRcfTAOUHUQKxA2lu6AnVo6fk6tKMJTBCU2XMKbN6TUhfbJ2mGroLLVKpcxvgGBVKHi
         VGGPvlZLDm2XiD0QN6/E3QZoSD9XnUbtKi38EdVkQ4GVTp0upbSDjduHrgCKvI1jxSxL
         eVkxoW36R3K4af01mZ/RN/Svkx5Uq/mWUzTd0qK6HHplpsKvduwVvtwzRE9jGj5ttrcZ
         bGOg==
X-Gm-Message-State: AOAM53286AR3wBCu1NcUJYlrPrMA1kkKBKVhmACZwmBxwph0ILLFPmoS
        Uqh0QQpu8OR2Gb2f39lsTOxcrjmc5lY+VONEWl7+3ff3+3+IF9bI5pEAYo8mt5Kx15TvxAUTCpB
        Vl1kWKWzFHGVhRUYEVPKgY7MqXyQO/ev+Ug==
X-Received: by 2002:ab0:3482:: with SMTP id c2mr3488390uar.122.1622213826610;
        Fri, 28 May 2021 07:57:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylmdPw48e3WnJvVm8n1XmFKbfo4OOP5M8lb+ZI/nv+T5y9BFhzf21srOlHkwLrsW2LDgEx3w==
X-Received: by 2002:ab0:3482:: with SMTP id c2mr3488375uar.122.1622213826492;
        Fri, 28 May 2021 07:57:06 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id 64sm330505uay.11.2021.05.28.07.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 07:57:06 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 11/11] nfc: st95hf: fix indentation to tabs
Date:   Fri, 28 May 2021 10:56:51 -0400
Message-Id: <20210528145651.125648-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528145330.125055-1-krzysztof.kozlowski@canonical.com>
References: <20210528145330.125055-1-krzysztof.kozlowski@canonical.com>
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

