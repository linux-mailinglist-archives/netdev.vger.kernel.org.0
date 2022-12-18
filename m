Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC12464FDE3
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 07:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiLRGPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 01:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiLRGPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 01:15:01 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4FEBF7A;
        Sat, 17 Dec 2022 22:15:00 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so6142110pjm.2;
        Sat, 17 Dec 2022 22:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OwH5tFkWHdn/+lF5Hxhm4OSnjJliIWhDkkxbcoccv1A=;
        b=A0zqRa0tFv7chDEJb90graEyDacWupBti2QmrouI6p193uE/ZXEurQZpDcbULzWdYI
         YnOc0D7wQqyOHL3WjADTiJPKCH1HTQw0UyF87+D3WLfIPDbJDDY31P+54hP//EL2ydSQ
         u1B6hfJJWFvGjxoFLuTnePLl/XqalkyoNAvocDt4/I4zph1W3pfrI2nI0y0HhQjcrDpo
         euAl+bc7f+Sjr6CQOoSF0rBPaGfNaEJoeSePVmcsqamBPBl+dFLR7Y2OEC38kMab3mo6
         toF0Syb7u8AriyidGcvVJOITdrQiRI7ECEXak0KVU9SL6JM7ZBFB0Sh8SoGcElN/FL/O
         f7Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OwH5tFkWHdn/+lF5Hxhm4OSnjJliIWhDkkxbcoccv1A=;
        b=wPpqqGR3lNGhIg7LOAGPePvm2Bq3p+o7AcTnsim+q8L4wFYiatHlvtvJys6m1A1iCT
         biGn6osKV73tum1/jVYtcfi4XDnYyyeKO6ssCGM1XID/H5Eh9hhY1aO5GzxPXu4VLSSU
         WRvzluDleSPDXCZn4dcs3jU/QgxtX/Wq227/fXcQBMY8EfIJ0QhksKY092Jyegrx0OOx
         MYLYmewfu4Jrp6aFsqDcA/KqlPcARuENlAP0VkM8lGqGxxckGzHnSBWdNGVoCHcYnN7G
         I2Wb0bGg5uiBomJWJBI3X//xp1nDKAyeI1ENA0MMXP4ujMGaNlGy1PixQAzB7ee7n67V
         7kZQ==
X-Gm-Message-State: ANoB5pnm6Ouv9YJE2OA2J4p1V0kv4rcQsSvaYfDwZeHfMElo79yuARP2
        EwUO4l+pDjxsP14s0S98bg==
X-Google-Smtp-Source: AA0mqf4TJ8JEivQfREVxKmr265vjs1wfPBvaQP5ujfqMq5xByVYOdQW9x804Ra1whJM67OcI18wbhw==
X-Received: by 2002:a17:90a:db04:b0:219:b936:6bd7 with SMTP id g4-20020a17090adb0400b00219b9366bd7mr39093837pjv.19.1671344100000;
        Sat, 17 Dec 2022 22:15:00 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id r21-20020a17090b051500b00219eefe47c7sm3721836pjz.47.2022.12.17.22.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 22:14:59 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v4 1/3] samples/bpf: remove unused function with test_lru_dist
Date:   Sun, 18 Dec 2022 15:14:51 +0900
Message-Id: <20221218061453.6287-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218061453.6287-1-danieltimlee@gmail.com>
References: <20221218061453.6287-1-danieltimlee@gmail.com>
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

