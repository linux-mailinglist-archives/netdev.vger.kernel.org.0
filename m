Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D621940ADE0
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhINMib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:38:31 -0400
Received: from mail.loongson.cn ([114.242.206.163]:42754 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232524AbhINMia (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 08:38:30 -0400
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxn2tEl0BhhZgGAA--.14513S3;
        Tue, 14 Sep 2021 20:36:22 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: Re: [PATCH bpf-next v2] bpf: Change value of MAX_TAIL_CALL_CNT from
 32 to 33
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        naveen.n.rao@linux.ibm.com, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, bjorn@kernel.org,
        davem@davemloft.net,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Paul Chaignon <paul@cilium.io>
References: <1631325361-9851-1-git-send-email-yangtiezhu@loongson.cn>
 <0fb8d16f-67e7-7197-fce2-a4c17f1e5987@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, sparclinux@vger.kernel.org
Message-ID: <9ad382ca-a254-f897-9ec6-c9b1920a6174@loongson.cn>
Date:   Tue, 14 Sep 2021 20:36:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <0fb8d16f-67e7-7197-fce2-a4c17f1e5987@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9Dxn2tEl0BhhZgGAA--.14513S3
X-Coremail-Antispam: 1UD129KBjvJXoWxurW7Gw1DJw1UGw4xGFW3KFg_yoW5Ar43pr
        WUJanakr4kXFyrC3ZrKa1xZay0vFZ8tryUGrWrK342yFn8Zrn5WF4xK3yFgF1UAryrta4F
        9ayFkr95C3WkZFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9Gb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l
        c7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_Xr1l42xK82IYc2Ij64vIr41l4I8I3I
        0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
        GVWUWwC2zVAF1VAY17CE14v26rWY6r4UJwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14
        v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xva
        j40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxV
        W8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU5lsj5UUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/14/2021 03:30 PM, Daniel Borkmann wrote:
> On 9/11/21 3:56 AM, Tiezhu Yang wrote:
>>
[...]
>> With this patch, it does not change the current limit 33, 
>> MAX_TAIL_CALL_CNT
>> can reflect the actual max tail call count, the tailcall selftests 
>> can work
>> well, and also the above failed testcase in test_bpf can be fixed for 
>> the
>> interpreter (all archs) and the JIT (all archs except for x86).
>>
>>   # uname -m
>>   x86_64
>>   # echo 1 > /proc/sys/net/core/bpf_jit_enable
>>   # modprobe test_bpf
>>   # dmesg | grep -w FAIL
>>   Tail call error path, max count reached jited:1 ret 33 != 34 FAIL
>
> Could you also state in here which archs you have tested with this 
> change? I
> presume /every/ arch which has a JIT?

OK, will do it in v3.
I have tested on x86 and mips.

>
>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>> ---
>>
>> v2:
>>    -- fix the typos in the commit message and update the commit message.
>>    -- fix the failed tailcall selftests for x86 jit.
>>       I am not quite sure the change on x86 is proper, with this change,
>>       tailcall selftests passed, but tailcall limit test in test_bpf.ko
>>       failed, I do not know the reason now, I think this is another 
>> issue,
>>       maybe someone more versed in x86 jit could take a look.
>
> There should be a series from Johan coming today with regards to 
> test_bpf.ko
> that will fix the "tail call error path, max count reached" test which 
> had an
> assumption in that R0 would always be valid for the fall-through and 
> could be
> passed to the bpf_exit insn whereas it is not guaranteed and verifier, 
> for
> example, forbids a subsequent access to R0 w/o reinit. For your 
> testing, I
> would suggested to recheck once this series is out.

I will test the following patch on x86 and mips:

[PATCH bpf v4 13/14] bpf/tests: Fix error in tail call limit tests

[...]

>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
>> index 0fe6aac..74a9e61 100644
>> --- a/arch/x86/net/bpf_jit_comp.c
>> +++ b/arch/x86/net/bpf_jit_comp.c
>> @@ -402,7 +402,7 @@ static int get_pop_bytes(bool *callee_regs_used)
>>    * ... bpf_tail_call(void *ctx, struct bpf_array *array, u64 index) 
>> ...
>>    *   if (index >= array->map.max_entries)
>>    *     goto out;
>> - *   if (++tail_call_cnt > MAX_TAIL_CALL_CNT)
>> + *   if (tail_call_cnt++ == MAX_TAIL_CALL_CNT)
>
> Why such inconsistency to e.g. above with arm64 case but also compared to
> x86 32 bit which uses JAE? If so, we should cleanly follow the reference
> implementation (== interpreter) _everywhere_ and _not_ introduce 
> additional
> variants/implementations across JITs.

In order tokeep consistencyand make as few changes as possible,
<javascript:void(0);>I will modify the check condition as follows:

#define MAX_TAIL_CALL_CNT 33
(1) for x86, arm64, ... (0 ~ 32)
tcc = 0;
if (tcc == MAX_TAIL_CALL_CNT)
     goto out;
tcc++;

(2) for mips, riscv (33 ~ 1)
tcc = MAX_TAIL_CALL_CNT;
if (tcc == 0)
     goto out;
tcc--;

[...]

