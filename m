Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550C72FC815
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 03:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbhATCe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:34:26 -0500
Received: from mail.loongson.cn ([114.242.206.163]:55628 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730297AbhATCdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 21:33:12 -0500
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx6L0ulgdgxeQHAA--.12601S3;
        Wed, 20 Jan 2021 10:32:15 +0800 (CST)
Subject: Re: [PATCH bpf-next v2] samples/bpf: Update README.rst and Makefile
 for manually compiling LLVM and clang
To:     Fangrui Song <maskray@google.com>
References: <1611042978-21473-1-git-send-email-yangtiezhu@loongson.cn>
 <20210119215815.efyerbwwq5x2o26q@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <b526e0eb-f05f-1c3a-de8f-3d7e9bef73ee@loongson.cn>
Date:   Wed, 20 Jan 2021 10:32:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20210119215815.efyerbwwq5x2o26q@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9Dx6L0ulgdgxeQHAA--.12601S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKrWfuFyUtr4rKFW5Zr1DJrb_yoW7Gw4Upr
        W7ta1SkrZ2qryfZFyxGw4UXw4rZ395Ja4UCa4xGryrZ3WDZrn7GF4ayrWfWFWUXr92yF47
        Ar1rGa4DGF18Xa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F
        4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkIecxEwVAFwVW8JwCF04k20xvY0x0EwI
        xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
        6cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXo7tUUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/20/2021 05:58 AM, Fangrui Song wrote:
> On 2021-01-19, Tiezhu Yang wrote:
>> The current llvm/clang build procedure in samples/bpf/README.rst is
>> out of date. See below that the links are not accessible any more.
>>
>> $ git clone http://llvm.org/git/llvm.git
>> Cloning into 'llvm'...
>> fatal: unable to access 'http://llvm.org/git/llvm.git/': Maximum (20) 
>> redirects followed
>> $ git clone --depth 1 http://llvm.org/git/clang.git
>> Cloning into 'clang'...
>> fatal: unable to access 'http://llvm.org/git/clang.git/': Maximum 
>> (20) redirects followed
>>
>> The llvm community has adopted new ways to build the compiler. There are
>> different ways to build llvm/clang, the Clang Getting Started page 
>> [1] has
>> one way. As Yonghong said, it is better to just copy the build procedure
>> in Documentation/bpf/bpf_devel_QA.rst to keep consistent.
>>
>> I verified the procedure and it is proved to be feasible, so we should
>> update README.rst to reflect the reality. At the same time, update the
>> related comment in Makefile.
>>
>> [1] https://clang.llvm.org/get_started.html
>>
>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>> Acked-by: Yonghong Song <yhs@fb.com>
>> ---
>>
>> v2: Update the commit message suggested by Yonghong,
>>    thank you very much.
>>
>> samples/bpf/Makefile   |  2 +-
>> samples/bpf/README.rst | 17 ++++++++++-------
>> 2 files changed, 11 insertions(+), 8 deletions(-)
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index 26fc96c..d061446 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -208,7 +208,7 @@ TPROGLDLIBS_xdpsock        += -pthread -lcap
>> TPROGLDLIBS_xsk_fwd        += -pthread
>>
>> # Allows pointing LLC/CLANG to a LLVM backend with bpf support, 
>> redefine on cmdline:
>> -#  make M=samples/bpf/ LLC=~/git/llvm/build/bin/llc 
>> CLANG=~/git/llvm/build/bin/clang
>> +# make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc 
>> CLANG=~/git/llvm-project/llvm/build/bin/clang
>> LLC ?= llc
>> CLANG ?= clang
>> OPT ?= opt
>> diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
>> index dd34b2d..d1be438 100644
>> --- a/samples/bpf/README.rst
>> +++ b/samples/bpf/README.rst
>> @@ -65,17 +65,20 @@ To generate a smaller llc binary one can use::
>> Quick sniplet for manually compiling LLVM and clang
>> (build dependencies are cmake and gcc-c++)::
>>
>> - $ git clone http://llvm.org/git/llvm.git
>> - $ cd llvm/tools
>> - $ git clone --depth 1 http://llvm.org/git/clang.git
>> - $ cd ..; mkdir build; cd build
>> - $ cmake .. -DLLVM_TARGETS_TO_BUILD="BPF;X86"
>> - $ make -j $(getconf _NPROCESSORS_ONLN)
>> + $ git clone https://github.com/llvm/llvm-project.git
>> + $ mkdir -p llvm-project/llvm/build/install
>
> llvm-project/llvm/build/install is not used.

Yes, just mkdir -p llvm-project/llvm/build is OK.

>
>> + $ cd llvm-project/llvm/build
>> + $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
>> +            -DLLVM_ENABLE_PROJECTS="clang"    \
>> +            -DBUILD_SHARED_LIBS=OFF           \
>
> -DBUILD_SHARED_LIBS=OFF is the default. It can be omitted.

I search the related doc [1] [2], remove this option is OK for me.

BUILD_SHARED_LIBS:BOOL

     Flag indicating if each LLVM component (e.g. Support) is built as a 
shared library (ON) or as a static library (OFF). Its default value is OFF.

[1] https://www.llvm.org/docs/CMake.html
[2] https://cmake.org/cmake/help/latest/variable/BUILD_SHARED_LIBS.html

>
>> + -DCMAKE_BUILD_TYPE=Release        \
>> +            -DLLVM_BUILD_RUNTIME=OFF
>
> -DLLVM_BUILD_RUNTIME=OFF can be omitted if none of
> compiler-rt/libc++/libc++abi is built.

I am not very sure about it because the default value of
LLVM_BUILD_RUNTIME is ON? [3]

option(LLVM_BUILD_RUNTIME
"Build the LLVM runtime libraries." ON)

[3] https://github.com/llvm/llvm-project/blob/main/llvm/CMakeLists.txt

If anyone has any more suggestions, please let me know.
I will send v3 after waiting for other feedback.

By the way, Documentation/bpf/bpf_devel_QA.rst maybe need a separate
patch to remove some cmake options?

Thanks,
Tiezhu

>
>> + $ ninja
>>
>> It is also possible to point make to the newly compiled 'llc' or
>> 'clang' command via redefining LLC or CLANG on the make command line::
>>
>> - make M=samples/bpf LLC=~/git/llvm/build/bin/llc 
>> CLANG=~/git/llvm/build/bin/clang
>> + make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc 
>> CLANG=~/git/llvm-project/llvm/build/bin/clang
>>
>> Cross compiling samples
>> -----------------------
>> -- 
>> 2.1.0
>>
>> -- 
>> You received this message because you are subscribed to the Google 
>> Groups "Clang Built Linux" group.
>> To unsubscribe from this group and stop receiving emails from it, 
>> send an email to clang-built-linux+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit 
>> https://groups.google.com/d/msgid/clang-built-linux/1611042978-21473-1-git-send-email-yangtiezhu%40loongson.cn.

