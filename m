Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9D9382296
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 03:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhEQBuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 21:50:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3701 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbhEQBuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 21:50:01 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fk2605TBhz16Qx6;
        Mon, 17 May 2021 09:46:00 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 09:48:44 +0800
Received: from [10.69.38.207] (10.69.38.207) by dggema704-chm.china.huawei.com
 (10.3.20.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 17
 May 2021 09:48:44 +0800
Subject: Re: [PATCH 07/34] net: cadence: macb_ptp: Demote non-compliant
 kernel-doc headers
To:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
 <1621076039-53986-8-git-send-email-shenyang39@huawei.com>
 <bbfb694c-5d48-137c-e394-4d718887f03d@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Claudiu.Beznea@microchip.com>
From:   Yang Shen <shenyang39@huawei.com>
Message-ID: <d7dd358d-1500-a2c9-e29f-bc0e0d8ef59c@huawei.com>
Date:   Mon, 17 May 2021 09:48:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <bbfb694c-5d48-137c-e394-4d718887f03d@microchip.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.38.207]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema704-chm.china.huawei.com (10.3.20.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/5/15 20:46, Nicolas.Ferre@microchip.com wrote:
> On 15/05/2021 at 12:53, Yang Shen wrote:
>> Fixes the following W=1 kernel build warning(s):
>>
>>   drivers/net/ethernet/cadence/macb_ptp.c:3: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>>
>> Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
>
> Ok, if it raises a warning.
>
> But I would prefer that you add drivers/net/ethernet/cadence/macb_pci.c
> with same change to a combined patch.
>
> Regards,
>    Nicolas
>

OK，The compiler missed this warning at 
drivers/net/ethernet/cadence/macb_pci.c.
I'll fix this in the next version.

Thanks,
     Yang

>
>> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
>> Signed-off-by: Yang Shen <shenyang39@huawei.com>
>> ---
>>   drivers/net/ethernet/cadence/macb_ptp.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
>> index 283918a..5c368a9 100644
>> --- a/drivers/net/ethernet/cadence/macb_ptp.c
>> +++ b/drivers/net/ethernet/cadence/macb_ptp.c
>> @@ -1,5 +1,5 @@
>>   // SPDX-License-Identifier: GPL-2.0-only
>> -/**
>> +/*
>>    * 1588 PTP support for Cadence GEM device.
>>    *
>>    * Copyright (C) 2017 Cadence Design Systems - https://www.cadence.com
>> --
>> 2.7.4
>>
>
>
