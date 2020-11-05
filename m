Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B3C2A7605
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 04:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388563AbgKEDTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 22:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731990AbgKEDTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 22:19:32 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73171C0613CF;
        Wed,  4 Nov 2020 19:19:30 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id p10so121524ile.3;
        Wed, 04 Nov 2020 19:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ieXOE+6edpx9/IxryG4IPFsJTE/8GyQPQvlpXXBPp/k=;
        b=JGTWCLWXFDGqBYyxf1Nom7sTHwHVvsjSYiFz0o4yI2wCb43vVXoXvxeoNnxSitrVvH
         PEB83eSkBa05atyC6QL8NYoBKvWE9wHPoi4PXWzP5yDB629VXwaxFCRJrZz1d0DT4h3i
         DNreOUpjK/3/65drCWuBHpTNedipQG7UgvKCHyNTEHMAs7ROKFboldAEwcV1krP4XrK9
         kjv8tofLAjUZNz7bJ6DvCRd9WaLtEUv69pAjJ0zUTnQ6EzOz20/HYi/29GVVEXQpZq5Q
         WaGX1Jyx1xKUW+bmbBqHlqrmduqeDc91Dn9gIVSehgSVcQ4RGxFJK5mTmNhBMvdwczDI
         KaeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ieXOE+6edpx9/IxryG4IPFsJTE/8GyQPQvlpXXBPp/k=;
        b=g0AntJC75bDAtK0TM+htr0ujndUO67gHwqB9Id+yijsjIfVabRXxTdLXFa+0wMcKdq
         u27RAIR57iX0IP2FssY9RL8O7Cuv7iOIPjyro/o6h1bD8tYLzVVG+G3XzUgJBB8PZvra
         kgoZ+D6Z01oVHAotSniQTVgL0wXUbz7T/WiXXqf/Q5hite9t0ITl3b38Qx3a6zmjiN3C
         cuvd2ZYWcwlzFGs7jcxhYRwC881qEpgpsPSxLRSIJ47TVQpKWS7niwYicYkkyss9AFRE
         eQRAFJXX3wWZ6SBiYkcTxemhRSjZzdKDd1xvn5asroeNOUwl6bliOg/atxJVMi7TCMf2
         EDwg==
X-Gm-Message-State: AOAM53197y0wxmFZreI/5fkm8Lo1qpcopuG/c5n8u9noWPiYp7+PavY2
        phFwPj17JbDATMD7fG15XNY=
X-Google-Smtp-Source: ABdhPJzVoh3PLVXIgP1TwYbQ76jUqLMA5CdpYmvMHmWKe1vlYTTV9izshqfNPzM1J9jSvF8rsKYO/A==
X-Received: by 2002:a92:d84a:: with SMTP id h10mr467896ilq.39.1604546369706;
        Wed, 04 Nov 2020 19:19:29 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:6dfd:4f87:68ce:497b])
        by smtp.googlemail.com with ESMTPSA id y2sm200481ioc.46.2020.11.04.19.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 19:19:28 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Daniel Borkmann <daniel@iogearbox.net>,
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ec50328d-61ab-71fb-f266-5e49e9dbf98e@gmail.com>
Date:   Wed, 4 Nov 2020 20:19:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/20 3:21 AM, Daniel Borkmann wrote:
> 
>> Then libbpf release process can incorporate proper testing of libbpf
>> and iproute2 combination.
>> Or iproute2 should stay as-is with obsolete bpf support.
>>
>> Few years from now the situation could be different and shared libbpf
>> would
>> be the most appropriate choice. But that day is not today.
> 
> Yep, for libbpf to be in same situation as libelf or libmnl basically
> feature
> development would have to pretty much come to a stop so that even minor
> or exotic
> distros get to a point where they ship same libbpf version as major
> distros where
> then users can start to rely on the base feature set for developing
> programs
> against it.

User experience keeps getting brought up, but I also keep reading the
stance that BPF users can not expect a consistent experience unless they
are constantly chasing latest greatest versions of *ALL* S/W related to
BPF. That is not a realistic expectation for users. Distributions exist
for a reason. They solve real packaging problems.

As libbpf and bpf in general reach a broader audience, the requirements
to use, deploy and even tryout BPF features needs to be more user
friendly and that starts with maintainers of the BPF code and how they
approach extensions and features. Telling libbpf consumers to make
libbpf a submodule of their project and update the reference point every
time a new release comes out is not user friendly.

Similarly, it is not realistic or user friendly to *require* general
Linux users to constantly chase latest versions of llvm, clang, dwarves,
bcc, bpftool, libbpf, (I am sure I am missing more), and, by extension
of what you want here, iproute2 just to upgrade their production kernel
to say v5.10, the next LTS, or to see what relevant new ebpf features
exists in the new kernel. As a specific example BTF extensions are added
in a way that is all or nothing. Meaning, you want to compile kernel
version X with CONFIG_DEBUG_INFO_BTF enabled, update your toolchain.
Sure, you are using the latest LTS of $distro, and it worked fine with
kernel version X-1 last week, but now compile fails completely unless
the pahole version is updated. Horrible user experience. Again, just an
example and one I brought up in July. I am sure there more.

Linux APIs are about stability and consistency. Commands and libraries
that work on v5.9 should work exactly the same on v5.10, 5.11, 5.12, ...
*IF* I want a new feature (kernel, bpf or libbpf), then the requirement
to upgrade is justified. But if I am just updating my kernel, or
updating my compiler, or updating iproute2 because I want to try out
some new nexthop feature, I should not be cornered into an all or
nothing scheme.
