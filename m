Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FBB1D24BC
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgENBdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:33:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4840 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725925AbgENBdA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 21:33:00 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 21B6A29B7E58DFE8DD60;
        Thu, 14 May 2020 09:32:58 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Thu, 14 May 2020
 09:32:51 +0800
Subject: Re: [PATCH net-next] net: phy: realtek: add loopback support for
 RTL8211F
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Jian Shen <shenjian15@huawei.com>
References: <1589358344-14009-1-git-send-email-tanhuazhong@huawei.com>
 <20200513131226.GA499265@lunn.ch>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <e54083ee-ed3a-115f-0856-d943dac579a8@huawei.com>
Date:   Thu, 14 May 2020 09:32:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20200513131226.GA499265@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/5/13 21:12, Andrew Lunn wrote:
> On Wed, May 13, 2020 at 04:25:44PM +0800, Huazhong Tan wrote:
>> From: Yufeng Mo <moyufeng@huawei.com>
>>
>> PHY loopback is already supported by genphy driver. This patch
>> adds the set_loopback interface to RTL8211F PHY driver, so the PHY
>> selftest can run properly on it.
>>
>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> It took three people to write a 1 line patch?

Yufeng Mo is the author of this patch, since he has not right to send mail
so I just help him to do than。 If necessary, Jian Shen could be deleted.

> 
>> ---
>>   drivers/net/phy/realtek.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
>> index c7229d0..6c5918c 100644
>> --- a/drivers/net/phy/realtek.c
>> +++ b/drivers/net/phy/realtek.c
>> @@ -615,6 +615,7 @@ static struct phy_driver realtek_drvs[] = {
>>   		.resume		= genphy_resume,
>>   		.read_page	= rtl821x_read_page,
>>   		.write_page	= rtl821x_write_page,
>> +		.set_loopback   = genphy_loopback,
>>   	}, {
>>   		.name		= "Generic FE-GE Realtek PHY",
>>   		.match_phy_device = rtlgen_match_phy_device,
> 
> Do you have access to the data sheets? Can you check if the other PHYs
> supported by this driver also support loopback in the standard way?
> They probably do.
> 
> 	  Andrew
> 

We have checked the data sheet. Since we only have rtl8211f phy on our 
hand, so only support loopback on this phy.

Thanks:)

> .
> 

