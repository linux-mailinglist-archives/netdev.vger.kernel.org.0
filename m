Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D432064FD28
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 01:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiLRAII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 19:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLRAIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 19:08:02 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104E2AE53;
        Sat, 17 Dec 2022 16:08:01 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id n4so5781989plp.1;
        Sat, 17 Dec 2022 16:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OwH5tFkWHdn/+lF5Hxhm4OSnjJliIWhDkkxbcoccv1A=;
        b=kWpM8c0KzJEDZjIqgQkd7XRecBWxzvGqjndW1gUAbH8EOIDrDWlrUA+gDoRSOBR6Ja
         6Z47EdL4/njl+yYY5FnKB4pJpH1l3bwsXF9dRikV5GRVn3mlhFwVlvMYaHNsAVZHPOkd
         3QQe4U/NMpQ0mMlGq2zaQ6Ezm7Ra/oOpb0b3q9f0bbqrmRi68bVXV3yPojKqLkWBmz0c
         0eoqjdaxd6AOpAwkgRsXbn0ErEawPS6+s32lVlyZ7J4irbGjXIeaBVwQUfWBokPn36Kr
         qTK+2VLtRW4tWkob/ENq8rMaWDLMrdyzNTGnDmRyX/KN+AUZsEaYocp2po1ZZQgCwC1w
         kucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OwH5tFkWHdn/+lF5Hxhm4OSnjJliIWhDkkxbcoccv1A=;
        b=7EV33pX2Dn320u5KYrOxK0xEBY9vAByOXvpBsxFwMGSHO3MY/tktLvXT7mcSUteosx
         exJBAWpndWIUOaIw2aTOiDJ8WF7OUgPdvsoj/9nb/RvwynBjz76Thp350gszUKs+uQu3
         14mUw4mbBNcu52OgNxMPjx0SyEQ+6iOEv+JdCs3F2Eic9cDeL0GsXAb9JZdjr1FSpdiq
         HUuggiu6Ud0bkJ9aXi3pUL61WSHCtGPD5hjCrvGZeoyH6NL3IcSfbKh1ibdA1gokFL3H
         c739AxxBter/6lqKz0HkPqjaFH+NV6gPnsCuMg42Qx43v/ZU4HBvH8rOQJlTRAyG7q5p
         Uflg==
X-Gm-Message-State: ANoB5pnnDq7ysyhWn2/mz7n0xYVOhPH7KbJTO7dtk5ozqAQ2lhLcotz6
        yxMpsKv3UV8mMgVmoKEmkw==
X-Google-Smtp-Source: AA0mqf6f0CPJrIllrW+6Wl7IV81n5273Yl2f5ZNq2cSYcDPQyp1Da5pAVoksRkoguJ+vs7isNO4Yxg==
X-Received: by 2002:a05:6a21:329a:b0:a4:829f:a43f with SMTP id yt26-20020a056a21329a00b000a4829fa43fmr57693666pzb.2.1671322080514;
        Sat, 17 Dec 2022 16:08:00 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id r7-20020a63b107000000b00478bd458bdfsm3554330pgf.88.2022.12.17.16.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 16:08:00 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v2 1/3] samples/bpf: remove unused function with test_lru_dist
Date:   Sun, 18 Dec 2022 09:07:51 +0900
Message-Id: <20221218000753.4519-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218000753.4519-1-danieltimlee@gmail.com>
References: <20221218000753.4519-1-danieltimlee@gmail.com>
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

