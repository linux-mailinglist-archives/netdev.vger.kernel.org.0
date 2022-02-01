Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347FD4A66B8
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242619AbiBAU6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiBAU6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:58:14 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CB5C06173B
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 12:58:13 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id e8so34465389wrc.0
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 12:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=C49wCojYAS3Ebs8u9s/X+axpoCCr/uqbgoeZa98MJ40=;
        b=6+pfREGhv7WY5YtI1+dkpam+P4EjjYfjkqHpkMQE9CXWDAhGki4ye9Qv15beUEqgwc
         UYLE5me6aRk3toi7F1ULnpS/HDDDdJxD1v8v8VLPtrijaGQK4myarJ92hNid9BFnSPRK
         /R7Xja9aQUxcy3yy/3+ejvTX/85OyFbv72mWZuK48yFIHsq47eQHb3QYhwjC2J5A562g
         jibVKDFAFCqLrV3FArQs09HuWCGJvbJk8R2lvQOqKYm16hWVM/NCEbCy9TLdKeZqQX3C
         kvDBvFVa/uZ8bldB1Z+kKEp2CQz49cIs6yM2r0hAwqdtDrxxu9MUGG++ot0F900blALF
         HMSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C49wCojYAS3Ebs8u9s/X+axpoCCr/uqbgoeZa98MJ40=;
        b=QkQ9s7D4V+W5GkKWcSXhJyonnXqnVWVs4IhoJt6pM2XPNqyawcnPyjc1rTJkZ8Jang
         Gk+VcpU7ICqdned8MDyc86tD0H81HF/IJKX8Ne+fdcSsbRTdtOnM1juyUx22FD5GJH9B
         Xw1oaD4IpzwHJTDFPICI/+tv8W4YsrSoBoiDOepp+ywM+VlssCxTYkHqftiC0s4Hg+Hn
         Bs4Z2LrnHU50Re8DHNBQvUhe4xnqo27qtWRZhWJ6oRc1FA/y9c82kCUq5/ZINzBJT73P
         w4qWT/G9MPdp/l2xBmS9motVTI4KRn57HcW6Q90YayFhJj2DK8DrOqWSb24AbRntwhWz
         LIRg==
X-Gm-Message-State: AOAM531nZ1Y3sWHp2kBR2lZhUamSartf6hTpmjaTrWGHkH1ZbzeJCt+r
        yhcKmR+XTSjUqKIMxzaH9XNPbQ==
X-Google-Smtp-Source: ABdhPJxlTdjGXHGgvUNDE3ZSC3eFoGGCgybgnH4UZbK7M5Xe3qEBqA72FVk9v1IZsiwuPoOYfdMwWQ==
X-Received: by 2002:adf:f045:: with SMTP id t5mr22252836wro.383.1643749091660;
        Tue, 01 Feb 2022 12:58:11 -0800 (PST)
Received: from [192.168.1.8] ([149.86.72.139])
        by smtp.gmail.com with ESMTPSA id o21sm2943021wmh.36.2022.02.01.12.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 12:58:10 -0800 (PST)
Message-ID: <30675965-71c5-e0e7-d3f3-8022bf41b764@isovalent.com>
Date:   Tue, 1 Feb 2022 20:58:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v5 9/9] selftest/bpf: Implement tests for bpftool
 gen min_core_btf
Content-Language: en-GB
To:     =?UTF-8?Q?Mauricio_V=c3=a1squez_Bernal?= <mauricio@kinvolk.io>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
References: <20220128223312.1253169-1-mauricio@kinvolk.io>
 <20220128223312.1253169-10-mauricio@kinvolk.io>
 <CAHap4zsWqpTezbzZn7TOWvFA4c2PbSum4vY1_9YB+XSfFor21g@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <CAHap4zsWqpTezbzZn7TOWvFA4c2PbSum4vY1_9YB+XSfFor21g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-01-28 18:23 UTC-0500 ~ Mauricio Vásquez Bernal <mauricio@kinvolk.io>
> On Fri, Jan 28, 2022 at 5:33 PM Mauricio Vásquez <mauricio@kinvolk.io> wrote:
>>
>> This commit implements some integration tests for "BTFGen". The goal
>> of such tests is to verify that the generated BTF file contains the
>> expected types.
>>
> 
> This is not an exhaustive list of test cases. I'm not sure if this is
> the approach we should follow to implement such tests, it seems to me
> that checking each generated BTF file by hand is a lot of work but I
> don't have other ideas to simplify it.
> 
> I considered different options to write these tests:
> 1. Use core_reloc_types.h to create a "source" BTF file with a lot of
> types, then run BTFGen for all test_core_reloc_*.o files and use the
> generated BTF file as btf_src_file in core_reloc.c. In other words,
> re-run all test_core_reloc tests using a generated BTF file as source
> instead of the "btf__core_reloc_" #name ".o" one. I think this test is
> great because it tests the full functionality and actually checks that
> the programs are able to run using the generated file. The problem is
> how do we test that the BTFGen is creating an optimized file? Just
> copying the source file without any modification will make all those
> tests pass. We could check that the generated file is small (by
> checking the size or the number of types) but it doesn't seem a very
> reliable approach to me.

To check that the resulting BTF is optimised, one idea maybe would be to
first produce such a minimal BTF file for the program (with a manual
check) and then to expand it with additional symbols that you know are
all unnecessary to the program. Then for the test you can run bpftool to
produce the minimal BTF again and can check if any of the definitions
known as superfluous are still present.

Another solution could be to attempt to load the BTF and program by
removing any of the info from the produced BTF file, and see if the
program still loads.

Not sure if any of those solutions is easy to implement, though.

> 2. We could write some .c files with the types we expect to have on
> the generated file and compare it with the generated file. The issue
> here is that comparing those BTF files doesn't seem to be too
> trivial...
> 
> Do you have any suggestions about it? Thanks!

I'm not familiar enough with BTF to have some great suggestion here,
maybe Andrii can help.

As a side note, it's already good to have some testing for the new
feature. The CI tests are pretty limited for bpftool at the moment and
we don't test much of it, so even basic tests to make sure that the
feature is not completely broken is a good start. Then the more we
cover, the safer we are of course :).

Thanks for this work!
Quentin
