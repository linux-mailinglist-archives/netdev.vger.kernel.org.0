Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6EE3A9DD1
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 16:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhFPOnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 10:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbhFPOnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 10:43:04 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DBBC061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 07:40:58 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id v6so2012010qta.9
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 07:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e8BQWj9GGSeGGaKWviuBbiJd2HGtQD3m99udw+frDiI=;
        b=ztPAVOObeQ7vo0DmWePgOg9O+Iy5/8CmcjDHtYYk0OaLhc5DwnRx4lz9ZAEP0MuO0h
         z0qx7ceezxpMnWY7+KiOAKU5rIe9cB1t1mD8B0BMA3Q41QltbFa/1P5SsX/dt1Kn6p2T
         5cO1gpN2OLQtNYpf2penm9hDb4Lh/ACosTKmsKLJGCnnZlhEkWhLAb3lzuhPwhngePrc
         kZt0vvv9eL8LQ9f5VnacnYF7JUGCA514+k8LsZfaTEQivWan1tWsqmKHNpvA7OQl+i8P
         gPh0JITYhzzEC061vE01f+L8oOYM8c6dM95e7Fh5vMc6Hzo+kwPpo5+PJBRTS++Pp+mt
         TKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e8BQWj9GGSeGGaKWviuBbiJd2HGtQD3m99udw+frDiI=;
        b=mdxQs1XYluXBiVq6cRIkWZ4+mIkXoFAeOU2q+rT7YBgU1FcCqZ6HjLh9G4Da0px/Pe
         Y8EEQzZdTbDMYN+h2aXhjJn5Lu9iIywIxOA3+4eFJ0FqcF1F7N86xfi5Z44F48XgJsli
         gR9K8JMvVUDpNvjkBzmFXd4RsNC0nnRM1O/QxfbhfBUdO8gvpgqPtvJyRCNz2tBnaqL4
         qNjd7VuDql8CkVC4ACn6SqU9D6+Id4DwfvawFL4sMKBl0D6wCeL1qzUhIB4zlUc8y0/s
         MVd8xDKOXyxObH2c1iOzcJxJnGy2Afj2j9ji7eI+aYYOnb0O0Bo8glcorQ9rdtmjhWpB
         /Tow==
X-Gm-Message-State: AOAM531o99bb5n45cgpkH6JV1d2UubPkPTvo/kztXtoA0BMOBnJ4vjCC
        6l4bR84H54dB9TewDvUUY1rIWQ==
X-Google-Smtp-Source: ABdhPJz6AmC+XrO7G+griAXN0YVYCUdxY3Zy0iP36Z6ULYPEE6reQGs4qmbgekOXjqPUqHCOI70CSQ==
X-Received: by 2002:a05:622a:2c3:: with SMTP id a3mr203998qtx.207.1623854457378;
        Wed, 16 Jun 2021 07:40:57 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-211.dsl.bell.ca. [184.148.47.211])
        by smtp.googlemail.com with ESMTPSA id l141sm1669287qke.59.2021.06.16.07.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 07:40:56 -0700 (PDT)
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
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo>
 <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo>
 <30ab29b9-c8b0-3b0f-af5f-78421b27b49c@mojatatu.com>
 <20210613203438.d376porvf5zycatn@apollo>
 <4b1046ef-ba16-f8d8-c02e-d69648ab510b@mojatatu.com>
 <bd18943b-8a0e-be8c-6a99-17f7dfdd3bc4@iogearbox.net>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7248dc4e-8c07-a25d-5ac3-c4c106b7a266@mojatatu.com>
Date:   Wed, 16 Jun 2021 10:40:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <bd18943b-8a0e-be8c-6a99-17f7dfdd3bc4@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-15 7:07 p.m., Daniel Borkmann wrote:
> On 6/13/21 11:10 PM, Jamal Hadi Salim wrote:

[..]

>>
>> I look at it from the perspective that if i can run something with
>> existing tc loading mechanism then i should be able to do the same
>> with the new (libbpf) scheme.
> 
> The intention is not to provide a full-blown tc library (that could be 
> subject to a
> libtc or such), but rather to only have libbpf abstract the tc related 
> API that is
> most /relevant/ for BPF program development and /efficient/ in terms of 
> execution in
> fast-path while at the same time providing a good user experience from 
> the API itself.
> 
> That is, simple to use and straight forward to explain to folks with 
> otherwise zero
> experience of tc. The current implementation does all that, and from 
> experience with
> large BPF programs managed via cls_bpf that is all that is actually 
> needed from tc
> layer perspective. The ability to have multi programs (incl. priorities) 
> is in the
> existing libbpf API as well.
> 

Which is a fair statement, but if you take away things that work fine
with current iproute2 loading I have no motivation to migrate at all.
Its like that saying of "throwing out the baby with the bathwater".
I want my baby.

In particular, here's a list from Kartikeya's implementation:

1) Direct action mode only
2) Protocol ETH_P_ALL only
3) Only at chain 0
4) No block support

I think he said priority is supported but was also originally on that
list.
When we discussed at the meetup it didnt seem these cost anything
in terms of code complexity or usability of the API.

1) We use non-DA mode, so i cant live without that (and frankly ebpf
has challenges adding complex code blocks).

2) We also use different protocols when i need to
(yes, you can do the filtering in the bpf code - but why impose that
if the cost of adding it is simple? and of course it is cheaper to do
the check outside of ebpf)
3) We use chains outside of zero

4) So far we dont use block support but certainly my recent experiences
in a deployment shows that we need to group netdevices more often than
i thought was necessary. So if i could express one map shared by
multiple netdevices it should cut down the user space complexity.

cheers,
jamal
