Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401963A76FA
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 08:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhFOGUq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Jun 2021 02:20:46 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4780 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhFOGUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 02:20:45 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G3ygS1mlNzXg41;
        Tue, 15 Jun 2021 14:13:40 +0800 (CST)
Received: from dggpeml100017.china.huawei.com (7.185.36.161) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:18:39 +0800
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggpeml100017.china.huawei.com (7.185.36.161) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:18:39 +0800
Received: from dggema753-chm.china.huawei.com ([10.9.48.84]) by
 dggema753-chm.china.huawei.com ([10.9.48.84]) with mapi id 15.01.2176.012;
 Tue, 15 Jun 2021 14:18:38 +0800
From:   liweihang <liweihang@huawei.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        liangwenpeng <liangwenpeng@huawei.com>
Subject: Re: [PATCH net-next 2/8] net: phy: correct format of block comments
Thread-Topic: [PATCH net-next 2/8] net: phy: correct format of block comments
Thread-Index: AQHXXoyi+Gi0jL1eg0evkWPZtRqBxw==
Date:   Tue, 15 Jun 2021 06:18:38 +0000
Message-ID: <f4016ec16e174e959bfb82f5ce77c260@huawei.com>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-3-git-send-email-liweihang@huawei.com>
 <YMN092dsNrUikeQJ@lunn.ch>
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

On 2021/6/11 22:36, Andrew Lunn wrote:
> On Fri, Jun 11, 2021 at 02:36:53PM +0800, Weihang Li wrote:
>> From: Wenpeng Liang <liangwenpeng@huawei.com>
>>
>> Block comments should not use a trailing */ on a separate line and every
>> line of a block comment should start with an '*'.
>>
>> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
>> Signed-off-by: Weihang Li <liweihang@huawei.com>
>> ---
>>  drivers/net/phy/lxt.c      | 6 +++---
>>  drivers/net/phy/national.c | 6 ++++--
>>  drivers/net/phy/phy-core.c | 3 ++-
>>  drivers/net/phy/phylink.c  | 9 ++++++---
>>  drivers/net/phy/vitesse.c  | 3 ++-
>>  5 files changed, 17 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/phy/lxt.c b/drivers/net/phy/lxt.c
>> index bde3356..5e00910 100644
>> --- a/drivers/net/phy/lxt.c
>> +++ b/drivers/net/phy/lxt.c
>> @@ -241,9 +241,9 @@ static int lxt973a2_read_status(struct phy_device *phydev)
>>  			if (lpa < 0)
>>  				return lpa;
>>  
>> -			/* If both registers are equal, it is suspect but not
>> -			* impossible, hence a new try
>> -			*/
>> +		/* If both registers are equal, it is suspect but not
>> +		 * impossible, hence a new try
>> +		 */
>>  		} while (lpa == adv && retry--);
> 
> Please indicate in the commit message why you changed the indentation.
> 
>        Andrew
> 

Sure, thanks.

Weihang
