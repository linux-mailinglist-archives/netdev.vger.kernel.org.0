Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A888F37F1A5
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 05:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhEMD0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 23:26:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5105 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhEMD0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 23:26:40 -0400
Received: from dggeml758-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FgcRg0mnMzYhMM;
        Thu, 13 May 2021 11:22:55 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml758-chm.china.huawei.com (10.1.199.159) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 13 May 2021 11:25:23 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 13 May
 2021 11:25:23 +0800
Subject: Re: [PATCH net-next v4 1/4] mm: add a signature in struct page
To:     Matthew Wilcox <willy@infradead.org>
CC:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Networking <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        "Vinay Kumar Yadav" <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
 <20210511133118.15012-2-mcroce@linux.microsoft.com>
 <YJqKfNh6l3yY2daM@casper.infradead.org> <YJqQgYSWH2qan1GS@apalos.home>
 <YJqSM79sOk1PRFPT@casper.infradead.org>
 <CAC_iWj+Tw9DzzzVj-F9AwzBN_OJV_HN2miJT4KTBH_Uei_V2ZA@mail.gmail.com>
 <YJv65eER2qgaP9Ib@casper.infradead.org>
 <3f9a0fb0-9cb9-686d-e89b-ea589d88ab58@huawei.com>
 <YJyQYCj3UUk5Sp4Z@casper.infradead.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <8f815871-e384-3e65-56a8-39e379dea4ce@huawei.com>
Date:   Thu, 13 May 2021 11:25:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YJyQYCj3UUk5Sp4Z@casper.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/13 10:35, Matthew Wilcox wrote:
> On Thu, May 13, 2021 at 10:15:26AM +0800, Yunsheng Lin wrote:
>> On 2021/5/12 23:57, Matthew Wilcox wrote:
>>> You'll need something like this because of the current use of
>>> page->index to mean "pfmemalloc".
>>>
>>> @@ -1682,12 +1684,12 @@ static inline bool page_is_pfmemalloc(const struct page *page)
>>>   */
>>>  static inline void set_page_pfmemalloc(struct page *page)
>>>  {
>>> -	page->index = -1UL;
>>> +	page->compound_head = 2;
>>
>> Is there any reason why not use "page->compound_head |= 2"? as
>> corresponding to the "page->compound_head & 2" in the above
>> page_is_pfmemalloc()?
>>
>> Also, this may mean we need to make sure to pass head page or
>> base page to set_page_pfmemalloc() if using
>> "page->compound_head = 2", because it clears the bit 0 and head
>> page ptr for tail page too, right?
> 
> I think what you're missing here is that this page is freshly allocated.
> This is information being passed from the page allocator to any user
> who cares to look at it.  By definition, it's set on the head/base page, and
> there is nothing else present in the page->compound_head.  Doing an OR
> is more expensive than just setting it to 2.

Thanks for clarifying.

> 
> I'm not really sure why set/clear page_pfmemalloc are defined in mm.h.
> They should probably be in mm/page_alloc.c where nobody else would ever
> think that they could or should be calling them.>
>>>  		struct {	/* page_pool used by netstack */
>>> -			/**
>>> -			 * @dma_addr: might require a 64-bit value on
>>> -			 * 32-bit architectures.
>>> -			 */
>>> +			unsigned long pp_magic;
>>> +			struct page_pool *pp;
>>> +			unsigned long _pp_mapping_pad;
>>>  			unsigned long dma_addr[2];
>>
>> It seems the dma_addr[1] aliases with page->private, and
>> page_private() is used in skb_copy_ubufs()?
>>
>> It seems we can avoid using page_private() in skb_copy_ubufs()
>> by using a dynamic allocated array to store the page ptr?
> 
> This is why I hate it when people use page_private() instead of
> documenting what they're doing in struct page.  There is no way to know
> (as an outsider to networking) whether the page in skb_copy_ubufs()
> comes from page_pool.  I looked at it, and thought it didn't:
> 
>                 page = alloc_page(gfp_mask);
> 
> but if you say those pages can come from page_pool, I believe you.

page_private() using in skb_copy_ubufs() does indeed seem ok here.
the page_private() is used on the page which is freshly allocated
from alloc_page().

Sorry for the confusion.

> 
> .
> 

