Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F67F3ACDE2
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbhFROwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 10:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234383AbhFROwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 10:52:15 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CF3C06175F
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 07:50:04 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id r19so3668456qvw.5
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 07:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xugROgai1hDRqrla6F1TMCpSa/EBaupT4G6tJbJ5feA=;
        b=KP5Hnjf2Z2Hsaa9wSsGpRGlA7nf0EXHywcHY2h7boPODHyDvB+ZaKL5GkQ9hFyRzr+
         pWqIYdiLt1pN6OXG+2J8jFS5QO4RJJbJzHLkjQ4ATTQteHZWmnLXYS+n4uSdxjDdhaWt
         9/kXtGotrSEUUyt2bsSkwrZok7LxvNbf4ovKLEcwNfAUjyvaP1YuG9d5YmO69migLCc+
         iz7rZN+8utNxRulUGpVGuPk/zJ7dyIIky0+c7OHyF7QOT7Qc4+M6St5gVKXGQMuHZKAK
         xiBRi1A3253LPY15CPrXms26N+PxNawpcC6DUZaIEFba01TW01BbIumE5savHAD8bHMS
         pNcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xugROgai1hDRqrla6F1TMCpSa/EBaupT4G6tJbJ5feA=;
        b=hGK3pixUKO87RSuGnNpWZdeSY5ylZDbRRJNZxg9F5WRnjwKc1HEmeeykw4517py3Me
         /1JN7ft99uTOTuWXwdoGouWMZD/pPk6MI/j5GD3unqX56zBuOtJwydRc1oOktTYVZRf8
         0F6doGFSdMkYaec2lKglEzpwz2evoW7XQuVp7h5vTwvwDFx73rp/JLp3d14EH/J/dv2h
         Y1bbiBP+hDeVQRq3Q+9D3XgnNQaEJdd70SAS/va92hyi57SqNq5YZgm8NtSXBdpdLWbM
         urrJ+cPcMOjWpaEtrLfq6iWDrPlJwdg8FNl/LTFxYKREcAUYCtK6RAwjV9I7zGWd6/jB
         f+Og==
X-Gm-Message-State: AOAM530qUymUrOqARFJvafCxvn9D4cMr5bHT863XmIUOUZjprrB0rUs+
        6GgkoKCmICQe6fUEeBXSfrQmzg==
X-Google-Smtp-Source: ABdhPJxCm0L+Ug2xyNCYEau2Lv5uFkEpis64reBWiuncwGgYVPAop/EUlY+yE0SEWJlNIDJzVIhvLg==
X-Received: by 2002:a0c:e8cd:: with SMTP id m13mr6084488qvo.52.1624027804075;
        Fri, 18 Jun 2021 07:50:04 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-211.dsl.bell.ca. [184.148.47.211])
        by smtp.googlemail.com with ESMTPSA id i67sm4203656qkd.90.2021.06.18.07.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 07:50:03 -0700 (PDT)
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
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <ec3a9381-7b15-e60f-86b6-87135393461d@mojatatu.com>
Date:   Fri, 18 Jun 2021 10:50:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQLO-r88OZEj93Bp_eOLi1zFu3Gfm7To+XtEN7Sj0ZpOMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-18 10:38 a.m., Alexei Starovoitov wrote:
> On Fri, Jun 18, 2021 at 4:40 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>
>> We are going to present some of the challenges we faced in a subset
>> of our work in an approach to replace iptables at netdev 0x15
>> (hopefully we get accepted).
> 
> Jamal,
> please stop using netdev@vger mailing list to promote a conference
> that does NOT represent the netdev kernel community.
 >
> Slides shown at that conference is a non-event as far as this discussion goes.

Alexei,
Tame the aggression, would you please?
You have no right to make claims as to who represents the community.
Absolutely none. So get off that high horse.

I only mentioned the slides because it will be a good spot when
done which captures the issues. As i mentioned in i actually did
send some email (some Cced to you) but got no response.
I dont mind having a discussion but you have to be willing to
listen as well.


cheers,
jamal


