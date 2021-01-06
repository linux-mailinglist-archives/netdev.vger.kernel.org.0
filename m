Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5792EBBD0
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 10:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbhAFJrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 04:47:13 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:10395 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbhAFJrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 04:47:13 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D9kxq1PFhz7Qp2;
        Wed,  6 Jan 2021 17:45:35 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Wed, 6 Jan 2021 17:46:22 +0800
Subject: Re: [v2] net: qrtr: fix null pointer dereference in qrtr_ns_remove
To:     Markus Elfring <Markus.Elfring@web.de>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <hulkci@huawei.com>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210105055754.16486-1-miaoqinglang@huawei.com>
 <4596fb37-5e74-5bf6-60e5-ded6fbb83969@web.de>
 <fdea7394-3e4a-0afe-6b22-7e3a258f5607@huawei.com>
 <b70726b8-0965-1fb9-2af1-2e05609905ea@web.de>
From:   Qinglang Miao <miaoqinglang@huawei.com>
Message-ID: <1a736322-42ce-e803-f91c-dc7595acffdd@huawei.com>
Date:   Wed, 6 Jan 2021 17:46:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <b70726b8-0965-1fb9-2af1-2e05609905ea@web.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/1/6 16:09, Markus Elfring 写道:
>>>> A null-ptr-deref bug is reported by Hulk Robot like this:
>>>
>>> Can it be clearer to use the term “null pointer dereference” for the final commit message?
>> This advice is too detailed for 'null-ptr-deref' is known as a general phrase
> 
> This key word was provided already by the referenced KASAN report.
>
Yep, you're right. 'null-ptr-deref' is not really proper here.
> 
>> like 'use-after-free' for kernel developer, I think.
> I suggest to reconsider the use of abbreviations at some places.
>  >
>>>> Fix it by making …
>>>
>>> Would you like to replace this wording by the tag “Fixes”?
>> Sorry, I didn't get your words.
>>
>> 'Fix it by' follows the solution
> 
> I propose to specify the desired adjustments without such a prefix
> in the change description.
Sorry, I can understand what you means, but I still disagree with this 
one, for:

1. 'Fix it by' is everywhere in kernel commit message.
2. I think adding it or not makes no change for understanding.
3. I'm not sure this is an official proposal.

> 
> 
>> In fact, I do considered using 'Fixes' on this one,
> 
> Thanks for such information.
> 
> 
>> but it's hard to tell which specific commit brought this null pointer dereference.
> 
> This aspect is unfortunate here. >
> Regards,
> Markus
> .
> 

Thanks anyway, I shall pay more attention to commit message. ;D
