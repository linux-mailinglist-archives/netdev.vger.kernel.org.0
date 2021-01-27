Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BF93050E7
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbhA0EaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:09 -0500
Received: from mail.loongson.cn ([114.242.206.163]:35288 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392344AbhA0BmB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 20:42:01 -0500
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxS+ShxBBgWooNAA--.21016S3;
        Wed, 27 Jan 2021 09:40:50 +0800 (CST)
Subject: Re: [PATCH bpf-next] samples/bpf: Add include dir for MIPS Loongson64
 to fix build errors
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
References: <1611669925-25315-1-git-send-email-yangtiezhu@loongson.cn>
 <67891f2f-a374-54fb-e6e5-44145190934f@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xuefeng Li <lixuefeng@loongson.cn>
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <add50f8c-7592-75ec-ffb2-84c4280f2fc7@loongson.cn>
Date:   Wed, 27 Jan 2021 09:40:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <67891f2f-a374-54fb-e6e5-44145190934f@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9DxS+ShxBBgWooNAA--.21016S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXFyxXrW5ZFW7WFyfWr13XFb_yoW5XrWfpa
        n3uanrKrWUXry5GayxCryUWr4Yy398G3yYgFWrWr45Aa4qqasagr4ktrW5urZ3GryIya1S
        yr9xKF98GF1kZ37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxV
        WxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
        Yx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbV
        WUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_KwCF04k20xvY0x0EwI
        xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
        6cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb9mitUUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/27/2021 12:01 AM, Daniel Borkmann wrote:
> On 1/26/21 3:05 PM, Tiezhu Yang wrote:
>> There exists many build errors when make M=samples/bpf on the Loongson
>> platform, this issue is MIPS related, x86 compiles just fine.
>>
>> Here are some errors:
> [...]
>>
>> So we can do the similar things in samples/bpf/Makefile, just add
>> platform specific and generic include dir for MIPS Loongson64 to
>> fix the build errors.
>
> Your patch from [0] said ...
>
>   There exists many build warnings when make M=samples/bpf on the 
> Loongson
>   platform, this issue is MIPS related, x86 compiles just fine.
>
>   Here are some warnings:
>   [...]
>
>   With #ifndef __SANE_USERSPACE_TYPES__  in tools/include/linux/types.h,
>   the above error has gone and this ifndef change does not hurt other
>   compilations.
>
> ... which ave the impression that all the issues were fixed. What else
> is needed aside from this patch here? More samples/bpf fixes coming? If
> yes, please all submit them as a series instead of individual ones.

Hi Daniel,

Thanks for your reply.

This is the last samples/bpf patch to fix the obvious build issues when
make M=samples/bpf on the MIPS Loongson64 platform.

There is another MIPS patch to fix the following build error when make
M=samples/bpf, but it seems a common and known issue when build MIPS
kernel used with clang [1]:

./arch/mips/include/asm/checksum.h:161:9: error: unsupported inline asm: 
input with type 'unsigned long' matching output with type '__wsum' (aka 
'unsigned int')
         : "0" ((__force unsigned long)daddr),
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
1 error generated.

Because these two patches are independent, this one is bpf-next related,
the other one is mips-next related, so I submit them sepearately.

[1] 
https://lore.kernel.org/linux-mips/CAG_fn=W0JHf8QyUX==+rQMp8PoULHrsQCa9Htffws31ga8k-iw@mail.gmail.com/

Thanks,
Tiezhu

>
>  [0] 
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=190d1c921ad0862da14807e1670f54020f48e889
>
>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>> ---
>>   samples/bpf/Makefile | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index 362f314..45ceca4 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -185,6 +185,10 @@ endif
>>     ifeq ($(ARCH), mips)
>>   TPROGS_CFLAGS += -D__SANE_USERSPACE_TYPES__
>> +ifdef CONFIG_MACH_LOONGSON64
>> +BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-loongson64
>> +BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-generic
>> +endif
>>   endif
>>     TPROGS_CFLAGS += -Wall -O2
>>

