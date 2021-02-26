Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9373265DE
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 17:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhBZQvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 11:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhBZQve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 11:51:34 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267ACC061756
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 08:50:46 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id b18so2731117wrn.6
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 08:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JcMQC9svEtKNnsjRXVVzKmKPg+gakSjq3oHTLIMUWnA=;
        b=GbRgobbI5YqAC9W6qnB8xsjPP1K1Mx12d0oKWk/B64DZKm8E0gGzm8GafeSR9Fg8Fu
         mElkBtVO+Rckffn5JwNjKxpAl0qBv+iK0ya0i8ZWgvJBgPpL87NrQXB9nOFM23sd30Hg
         ktR07mR0ptNNYazLv9vXiLrGm/Q88AkzEjKHsGvN886jFRHPHIa8M7Utwmvu5jOUa6O8
         hSan1fqtTssqy1JpQFyu72hiTIramPjZSMgmY9F6JZFKTL+ic8XoBK7IxvWRlrmngnly
         Gam0/euxvZwCWozN/4HyoV0eO+njyEVfHq6L7llh1m7k//5GcohKELgX2lu/jpywO+XP
         IA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JcMQC9svEtKNnsjRXVVzKmKPg+gakSjq3oHTLIMUWnA=;
        b=XPWdKsCn+3Ya6c8F9RG2SlJJpVeZZz50IDVeVILsIIYtn//Vzb0xSFPUVCNSKS19cd
         O9/ft7iWwFBZ+6dgIqeXR+zkr8eNKyNROJ3qpmdF+OwuQ3W36pxrH3T45V5Q12KREDL0
         SjXpmj76ZKGn1b4YI08A4XCYfbdWLOJZx4BS2e9xuS7WyC8i+lwXRFVFoEptYB8qqwki
         C8kmdXr0jiDDWknV0ldRRNLPsQJFr+/kIkTAZlnm82YvXWOhodFTXQShnnDpwlqTRK2Q
         hObKktOfUOZaI/7S8O21pZ+Gqud4kRETerG5a0QLZ99sd6Oddg/f+oPdKidP0jTfKtnx
         DeNg==
X-Gm-Message-State: AOAM531d/m80kihzH4WOu8HEeVpe57BtWICleVhMmrrkd9eokNLeMH1o
        YnqewNEhVjb2J5z0bJyO5c8w6f6v6drJG9k6pjI=
X-Google-Smtp-Source: ABdhPJx+kBynr78v8lUIr4BFep8VxDIBoproABvLOZanBkj1zf0zDg05qBvi9nx3tq8j8l+Z7dQkVg==
X-Received: by 2002:adf:8151:: with SMTP id 75mr4138303wrm.152.1614358244242;
        Fri, 26 Feb 2021 08:50:44 -0800 (PST)
Received: from [192.168.1.9] ([194.35.118.244])
        by smtp.gmail.com with ESMTPSA id 36sm15503611wrh.94.2021.02.26.08.50.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 08:50:43 -0800 (PST)
Subject: Re: [PATCH bpf-next] bpf: fix missing * in bpf.h
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Joe Stringer <joe@wand.net.nz>
References: <20210223124554.1375051-1-liuhangbin@gmail.com>
 <20210223154327.6011b5ee@carbon>
 <2b917326-3a63-035e-39e9-f63fe3315432@iogearbox.net>
 <CAEf4BzaqsyhJvav-GsJkxP7zHvxZQWvEbrcjc0FH2eXXmidKDw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <b64fa932-5902-f13f-b3b9-f476e389db1b@isovalent.com>
Date:   Fri, 26 Feb 2021 16:50:42 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaqsyhJvav-GsJkxP7zHvxZQWvEbrcjc0FH2eXXmidKDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-02-24 10:59 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Wed, Feb 24, 2021 at 7:55 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> On 2/23/21 3:43 PM, Jesper Dangaard Brouer wrote:
>>> On Tue, 23 Feb 2021 20:45:54 +0800
>>> Hangbin Liu <liuhangbin@gmail.com> wrote:
>>>
>>>> Commit 34b2021cc616 ("bpf: Add BPF-helper for MTU checking") lost a *
>>>> in bpf.h. This will make bpf_helpers_doc.py stop building
>>>> bpf_helper_defs.h immediately after bpf_check_mtu, which will affect
>>>> future add functions.
>>>>
>>>> Fixes: 34b2021cc616 ("bpf: Add BPF-helper for MTU checking")
>>>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>>>> ---
>>>>   include/uapi/linux/bpf.h       | 2 +-
>>>>   tools/include/uapi/linux/bpf.h | 2 +-
>>>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> Thanks for fixing that!
>>>
>>> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>
>> Thanks guys, applied!
>>
>>> I though I had already fix that, but I must have missed or reintroduced
>>> this, when I rolling back broken ideas in V13.
>>>
>>> I usually run this command to check the man-page (before submitting):
>>>
>>>   ./scripts/bpf_helpers_doc.py | rst2man | man -l -
>>
>> [+ Andrii] maybe this could be included to run as part of CI to catch such
>> things in advance?
> 
> We do something like that as part of bpftool build, so there is no
> reason we can't add this to selftests/bpf/Makefile as well.

Hi, pretty sure this is the case already? [0]

This helps catching RST formatting issues, for example if a description
is using invalid markup, and reported by rst2man. My understanding is
that in the current case, the missing star simply ends the block for the
helpers documentation from the parser point of view, it's not considered
an error.

I see two possible workarounds:

1) Check that the number of helpers found ("len(self.helpers)") is equal
to the number of helpers in the file, but that requires knowing how many
helpers we have in the first place (e.g. parsing "__BPF_FUNC_MAPPER(FN)").

2) Add some ending tag to the documentation block, and make sure we
eventually reach it. This is probably a much simpler solution. I could
work on this (or sync with Joe (+Cc) who is also working on these bits
for documenting the bpf() syscall).

[0]
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/Makefile?h=v5.11#n189

Quentin
