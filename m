Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E1D491154
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 22:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243269AbiAQVdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 16:33:15 -0500
Received: from foss.arm.com ([217.140.110.172]:37478 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243263AbiAQVdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 16:33:15 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27D21ED1;
        Mon, 17 Jan 2022 13:33:14 -0800 (PST)
Received: from [192.168.0.5] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A1873F774;
        Mon, 17 Jan 2022 13:33:11 -0800 (PST)
Subject: Re: [PATCH] perf record/arm-spe: Override attr->sample_period for
 non-libpfm4 events
To:     Ian Rogers <irogers@google.com>
Cc:     James Clark <james.clark@arm.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Chase Conklin <chase.conklin@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, "acme@kernel.org" <acme@kernel.org>
References: <20220114212102.179209-1-german.gomez@arm.com>
 <c2b960eb-a25e-7ce7-ee4b-2be557d8a213@arm.com>
 <35a4f70f-d7ef-6e3c-dc79-aa09d87f0271@arm.com>
 <CAP-5=fUHT29Z8Y5pMdTWK4mLKAXrNTtC5RBpet6UsAy4TLDfDw@mail.gmail.com>
From:   German Gomez <german.gomez@arm.com>
Message-ID: <10cc73f1-53fd-9c5a-7fe2-8cd3786fbe37@arm.com>
Date:   Mon, 17 Jan 2022 21:32:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAP-5=fUHT29Z8Y5pMdTWK4mLKAXrNTtC5RBpet6UsAy4TLDfDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ian,

On 17/01/2022 16:28, Ian Rogers wrote:
> [...]
> Thanks for fixing this, I can add an acked-by for the v2 patch. Could
> we add a test for this to avoid future regressions? There are similar
> tests for frequency like:
> https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/tools/perf/tests/attr/test-record-freq
> based on the attr.py test:
> https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/tools/perf/tests/attr.py
> The test specifies a base type of event attribute and then what is
> modified by the test. It takes a little to get your head around but
> having a test for this would be a welcome addition.

I agree I should have included a test for this fix. I'll look into this for the v2.

Other events such as "-p 10000 -e cycles//" worked fine. Only the ones with aux area tracing (arm_spe, cs_etm, intel_pt) were ignoring the global config flags.

Thank you for the pointers, and the review,
German

>
> Thanks!
> Ian
>
>> Thanks for the review,
>> German
