Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E0E49F61C
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 10:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347550AbiA1JSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 04:18:40 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:35881 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238113AbiA1JSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 04:18:39 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JlX144YdYzcctP;
        Fri, 28 Jan 2022 17:17:44 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 28 Jan 2022 17:18:35 +0800
Subject: Re: [PATCH bpf-next 2/2] arm64, bpf: support more atomic operations
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <jthierry@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20220121135632.136976-1-houtao1@huawei.com>
 <20220121135632.136976-3-houtao1@huawei.com>
 <61f23655411bc_57f032084@john.notmuch>
 <8b67fa3d-f83c-85a5-5159-70b0f913833a@huawei.com>
 <61f35869ba5a_738dc20823@john.notmuch>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <cf4f75c9-dccb-913f-4527-d358cf653f93@huawei.com>
Date:   Fri, 28 Jan 2022 17:18:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <61f35869ba5a_738dc20823@john.notmuch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/28/2022 10:43 AM, John Fastabend wrote:
> Hou Tao wrote:
>> Hi,
>>
>> On 1/27/2022 2:06 PM, John Fastabend wrote:
>>> Hou Tao wrote:
>>>> Atomics for eBPF patch series adds support for atomic[64]_fetch_add,
>>>> atomic[64]_[fetch_]{and,or,xor} and atomic[64]_{xchg|cmpxchg}, but
>>>> it only add support for x86-64, so support these atomic operations
>>>> for arm64 as well.
snip
>>>> +
>>>> +	switch (insn->imm) {
>>> Diff'ing X86 implementation which has a BPF_SUB case how is it avoided
>>> here?
>> I think it is just left over from patchset [1], because according to the LLVM
>> commit [2]
>> __sync_fetch_and_sub(&addr, value) is implemented by __sync_fetch_and_add(&addr,
>> -value).
>> I will post a patch to remove it.
> OK in that case LGTM with the caveat not an ARM expert.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
Thanks for your Acked-by.

Regards,
Tao
