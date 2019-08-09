Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8AD86F60
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405293AbfHIBdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:33:10 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:46648 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732796AbfHIBdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 21:33:10 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CEBA2A532C3AE40E2024;
        Fri,  9 Aug 2019 09:33:07 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Fri, 9 Aug 2019
 09:33:03 +0800
Subject: Re: [PATCH net-next] taprio: remove unused variable
 'entry_list_policy'
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        David Miller <davem@davemloft.net>
References: <20190808142623.69188-1-yuehaibing@huawei.com>
 <20190808.113813.478689798535715440.davem@davemloft.net>
 <87mugjtmn7.fsf@intel.com>
CC:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <96b67595-5b58-e049-64bb-cd3cc67659ac@huawei.com>
Date:   Fri, 9 Aug 2019 09:33:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <87mugjtmn7.fsf@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/8/9 4:42, Vinicius Costa Gomes wrote:
> Hi,
> 
> David Miller <davem@davemloft.net> writes:
> 
>> From: YueHaibing <yuehaibing@huawei.com>
>> Date: Thu, 8 Aug 2019 22:26:23 +0800
>>
>>> net/sched/sch_taprio.c:680:32: warning:
>>>  entry_list_policy defined but not used [-Wunused-const-variable=]
>>>
>>> It is not used since commit a3d43c0d56f1 ("taprio: Add
>>> support adding an admin schedule")
>>>
>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>
>> This is probably unintentional and a bug, we should be using that
>> policy value to validate that the sched list is indeed a nested
>> attribute.
> 
> Removing this policy should be fine.
> 
> One of the points of commit (as explained in the commit message)
> a3d43c0d56f1 ("taprio: Add support adding an admin schedule") is that it
> removes support (it now returns "not supported") for schedules using the
> TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY attribute (which were never used),
> the parsing of those types of schedules was the only user of this
> policy.
> 
>>
>> I'm not applying this without at least a better and clear commit
>> message explaining why we shouldn't be using this policy any more.
> 
> YueHaibing may use the text above in the commit message of a new spin of
> this patch if you think it's clear enough.

Thanks, will send v2 with your explanation.

> 
> 
> Cheers,
> --
> Vinicius
> 
> .
> 

