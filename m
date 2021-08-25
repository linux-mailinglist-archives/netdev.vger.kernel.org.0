Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12603F7A84
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240595AbhHYQaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239665AbhHYQ37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:29:59 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9DFC0613CF;
        Wed, 25 Aug 2021 09:29:12 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id c17so302907pgc.0;
        Wed, 25 Aug 2021 09:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sqeNXGhA3cye1rsmvOQ8m1ijfc+DLpUpqgAU3WM7aN4=;
        b=OrbxUpYEIiu7NIfew3ajuAEX9jeRcQHAr8imiwkrrbpLS2G/1fk8hZ6sBYyJuQRTid
         h/06Awkk2XomH/y33/Ohuvr0tBJ7wR+So1xBFDCsCjUIn8rJrsE4Mp0YPuBzqWN2A1Mr
         XN1QnZNArYu+ptSfUEcxQc1DJLBBENz2VNVUB92jV8IkRnpWYxDKnMbXknwkmbZzyo6+
         xKS5hyPUKGMAEIAwYTgv8PHWx5zy9m618JBlJ9ofKy4MxxKYORtbbL/Xd4+zUBn4Cey/
         KYtI6w+Rgoxpx1xujAEfGRMYiBczvdY8zuKpr6ZnejX5FLaOrFYtFMjVNTNvPcXQYt1z
         /D7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sqeNXGhA3cye1rsmvOQ8m1ijfc+DLpUpqgAU3WM7aN4=;
        b=jJFsnwACOr36Vx8TJPA3avqf8T0rTXadFwHEYifjNJBSeiy4O5o4sR0yHiwkpC8o15
         DQb0s1Tw+POJh6WGycMQSVDZVwb/DiPOsH5Qq3AgNAN14d/dQDq3zogJxGA3BiXKiqG9
         a2gFv6mLm6pP7MP0RiOG43ETtaBbk8/wuNkoB0UsjCx78dN5Wnah+jMmsTR9a8jXGdBU
         RknjbAsUHf1ejEgnE0FhNld2vhfCBbVKiIRh5ALaYAMC5RGy3/s6kqqqd8ANkl4At6P1
         sCFIp4VwGz3nTw7620eIrnCps2naKBWZ8x9LJ6YbjO8dx7HTEv44jWIzx65qjgVujXZd
         39pw==
X-Gm-Message-State: AOAM531xSmSRDPUVWbOrABVPpZwzu0N7dcqo8s2Ds+f/zJas0Qe8vK9y
        +/hxvF8tI2YXPCKr8+giqOo=
X-Google-Smtp-Source: ABdhPJyp1GSn7DJWZmmufrA+tyes3YmkjmDkWuHBiZ49/Hmzz5Ryn3lrUoGHZxePMk67afl6OS6sQA==
X-Received: by 2002:aa7:8d11:0:b0:3ef:9c79:405d with SMTP id j17-20020aa78d11000000b003ef9c79405dmr3832497pfe.72.1629908952097;
        Wed, 25 Aug 2021 09:29:12 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id a66sm300826pfa.59.2021.08.25.09.29.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:29:11 -0700 (PDT)
Subject: Re: [Linuxarm] Re: [PATCH RFC 0/7] add socket to netdev page frag
 recycling support
To:     Eric Dumazet <edumazet@google.com>,
        Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5fdc5223-7d67-fed7-f691-185dcb2e3d80@gmail.com>
Date:   Wed, 25 Aug 2021 09:29:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CANn89iK0nMG3qq226aL-urrtPF5jBN6UQCV=ckTmAFqWgy5kiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/21 8:04 AM, Eric Dumazet wrote:
>>
>>
>> It seems PAGE_ALLOC_COSTLY_ORDER is mostly related to pcp page, OOM, memory
>> compact and memory isolation, as the test system has a lot of memory installed
>> (about 500G, only 3-4G is used), so I used the below patch to test the max
>> possible performance improvement when making TCP frags twice bigger, and
>> the performance improvement went from about 30Gbit to 32Gbit for one thread
>> iperf tcp flow in IOMMU strict mode,
> 
> This is encouraging, and means we can do much better.
> 
> Even with SKB_FRAG_PAGE_ORDER  set to 4, typical skbs will need 3 mappings
> 
> 1) One for the headers (in skb->head)
> 2) Two page frags, because one TSO packet payload is not a nice power-of-two.

interesting observation. I have noticed 17 with the ZC API. That might
explain the less than expected performance bump with iommu strict mode.

> 
> The first issue can be addressed using a piece of coherent memory (128
> or 256 bytes per entry in TX ring).
> Copying the headers can avoid one IOMMU mapping, and improve IOTLB
> hits, because all
> slots of the TX ring buffer will use one single IOTLB slot.
> 
> The second issue can be solved by tweaking a bit
> skb_page_frag_refill() to accept an additional parameter
> so that the whole skb payload fits in a single order-4 page.
> 
> 
