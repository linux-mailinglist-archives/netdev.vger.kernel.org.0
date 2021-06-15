Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF9F3A770E
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 08:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFOG2j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Jun 2021 02:28:39 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10069 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbhFOG2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 02:28:36 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G3ytx0cSszZf5H;
        Tue, 15 Jun 2021 14:23:37 +0800 (CST)
Received: from dggpeml500018.china.huawei.com (7.185.36.186) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:26:31 +0800
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggpeml500018.china.huawei.com (7.185.36.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:26:31 +0800
Received: from dggema753-chm.china.huawei.com ([10.9.48.84]) by
 dggema753-chm.china.huawei.com ([10.9.48.84]) with mapi id 15.01.2176.012;
 Tue, 15 Jun 2021 14:26:31 +0800
From:   liweihang <liweihang@huawei.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        liangwenpeng <liangwenpeng@huawei.com>
Subject: Re: [PATCH net-next 7/8] net: phy: remove unnecessary line
 continuation
Thread-Topic: [PATCH net-next 7/8] net: phy: remove unnecessary line
 continuation
Thread-Index: AQHXXoyjdl2f1xhmskyc5eJ5hMvy+A==
Date:   Tue, 15 Jun 2021 06:26:31 +0000
Message-ID: <3315ce40e68e4d55ab56e365d2d724a9@huawei.com>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-8-git-send-email-liweihang@huawei.com>
 <YMOKHC6LV1SvMupN@lunn.ch>
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

On 2021/6/12 0:07, Andrew Lunn wrote:
>> -			phy_write(phydev, ET1011C_CONFIG_REG, val\
>> -					| ET1011C_GMII_INTERFACE\
>> -					| ET1011C_SYS_CLK_EN\
>> +			phy_write(phydev, ET1011C_CONFIG_REG, val
>> +					| ET1011C_GMII_INTERFACE
>> +					| ET1011C_SYS_CLK_EN
>>  					| ET1011C_TX_FIFO_DEPTH_16);
> 
> Please put the | at the end of the line, not the beginning of the next
> line.
> 
> Thanks
> 	Andrew
> 

Sure, thank you.

Weihang
