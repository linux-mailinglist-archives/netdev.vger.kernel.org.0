Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA6043E27D
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhJ1NvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:51:10 -0400
Received: from foss.arm.com ([217.140.110.172]:55078 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229887AbhJ1NvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:51:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FB471FB;
        Thu, 28 Oct 2021 06:48:42 -0700 (PDT)
Received: from e121896.Emea.Arm.com (e121896.Emea.Arm.com [10.32.36.26])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 50F523F70D;
        Thu, 28 Oct 2021 06:48:38 -0700 (PDT)
From:   James Clark <james.clark@arm.com>
To:     acme@kernel.org, linux-perf-users@vger.kernel.org,
        f.fainelli@gmail.com, irogers@google.com
Cc:     James Clark <james.clark@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 0/3] Fix various bash constructs in tests
Date:   Thu, 28 Oct 2021 14:48:24 +0100
Message-Id: <20211028134828.65774-1-james.clark@arm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These tests were either failing or printing warnings on my Ubuntu 18
and 20 systems. I'm not sure if there is a system where /bin/sh allows
bash constructs, or perf invokes bash instead of sh, but I saw that
there have been similar fixes made in the past so I assume this should
be done.

Adding set -e to the scripts didn't highlight these issues, so I didn't
do it at this time.

For stat_bpf_counters.sh, there are further bashisms after the skip,
but I couldn't get BPF working, so I only fixed it up to that point.

Applies to perf/core 624ff63abfd36

James Clark (3):
  perf test: Remove bash construct from stat_bpf_counters.sh test
  perf tests: Remove bash construct from record+zstd_comp_decomp.sh
  perf tests: Remove bash constructs from stat_all_pmu.sh

 tools/perf/tests/shell/record+zstd_comp_decomp.sh | 2 +-
 tools/perf/tests/shell/stat_all_pmu.sh            | 4 ++--
 tools/perf/tests/shell/stat_bpf_counters.sh       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.28.0

