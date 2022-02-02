Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A284A7865
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 19:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346790AbiBBS7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 13:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237323AbiBBS7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 13:59:08 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58263C06173B
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 10:59:08 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id d10so371976eje.10
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 10:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fmxlVuvvX82+AWFikAmMOP/6PnRDyKdhHTlNXejlqmc=;
        b=bLW5jctB1WXmvWwfeTK7e+TjSDxh8IhBvXpAOnxMjT6A31YwePZa1KskaOi3J0Ryly
         1m4YZrBBe1vLCwQa2IHhqy8D9O124VIU9v4Y46KiWpM7cUZhJswx1pblPbXcw7xPNLV6
         dcxaBvvPoRy2T3UbqJLZ9mfnEyFHtnvSyjxSd5HzyqElJV4jlG/ifBehQCzOfKQNn1OF
         DX0mBUn+eAuatIzL85pX2qz4fov1iX1UDZDwBqlRDmfjYo91rCYwcOayGBpnEt77vOka
         IkcJKAVZo5ggsjsLJkdbNNVvtpnXhDL0fq0IlJtUbRDd27u4h+qzwb/2J6ZGfLkGpTFk
         nCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fmxlVuvvX82+AWFikAmMOP/6PnRDyKdhHTlNXejlqmc=;
        b=xgbpssv5H7fM6jimznnM/vvG+eUQQKJKAR3Mkkp4zbdvLuP2U0rWx+6dd3O/iwSmSo
         WL2/FbhmbXCHxYBUgvBdbWAbPhy9f7yi+AeuC8ni24DloWfj8HUpbwz9ZUFWFUDwvDcC
         d0Aq/1pjGC9U3qa3HORu1Ph8Mxgy+AqaIAw6eYFpZxVsWLFfJYox0MAj5M6hkho5v6cF
         bH1NrHaT2kgaTioda2eczX06UeAKJcFMxmhBg83HOJdi4o9BrLorZV9Fc8opD6jbXayo
         85KcePlxPnerwT8CHa2VLNuwr6Ud9GQ+dJ8hsxjfBL49LK0Xs1nRvuk5o9EamlcOEGH3
         TQaA==
X-Gm-Message-State: AOAM531GX7J+c4jFwdJqkMjsYPDb5XaPWwIdwh1J85fY+w1K4AH3cy1E
        4sAp6fjAoDJHnLbrqV4w7cHVrg==
X-Google-Smtp-Source: ABdhPJztKQ/wD+siTiOphi8M1m//v7Oq1xMqRbzdFNvD8uSmpDtTOE5rwUAh2nc5Hby6viXCMsF1jA==
X-Received: by 2002:a17:906:3f8e:: with SMTP id b14mr27720906ejj.463.1643828346857;
        Wed, 02 Feb 2022 10:59:06 -0800 (PST)
Received: from [192.168.1.8] ([149.86.76.131])
        by smtp.gmail.com with ESMTPSA id q6sm16112877ejx.113.2022.02.02.10.59.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 10:59:06 -0800 (PST)
Message-ID: <84ae0d13-6f40-b6d5-5a4d-bfe8e198a33a@isovalent.com>
Date:   Wed, 2 Feb 2022 18:59:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next 3/3] bpftool: Update versioning scheme
Content-Language: en-GB
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20220131211136.71010-1-quentin@isovalent.com>
 <20220131211136.71010-4-quentin@isovalent.com>
 <CAEf4BzbB3PDGTXuCou7cSbWHpKiTzZWA52UFTxzM1=Z1o4+Qjw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <CAEf4BzbB3PDGTXuCou7cSbWHpKiTzZWA52UFTxzM1=Z1o4+Qjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-02-01 22:59 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Mon, Jan 31, 2022 at 1:11 PM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> Since the notion of versions was introduced for bpftool, it has been
>> following the version number of the kernel (using the version number
>> corresponding to the tree in which bpftool's sources are located). The
>> rationale was that bpftool's features are loosely tied to BPF features
>> in the kernel, and that we could defer versioning to the kernel
>> repository itself.
>>
>> But this versioning scheme is confusing today, because a bpftool binary
>> should be able to work with both older and newer kernels, even if some
>> of its recent features won't be available on older systems. Furthermore,
>> if bpftool is ported to other systems in the future, keeping a
>> Linux-based version number is not a good option.
>>
>> It would make more sense to align bpftool's number on libbpf, maybe.
>> When versioning was introduced in bpftool, libbpf was in its initial
>> phase at v0.0.1. Now it moves faster, with regular version bumps. But
>> there are two issues if we want to pick the same numbers. First, that
>> would mean going backward on the numbering, and will be a huge pain for
>> every script trying to determine which bpftool binary is the most
>> recent (not to mention some possible overlap of the numbers in a distant
>> future). Then, bpftool could get new features or bug fixes between two
>> versions libbpf, so maybe we should not completely tie its versions to
>> libbpf, either.
>>
>> Therefore, this commit introduces an independent versioning scheme for
>> bpftool. The new version is v6.0.0, with its major number incremented
>> over the current 5.16.* returned from the kernel's Makefile. The plan is
>> to update this new number from time to time when bpftool gets new
>> features or new bug fixes. These updates could possibly lead to new
>> releases being tagged on the recently created out-of-tree mirror, at
>> https://github.com/libbpf/bpftool.
>>
>> Version number is moved higher in the Makefile, to make it more visible.
>>
>> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
>>  tools/bpf/bpftool/Makefile | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
>> index bd5a8cafac49..b7dbdea112d3 100644
>> --- a/tools/bpf/bpftool/Makefile
>> +++ b/tools/bpf/bpftool/Makefile
>> @@ -1,6 +1,8 @@
>>  # SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>  include ../../scripts/Makefile.include
>>
>> +BPFTOOL_VERSION := 6.0.0
>> +
> 
> It's going to be a PITA to not forget to update this :( As discussed,
> I'm fine with this, but I also recalled the versioning approach that
> libbpf-sys library is using (see [0]). Maybe we could steal some of
> those ideas. As in, base bpftool version on libbpf (with major version
> + 6 as you do here), but also have "-1", "-2", etc suffixes for
> bpftool releases for when libbpf version didn't change. Don't know,
> just throwing out the idea for your consideration.
> 
>   [0] https://github.com/libbpf/libbpf-sys#versioning

I've been somewhat torn between having a separate versioning scheme and
getting as much flexibility as we want, and aligning on libbpf and
having “automatic” version updates. My reasoning is the following.

If aligning on libbpf:

- We may want bpftool releases in-between two libbpf versions. Using
pre-release numbers for tagging them is a good idea, although I don't
know if something marked as a pre-release will look “official” enough
(users may not pick it, thinking it's a beta release?). On the other
hand, having bpftool with version numbers that look “official” haven't
really been an issue so far.

- If no new feature lands in bpftool for some time, we may move from
e.g. 6.7.0 to 6.8.0 when libbpf levels up and have two different
versions which are in fact the same.

- Following libbpf's versioning scheme sounds better than kernel's, but
ultimately it doesn't make too much sense either, because even though
bpftool uses the lib a lot, its behaviour is not that much conditioned
by the internal evolution of the library (or by new APIs that it may not
use).

Having an independent versioning scheme solves the above, but as you
say, it's gonna be painful to update the numbers. Developers will miss
it most of the time, and I'm not even exactly sure myself of when to tag
a new minor release. I suppose it would be a bit like for docs and
completion, with occasional “catch-up” patches to update the version
number - not great.

Based on all the above, I think your suggestion is good, and I'll switch
back to aligning on libbpf's version. It may not be perfect, but 1) it's
certainly an improvement over the current scheme, 2) the issues raised
above are minor at the moment, and 3) we can still move to an
independent scheme in the future if we realise we need it. Sounds more
important to save on the maintenance burden at the moment. I'll send a
new version shortly.

Thanks,
Quentin
