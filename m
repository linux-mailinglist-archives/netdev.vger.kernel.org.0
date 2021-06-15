Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BB73A770A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 08:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhFOG2U convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Jun 2021 02:28:20 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10068 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhFOG2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 02:28:15 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G3ytV2RB4zZf6J;
        Tue, 15 Jun 2021 14:23:14 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:26:07 +0800
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:26:07 +0800
Received: from dggema753-chm.china.huawei.com ([10.9.48.84]) by
 dggema753-chm.china.huawei.com ([10.9.48.84]) with mapi id 15.01.2176.012;
 Tue, 15 Jun 2021 14:26:06 +0800
From:   liweihang <liweihang@huawei.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        liangwenpeng <liangwenpeng@huawei.com>
Subject: Re: [PATCH net-next 6/8] net: phy: print the function name by
 __func__ instead of an fixed string
Thread-Topic: [PATCH net-next 6/8] net: phy: print the function name by
 __func__ instead of an fixed string
Thread-Index: AQHXXoyi1m/nu5hoXk6l2MqNPefXag==
Date:   Tue, 15 Jun 2021 06:26:06 +0000
Message-ID: <9a4d88aaf8a8483b8a4514c4c414457f@huawei.com>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-7-git-send-email-liweihang@huawei.com>
 <YMOJrv0ZRGCP26F7@lunn.ch>
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

On 2021/6/12 0:05, Andrew Lunn wrote:
> On Fri, Jun 11, 2021 at 02:36:57PM +0800, Weihang Li wrote:
>> From: Wenpeng Liang <liangwenpeng@huawei.com>
>>
>> It's better to use __func__ than a fixed string to print a
>> function's name.
>>
>> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
>> Signed-off-by: Weihang Li <liweihang@huawei.com>
>> ---
>>  drivers/net/phy/mdio_device.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
>> index 0837319..c94cb53 100644
>> --- a/drivers/net/phy/mdio_device.c
>> +++ b/drivers/net/phy/mdio_device.c
>> @@ -77,7 +77,7 @@ int mdio_device_register(struct mdio_device *mdiodev)
>>  {
>>  	int err;
>>  
>> -	dev_dbg(&mdiodev->dev, "mdio_device_register\n");
>> +	dev_dbg(&mdiodev->dev, "%s\n", __func__);
>>  
>>  	err = mdiobus_register_device(mdiodev);
>>  	if (err)
>> @@ -188,7 +188,7 @@ int mdio_driver_register(struct mdio_driver *drv)
>>  	struct mdio_driver_common *mdiodrv = &drv->mdiodrv;
>>  	int retval;
>>  
>> -	pr_debug("mdio_driver_register: %s\n", mdiodrv->driver.name);
>> +	pr_debug("%s: %s\n", __func__, mdiodrv->driver.name);
> 
> It would be nice to make this
> 
>         dev_dbg(&mdiodev->dev, "%s: %s\n", __func__, mdiodrv->driver.name);
> 
> 	Andrew
> 

Thanks for the advice, I will change it.

Weihang
