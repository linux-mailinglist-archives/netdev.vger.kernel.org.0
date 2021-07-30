Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF353DBC2E
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 17:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbhG3PXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 11:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239548AbhG3PXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 11:23:45 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C24BC06175F
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 08:23:40 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id p5so11775863wro.7
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 08:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qLTkkTRB2m48PRQOb2OOE1hRgVUYtcA1Azw+6tyaSXM=;
        b=L4L9kkf+SR8I2+qs3p4ZofgT/seTAn0qTCatL2rO/Skw4uavLeo1UBGm9LhoVuPsIN
         HcrkgBZ3EBLM68Ada/vHxuJcrF5JlCJyT/q0JEEAegHOz2oV/6Nq1mH72koRVbtMx674
         Tj+aUeG/HQMmWAUU3xbDEP/B4lRtkNVNnZp//k5iLA7Ef3ionQwrXm+ENCTqQmQl4cnj
         N+OcyfLf+QN7RAPWIBMWmjHzCqpyJup+eZ5Tf+V8R2ggbzs97J9ist/+gvmDQFj8ZobQ
         i1bRCiPsL0CldshxMPfZR/8Wq3yc114qVUfE0q3kkdJEQ51uIcIP/f74wjwFwkehiKhU
         fP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qLTkkTRB2m48PRQOb2OOE1hRgVUYtcA1Azw+6tyaSXM=;
        b=U/89UfBKJY2o/GuM33SznyEQ/mNmIlknXDIsRaOVa/e4RKSqtBLMocBJRXsgDl/zBx
         s6Dk0WUUcxdIYkyMhpi+W+Ab+JWIEPTQYiMtixA/rskBfbnfuG1LKah2COvONkVzk4ud
         Ir+ZGoOT3BzFZgYkx7TfRtYIOP2nVPU9yx73QWXrUzO2c4a1FxyNTzIX3kgIOQYfbSbq
         mC+8HUH1MZ1JXUoO1Un/jtMUICcHv6RG+wHeFRAhl+sDEQXhxYlEB++Q5BqcU6EkIL5A
         kuTVk43UTjBWfqvcCYDUiwLbbStN01Y+vII/NFhnvwLvJ+DjVqtRgRg8dR0WPjDoPpLH
         kXZA==
X-Gm-Message-State: AOAM533v6/4Qi/Wd770PZorhrFH0npZYs6ljmDv/iYOZZnLs2cxIlXsj
        zlC6ZuWwpNAtIpmqZK78AhNP3A==
X-Google-Smtp-Source: ABdhPJxMT9BQIUR4rxWH8Jy4wW+mYCv9ziecA5dPlT2e0mUE02XzmYriGdxOIDTlb+OOnJU9q+7npA==
X-Received: by 2002:a05:6000:11c8:: with SMTP id i8mr3713658wrx.300.1627658619042;
        Fri, 30 Jul 2021 08:23:39 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.68.125])
        by smtp.gmail.com with ESMTPSA id l3sm1621664wmq.2.2021.07.30.08.23.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 08:23:38 -0700 (PDT)
Subject: Re: [PATCH bpf-next v3 0/8] libbpf: rename btf__get_from_id() and
 btf__load() APIs, support split BTF
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20210729162028.29512-1-quentin@isovalent.com>
 <CAEf4BzbrQOr8Z2oiywT-zPBEz9jbP9_6oJXOW28LdOaqAy8pLw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <22d59def-51e7-2b98-61b6-b700e7de8ef6@isovalent.com>
Date:   Fri, 30 Jul 2021 16:23:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbrQOr8Z2oiywT-zPBEz9jbP9_6oJXOW28LdOaqAy8pLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-07-29 17:31 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Thu, Jul 29, 2021 at 9:20 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> As part of the effort to move towards a v1.0 for libbpf [0], this set
>> improves some confusing function names related to BTF loading from and to
>> the kernel:
>>
>> - btf__load() becomes btf__load_into_kernel().
>> - btf__get_from_id becomes btf__load_from_kernel_by_id().
>> - A new version btf__load_from_kernel_by_id_split() extends the former to
>>   add support for split BTF.
>>
>> The old functions are marked for deprecation for the next minor version
>> (0.6) of libbpf.
>>
>> The last patch is a trivial change to bpftool to add support for dumping
>> split BTF objects by referencing them by their id (and not only by their
>> BTF path).
>>
>> [0] https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
>>
>> v3:
>> - Use libbpf_err_ptr() in btf__load_from_kernel_by_id(), ERR_PTR() in
>>   bpftool's get_map_kv_btf().
>> - Move the definition of btf__load_from_kernel_by_id() closer to the
>>   btf__parse() group in btf.h (move the legacy function with it).
>> - Fix a bug on the return value in libbpf_find_prog_btf_id(), as a new
>>   patch.
>> - Move the btf__free() fixes to their own patch.
>> - Add "Fixes:" tags to relevant patches.
>> - Re-introduce deprecation (removed in v2) for the legacy functions, as a
>>   new macro LIBBPF_DEPRECATED_SINCE(major, minor, message).
>>
>> v2:
>> - Remove deprecation marking of legacy functions (patch 4/6 from v1).
>> - Make btf__load_from_kernel_by_id{,_split}() return the btf struct, adjust
>>   surrounding code and call btf__free() when missing.
>> - Add new functions to v0.5.0 API (and not v0.6.0).
>>
>> Quentin Monnet (8):
>>   libbpf: return non-null error on failures in libbpf_find_prog_btf_id()
>>   libbpf: rename btf__load() as btf__load_into_kernel()
>>   libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
>>   tools: free BTF objects at various locations
>>   tools: replace btf__get_from_id() with btf__load_from_kernel_by_id()
>>   libbpf: prepare deprecation of btf__get_from_id(), btf__load()
>>   libbpf: add split BTF support for btf__load_from_kernel_by_id()
>>   tools: bpftool: support dumping split BTF by id
>>
>>  tools/bpf/bpftool/btf.c                      |  8 ++---
>>  tools/bpf/bpftool/btf_dumper.c               |  6 ++--
>>  tools/bpf/bpftool/map.c                      | 14 ++++-----
>>  tools/bpf/bpftool/prog.c                     | 29 +++++++++++------
>>  tools/lib/bpf/Makefile                       |  3 ++
>>  tools/lib/bpf/btf.c                          | 33 ++++++++++++++------
>>  tools/lib/bpf/btf.h                          |  7 ++++-
>>  tools/lib/bpf/libbpf.c                       | 11 ++++---
>>  tools/lib/bpf/libbpf.map                     |  3 ++
>>  tools/lib/bpf/libbpf_common.h                | 19 +++++++++++
>>  tools/perf/util/bpf-event.c                  | 11 ++++---
>>  tools/perf/util/bpf_counter.c                | 12 +++++--
>>  tools/testing/selftests/bpf/prog_tests/btf.c |  4 ++-
>>  13 files changed, 113 insertions(+), 47 deletions(-)
>>
>> --
>> 2.30.2
>>
> 
> I dropped patch #7 with deprecations and LIBBPF_DEPRECATED_SINCE and
> applied to bpf-next.
> 
> Current LIBBPF_DEPRECATED_SINCE approach doesn't work (and you should
> have caught this when you built selftests/bpf, what happened there?).
> bpftool build generates warnings like this:
> 
> In file included from /data/users/andriin/linux/tools/lib/bpf/libbpf.h:20,
>                  from xlated_dumper.c:10:
> /data/users/andriin/linux/tools/lib/bpf/libbpf_common.h:22:23:
> warning: "LIBBPF_MAJOR_VERSION" is not defined, evaluates to 0
> [-Wundef]
>   __LIBBPF_GET_VERSION(LIBBPF_MAJOR_VERSION, LIBBPF_MINOR_VERSION)
>                        ^~~~~~~~~~~~~~~~~~~~

Apologies, I didn't realise the change would impact external applications.

> 
> And it makes total sense. LIBBPF_DEPRECATED_SINCE() assumes
> LIBBPF_MAJOR_VERSION/LIBBPF_MINOR_VERSION is defined at compilation
> time of the *application that is using libbpf*, not just libbpf's
> compilation time. And that's clearly a bogus assumption which we can't
> and shouldn't make. The right approach will be to define
> LIBBPF_MAJOR_VERSION/LIBBPF_MINOR_VERSION in some sort of
> auto-generated header, included from libbpf_common.h and installed as
> part of libbpf package.

So generating this header is easy. Installing it with the other headers
is simple too. It becomes a bit trickier when we build outside of the
directory (it seems I need to pass -I$(OUTPUT) to build libbpf).

The step I'm most struggling with at the moment is bpftool, which
bootstraps a first version of itself before building libbpf, by looking
at the headers directly in libbpf's directory. It means that the
generated header with the version number has not yet been generated. Do
you think it is worth changing bpftool's build steps to implement this
deprecation helper?

Alternatively, wouldn't it make more sense to have a script in the
GitHub repo for libbpf, and to run it once during the release process of
a new version to update, say, the version number, or even the
deprecation status directly?

> 
> Anyways, I've removed all the LIBBPF_DEPRECATED_SINCE stuff and
> applied all the rest, as it looks good and is a useful addition.

Thanks.
Quentin
