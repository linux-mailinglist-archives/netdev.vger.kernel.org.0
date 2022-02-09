Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59BD4AFD1C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 20:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiBITQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 14:16:17 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiBITQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 14:16:17 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BC6C1DC709
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 11:16:11 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id d10so10054848eje.10
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 11:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2xBA9/2oXe3Pshrbg71gRiie+D/Fw+wOJCZE411LMoY=;
        b=gYmYYOFCWCraSrUBchVfEHF8/YxVQBNMoVUQimr0BfYwhB7Lr7hrFrM5jCwIja8rDU
         tegWd9Ueh9okTZpiHJfe8mpTKsONtJ5ZvVvnooZ/vil9ROC/b+Ee6KQEok5iS3F8DxX2
         g87aQ5kDrDOrGrZeBwmAc4XLeqjzdReBuoKc9GZcyxazgqhjToYbbIQLToBRUCCkECOT
         JepSXbdW53tA4CWsZ3e+Vvvg6jcM+adMyXkarPKE/BSUQ6SUZBD7ScKjc6gV8pKwWiIN
         wiO+61hlmfP+t99Vk/1JARzDn9C7OMdlkE1hEH+aBX2ndbfN9OO2gXuLZqtnPlDCa6GW
         HxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2xBA9/2oXe3Pshrbg71gRiie+D/Fw+wOJCZE411LMoY=;
        b=Fz5tO/zfxluL5s/c9hDWPLtFSEAQTbLt/1fLS7+uJVeNQQCtqWnxqzpT/xHeq3+K1q
         glygCvXgcljLu40q0gTsN1HDGfIFx1rjqRAteO06PNkaEJJsLOmlrAbayrtFESvbaxGl
         qFdDhhEWeFT558rMeCZzL9Z81OozexOByFxVgPUQrOibt3rDSZPE/V9L0klqOSKMDWrS
         YicCLrlFVzY/xYnETqnNW6nqhlvY+/lMriwOd9ig1hAkFnVI2hEgWKmy8i5qLrbL5dTp
         Pdh4aTmBB5qUC9DVArIEQsBWPJyLUvk1bvXkUVyS+1g75FivFrBlOq5aEBF3eTgZtyF+
         MoSA==
X-Gm-Message-State: AOAM530rVinOdZhO7+cOICr1zTImQVP1YhENgoxvA9ieKo1g91kzhnqG
        cEu7tHVqRlTI/JDgFjfQIDjVeg==
X-Google-Smtp-Source: ABdhPJyvYJHLlDeNgmZTjaFmKiEfiSJryJXrM6CcUyvJg/vEW3sE4VRkO9gB/hCfBv9AI3wHZMfygA==
X-Received: by 2002:a17:906:73d2:: with SMTP id n18mr3414033ejl.262.1644434110193;
        Wed, 09 Feb 2022 11:15:10 -0800 (PST)
Received: from [192.168.1.8] ([149.86.73.79])
        by smtp.gmail.com with ESMTPSA id gh24sm4762604ejb.76.2022.02.09.11.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 11:15:09 -0800 (PST)
Message-ID: <1d3d53c7-d3cc-cd76-220c-c7b250111229@isovalent.com>
Date:   Wed, 9 Feb 2022 19:15:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v2 3/3] bpftool: Update versioning scheme, align
 on libbpf's version number
Content-Language: en-GB
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20220208120648.49169-1-quentin@isovalent.com>
 <20220208120648.49169-4-quentin@isovalent.com>
 <CAEf4BzaH1OKZpJ8-CC4TbhGmYe+jv_0iqOTwhOG9+98Lze9Lew@mail.gmail.com>
 <82da0b01-af9f-ea0d-17a4-76a4c48bc879@isovalent.com>
 <CAEf4BzYPP28afBFwG+9jW4hpt2-iyy2gqATNUbY9yw0eDJU7Vw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <CAEf4BzYPP28afBFwG+9jW4hpt2-iyy2gqATNUbY9yw0eDJU7Vw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-02-09 09:53 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Wed, Feb 9, 2022 at 4:37 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> 2022-02-08 16:39 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
>>> On Tue, Feb 8, 2022 at 4:07 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>>>
>>>> Since the notion of versions was introduced for bpftool, it has been
>>>> following the version number of the kernel (using the version number
>>>> corresponding to the tree in which bpftool's sources are located). The
>>>> rationale was that bpftool's features are loosely tied to BPF features
>>>> in the kernel, and that we could defer versioning to the kernel
>>>> repository itself.
>>>>
>>>> But this versioning scheme is confusing today, because a bpftool binary
>>>> should be able to work with both older and newer kernels, even if some
>>>> of its recent features won't be available on older systems. Furthermore,
>>>> if bpftool is ported to other systems in the future, keeping a
>>>> Linux-based version number is not a good option.
>>>>
>>>> Looking at other options, we could either have a totally independent
>>>> scheme for bpftool, or we could align it on libbpf's version number
>>>> (with an offset on the major version number, to avoid going backwards).
>>>> The latter comes with a few drawbacks:
>>>>
>>>> - We may want bpftool releases in-between two libbpf versions. We can
>>>>   always append pre-release numbers to distinguish versions, although
>>>>   those won't look as "official" as something with a proper release
>>>>   number. But at the same time, having bpftool with version numbers that
>>>>   look "official" hasn't really been an issue so far.
>>>>
>>>> - If no new feature lands in bpftool for some time, we may move from
>>>>   e.g. 6.7.0 to 6.8.0 when libbpf levels up and have two different
>>>>   versions which are in fact the same.
>>>>
>>>> - Following libbpf's versioning scheme sounds better than kernel's, but
>>>>   ultimately it doesn't make too much sense either, because even though
>>>>   bpftool uses the lib a lot, its behaviour is not that much conditioned
>>>>   by the internal evolution of the library (or by new APIs that it may
>>>>   not use).
>>>>
>>>> Having an independent versioning scheme solves the above, but at the
>>>> cost of heavier maintenance. Developers will likely forget to increase
>>>> the numbers when adding features or bug fixes, and we would take the
>>>> risk of having to send occasional "catch-up" patches just to update the
>>>> version number.
>>>>
>>>> Based on these considerations, this patch aligns bpftool's version
>>>> number on libbpf's. This is not a perfect solution, but 1) it's
>>>> certainly an improvement over the current scheme, 2) the issues raised
>>>> above are all minor at the moment, and 3) we can still move to an
>>>> independent scheme in the future if we realise we need it.
>>>>
>>>> Given that libbpf is currently at version 0.7.0, and bpftool, before
>>>> this patch, was at 5.16, we use an offset of 6 for the major version,
>>>> bumping bpftool to 6.7.0.
>>>>
>>>> It remains possible to manually override the version number by setting
>>>> BPFTOOL_VERSION when calling make.
>>>>
>>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>>>> ---
>>>> Contrarily to the previous discussion and to what the first patch of the
>>>> set does, I chose not to use the libbpf_version_string() API from libbpf
>>>> to compute the version for bpftool. There were three reasons for that:
>>>>
>>>> - I don't feel comfortable having bpftool's version number computed at
>>>>   runtime. Somehow it really feels like we should now it when we compile
>>>
>>> Fair, but why not use LIBBPF_MAJOR_VERSION and LIBBPF_MINOR_VERSION to
>>> define BPFTOOL_VERSION (unless it's overridden).
>>
>> I forgot the macros were exposed, which is silly, because I was the one
>> to help expose them in the first place. Anyway.
>>
>>> Which all seems to be
>>> doable at compilation time in C code, not in Makefile. This will work
>>> with Github version of libbpf just as well with no extra Makefile
>>> changes (and in general, the less stuff is done in Makefile the
>>> better, IMO).
>>>
>>> Version string can also be "composed" at compile time with a bit of
>>> helper macro, see libbpf_version_string() implementation in libbpf.
>>
>> Sounds good, I can do that.

... Except that you can only compose so much. The preprocessor won't
allow me to sum libbpf's major version with the offset (6) before
turning it into a string. I need to think about this a bit more.

>>
>> This won't give me the patch number, though, only major and minor
>> version. We could add an additional LIBBPF_PATCH_VERSION to libbpf.
>> Although thinking about it, I'm not sure we need a patch version for
>> bpftool at the moment, because changes in libbpf's patch number is
>> unlikely to reflect any change in bpftool, so it makes little sense to
>> copy it. So I'm considering just leaving it at 0 in bpftool, and having
>> updates on major/minor numbers only when libbpf releases a major/minor
>> version. If we do want bugfix releases, it will still be possible to
>> overwrite the version number with BPFTOOL_VERSION anyway. What do you think?
> 
> So the patch version is not currently reflected in libbpf.map file. I
> do patch version bumps only when we detect some small issue after
> official release. It happened 2 or 3 times so far. I'm hesitant to
> expose that as LIBBPF_PATCH_VERSION, because I'll need to remember to
> bump it manually (and coordinating this between kernel sources and
> Github is a slow nightmare). Let's not rely on patch version, too much
> burden.

Agreed, thanks.
Quentin
