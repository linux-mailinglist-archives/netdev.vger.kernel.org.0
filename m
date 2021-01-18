Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F027D2F9830
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 04:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbhARDXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 22:23:19 -0500
Received: from mail.loongson.cn ([114.242.206.163]:52398 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728664AbhARDXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Jan 2021 22:23:17 -0500
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxaL7s_gRgPYQGAA--.10491S3;
        Mon, 18 Jan 2021 11:22:21 +0800 (CST)
Subject: Re: [PATCH bpf 1/2] samples/bpf: Set flag __SANE_USERSPACE_TYPES__
 for MIPS to fix build warnings
To:     Yonghong Song <yhs@fb.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
References: <1610535453-2352-1-git-send-email-yangtiezhu@loongson.cn>
 <1610535453-2352-2-git-send-email-yangtiezhu@loongson.cn>
 <e3eb5919-4573-4576-e6aa-bd8ff56409ed@fb.com>
Cc:     linux-sparse@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <f077bcae-97be-fc7f-c3fa-c6026bfe25d2@loongson.cn>
Date:   Mon, 18 Jan 2021 11:22:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <e3eb5919-4573-4576-e6aa-bd8ff56409ed@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9DxaL7s_gRgPYQGAA--.10491S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFyfur4fWrW5KF1xZF1rCrg_yoW5uF47pa
        1vkay8CF4DCry3GFW2yr12vr1fX3yfG34jgFykWryjyF1agas2qr4kGrWa9rn7ur4Iy3y2
        9FyagFy5AFyrXrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F
        4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkIecxEwVAFwVW8GwCF04k20xvY0x0EwI
        xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
        6cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUUCeHPUUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/14/2021 01:12 AM, Yonghong Song wrote:
>
>
> On 1/13/21 2:57 AM, Tiezhu Yang wrote:
>> MIPS needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
>> 'int-ll64.h' in arch/mips/include/uapi/asm/types.h and avoid compile
>> warnings when printing __u64 with %llu, %llx or %lld.
>
> could you mention which command produces the following warning?

make M=samples/bpf

>
>>
>>      printf("0x%02x : %llu\n", key, value);
>>                       ~~~^          ~~~~~
>>                       %lu
>>     printf("%s/%llx;", sym->name, addr);
>>                ~~~^               ~~~~
>>                %lx
>>    printf(";%s %lld\n", key->waker, count);
>>                ~~~^                 ~~~~~
>>                %ld
>>
>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>> ---
>>   samples/bpf/Makefile        | 4 ++++
>>   tools/include/linux/types.h | 3 +++
>>   2 files changed, 7 insertions(+)
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index 26fc96c..27de306 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -183,6 +183,10 @@ BPF_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
>>   TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
>>   endif
>>   +ifeq ($(ARCH), mips)
>> +TPROGS_CFLAGS += -D__SANE_USERSPACE_TYPES__
>> +endif
>> +
>
> This change looks okay based on description in
> arch/mips/include/uapi/asm/types.h
>
> '''
> /*
>  * We don't use int-l64.h for the kernel anymore but still use it for
>  * userspace to avoid code changes.
>  *
>  * However, some user programs (e.g. perf) may not want this. They can
>  * flag __SANE_USERSPACE_TYPES__ to get int-ll64.h here.
>  */
> '''
>
>>   TPROGS_CFLAGS += -Wall -O2
>>   TPROGS_CFLAGS += -Wmissing-prototypes
>>   TPROGS_CFLAGS += -Wstrict-prototypes
>> diff --git a/tools/include/linux/types.h b/tools/include/linux/types.h
>> index 154eb4e..e9c5a21 100644
>> --- a/tools/include/linux/types.h
>> +++ b/tools/include/linux/types.h
>> @@ -6,7 +6,10 @@
>>   #include <stddef.h>
>>   #include <stdint.h>
>>   +#ifndef __SANE_USERSPACE_TYPES__
>>   #define __SANE_USERSPACE_TYPES__    /* For PPC64, to get LL64 types */
>> +#endif
>
> What problem this patch fixed?

If add "TPROGS_CFLAGS += -D__SANE_USERSPACE_TYPES__" in
samples/bpf/Makefile, it appears the following error:

Auto-detecting system features:
...                        libelf: [ on  ]
...                          zlib: [ on  ]
...                           bpf: [ OFF ]

BPF API too old
make[3]: *** [Makefile:293: bpfdep] Error 1
make[2]: *** [Makefile:156: all] Error 2

With #ifndef __SANE_USERSPACE_TYPES__  in tools/include/linux/types.h,
the above error has gone.

> If this header is used, you can just
> change comment from "PPC64" to "PPC64/MIPS", right?

If include <linux/types.h> in the source files which have compile warnings
when printing __u64 with %llu, %llx or %lld, it has no effect due to 
actually
it includes usr/include/linux/types.h instead of 
tools/include/linux/types.h,
this is because the include-directories in samples/bpf/Makefile are searched
in the order, -I./usr/include is in the front of -I./tools/include.

So I think define __SANE_USERSPACE_TYPES__ for MIPS in samples/bpf/Makefile
is proper, at the same time, add #ifndef __SANE_USERSPACE_TYPES__ in
tools/include/linux/types.h can avoid build error and have no side effect.

I will send v2 later with mention in the commit message that this is
mips related.

Thanks,
Tiezhu

>
>> +
>>   #include <asm/types.h>
>>   #include <asm/posix_types.h>
>>

