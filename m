Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA1334B2A4
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhCZXRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbhCZXQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:52 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5610AC0613AA;
        Fri, 26 Mar 2021 16:16:52 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id y18so6942656qky.11;
        Fri, 26 Mar 2021 16:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+QzTIMQkrFw6m3Cji1kHVk1ThDqLlItcXspdG6j7uyw=;
        b=YHS+4fg4hfdjRIfWpfN2+BDEh520DrcyJHj0sbghtGO9t0UFeZ998MTKOshKMQzw2Z
         wcjZXXxkF+WzrUKP8XH8H2E2iK2uyiDTs1RPYXsljJV9xmFPrdzCqCXHqrrVjGbRz1Of
         BjbzTFnUZnNIWc8KNj+PMelNabwpGpTLZ4QCQqeavYV//iCbB9ndK1c8Z1jLlb2NRiry
         SY9zjyXt53eir87JAnP/FQ7pHLaT35eFOTMAk9vQfTUhB0kp/EMgKIr2lErkp9bJBjYn
         nBm6GSTP+tYROA9Bg2V+/Y+lpSfRq5RPTcG00RJkrQ7kL6tHvmicW+MLAKEr0SAy1NFq
         zBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+QzTIMQkrFw6m3Cji1kHVk1ThDqLlItcXspdG6j7uyw=;
        b=ezJGUhLe30WWknQk6N5GTXZXVUZGDpt0ojIEWqnal5QpRuysg8P/DtiCJf5iHAx8Oj
         wvojEYLnyNyzC8Hd+r2Fg1YyUA+8lbv+bwYB43uIVKjHKgc/H8elOEZlx6CXJY15IPrL
         bV/hi/TU1DCySfEERLVq4YGLpJLf7GnQCr9gLaJdF7Rwh381fGXELH6iPxXKwuz/dxSs
         HfNCgfVRIPwCSC86ske5gbSbjkS0yFAo6O0XRj+g20yx6w8GMDJ2wAcKsMaCY2TUWi+q
         BE6zOofuguEZVdetwdcuyXJCPkWugoFsNwAAH/QAAxFvwnmCFY7pRxW4Y5fi9iMFrtfs
         sG/A==
X-Gm-Message-State: AOAM533nC4dY4oNkNpNrNeGVrKYlhuNXlhdKrtVTZpzv95sC+ThUTGnS
        UuurIk5p1Sw0CNamu0sLKXE=
X-Google-Smtp-Source: ABdhPJw62s6PUS9MpSNXnFlIHsjAPTc8BrXG0reeoMZU4/nnF1uoBPzNMsxshJQORXnWwFtKB6JoKw==
X-Received: by 2002:a37:c13:: with SMTP id 19mr15232793qkm.210.1616800611467;
        Fri, 26 Mar 2021 16:16:51 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:50 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] mptcp: subflow.c: Fix a typo
Date:   Sat, 27 Mar 2021 04:42:46 +0530
Message-Id: <20210326231608.24407-11-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/concerened/concerned/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/mptcp/subflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3d47d670e665..f1b6e4d0b95f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1076,7 +1076,7 @@ bool mptcp_subflow_data_available(struct sock *sk)
  * In mptcp, rwin is about the mptcp-level connection data.
  *
  * Data that is still on the ssk rx queue can thus be ignored,
- * as far as mptcp peer is concerened that data is still inflight.
+ * as far as mptcp peer is concerned that data is still inflight.
  * DSS ACK is updated when skb is moved to the mptcp rx queue.
  */
 void mptcp_space(const struct sock *ssk, int *space, int *full_space)
--
2.26.2

