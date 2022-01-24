Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08417497D46
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 11:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbiAXKhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 05:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiAXKhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 05:37:33 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C21C06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 02:37:33 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id m11so55645698edi.13
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 02:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rSQeUpcdlaVxnlyHPZlA/Ygg7QddjkAcIgXh5+dK4ZA=;
        b=E7O+yFPXvOVsUYSz5zQWo2D9xtg2H9UXlQ/JIEjYlqzFFujW2FXR+rOUbFixqb7Jkz
         Wfk/OrqKKQWA8d4CjyOBoCP81Zko9goCKO7TNH0/1vTgTNgorhJqUlVoKkYpbXZeEUpV
         9NB9AOG+qstYRWdjMmRIYPs15/2Xtghvqt8it/7WXoKRwwLZjJNcZHHa0FMu7rxXvmgP
         dECAy3gFD9OMGs+HH3bSmTZVb4+jQfEwrkz3lBw9mZTvvH+SiMCozWU4Xqf+jf9kicKn
         eTRi0QzYUU78TFKg6S2WxE5aC3LsxcKI089As6Fdq427ctQ6+2ju96BZezLkrvlWkFTo
         L1pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rSQeUpcdlaVxnlyHPZlA/Ygg7QddjkAcIgXh5+dK4ZA=;
        b=nmHaaG1mTaQrHe/hsKCpA9MM0YrsARI3InMSz5chOKg0S48sg/oHiSU85Fm25CB5bN
         hDx7y0QoooISZmJ1RhMa76Kne1ze6F4XR5GHMdnaYBINWxeab5tHL5HG/2usFg/97AxZ
         W6MXXhh0h5KIUZxAmq3vPpEMmetotZw0pKJ7W/FHWrPYCbKSt7OivHc0wftW517GzCoh
         6tiVm6Wy9QtGhSed6we9Xpqt3MT111DFVZEgfgeyLZFFW2XvlIfeTWAlfMQ7YEreAHTX
         MLAyNE7PiDhcPByJ1TcxYUFbdN8AjpBRgRQGTzfI98e7K0DxhibfJpTplUqmhP7FmJPr
         XfHg==
X-Gm-Message-State: AOAM5335MAR09FO2Dcv1stbEFlrxqOqRJjxVJz+INxLlvkxEidPTxhzU
        53IaromVrRBbY1aSwhSjwxH+mw==
X-Google-Smtp-Source: ABdhPJyR81z+nPMmqT+s+6dYEX7jRS7cDIaT4GXBCfwJpdqDc6v9er/YadU9xc6kuBfX2Zm0MzhDig==
X-Received: by 2002:a05:6402:34c1:: with SMTP id w1mr10663162edc.403.1643020651530;
        Mon, 24 Jan 2022 02:37:31 -0800 (PST)
Received: from [192.168.1.8] ([149.86.95.103])
        by smtp.gmail.com with ESMTPSA id oz3sm4690259ejb.219.2022.01.24.02.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 02:37:30 -0800 (PST)
Message-ID: <15f76929-a953-e540-014f-170dd95dddb1@isovalent.com>
Date:   Mon, 24 Jan 2022 10:37:30 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Bpftool mirror now available
Content-Language: en-GB
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dave Thaler <dthaler@microsoft.com>
References: <267a35a6-a045-c025-c2d9-78afbf6fc325@isovalent.com>
 <CAEf4Bzbu4wc9anr19yG1AtFEcnxFsBrznynkrVZajQT1x_o6cA@mail.gmail.com>
 <ac3f95ed-bead-e8ea-b477-edcbd809452c@isovalent.com>
 <CAEf4BzaiUbAT4hBKTVYadGdygccA3c6jgPsu8VW9sLo+4Ofsvw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <CAEf4BzaiUbAT4hBKTVYadGdygccA3c6jgPsu8VW9sLo+4Ofsvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-01-20 11:07 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Thu, Jan 20, 2022 at 4:35 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> 2022-01-19 22:25 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
>>> On Wed, Jan 19, 2022 at 6:47 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> [...]
>>
>>>> 2. Because it is easier to compile and ship, this mirror should
>>>> hopefully simplify bpftool packaging for distributions.
>>>
>>> Right, I hope disto packagers will be quick to adopt the new mirror
>>> repo for packaging bpftool. Let's figure out bpftool versioning schema
>>> as a next step. Given bpftool heavily relies on libbpf and isn't
>>> really coupled to kernel versions, it makes sense for bpftool to
>>> reflect libbpf version rather than kernel's. WDYT?
>>
>> Personally, I don't mind finding another scheme, as long as we keep it
>> consistent between the reference sources in the kernel repo and the mirror.
>>
>> I also agree that it would make sense to align it to libbpf, but that
>> would mean going backward on the numbers (current version is 5.16.0,
>> libbpf's is 0.7.0) and this will mess up with every script trying to
>> compare versions. We could maybe add a prefix to indicate that the
>> scheme has changed ('l_0.7.0), but similarly, it would break a good
>> number of tools that expect semantic versioning, I don't think this is
>> any better.
>>
>> The other alternative I see would be to pick a different major version
>> number and arbitrarily declare that bpftool's version is aligned on
>> libbpf's, but with a difference of 6 for the version number. So we would
>> start at 6.7.0 and reach 7.0.0 when libbpf 1.0.0 is released. This is
>> not ideal, but we would keep some consistency, and we can always add the
>> version of libbpf used for the build to "bpftool version"'s output. How
>> would you feel about it? Did you have something else in mind?
> 
> Yeah, this off-by-6 major version difference seems ok-ish to me, I
> don't mind that. Another alternative is to have a completely
> independent versioning (and report used libbpf version in bpftool
> --version output  separately). But I think divorcing it from kernel
> version is a must, too much confusion.

Right, let's not tie it to libbpf either, having an independent
versioning scheme is probably the best solution indeed. I'll send a
patchset shortly to update the version and also print the one from libbpf.

Thanks,
Quentin
