Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75543AD09E
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbhFRQoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbhFRQoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 12:44:11 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9A2C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 09:42:00 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id o20so7977608qtr.8
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 09:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xqBz3eNyDUZXRDT/sBrEORRw8yLFnQSQre/jnFUfhGA=;
        b=pJ+/lN+w7GrXtRcmNVeBtY0FApfLVdPIfcFg3mFbrgO3nVzsyJ7a1POU2f6PkgX9sJ
         pLq4NsFhfgXqCe1mX/tFYt4HQRKoZTAMNZGfnGR8Sx1TAMYz8HEBDRFt5iaWwCuW0hP+
         kFmOw/hJePlJ6qNHvbBdHTbyXptXYIPqj+Il/j0mL0tZTmOY3RYMh0WvWQbur+QqF0+m
         KAPQ0QmGWo5a1KqueaS3TXL4dapQ07/LkURD14dUUB799oS5ZOPoDD2183adkYFR3aar
         m1C3W7xpfYKnOeCbtVgf+0Mq9abfegs+Taf/c5WhzSrurN6b5LESH2QJwJIkgKTLAyLw
         Bs9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xqBz3eNyDUZXRDT/sBrEORRw8yLFnQSQre/jnFUfhGA=;
        b=Er8UVmqHtWa8DD9sglmy56jhXhpF4dnkMiIz9oQRW+1BOKy3ifX0LSEyTzPAghgDUw
         hJO1I1yJuhJnohJnHd/NK0X107apcuM42snvsK3Cv20+XjQ5YT+ps0iiUrKllxCR3BDG
         W0Y1Q2iwbvXdS95Gsp6jtupUigZmAPyAbxC4dWniTvOjeEj7IAb3p8Dh9zltrDxbN9Ct
         u6YVms9sKfdWzsKS+ilC19TVX2gfHndbL4/t5kJEIgiVgcLSGKUI9O9RSDXdfdqutRA7
         3f0a8ZY9Iw6gKMV+4viz/LFn5K9IAbW5BGGTGQkcl7Cw1sDYrmoly6P4+9eihoevQKcD
         8ICA==
X-Gm-Message-State: AOAM5316qK9Nv1+t4KeC2fjzu3mXrn5k8pELhd+Mn88jDwdPkRD1OXBM
        XDKrI9qsf7KSto/RQ9LADFRWSw==
X-Google-Smtp-Source: ABdhPJziPuW9/1zINhuPZAGTnlXdpWXiDSX+xD0+k+SCaxW1JORItNhnA+WG47sRmjNY69BUpJUp8A==
X-Received: by 2002:ac8:5c11:: with SMTP id i17mr11741918qti.64.1624034519941;
        Fri, 18 Jun 2021 09:41:59 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-211.dsl.bell.ca. [184.148.47.211])
        by smtp.googlemail.com with ESMTPSA id m126sm4332683qke.16.2021.06.18.09.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 09:41:59 -0700 (PDT)
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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
 <CAADnVQLO-r88OZEj93Bp_eOLi1zFu3Gfm7To+XtEN7Sj0ZpOMg@mail.gmail.com>
 <ec3a9381-7b15-e60f-86b6-87135393461d@mojatatu.com>
 <CAADnVQKi_3i6bOrYiDTLXwxhQnHDBJvHankqndzNP7eCJr27pQ@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <d2a23b1b-aa2e-ee55-fff7-89a59ea57c8e@mojatatu.com>
Date:   Fri, 18 Jun 2021 12:41:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQKi_3i6bOrYiDTLXwxhQnHDBJvHankqndzNP7eCJr27pQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-18 12:23 p.m., Alexei Starovoitov wrote:
> On Fri, Jun 18, 2021 at 7:50 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>

[..]
>> Alexei,
>> Tame the aggression, would you please?
>> You have no right to make claims as to who represents the community.
>> Absolutely none. So get off that high horse.
>>
>> I only mentioned the slides because it will be a good spot when
>> done which captures the issues. As i mentioned in i actually did
>> send some email (some Cced to you) but got no response.
>> I dont mind having a discussion but you have to be willing to
>> listen as well.
> 
> You've side tracked technical discussion to promote your own conference.
> That's not acceptable. Please use other forums for marketing.
 >
> This mailing list is for technical discussions.

I just made a statement in passing and you took it to a
tangent. If you are so righteous, why didnt you just stick
to making technical comments?
Stop making bold statements and then playing the victim.

cheers,
jamal
