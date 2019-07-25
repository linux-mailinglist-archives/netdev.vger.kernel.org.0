Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F887478F
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 08:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfGYG5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 02:57:44 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2052 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725808AbfGYG5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 02:57:44 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 84A2A2D77354B4292889;
        Thu, 25 Jul 2019 14:57:42 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 25 Jul 2019 14:57:01 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Thu, 25
 Jul 2019 14:57:01 +0800
Subject: Re: [PATCH net] net: hns: fix LED configuration for marvell phy
To:     Andrew Lunn <andrew@lunn.ch>
CC:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <shiju.jose@huawei.com>
References: <1563775152-21369-1-git-send-email-liuyonglong@huawei.com>
 <20190722.181906.2225538844348045066.davem@davemloft.net>
 <72061222-411f-a58c-5873-ad873394cdb5@huawei.com>
 <20190725042829.GB14276@lunn.ch>
From:   liuyonglong <liuyonglong@huawei.com>
Message-ID: <8017d9ff-2991-f94f-e611-4d1bac12e93b@huawei.com>
Date:   Thu, 25 Jul 2019 14:56:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190725042829.GB14276@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/25 12:28, Andrew Lunn wrote:
> On Thu, Jul 25, 2019 at 11:00:08AM +0800, liuyonglong wrote:
>>> Revert "net: hns: fix LED configuration for marvell phy"
>>> This reverts commit f4e5f775db5a4631300dccd0de5eafb50a77c131.
>>>
>>> Andrew Lunn says this should be handled another way.
>>>
>>> Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>>
>> Hi Andrew:
>>
>> I see this patch have been reverted, can you tell me the better way to do this?
>> Thanks very much!
> 
> Please take a look at the work Matthias Kaehlcke is doing. It has not
> got too far yet, but when it is complete, it should define a generic
> way to configure PHY LEDs.
> 
>     Andrew
> 

Hi Andrew

https://lore.kernel.org/patchwork/patch/1097185/

You are discussing about the DT configuration, is Matthias Kaehlcke's work
also provide a generic way to configure PHY LEDS using ACPI?

