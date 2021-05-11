Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF86379C3A
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 03:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhEKBpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 21:45:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2763 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhEKBpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 21:45:11 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FfLGd0G1mzmg21;
        Tue, 11 May 2021 09:40:41 +0800 (CST)
Received: from [127.0.0.1] (10.174.177.72) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0; Tue, 11 May 2021
 09:43:57 +0800
Subject: Re: [PATCH 1/1] forcedeth: Delete a redundant condition branch
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20210510135656.3960-1-thunder.leizhen@huawei.com>
 <YJmQufHgq6WlRz4Q@lunn.ch>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <20f15fbc-347f-b76d-24f4-da08f76fd603@huawei.com>
Date:   Tue, 11 May 2021 09:43:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YJmQufHgq6WlRz4Q@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.72]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/5/11 3:59, Andrew Lunn wrote:
> On Mon, May 10, 2021 at 09:56:56PM +0800, Zhen Lei wrote:
>> The statement of the last "if (adv_lpa & LPA_10HALF)" branch is the same
>> as the "else" branch. Delete it to simplify code.
>>
>> No functional change.
>>
>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> 
> Hi Zhen
> 
> Could you teach your bot to check lore.kernel.org and see if the same
> patch has been submitted before? If it has, there is probably a reason
> why it was rejected. You need to check if that reason it still true.

This is a tool that comes with the kernel. Now it's all about manual
Google searches to see if someone has posted it. So there could be a
mistake.

Although the compiler can optimize this "if" branch, but I think those
that can optimize directly should try to avoid relying on the machine.
If it must exist, it should be in the form of comments. Otherwise, the
intuition is that there was a mistake in writing this code. That's why
the kernel tool reports it. At least the developers of the tool has the
same point of view as mine.

> 
>     Andrew
> 
> .
> 

