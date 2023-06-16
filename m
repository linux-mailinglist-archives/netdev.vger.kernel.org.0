Return-Path: <netdev+bounces-11431-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D90873310E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:21:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C4822817AA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C9219922;
	Fri, 16 Jun 2023 12:21:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B249A1428F
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:21:12 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB27358C;
	Fri, 16 Jun 2023 05:20:59 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QjJ642Bt3z18MFb;
	Fri, 16 Jun 2023 20:15:56 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 16 Jun
 2023 20:20:55 +0800
Subject: Re: [PATCH net-next v4 4/5] page_pool: remove PP_FLAG_PAGE_FRAG flag
To: Alexander Duyck <alexander.duyck@gmail.com>, Jakub Kicinski
	<kuba@kernel.org>
CC: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>, Yisen
 Zhuang <yisen.zhuang@huawei.com>, Salil Mehta <salil.mehta@huawei.com>, Eric
 Dumazet <edumazet@google.com>, Sunil Goutham <sgoutham@marvell.com>, Geetha
 sowjanya <gakula@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>,
	hariprasad <hkelam@marvell.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, Felix Fietkau <nbd@nbd.name>, Ryder Lee
	<ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang
	<sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>, Matthias Brugger
	<matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	<linux-rdma@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mediatek@lists.infradead.org>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
 <20230612130256.4572-5-linyunsheng@huawei.com>
 <20230614101954.30112d6e@kernel.org>
 <8c544cd9-00a3-2f17-bd04-13ca99136750@huawei.com>
 <20230615095100.35c5eb10@kernel.org>
 <CAKgT0Uc6Xoyh3Edgt+83b+HTM5j4JDr3fuxcyL9qDk+Wwt9APg@mail.gmail.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <908b8b17-f942-f909-61e6-276df52a5ad5@huawei.com>
Date: Fri, 16 Jun 2023 20:20:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAKgT0Uc6Xoyh3Edgt+83b+HTM5j4JDr3fuxcyL9qDk+Wwt9APg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/16 2:26, Alexander Duyck wrote:
> On Thu, Jun 15, 2023 at 9:51 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Thu, 15 Jun 2023 15:17:39 +0800 Yunsheng Lin wrote:
>>>> Does hns3_page_order() set a good example for the users?
>>>>
>>>> static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
>>>> {
>>>> #if (PAGE_SIZE < 8192)
>>>>     if (ring->buf_size > (PAGE_SIZE / 2))
>>>>             return 1;
>>>> #endif
>>>>     return 0;
>>>> }
>>>>
>>>> Why allocate order 1 pages for buffers which would fit in a single page?
>>>> I feel like this soft of heuristic should be built into the API itself.
>>>
>>> hns3 only support fixed buf size per desc by 512 byte, 1024 bytes, 2048 bytes
>>> 4096 bytes, see hns3_buf_size2type(), I think the order 1 pages is for buf size
>>> with 4096 bytes and system page size with 4K, as hns3 driver still support the
>>> per-desc ping-pong way of page splitting when page_pool_enabled is false.
>>>
>>> With page pool enabled, you are right that order 0 pages is enough, and I am not
>>> sure about the exact reason we use the some order as the ping-pong way of page
>>> splitting now.
>>> As 2048 bytes buf size seems to be the default one, and I has not heard any one
>>> changing it. Also, it caculates the pool_size using something as below, so the
>>> memory usage is almost the same for order 0 and order 1:
>>>
>>> .pool_size = ring->desc_num * hns3_buf_size(ring) /
>>>               (PAGE_SIZE << hns3_page_order(ring)),
>>>
>>> I am not sure it worth changing it, maybe just change it to set good example for
>>> the users:) anyway I need to discuss this with other colleague internally and do
>>> some testing before doing the change.
>>
>> Right, I think this may be a leftover from the page flipping mode of
>> operation. But AFAIU we should leave the recycling fully to the page
>> pool now. If we make any improvements try to make them at the page pool
>> level.

I checked, the per-desc buf with 4096 bytes for hnse does not seem to
be used mainly because of the larger memory usage you mentioned below.

>>
>> I like your patches as they isolate the drivers from having to make the
>> fragmentation decisions based on the system page size (4k vs 64k but
>> we're hearing more and more about ARM w/ 16k pages). For that use case
>> this is great.

Yes, That is my point. For hw case, the page splitting in page pool is
mainly to enble multi-descs to use the same page as my understanding.

>>
>> What we don't want is drivers to start requesting larger page sizes
>> because it looks good in iperf on a freshly booted, idle system :(
> 
> Actually that would be a really good direction for this patch set to
> look at going into. Rather than having us always allocate a "page" it
> would make sense for most drivers to allocate a 4K fragment or the
> like in the case that the base page size is larger than 4K. That might
> be a good use case to justify doing away with the standard page pool
> page and look at making them all fragmented.

I am not sure if I understand the above, isn't the frag API able to
support allocating a 4K fragment when base page size is larger than
4K before or after this patch? what more do we need to do?

> 
> In the case of the standard page size being 4K a standard page would
> just have to take on the CPU overhead of the atomic_set and
> atomic_read for pp_ref_count (new name) which should be minimal as on
> most sane systems those just end up being a memory write and read.

If I understand you correctly, I think what you are trying to do
may break some of Jesper' benchmarking:)

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c

> .
> 

