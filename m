Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7D44D27DC
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiCIEXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 23:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiCIEW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 23:22:58 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EC6314A075;
        Tue,  8 Mar 2022 20:21:58 -0800 (PST)
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxfxNfKyhio3kFAA--.207S3;
        Wed, 09 Mar 2022 12:21:52 +0800 (CST)
Subject: Re: [PATCH bpf-next v3 2/2] bpf: Make BPF_JIT_DEFAULT_ON selectable
 in Kconfig
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
References: <1645523826-18149-1-git-send-email-yangtiezhu@loongson.cn>
 <1645523826-18149-3-git-send-email-yangtiezhu@loongson.cn>
 <b2aa5233-282e-004c-1ba3-63417cbccd58@iogearbox.net>
Cc:     Xuefeng Li <lixuefeng@loongson.cn>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <c709954e-9232-d719-eeb2-6a05546231b6@loongson.cn>
Date:   Wed, 9 Mar 2022 12:21:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <b2aa5233-282e-004c-1ba3-63417cbccd58@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9DxfxNfKyhio3kFAA--.207S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWF4fGw4kXFW7Zw1fKF18Grg_yoWrZFW8pw
        1jqw1xKr97Xr1fKFW7Ca47GF4UGw4jgryDJFs8u3yUZF97ua4kCr40gw1jgF9rZr97Xa1j
        yrZ5u3WkZa1DWa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
        c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkIecxEwVAFwVW8XwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
        x2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
        AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjGYLDUUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/01/2022 07:53 AM, Daniel Borkmann wrote:
> Hi Tiezhu,
>
> (patch 1/2 applied so far, thanks!)
>
> On 2/22/22 10:57 AM, Tiezhu Yang wrote:
>> Currently, only x86, arm64 and s390 select ARCH_WANT_DEFAULT_BPF_JIT,
>> the other archs do not select ARCH_WANT_DEFAULT_BPF_JIT. On the archs
>> without ARCH_WANT_DEFAULT_BPF_JIT, if we want to set bpf_jit_enable to
>> 1 by default, the only way is to enable CONFIG_BPF_JIT_ALWAYS_ON, then
>> the users can not change it to 0 or 2, it seems bad for some users. We
>
> Can you elaborate on the "it seems bad for some users" part? What's the
> concrete

Hi Daniel,

Sorry for the late reply.

I saw the following two similar patches, some users want to set
bpf_jit_enable to 1 by default, at the same time, they want to
change it to 0 or 2 to debug, only enable CONFIG_BPF_JIT_DEFAULT_ON
is a proper way in such a case.

[PATCH bpf-next] bpf: trace jit code when enable BPF_JIT_ALWAYS_ON
https://lore.kernel.org/bpf/20210326124030.1138964-1-Jianlin.Lv@arm.com/

[PATCH bpf-next] bpf: support bpf_jit_enable=2 for CONFIG_BPF_JIT_ALWAYS_ON
https://lore.kernel.org/bpf/20211231153550.3807430-1-houtao1@huawei.com/


> use case? Also, why not add (e.g. mips) JIT to ARCH_WANT_DEFAULT_BPF_JIT
> if the
> CI suite passes with high degree/confidence?

Yes, we can let the specific arch select ARCH_WANT_DEFAULT_BPF_JIT in 
Kconfig, this commit only gives another chance to enable or disable 
CONFIG_BPF_JIT_DEFAULT_ON manually when make menuconfig, this is useful
to debug when develop JIT.

>
>> can select ARCH_WANT_DEFAULT_BPF_JIT for those archs if it is proper,
>> but at least for now, make BPF_JIT_DEFAULT_ON selectable can give them
>> a chance.
>>
>> Additionally, with this patch, under !BPF_JIT_ALWAYS_ON, we can disable
>> BPF_JIT_DEFAULT_ON on the archs with ARCH_WANT_DEFAULT_BPF_JIT when make
>> menuconfig, it seems flexible for some developers.
>>
>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>> ---
>>   kernel/bpf/Kconfig | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
>> index f3db15a..8521874 100644
>> --- a/kernel/bpf/Kconfig
>> +++ b/kernel/bpf/Kconfig
>> @@ -54,6 +54,7 @@ config BPF_JIT
>>   config BPF_JIT_ALWAYS_ON
>>       bool "Permanently enable BPF JIT and remove BPF interpreter"
>>       depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT
>> +    select BPF_JIT_DEFAULT_ON
>
> Is the above needed if ...
>
>>       help
>>         Enables BPF JIT and removes BPF interpreter to avoid speculative
>>         execution of BPF instructions by the interpreter.
>> @@ -63,8 +64,16 @@ config BPF_JIT_ALWAYS_ON
>>         failure.
>>     config BPF_JIT_DEFAULT_ON
>> -    def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
>> -    depends on HAVE_EBPF_JIT && BPF_JIT
>> +    bool "Enable BPF JIT by default"
>> +    default y if ARCH_WANT_DEFAULT_BPF_JIT
>
> ... we retain the prior `default y if ARCH_WANT_DEFAULT_BPF_JIT ||
> BPF_JIT_ALWAYS_ON` ?

After add

   bool "Enable BPF JIT by default"

if use

   default y if ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON

under !ARCH_WANT_DEFAULT_BPF_JIT, when enable CONFIG_BPF_JIT_ALWAYS_ON
manually through make menuconfig, CONFIG_BPF_JIT_DEFAULT_ON is not set
automatically, it seems not reasonable, but I do not know the reason,
maybe this is because CONFIG_BPF_JIT_ALWAYS_ON is user selectable rather
than selected via Kconfig only (like ARCH_WANT_DEFAULT_BPF_JIT), so here
let BPF_JIT_ALWAYS_ON select BPF_JIT_DEFAULT_ON.

>
>> +    depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT
>
> Why is the extra BPF_SYSCALL dependency needed? You could still have
> this for cBPF->eBPF
> translations when BPF syscall is compiled out (e.g. seccomp, sock/packet
> filters, etc).

Sorry, just copy-paste from "config BPF_JIT_ALWAYS_ON".

If BPF_SYSCALL dependency is not needed by BPF_JIT_DEFAULT_ON,
should we remove BPF_SYSCALL dependency in "config BPF_JIT_ALWAYS_ON"?

Thanks,
Tiezhu

>
>> +    help
>> +      Enables BPF JIT by default to avoid speculative execution of BPF
>> +      instructions by the interpreter.
>> +
>> +      When CONFIG_BPF_JIT_DEFAULT_ON is enabled but
>> CONFIG_BPF_JIT_ALWAYS_ON
>> +      is disabled, /proc/sys/net/core/bpf_jit_enable is set to 1 by
>> default
>> +      and can be changed to 0 or 2.
>>     config BPF_UNPRIV_DEFAULT_OFF
>>       bool "Disable unprivileged BPF by default"
>>

