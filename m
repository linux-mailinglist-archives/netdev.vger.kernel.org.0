Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E227326B05
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 02:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhB0B2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 20:28:20 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:4639 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhB0B2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 20:28:19 -0500
Received: from dggeme752-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4DnTPV662JzYDCT;
        Sat, 27 Feb 2021 09:26:06 +0800 (CST)
Received: from [127.0.0.1] (10.69.26.252) by dggeme752-chm.china.huawei.com
 (10.3.19.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2106.2; Sat, 27
 Feb 2021 09:27:35 +0800
Subject: Re: [PATCH net] net: phy: fix save wrong speed and duplex problem if
 autoneg is on
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <1614325482-25208-1-git-send-email-tanhuazhong@huawei.com>
 <20210226155603.6a1cda0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <cb001681-137d-3352-b334-63d1a80cae36@huawei.com>
Date:   Sat, 27 Feb 2021 09:27:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210226155603.6a1cda0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggeme752-chm.china.huawei.com (10.3.19.98)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/27 7:56, Jakub Kicinski wrote:
> On Fri, 26 Feb 2021 15:44:42 +0800 Huazhong Tan wrote:
>> From: Guangbin Huang <huangguangbin2@huawei.com>
>>
>> If phy uses generic driver and autoneg is on, enter command
>> "ethtool -s eth0 speed 50" will not change phy speed actually, but
>> command "ethtool eth0" shows speed is 50Mb/s because phydev->speed
>> has been set to 50 and no update later.
>>
>> And duplex setting has same problem too.
>>
>> However, if autoneg is on, phy only changes speed and duplex according to
>> phydev->advertising, but not phydev->speed and phydev->duplex. So in this
>> case, phydev->speed and phydev->duplex don't need to be set in function
>> phy_ethtool_ksettings_set() if autoneg is on.
> Can we get a Fixes tag for this one? How far back does this behavior
> date?
will add a fixes tag in V2, thanks.
> .

