Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A701D4682
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 08:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgEOG5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 02:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726659AbgEOG4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 02:56:35 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF4FC05BD0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 23:56:35 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id x26so1613135qvd.20
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 23:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6zJdeczCxXIR05ROPjfL5M3I5d1ozekeF2WaxmhUPXo=;
        b=l3OKb9/Pu0/xrbfvi4lE2TdFagJPZ+BcPCVUsNj1x3y0yxGzAHd4rZFb5smd6fBjNj
         E5sWXxqdr81LqYGmCrXKMXD26Kg4w64KQ4PrQb0AMH475KRgrmYJgqfinUUapGN7Kz0+
         JomMgqVpcsgelaft2fGQcqHV65twgmBNwO6YywGIvz5fFPrQKjW4r2P9MSpe+MLL9z0V
         RQOYhDIkOX8dkiQyqL8tEyMl+XCpKwT8/zrxBEQJE6gVIki9Z/7z27Q3MngZfJG4k6yh
         uyC+MInwMKFZubfIYfNfwhotQRMCL9SLOigBr4GX5+3V5evNYARi8ESBmeBfvf2faHMy
         31Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6zJdeczCxXIR05ROPjfL5M3I5d1ozekeF2WaxmhUPXo=;
        b=pPaVeLrOklktWpSIIoN0cH4hCl91w9D/AGlCGBvuIXgbSRaaKVquy1ZB31GiyWFVy2
         Qzhw3AltNpQcOcgWcz9BITF6p0FDrTLRhV9bymazkBx1D62LvkaxN0Ut2oRODd5msnJG
         kmuv/9rdZRqYBHm5deqxJPjYBRivt+0Qiv7Kx3/ZDalxz/8QEkmkcZdBVhHkZpHZ38y9
         cB8wkMuA/WBJhbx1Dn5quL3bkAgGKIFMyMtZBiTFoIC33By3uCPV/bxM7A88GQk7HGTf
         DBZy7rfKKvmqx71ZozTym7UNWUMCbOeKONEW1PYzLkxOyXxhI4QKi9y3eJCZ/Q8VYyWf
         mAEQ==
X-Gm-Message-State: AOAM531RKOrcp0w002CntBNyB37fZPXZmtn8zNXBBZWTNNTn6AX9/SSq
        aa3LSnbS6Xabsls9o+D/1vN62l/J7iXi
X-Google-Smtp-Source: ABdhPJxgP3QPfqhrDHlYbZvoBePrEE1LeamWczkyl3CHCs2p0Alr5VTy1rx2TlK6084IIR4Gb7TzZvSscmhG
X-Received: by 2002:ad4:5584:: with SMTP id e4mr2000014qvx.191.1589525794216;
 Thu, 14 May 2020 23:56:34 -0700 (PDT)
Date:   Thu, 14 May 2020 23:56:18 -0700
In-Reply-To: <20200515065624.21658-1-irogers@google.com>
Message-Id: <20200515065624.21658-3-irogers@google.com>
Mime-Version: 1.0
References: <20200515065624.21658-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 2/8] libbpf hashmap: Remove unused #include
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
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove #include of libbpf_internal.h that is unused.
Discussed in this thread:
https://lore.kernel.org/lkml/CAEf4BzZRmiEds_8R8g4vaAeWvJzPb4xYLnpF0X2VNY8oTzkphQ@mail.gmail.com/

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/lib/bpf/hashmap.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
index bae8879cdf58..e823b35e7371 100644
--- a/tools/lib/bpf/hashmap.h
+++ b/tools/lib/bpf/hashmap.h
@@ -15,7 +15,6 @@
 #else
 #include <bits/reg.h>
 #endif
-#include "libbpf_internal.h"
 
 static inline size_t hash_bits(size_t h, int bits)
 {
-- 
2.26.2.761.g0e0b3e54be-goog

