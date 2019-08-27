Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 292DF9E6E4
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbfH0Lg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:36:59 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43118 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725912AbfH0Lg7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 07:36:59 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BA7916EE540715C841CF;
        Tue, 27 Aug 2019 19:36:57 +0800 (CST)
Received: from [127.0.0.1] (10.65.91.35) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Tue, 27 Aug 2019
 19:36:50 +0800
Subject: Re: [RFC PATCH net-next] net: phy: force phy suspend when calling
 phy_stop
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <forest.zhouchang@huawei.com>,
        <linuxarm@huawei.com>
References: <1566874020-14334-1-git-send-email-shenjian15@huawei.com>
 <cc52cde5-b114-3bf8-4c4b-fe81c04080ee@cogentembedded.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <02aea077-a7b9-0427-5ea4-4914091d7b77@huawei.com>
Date:   Tue, 27 Aug 2019 19:36:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <cc52cde5-b114-3bf8-4c4b-fe81c04080ee@cogentembedded.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.65.91.35]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2019/8/27 18:11, Sergei Shtylyov 写道:
> On 27.08.2019 5:47, Jian Shen wrote:
> 
>> Some ethernet drivers may call phy_start() and phy_stop() from
>> ndo_open and ndo_close() respectively.
> 
>    ndo_open() for consistency.
> 
>> When network cable is unconnected, and operate like below:
>> step 1: ifconfig ethX up -> ndo_open -> phy_start ->start
>> autoneg, and phy is no link.
>> step 2: ifconfig ethX down -> ndo_close -> phy_stop -> just stop
>> phy state machine.
>> step 3: plugin the network cable, and autoneg complete, then
>> LED for link status will be on.
>> step 4: ethtool ethX --> see the result of "Link detected" is no.
>>
>> This patch forces phy suspend even phydev->link is off.
>>
>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> [...]
> 
> MBR, Sergei
> 
> 
Thanks, will fix it.

