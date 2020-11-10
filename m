Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C84E2AC9F2
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 01:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730702AbgKJA61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 19:58:27 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7507 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729451AbgKJA60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 19:58:26 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CVTxj1d6Wzhj15;
        Tue, 10 Nov 2020 08:58:17 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 10 Nov 2020 08:58:18 +0800
Subject: Re: [PATCH stable] net: sch_generic: fix the missing new qdisc
 assignment bug
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <vpai@akamai.com>,
        <Joakim.Tjernlund@infinera.com>, <xiyou.wangcong@gmail.com>,
        <johunt@akamai.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.fastabend@gmail.com>, <eric.dumazet@gmail.com>,
        <dsahern@gmail.com>
References: <1604373938-211588-1-git-send-email-linyunsheng@huawei.com>
 <20201109124658.GC1834954@kroah.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <3deb16a8-bdb1-3c31-2722-404f271f41d8@huawei.com>
Date:   Tue, 10 Nov 2020 08:58:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20201109124658.GC1834954@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/11/9 20:46, Greg KH wrote:
> On Tue, Nov 03, 2020 at 11:25:38AM +0800, Yunsheng Lin wrote:
>> commit 2fb541c862c9 ("net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc")
>>
>> When the above upstream commit is backported to stable kernel,
>> one assignment is missing, which causes two problems reported
>> by Joakim and Vishwanath, see [1] and [2].
>>
>> So add the assignment back to fix it.
>>
>> 1. https://www.spinics.net/lists/netdev/msg693916.html
>> 2. https://www.spinics.net/lists/netdev/msg695131.html
>>
>> Fixes: 749cc0b0c7f3 ("net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc")
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>  net/sched/sch_generic.c | 3 +++
>>  1 file changed, 3 insertions(+)
> 
> What kernel tree(s) does this need to be backported to?

4.19.x and 5.4.x

Thanks

> 
> thanks,
> 
> greg k-h
> .
> 
