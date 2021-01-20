Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E66A2FC879
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389581AbhATDIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:08:21 -0500
Received: from mail.loongson.cn ([114.242.206.163]:35756 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387889AbhATDHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 22:07:49 -0500
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9AxZbxBngdgg+gHAA--.9869S3;
        Wed, 20 Jan 2021 11:06:42 +0800 (CST)
Subject: Re: [PATCH bpf-next v2] samples/bpf: Update README.rst and Makefile
 for manually compiling LLVM and clang
To:     Nick Desaulniers <ndesaulniers@google.com>
References: <1611042978-21473-1-git-send-email-yangtiezhu@loongson.cn>
 <CAKwvOdkXGx-WogH0o5iuNnEe07sqRfxMpOg5fEEnTWcOfBrbAQ@mail.gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <198ec9cf-46cc-7ed4-ebc5-80c875033995@loongson.cn>
Date:   Wed, 20 Jan 2021 11:06:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAKwvOdkXGx-WogH0o5iuNnEe07sqRfxMpOg5fEEnTWcOfBrbAQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9AxZbxBngdgg+gHAA--.9869S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWw1DtFWkKr13Wry8KryfZwb_yoWrurWUpF
        W7tayS9rZ2qry3ZFyxGr4jqr4fX398Xa4UCa4xGr18Z3ZIyr1kGF43t3yxWFWUWr92yF43
        Cr1rKFZ8WF18X3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F
        4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkIecxEwVAFwVW8GwCF04k20xvY0x0EwI
        xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
        6cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
        CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU-miiUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/20/2021 10:43 AM, Nick Desaulniers wrote:
> On Mon, Jan 18, 2021 at 11:56 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>> The current llvm/clang build procedure in samples/bpf/README.rst is
>> out of date. See below that the links are not accessible any more.
>>
>> $ git clone http://llvm.org/git/llvm.git
>> Cloning into 'llvm'...
>> fatal: unable to access 'http://llvm.org/git/llvm.git/': Maximum (20) redirects followed
>> $ git clone --depth 1 http://llvm.org/git/clang.git
>> Cloning into 'clang'...
>> fatal: unable to access 'http://llvm.org/git/clang.git/': Maximum (20) redirects followed
>>
>> The llvm community has adopted new ways to build the compiler. There are
>> different ways to build llvm/clang, the Clang Getting Started page [1] has
>> one way. As Yonghong said, it is better to just copy the build procedure
>> in Documentation/bpf/bpf_devel_QA.rst to keep consistent.
>>
>> I verified the procedure and it is proved to be feasible, so we should
>> update README.rst to reflect the reality. At the same time, update the
>> related comment in Makefile.
>>
>> [1] https://clang.llvm.org/get_started.html
> There's also https://www.kernel.org/doc/html/latest/kbuild/llvm.html#getting-llvm
> (could cross link in rst/sphinx).
>
>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>> Acked-by: Yonghong Song <yhs@fb.com>
>> ---
>>
>> v2: Update the commit message suggested by Yonghong,
>>      thank you very much.
>>
>>   samples/bpf/Makefile   |  2 +-
>>   samples/bpf/README.rst | 17 ++++++++++-------
>>   2 files changed, 11 insertions(+), 8 deletions(-)
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index 26fc96c..d061446 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -208,7 +208,7 @@ TPROGLDLIBS_xdpsock         += -pthread -lcap
>>   TPROGLDLIBS_xsk_fwd            += -pthread
>>
>>   # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
>> -#  make M=samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
>> +# make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
>>   LLC ?= llc
>>   CLANG ?= clang
>>   OPT ?= opt
>> diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
>> index dd34b2d..d1be438 100644
>> --- a/samples/bpf/README.rst
>> +++ b/samples/bpf/README.rst
>> @@ -65,17 +65,20 @@ To generate a smaller llc binary one can use::
>>   Quick sniplet for manually compiling LLVM and clang
>>   (build dependencies are cmake and gcc-c++)::
>>
>> - $ git clone http://llvm.org/git/llvm.git
>> - $ cd llvm/tools
>> - $ git clone --depth 1 http://llvm.org/git/clang.git
>> - $ cd ..; mkdir build; cd build
>> - $ cmake .. -DLLVM_TARGETS_TO_BUILD="BPF;X86"
> Is the BPF target not yet on by default?

The default value includes BPF.

>   I frown upon disabling other backends.

I think the initial aim of the build procedure in samples/bpf/README.rst [1]
is a simple and quick start guide:

[ To generate a smaller llc binary one can use:

  -DLLVM_TARGETS_TO_BUILD="BPF" ]

[1] https://github.com/torvalds/linux/blob/master/samples/bpf/README.rst

>
>> - $ make -j $(getconf _NPROCESSORS_ONLN)
>> + $ git clone https://github.com/llvm/llvm-project.git
>> + $ mkdir -p llvm-project/llvm/build/install
>> + $ cd llvm-project/llvm/build
>> + $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
>> +            -DLLVM_ENABLE_PROJECTS="clang"    \
>> +            -DBUILD_SHARED_LIBS=OFF           \
>> +            -DCMAKE_BUILD_TYPE=Release        \
>> +            -DLLVM_BUILD_RUNTIME=OFF
>> + $ ninja
>>
>>   It is also possible to point make to the newly compiled 'llc' or
>>   'clang' command via redefining LLC or CLANG on the make command line::
>>
>> - make M=samples/bpf LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
>> + make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
>>
>>   Cross compiling samples
>>   -----------------------
>> --
>> 2.1.0
>>
>> --
>> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/1611042978-21473-1-git-send-email-yangtiezhu%40loongson.cn.
>
>

