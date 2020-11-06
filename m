Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59F32A9885
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 16:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgKFP15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 10:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbgKFP14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 10:27:56 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C2CC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 07:27:56 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id k9so1366424qki.6
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 07:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MRCDqFeCLqw9GHk0394i8qLuY6gO7+ykE3myG5PJBbI=;
        b=wkpaZOrox1Spg5eAeNy7q5Y1ENwvRqyqAJvlp7OVOgHv6awLQLjjwWYdOdgKjkZA8c
         f7FTGZciheVnrJqRWrROuxIP7UoX/AeCHVuJfYLF9TWSkvRXlOnp5HuNLlFsGqHTj4Rs
         ibowrjvtIgMuCiLiqImSHO+u0EZJvYtiykfhE00XkbilUxi0BimdiAGdW+ZcuRdqVIA0
         vwvnRR6zoEfNpwdmtyopJjdXA7+wwcbfWIIJoktzrLgcO9u0IL0fnd1SBXcym/g3urnj
         6hE+28G9pnrE9oh2OPaYt8fxe0IiXbSGl5xGlBRzfbYUUQBiiXsaLq5X8RNV1ui4G3+7
         0TTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MRCDqFeCLqw9GHk0394i8qLuY6gO7+ykE3myG5PJBbI=;
        b=lZv0RhMAYk0KGLocTC7jTyvkfrOB6Q7rNLVya+ec2grl98DvAfK/bAnm7PyQz2wkHe
         6qnWfw/+1v2JCgsRFRu0nhweFMUSWzxMcnR60D2BukT9ooXJy7Ozu1bkCZrNsceMoM+4
         lF+WarzLEyfKSteSvFMNeu2QJ/Y3PjedVA3lSG4nzZcre3dVlfMRumDYrRE3Lm8izTk1
         AY69lm6sIp5/fX/sY9UYq+0TVJGnNyfOEtFrHRX1C47qDS3sUoN1sthV2oe/aboxh9X8
         M3Hv6l57yILoQtCMNTXsrZAi0/ZcRXJo7NFHuRLOzpX8ymGsYniFDFqXmP+saME6SBNk
         CFew==
X-Gm-Message-State: AOAM5312U2CiEFqoxFUme4698oE1Yi62szqSwePW9Gvs8txxfwWxoD9o
        yFScGFocsIKAURWuOglz20Wn2Q==
X-Google-Smtp-Source: ABdhPJwV21iipVPsbeIUD04K2O8C7hRThZwePhL4UxnI/+HZy+fmZIASONnJS0X1k5RKNcZ86ccfRA==
X-Received: by 2002:a05:620a:4eb:: with SMTP id b11mr1917692qkh.306.1604676475927;
        Fri, 06 Nov 2020 07:27:55 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id z1sm287437qtz.46.2020.11.06.07.27.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 07:27:54 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
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
 <1118ef27-3302-d077-021a-43aa8d8f3ebb@mojatatu.com>
 <CAEf4Bzag9XCRKCV_vkFU3TyCza3W+NJzm=Vh=NPkSNBY+Qke_A@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <3d7090ab-8bc9-bc68-642f-1e84d7a6ec08@mojatatu.com>
Date:   Fri, 6 Nov 2020 10:27:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzag9XCRKCV_vkFU3TyCza3W+NJzm=Vh=NPkSNBY+Qke_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-05 4:01 p.m., Andrii Nakryiko wrote:
> On Thu, Nov 5, 2020 at 6:05 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>
>> On 2020-11-04 10:19 p.m., David Ahern wrote:
>>
>> [..]

[..]

>> 2cents feedback from a dabbler in ebpf on user experience:
>>
>> What David described above *has held me back*.
>> Over time it seems things have gotten better with libbpf
>> (although a few times i find myself copying includes from the
>> latest iproute into libbpf). I ended up just doing static links.
>> The idea of upgrading clang/llvm every 2 months i revisit ebpf is
>> the most painful. At times code that used to compile just fine
>> earlier doesnt anymore. There's a minor issue of requiring i install
> 
> Do you have a specific example of something that stopped compiling?
> I'm not saying that can't happen, but we definitely try hard to avoid
> any regressions. I might be forgetting something, but I don't recall
> the situation when something would stop compiling just due to newer
> libbpf.
> 

Unfortunately the ecosystem is more than libbpf; sometimes it is
the kernel code that is being exercised by libbpf that is problematic.
This may sound unfair to libbpf but it is hard to separate the two for
someone who is dabbling like me.

The last issue iirc correctly had to do with one of the tcp notifier
variants either in samples or selftests(both user space and kernel).
I can go back and look at the details.
The fix always more than half the time was need to upgrade
clang/llvm. At one point i think it required that i had to grab
the latest and greatest git version. I think the machine i have
right now has version 11. The first time i found out about these
clang upgrades was trying to go from 8->9 or maybe it was 9->10.
Somewhere along there also was discovery that something that
compiled under earlier version wasnt compiling under newer version.

>> kernel headers every time i want to run something in samples, etc
>> but i am probably lacking knowledge on how to ease the pain in that
>> regard.
>>
>> I find the loader and associated tooling in iproute2/tc to be quiet
>> stable (not shiny but works everytime).
>> And for that reason i often find myself sticking to just tc instead
>> of toying with other areas.
> 
> That's the part that others on this thread mentioned is bit rotting?

Yes. Reason is i dont have to deal with new discoveries of things
that require some upgrade or copying etc.
I should be clear on the "it is the ecosystem": this is not just because
of user space code but also the simplicity of writing the tc kernel code
and loading it with tc tooling and then have a separate user tool for
control.
Lately i started linking the control tool with static libbpf instead.

Bpftool seems improved last time i tried to load something in XDP. I 
like the load-map-then-attach-program approach that bpftool gets
out of libbpf. I dont think that feature is possible with tc tooling.

However, I am still loading with tc and xdp with ip because of old
habits and what i consider to be a very simple workflow.

> Doesn't seem like everyone is happy about that, though. Stopping any
> development definitely makes things stable by definition. BPF and
> libbpf try to be stable while not stagnating, which is harder than
> just stopping any development, unfortunately.
> 

I am for moving to libbpf. I think it is a bad idea to have multiple
loaders for example. Note: I am not a demanding user, but there
are a few useful features that i feel i need that are missing in
iproute2 version. e.g, one thing i was playing with about a month
ago was some TOCTOU issue in the kernel code and getting
the bpf_lock integrated into the tc code proved challenging.
I ended rewriting the code to work around the tooling.

The challenge - when making changes in the name of progress - is to
not burden a user like myself with a complex workflow but still give
me the features i need.

>> Slight tangent:
>> One thing that would help libbpf adoption is to include an examples/
>> directory. Put a bunch of sample apps for tc, probes, xdp etc.
>> And have them compile outside of the kernel. Maybe useful Makefiles
>> that people can cutnpaste from. Every time you add a new feature
>> put some sample code in the examples.
> 
> That's what tools/testing/selftests/bpf in kernel source are for. It's
> not the greatest showcase of examples, but all the new features have a
> test demonstrating its usage. I do agree about having simple Makefiles
> and we do have that at [0]. I'm also about to do another sample repo
> with a lot of things pre-setup, for tinkering and using that as a
> bootstrap for BPF development with libbpf.
> 
>    [0] https://github.com/iovisor/bcc/tree/master/libbpf-tools


I pull that tree regularly.
selftests is good for aggregating things developers submit and
then have the robots test.
For better usability, it has to be something that is standalone that 
would work out of the box with libbf.
selftests and samples are not what i would consider for the
faint-hearted.
It may look easy to you because you eat this stuff for
breakfast but consider all those masses you want to be part of this.
They dont have the skills and people with average skills dont
have the patience.

This again comes back to "the ecosystem" - just getting libbpf to get
things stable for userland is not enough. Maybe have part of the libbpf
testing also to copy things from selftests.

cheers,
jamal
