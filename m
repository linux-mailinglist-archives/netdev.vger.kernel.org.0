Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0E82A7599
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 03:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732407AbgKECjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 21:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgKECjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 21:39:24 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0CDC0613CF;
        Wed,  4 Nov 2020 18:39:23 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id t13so62711ilp.2;
        Wed, 04 Nov 2020 18:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0YNYyrDglorxKo4HUtp6cUV1k9Wdqqjmo1v9Wj/6S80=;
        b=r3kDXz8c6ci+xcANLXRqfMcolEU1Jmf4S52Zjdyhe0ugd3AEQUo5Gm4Hhcf94xNITp
         qF4er5JI/OpKY6qfF9wLnuZcS0PIB+AKIdy8evQe9ZRM0/aQLMRtKEtFVp8u2Fw8mHjb
         ZPppinzKpS5/o4y8k0wmKLsbDGZqrp+kLMwkv+FFPw1eydKl7dlwWM69+CV9c5lDC9k0
         cqiPeoYHy7DouWBns/6goiMwpW7up1O8xQ00Ht9zbgRSzARzoIs+88BBNhDMqIMQ0P6v
         uf1TdfvhsY97FxSNOHabok4jy8e1eZlcPc0SgcpqUNLQZ8zXBuxz9UjeGCVMTFowfgLo
         INhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0YNYyrDglorxKo4HUtp6cUV1k9Wdqqjmo1v9Wj/6S80=;
        b=Es9zJHqgPQRO8vCkwhH99D5owqNL4hIexCp6ndel5ahC7wRuxsPWsKh5Aug9nXcnFK
         ZuKRFg2peVxNLB4WTLxNr9/McfuWgVP1jGLA3t4MeaIkXuhGgL3ei4Hw6fzWvy+zlCMA
         cuTse/cI2jmRAWEWq4YBmurTMO24il8cckpTQqxgD+CxzTNIUrh+cDcCm3/HmyUsRMCV
         ynpOeE98Ykjva+kV6hUBEjgCqeXwPfLTmBKb0/tX0nHVQTbnrc87Nz+9Vg89LZnDct9S
         SQoQ2m/kWIx5A6B8ih2UmhrEyxM3HeCdzuAmKda39uf2IpayTrSQHS+aTzTx38sjubTG
         FwFA==
X-Gm-Message-State: AOAM532K4MpLBWoSAaHyW6FP0QLLWvaw/SghkNuN5nq8RKKOpI6WIxNt
        tiqP1d/Q6ZLQ20m/DNry1m0=
X-Google-Smtp-Source: ABdhPJzuwgh/i+fT/Flmnz2O7gEW/c1/smasUsaAnXYk2S+7zGHe6YtP9rke8DuIlF2Jh8izGOpjXQ==
X-Received: by 2002:a92:a808:: with SMTP id o8mr319971ilh.35.1604543963192;
        Wed, 04 Nov 2020 18:39:23 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:6dfd:4f87:68ce:497b])
        by smtp.googlemail.com with ESMTPSA id m9sm168426ioc.15.2020.11.04.18.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 18:39:22 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Jiri Benc <jbenc@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <ce441cb4-0e36-eae6-ca19-efebb6fb55f1@gmail.com>
 <20201104024559.gxullc7e6boaupuk@ast-mbp.dhcp.thefacebook.com>
 <20201104102816.472a9400@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <730c2c2a-d743-cedf-265e-a22e706f2882@gmail.com>
Date:   Wed, 4 Nov 2020 19:39:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201104102816.472a9400@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/20 2:28 AM, Jiri Benc wrote:
> On Tue, 3 Nov 2020 18:45:59 -0800, Alexei Starovoitov wrote:
>> libbpf is the only library I know that is backward and forward compatible.
> 
> This is great to hear. It means there will be no problem with iproute2
> using the system libbpf. As libbpf is both backward and forward
> compatible, iproute2 will just work with whatever version it is used
> with.

That is how I read that as well. The bpf team is making sure libbpf is a
stable, robust front-end to kernel APIs. That stability is what controls
the user experience. With the due diligence in testing, packages using
libbpf can have confidence that using an libbpf API is not going to
change release over release regardless of kernel version installed
(i.e., as kernel versions go newer from an OS start point - typical
scenario for a distribution).


> 
> The only problem would be if a particular function changed its
> semantics while retaining ABI. But since libbpf is backward and forward
> compatible, this should not happen.

exactly.

Then, If libbpf needs to change something that affects users, it bumps
the soname version.
