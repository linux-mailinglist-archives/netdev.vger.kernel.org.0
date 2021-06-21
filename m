Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43B83AEA90
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhFUN5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhFUN5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:57:49 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67238C061756
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 06:55:34 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id c22so5854007qtn.1
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 06:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6Ougy1rc6cqK/L0Yxf92AJ9zYcOkCJyCYFV/gxpwdkI=;
        b=XZajQ0C6K9LCa+8YhGzsGrqq3CaWrPw2ptkSvWOpjQqGj6tNj5uZynPf+FJs66ScJK
         KVb0emS8xFHKco+7NWrrQQRO1339Y9ycIpKnhBW2X47EOZxdNU9v+yeVWSU95brLbJxO
         nL3atOQwzbScq40I7LcADa3ZEhVQ8Cjs00KjFRM13jM/4GaKr24VdDJSpKenEKKLWxPl
         /HpCuKMaCQXwD0RM2yA2BLAqHQ5GAUp+EvA6XSooTiwSCNbH6AE3+KLddXdJwTdLJdVX
         P2f+N6GfkLE6HfR8vZU9wx8mgiJv935LpQqtZbsbaZe4lQOHkmyKBqaAF+IWMlDJgamD
         8E/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6Ougy1rc6cqK/L0Yxf92AJ9zYcOkCJyCYFV/gxpwdkI=;
        b=EDyuEABoYeiOn1n4oRIXB7q+NUInqR/Iks2kD0VuyjQyawNay8yteQJHs+cO9EnEj7
         w9UAv/zhqgtqkhk7HT234vgv1Y3gzu+XMoi469PHXft8sWFgLzw+wGxQohAiq3q5lQnB
         BVW7XcFLmIDSsnikh7Vmu7LCwePCd/NvdSFSLC9zuhoOJSpVCI0hlZbzgp2Ed3LybdBQ
         wZqHA+xryXG+ce3+5ZvU3VBz96o9h50E1UIfUV8rV1hnLpZN+xxA++fa4AwCagKBlqBI
         j+eV4/fqPP8jf9coAdTKoFmfY2EGJJdawA6h0LXC/myQ8TGYJdM6eZq8ngpn93vQA2tY
         tMxA==
X-Gm-Message-State: AOAM5313b0R1pDTgUFbrpsuyHWjOUsBpYn6BPuRhk1E5oG4xMe3bJyO+
        EjR1Yl+xPNGiFzjhY3TgPvy9Cw==
X-Google-Smtp-Source: ABdhPJyYDEzdi/1hbbOYGLD2+Kzbq4pqXthUystxxVMqorPWSzXgB/kTMhae1Z0dnTxWmzHMP+CDgw==
X-Received: by 2002:ac8:5f93:: with SMTP id j19mr23965892qta.298.1624283733550;
        Mon, 21 Jun 2021 06:55:33 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-24-174-92-115-23.dsl.bell.ca. [174.92.115.23])
        by smtp.googlemail.com with ESMTPSA id k19sm10035340qkj.89.2021.06.21.06.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 06:55:32 -0700 (PDT)
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Vlad Buslov <vladbu@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo>
 <30ab29b9-c8b0-3b0f-af5f-78421b27b49c@mojatatu.com>
 <20210613203438.d376porvf5zycatn@apollo>
 <4b1046ef-ba16-f8d8-c02e-d69648ab510b@mojatatu.com>
 <bd18943b-8a0e-be8c-6a99-17f7dfdd3bc4@iogearbox.net>
 <7248dc4e-8c07-a25d-5ac3-c4c106b7a266@mojatatu.com>
 <20210616153209.pejkgb3iieu6idqq@apollo>
 <05ec2836-7f0d-0393-e916-fd578d8f14ac@iogearbox.net>
 <f038645a-cb8a-dc59-e57e-2544a259bab1@mojatatu.com>
 <3e9bf85b-60a4-d5d2-0267-85bb76974339@iogearbox.net>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <90f403df-520a-a3c0-0272-8118f9628498@mojatatu.com>
Date:   Mon, 21 Jun 2021 09:55:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3e9bf85b-60a4-d5d2-0267-85bb76974339@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-18 6:42 p.m., Daniel Borkmann wrote:
> On 6/18/21 1:40 PM, Jamal Hadi Salim wrote:

[..]
>  From a user interface PoV it's odd since you need to go and parse that 
> anyway, at
> least the programs typically start out with a switch/case on either 
> reading the
> skb->protocol or getting it via eth->h_proto. But then once you extend 
> that same
> program to also cover IPv6, you don't need to do anything with the 
> ETH_P_ALL
> from the loader application, but now you'd also need to additionally 
> remember to
> downgrade ETH_P_IP to ETH_P_ALL and rebuild the loader to get v6 
> traffic. But even
> if you were to split things in the main/entry program to separate v4/v6 
> processing
> into two different ones, I expect this to be faster via tail calls 
> (given direct
> absolute jump) instead of walking a list of tcf_proto objects, comparing 
> the
> tp->protocol and going into a different cls_bpf instance.
> 

Good point on being more future proof with ETH_P_ALL.
Note: In our case we were only interested in ipv4 and i dont see that
changing for the specific prog we have. From a compute perspective all
i am saving by not using ETH_P_ALL is one if statement (checking if
proto is ipv4). If you feel strongly about it we can change our code.
My worry now is if we used this approach then likely someone else in the 
wild used something similar.

I think it boils down again to: if it doesnt confuse the API or add
extra complexity why not allow it and default to ETH_P_ALL?

On your comment that a bpf based proto comparison being faster - the
issue is that the tp proto always happens regardless and ebpf, depending
on your program, may not fit all your code. Example i may actually
decide to have a program for v6 and v4 separately if i wanted
to with current mechanism - at different tc ruleset prios just
so as to work around code/complexity issues.

BTW: tail call limit of 32 provides an upper bound which affects
depth of (generic) parsing.
Does it make sense to allow (maybe on a per-boot) increasing the size?
The fact things run on the stack may be restricting.


> It may be more tricky but not impossible either, in recent years some 
> (imho) very
> interesting and exciting use cases have been implemented and talked 
> about e.g. [0-2],
> and with the recent linker work there could also be a [e.g. in-kernel] 
> collection with
> library code that can be pulled in by others aside from using them as 
> BPF selftests
> as one option. The gain you have with the flexibility [as you know] is 
> that it allows
> easy integration/orchestration into user space applications and thus 
> suitable for
> more dynamic envs as with old-style actions. The issue I have with the 
> latter is
> that they're not scalable enough from a SW datapath / tc fast-path 
> perspective given
> you then need to fallback to old-style list processing of cls+act 
> combinations which
> is also not covered / in scope for the libbpf API in terms of their 
> setup, and
> additionally not all of the BPF features can be used this way either, so 
> it'll be very
> hard for users to debug why their BPF programs don't work as they're 
> expected to.
> 
> But also aside from those blockers, the case with this clean slate tc 
> BPF API is that
> we have a unique chance to overcome the cmdline usability struggles, and 
> make it as
> straight forward as possible for new generation of users.
> 
>    [0] https://linuxplumbersconf.org/event/7/contributions/677/
>    [1] https://linuxplumbersconf.org/event/2/contributions/121/
>    [2] 
> https://netdevconf.info/0x14/session.html?talk-replacing-HTB-with-EDT-and-BPF 

I took a quick glance at the refs.

IIUC, your message is "do more with less" i.e restrict choices now
so we can focus on optimizing for speed. Here's my experience.
We have two pragmatic challenges:

1) In a deployment, like some enterprise class data centers, we are
often limited by the kernel and often even the distro you are on. You
cant just upgrade to the latest and greatest without risking voiding
the distro vendors support contract. Big shops with a lot of geniuses
like FB and Google dont have these problems of course - but the majority
out there do.

So even our little program must use supported interfaces (ex: You cant
expect support on RH8.3 for an XDP issue without using the supplied XDP 
lib) to be accepted.

So building in support to use existing infra is useful

2) challenges with ebpf code space and code complexity: Depending
on the complexity, a program with less than 4K instructions may be
rejected by the verifier. IOW, I just cant add all the features
i need _even if i wanted to_.

For this reason working cooperatively with other existing kernel
and user infra makes sense (Ref [2] is doing that for example).
You dont want to rewrite the kernel using ebpf. Extending the kernel
with ebpf makes sense. And of course I dont want to loose performance
but there may be a trade-off sometimes where a little loss in 
performance is justified for gain of a feature makes sense
(the non-da example applies).

Perhaps adding more helpers to interface to the actions and classifiers
is one way forward.

cheers,
jamal

PS: I didnt understand the kernel linker point with BPF selftests.
Pointer?
