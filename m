Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2AE39EBD0
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 04:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhFHCRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 22:17:54 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:4388 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhFHCRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 22:17:53 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FzYf150KCz6vSv;
        Tue,  8 Jun 2021 10:12:09 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 10:16:00 +0800
Received: from [10.174.179.215] (10.174.179.215) by
 dggema769-chm.china.huawei.com (10.1.198.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 10:15:59 +0800
Subject: Re: [PATCH net-next] tipc: Return the correct errno code
To:     <patchwork-bot+netdevbpf@kernel.org>,
        zhengyongjun <zhengyongjun3@huawei.com>
CC:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
References: <20210604014702.2087584-1-zhengyongjun3@huawei.com>
 <162284160438.23356.17911968954229324185.git-patchwork-notify@kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <410bbe52-5ead-4719-d711-8dc355a9a5f4@huawei.com>
Date:   Tue, 8 Jun 2021 10:15:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <162284160438.23356.17911968954229324185.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/6/5 5:20, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (refs/heads/master):

This should not be applied.

tipc_node_xmit() now check -ENOBUFS rather than -ENOMEM.

Yongjun, maybe you fix this now?

> 
> On Fri, 4 Jun 2021 09:47:02 +0800 you wrote:
>> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.
>>
>> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
>> ---
>>  net/tipc/link.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Here is the summary with links:
>   - [net-next] tipc: Return the correct errno code
>     https://git.kernel.org/netdev/net-next/c/0efea3c649f0
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> 
> .
> 
