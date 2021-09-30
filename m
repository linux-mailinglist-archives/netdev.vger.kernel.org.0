Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E2241D8D5
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350507AbhI3Lfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350453AbhI3Lfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:35:45 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B49CC06176C
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:34:02 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t8so9529884wrq.4
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C6sdHrUdi9BDM1rYxYocEEgrTC9SSamTyBYNfJp2XuY=;
        b=HQQJsRvkgb6Nho7VlDDEr0s/2xa9K4xns8qQGU8nQ0Z3fndm/vijX+UfgYkzYxPO7Y
         AGJOkxnxIgeA+0hr7wGgWLE3ZGsQSHaBDDc3bGbaB23AFZpVWnA2Ob1Y/P+0kpm079e8
         uZq2CEafCecf1t3bJpvJ/yn9VcparKPneN6Bd8LncVRMcMABowLwn4AHx59buN1ea4KE
         9Ugv6oCMHA+Yx89j+D5wIw+FhIlV/fPpdWwXtFy+6aOEwyC3oFjHdZf8HJfqzuWfzwfY
         cPpoL8d7xHiiYsy/77CWt7fY7rT6JMsWaXYyYm3FwxgTZD9HCdcnWwZO0HlPgFEoTwlH
         I3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C6sdHrUdi9BDM1rYxYocEEgrTC9SSamTyBYNfJp2XuY=;
        b=vDE3E0dVPZ/fn4iwDq08Q4SERr1TlmOCMzN5mxOlrxRlfY5HKLsCCWAZKNjb+dFFvg
         bmYxMeqqjjVnChUEAKRnMjCE5ciuxN1ihddcXW8rvaaBHOV2cIRsxqrgc6beaNYbaodl
         gjbrqVdLhaOsIXWGEmGhcZLk2b2OPVIR0qebZxzsD5A6nsGbZ0t17fXMsTRYZF89AJZh
         awd0SfQRr6LLOcZlUAuWPQNRSfWqmwK+nBl19n5qi0anGLtnXG4IIUdFLd0augYoaUY8
         IAI+XAbH+3RTfQTuCaHiAbY3kTOgJPkOp7HaU7EGbpKQSUhEyvc5qkHYP6Mphmo7Aq7f
         59TA==
X-Gm-Message-State: AOAM532sBFfAZJBUbh8k0zI6NV+ZOyKYA93l7WuQmSVwzG4JN0zmahdd
        a0rQelajxJHiZ7TJ1pTMvc1VFg==
X-Google-Smtp-Source: ABdhPJzlRCuX9U4Yk5LIsQEyE1nFTW9uM2c1M9gGK1wgIP5H1uHE7MoWWH1Wfn6wmR87yBt6JqYnXg==
X-Received: by 2002:adf:a745:: with SMTP id e5mr5476842wrd.406.1633001641176;
        Thu, 30 Sep 2021 04:34:01 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.95])
        by smtp.gmail.com with ESMTPSA id v10sm2904660wrm.71.2021.09.30.04.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:34:00 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/9] tools: bpftool: remove unused includes to <bpf/bpf_gen_internal.h>
Date:   Thu, 30 Sep 2021 12:32:58 +0100
Message-Id: <20210930113306.14950-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930113306.14950-1-quentin@isovalent.com>
References: <20210930113306.14950-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that the header file was never necessary to compile bpftool,
and it is not part of the headers exported from libbpf. Let's remove the
includes from prog.c and gen.c.

Fixes: d510296d331a ("bpftool: Use syscall/loader program in "prog load" and "gen skeleton" command.")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/gen.c  | 1 -
 tools/bpf/bpftool/prog.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index cc835859465b..b2ffc18eafc1 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -18,7 +18,6 @@
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <bpf/btf.h>
-#include <bpf/bpf_gen_internal.h>
 
 #include "json_writer.h"
 #include "main.h"
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 9c3e343b7d87..7323dd490873 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -25,7 +25,6 @@
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
 #include <bpf/libbpf.h>
-#include <bpf/bpf_gen_internal.h>
 #include <bpf/skel_internal.h>
 
 #include "cfg.h"
-- 
2.30.2

