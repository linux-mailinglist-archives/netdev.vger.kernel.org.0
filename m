Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43071309EF6
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 21:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhAaUgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 15:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhAaUgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 15:36:03 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767CDC061574
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 12:35:20 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id es14so7231984qvb.3
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 12:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dZVoYvBEbjdRi+n/vXfZg27E1gnXAg6WXs8ZSgaW7tA=;
        b=TQ/fqoaUzgKgBg60lA0W4GROZWokCHwnNKxb1Hz4xdbgxOYBE9D0/gWgV4HdYcnFOS
         Y3Ois1Hw4PpwTRnIDx1/3/lVtbRA6I8+SHjomy8WA5aHZXg3pooVwwoG2Msr3FQNXU7T
         iYNZtG8+LdJDh4E/HTVfc1zAdV8b+elGCTwcKtat+gtWOgppOp9QQujpLHCzz3S2pZFe
         BXX4HXphOOlYrQEMPgm6UJOqet00SJVuSIElmuPNyqc8PIhBgQ1V4+z75j7KQJ0PsAJG
         eytTMqlcGjmogVjVAZEbjNc0BWwC9JH7CBfIBydatGFnk912cocIUxjrZmDQG4w++NLX
         dOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dZVoYvBEbjdRi+n/vXfZg27E1gnXAg6WXs8ZSgaW7tA=;
        b=dau0QVo5Tg6cYIAIRpg9lmbXtfbhEwCdJiLS0ntgNq0H2C+RrhfyfBFt80UlwpWvdI
         OxNG3vsQzmf6bJbwDcKsLAkk9NWWeK96mxIXCytZDumCvpCBCipLwxLTTMy8WdN3l65T
         3YGS3HU8/No0pPAX16kMuJYn3u9IDhGYMz9GIw/wF2+ZFovIT02M7uqhszGogZr9yJXp
         b0NLSoFi/xlbArXgni9bj35AZH6nMmopXXIq12zHtUuCnCloy3MNFsfgdxCpWj14g8Eq
         nlDvBI/Q+JI3roYK1jI3gvml6QZI2KrCbrxr8u4dGNkG8LUH+LqZnj7EEf9Gc5DXInN6
         fdyw==
X-Gm-Message-State: AOAM5312qx+Di33ixAdNXtVkFZ/7vw+akst6VpCpPLpmcC3BDB7uRvzM
        gtLHgizrjksz5t73LDhjegVPSA==
X-Google-Smtp-Source: ABdhPJw2ZPKML7GsFPQxA7G4z5QWK/N1CqAbyDPUNbJq6K35dtWCQZo2G94ZUj3vZNOHzwt9yKfSrw==
X-Received: by 2002:a05:6214:1110:: with SMTP id e16mr12585884qvs.62.1612125319251;
        Sun, 31 Jan 2021 12:35:19 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id d1sm5149128qtn.30.2021.01.31.12.35.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 12:35:18 -0800 (PST)
Subject: Re: [Patch bpf-next v5 1/3] bpf: introduce timeout hash map
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
 <20210122205415.113822-2-xiyou.wangcong@gmail.com>
 <d69d44ca-206c-d818-1177-c8f14d8be8d1@iogearbox.net>
 <CAM_iQpW8aeh190G=KVA9UEZ_6+UfenQxgPXuw784oxCaMfXjng@mail.gmail.com>
 <CAADnVQKmNiHj8qy1yqbOrf-OMyhnn8fKm87w6YMfkiDHkBpJVg@mail.gmail.com>
 <CAM_iQpXAQ7AMz34=o5E=81RFGFsQB5jCDTCCaVdHokU6kaJQsQ@mail.gmail.com>
 <20210129025435.a34ydsgmwzrnwjlg@ast-mbp.dhcp.thefacebook.com>
 <f7bc5873-7722-e359-b450-4db7dc3656d6@mojatatu.com>
 <dc5ddf32-2d65-15a9-9448-5f2d3a10d227@mojatatu.com>
 <CAADnVQJafr__W+oPvBjqisvh2vCRye8QkT9TQTFXH=wsDGtKqA@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <c4c6d889-d8ec-efe5-7fcb-aed9f5efa318@mojatatu.com>
Date:   Sun, 31 Jan 2021 15:35:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQJafr__W+oPvBjqisvh2vCRye8QkT9TQTFXH=wsDGtKqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-29 10:14 p.m., Alexei Starovoitov wrote:
> On Fri, Jan 29, 2021 at 6:14 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>
>> On 2021-01-29 9:06 a.m., Jamal Hadi Salim wrote:
>>
>>> Which leads to:
>>> Why not extend the general feature so one can register for optional
>>> callbacks not just for expire but also add/del/update on specific
>>> entries or table?
>>> add/del/update could be sourced from other kernel programs or user space
>>> and the callback would be invoked before an entry is added/deleted etc.
>>> (just like it is here for expiry).
>>
>> Sorry - shouldve read the rest of the thread:
>> Agree with Cong that you want per-map but there are use cases where you
>> want it per entry (eg the add/del/update case).
> 
> That was my point as well.
> bpf_timer api should be generic, so that users can do both.
> The program could use bpf_timer one for each flow and bpf_timer for each map.
> And timers without maps.

I like it. Sensible to also have callback invocations for map
changes i.e entry create/update/delete (maybe map create/destroy).

cheers,
jamal
