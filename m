Return-Path: <netdev+bounces-11257-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BE237324AE
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 03:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAB901C20F24
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 01:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB92262A;
	Fri, 16 Jun 2023 01:34:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F56627;
	Fri, 16 Jun 2023 01:34:33 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC832947;
	Thu, 15 Jun 2023 18:34:31 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.56])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Qj1pN1CRWzMn87;
	Fri, 16 Jun 2023 09:31:24 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 09:34:29 +0800
Subject: Re: [PATCH net-next] xsk: Remove unused inline function
 xsk_buff_discard()
To: Simon Horman <simon.horman@corigine.com>, Maciej Fijalkowski
	<maciej.fijalkowski@intel.com>
CC: <bjorn@kernel.org>, <magnus.karlsson@intel.com>,
	<jonathan.lemon@gmail.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <ast@kernel.org>,
	<daniel@iogearbox.net>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
	<netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <maxtram95@gmail.com>
References: <20230615124612.37772-1-yuehaibing@huawei.com>
 <ZIsW47S1Pdzqxkxt@boxer> <ZIsXdcawAWc/9Izo@boxer>
 <ZIsiyKfr/WdzKlji@corigine.com>
From: YueHaibing <yuehaibing@huawei.com>
Message-ID: <ca6b43b1-5b54-51c3-01f7-0cee6189e4be@huawei.com>
Date: Fri, 16 Jun 2023 09:34:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZIsiyKfr/WdzKlji@corigine.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/15 22:40, Simon Horman wrote:
> On Thu, Jun 15, 2023 at 03:51:49PM +0200, Maciej Fijalkowski wrote:
>> On Thu, Jun 15, 2023 at 03:49:23PM +0200, Maciej Fijalkowski wrote:
>>> On Thu, Jun 15, 2023 at 08:46:12PM +0800, YueHaibing wrote:
>>>> commit f2f167583601 ("xsk: Remove unused xsk_buff_discard")
>>>> left behind this, remove it.
>>>>
>>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>>
>>> Yeah this is a stub for !CONFIG_XDP_SOCKETS...
>>
>> Wait, I am not sure if this should go to bpf tree and have fixes tag
>> pointing to the cited commit?
>>
>> Functionally this commit does not fix anything but it feels that
>> f2f167583601 was incomplete.
> 
> FWIIW, I think that bpf-next is appropriate for this patch
> as it doesn't address a bug.

Ok , will send v2 target to bpf-next.
> .
> 

