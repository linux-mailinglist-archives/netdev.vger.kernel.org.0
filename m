Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D45C2F9D05
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 11:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389262AbhARKnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 05:43:32 -0500
Received: from mail.loongson.cn ([114.242.206.163]:46270 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388223AbhARJ1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 04:27:48 -0500
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxSL4PVAVguK4GAA--.10639S3;
        Mon, 18 Jan 2021 17:25:36 +0800 (CST)
Subject: Re: [PATCH 2/2] compiler.h: Include asm/rwonce.h under ARM64 and
 ALPHA to fix build errors
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
 <1610535453-2352-3-git-send-email-yangtiezhu@loongson.cn>
 <33050fcc-a4a0-af2e-6fba-dca248f5f23b@fb.com>
Cc:     linux-sparse@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        kernel test robot <lkp@intel.com>
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <5663510d-2aa5-c1f2-d0c8-5313cc2a4a18@loongson.cn>
Date:   Mon, 18 Jan 2021 17:25:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <33050fcc-a4a0-af2e-6fba-dca248f5f23b@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9DxSL4PVAVguK4GAA--.10639S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uw1rtF4UCF4xKw1xJr13Jwb_yoW8GFWxpF
        4DZr4kKrZ8Wry5JrsYvr12kr43A39xGrW5tF97W348Z3WIqFy7GanYgwn8CF4xWanIqFWI
        k3W2gry3Jw4jv37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUB014x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_GFWl42xK82IYc2Ij64vIr4
        1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
        67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
        8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
        wI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
        0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU83kuDUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/14/2021 01:14 AM, Yonghong Song wrote:
> I do not think this fix is correct. x86 does not define its own
> rwonce.h and still compiles fine.
>
> As noted in the above, we have include/asm-generic/rwonce.h.
> Once you do a proper build, you will have rwonce.h in arch
> generated directory like
>
> -bash-4.4$ find . -name rwonce.h
> ./include/asm-generic/rwonce.h
> ./arch/alpha/include/asm/rwonce.h
> ./arch/arm64/include/asm/rwonce.h
> ./arch/x86/include/generated/asm/rwonce.h
>
> for mips, it should generated in 
> arch/mips/include/generated/asm/rwonce.h. Please double check why this 
> does not happen.

Hi Yonghong,

Thank you very much for your reply.
You are right, this patch is meaningless.

I find this build error when make M=samples/bpf after make clean,
so the ./arch/mips/include/generated/asm/rwonce.h is not exist.

After rebuild the kernel, this header file can be found when make
M=samples/bpf due to samples/bpf/Makefile contains $LINUXINCLUDE.

$ find . -name rwonce.h
./include/asm-generic/rwonce.h
./arch/arm64/include/asm/rwonce.h
./arch/mips/include/generated/asm/rwonce.h
./arch/alpha/include/asm/rwonce.h
$ cat ./arch/mips/include/generated/asm/rwonce.h
#include <asm-generic/rwonce.h>


Hi Sergei and kernel test robot,

Thank you for your suggestion and report,
please ignore this patch, sorry for the noise.

Thanks,
Tiezhu

