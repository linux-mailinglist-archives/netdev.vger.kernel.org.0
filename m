Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9DF1D568B
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgEOQuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726023AbgEOQuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:50:18 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C45C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:50:17 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id z1so3149369qvd.23
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6zJdeczCxXIR05ROPjfL5M3I5d1ozekeF2WaxmhUPXo=;
        b=lWDuCPSEHnSqfmNmK7U6zSigGtw2pUvPEmqBm3E79EfmUdhRFZKr9rmmlG8SLtiTLY
         8HCqoaQuGDPxignnWBj97QPYO0GwwkgCH1z0wTKLYpS7vxYkxdK21eAfNqBq1eACYnKW
         X/07rqk/NxKbF66ALRKpmYyVR/Wyx+OYTCq24+o2G2V49wg3xHyYb7VUXnnmYcp+gEQF
         nL2XDaWLaYS/Je45LXoeJJMo6D2hMR2jOfXa7nomoK6/lPSR11Brli1vClEnVFZqT/pv
         2sIB00W6zEXOfVYKy1WDxw2k2tj56W5+R3oq9j7OmEXIeXAyCBwW0+ZP4ExwI5AK0m5d
         F/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6zJdeczCxXIR05ROPjfL5M3I5d1ozekeF2WaxmhUPXo=;
        b=f+NTesUU075Y5Yi0AstUDqC10C4xNdUc3Dl+5pWHVOiFt2dDf4qLROyHlyuX/XCkaS
         VROnewk1bSqDMcjctBUq9iMS6RiZUJW5etEc7wDs3yDSFuxDWxVv5Tu4GkiTt2DepxES
         UYtVb89FF4IdMzG0U4GIA375o5dVk9aj5He43nH+dC4WACUxeSaInhx289zwMRPlqNaP
         bGTOTteQgyji6BYmiNpdYAI6BrSRY/qVh7HW3ad0v1LRfx+mFT5qCfoOVeHvCXifUGAZ
         FkO1UzEL+OGKMhb7MzspuSKJCZJrF+KdaQoK7WNff4F2iXXYscDO9yR55+wuCZkyWCnR
         0KQQ==
X-Gm-Message-State: AOAM533GQSFIxlrvBca9QbrDa2LnKH+/20yExui23lmKF32ozsgzpe6D
        rc8p41Vi8/cusbM+Nm8JQbnOBqlzX5g1
X-Google-Smtp-Source: ABdhPJzJeU3KJoEKMsk2E7nrlFXgcd2WBQbWwlr2cF809BRrmVmF2HWm35q7vDzY8rUFv8F6tFzwUDUNfz/I
X-Received: by 2002:a0c:b58a:: with SMTP id g10mr4291860qve.225.1589561416205;
 Fri, 15 May 2020 09:50:16 -0700 (PDT)
Date:   Fri, 15 May 2020 09:50:02 -0700
In-Reply-To: <20200515165007.217120-1-irogers@google.com>
Message-Id: <20200515165007.217120-3-irogers@google.com>
Mime-Version: 1.0
References: <20200515165007.217120-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v2 2/7] libbpf hashmap: Remove unused #include
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

