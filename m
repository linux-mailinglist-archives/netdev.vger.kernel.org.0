Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4C944A5F5
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 05:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbhKIE6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 23:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242932AbhKIE6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 23:58:44 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE39EC061764;
        Mon,  8 Nov 2021 20:55:58 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id k4so18718236plx.8;
        Mon, 08 Nov 2021 20:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=oSQetnYzyOAK00x8RRMKldgCHOuLoxNZ9OZDJXEntB4=;
        b=XH+BAQsqzyYuqUKRlliwobYqcvWlUNiWXT9HTKA77wCXsZ5eHXAr2tZi3wa22qa+WH
         /CFKZFk88MFNcwcissaboJ6HLKGwZa8vT5KMDHtOQORIe8tRlBlCl629tafJhHnpHlfR
         TcG+Mwfzo407ML4e9iT7szF2Eoye8Lh5ZuAzbsbzf7qVp3In0KNRy1N1+2v46SqT5J2P
         LR1aVZoDthHfTyNb/hegrYagalx0w67zI78NEV1EGftMZpeD4dKLFwNE3QMgOvAv/467
         G6/l+Co4JpuDDcGcgeWemT04C1ML+d+d1Lz4q/WQLyWVVST/522CnJSSriFfudwirCgz
         j5Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=oSQetnYzyOAK00x8RRMKldgCHOuLoxNZ9OZDJXEntB4=;
        b=5eLSovJ6pYLN5zHOLMIcMe/eJoPgP5nGP2yPE0SIq2N3r3NDHSlRg/CMAUCfpIKyaH
         0LRsgII8PTeS9nIgTpp7+8tmTxj1fWvmQTy8YMYU41mQjSvEIJBX7EyOW5wDTZrj6Hqk
         2yZqCfNk7HfLd/FNh8FdpT/6N4bqYhVPHwN7bOF7ALw+4j+mpR/71ntXHQTgyyvoFX7G
         ibG2UTC9iOSI0hLbWS3LtZe2DUbg5BMGUwsUHFyJ7NJJ7K2tvbgdwDOd69EU83PHmh+V
         uUbubIM4/LV5+RqnOoXYIeYDNwel4rYv2sY2RGnPCFG6YmTdNJ1/yGoCHutxj8qiWreN
         TpSA==
X-Gm-Message-State: AOAM530ZFOWwHdwWvqtml8bMAGcEx5mHa93xPNg6AbktdMwuEyI5u92m
        z7aUTwOY4oM+SBC7MjZhWZIPeAfsgUQ=
X-Google-Smtp-Source: ABdhPJwv41Pm3B+5Nn9KrYcDkYOL9ViOq9gOGQlDZdYU20igJfYuoDCAcrkCaJJJha7Ob804LA1ozQ==
X-Received: by 2002:a17:90a:5515:: with SMTP id b21mr4137165pji.239.1636433758145;
        Mon, 08 Nov 2021 20:55:58 -0800 (PST)
Received: from [10.1.1.26] (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id t8sm14243087pgk.66.2021.11.08.20.55.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 20:55:57 -0800 (PST)
Subject: Re: [PATCH net v9 3/3] net/8390: apne.c - add 100 Mbit support to
 apne.c driver
To:     Randy Dunlap <rdunlap@infradead.org>, linux-m68k@vger.kernel.org,
        geert@linux-m68k.org
References: <20211109040242.11615-1-schmitzmic@gmail.com>
 <20211109040242.11615-4-schmitzmic@gmail.com>
 <3d4c9e98-f004-755c-2f30-45b951ede6a6@infradead.org>
Cc:     alex@kazik.de, netdev@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <d5fa96b6-a351-1195-7967-25c26d9a04fb@gmail.com>
Date:   Tue, 9 Nov 2021 17:55:52 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <3d4c9e98-f004-755c-2f30-45b951ede6a6@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

On 09/11/21 17:09, Randy Dunlap wrote:
> On 11/8/21 8:02 PM, Michael Schmitz wrote:
>> diff --git a/drivers/net/ethernet/8390/Kconfig
>> b/drivers/net/ethernet/8390/Kconfig
>> index a4130e643342..b22c3cf96560 100644
>> --- a/drivers/net/ethernet/8390/Kconfig
>> +++ b/drivers/net/ethernet/8390/Kconfig
>> @@ -136,6 +136,8 @@ config NE2K_PCI
>>   config APNE
>>       tristate "PCMCIA NE2000 support"
>>       depends on AMIGA_PCMCIA
>> +    select PCCARD
>> +    select PCMCIA
>>       select CRC32
>
> Hi,
>
> There are no other drivers that "select PCCARD" or
> "select PCMCIA" in the entire kernel tree.
> I don't see any good justification to allow it here.

Amiga doesn't use anything from the core PCMCIA code, instead providing 
its own basic PCMCIA support code.

I had initially duplicated some of the cis tuple parser code, but 
decided to use what's already there instead.

I can drop these selects, and add instructions to manually select these 
options in the Kconfig help section. Seemed a little error prone to me.

Cheers,

	Michael


