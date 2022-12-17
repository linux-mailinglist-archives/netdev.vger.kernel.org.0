Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86C564FAE9
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 16:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiLQPzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 10:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiLQPyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 10:54:39 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7EB28E30;
        Sat, 17 Dec 2022 07:38:28 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so8937574pje.5;
        Sat, 17 Dec 2022 07:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uediP+nXqszD82iggm8JfD1AiyDXDZ52s2ztBKGez2M=;
        b=JWv9ZTrEUm3pRQH1VfpkVHn+OcACgUJJzKpnaFMH6T6XzHAh7m84EwiahnOtkVM8rY
         jkYBmQSS/XYz+0BBTaUEZzUdRD2B+ut6oaBtkUldibK6KWAIYppANfWk/5F7TEV0xXBM
         8UKSogxtIYz+C/Qq7iHSICY3/mVKxberoLMfN8YpS5/r8fsizBimeWtT0ndHRb+NQ5MV
         NwqJ3iKNElngy+N0rmVX9+Dj8guDWK6QROeyF49Ew2HS9dy5xggvxjD871D4d6o3pNZg
         aGZJ7ZZrtCEiIWpz+vzvm1VcJ41Urp/mv13+roRIhLQN/bqooeJAoxOzbh3hZIBwOYFA
         DD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uediP+nXqszD82iggm8JfD1AiyDXDZ52s2ztBKGez2M=;
        b=7EUVBEPqdPO0njsZz4cfTZbkwgHWr6MsumCOEA/YtXcWbo95JwhMFCu/lH03l9UXsv
         8hDZvFf5rmHiVMCDaSCGa1wGWBtLO6uagUdWbsnXZmi0J6td13mzrnUc5jK3k1iV8EZb
         sZ5XDdPtqMq8LIDqVc02MYw3nayS8vKcgv5LldOL1BikdScfMqBsCR2cJ6/9SsMXpLRB
         LFFNv5YR4AWd1kEp1ZHf4Pdbh8U3NirI4TvzOgjRu8SHtQ7vUAOrQ8t4TwMuvqlfBbZf
         wTOc1BjQwCX2PwhX77k2XNeBrlbc34qpOy92jGbX9fGqPpMCg56qvSpj0BIPgBO/vgEq
         z3pw==
X-Gm-Message-State: AFqh2kq+Wh3N9/6njO5CPhzZvgaQqGAAxqzDlTKUDx8YCwRYv60pqwGh
        KQ8u1rA2F4o3AzCgRtsJxQ==
X-Google-Smtp-Source: AMrXdXs33Hzc0q7XWbqBLKfKes3e8RZeAY85ie+MzTdRfLYsZhj+oyetH9qxyus0JpGk6GjNnFhkqg==
X-Received: by 2002:a17:90a:69e5:b0:20d:bd60:adab with SMTP id s92-20020a17090a69e500b0020dbd60adabmr2738748pjj.39.1671291508492;
        Sat, 17 Dec 2022 07:38:28 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id u31-20020a63235f000000b00488b8ad57bfsm732039pgm.54.2022.12.17.07.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 07:38:28 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 1/3] samples/bpf: remove unused function with test_lru_dist
Date:   Sun, 18 Dec 2022 00:38:19 +0900
Message-Id: <20221217153821.2285-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221217153821.2285-1-danieltimlee@gmail.com>
References: <20221217153821.2285-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, compiling samples/bpf with LLVM warns about the unused
function with test_lru_dist.

    ./samples/bpf/test_lru_dist.c:45:19:
    warning: unused function 'list_empty' [-Wunused-function]
    static inline int list_empty(const struct list_head *head)
                      ^
                      1 warning generated.

This commit resolve this compiler warning by removing the abandoned
function.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/test_lru_dist.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/samples/bpf/test_lru_dist.c b/samples/bpf/test_lru_dist.c
index 5efb91763d65..1c161276d57b 100644
--- a/samples/bpf/test_lru_dist.c
+++ b/samples/bpf/test_lru_dist.c
@@ -42,11 +42,6 @@ static inline void INIT_LIST_HEAD(struct list_head *list)
 	list->prev = list;
 }
 
-static inline int list_empty(const struct list_head *head)
-{
-	return head->next == head;
-}
-
 static inline void __list_add(struct list_head *new,
 			      struct list_head *prev,
 			      struct list_head *next)
-- 
2.34.1

