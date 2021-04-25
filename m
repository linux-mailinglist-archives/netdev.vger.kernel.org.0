Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6FB36A419
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 04:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhDYCQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 22:16:46 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17400 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhDYCQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 22:16:46 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FSWmW2KpqzlZBV;
        Sun, 25 Apr 2021 10:14:03 +0800 (CST)
Received: from [10.174.176.174] (10.174.176.174) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Sun, 25 Apr 2021 10:16:01 +0800
Subject: Re: [PATCH] net: sock: remove the unnecessary check in proto_register
To:     <patchwork-bot+netdevbpf@kernel.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
CC:     <netdev@vger.kernel.org>
References: <20210422134151.28905-1-xiangxia.m.yue@gmail.com>
 <161920920905.3258.13413289137138136442.git-patchwork-notify@kernel.org>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d45d51ca-ddb1-6ce4-0421-c5a3ee29864a@huawei.com>
Date:   Sun, 25 Apr 2021 10:16:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <161920920905.3258.13413289137138136442.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi:
On 2021/4/24 4:20, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (refs/heads/master):
> 
> On Thu, 22 Apr 2021 21:41:51 +0800 you wrote:
>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>
>> tw_prot_cleanup will check the twsk_prot.
>>
>> Fixes: 0f5907af3913 ("net: Fix potential memory leak in proto_register()")

Thanks for the patch. But I don't think this Fixes tag is needed as this is a cleanup
and do not fix anything.

Thanks.

>> Cc: Miaohe Lin <linmiaohe@huawei.com>
>> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>
>> [...]
> 
> Here is the summary with links:
>   - net: sock: remove the unnecessary check in proto_register
>     https://git.kernel.org/netdev/net-next/c/ed744d819379
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> 
> .
> 

