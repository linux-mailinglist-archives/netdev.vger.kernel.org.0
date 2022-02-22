Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C354B4BFE40
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 17:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbiBVQOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 11:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiBVQOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 11:14:40 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BB81662CD
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 08:14:13 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id az13-20020a05600c600d00b003808a3380faso2310473wmb.1
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 08:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xasGxjrWKUc8knKCgLkgRZOxjNjk0+kPfOd8fVbvqhU=;
        b=Uzd7uFCrCfTZmnmyq7XQpk6x3ugcA+wC0doquagldpVyGgPBQXI7nKoc4gvCtS0jw0
         3y0CKdjRgmrlJTD3qH8L++heLeT/7eVONkD+2jrLMdcuMwVH+3bFpZn5IMy6sJzciyW0
         6Nny5GfcxWLe4DyGuFmQN2/h+NKKAwqeLsJJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xasGxjrWKUc8knKCgLkgRZOxjNjk0+kPfOd8fVbvqhU=;
        b=fuQSOYaFejfwLmCubc4wzLLCtnsnAGJoMbvvJixFbPKVmMRUWJirTk2x40B5jR1TkR
         XdoA2jenI9ADuMZrabS9W6R6tAdTBsCg3iGeJ2OqUfUEnWe3gb9RsV1Og3wJu5HGVq5O
         8T8pDxzKxhtWkVbewLfr7vPzrMhuVgnCSXljgE4auXEHh6Myx6ovZ2QT5JvxIxdzzjSZ
         xIBfCkv0X9UUDB5ZtypbyUQ2ujIYAvRUthzPwQiMlB1T4I9Qfvm8egXcBLZ6dKJL5llg
         yfiT0V9rPTwsXyKxaav12L2vqJ+HxTiug7FCCCJ9BiRJtWgW8M7b5FoLN6ivgdD/O1CB
         IO3w==
X-Gm-Message-State: AOAM5302m2m8ZSlW/qL/PuKWW+071//weuabhNlXsYbm6q72efbyLOfQ
        iqwnXa1cef+hTZyoftcBh5PD0vGPaTY1PRdb
X-Google-Smtp-Source: ABdhPJxy3JfkDLpNbVyQxRl/PTpz5egGbFjnDEiLGsOCyGivRmc3NdFk+JRQndorBH2jF4GJnRj1Ww==
X-Received: by 2002:a05:600c:230d:b0:37d:5882:ec9b with SMTP id 13-20020a05600c230d00b0037d5882ec9bmr3954756wmo.162.1645546452525;
        Tue, 22 Feb 2022 08:14:12 -0800 (PST)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id z24-20020a1c4c18000000b0037bd7f40771sm2671433wmf.30.2022.02.22.08.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 08:14:12 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alsi@bang-olufsen.dk, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net] MAINTAINERS: add myself as co-maintainer for Realtek DSA switch drivers
Date:   Tue, 22 Feb 2022 17:14:08 +0100
Message-Id: <20220222161408.577783-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Adding myself (Alvin Šipraga) as another maintainer for the Realtek DSA
switch drivers. I intend to help Linus out with reviewing and testing
changes to these drivers, particularly the rtl8365mb driver which I
authored and have hardware access to.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b57077b935ba..0171f3e949fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16370,6 +16370,7 @@ F:	drivers/watchdog/realtek_otto_wdt.c
 
 REALTEK RTL83xx SMI DSA ROUTER CHIPS
 M:	Linus Walleij <linus.walleij@linaro.org>
+M:	Alvin Šipraga <alsi@bang-olufsen.dk>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
 F:	drivers/net/dsa/realtek-smi*
-- 
2.35.1

