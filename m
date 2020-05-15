Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981E81D5C6F
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgEOWeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgEOWeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 18:34:02 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEA6C061A0C;
        Fri, 15 May 2020 15:34:01 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id c83so796755oob.6;
        Fri, 15 May 2020 15:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vh3ZP2e9/E+V3ueF0Y04DaEaXMiwgawvG0Y7J6ZEOgc=;
        b=OlSp/NHTK/S4ED5pnIAp0jEUj9HdxRpYf+lOzhDDe7NSuXU8vjhjJpTX3eToWogpNN
         yEwYR7VricLuXE0Y/M5cfrlGU4pvHSKIEbfIKIZDghYSfbN1njQnsgy4wua/hdF+/6AN
         rrwBk+xL6eSY0+MgUEtTqrjiMBA780Un/3dIJW4utIzKIcgsMGzlTS5MCqjVg+TRzLxd
         VTWZwwsw3Ip7d+/oqJLGUUznq4/PJNhSkuUNpKKjdD7T9X5H1bnD4LWL4An2TU0ouNO+
         zwaQMSceDGh6qj+t9eLhsz9ltjB23DRpLULsAijV087ykaR/+qzcso/rq+VWZyPfHD3a
         tsKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vh3ZP2e9/E+V3ueF0Y04DaEaXMiwgawvG0Y7J6ZEOgc=;
        b=bKcb+iS/DTrpUtnbdUBGZPUvu17BD6swgO+D4aAMtqLHT2eAdjl9/GKyAy0e6tL7hN
         xB7ln3n/xf6wiENmIRlUapY2eyE1X1xcrqz/psxM9czIyWpD0oQwbyFTgnp1TAWA1oUS
         qj0cg+T4DCnKiLntEhkbwyIPO1d/9xqHsd/+HaMPCsD69lPA8Uk98xtY8qT4VYzFf2pl
         Drc+qEzuscvLHJb6RDfqzE/d61QclM7iLHlKHy2koIBfDt0Ik/ddL0Jds7hVgKHE4D09
         FVsK45MywdyEWj5L3DH1C0dwftP2vUTlxyznl9I5mNSZ4EE59H3iQYQiTnO9ElRrafOY
         tnAw==
X-Gm-Message-State: AOAM5307t1uFl0L27LAk08O/9THZu2DDhvo1ErQ8oEseVYXT3Yb+riWN
        2rHUbkCgBbrP5DgzAkdRg1E=
X-Google-Smtp-Source: ABdhPJwIU1ZGu5Bo5WpV9Cfd6ftse9mWcr7TrO9KgFqz7kCeGavMH34rHohA797MFLs9yDcDXz1nTA==
X-Received: by 2002:a4a:94eb:: with SMTP id l40mr4434211ooi.30.1589582041166;
        Fri, 15 May 2020 15:34:01 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id g6sm913034otj.6.2020.05.15.15.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 15:34:00 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] ethernet: ti: am65-cpts: Add missing inline qualifier to stub functions
Date:   Fri, 15 May 2020 15:33:18 -0700
Message-Id: <20200515223317.3650378-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with Clang:

In file included from drivers/net/ethernet/ti/am65-cpsw-ethtool.c:15:
drivers/net/ethernet/ti/am65-cpts.h:58:12: warning: unused function
'am65_cpts_ns_gettime' [-Wunused-function]
static s64 am65_cpts_ns_gettime(struct am65_cpts *cpts)
           ^
drivers/net/ethernet/ti/am65-cpts.h:63:12: warning: unused function
'am65_cpts_estf_enable' [-Wunused-function]
static int am65_cpts_estf_enable(struct am65_cpts *cpts,
           ^
drivers/net/ethernet/ti/am65-cpts.h:69:13: warning: unused function
'am65_cpts_estf_disable' [-Wunused-function]
static void am65_cpts_estf_disable(struct am65_cpts *cpts, int idx)
            ^
3 warnings generated.

These functions need to be marked as inline, which adds __maybe_unused,
to avoid these warnings, which is the pattern for stub functions.

Fixes: ec008fa2a9e5 ("ethernet: ti: am65-cpts: add routines to support taprio offload")
Link: https://github.com/ClangBuiltLinux/linux/issues/1026
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/ti/am65-cpts.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.h b/drivers/net/ethernet/ti/am65-cpts.h
index 98c1960b20b9..cf9fbc28fd03 100644
--- a/drivers/net/ethernet/ti/am65-cpts.h
+++ b/drivers/net/ethernet/ti/am65-cpts.h
@@ -55,18 +55,18 @@ static inline void am65_cpts_rx_enable(struct am65_cpts *cpts, bool en)
 {
 }
 
-static s64 am65_cpts_ns_gettime(struct am65_cpts *cpts)
+static inline s64 am65_cpts_ns_gettime(struct am65_cpts *cpts)
 {
 	return 0;
 }
 
-static int am65_cpts_estf_enable(struct am65_cpts *cpts,
-				 int idx, struct am65_cpts_estf_cfg *cfg)
+static inline int am65_cpts_estf_enable(struct am65_cpts *cpts, int idx,
+					struct am65_cpts_estf_cfg *cfg)
 {
 	return 0;
 }
 
-static void am65_cpts_estf_disable(struct am65_cpts *cpts, int idx)
+static inline void am65_cpts_estf_disable(struct am65_cpts *cpts, int idx)
 {
 }
 #endif

base-commit: bdecf38f228bcca73b31ada98b5b7ba1215eb9c9
-- 
2.26.2

