Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23283A92E4
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhFPGmu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Jun 2021 02:42:50 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7328 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbhFPGly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:41:54 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G4b6X5Hfvz6y9n;
        Wed, 16 Jun 2021 14:35:48 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:47 +0800
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:47 +0800
Received: from dggema753-chm.china.huawei.com ([10.9.48.84]) by
 dggema753-chm.china.huawei.com ([10.9.48.84]) with mapi id 15.01.2176.012;
 Wed, 16 Jun 2021 14:39:47 +0800
From:   liweihang <liweihang@huawei.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        liangwenpeng <liangwenpeng@huawei.com>
Subject: Re: [PATCH net-next 4/8] net: phy: fixed formatting issues with
 braces
Thread-Topic: [PATCH net-next 4/8] net: phy: fixed formatting issues with
 braces
Thread-Index: AQHXXoyi/R2wvm3tvEirbx8m7zk1fA==
Date:   Wed, 16 Jun 2021 06:39:47 +0000
Message-ID: <ee9cae196cdd40fdaab80ef3d386e2ac@huawei.com>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-5-git-send-email-liweihang@huawei.com>
 <YMN2ItFGaZkKs0H9@lunn.ch>
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

On 2021/6/11 22:41, Andrew Lunn wrote:
>> -	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
>> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
>>  		delay = MII_M1111_RGMII_RX_DELAY | MII_M1111_RGMII_TX_DELAY;
>> -	} else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
>> +	else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
>>  		delay = MII_M1111_RGMII_RX_DELAY;
>> -	} else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
>> +	else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
>>  		delay = MII_M1111_RGMII_TX_DELAY;
>> -	} else {
>> +	else
>>  		delay = 0;
>> -	}
> 
> Or turn it into a switch statement?
> 
>    Andrew
> 

Sure, I will put them into another patch.

Weihang
