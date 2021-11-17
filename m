Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872B745448D
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 11:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbhKQKEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 05:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbhKQKEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 05:04:33 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07422C061767
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 02:01:35 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id u17so1674472plg.9
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 02:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qb8kg0dvEdemifaT+U/lwr54bQu6pS+cXcnasNu7KBc=;
        b=eOAAJ6DKiRt8UK+XTXk84SrergSaOpH+YaYVtpxgPZe6q8r9RkqhIm0ifQ3tLPq8QS
         RrmDvvN1tXnQumCvXTFi25+KaDocJnAnwj9+KmefLdO7q5cj5HFtz2DTZlm02idKNUVQ
         pGooaSxoQbVyI9fAGQy06gnWM40ylTiGd5MEJRGpHsmbNcoCSsmQfUteIyl+D+PW5JGh
         EyffEGGar7cj2+YioHYaedEsYzj5p/nhkVoGRgXT4kcqobD4N71oOwNVElMp/lXWYZK9
         /fOl/z5WMtKOXMKMBEW2dEa/v95RcdbOAKU+mLaQV+g7n8sCsnmaufuKG1NIkJA7WaBZ
         PkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qb8kg0dvEdemifaT+U/lwr54bQu6pS+cXcnasNu7KBc=;
        b=sMDdTAHsAJzWTVuj799rmn+hfJPTd/zOhmkfaBtYT8UKtcljTaBio/0IfoZzI7WLZ2
         qX1L7AwxS4712AsMOzaGsN/VmLbGDtHFw1hNavB0m0ZkY1w3agwUU0DZ0PkLCreTjS8/
         t9szmm1M1GbWqJhZO0cs2X4LeNJ3tjX03yJHVA+B/10YT96PRNvZIWDHiEpAs601LyTw
         kOCGUR3a1s05n51TFwulQIJacIl0jVVSxSPvsPd7iySfMSD2pCOoHjcdBN8k6bZf2l7Y
         wXc/6waUOuKRdqu1tNTF5ihOLr5/6F3LQQf8hcuGZGuaDbUMR2c/GyEhaMlJ/0RNzx3A
         Hceg==
X-Gm-Message-State: AOAM530ebrPbcuEawbEBakYz/0DDulYWXBW5oQbfK1y06afbEY7gDfAP
        oUQGLFTTgxmMSy4ghiVmHmU=
X-Google-Smtp-Source: ABdhPJznVNk6nH9V8SThkW2vZiTgeUOTnB7Ey2PYKMVvoNYZFCJzaObdsbuLYwJDD50FVerqd90OBg==
X-Received: by 2002:a17:90b:180b:: with SMTP id lw11mr8379614pjb.108.1637143294618;
        Wed, 17 Nov 2021 02:01:34 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bea:143e:3360:c708])
        by smtp.gmail.com with ESMTPSA id s30sm22660169pfg.17.2021.11.17.02.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 02:01:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH net-next 1/1] net: add missing include in include/net/gro.h
Date:   Wed, 17 Nov 2021 02:01:30 -0800
Message-Id: <20211117100130.2368319-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This is needed for some arches, as reported by Geert Uytterhoeven,
Randy Dunlap and Stephen Rothwell

Fixes: 4721031c3559 ("net: move gro definitions to include/net/gro.h")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/net/gro.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/gro.h b/include/net/gro.h
index d0e7df691a807410049508355230a4523af590a1..9c22a010369cb89f9511d78cc322be56170d7b20 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -6,6 +6,7 @@
 #include <linux/indirect_call_wrapper.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <net/ip6_checksum.h>
 #include <linux/skbuff.h>
 #include <net/udp.h>
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

