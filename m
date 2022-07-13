Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302F9573CE1
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 21:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236869AbiGMTD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 15:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiGMTDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 15:03:55 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BE211142
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 12:03:53 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o19-20020a05600c511300b003a2de48b4bbso1748968wms.5
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 12:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GgWRzuR7K/JM+T/DhfougYNCN+Ei/e3TSwLryof3+SU=;
        b=xjmR4PktYkcZtxmm4Bxud6e1aFZ3icNzqrxGwpsyvSP+iki6V1kc7Rk+QMVAugghKs
         iy7l2DXORV/J357l07me+d7VqA7/HL2x2vHWNoMi+5mYTt8WGp4FQPtVI+2pqF64cTtA
         72/E72qCLviSjQ3n7SaazKsHHso9wazLcrSWjeyWZaRt+N37dRw0W8REriGXdGCbv3GZ
         eDpk4Xk1iWRO/CyvBhTcSUzYtR0k1b+8SROjZcAnrCcKt+iODYoqNFmQeZA9KLa87osf
         jrKVnFZ29iOIttvTcm0VWLFjGFE28pZR09hVfbbVPeOexxxSpfWMMiby4vFEeVmqVSTd
         teQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GgWRzuR7K/JM+T/DhfougYNCN+Ei/e3TSwLryof3+SU=;
        b=o+GNTUdt7v8JPbtIOZtVrM6zhOKiUL6VODBg05A3dJWchx27cdGPcbsiZfXCVkO65p
         pMAwcPeDFLj/gpwNGMNqb3Divm1MU4yN8TXqougxPnBvME4hP7KxacTq+hRM/vkSYNWU
         6Ce1KGyzVqMJT1WY762tHKNOmpLfh7HfSpo/hsep+n023kkWfPiubGPjiOROu3mj3zGW
         7GeB4qkdhSi2gcvB31u9MjPzypFKqMf3yIXCynRnb/1HEdrSGId1TiQsaDZa6VaHTLwG
         /bPW2GFdV07Hl+w7IZOickk4hi4zPuop9F5tVSAQnYf2cYUTQydmFduRY80/wZgGvqTe
         nkxw==
X-Gm-Message-State: AJIora+E7oH6J9VrcdTg4z8Gwe6R8psdIrbLFY6h6nTxuSRc/ozRDwjs
        ztcuouBxceiykPNxz4spbqJ1fw==
X-Google-Smtp-Source: AGRyM1v6OHDPNsuQGBaw1nVibAaCboV5t8oVecRp/qoC5aWo4oFLZyMC2kuFeNcml66hBnqpZnsTqQ==
X-Received: by 2002:a05:600c:4f11:b0:3a1:8631:b6b4 with SMTP id l17-20020a05600c4f1100b003a18631b6b4mr4988643wmq.94.1657739031768;
        Wed, 13 Jul 2022 12:03:51 -0700 (PDT)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id p2-20020a1c7402000000b003a2fdde48d1sm1768396wmc.25.2022.07.13.12.03.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 12:03:51 -0700 (PDT)
Message-ID: <40315ef2-e2e0-cb2b-becc-e1ba5a4826ff@isovalent.com>
Date:   Wed, 13 Jul 2022 20:03:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH bpf-next 3/3] bpf: iterators: build and use lightweight
 bootstrap version of bpftool
Content-Language: en-GB
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Pu Lehui <pulehui@huawei.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20220712030813.865410-1-pulehui@huawei.com>
 <20220712030813.865410-4-pulehui@huawei.com>
 <CAEf4Bza15HfVKDrA8dV+U5GJiDcPS0bnV81rmdxuFn0+_2hrXw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <CAEf4Bza15HfVKDrA8dV+U5GJiDcPS0bnV81rmdxuFn0+_2hrXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/07/2022 19:55, Andrii Nakryiko wrote:
> On Mon, Jul 11, 2022 at 7:37 PM Pu Lehui <pulehui@huawei.com> wrote:
>>
>> kernel/bpf/preload/iterators use bpftool for vmlinux.h, skeleton, and
>> static linking only. So we can use lightweight bootstrap version of
>> bpftool to handle these, and it will be faster.
>>
>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
>> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
>> ---
>>  kernel/bpf/preload/iterators/Makefile | 13 +++++++++----
>>  1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/bpf/preload/iterators/Makefile b/kernel/bpf/preload/iterators/Makefile
>> index bfe24f8c5a20..cf5f39f95fed 100644
>> --- a/kernel/bpf/preload/iterators/Makefile
>> +++ b/kernel/bpf/preload/iterators/Makefile
>> @@ -9,7 +9,7 @@ LLVM_STRIP ?= llvm-strip
>>  TOOLS_PATH := $(abspath ../../../../tools)
>>  BPFTOOL_SRC := $(TOOLS_PATH)/bpf/bpftool
>>  BPFTOOL_OUTPUT := $(abs_out)/bpftool
>> -DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
>> +DEFAULT_BPFTOOL := $(BPFTOOL_OUTPUT)/bootstrap/bpftool
>>  BPFTOOL ?= $(DEFAULT_BPFTOOL)
>>
>>  LIBBPF_SRC := $(TOOLS_PATH)/lib/bpf
>> @@ -61,9 +61,14 @@ $(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OU
>>                     OUTPUT=$(abspath $(dir $@))/ prefix=                       \
>>                     DESTDIR=$(LIBBPF_DESTDIR) $(abspath $@) install_headers
>>
>> +ifeq ($(CROSS_COMPILE),)
>>  $(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BPFTOOL_OUTPUT)
>>         $(Q)$(MAKE) $(submake_extras) -C $(BPFTOOL_SRC)                        \
>>                     OUTPUT=$(BPFTOOL_OUTPUT)/                                  \
>> -                   LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/                            \
>> -                   LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/                          \
>> -                   prefix= DESTDIR=$(abs_out)/ install-bin
>> +                   LIBBPF_BOOTSTRAP_OUTPUT=$(LIBBPF_OUTPUT)/                  \
>> +                   LIBBPF_BOOTSTRAP_DESTDIR=$(LIBBPF_DESTDIR)/ bootstrap
>> +else
>> +$(DEFAULT_BPFTOOL): | $(BPFTOOL_OUTPUT)
>> +       $(Q)$(MAKE) $(submake_extras) -C $(BPFTOOL_SRC)                        \
>> +                   OUTPUT=$(BPFTOOL_OUTPUT)/ bootstrap
>> +endif
> 
> another idea (related to my two previous comments for this patch set),
> maybe we can teach bpftool's Makefile to reuse LIBBPF_OUTPUT as
> LIBBPF_BOOTSTRAP_OUTPUT, if there is no CROSS_COMPILE? Then we can
> keep iterators/Makefile, samples/bpf/Makefile and runqslower/Makefile
> simpler and ignorant of CROSS_COMPILE, but still get the benefit of
> not rebuilding libbpf unnecessarily in non-cross-compile mode?

Could be a good idea. Seeing how the HID BPF patches add BTF/skeletons
generation at new locations, I'm also starting to wonder if it would be
worth having a Makefile.bpftool.include of some sort to harmonise the
way we compile the bootstrap bpftool as a dependency, and make it easier
to maintain. I haven't looked at how feasible that would be, yet.

