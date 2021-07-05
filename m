Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C2F3BB496
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 03:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhGEBPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 21:15:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13064 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhGEBPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 21:15:07 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GJ6z31BPpzZnD0;
        Mon,  5 Jul 2021 09:09:19 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 09:12:29 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 5 Jul
 2021 09:12:28 +0800
Subject: Re: [PATCH net-next 3/3] net: hns3: add support for link diagnosis
 info in debugfs
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>
References: <1624545405-37050-1-git-send-email-huangguangbin2@huawei.com>
 <1624545405-37050-4-git-send-email-huangguangbin2@huawei.com>
 <20210624122517.7c8cb329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <08395721-4ca1-9913-19fd-4d8ec7e41e4b@huawei.com>
 <20210701085447.2270b1df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a5d42bf6-d71f-978e-b9ae-6b04f072d988@huawei.com> <YOISwD+8ZoMpjP2m@lunn.ch>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <ce0b9907-faa7-1f54-4040-e139ae153dec@huawei.com>
Date:   Mon, 5 Jul 2021 09:12:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <YOISwD+8ZoMpjP2m@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/7/5 3:57, Andrew Lunn wrote:
>>>> Hi Jakub, I have a question to consult you.
>>>> Some fault information in our patch are not existed in current ethtool extended
>>>> link states, for examples:
>>>> "Serdes reference clock lost"
>>>> "Serdes analog loss of signal"
>>>> "SFP tx is disabled"
>>>> "PHY power down"
>>>
>>> Why would the PHY be powered down if user requested port to be up?
>>>
>> In the case of other user may use MDIO tool to write PHY register directly to make
>> PHY power down, if link state can display this information, I think it is helpful.
> 
> If the user directly writes to PHY registers, they should expect bad
> things to happen. They can do a lot more than power the PHY down. They
> could configure it into loopback mode, turn off autoneg and force a
> mode which is compatible with the peer, etc.
> 
> I don't think you need to tell the user they have pointed a foot gun
> at their feet and pulled the trigger.
> 
>     Andrew
> .
> 
OK, I accept your point, thanks!
