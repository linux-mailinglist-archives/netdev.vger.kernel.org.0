Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2861DBC9A
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgETSUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbgETSUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:20:36 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C32C08C5C0
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:20:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 207so2644764ybl.2
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qEvd4x8iUsR7kfWiuh/jmJJHKtjhzJyBE+y8nt3gTxE=;
        b=eVokqwG3f1DWq3B2VU75ImzZJZ87g4smfOOCsLyMgXVgInjD2jU69dwde+ItcqJCoJ
         CNyunHXm6dMA3c9XZOdci2HOwhzsz/8sZSgHtx3RHEgonCETRLDDrzDPiiGzgrztPbmF
         Ug5byOB2TfNbnnl0cmLQ/v50g27rDmPAN+ajcNGGk6MpKt6naNcWkHu/mD0yvPYwHliV
         VscfqS5NAPHHzNdc+ctVoX859ZoeTq3nXyGi2XgmER9idZLk1PnhljYrqBslz49+Uf1A
         ZM2POxrcKFzPCleuLmPa21gczdL8oLT+njyEU7hezS7DaAHxXyP7mns9wT9LjOkb6Bk4
         eNfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qEvd4x8iUsR7kfWiuh/jmJJHKtjhzJyBE+y8nt3gTxE=;
        b=kADQ5RFsH4IOagRuis/oCaGJ/E/R3u7q2QGLOYytAfsujABhGwCBvKzr54o+SAhzwO
         pT85sb+P4EPmJ0d46XWoOQ4Esg8BPtk4lulVYvy4hRjObTWE7i33h3hk8IrLqpLBvACJ
         RJnA/BEfVuQAZUWebRKJSqW0UijqumOWeATF8yLV1bLSpTg/97eZDZXXtkTNPj9Fpmcy
         y9FlwBPbXdn9NU+CEZs2AjQmZr3eicxP3fex2zFIawBORgej1QRD33ShrAEmViFQTL8l
         FOp0ydofFkODOmnxG3056t0r0+KueA12MbDrlAar58Y6frHZUXJ0jQDXbZTeGy649NK1
         GYwA==
X-Gm-Message-State: AOAM532hQeRba9WC0YK9gvgn2Z4GJYXPDeGOXFjzfRDy72TH/RIibKso
        6NmGryAtDqBPd+ubdiDvEn9RBvamHX6A
X-Google-Smtp-Source: ABdhPJyHN+0rbcjsE/V1xWdrFn3brQHIAZ0/P+ok6EF+o35T6o8TF2+dmB6jytrwLcuIYo7jKTFV1BeJId9P
X-Received: by 2002:a25:3610:: with SMTP id d16mr9112137yba.222.1589998834804;
 Wed, 20 May 2020 11:20:34 -0700 (PDT)
Date:   Wed, 20 May 2020 11:20:11 -0700
In-Reply-To: <20200520182011.32236-1-irogers@google.com>
Message-Id: <20200520182011.32236-8-irogers@google.com>
Mime-Version: 1.0
References: <20200520182011.32236-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v2 7/7] perf metricgroup: Remove unnecessary ',' from events
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unnecessary commas from events before they are parsed. This
avoids ',' being echoed by parse-events.l.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/metricgroup.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 50d22f6b60c0..f787161e54ba 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -501,9 +501,14 @@ static void metricgroup__add_metric_non_group(struct strbuf *events,
 {
 	struct hashmap_entry *cur;
 	size_t bkt;
+	bool first = true;
 
-	hashmap__for_each_entry((&ctx->ids), cur, bkt)
-		strbuf_addf(events, ",%s", (const char *)cur->key);
+	hashmap__for_each_entry((&ctx->ids), cur, bkt) {
+		if (!first)
+			strbuf_addf(events, ",");
+		strbuf_addf(events, "%s", (const char *)cur->key);
+		first = false;
+	}
 }
 
 static void metricgroup___watchdog_constraint_hint(const char *name, bool foot)
-- 
2.26.2.761.g0e0b3e54be-goog

