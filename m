Return-Path: <netdev+bounces-2984-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD289704DAA
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 661C11C20DE1
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A215261CD;
	Tue, 16 May 2023 12:22:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD4B24EA6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:22:38 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F304C26
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 05:22:36 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QLFd26pcQzqSNr;
	Tue, 16 May 2023 20:18:14 +0800 (CST)
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 16 May
 2023 20:22:34 +0800
Subject: Re: [PATCH net-next 4/4] net: hns3: clear hns unused parameter alarm
To: Simon Horman <simon.horman@corigine.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
 <20230515134643.48314-5-lanhao@huawei.com> <ZGKPfM5ctobTcguU@corigine.com>
CC: <netdev@vger.kernel.org>, <yisen.zhuang@huawei.com>,
	<salil.mehta@huawei.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <richardcochran@gmail.com>,
	<wangpeiyang1@huawei.com>, <shenjian15@huawei.com>, <chenhao418@huawei.com>,
	<wangjie125@huawei.com>, <yuanjilin@cdjrlc.com>, <cai.huoqing@linux.dev>,
	<xiujianfeng@huawei.com>
From: Hao Lan <lanhao@huawei.com>
Message-ID: <9cfbf2fc-3cf9-f7f9-ff4a-405c224ec392@huawei.com>
Date: Tue, 16 May 2023 20:22:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZGKPfM5ctobTcguU@corigine.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/5/16 4:01, Simon Horman wrote:
> On Mon, May 15, 2023 at 09:46:43PM +0800, Hao Lan wrote:
>> From: Peiyang Wang <wangpeiyang1@huawei.com>
>>
>> Several functions in the hns3 driver have unused parameters.
>> The compiler will warn about them when building
>> with -Wunused-parameter option of hns3.
>>
>> Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
>> Signed-off-by: Hao Lan <lanhao@huawei.com>
> 
> ...
> 
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
>> index 1b360aa52e5d..8c0016b359b7 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
>> @@ -693,7 +693,7 @@ static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
>>  
>>  /* iterator for handling rings in ring group */
>>  #define hns3_for_each_ring(pos, head) \
>> -	for (pos = (head).ring; (pos); pos = (pos)->next)
>> +	for ((pos) = (head).ring; (pos); (pos) = (pos)->next)
> 
> Hi,
> 
> A minor nit from my side.
> 
> This hunk does not seem related to the topic of this patch.
> 

Hi,
Thank you for the review. It's really an oversight. We'll delete this hunk from this patch.

>>  
>>  #define hns3_get_handle(ndev) \
>>  	(((struct hns3_nic_priv *)netdev_priv(ndev))->ae_handle)
> 
> ...
> .
> 

