Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667B93C5831
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344564AbhGLImi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 04:42:38 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:40922
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350572AbhGLIht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 04:37:49 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id D9AEB40325;
        Mon, 12 Jul 2021 08:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626078888;
        bh=Pzh4dpmLwQ8NXTWOU/AqP/Io9WI9Fmjor6J5jI85EO0=;
        h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=SE/XbkgzHSQIP+rm00RAY7rkDNB4P1AZ0BxglE+wU9yj8Bo1qx+U8WoxuE9loYbW2
         din6bNOnctHusKV5Ts344LcS4cNGjez01//8ZHCU1f9hvo/XNLmUgKiKMpxJjcBJZ3
         JLzrLV7Bd+R+Oka5aKhnIo/WOeMeGRUgc6V+ZlL5K2hL2pZZqjGLx94AYOjZeoT/qn
         5xVGvupiXxZ/QKO4I4Tz85TTgiwHY2FK5qjeIIj6czpTYuhFm/901KHU6dp1m/c7vX
         Om13gXg4ianchA/iOqBhXrWSaiFSN/Sm+7IFnKgx2rKB+dGZ1S+hts0XzrA3kmAVxI
         vU3nS2OEQ5eiA==
From:   Colin King <colin.king@canonical.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] perf tools: Fix spelling mistake "falied" -> "failed"
Date:   Mon, 12 Jul 2021 09:34:48 +0100
Message-Id: <20210712083448.26317-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a pr_err error message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 tools/perf/util/bpf_counter_cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf_counter_cgroup.c b/tools/perf/util/bpf_counter_cgroup.c
index 89aa5e71db1a..4139b4deee77 100644
--- a/tools/perf/util/bpf_counter_cgroup.c
+++ b/tools/perf/util/bpf_counter_cgroup.c
@@ -266,7 +266,7 @@ static int bperf_cgrp__read(struct evsel *evsel)
 		idx = evsel->core.idx;
 		err = bpf_map_lookup_elem(reading_map_fd, &idx, values);
 		if (err) {
-			pr_err("bpf map lookup falied: idx=%u, event=%s, cgrp=%s\n",
+			pr_err("bpf map lookup failed: idx=%u, event=%s, cgrp=%s\n",
 			       idx, evsel__name(evsel), evsel->cgrp->name);
 			goto out;
 		}
-- 
2.31.1

