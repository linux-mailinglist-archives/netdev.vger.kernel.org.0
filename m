Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BBE369FF
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 04:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFFCaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 22:30:21 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37182 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726454AbfFFCaV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 22:30:21 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5FE8057C4BBF7516ADFC;
        Thu,  6 Jun 2019 10:30:17 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Thu, 6 Jun 2019
 10:29:56 +0800
Subject: Re: [PATCH net] inet_connection_sock: remove unused parameter of
 reqsk_queue_unlink func
To:     David Miller <davem@davemloft.net>
CC:     <edumazet@google.com>, <netdev@vger.kernel.org>,
        <mingfangsen@huawei.com>, <zhoukang7@huawei.com>,
        <wangxiaogang3@huawei.com>, maowenan <maowenan@huawei.com>
References: <546c6d2f-39ca-521d-7009-d80df735bd9e@huawei.com>
 <20190605.184902.257610327160365131.davem@davemloft.net>
 <3792c359-98b3-c312-d87a-204a846a3c11@huawei.com>
 <20190605.191903.756231080836216664.davem@davemloft.net>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <e399b176-ebe8-4967-91cc-ff5deb51c1f2@huawei.com>
Date:   Thu, 6 Jun 2019 10:29:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190605.191903.756231080836216664.davem@davemloft.net>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>>> small cleanup: "struct request_sock_queue *queue" parameter of reqsk_queue_unlink
>>>> func is never used in the func, so we can remove it.
>>>>
>>>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>>>
>>> Applied, thanks.
>>>
>>
>> Hi, David Miller.
>> So sorry for forgetting to sign partner's name who find the cleanup together.
>> I have sent v2 patch with my partner's signature.
>>
>> I am so sorry for the mistake.
> 
> It is already pushed out to my public GIT tree and the commit is immutable.
> 

Ok, I'll pay more attention next time.
Sorry again.


