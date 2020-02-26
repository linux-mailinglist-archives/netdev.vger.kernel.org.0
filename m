Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6A516FE91
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 13:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgBZMBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 07:01:49 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11111 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbgBZMBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 07:01:49 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 18D945087330DCAC2CFB;
        Wed, 26 Feb 2020 20:01:37 +0800 (CST)
Received: from [127.0.0.1] (10.133.210.141) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Wed, 26 Feb 2020
 20:01:29 +0800
Subject: Re: [RFC] slip: not call free_netdev before rtnl_unlock in slip_open
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <maowenan@huawei.com>
References: <5f3e0e02-c900-1956-9628-e25babad2dd9@huawei.com>
 <20200225.103927.302026645880403716.davem@davemloft.net>
 <38005566-2319-9a13-00d9-5a4f88d4bc46@huawei.com>
 <20200225.193043.522116649502857666.davem@davemloft.net>
 <8654b2ef-1951-7f10-c09d-8f42beee9cd4@hartkopp.net>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <cfc612e7-5eb4-16b0-30f6-32d7d4daec29@huawei.com>
Date:   Wed, 26 Feb 2020 20:01:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <8654b2ef-1951-7f10-c09d-8f42beee9cd4@hartkopp.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.133.210.141]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/2/26 15:28, Oliver Hartkopp wrote:
> 
> 
> On 26/02/2020 04.30, David Miller wrote:
>> From: yangerkun <yangerkun@huawei.com>
>> Date: Wed, 26 Feb 2020 09:35:38 +0800
>>
>>>
>>>
>>> On 2020/2/26 2:39, David Miller wrote:
>>>> From: yangerkun <yangerkun@huawei.com>
>>>> Date: Tue, 25 Feb 2020 16:57:16 +0800
>>>>
>>>>> Ping. And anyone can give some advise about this patch?
>>>> You've pinged us 5 or 6 times already.
>>> Hi,
>>>
>>> Thanks for your reply!
>>>
>>> I am so sorry for the frequently ping which can make some
>>> noise. Wont't happen again after this...
>>
>> Ok.  But please repost your patch without the RFC tag.
>>
> 
> In fact the comment
> 
> /* do not call free_netdev before rtnl_unlock */
> 
> is also obsolete and can be omitted as you describe the change in the 
> commit message.

Hi,

Yes. No need for this commit message. I will resend the patch!

Thanks,
Kun.

> 
> In similar code snipets in the kernel there are also no comments for this.
> 
> Thanks,
> Oliver
> 
> 

