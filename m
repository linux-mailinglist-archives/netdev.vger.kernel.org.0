Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB9F1808A2
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 20:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgCJT7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 15:59:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:58810 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgCJT7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 15:59:16 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 12:59:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,538,1574150400"; 
   d="scan'208";a="231440862"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by orsmga007.jf.intel.com with ESMTP; 10 Mar 2020 12:59:15 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 7AF3C301BCC; Tue, 10 Mar 2020 12:59:15 -0700 (PDT)
Date:   Tue, 10 Mar 2020 12:59:15 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf tools: add support for lipfm4
Message-ID: <20200310195915.GA1676879@tassilo.jf.intel.com>
References: <20200310185003.57344-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310185003.57344-1-irogers@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 11:50:03AM -0700, Ian Rogers wrote:
> This patch links perf with the libpfm4 library.
> This library contains all the hardware event tables for all
> processors supported by perf_events. This is a helper library
> that help convert from a symbolic event name to the event
> encoding required by the underlying kernel interface. This
> library is open-source and available from: http://perfmon2.sf.net.

For most CPUs the builtin perf JSON event support should make
this redundant.

Perhaps you could list what CPUs it actually supports over
the existing JSON tables.

If it's only a few it would be likely better to add
appropiate json files.

If it's a massive number it might be useful, although
JSON support would be better for those too.

-Andi
