Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814473F7AD1
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242102AbhHYQjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240886AbhHYQjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:39:47 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DAFC0613C1;
        Wed, 25 Aug 2021 09:39:01 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id z24-20020a17090acb1800b0018e87a24300so260194pjt.0;
        Wed, 25 Aug 2021 09:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qEOWu+zwohAyeu48YPyKnHBf3B+akMU6aVJL4Wj/tUI=;
        b=QVddfosZgWmm7j+1/jpygURVNj2qGTghH6wrY+RVQFiW+QMhG9Eidjpe6+fwp3ZvfY
         8WSZRH8HTu89Kb+jNWGj0Mb6Mxq5iBdBMhYfa8wbnTbpFlZB0veIAfCTd4w5QIkEgtGr
         9ueCand8dHdd05NKnyvAOK5xeGHtuwWdrAjKzr27SlSQY+GecI7Qh9spW5v0Sw36IzNp
         JZ2/piSnL4ALFSrTz8arRAKC/NaLUgugp17jwOf4Fpg2otEVdoozLQXav2pPZnyi1ZtP
         Cg41oQOlT1NPo/zjslN40j302DV/W8VpdkMLc+qJ3XyGtUNlPhghyinZJw5LdWV3r5a7
         OPAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qEOWu+zwohAyeu48YPyKnHBf3B+akMU6aVJL4Wj/tUI=;
        b=ghHWUFEBaYtKjb87X8XQODJLPcGiwA3T+YjSlCkJWOQGOKsLHLHOIa0AEyFFec7lc4
         MkLICmBPS80ww6af4MrDZFaULJZ4KV3iZUzPrRZzc1yUlySrGfsyzb2lyKdtNNg9MJzN
         PudT8H+YucSmPP4+UG5kGrceLIwu2I86dfXK2oSsmKHDuAM6FEDmOSJ7aieLenX9ecGe
         HFlSJq3wOrs2OyVaLnV7UOdveD2OrM+gsbJhSFM0iLBfMG3W68A59RmtIDMrtfrAQHKi
         UGt31IH3Vh32G/n7D0b28wGMpiVF0ls+IAkOOvLkPF2zujoYK056YNire+RTv27PGsOt
         EdEg==
X-Gm-Message-State: AOAM5317wz4w95mBGSpCiNY9L7XoXO78RtvgcT1TY6atwk2RmJL4TUhy
        6T1K2yyesQU1D0Ti1fO0p+0=
X-Google-Smtp-Source: ABdhPJyymv0k+c/asCnQfBBkV+V3fVpGcLmiG3uI9TJut2L2RYKfCp4c6QsBnPC2zKDTgb1eJ10amg==
X-Received: by 2002:a17:90b:1e02:: with SMTP id pg2mr1660891pjb.37.1629909540919;
        Wed, 25 Aug 2021 09:39:00 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id o15sm544177pgr.64.2021.08.25.09.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:39:00 -0700 (PDT)
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2d2154f4-c735-a9b3-7940-f8830fee6229@gmail.com>
Date:   Wed, 25 Aug 2021 09:38:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKqijGU_0dQMeyMJ2h2MJE3=fLm8qb456G3ZD_7TrLt_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 9:32 AM, Eric Dumazet wrote:
> On Wed, Aug 25, 2021 at 9:29 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 8/23/21 8:04 AM, Eric Dumazet wrote:
>>>>
>>>>
>>>> It seems PAGE_ALLOC_COSTLY_ORDER is mostly related to pcp page, OOM, memory
>>>> compact and memory isolation, as the test system has a lot of memory installed
>>>> (about 500G, only 3-4G is used), so I used the below patch to test the max
>>>> possible performance improvement when making TCP frags twice bigger, and
>>>> the performance improvement went from about 30Gbit to 32Gbit for one thread
>>>> iperf tcp flow in IOMMU strict mode,
>>>
>>> This is encouraging, and means we can do much better.
>>>
>>> Even with SKB_FRAG_PAGE_ORDER  set to 4, typical skbs will need 3 mappings
>>>
>>> 1) One for the headers (in skb->head)
>>> 2) Two page frags, because one TSO packet payload is not a nice power-of-two.
>>
>> interesting observation. I have noticed 17 with the ZC API. That might
>> explain the less than expected performance bump with iommu strict mode.
> 
> Note that if application is using huge pages, things get better after
> 
> commit 394fcd8a813456b3306c423ec4227ed874dfc08b
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Thu Aug 20 08:43:59 2020 -0700
> 
>     net: zerocopy: combine pages in zerocopy_sg_from_iter()
> 
>     Currently, tcp sendmsg(MSG_ZEROCOPY) is building skbs with order-0
> fragments.
>     Compared to standard sendmsg(), these skbs usually contain up to
> 16 fragments
>     on arches with 4KB page sizes, instead of two.
> 
>     This adds considerable costs on various ndo_start_xmit() handlers,
>     especially when IOMMU is in the picture.
> 
>     As high performance applications are often using huge pages,
>     we can try to combine adjacent pages belonging to same
>     compound page.
> 
>     Tested on AMD Rome platform, with IOMMU, nominal single TCP flow speed
>     is roughly doubled (~55Gbit -> ~100Gbit), when user application
>     is using hugepages.
> 
>     For reference, nominal single TCP flow speed on this platform
>     without MSG_ZEROCOPY is ~65Gbit.
> 
>     Signed-off-by: Eric Dumazet <edumazet@google.com>
>     Cc: Willem de Bruijn <willemb@google.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Ideally the gup stuff should really directly deal with hugepages, so
> that we avoid
> all these crazy refcounting games on the per-huge-page central refcount.
> 

thanks for the pointer. I need to revisit my past attempt to get iperf3
working with hugepages.
