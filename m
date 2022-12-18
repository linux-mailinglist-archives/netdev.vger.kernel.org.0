Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF10864FD48
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 01:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiLRAnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 19:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLRAnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 19:43:16 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2C2BC99;
        Sat, 17 Dec 2022 16:43:15 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so9679874pjp.1;
        Sat, 17 Dec 2022 16:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OwH5tFkWHdn/+lF5Hxhm4OSnjJliIWhDkkxbcoccv1A=;
        b=AMkq2CfWXDm6PmbXHdaYfCgWsCLizpHlyeMDNVowfxkuEo9GgbjabtQ7Oxz2pUDTMH
         cRY3N6mF3Mxs/gnI31LMgra2GzY+Eaqwry5sIfE48Rosw0o3jm3gmZXnAq2am9LPq0+7
         NPsP+PAf9uVGa8X6ZdhZgYDWgWtXTOi868ud5g5CkdYeHFzojjyv2K2MGDOMzGgXgS03
         lyxdnq7gc3CFwabL1R5e2GWRgTd5ZJQvPujXeZboMEiQ7bDmD+YZ2/ug/jgjVYofHXP1
         5AcCRztQWFnGZtsiFR7h8FulWp18a7O2rDNUst90laIcs+EEZcdvBBJCXE/Op4j7+2gC
         zQUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OwH5tFkWHdn/+lF5Hxhm4OSnjJliIWhDkkxbcoccv1A=;
        b=eI0M5VXnjxqTspdQN/gykFQ2qjLDHzIiXPC1v/cHujcRp55Y9CU4L7YJI38FpF2XHa
         qUS4NzxNtYVcAApLTlu7GvpH7/ZqzpLgapPkfEgkjhv5U4r3QMliyLW9a7J8HA/HJDYn
         Wua/35dMTzYPy5hOTsnT6TVgsxbZqx6UP701k32nZHrw0qkPGvPpPfeuUjIZ0aP7IxmV
         USvZ9ScDobSIlgxa3hsHNWGqRKIm+uj5GYM4+WyQI8WlFXnfzky9ObEo2RU+PmXg2iet
         9EPN+paIhkgQvz/pagtnzyqzt085I/JlcULHP4gbhyd2X38i/ifM3vQxOdi5ULRw4R19
         00mQ==
X-Gm-Message-State: ANoB5plSfG6CrRYcawoO8IJBEvoP1gnUpxQqKyNe0SCGLezrvJ0JCd5O
        5Xxr9HRdl6nixRUuWsAFdA==
X-Google-Smtp-Source: AA0mqf6g9DhvCdAqiakC4Y5DkW1WlAp5FfgR/PGx7yeOMtfP+BbZ6AWR4G0fsZ31/N6gWax53cQZfQ==
X-Received: by 2002:a05:6a20:a591:b0:af:6d40:9883 with SMTP id bc17-20020a056a20a59100b000af6d409883mr19906943pzb.18.1671324195214;
        Sat, 17 Dec 2022 16:43:15 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id k10-20020a63ff0a000000b0047048c201e3sm3639458pgi.33.2022.12.17.16.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 16:43:14 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v3 1/3] samples/bpf: remove unused function with test_lru_dist
Date:   Sun, 18 Dec 2022 09:43:05 +0900
Message-Id: <20221218004307.4872-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218004307.4872-1-danieltimlee@gmail.com>
References: <20221218004307.4872-1-danieltimlee@gmail.com>
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
Acked-by: Yonghong Song <yhs@fb.com>
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

