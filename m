Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FBE2EB9D8
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 07:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbhAFGHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 01:07:41 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10025 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbhAFGHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 01:07:40 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D9f4W0xZlzj4K4;
        Wed,  6 Jan 2021 14:06:03 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Wed, 6 Jan 2021 14:06:49 +0800
Subject: Re: [PATCH v2] net: qrtr: fix null pointer dereference in
 qrtr_ns_remove
To:     Markus Elfring <Markus.Elfring@web.de>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <hulkci@huawei.com>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210105055754.16486-1-miaoqinglang@huawei.com>
 <4596fb37-5e74-5bf6-60e5-ded6fbb83969@web.de>
From:   Qinglang Miao <miaoqinglang@huawei.com>
Message-ID: <fdea7394-3e4a-0afe-6b22-7e3a258f5607@huawei.com>
Date:   Wed, 6 Jan 2021 14:06:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <4596fb37-5e74-5bf6-60e5-ded6fbb83969@web.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Markus,

I'd like to take some of your advice in this patch, but I noticed that 
this one has been applied.

Some of your advice would be considered kindly on my future work.

Thanks.

在 2021/1/5 21:14, Markus Elfring 写道:
>> A null-ptr-deref bug is reported by Hulk Robot like this:
> 
> Can it be clearer to use the term “null pointer dereference” for the final commit message?
This advice is too detailed for 'null-ptr-deref' is known as a general 
phrase like 'use-after-free' for kernel developer, I think.>
> 
>> --------------
> 
> I suggest to choose an other character for drawing such a text line.
It's an acceptable advice, thanks.
> 
> 
>> Fix it by making …
> 
> Would you like to replace this wording by the tag “Fixes”?
Sorry, I didn't get your words.

'Fix it by' follows the solution
'Fixes' follows the commit which brought the problem.

In fact, I do considered using 'Fixes' on this one, but it's hard to 
tell which specific commit brought this null pointer dereference.
> 
> Will an other imperative wording variant be helpful for this change description?
> 
> 
> …
>> +++ b/net/qrtr/qrtr.c
>> @@ -1287,13 +1287,19 @@ static int __init qrtr_proto_init(void)
> …
>> +err_sock:
>> +	sock_unregister(qrtr_family.family);
>> +err_proto:
>> +	proto_unregister(&qrtr_proto);
>>   	return rc;
>>   }
> 
> Would it be clearer to use the labels “unregister_sock” and “unregister_proto”?
In fact, The reason I use 'err_sock' rather than 'unregister_sock' is to 
keep same in 'net/qrtr/ns.c'.

I agree with you that “unregister_sock” is better in normal case.
> 
> Regards,
> Markus
> .
> 
