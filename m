Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97FC3A94D3
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 10:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhFPIQW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Jun 2021 04:16:22 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7304 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbhFPIQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 04:16:20 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G4dBJ5ftVz1BJhv;
        Wed, 16 Jun 2021 16:09:12 +0800 (CST)
Received: from dggpeml500018.china.huawei.com (7.185.36.186) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 16:14:13 +0800
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggpeml500018.china.huawei.com (7.185.36.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 16:14:13 +0800
Received: from dggema753-chm.china.huawei.com ([10.9.48.84]) by
 dggema753-chm.china.huawei.com ([10.9.48.84]) with mapi id 15.01.2176.012;
 Wed, 16 Jun 2021 16:14:13 +0800
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
Date:   Wed, 16 Jun 2021 08:14:13 +0000
Message-ID: <bc0300eb01494e2b9b190c5d3ac7bc80@huawei.com>
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
>> @@ -188,7 +188,7 @@ int mdio_driver_register(struct mdio_driver *drv)
>>  	struct mdio_driver_common *mdiodrv = &drv->mdiodrv;
>>  	int retval;
>>  
>> -	pr_debug("mdio_driver_register: %s\n", mdiodrv->driver.name);
>> +	pr_debug("%s: %s\n", __func__, mdiodrv->driver.name);
> It would be nice to make this
> 
>         dev_dbg(&mdiodev->dev, "%s: %s\n", __func__, mdiodrv->driver.name);
> 
> 	Andrew
> 

There is no way to get mdiodev from a pointer to mdio_driver, I don't think
there's a direct relationship between them. So I will keep using pr_debug :)

Thanks
Weihang
