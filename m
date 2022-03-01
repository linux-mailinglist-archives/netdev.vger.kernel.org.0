Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3223D4C85AC
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 08:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbiCAH7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 02:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiCAH7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 02:59:36 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCF650E01;
        Mon, 28 Feb 2022 23:58:56 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id g21so7148141pfj.11;
        Mon, 28 Feb 2022 23:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A25GcqUFVN2qz3QO76ICHSNj41DHlj4ABgVqzMafhNg=;
        b=hVlBBk7cs3/dXDPXoxjOjlK9Y2BjNWryWa8KLFqkxMZ5ftNCcm0uTY3qgZ7j31jVdE
         NhAaG15pa6YHcqJrKGZ4lLVFaxxfcvKBBdFIiwMikx65WVALF2ZyVQ+KTVRaghMfTH0I
         p5g2esJOzzR3Yr587LNne8gGAKIjHfiX75OEHWXutMQKgC2pkNRDzvcLsmu7YRDSwyNt
         J5eed6MBS7KSGP0xLrSgVRfq8sjHu8/Z0Zr+42wZRfwZZLWen1ndY0pLNyxau4KukI7u
         OUORMosGY7bR8f0Hq3ApDq+5m6lWzaZIUan654q+W/RtAwKEhkenqXGM81YkqYfiFq30
         jOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=A25GcqUFVN2qz3QO76ICHSNj41DHlj4ABgVqzMafhNg=;
        b=kIFHCwtgahgelilqzEMTrPYK7hHobYi6y3zZ1OGtcy7jqdLJZAE6/iNFczrN2nhT5D
         Vf8qDRqjhNWFx0AqqVEZPFhOFc7xXuLoatkSZLqhHF2Lhfc0sWykKfMZmcTiWaHEJawp
         g3HoJcY4gxLU+39zwIXkB7ixuQjlZ8S6gMHRtkyUV86LdVEowlGugu9KSOcPeHQE12fE
         sR6FtOPH+DcF4SaguQAi3Lqy3UO9+fJz8WsHOzmolKp33UHafKlgdDRFhu9D87ms1Sbk
         BUZj2Zps/9rGhnpd8itdDIGl91i9i2xAXKKeg5VTTxqTHSoI8Qw80djo5m3TUVhIvJH9
         cOfg==
X-Gm-Message-State: AOAM530ihy40Y5Js1+TNCfZ8lDk8+z1fpSriO1ce0Jdq2GjaKChsGlST
        ssyqTnBMo1caqjhkwqAk9dk=
X-Google-Smtp-Source: ABdhPJwz/5TAUp9XKAqJDu66ccB4TZTOrvlYbd+foqA41ACOpsKAIWqQCfWfUYS1KUrpFS2b84vyqA==
X-Received: by 2002:a05:6a00:2286:b0:4e1:285:5715 with SMTP id f6-20020a056a00228600b004e102855715mr26166424pfe.37.1646121536489;
        Mon, 28 Feb 2022 23:58:56 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id o12-20020a17090aac0c00b001b9e5286c90sm1662745pjq.0.2022.02.28.23.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 23:58:56 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     arnd@arndb.de, jakobkoschel@gmail.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        keescook@chromium.org, jannh@google.com,
        linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH 1/6] Kbuild: compile kernel with gnu11 std
Date:   Tue,  1 Mar 2022 15:58:34 +0800
Message-Id: <20220301075839.4156-2-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
References: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is suggested by linus[1], there may be some corner cases which
should be considered before merge, and is just for prove PATCH 2.

[1]: https://lore.kernel.org/all/CAHk-=wh97QY9fEQUK6zMVQwaQ_JWDvR=R+TxQ_0OYrMHQ+egvQ@mail.gmail.com/

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 289ce2be8..84a96ae3c 100644
--- a/Makefile
+++ b/Makefile
@@ -515,7 +515,7 @@ KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE \
 		   -Werror=implicit-function-declaration -Werror=implicit-int \
 		   -Werror=return-type -Wno-format-security \
-		   -std=gnu89
+		   -std=gnu11 -Wno-shift-negative-value
 KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
-- 
2.17.1

