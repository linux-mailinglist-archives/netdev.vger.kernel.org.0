Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBC23ACA1B
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 13:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbhFRLm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 07:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhFRLm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 07:42:26 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFEFC061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 04:40:17 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id c9so10206886qkm.0
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 04:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hxTpNTjI0kG2nomUBbYf7UdQNAS7vv0AjvB2ZhKjRd4=;
        b=vUWhZLoZQnftWpUqbkKEAs7oX4Y8HDuqvsdrWjbiMuaNy/IOyEjyRudPJoOyG8ioJB
         PhxQqeqsH2IvUWd4fYPj/n+V7j/b9UKZSak6jCq7+tDS+lz/BDtuXhlK2BxDWXXE5uM8
         kZcUlUdBFkd2HHscrpYQxpwB1PMNbkHdB2qFy5Gk/caH2VWlk8XWmejFP/ub4DteknWu
         NpFps0LQ9A81ypDUt5R4kFPWKo+6BVtMkec32wSfr2LNnxDebgZiFGFqX7aEPWeXdkQF
         iDnnrHF+kz1bsVNTWsn9wfWoy1gjIeZeMmN8KMLdj423Ejnh20gp2xVo3Dlc3xszOkhV
         dlTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hxTpNTjI0kG2nomUBbYf7UdQNAS7vv0AjvB2ZhKjRd4=;
        b=Ez4hpLQhxb84MiyREONsxL55L7vg6AjG9G1aetMXfqddbn7NdRpQhmD3ObLh+Z2H6c
         wAuw2vErBhLwaI+AZC5JZqHGpGzxi4JFQ9FDKdPpLWcDoFJZECyghH+9peGQh/h8QhZc
         bkfqE6Of8h6VeB7atTAaTpQ3sVRGgrpB/iOyiDDcdCmajhNQQXbyNbJ7AdYUEprybZBn
         wiaJXk9gG3PiX2nQ7Naf4iT92kLHJ+2cpMKpbOOrhKvxj1oUFS33/4zS1tZxwuYPZR7g
         EGqnYcD/AKmGJDJ2MT8kazNlpCUBI6/3407K1YKWM2NgS8HQWH86+GuDexvNTvGp5J6D
         mO3Q==
X-Gm-Message-State: AOAM533JYT3Wxm4NHvY+aG9XMcp/6Ts0HIsD2D+p/jEJguhpt3dixuO+
        cfMLJIgHfYPemmZ2U1oIhXm5Gg==
X-Google-Smtp-Source: ABdhPJy03kwyCgBBJW2pNwyMwghGikCC0q7D2VookmGkvCzHvd8zkTJsJqR9pef4zzVKKHyXv62Esw==
X-Received: by 2002:a37:b741:: with SMTP id h62mr9117585qkf.78.1624016416403;
        Fri, 18 Jun 2021 04:40:16 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-211.dsl.bell.ca. [184.148.47.211])
        by smtp.googlemail.com with ESMTPSA id g1sm3703243qkd.125.2021.06.18.04.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 04:40:15 -0700 (PDT)
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
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <f038645a-cb8a-dc59-e57e-2544a259bab1@mojatatu.com>
Date:   Fri, 18 Jun 2021 07:40:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <05ec2836-7f0d-0393-e916-fd578d8f14ac@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-16 12:00 p.m., Daniel Borkmann wrote:
> On 6/16/21 5:32 PM, Kumar Kartikeya Dwivedi wrote:
>> On Wed, Jun 16, 2021 at 08:10:55PM IST, Jamal Hadi Salim wrote:
>>> On 2021-06-15 7:07 p.m., Daniel Borkmann wrote:
>>>> On 6/13/21 11:10 PM, Jamal Hadi Salim wrote:

[..]

>>>
>>> In particular, here's a list from Kartikeya's implementation:
>>>
>>> 1) Direct action mode only
> 
> (More below.)
> 
>>> 2) Protocol ETH_P_ALL only
> 
> The issue I see with this one is that it's not very valuable or useful 
> from a BPF
> point of view. Meaning, this kind of check can and typically is 
> implemented from
> BPF program anyway. For example, when you have direct packet access 
> initially
> parsing the eth header anyway (and from there having logic for the 
> various eth
> protos).

In that case make it optional to specify proto and default it to
ETH_P_ALL. As far as i can see this flexibility doesnt
complicate usability or add code complexity to the interfaces.

> 
> That protocol option is maybe more useful when you have classic tc with 
> cls+act
> style pipeline where you want a quick skip of classifiers to avoid 
> reparsing the
> packet. Given you can do everything inside the BPF program already it 
> adds more
> confusion than value for a simple libbpf [tc/BPF] API.
> 

There's no point in repeating an operation of identifying
the protocol type which can/has already be Id-ed by the calling
(into ebpf) code. If all i am interested in is IPv4, then
my ebpf parser can be simplified if i am sure i can assume it
is an IPv4 packet.


[..]

>>> 1) We use non-DA mode, so i cant live without that (and frankly ebpf
>>> has challenges adding complex code blocks).
> 
> Could you elaborate on that or provide code examples? Since introduction 
> of the
> direct action mode I've never used anything else again, and we do have 
> complex
> BPF code blocks that we need to handle as well. Would be good if you 
> could provide
> more details on things you ran into, maybe they can be solved?
> 

Main issue is code complexity in ebpf and not so much instruction
count (which is complicated once you have bounded loops).
Earlier, I tried to post on the ebpf list but i got no response.
I moved on since. I would like to engage you at some point - and
you are right there may be some clever tricks to achieve the goals
we had. The challenge is in keeping up with the bag of tricks to make
the verifier happy.
Being able to run non-da mode and for example attach an action such
as the policer (and others) has pragmatic uses. It would be quiet 
complex to implement the policer within an all-in-one-appliance
da-mode ebpf code.
One approach is to add more helpers to invoke such code directly
from ebpf - but we have some restrictions; the deployment is RHEL8.3
based and we have to live with the kernel features supported there.
i.e kernel upgrade is a no-no. Given all these TC features have
existed (and stable) for 100 years it make a lot of sense to use them.

We are going to present some of the challenges we faced in a subset
of our work in an approach to replace iptables at netdev 0x15
(hopefully we get accepted).

cheers,
jamal
