Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852F91AB82B
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 08:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408153AbgDPGh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 02:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407813AbgDPGgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 02:36:04 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82557C061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 23:36:02 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g11so2281597pgd.20
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 23:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BlvWvGdkN2WeiBN4fqdYccjrgT9VbdrAfRUdSyUXBZE=;
        b=H9atdV+jIHLzhnSRMTGxi6PhgpWAWnmvxLtdgQ7Ze7tsMGx9/Ozfs7Mn/5s7MeGlJK
         cM97cLthvXZj9VfG0UHnIuPZ791ZlqBPcKhl4TKU0gtRxvg27tC9/JA9JN+Z35ZKy5Eb
         FNX25TnWgyh1XsxMgMivQgd44/xASJmd+AL35hxIxietW6xABCdGNpCtY14SNQj1BL3g
         CQncp2pfrj8kIvTXpplmDmWGUgT+AflRLJSPvtWyB3FNcgisU0QaTPa0qwVh8jSRbLS2
         suJMQzyoMqRDHLBu/SlnDfcgOBPVFAGWMQ0qbYprF6Q93xwpM6+wM2DSPrhRpO48dY2x
         Hs9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BlvWvGdkN2WeiBN4fqdYccjrgT9VbdrAfRUdSyUXBZE=;
        b=sCFqL5MLo+i7Bu7TpgSzFAJIEKjPgUPyPvWbrqvR6OSBrYpUMAQpmE157SJrTBGl9T
         kENXeqE/SL4oC71sx7Id4R/8b2T9BT3aaqK2rR3SklVeQzjszvziN4kk49UMmkwt8Um+
         5qXXCTuqUpr43v5P+BAS87y7XMkYGgwy+NQtVimlUZH1FFKk7mDOOKlygEbpSk0pR/up
         Oj0oJ/5eVxOBKLiZGANK/SR5CjcdjoR/sxqJNPxP45dhzWJEOf88BNETl4WuGcLQSPnA
         kzc9tUwj+gXa3+8VMJhfcodAWIjvU/U/PhKHPTU2RfTyuBnIjyVWm6fnVkmlsfHitK3y
         M+Mg==
X-Gm-Message-State: AGi0Pub+JHx40K//9e8Nae/PUFo+dB8omQ35jKgqg4HJMyE0FgWGqjBJ
        ggHz3LoAoLmGQfSsMumQsUdYB6pzy13T
X-Google-Smtp-Source: APiQypIXFlNyU4jPKhKsW7bqQXqygCJOPH3HCUAQSTDfa58kIDTMxNra7PCCqatriqPbIiuDRDfFA+hXIhFk
X-Received: by 2002:a63:31c4:: with SMTP id x187mr29767475pgx.56.1587018961894;
 Wed, 15 Apr 2020 23:36:01 -0700 (PDT)
Date:   Wed, 15 Apr 2020 23:35:48 -0700
In-Reply-To: <20200416063551.47637-1-irogers@google.com>
Message-Id: <20200416063551.47637-2-irogers@google.com>
Mime-Version: 1.0
References: <20200416063551.47637-1-irogers@google.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v9 1/4] perf doc: allow ASCIIDOC_EXTRA to be an argument
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

This will allow parent makefiles to pass values to asciidoc.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/Documentation/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index 31824d5269cc..6e54979c2124 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -48,7 +48,7 @@ man5dir=$(mandir)/man5
 man7dir=$(mandir)/man7
 
 ASCIIDOC=asciidoc
-ASCIIDOC_EXTRA = --unsafe -f asciidoc.conf
+ASCIIDOC_EXTRA += --unsafe -f asciidoc.conf
 ASCIIDOC_HTML = xhtml11
 MANPAGE_XSL = manpage-normal.xsl
 XMLTO_EXTRA =
@@ -59,7 +59,7 @@ HTML_REF = origin/html
 
 ifdef USE_ASCIIDOCTOR
 ASCIIDOC = asciidoctor
-ASCIIDOC_EXTRA = -a compat-mode
+ASCIIDOC_EXTRA += -a compat-mode
 ASCIIDOC_EXTRA += -I. -rasciidoctor-extensions
 ASCIIDOC_EXTRA += -a mansource="perf" -a manmanual="perf Manual"
 ASCIIDOC_HTML = xhtml5
-- 
2.26.0.110.g2183baf09c-goog

