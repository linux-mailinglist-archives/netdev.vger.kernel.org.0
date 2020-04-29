Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A97C1BEC7C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 01:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgD2XOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 19:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgD2XOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 19:14:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A70C08E859
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 16:14:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n205so5527130ybf.14
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 16:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=i/C9Y5GBkF2sbab6q3+mjJTMGZ+JZWwA9+KZOitr3OM=;
        b=an0eB0YQUWdRXYpVKwcafDNEnJADvqWwOxc0VVxK6auzCfPBKH3gE+lFd5qWvSTHpe
         8Ch92zMhwRQH3dpWUOkhNMsFaaQ5UhvY22buMZ3MootPfH5NESaPKeQrf01GwcCs8hs/
         aRC3v/RRPKcQtr+NMDmSd1tpy9DFNpA4HtMR1YUMghkMiqhQ9mvSjYMdcLpahsM4goha
         AMfRZNYl/VYY1ODzm8vOgGOaGJd1QZIIh4xOueTRZb/PY/mWSs3fJbzyQFucgi0mes5g
         Hl6m7DsNEFotBNNwJpr3f8RCglj74BkHPNAQAF8V2SMgSDoqPi+X8DLzkS/NVpHmAIAK
         o8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=i/C9Y5GBkF2sbab6q3+mjJTMGZ+JZWwA9+KZOitr3OM=;
        b=UOBVBh/Ij/3BABxSExW3gRC55+qfdAY/30NifoOAJVvVMNVXLuPmABP77lSaBAL2eG
         MrK7hOA1YAml1utlnvrZAdoKSWri6lUmnuaNL/v3lZi7Z+3H6Uqomydh+2NVuG2oxpvx
         GSXMcv9q6Ve3Z3QI8jCH8/2ATD6eDnWjG1Su4UVlGCQMh3IEwIRFIskFU77ngtITGa4E
         X6+OkSeQ/Ql97zoezmnDalvYrP36iIJLhZLprqUrwqnjZ9lNSYClTxVsLpvDm1G9uMNO
         C9u1zQzvNwrRZ+8bQQWgbjgDLJNKwG5gvMWoa8+D4Wgm2xp41AQEvQJ7H/bENNXG2YBD
         vvXw==
X-Gm-Message-State: AGi0PuYJxqXkiVAdIfyPID4NmF+L0pmPgszAyecsPeHvckqBWvNQj+nn
        h187OvDQZzsJH8G411zfv30G58T0MJwN
X-Google-Smtp-Source: APiQypJBTqSQS3d0yu8bI0zf5TDtC47H8/IA8UDPVs9BcVPOkO0Zx3N6T0EyoA/W4eHBYS3cvi7+g+4ELU0/
X-Received: by 2002:a25:908c:: with SMTP id t12mr1151108ybl.206.1588202089102;
 Wed, 29 Apr 2020 16:14:49 -0700 (PDT)
Date:   Wed, 29 Apr 2020 16:14:40 -0700
In-Reply-To: <20200429231443.207201-1-irogers@google.com>
Message-Id: <20200429231443.207201-2-irogers@google.com>
Mime-Version: 1.0
References: <20200429231443.207201-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v12 1/4] perf doc: pass ASCIIDOC_EXTRA as an argument
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit e9cfa47e687d ("perf doc: allow ASCIIDOC_EXTRA to be an argument")
allowed ASCIIDOC_EXTRA to be passed as an option to the Documentation
Makefile. This change passes ASCIIDOC_EXTRA, set by detected features or
command line options, prior to doing a Documentation build. This is
necessary to allow conditional compilation, based on configuration
variables, in asciidoc code.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/Makefile.perf | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index d15a311408f1..94a495594e99 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -188,7 +188,7 @@ AWK     = awk
 # non-config cases
 config := 1
 
-NON_CONFIG_TARGETS := clean python-clean TAGS tags cscope help install-doc install-man install-html install-info install-pdf doc man html info pdf
+NON_CONFIG_TARGETS := clean python-clean TAGS tags cscope help
 
 ifdef MAKECMDGOALS
 ifeq ($(filter-out $(NON_CONFIG_TARGETS),$(MAKECMDGOALS)),)
@@ -832,7 +832,7 @@ INSTALL_DOC_TARGETS += quick-install-doc quick-install-man quick-install-html
 
 # 'make doc' should call 'make -C Documentation all'
 $(DOC_TARGETS):
-	$(Q)$(MAKE) -C $(DOC_DIR) O=$(OUTPUT) $(@:doc=all)
+	$(Q)$(MAKE) -C $(DOC_DIR) O=$(OUTPUT) $(@:doc=all) ASCIIDOC_EXTRA=$(ASCIIDOC_EXTRA)
 
 TAG_FOLDERS= . ../lib ../include
 TAG_FILES= ../../include/uapi/linux/perf_event.h
@@ -959,7 +959,7 @@ install-python_ext:
 
 # 'make install-doc' should call 'make -C Documentation install'
 $(INSTALL_DOC_TARGETS):
-	$(Q)$(MAKE) -C $(DOC_DIR) O=$(OUTPUT) $(@:-doc=)
+	$(Q)$(MAKE) -C $(DOC_DIR) O=$(OUTPUT) $(@:-doc=) ASCIIDOC_EXTRA=$(ASCIIDOC_EXTRA)
 
 ### Cleaning rules
 
-- 
2.26.2.303.gf8c07b1a785-goog

