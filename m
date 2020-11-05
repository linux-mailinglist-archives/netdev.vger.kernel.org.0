Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3411D2A805F
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 15:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730993AbgKEOFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 09:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730461AbgKEOFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 09:05:52 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DFFC0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 06:05:52 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id y197so1204267qkb.7
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 06:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kGsS3CDA+A4yL0j/LqXfYl8CzhC0b4YwmHrFB9LaQUI=;
        b=g9Z4SEZOKnUkWvEkyoPAGPSbaj0mK3KIkrq5A8KpV43SpGg2cSQlwyucY/qwAhIxff
         nsWnIgpGvlvtw3fnTkzKn7CuzHmFOUNnUfXBQ8t8sVbGdv/tT1KTGMmsMx3VDMi4ifQH
         cOHrODhh2GytYB/lkF6RQu+XbghSsp8ze/k9qApGY75NeFhyncZr6Yy4RhmdSNITLACX
         6Sl1KMP1KBbIT+S+FTJ2UHNWuYEnxzSyPP37Yxq9PkZUvV/VbN6wpn9nFcIihWYrArNe
         58miXECm1Er+1SjyeK2ZNXqRayPMaRm9lEN3TcB9bdb3F+znrwwdfTCAR5qa6IcDD1oT
         fyxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kGsS3CDA+A4yL0j/LqXfYl8CzhC0b4YwmHrFB9LaQUI=;
        b=LBKRySf0FaYGu+kVDPSvmjXHXJgFqS5nZkZri9pTyUhfYjxp8y0mAmsmpr9PRKMgWn
         /QQqOU3n5kYkz5HPbcBdRp4pI9fQHul+CZA7l3FuYGl1cXih/P4qmUXkAaxk8i+1abeb
         cAOZei7H4FBPwknsC/1GjA71O+nSAWkhB3Ghz1i8OA+GhB6XZqn4Y8d4yhdeNHWCqLPn
         qRyM+MfFSc42+ESTOxP3TIVfMBgn9sEFI94vJsGIMN8z3atSlD1+FXvIVkTBPheMzMHJ
         WvjvWsC3Oq3ZJ8MfWTVLCa2j0o5rzQWOvhkKD6XpMlMfmDeTjzemQFxAcxaqO6iXUKAV
         Eqjg==
X-Gm-Message-State: AOAM532qfTJ3hImag+DWiUYU2rec0X7DZdU/IAM0aKNuxEBNSCm9sS1J
        ZabUhNjC3RcXMiH9UX5G6Hi/lA==
X-Google-Smtp-Source: ABdhPJy85uIXg+WyZbDaRM8Js2JSe3kWh26Yp7y6E+mYU+A488fs9Hf/sAzIu1VJsQAjejXwgL+/5g==
X-Received: by 2002:a37:a5c3:: with SMTP id o186mr2158945qke.259.1604585151255;
        Thu, 05 Nov 2020 06:05:51 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id m25sm1040025qki.105.2020.11.05.06.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 06:05:50 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
 <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net>
 <ec50328d-61ab-71fb-f266-5e49e9dbf98e@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <1118ef27-3302-d077-021a-43aa8d8f3ebb@mojatatu.com>
Date:   Thu, 5 Nov 2020 09:05:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <ec50328d-61ab-71fb-f266-5e49e9dbf98e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-04 10:19 p.m., David Ahern wrote:

[..]
> 
> User experience keeps getting brought up, but I also keep reading the
> stance that BPF users can not expect a consistent experience unless they
> are constantly chasing latest greatest versions of *ALL* S/W related to
> BPF. That is not a realistic expectation for users. Distributions exist
> for a reason. They solve real packaging problems.
> 
> As libbpf and bpf in general reach a broader audience, the requirements
> to use, deploy and even tryout BPF features needs to be more user
> friendly and that starts with maintainers of the BPF code and how they
> approach extensions and features. Telling libbpf consumers to make
> libbpf a submodule of their project and update the reference point every
> time a new release comes out is not user friendly.
> 
> Similarly, it is not realistic or user friendly to *require* general
> Linux users to constantly chase latest versions of llvm, clang, dwarves,
> bcc, bpftool, libbpf, (I am sure I am missing more), and, by extension
> of what you want here, iproute2 just to upgrade their production kernel
> to say v5.10, the next LTS, or to see what relevant new ebpf features
> exists in the new kernel. As a specific example BTF extensions are added
> in a way that is all or nothing. Meaning, you want to compile kernel
> version X with CONFIG_DEBUG_INFO_BTF enabled, update your toolchain.
> Sure, you are using the latest LTS of $distro, and it worked fine with
> kernel version X-1 last week, but now compile fails completely unless
> the pahole version is updated. Horrible user experience. Again, just an
> example and one I brought up in July. I am sure there more.
> 


2cents feedback from a dabbler in ebpf on user experience:

What David described above *has held me back*.
Over time it seems things have gotten better with libbpf
(although a few times i find myself copying includes from the
latest iproute into libbpf). I ended up just doing static links.
The idea of upgrading clang/llvm every 2 months i revisit ebpf is
the most painful. At times code that used to compile just fine
earlier doesnt anymore. There's a minor issue of requiring i install
kernel headers every time i want to run something in samples, etc
but i am probably lacking knowledge on how to ease the pain in that
regard.

I find the loader and associated tooling in iproute2/tc to be quiet
stable (not shiny but works everytime).
And for that reason i often find myself sticking to just tc instead
of toying with other areas.
Slight tangent:
One thing that would help libbpf adoption is to include an examples/
directory. Put a bunch of sample apps for tc, probes, xdp etc.
And have them compile outside of the kernel. Maybe useful Makefiles
that people can cutnpaste from. Every time you add a new feature
put some sample code in the examples.

cheers,
jamal
