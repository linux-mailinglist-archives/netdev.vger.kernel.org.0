Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51CE97438F
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 05:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389518AbfGYDAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 23:00:14 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2486 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389341AbfGYDAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 23:00:14 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 9F167A0EC54B8BF126DE;
        Thu, 25 Jul 2019 11:00:12 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 25 Jul 2019 11:00:12 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Thu, 25
 Jul 2019 11:00:11 +0800
Subject: Re: [PATCH net] net: hns: fix LED configuration for marvell phy
To:     David Miller <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <shiju.jose@huawei.com>
References: <1563775152-21369-1-git-send-email-liuyonglong@huawei.com>
 <20190722.181906.2225538844348045066.davem@davemloft.net>
From:   liuyonglong <liuyonglong@huawei.com>
Message-ID: <72061222-411f-a58c-5873-ad873394cdb5@huawei.com>
Date:   Thu, 25 Jul 2019 11:00:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190722.181906.2225538844348045066.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Revert "net: hns: fix LED configuration for marvell phy"
> This reverts commit f4e5f775db5a4631300dccd0de5eafb50a77c131.
>
> Andrew Lunn says this should be handled another way.
>
> Signed-off-by: David S. Miller <davem@davemloft.net>


Hi Andrew:

I see this patch have been reverted, can you tell me the better way to do this?
Thanks very much!

On 2019/7/23 9:19, David Miller wrote:
> From: Yonglong Liu <liuyonglong@huawei.com>
> Date: Mon, 22 Jul 2019 13:59:12 +0800
> 
>> Since commit(net: phy: marvell: change default m88e1510 LED configuration),
>> the active LED of Hip07 devices is always off, because Hip07 just
>> use 2 LEDs.
>> This patch adds a phy_register_fixup_for_uid() for m88e1510 to
>> correct the LED configuration.
>>
>> Fixes: 077772468ec1 ("net: phy: marvell: change default m88e1510 LED configuration")
>> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
>> Reviewed-by: linyunsheng <linyunsheng@huawei.com>
> 
> Applied and queued up for -stable.
> 
> .
> 

