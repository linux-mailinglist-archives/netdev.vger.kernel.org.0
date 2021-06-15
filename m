Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4E13A76ED
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 08:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhFOGOv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Jun 2021 02:14:51 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4779 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhFOGOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 02:14:49 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G3yXb46S1zXfcw;
        Tue, 15 Jun 2021 14:07:43 +0800 (CST)
Received: from dggpeml100024.china.huawei.com (7.185.36.115) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:12:43 +0800
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggpeml100024.china.huawei.com (7.185.36.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:12:43 +0800
Received: from dggema753-chm.china.huawei.com ([10.9.48.84]) by
 dggema753-chm.china.huawei.com ([10.9.48.84]) with mapi id 15.01.2176.012;
 Tue, 15 Jun 2021 14:12:42 +0800
From:   liweihang <liweihang@huawei.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        liangwenpeng <liangwenpeng@huawei.com>,
        "Richard Cochran" <richardcochran@gmail.com>
Subject: Re: [PATCH net-next 1/8] net: phy: add a blank line after
 declarations
Thread-Topic: [PATCH net-next 1/8] net: phy: add a blank line after
 declarations
Thread-Index: AQHXXoyiXjgyNTuRckKnrsWlwQl1Gw==
Date:   Tue, 15 Jun 2021 06:12:42 +0000
Message-ID: <17675f18295848d384e360197648dfd9@huawei.com>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-2-git-send-email-liweihang@huawei.com>
 <YMNz3RnzhPak7XIT@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.100.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/11 22:32, Andrew Lunn wrote:
> On Fri, Jun 11, 2021 at 02:36:52PM +0800, Weihang Li wrote:
>> From: Wenpeng Liang <liangwenpeng@huawei.com>
>>
>> There should be a blank line after declarations.
>>
>> Cc: Richard Cochran <richardcochran@gmail.com>
>> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
>> Signed-off-by: Weihang Li <liweihang@huawei.com>
>> ---
>>  drivers/net/phy/bcm87xx.c  | 4 ++--
>>  drivers/net/phy/dp83640.c  | 1 +
>>  drivers/net/phy/et1011c.c  | 6 ++++--
>>  drivers/net/phy/mdio_bus.c | 1 +
>>  drivers/net/phy/qsemi.c    | 1 +
>>  5 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/phy/bcm87xx.c b/drivers/net/phy/bcm87xx.c
>> index 4ac8fd1..3135634 100644
>> --- a/drivers/net/phy/bcm87xx.c
>> +++ b/drivers/net/phy/bcm87xx.c
>> @@ -54,9 +54,9 @@ static int bcm87xx_of_reg_init(struct phy_device *phydev)
>>  		u16 reg		= be32_to_cpup(paddr++);
>>  		u16 mask	= be32_to_cpup(paddr++);
>>  		u16 val_bits	= be32_to_cpup(paddr++);
>> -		int val;
>>  		u32 regnum = mdiobus_c45_addr(devid, reg);
>> -		val = 0;
>> +		int val = 0;
>> +
> 
> This does a little bit more than add a blank line. Please mention it
> in the commit message.
> 
> This is to do with trust. If you say you are just added blank lines,
> the review can be very quick because you cannot break anything with
> just blank lines. But as soon as i see more than just blank lines, i
> can no longer trust your description, and i need to look much harder
> at your changes.

I see, thanks for the patient guidance.

> 
>> --- a/drivers/net/phy/et1011c.c
>> +++ b/drivers/net/phy/et1011c.c
>> @@ -46,7 +46,8 @@ MODULE_LICENSE("GPL");
>>  
>>  static int et1011c_config_aneg(struct phy_device *phydev)
>>  {
>> -	int ctl = 0;
>> +	int ctl;
>> +
>>  	ctl = phy_read(phydev, MII_BMCR);
>>  	if (ctl < 0)
>>  		return ctl;
> 
> Since you made this change, you could go one step further
> 
> 	int ctl = phy_read(phydev, MII_BMCR);

Sure.

> 
>> @@ -60,9 +61,10 @@ static int et1011c_config_aneg(struct phy_device *phydev)
>>  
>>  static int et1011c_read_status(struct phy_device *phydev)
>>  {
>> +	static int speed;
>>  	int ret;
>>  	u32 val;
>> -	static int speed;
>> +
> 
> This is an O.K. change, but again, more than adding a blank line.
> 
>      Andrew>

OK, I will describe that in the commit description.

Thanks
Weihang

