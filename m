Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA63D34306F
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 02:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCUA7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 20:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhCUA6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 20:58:34 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8E1C061574;
        Sat, 20 Mar 2021 17:58:34 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id f12so9808310qtq.4;
        Sat, 20 Mar 2021 17:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j7g00KvxUaXEkg8CodXOQ9q9GuklDT0w1/LZTLeravI=;
        b=JMw3ewJMtAVd4yTjqh7ux/RxZgrXnd8KPkfnLkFLrrZULV0hUGPQJmw+bI15dVx3qf
         CQno9uPhunkDAmloEPQWGpmAVwrDS4kDVv2JqMU7bSmgofRFGHhA5lV6rIcGyPGh/BQg
         eHlKQE3K1eBpGAj/4bWabWdAAZaqQd5j9xFklJD/11rfk3ogIgbPfXdd9lW/EXOx4aJ2
         KutK1KefTuxZwW7ozYcwSNMCRT44AQIksSDtEZ+T+3DiQq89Ub5OCEgPcuRa2bqSZMOH
         VbcsGplWvXC4W9sUXE3ynGNVCXn/+IUd5dBCrULp+QgDlrxVUsj7E1wmUgTH16unBRRP
         +AIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j7g00KvxUaXEkg8CodXOQ9q9GuklDT0w1/LZTLeravI=;
        b=HYYzNgtqbT8rB1YLmuzRkSNWcF+Ut9Q3XH8i3kNFI/ClSRuW6iF0+SyIq+uUxgYZoU
         o3FFdwtzj5PFAHaFNyNY6VJHDiCqRBDH4ycP4BibEPwO23wmyYPqMqlbniVKW6ABAUHA
         k0q5/5ugdLxQyWiVBkc+hDDiQDg/7nnm5DF2CuWRBSRWc3ZzGresj5MKVC3BJCKRsBzl
         92zCxn4CsdOFE4M+9vO3SshdBuP0HXzQkie49gYhctd/ApY52P23sXvvzWXrIzgbndvC
         6nDJSjq0o0VJ3mq3GDwUR/X4bTwoIjrMBzdXZXD7ALI1iIoV2m1IiAU3gnDecWjyjXPu
         gGQQ==
X-Gm-Message-State: AOAM532SCrGFcG+yjHDqIzVtL4pXNQPj5hR0i4jgnpypzakzeuqJyJN1
        Kw41FJb/ask74ZzvYSQMPqg=
X-Google-Smtp-Source: ABdhPJy96ZtyLWHigXJWo1rfi/ZX7PIoXySFPza2l2ON1lbJNeob/30XoVBuzhl4NZuqS5e9rNh8cw==
X-Received: by 2002:ac8:4d95:: with SMTP id a21mr4515515qtw.304.1616288313236;
        Sat, 20 Mar 2021 17:58:33 -0700 (PDT)
Received: from localhost.localdomain ([156.146.55.187])
        by smtp.gmail.com with ESMTPSA id e14sm7748588qka.56.2021.03.20.17.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 17:58:32 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] perf tools: Rudimentary typo fix
Date:   Sun, 21 Mar 2021 06:27:55 +0530
Message-Id: <20210321005755.26660-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/archictures/architectures/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 tools/perf/builtin-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2e2e4a8345ea..5cc5eeae6ade 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1705,7 +1705,7 @@ static int add_default_attributes(void)
 	bzero(&errinfo, sizeof(errinfo));
 	if (transaction_run) {
 		/* Handle -T as -M transaction. Once platform specific metrics
-		 * support has been added to the json files, all archictures
+		 * support has been added to the json files, all architectures
 		 * will use this approach. To determine transaction support
 		 * on an architecture test for such a metric name.
 		 */
--
2.30.1

