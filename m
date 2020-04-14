Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1331A88C2
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503546AbgDNSM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503473AbgDNSLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:11:03 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF946C0610D6
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:11:01 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 33so429049pgx.17
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BlvWvGdkN2WeiBN4fqdYccjrgT9VbdrAfRUdSyUXBZE=;
        b=TZqQWV94Zuu65bh1l2U2we+9RQv0ecmGJ/H8OsjT+KUkAeOB0Im2t4v6FIP69dmojT
         TXzddpdrsIGUDPp7azXpW1Eok3r27SblClzb6ZvGs0vf8ESCCFAlhjLouhoYbG4aZe0s
         Zqfxgl0hZrH7160buCzm+WwdijtDQEdXVr0f6czTZed9sRSx9fA4Ot2E9x1vYhNhDwAK
         IFt2XupTwy63RUFA9G7aULrBKkPBd3DuXNyfOmmCPzr/+WpJFwG24wcTbnA8wNXH0m26
         cK/37ysy+da+dMHdJRpbtWL2Epdw0PvoUqjLQhy3nZicZqklG/9ungERiZxTOmT+VXyZ
         tO/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BlvWvGdkN2WeiBN4fqdYccjrgT9VbdrAfRUdSyUXBZE=;
        b=nNG/P+3otQPVMbYAv0Ibr2R9iMxsweFRBjW33ksAmEfBnWYVLhYlfMdiDfQJb0KSMj
         R6sAimZati1/YKESb+d9T7Iqo83DnypQsg3HcxseXj/MoKCoyqR0ceiSQVaexeuFC3o7
         Qp+rk20fKsGqju2TOuMbBbxqfE5P9xAk00uu6/YVpLog/ThIgFThWXu+IbdYndO5H8yA
         NqHhzdJSR9V0vtKmF9P5HNSc4WN4ypMIdM+qmA4J/kxIFAxSkEskTFDj7aRn07XuRhPQ
         /3cE6tln2E//dudVtkzcGdFwMsXQDh/5F9WHLq9JOUZk0AaUce9eli/uIXh1EhgB5U5e
         dO7g==
X-Gm-Message-State: AGi0PuZTc/h1VPEgr7pe+iD8Q9h/BpnXVPJqJFk6LLbG7z8+dqgytBfW
        DQRqU6IHU9Cke8PlhIrp53w9FGuEwPHC
X-Google-Smtp-Source: APiQypJpp1FHKo9I4j4uknzvoQXqGMx6BkeFOtMVeAThGZ2kTspRZEZVLXgIe/H5UnbizK5QcpZHfol1Mqvg
X-Received: by 2002:a63:e74f:: with SMTP id j15mr22888445pgk.153.1586887861370;
 Tue, 14 Apr 2020 11:11:01 -0700 (PDT)
Date:   Tue, 14 Apr 2020 11:10:51 -0700
In-Reply-To: <20200414181054.22435-1-irogers@google.com>
Message-Id: <20200414181054.22435-2-irogers@google.com>
Mime-Version: 1.0
References: <20200414181054.22435-1-irogers@google.com>
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

