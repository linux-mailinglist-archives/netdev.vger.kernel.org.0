Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C323726A2
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 09:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhEDHjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 03:39:32 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3967 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhEDHjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 03:39:31 -0400
Received: from dggeml701-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FZBTr3YSGz5yGn;
        Tue,  4 May 2021 15:36:00 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggeml701-chm.china.huawei.com (10.3.17.134) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 4 May 2021 15:38:33 +0800
Received: from [127.0.0.1] (10.69.26.252) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 4 May 2021
 15:38:33 +0800
Subject: Re: [PATCH net-next 4/4] net: hns3: disable phy loopback setting in
 hclge_mac_start_phy
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>
References: <1619773582-17828-1-git-send-email-tanhuazhong@huawei.com>
 <1619773582-17828-5-git-send-email-tanhuazhong@huawei.com>
 <YIv9d9CHvWAtbqJE@lunn.ch>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <fa236262-6bc6-3ef4-030f-76e4929bb636@huawei.com>
Date:   Tue, 4 May 2021 15:38:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <YIv9d9CHvWAtbqJE@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/4/30 20:52, Andrew Lunn wrote:
> On Fri, Apr 30, 2021 at 05:06:22PM +0800, Huazhong Tan wrote:
>> From: Yufeng Mo <moyufeng@huawei.com>
>>
>> If selftest and reset are performed at the same time, the phy
>> loopback setting may be still in enable state after the reset,
>> and device cannot link up. So fix this issue by disabling phy
>> loopback before phy_start().
> This sounds like a generic problem, not specific to your
> driver. Please look at solving this within phy_start().
>
> 	Andrew


I will try to send another patch to do that.

thanks.


> .

