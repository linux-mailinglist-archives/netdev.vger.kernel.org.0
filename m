Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C013A7703
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 08:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhFOG0O convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Jun 2021 02:26:14 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6503 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFOG0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 02:26:12 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G3yr72BVszZhQM;
        Tue, 15 Jun 2021 14:21:11 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:24:05 +0800
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:24:05 +0800
Received: from dggema753-chm.china.huawei.com ([10.9.48.84]) by
 dggema753-chm.china.huawei.com ([10.9.48.84]) with mapi id 15.01.2176.012;
 Tue, 15 Jun 2021 14:24:04 +0800
From:   liweihang <liweihang@huawei.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        liangwenpeng <liangwenpeng@huawei.com>
Subject: Re: [PATCH net-next 5/8] net: phy: fixed space alignment issues
Thread-Topic: [PATCH net-next 5/8] net: phy: fixed space alignment issues
Thread-Index: AQHXXoyi7MsJxPn4Zka2xJsxF14BKA==
Date:   Tue, 15 Jun 2021 06:24:04 +0000
Message-ID: <2403f37d2ee44ea8a1cc9c49ccbfa45b@huawei.com>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-6-git-send-email-liweihang@huawei.com>
 <YMOBh/lpHCSMsTPt@lunn.ch>
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

On 2021/6/11 23:30, Andrew Lunn wrote:
>>  (MII_DM9161_INTR_DPLX_MASK | MII_DM9161_INTR_SPD_MASK \
>> - | MII_DM9161_INTR_LINK_MASK | MII_DM9161_INTR_MASK)
>> +	| MII_DM9161_INTR_LINK_MASK | MII_DM9161_INTR_MASK)
> 
> The convention is to put the | at the end of the line. So
> 
>   (MII_DM9161_INTR_DPLX_MASK | MII_DM9161_INTR_SPD_MASK | \
>    MII_DM9161_INTR_LINK_MASK | MII_DM9161_INTR_MASK)
> 
> 
>>  #define MII_DM9161_INTR_CHANGE	\
>>  	(MII_DM9161_INTR_DPLX_CHANGE | \
>>  	 MII_DM9161_INTR_SPD_CHANGE | \
>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
>> index 2870c33..c8d8ef8 100644
>> --- a/drivers/net/phy/phy-core.c
>> +++ b/drivers/net/phy/phy-core.c
>> @@ -84,98 +84,98 @@ EXPORT_SYMBOL_GPL(phy_duplex_to_str);
> 
> 
>>  
>>  static const struct phy_setting settings[] = {
>>  	/* 400G */
>> -	PHY_SETTING( 400000, FULL, 400000baseCR8_Full		),
>> -	PHY_SETTING( 400000, FULL, 400000baseKR8_Full		),
>> -	PHY_SETTING( 400000, FULL, 400000baseLR8_ER8_FR8_Full	),
>> -	PHY_SETTING( 400000, FULL, 400000baseDR8_Full		),
>> -	PHY_SETTING( 400000, FULL, 400000baseSR8_Full		),
>> -	PHY_SETTING( 400000, FULL, 400000baseCR4_Full		),
>> -	PHY_SETTING( 400000, FULL, 400000baseKR4_Full		),
>> -	PHY_SETTING( 400000, FULL, 400000baseLR4_ER4_FR4_Full	),
>> -	PHY_SETTING( 400000, FULL, 400000baseDR4_Full		),
>> -	PHY_SETTING( 400000, FULL, 400000baseSR4_Full		),
>> +	PHY_SETTING(400000, FULL, 400000baseCR8_Full),
>> +	PHY_SETTING(400000, FULL, 400000baseKR8_Full),
>> +	PHY_SETTING(400000, FULL, 400000baseLR8_ER8_FR8_Full),
>> +	PHY_SETTING(400000, FULL, 400000baseDR8_Full),
>> +	PHY_SETTING(400000, FULL, 400000baseSR8_Full),
>> +	PHY_SETTING(400000, FULL, 400000baseCR4_Full),
>> +	PHY_SETTING(400000, FULL, 400000baseKR4_Full),
>> +	PHY_SETTING(400000, FULL, 400000baseLR4_ER4_FR4_Full),
>> +	PHY_SETTING(400000, FULL, 400000baseDR4_Full),
>> +	PHY_SETTING(400000, FULL, 400000baseSR4_Full),
>>  	/* 200G */
>> -	PHY_SETTING( 200000, FULL, 200000baseCR4_Full		),
>> -	PHY_SETTING( 200000, FULL, 200000baseKR4_Full		),
>> -	PHY_SETTING( 200000, FULL, 200000baseLR4_ER4_FR4_Full	),
>> -	PHY_SETTING( 200000, FULL, 200000baseDR4_Full		),
>> -	PHY_SETTING( 200000, FULL, 200000baseSR4_Full		),
>> -	PHY_SETTING( 200000, FULL, 200000baseCR2_Full		),
>> -	PHY_SETTING( 200000, FULL, 200000baseKR2_Full		),
>> -	PHY_SETTING( 200000, FULL, 200000baseLR2_ER2_FR2_Full	),
>> -	PHY_SETTING( 200000, FULL, 200000baseDR2_Full		),
>> -	PHY_SETTING( 200000, FULL, 200000baseSR2_Full		),
>> +	PHY_SETTING(200000, FULL, 200000baseCR4_Full),
>> +	PHY_SETTING(200000, FULL, 200000baseKR4_Full),
>> +	PHY_SETTING(200000, FULL, 200000baseLR4_ER4_FR4_Full),
>> +	PHY_SETTING(200000, FULL, 200000baseDR4_Full),
>> +	PHY_SETTING(200000, FULL, 200000baseSR4_Full),
>> +	PHY_SETTING(200000, FULL, 200000baseCR2_Full),
>> +	PHY_SETTING(200000, FULL, 200000baseKR2_Full),
>> +	PHY_SETTING(200000, FULL, 200000baseLR2_ER2_FR2_Full),
>> +	PHY_SETTING(200000, FULL, 200000baseDR2_Full),
>> +	PHY_SETTING(200000, FULL, 200000baseSR2_Full),
>>  	/* 100G */
>> -	PHY_SETTING( 100000, FULL, 100000baseCR4_Full		),
>> -	PHY_SETTING( 100000, FULL, 100000baseKR4_Full		),
>> -	PHY_SETTING( 100000, FULL, 100000baseLR4_ER4_Full	),
>> -	PHY_SETTING( 100000, FULL, 100000baseSR4_Full		),
>> -	PHY_SETTING( 100000, FULL, 100000baseCR2_Full		),
>> -	PHY_SETTING( 100000, FULL, 100000baseKR2_Full		),
>> -	PHY_SETTING( 100000, FULL, 100000baseLR2_ER2_FR2_Full	),
>> -	PHY_SETTING( 100000, FULL, 100000baseDR2_Full		),
>> -	PHY_SETTING( 100000, FULL, 100000baseSR2_Full		),
>> -	PHY_SETTING( 100000, FULL, 100000baseCR_Full		),
>> -	PHY_SETTING( 100000, FULL, 100000baseKR_Full		),
>> -	PHY_SETTING( 100000, FULL, 100000baseLR_ER_FR_Full	),
>> -	PHY_SETTING( 100000, FULL, 100000baseDR_Full		),
>> -	PHY_SETTING( 100000, FULL, 100000baseSR_Full		),
>> +	PHY_SETTING(100000, FULL, 100000baseCR4_Full),
>> +	PHY_SETTING(100000, FULL, 100000baseKR4_Full),
>> +	PHY_SETTING(100000, FULL, 100000baseLR4_ER4_Full),
>> +	PHY_SETTING(100000, FULL, 100000baseSR4_Full),
>> +	PHY_SETTING(100000, FULL, 100000baseCR2_Full),
>> +	PHY_SETTING(100000, FULL, 100000baseKR2_Full),
>> +	PHY_SETTING(100000, FULL, 100000baseLR2_ER2_FR2_Full),
>> +	PHY_SETTING(100000, FULL, 100000baseDR2_Full),
>> +	PHY_SETTING(100000, FULL, 100000baseSR2_Full),
>> +	PHY_SETTING(100000, FULL, 100000baseCR_Full),
>> +	PHY_SETTING(100000, FULL, 100000baseKR_Full),
>> +	PHY_SETTING(100000, FULL, 100000baseLR_ER_FR_Full),
>> +	PHY_SETTING(100000, FULL, 100000baseDR_Full),
>> +	PHY_SETTING(100000, FULL, 100000baseSR_Full),
>>  	/* 56G */
>> -	PHY_SETTING(  56000, FULL,  56000baseCR4_Full	  	),
>> -	PHY_SETTING(  56000, FULL,  56000baseKR4_Full	  	),
>> -	PHY_SETTING(  56000, FULL,  56000baseLR4_Full	  	),
>> -	PHY_SETTING(  56000, FULL,  56000baseSR4_Full	  	),
>> +	PHY_SETTING(56000, FULL, 56000baseCR4_Full),
>> +	PHY_SETTING(56000, FULL, 56000baseKR4_Full),
>> +	PHY_SETTING(56000, FULL, 56000baseLR4_Full),
>> +	PHY_SETTING(56000, FULL, 56000baseSR4_Full),
>>  	/* 50G */
>> -	PHY_SETTING(  50000, FULL,  50000baseCR2_Full		),
>> -	PHY_SETTING(  50000, FULL,  50000baseKR2_Full		),
>> -	PHY_SETTING(  50000, FULL,  50000baseSR2_Full		),
>> -	PHY_SETTING(  50000, FULL,  50000baseCR_Full		),
>> -	PHY_SETTING(  50000, FULL,  50000baseKR_Full		),
>> -	PHY_SETTING(  50000, FULL,  50000baseLR_ER_FR_Full	),
>> -	PHY_SETTING(  50000, FULL,  50000baseDR_Full		),
>> -	PHY_SETTING(  50000, FULL,  50000baseSR_Full		),
>> +	PHY_SETTING(50000, FULL, 50000baseCR2_Full),
>> +	PHY_SETTING(50000, FULL, 50000baseKR2_Full),
>> +	PHY_SETTING(50000, FULL, 50000baseSR2_Full),
>> +	PHY_SETTING(50000, FULL, 50000baseCR_Full),
>> +	PHY_SETTING(50000, FULL, 50000baseKR_Full),
>> +	PHY_SETTING(50000, FULL, 50000baseLR_ER_FR_Full),
>> +	PHY_SETTING(50000, FULL, 50000baseDR_Full),
>> +	PHY_SETTING(50000, FULL, 50000baseSR_Full),
>>  	/* 40G */
>> -	PHY_SETTING(  40000, FULL,  40000baseCR4_Full		),
>> -	PHY_SETTING(  40000, FULL,  40000baseKR4_Full		),
>> -	PHY_SETTING(  40000, FULL,  40000baseLR4_Full		),
>> -	PHY_SETTING(  40000, FULL,  40000baseSR4_Full		),
>> +	PHY_SETTING(40000, FULL, 40000baseCR4_Full),
>> +	PHY_SETTING(40000, FULL, 40000baseKR4_Full),
>> +	PHY_SETTING(40000, FULL, 40000baseLR4_Full),
>> +	PHY_SETTING(40000, FULL, 40000baseSR4_Full),
>>  	/* 25G */
>> -	PHY_SETTING(  25000, FULL,  25000baseCR_Full		),
>> -	PHY_SETTING(  25000, FULL,  25000baseKR_Full		),
>> -	PHY_SETTING(  25000, FULL,  25000baseSR_Full		),
>> +	PHY_SETTING(25000, FULL, 25000baseCR_Full),
>> +	PHY_SETTING(25000, FULL, 25000baseKR_Full),
>> +	PHY_SETTING(25000, FULL, 25000baseSR_Full),
>>  	/* 20G */
>> -	PHY_SETTING(  20000, FULL,  20000baseKR2_Full		),
>> -	PHY_SETTING(  20000, FULL,  20000baseMLD2_Full		),
>> +	PHY_SETTING(20000, FULL, 20000baseKR2_Full),
>> +	PHY_SETTING(20000, FULL, 20000baseMLD2_Full),
>>  	/* 10G */
>> -	PHY_SETTING(  10000, FULL,  10000baseCR_Full		),
>> -	PHY_SETTING(  10000, FULL,  10000baseER_Full		),
>> -	PHY_SETTING(  10000, FULL,  10000baseKR_Full		),
>> -	PHY_SETTING(  10000, FULL,  10000baseKX4_Full		),
>> -	PHY_SETTING(  10000, FULL,  10000baseLR_Full		),
>> -	PHY_SETTING(  10000, FULL,  10000baseLRM_Full		),
>> -	PHY_SETTING(  10000, FULL,  10000baseR_FEC		),
>> -	PHY_SETTING(  10000, FULL,  10000baseSR_Full		),
>> -	PHY_SETTING(  10000, FULL,  10000baseT_Full		),
>> +	PHY_SETTING(10000, FULL, 10000baseCR_Full),
>> +	PHY_SETTING(10000, FULL, 10000baseER_Full),
>> +	PHY_SETTING(10000, FULL, 10000baseKR_Full),
>> +	PHY_SETTING(10000, FULL, 10000baseKX4_Full),
>> +	PHY_SETTING(10000, FULL, 10000baseLR_Full),
>> +	PHY_SETTING(10000, FULL, 10000baseLRM_Full),
>> +	PHY_SETTING(10000, FULL, 10000baseR_FEC),
>> +	PHY_SETTING(10000, FULL, 10000baseSR_Full),
>> +	PHY_SETTING(10000, FULL, 10000baseT_Full),
>>  	/* 5G */
>> -	PHY_SETTING(   5000, FULL,   5000baseT_Full		),
>> +	PHY_SETTING(5000, FULL, 5000baseT_Full),
>>  	/* 2.5G */
>> -	PHY_SETTING(   2500, FULL,   2500baseT_Full		),
>> -	PHY_SETTING(   2500, FULL,   2500baseX_Full		),
>> +	PHY_SETTING(2500, FULL, 2500baseT_Full),
>> +	PHY_SETTING(2500, FULL, 2500baseX_Full),
>>  	/* 1G */
>> -	PHY_SETTING(   1000, FULL,   1000baseKX_Full		),
>> -	PHY_SETTING(   1000, FULL,   1000baseT_Full		),
>> -	PHY_SETTING(   1000, HALF,   1000baseT_Half		),
>> -	PHY_SETTING(   1000, FULL,   1000baseT1_Full		),
>> -	PHY_SETTING(   1000, FULL,   1000baseX_Full		),
>> +	PHY_SETTING(1000, FULL, 1000baseKX_Full),
>> +	PHY_SETTING(1000, FULL, 1000baseT_Full),
>> +	PHY_SETTING(1000, HALF, 1000baseT_Half),
>> +	PHY_SETTING(1000, FULL, 1000baseT1_Full),
>> +	PHY_SETTING(1000, FULL, 1000baseX_Full),
>>  	/* 100M */
>> -	PHY_SETTING(    100, FULL,    100baseT_Full		),
>> -	PHY_SETTING(    100, FULL,    100baseT1_Full		),
>> -	PHY_SETTING(    100, HALF,    100baseT_Half		),
>> -	PHY_SETTING(    100, HALF,    100baseFX_Half		),
>> -	PHY_SETTING(    100, FULL,    100baseFX_Full		),
>> +	PHY_SETTING(100, FULL, 100baseT_Full),
>> +	PHY_SETTING(100, FULL, 100baseT1_Full),
>> +	PHY_SETTING(100, HALF, 100baseT_Half),
>> +	PHY_SETTING(100, HALF, 100baseFX_Half),
>> +	PHY_SETTING(100, FULL, 100baseFX_Full),
>>  	/* 10M */
>> -	PHY_SETTING(     10, FULL,     10baseT_Full		),
>> -	PHY_SETTING(     10, HALF,     10baseT_Half		),
>> +	PHY_SETTING(10, FULL, 10baseT_Full),
>> +	PHY_SETTING(10, HALF, 10baseT_Half),
> 
> Please do not change this. It is a deliberate design decision to add
> these spaces here.
> 
>       Andrew
> 

OK, I will drop this part from this patch, thank you.

Weihang
