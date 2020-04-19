Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61A41AF794
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 08:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgDSGiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 02:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgDSGiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 02:38:01 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F08C061A0C;
        Sat, 18 Apr 2020 23:38:01 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id ay1so2718332plb.0;
        Sat, 18 Apr 2020 23:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XYbiols2T3sFmlzqIAnLRnHJlR1L5ZQovlULPSM3xQc=;
        b=ceIT5XZ9XKkOPrXOjsO/Ob0fXgI72L0TZMEDIIEnkFin7bNZfbGXK1OLSkljFHdSxL
         NlkwM0UDd+az4V78GJnaPhaTSB/g3RY+E6lYaw3SKWHjFwDFPX1KFaZ7CAzix5fv65IJ
         SNTkPKNhyGg1XwJkJFglosyZWh5lLpDZ4PWQMTl3PvU8fz5atEI2nxezz2cIVhJQG4JN
         SjTHWtJarfLMuma9rKHWzd6SQmI26gNArXk6++pJ/kQhKxsZjCb4Lij2uYoN6nnqFPXB
         gjEjORXWwJJLtyGet7jOnB5XxaWXYWpbI1P7AIR1zksjhfyr8Lv/CUz41/yxqUZ57n+T
         CUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XYbiols2T3sFmlzqIAnLRnHJlR1L5ZQovlULPSM3xQc=;
        b=tu6OGeaSsYus5KH0dWtKVsBSuIPANvr8Bj837XmrhfQ2ie6D26ufg2p7N7acqF/ecw
         RE9gBKwSWM/UxaidwVj2gyaXIk0odChEs2LVT4oZy/Le+GISwA4rGZ39L1Hws3WMIJJ6
         C3ErTfh4T4/aTvWw85Qtz7Kyt2MsUoD8L28q8FUqf9ZkehI9PHqKsLOskkIIclvy352u
         FxFmjkURjtSEJ87aYA0ySgGs666vWHBRYKpGEHGeie5YY6HdltX0i7H46IIzYNLv4LWX
         Z5vPy+t6L7UOxZ5HaF+0wUOfbjaHkdYwNufMK1+fF65QzwZetNPEs9dPQEVWucVKN5sz
         axtw==
X-Gm-Message-State: AGi0PubrzPc0jotlriLajCtAhOY91OcsQRwUrFAhdunisp0Kbot/faVw
        bCn8eO3wRKPQkaAtHxKX2Bc=
X-Google-Smtp-Source: APiQypKs2LRl3WudwRCi5KQMWy4ME1wDmPYGexg9tjVS9lnxpEZ/u1Wgqb7m6MF2m1v5jcTKOPo2Jw==
X-Received: by 2002:a17:902:bc8c:: with SMTP id bb12mr10566271plb.13.1587278280456;
        Sat, 18 Apr 2020 23:38:00 -0700 (PDT)
Received: from CentOS76.localdomain.localdomain ([27.59.158.48])
        by smtp.gmail.com with ESMTPSA id e27sm23716930pfl.219.2020.04.18.23.37.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Apr 2020 23:37:59 -0700 (PDT)
From:   jagdsh.linux@gmail.com
To:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, ravi.bangoria@linux.ibm.com,
        irogers@google.com, adrian.hunter@intel.com, tglx@linutronix.de,
        alexey.budankov@linux.intel.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jagadeesh Pagadala <jagdsh.linux@gmail.com>
Subject: [PATCH] tools/perf/util: Remove duplicate headers
Date:   Sun, 19 Apr 2020 12:06:53 +0530
Message-Id: <1587278213-18217-1-git-send-email-jagdsh.linux@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jagadeesh Pagadala <jagdsh.linux@gmail.com>

Code cleanup: Remove duplicate headers which are included twice.

Signed-off-by: Jagadeesh Pagadala <jagdsh.linux@gmail.com>
---
 tools/perf/util/annotate.c | 1 -
 tools/perf/util/auxtrace.c | 1 -
 tools/perf/util/config.c   | 1 -
 tools/perf/util/session.c  | 1 -
 4 files changed, 4 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index f1ea0d6..45f7b28 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -41,7 +41,6 @@
 #include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <bpf/libbpf.h>
 #include <subcmd/parse-options.h>
 #include <subcmd/run-command.h>
 
diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index 3571ce7..c39741a 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -54,7 +54,6 @@
 #include "util/mmap.h"
 
 #include <linux/ctype.h>
-#include <linux/kernel.h>
 #include "symbol/kallsyms.h"
 #include <internal/lib.h>
 
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index ef38eba..64f14a5 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -20,7 +20,6 @@
 #include "build-id.h"
 #include "debug.h"
 #include "config.h"
-#include "debug.h"
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <stdlib.h>
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0b0bfe5..8091f1e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -33,7 +33,6 @@
 #include "../perf.h"
 #include "arch/common.h"
 #include <internal/lib.h>
-#include <linux/err.h>
 
 #ifdef HAVE_ZSTD_SUPPORT
 static int perf_session__process_compressed_event(struct perf_session *session,
-- 
1.8.3.1

