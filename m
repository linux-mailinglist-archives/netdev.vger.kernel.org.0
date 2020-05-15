Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63FA1D5CA9
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 01:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgEOXKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 19:10:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:43548 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgEOXKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 19:10:06 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZjSH-0003dR-TU; Sat, 16 May 2020 01:09:25 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZjSH-0006rZ-3f; Sat, 16 May 2020 01:09:25 +0200
Subject: Re: [PATCH v2 0/7] Copy hashmap to tools/perf/util, use in perf expr
To:     arnaldo.melo@gmail.com, Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
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
        Leo Yan <leo.yan@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org
References: <20200515165007.217120-1-irogers@google.com>
 <20200515170036.GA10230@kernel.org>
 <CAEf4BzZ5=_yu1kL77n+Oc0K9oaDi4J=c+7CV8D0AXs2hBxhNbw@mail.gmail.com>
 <5ebf0748.1c69fb81.f8310.eef3@mx.google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ed5c6584-791a-96e3-7043-19e4d7390289@iogearbox.net>
Date:   Sat, 16 May 2020 01:09:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <5ebf0748.1c69fb81.f8310.eef3@mx.google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25813/Fri May 15 14:16:29 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/20 11:18 PM, arnaldo.melo@gmail.com wrote:
[...]
>>> Andrii/Alexei/Daniel, what do you think about me merging these fixes
>> in my
>>> perf-tools-next branch?
>>
>> I'm ok with the idea, but it's up to maintainers to coordinate this :)
> 
> Good to know, do I'll take all patches except the ones touching libppf, will just make sure the copy is done with the patches applied.
> 
> At some point they'll land in libbpf and the warning from check_headers.sh will be resolved.

Works for me, I've just taken in Ian's two libbpf ones into bpf-next.

Thanks everyone,
Daniel
