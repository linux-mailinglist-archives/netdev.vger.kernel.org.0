Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098FA1D5B59
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgEOVTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726183AbgEOVTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:19:07 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A617C061A0C;
        Fri, 15 May 2020 14:19:06 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id x12so3240292qts.9;
        Fri, 15 May 2020 14:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:from:date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc;
        bh=srt7QXlq4v2mVg2Pcb9Nrsj43p0okN5hPOgneLc3kDU=;
        b=IC9yJMxMC2Bc6jWNDzMmlDB3+fmkmwHp/GWWHThRou0USteQZjoXvCa34feLiTCRPN
         dNOQYkuPLcaKLQ2We2ulkNlRwkMMmhx806CbAZ9kqYqCxubYJcM2Sv0AgQ2WuhvN1vry
         bj/pQzLlWwep0QtWwhaLgCxiu1pg+1P3BXOMJ7s5hNFL4H7WSgkS8heVf55vmEXwNLLR
         9D7vXoMh2Vl7M4/dAE97wulo0+0v6qrh6Xck/V53alDcLm77Tf3Tc9KkK4VgLQxSPMQb
         +6fLLcND3PXxIwflu/ffcUfn5qBNK1WA8oHUpGIfjbs1ZHbMHnivwVKvFE1cxJYo0uQC
         /lfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:date:user-agent:in-reply-to
         :references:mime-version:content-transfer-encoding:subject:to:cc;
        bh=srt7QXlq4v2mVg2Pcb9Nrsj43p0okN5hPOgneLc3kDU=;
        b=ZIsMR9Ifqi3KOg+DhznC6GbHNGQjNtf7DHU0zfiFm3u1KKp4kJFsZvdOKqIH+MYYyu
         B4adPQT5y2+f3+dkHYq4qoYprI2exzH5CrLw+LjJH38TE2YPbU6i+UOSVa8ppmyjtelD
         t2348rMZbhMVmTLjkJvAX9x6q9weJTQ3A8yzTqsUZlxu4OmLPvxyRvl/T1nkDChzDxhS
         zbrgjB0+ABEoBkx1bOEqo8e+tU/NSUPkIplvCzhYdI2MK3egVGCDWCdyQKRtfXUXU0Mv
         Uo7joT2BZMD49WQ65w3LqmAa7U+hbnIXELkCXOFLNGaxqyxX3OSjaPSubUmfr9EsiuuN
         K/rg==
X-Gm-Message-State: AOAM531WHtYjfVA4b2eEa67DsivK3UaQ/rb2F12SnEIwAck7XnCqqm1+
        ZPIaR6AnwtinjqGSaUONSlU=
X-Google-Smtp-Source: ABdhPJyzrzazSLyxQqTYcTXRILBssVzRq+eZQpILUE2lrhccijlaN/BQkScN0/xmxqKfyyqk5ZtR3A==
X-Received: by 2002:ac8:6b8a:: with SMTP id z10mr5471891qts.373.1589577545145;
        Fri, 15 May 2020 14:19:05 -0700 (PDT)
Received: from [192.168.86.185] ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id d7sm2420093qkk.26.2020.05.15.14.19.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2020 14:19:04 -0700 (PDT)
Message-ID: <5ebf0748.1c69fb81.f8310.eef3@mx.google.com>
From:   arnaldo.melo@gmail.com
Date:   Fri, 15 May 2020 18:18:45 -0300
User-Agent: K-9 Mail for Android
In-Reply-To: <CAEf4BzZ5=_yu1kL77n+Oc0K9oaDi4J=c+7CV8D0AXs2hBxhNbw@mail.gmail.com>
References: <20200515165007.217120-1-irogers@google.com> <20200515170036.GA10230@kernel.org> <CAEf4BzZ5=_yu1kL77n+Oc0K9oaDi4J=c+7CV8D0AXs2hBxhNbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 0/7] Copy hashmap to tools/perf/util, use in perf expr
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<bpf@vger.kernel.org>,Stephane Eranian <eranian@google.com>
From: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Message-ID: <79BCBAF7-BF5F-4556-A923-56E9D82FB570@gmail.com>



On May 15, 2020 4:42:46 PM GMT-03:00, Andrii Nakryiko <andrii=2Enakryiko@g=
mail=2Ecom> wrote:
>On Fri, May 15, 2020 at 10:01 AM Arnaldo Carvalho de Melo
><arnaldo=2Emelo@gmail=2Ecom> wrote:
>>
>> Em Fri, May 15, 2020 at 09:50:00AM -0700, Ian Rogers escreveu:
>> > Perf's expr code currently builds an array of strings then removes
>> > duplicates=2E The array is larger than necessary and has recently
>been
>> > increased in size=2E When this was done it was commented that a
>hashmap
>> > would be preferable=2E
>> >
>> > libbpf has a hashmap but libbpf isn't currently required to build
>> > perf=2E To satisfy various concerns this change copies libbpf's
>hashmap
>> > into tools/perf/util, it then adds a check in perf that the two are
>in
>> > sync=2E
>> >
>> > Andrii's patch to hashmap from bpf-next is brought into this set to
>> > fix issues with hashmap__clear=2E
>> >
>> > Two minor changes to libbpf's hashmap are made that remove an
>unused
>> > dependency and fix a compiler warning=2E
>>
>> Andrii/Alexei/Daniel, what do you think about me merging these fixes
>in my
>> perf-tools-next branch?
>
>I'm ok with the idea, but it's up to maintainers to coordinate this :)

Good to know, do I'll take all patches except the ones touching libppf, wi=
ll just make sure the copy is done with the patches applied=2E

At some point they'll land in libbpf and the warning from check_headers=2E=
sh will be resolved=2E

Thanks,

- Arnaldo

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
