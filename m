Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3ACA3F8179
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 06:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhHZEGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 00:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhHZEGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 00:06:52 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7D3C061757;
        Wed, 25 Aug 2021 21:06:05 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id oc2-20020a17090b1c0200b00179e56772d6so5652236pjb.4;
        Wed, 25 Aug 2021 21:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N16RKnUBx3phhWrpfZGU8bqm0CgY23oxoM9EgaIfVmw=;
        b=inJL4C+amEqXewa2Rc0U4g2vrwjLtbaLLFQ1N/KY7NtVNXbaomLm05qmUrWnRYfbAu
         QiqnY7O5AgRDCUFmxb8+P25rW/BXymUNTQVvEh0GALLT25We/ajMcPwbigRvFKZAfUqm
         QrvBd+0SWL+uw2uPaTaS1QE+wlwvsR/3QlzFkn6/5HHo5z48LiLJX3q4p6gP7Wf0Bkmk
         iwthRKXapDwz3pt1mPyx4hXf4aRB1WGpRic3oNuQojkS1E2I3Dl8Ccfc0XcBrGXsyBoj
         5P9O9BCJXwwfS5ShBqgjWQaIZ91sOtG97WughmTirOYSmNwPrlEsL2KFm3k6Z9JrGyVr
         9vXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N16RKnUBx3phhWrpfZGU8bqm0CgY23oxoM9EgaIfVmw=;
        b=BrK65VtZQwUDgZ/iO+Fx7Zrx5Pp1tB9vU5dsIQBheV4f3qu6/dh0H02qIxFeeQNAQY
         qRG/KTDW12hlQyvDFja+WxXRYflXkSh3QV7OrYPZuKpkB3DaTN3b5mZAiQbJy6VsGZUJ
         4eH2JaaEyn5OVQ0+d6VwP/8OG+gnCBeOJjc/L8pnzYgd3tTLg4Nfbfvhfin9516PYcEM
         4LGAPzrytHdnEYf3ek67SGGjqbvhxZHuWtX2arkT7xTNcLEluKK1ywwKLj/StEMbAQOl
         MbB5SS2qfacgOFI2mEQts4+l/g5M0VBIgRentoelPJ5+m2KE61x6kJbKtFLEDI8leN7N
         /8Fg==
X-Gm-Message-State: AOAM532EgjuZdj9I82cCAhD+ZOFRPTjOrtXiBD6eJvy1lSBSAIGpAnNe
        fy84owI6JLg8inC37m2YGdw=
X-Google-Smtp-Source: ABdhPJwvOq8Z9Vd5RrqOn/Y6ERgkcHEfA1yPjfNi4dpchaixmO68J2qRQh2aEksvfAxABwAm0dgsUg==
X-Received: by 2002:a17:90a:404a:: with SMTP id k10mr1904704pjg.145.1629950765370;
        Wed, 25 Aug 2021 21:06:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:647:5e00:7920:50c4:c83a:d55e:e023])
        by smtp.googlemail.com with ESMTPSA id f5sm7541989pjw.20.2021.08.25.21.06.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 21:06:04 -0700 (PDT)
Subject: Re: [Linuxarm] Re: [PATCH RFC 0/7] add socket to netdev page frag
 recycling support
To:     Eric Dumazet <edumazet@google.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linuxarm@openeuler.org,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        "Tang, Feng" <feng.tang@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        mcroce@microsoft.com, Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        wenxu <wenxu@ucloud.cn>, Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        chenhao288@hisilicon.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, memxor@gmail.com,
        linux@rempel-privat.de, Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        aahringo@redhat.com, ceggers@arri.de, yangbo.lu@nxp.com,
        Florian Westphal <fw@strlen.de>, xiangxia.m.yue@gmail.com,
        linmiaohe <linmiaohe@huawei.com>, Christoph Hellwig <hch@lst.de>
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
 <CANn89iJDf9uzSdqLEBeTeGB1uAxvmruKfK5HbeZWp+Cdc+qggQ@mail.gmail.com>
 <2cf4b672-d7dc-db3d-ce90-15b4e91c4005@huawei.com>
 <4b2ad6d4-8e3f-fea9-766e-2e7330750f84@huawei.com>
 <CANn89iK0nMG3qq226aL-urrtPF5jBN6UQCV=ckTmAFqWgy5kiA@mail.gmail.com>
 <5fdc5223-7d67-fed7-f691-185dcb2e3d80@gmail.com>
 <CANn89iKqijGU_0dQMeyMJ2h2MJE3=fLm8qb456G3ZD_7TrLt_A@mail.gmail.com>
 <2d2154f4-c735-a9b3-7940-f8830fee6229@gmail.com>
 <CANn89iLa4QnA-hOJVVrAZLZs-pLr66-K+fRjB9vTjqgz_aAmnA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dd74d689-ebc8-3356-4a4f-d423a6aee4a6@gmail.com>
Date:   Wed, 25 Aug 2021 21:05:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLa4QnA-hOJVVrAZLZs-pLr66-K+fRjB9vTjqgz_aAmnA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 10:24 AM, Eric Dumazet wrote:
> On Wed, Aug 25, 2021 at 9:39 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 8/25/21 9:32 AM, Eric Dumazet wrote:
> 
>>>
>>
>> thanks for the pointer. I need to revisit my past attempt to get iperf3
>> working with hugepages.
> 
> ANother pointer, just in case this helps.
> 
> commit 72653ae5303c626ca29fcbcbb8165a894a104adf
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Thu Aug 20 10:11:17 2020 -0700
> 
>     selftests: net: tcp_mmap: Use huge pages in send path
> 

very helpful. Thanks. Added support to iperf3, and it does show a big
drop in cpu utilization.
