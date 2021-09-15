Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9DD40C067
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 09:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbhIOHX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 03:23:59 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:49856 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236490AbhIOHX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 03:23:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UoSeiPZ_1631690555;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UoSeiPZ_1631690555)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 15 Sep 2021 15:22:36 +0800
Subject: Re: [PATCH] perf: fix panic by disable ftrace on fault.c
To:     Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:X86 MM" <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
References: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
 <d16e7188-1afa-7513-990c-804811747bcb@linux.alibaba.com>
 <d85f9710-67c9-2573-07c4-05d9c677d615@intel.com>
 <d8853e49-8b34-4632-3e29-012eb605bea9@linux.alibaba.com>
 <09777a57-a771-5e17-7e17-afc03ea9b83b@linux.alibaba.com>
 <4f63c8bc-1d09-1717-cf81-f9091a9f9fb0@linux.alibaba.com>
 <18252e42-9c30-73d4-e3bb-0e705a78af41@intel.com>
 <4cba7088-f7c8-edcf-02cd-396eb2a56b46@linux.alibaba.com>
 <bbe09ffb-08b7-824c-943f-dffef51e98c2@intel.com>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <ac31b8c7-122e-3467-566b-54f053ca0ae2@linux.alibaba.com>
Date:   Wed, 15 Sep 2021 15:22:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <bbe09ffb-08b7-824c-943f-dffef51e98c2@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/15 上午11:27, Dave Hansen wrote:
> On 9/14/21 6:56 PM, 王贇 wrote:
>>>> [   44.134987][    C0]  ? __sanitizer_cov_trace_pc+0x7/0x60
>>>> [   44.135005][    C0]  ? kcov_common_handle+0x30/0x30
>>> Just turning off tracing for the page fault handler is papering over the
>>> problem.  It'll just come back later with a slightly different form.
>>>
>> Cool~ please let me know when you have the proper approach.
> 
> It's an entertaining issue, but I wasn't planning on fixing it myself.
> 

Do you have any suggestion on how should we fix the problem?

I'd like to help fix it, but sounds like all the known working approach
are not acceptable...

Regards,
Michael Wang
