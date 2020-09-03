Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2285325C722
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 18:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgICQlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 12:41:24 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:55516 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbgICQlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 12:41:23 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 083GfGwf039935;
        Thu, 3 Sep 2020 11:41:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599151276;
        bh=X9QPS3a/ZCaAKG2uXIKrOUiVQHzUJ66YvXo6YsH9ZL8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=R8L3ioD+HoPVkdB1rjJnkKJrBqEImULcZjQkm5JhGEmQu2akqeA2JYZodzmzJCyJW
         rTEIHYre8tEbf725ap1JhM13wAIj2Pw9Hu886BraPqG9RIxTNb1kORD3nnqETBwnXd
         Sri0nr4K8NydYdEjxk6pfJ+Q2hNWQA3R1TMcWML4=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 083GfGpW116922
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 3 Sep 2020 11:41:16 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 3 Sep
 2020 11:41:16 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 3 Sep 2020 11:41:16 -0500
Received: from [10.250.38.37] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 083GfF3K096927;
        Thu, 3 Sep 2020 11:41:15 -0500
Subject: Re: [PATCH net] net: phy: dp83867: Fix various styling and space
 issues
To:     Florian Fainelli <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200903141510.20212-1-dmurphy@ti.com>
 <76046e32-a17d-b87c-26c7-6f48f4257916@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <4d38ac31-8646-2c4f-616c-1a1341721819@ti.com>
Date:   Thu, 3 Sep 2020 11:41:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <76046e32-a17d-b87c-26c7-6f48f4257916@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian

On 9/3/20 11:34 AM, Florian Fainelli wrote:
>
>
> On 9/3/2020 7:15 AM, Dan Murphy wrote:
>> Fix spacing issues reported for misaligned switch..case and extra new
>> lines.
>>
>> Also updated the file header to comply with networking commet style.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   drivers/net/phy/dp83867.c | 47 ++++++++++++++++++---------------------
>>   1 file changed, 22 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
>> index cd7032628a28..f182a8d767c6 100644
>> --- a/drivers/net/phy/dp83867.c
>> +++ b/drivers/net/phy/dp83867.c
>> @@ -1,6 +1,5 @@
>>   // SPDX-License-Identifier: GPL-2.0
>> -/*
>> - * Driver for the Texas Instruments DP83867 PHY
>> +/* Driver for the Texas Instruments DP83867 PHY
>>    *
>>    * Copyright (C) 2015 Texas Instruments Inc.
>>    */
>> @@ -35,7 +34,7 @@
>>   #define DP83867_CFG4_SGMII_ANEG_MASK (BIT(5) | BIT(6))
>>   #define DP83867_CFG4_SGMII_ANEG_TIMER_11MS   (3 << 5)
>>   #define DP83867_CFG4_SGMII_ANEG_TIMER_800US  (2 << 5)
>> -#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    (1 << 5)
>> +#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    BIT(5)
>
> Now the definitions are inconsistent, you would want to drop this one 
> and stick to the existing style.

OK I was a little conflicted making that change due to the reasons you 
mentioned.  But if that is an acceptable warning I am ok with it.


>
> The rest of the changes look good, so with that fixed, and the subject 
> correct to "net-next" (this is no bug fix material), you can add:
>
I will have to reapply this to the net-next to make sure it applies 
cleanly there.  But not an issue.

Dan


> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
