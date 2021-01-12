Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96222F275B
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 05:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732927AbhALEvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 23:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727713AbhALEvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 23:51:06 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805BBC061575;
        Mon, 11 Jan 2021 20:50:26 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id p187so1449014iod.4;
        Mon, 11 Jan 2021 20:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fQwJ/zQI4XXD5wXIIQJHRYMn67QDCXvxmnE6LCbaUCE=;
        b=qTEAK4tRyH4x/S/RzWc+M30mi2lTlMlw3UzKWioAlIDViZWSmDL0AjBLutltWjD5v5
         eqmtu6MeLN1VH4iwVptk5nSvHaaWRW5UdDDDWnNwFu+Po1khJu044RWX4VrK1hCvLuod
         1LhA585YyLy3ngI43N3yf2vVqMt+jT0B9ocEcgw7cVYg8JsTJE6I6lfoMgyA6kuK88YE
         gTasTRbvxiU+rgKxg2oF34VkCIrqwDKtYDsiLQyHgHLRbViiE/sBI9gjlZnIrVJ4nrgV
         MmdH9DRtYt0d4f/47cYFngt4Rj1r6ViU9zENXTcxD1Uo4xIk1rZlKJ6PLnqgVnu4kTco
         AOow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fQwJ/zQI4XXD5wXIIQJHRYMn67QDCXvxmnE6LCbaUCE=;
        b=MlZzgMj1gcy1xtXAkULNbwq/SXyKWDtGYcHRtC2xIMJg1BD7QYwWVd437+SGRSh3zI
         zMV5V3YT/Ro02GTA/URFOBVtI56bKpl4i6mgA9heexE4foDEKMMzYXyL5f88dKcos/1H
         z0uxu75NKNZNkJIU0cGTIO4nwe2bKGEB29MgYF5onGQTQoAXdQlGt3ktI+sGVVF+tcqu
         dxPH/qq7g7/4/htbU5T7hMF0tpbu61Y7YM3KxKXjwBImPYvq60EXZ9CKOPROyrVJJzVk
         z/yW7QQsRQYGoYnhRR64CAKnvj78nvQkKe4nZKRpWdgZf1jpidJOVxepAhN41RG3qBNr
         IQiA==
X-Gm-Message-State: AOAM533gv06Ah8u3jAv4EfxjT9F+fsgeF2rejLJX4Ub6CjlA7l3n4bQ+
        JDoNzIebDpm6wLeQTjPvigo=
X-Google-Smtp-Source: ABdhPJzBS/UnLHLWQiJGrLtphGPTbikgOrMy5d7J9tAAgZjrzP9a7iV628YN9cc/b1KAw7N0/vgBuA==
X-Received: by 2002:a02:2ace:: with SMTP id w197mr2641353jaw.132.1610427025994;
        Mon, 11 Jan 2021 20:50:25 -0800 (PST)
Received: from localhost.localdomain ([156.146.36.246])
        by smtp.gmail.com with ESMTPSA id e5sm475174ilu.27.2021.01.11.20.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 20:50:25 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] kernel: trace: uprobe:  Fix word to the correct spelling
Date:   Tue, 12 Jan 2021 10:20:08 +0530
Message-Id: <20210112045008.29834-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/controling/controlling/p

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 kernel/trace/trace_uprobe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 3cf7128e1ad3..55c6afd8cb27 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1635,7 +1635,7 @@ void destroy_local_trace_uprobe(struct trace_event_call *event_call)
 }
 #endif /* CONFIG_PERF_EVENTS */

-/* Make a trace interface for controling probe points */
+/* Make a trace interface for controlling probe points */
 static __init int init_uprobe_trace(void)
 {
 	int ret;
--
2.26.2

