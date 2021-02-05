Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13702310AFC
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 13:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhBEMT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 07:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhBEMRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 07:17:15 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091A0C0613D6;
        Fri,  5 Feb 2021 04:16:35 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id ew18so3297088qvb.4;
        Fri, 05 Feb 2021 04:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2wLorlSLwD8qAK1tCDXh1sGAgsLi9xWf3prmJoyDJAg=;
        b=PtASXxH3/2jHxOR4T+9fXBgKh9dRfaxFVmefhuS2U4Q/J03Up20YXm1Q1WbKS/f6Fl
         ErdvsV6Z8Zs2a5TPGfCJZ0K6w/MzQIGZZTKzrQLLYG3LXAh9vJnPckO5Fxn7q44nFmys
         B8lcjDe7MqcFq9FWZRbvqhT/PWG9071Z31GQdrWw3dRTaKJg/wnugByvWdWnDfsexWhn
         lQc/1dV0014s0pd5yzXO01iUBfKHQyLMkqQpM/YnkTZp751MjUeCAijz7vA/rkYXDC3c
         P25LIn7UZMWuU+d0HI3JVKvzwiacvgwER5MnJewt+8tY0alpnlsQO/mLzIW5RuM4uF7z
         jFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2wLorlSLwD8qAK1tCDXh1sGAgsLi9xWf3prmJoyDJAg=;
        b=W/qpFoQcPsholci9KJ8ODwuQIPcCC1wjM5BuhgcPIj4cHchXvB9uFYjQoBz/FAULkJ
         4u2OQAAwsv9lRtKRTM2BUotC7pU30dwq+8PefPDSzqm5Raset4GbDJPiDXWveVlY0LkO
         j916Y1RL0znwSUoXBG6JiSjDHpnAn+uVo9IWDQqf1+GZRfIl7OmtLglgWZYjPV5QAn84
         hAF0NbtZN8F6JSdcXJ40Q2g4lzx1xHwLhZquERBkaRVj2iTmAC/jiFyMGNOGc20Bs2xt
         xB91qU0bfAIw1Xd/sv7aVvYF0VvR1d1B1l+C16dRG21xTWnIfEGzWOMHnpdxgQ0t0pPx
         gfZw==
X-Gm-Message-State: AOAM533Xl+OKFW8vqdG0jkbCfdHi5RGxoL/kJQacUpphWqRuw/01ZCGN
        pqFotZA3cbEfNWjPa1fN2iY=
X-Google-Smtp-Source: ABdhPJzA/cKN+AUQw23sLWPv+tFT6LuNDQiBAiKZR/e9S1Hwe+1Fe48tmJVez9MKD1WQQVGrbpfT1g==
X-Received: by 2002:a05:6214:20a1:: with SMTP id 1mr3848322qvd.30.1612527394045;
        Fri, 05 Feb 2021 04:16:34 -0800 (PST)
Received: from localhost.localdomain ([138.199.10.106])
        by smtp.gmail.com with ESMTPSA id g186sm8760220qke.0.2021.02.05.04.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 04:16:33 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] lib:  Replace obscene word with a better one :)
Date:   Fri,  5 Feb 2021 17:45:43 +0530
Message-Id: <20210205121543.1315285-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



s/fucked/messed/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 lib/vsprintf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3b53c73580c5..470805777117 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -7,7 +7,7 @@

 /* vsprintf.c -- Lars Wirzenius & Linus Torvalds. */
 /*
- * Wirzenius wrote this portably, Torvalds fucked it up :-)
+ * Wirzenius wrote this portably, Torvalds messed it up :-)
  */

 /*
--
2.30.0

