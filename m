Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF8631DB09
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 14:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhBQN4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 08:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbhBQN4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 08:56:52 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00893C0613D6;
        Wed, 17 Feb 2021 05:56:11 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id 81so12727203qkf.4;
        Wed, 17 Feb 2021 05:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=JCCnv2cB5dMsn244YKWpcbhNJgxiilTBni2u8DqhTtQ=;
        b=Aamka5A7B3pAYs2/I7AhFqMhx5njNhEiJR0WIIiMmHLaIKyIJchkbdcYOOeceec909
         UX37mjUq+6ovPqEuEiwkZgCzzgKC3eaKZBeuESmBZyCB/UEkn2n6EvES6yDFrKKCvHac
         5+zAxk5cOafGSfPan5qStkv7AFjtwBVavL0/loLM8CL8RUNygBlbvgLIhD/0A9bZToUn
         V8W9NlLeKxCaMr0tC6Hz1yr8ck8fnkGesNKSr4jaW52bTKU29AWprMnbU63UUqyZqKUc
         kZf8EX6ZlBKY9dDwN+qsfVVCHgrIumTg0bOC9UJYcC+/e1A2oOL/5whj6qRKPORhuDmB
         7m3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:from
         :message-id;
        bh=JCCnv2cB5dMsn244YKWpcbhNJgxiilTBni2u8DqhTtQ=;
        b=mAXo1R1Dv6Fk8xZ9Lpkf1AysZ27eJ6IqSpDjTKOv8FsIy86IEYupYdeeyo5/UsD500
         Y65Viq7p1E1jEeRRR1Oq9NuC3wBkQsIwjYMVe1FRh5mRV28oIJNp9gB3tcjnirsGTgd5
         bBjDwPTLkA17i+M0XPTPymp2CuLQJv6pMe6zJ2njmyPlcSkRd4/jwJRpgbmxkTSNJrwg
         dg7tH4R2fm3AGfwzeljbvfS2AZSCC3PdXADTxQZRBUkND1wQkHGb34usjWpSQo94hgyq
         5Lj+45ACozeEkHeoNOvYFD5DeZ+VVefhFyjs4Ofed3Zidpui7hVWMij/IdajBeK/ubMn
         jE4A==
X-Gm-Message-State: AOAM531vm4r5O7GHmLYmr0gpj3GNYBPMCjbQuw9b/zi17rdul+3in07J
        rVDA8xklQJtPdumM6I/RZ1I=
X-Google-Smtp-Source: ABdhPJwNT1CUXwV+lOUPlIurxRqBKleyvmNoDKSQEmcFxFyxDPaauYAjpFIkJVnyl/HM9Ms3tKBWoQ==
X-Received: by 2002:a37:b002:: with SMTP id z2mr23772528qke.500.1613570171176;
        Wed, 17 Feb 2021 05:56:11 -0800 (PST)
Received: from [192.168.86.198] ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id h9sm1607145qkh.104.2021.02.17.05.56.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 05:56:08 -0800 (PST)
Date:   Wed, 17 Feb 2021 10:54:29 -0300
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+icZUWBfwJ0WKQi7AO_dhcMpFWmo6riwszpmsZLfn1BwH_kyw@mail.gmail.com>
References: <20210213164648.1322182-1-jolsa@kernel.org> <YC0Pmn0uwhHROsQd@kernel.org> <CA+icZUWBfwJ0WKQi7AO_dhcMpFWmo6riwszpmsZLfn1BwH_kyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCHv2] btf_encoder: Match ftrace addresses within elf functions
To:     sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@gmail.com>
CC:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Message-ID: <AA8690FE-7C57-4791-881A-DE06B337DF45@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On February 17, 2021 10:40:43 AM GMT-03:00, Sedat Dilek <sedat=2Edilek@gma=
il=2Ecom> wrote:
>On Wed, Feb 17, 2021 at 1:44 PM Arnaldo Carvalho de Melo
><arnaldo=2Emelo@gmail=2Ecom> wrote:
>>
>> Em Sat, Feb 13, 2021 at 05:46:48PM +0100, Jiri Olsa escreveu:
>> > Currently when processing DWARF function, we check its entrypoint
>> > against ftrace addresses, assuming that the ftrace address matches
>> > with function's entrypoint=2E
>> >
>> > This is not the case on some architectures as reported by Nathan
>> > when building kernel on arm [1]=2E
>> >
>> > Fixing the check to take into account the whole function not
>> > just the entrypoint=2E
>> >
>> > Most of the is_ftrace_func code was contributed by Andrii=2E
>>
>> Applied locally, will go out after tests,
>>
>
>Hi Arnaldo,
>
>Is it possible to have a pahole version 1=2E21 with this patch and the
>one from Yonghong Son?
>
>From my local pahole Git:
>
>$ git log --oneline --no-merges v1=2E20=2E=2E
>2f83aefdbddf (for-1=2E20/btf_encoder-ftrace_elf-clang-jolsa-v2)
>btf_encoder: Match ftrace addresses within elf functions
>f21eafdfc877 (for-1=2E20/btf_encoder-sanitized_int-clang-yhs-v2)
>btf_encoder: sanitize non-regular int base type
>
>Both patches fixes all issues seen so far with LLVM/Clang >=3D
>12=2E0=2E0-rc1 and DWARF-v5 and BTF (debug-info) and pahole on
>Linux/x86_64 and according to Nathan on Linux/arm64=2E
>Yesterday, I tried with LLVM/Clang 13-git from <apt=2Ellvm=2Eorg>=2E
>
>BTW, Nick's DWARF-v5 patches are pending in <kbuild=2Egit#kbuild> (see
>[1])=2E
>
>Personally, I can wait until [1] is in Linus Git=2E
>
>Please, let me/us know what you are planning=2E
>( I know it is Linux v5=2E12 merge-window=2E )

Sure, next week=2E

- Arnaldo

>
>Regards,
>- Sedat -
>
>[1]
>https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/masahiroy/linux-kbuil=
d=2Egit/log/?h=3Dkbuild

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
