Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3885144B320
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 20:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243073AbhKITWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 14:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbhKITWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 14:22:37 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BC0C061764;
        Tue,  9 Nov 2021 11:19:51 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y7so470426plp.0;
        Tue, 09 Nov 2021 11:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=iuczEJUFH8NAmBu+6MhEyS1Oy526YGYJ40DdJUhMxXU=;
        b=iT9sJzGOAD++jCCo2/84DRigMjRY5MBKPP2sfrbWevMFunAuSPXCfVvNeLqVNb0Npa
         JbInWsFHG2Iv2Iria+l724E8LeVnCm8pwz70gXSO61cMSyrnXifyCEtKozJOhIcdtHX7
         vL/TJsPd0dS5rPR6lB7ak1gDPI299Lw/NsTtBy9AsRvtroKVleYrBQazJBdPEvDUYgPP
         tXzVoumENHAfM96W+NZFwe/uBfqDdkq7E6SJcZphvKyrWPctwJNlIKABBBoLsmGaNak3
         2S7pqRU+2dgcoV1i2a/WMoiG4OTvv+7OemHj6gaWmF2juemyZrMR8H4KMu0u7Uz1MOmL
         K23g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=iuczEJUFH8NAmBu+6MhEyS1Oy526YGYJ40DdJUhMxXU=;
        b=jt0tHgymP8jPxddI5v3Ll3D7W08USh7w11ry2JmPOAhCrKdOeHRoyPg0O4D5exdJX+
         fAdgu56cTMcNXIaS6u506GmdlOtAxWTVTlwq4rxTtTHHNS0QQPvDcAz1iTrMx0vhy+uc
         3CGlkiaN/Uw5gYsIINf5IuYCDMp9Po/LCaeTyspkZhwmwvwCwFYd6bEXz1aTSsbPaFu/
         S+YcyrGU/M/HT6+skI0EeMOmlNColYZj14xsbEYemvAk+kV0lU25wACdczzMuk6J4zhQ
         +JYp/7canNBNS/F+K9v+ccAW6waIX44vIL4GuyKtIHY/lw0b6TBkib8JdgDOEt33cGHw
         rxFQ==
X-Gm-Message-State: AOAM533s3Lu4X0uSubWrAj7Vc3MC+qzJQy0GNZO1CY/9pa/fKjXV6Y0C
        EiGpN9tGHvKLez2LexLsCGS56a6eNTA=
X-Google-Smtp-Source: ABdhPJzINCEQFIMyYG2W5OVqoCflUtO+O8LPtH2tNUIyTbTgGDo2UKDlSjgxoGdfLHtoq4kcX+dHxg==
X-Received: by 2002:a17:903:2055:b0:142:497c:a249 with SMTP id q21-20020a170903205500b00142497ca249mr9433909pla.35.1636485590950;
        Tue, 09 Nov 2021 11:19:50 -0800 (PST)
Received: from [10.1.1.26] (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id oa2sm3449107pjb.53.2021.11.09.11.19.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Nov 2021 11:19:50 -0800 (PST)
Subject: Re: [PATCH net v9 3/3] net/8390: apne.c - add 100 Mbit support to
 apne.c driver
To:     Randy Dunlap <rdunlap@infradead.org>, linux-m68k@vger.kernel.org,
        geert@linux-m68k.org
References: <20211109040242.11615-1-schmitzmic@gmail.com>
 <20211109040242.11615-4-schmitzmic@gmail.com>
 <3d4c9e98-f004-755c-2f30-45b951ede6a6@infradead.org>
 <d5fa96b6-a351-1195-7967-25c26d9a04fb@gmail.com>
 <c7ab4109-9abf-dfe8-0325-7d3e113aa66c@infradead.org>
Cc:     alex@kazik.de, netdev@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <1ed3a71a-e57b-0754-b719-36ac862413da@gmail.com>
Date:   Wed, 10 Nov 2021 08:19:45 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <c7ab4109-9abf-dfe8-0325-7d3e113aa66c@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

On 09/11/21 18:44, Randy Dunlap wrote:
> On 11/8/21 8:55 PM, Michael Schmitz wrote:
>> Hi Randy,
>>
>> On 09/11/21 17:09, Randy Dunlap wrote:
>>> On 11/8/21 8:02 PM, Michael Schmitz wrote:
>>>> diff --git a/drivers/net/ethernet/8390/Kconfig
>>>> b/drivers/net/ethernet/8390/Kconfig
>>>> index a4130e643342..b22c3cf96560 100644
>>>> --- a/drivers/net/ethernet/8390/Kconfig
>>>> +++ b/drivers/net/ethernet/8390/Kconfig
>>>> @@ -136,6 +136,8 @@ config NE2K_PCI
>>>>   config APNE
>>>>       tristate "PCMCIA NE2000 support"
>>>>       depends on AMIGA_PCMCIA
>>>> +    select PCCARD
>>>> +    select PCMCIA
>>>>       select CRC32
>>>
>>> Hi,
>>>
>>> There are no other drivers that "select PCCARD" or
>>> "select PCMCIA" in the entire kernel tree.
>>> I don't see any good justification to allow it here.
>>
>> Amiga doesn't use anything from the core PCMCIA code, instead
>> providing its own basic PCMCIA support code.
>>
>> I had initially duplicated some of the cis tuple parser code, but
>> decided to use what's already there instead.
>>
>> I can drop these selects, and add instructions to manually select
>> these options in the Kconfig help section. Seemed a little error prone
>> to me.
>
> Just make it the same as other drivers in this respect, please.

"depends on PCMCIA" is what I've seen for other drivers. That is not 
really appropriate for the APNE driver (8 bit cards work fine with just 
the support code from arch/m68k/amiga/pcmcia.c).

Please confirm that "depends on PCMCIA" is what you want me to use?

Cheers,

	Michael

