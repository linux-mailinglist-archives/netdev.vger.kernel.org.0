Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9329E13DB3C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgAPNNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:13:42 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:49162 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726278AbgAPNNm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:13:42 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2B85277B6B48B87C9A96;
        Thu, 16 Jan 2020 21:13:39 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.129) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Thu, 16 Jan 2020
 21:13:28 +0800
Subject: Re: [PATCH -next] drivers/net: netdevsim depends on INET
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <chenzhou10@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200116125219.166830-1-yaohongbo@huawei.com>
 <20200116050506.18c2cce3@cakuba.hsd1.ca.comcast.net>
From:   Hongbo Yao <yaohongbo@huawei.com>
Message-ID: <fc6c7d33-479d-6cb6-3126-dc215789d6f3@huawei.com>
Date:   Thu, 16 Jan 2020 21:13:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200116050506.18c2cce3@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.129]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/1/16 21:05, Jakub Kicinski wrote:
> On Thu, 16 Jan 2020 20:52:19 +0800, Hongbo Yao wrote:
>> If CONFIG_INET is not set and CONFIG_NETDEVSIM=y.
>> Building drivers/net/netdevsim/fib.o will get the following error:
>>
>> drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_hw_flags_set':
>> fib.c:(.text+0x12b): undefined reference to `fib_alias_hw_flags_set'
>> drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_destroy':
>> fib.c:(.text+0xb11): undefined reference to `free_fib_info'
>>
>> Correct the Kconfig for netdevsim.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Fixes: 83c9e13aa39ae("netdevsim: add software driver for testing
>> offloads")
> 
> Please provide a _correct_ Fixes tag, and don't line wrap it.
> The commit you're pointing to doesn't use any of the fib functions 
> so how can it be to blame?

Thank you for catching my mistake.
I'll resend it.

Best regards,
Hongbo.
>> Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>
>> ---
>>  drivers/net/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
>> index 77ee9afad038..25a8f9387d5a 100644
>> --- a/drivers/net/Kconfig
>> +++ b/drivers/net/Kconfig
>> @@ -549,6 +549,7 @@ source "drivers/net/hyperv/Kconfig"
>>  config NETDEVSIM
>>  	tristate "Simulated networking device"
>>  	depends on DEBUG_FS
>> +	depends on INET
>>  	depends on IPV6 || IPV6=n
>>  	select NET_DEVLINK
>>  	help
> 
> 
> .
> 

