Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D102ED543
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbhAGRPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbhAGRPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:15:06 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4415C0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:14:25 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id i5so5397746pgo.1
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 09:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SSKVfFCz3wBuw8flx8OOxnhTNpa0I1v3rZ0C/KXTpPg=;
        b=b5QTAzJqbDfBXlFVjLybbg0PC4JDvlqkutK/u5RElNW5nDWX5V02Q1OEPig4aP9K2G
         O1yB9DI5klERKwqeWgMxN/QECeqHWLveC7HlwuIOBbur5Q0pTAX4DOB+8XEeibCHM4KL
         +3SZmU6aa8Huxp40ZZCg4Yg4V8686csa8J9mjGXp7MovhVqockymGKyPTJIydIQt1O+l
         +e6/5FBLo8Xtli3YZbOxdULJ1i0wx0r9iCVatctg54BtUQyOl6M0nawLzKHIZ3i35SmF
         /Kx4BwLb6keYTdzMhbDY6m3pcuuuILVYfVTRxUGE2w7rdUPk97NgPWZ6NTeS8DA6vKtA
         Yl4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=SSKVfFCz3wBuw8flx8OOxnhTNpa0I1v3rZ0C/KXTpPg=;
        b=W6S8ifUZRRfrLG3RcIdNcFDVUBMzg3HkshbgBQaZni6Qu+1miVNQZGaSb3/hNYV3+P
         uFhaGBo617pd8oLZDV/QY+yp0mMZFLSYduBtu2eL5ympc0po/4oByxy6isWI+Szly1w1
         Cs0rB3+lnoGHapMu6y7crUb5OYhzWxOMXf8U6691K5G6IPCgRUa0GCDgAuilVBfcsRBG
         OuDAfNK995779QWVRPYv1ejSqPb1UEZ544yMtjfDKPTvmyoQSHmOzLQTs290qzq8EaP5
         QB0it4fRS0PX0QxDSYmcaZZDYxp6ApErxF1p3onQuVxPif0MvWnze5G6xVr55K7PJsQR
         k0jw==
X-Gm-Message-State: AOAM5322pe7iFqQeS/FYWaSEpvkvGWrYOeSEZGuroug2pf/tTPS1cF+J
        XNUlu+nD94HyH6OXvmXUPJA=
X-Google-Smtp-Source: ABdhPJwsSykFvcf02O1u/wsg4m10MFtEAdXQrg/SfurTHhIkWkygVSkLiHtAiYWOX77gRxUr9iLHEw==
X-Received: by 2002:aa7:80d5:0:b029:1a3:832a:1fd0 with SMTP id a21-20020aa780d50000b02901a3832a1fd0mr9509368pfn.6.1610039665350;
        Thu, 07 Jan 2021 09:14:25 -0800 (PST)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q26sm6468394pfl.219.2021.01.07.09.14.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 09:14:24 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] net: broadcom: share header defining UniMAC
 registers
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Doug Berger <opendmb@gmail.com>, Ray Jui <ray.jui@broadcom.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Timur Tabi <timur@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210106073245.32597-1-zajec5@gmail.com>
 <20210106073245.32597-2-zajec5@gmail.com>
 <284cc000-edf1-e943-2531-8c23e9470de1@gmail.com>
 <ed92d6bd-0d07-afbb-6b53-23180a5abae9@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <362ccb19-8f58-6bb6-a49b-c9eea93a5366@gmail.com>
Date:   Thu, 7 Jan 2021 09:14:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ed92d6bd-0d07-afbb-6b53-23180a5abae9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/21 12:37 PM, Rafał Miłecki wrote:
> On 06.01.2021 20:26, Florian Fainelli wrote:
>> On 1/5/21 11:32 PM, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> UniMAC is integrated into multiple Broadcom's Ethernet controllers so
>>> use a shared header file for it and avoid some code duplication.
>>>
>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>> ---
>>>   MAINTAINERS                                   |  2 +
>>
>> Don't you need to update the BGMAC section to also list unimac.h since
>> it is a shared header now? This looks good to me, the conversion does
>> produce the following warnings on x86-64 (and probably arm64, too):
>>
>> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_set_rx_mode':
>> drivers/net/ethernet/broadcom/bgmac.c:788:33: warning: conversion from
>> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
>> '18446744073709551599' to '4294967279' [-Woverflow]
>>    788 |   bgmac_umac_cmd_maskset(bgmac, ~CMD_PROMISC, 0, true);
>> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_mac_speed':
>> drivers/net/ethernet/broadcom/bgmac.c:828:13: warning: conversion from
>> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
>> '18446744073709550579' to '4294966259' [-Woverflow]
>>    828 |  u32 mask = ~(CMD_SPEED_MASK << CMD_SPEED_SHIFT | CMD_HD_EN);
>>        |             ^
>> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_chip_reset':
>> drivers/net/ethernet/broadcom/bgmac.c:999:11: warning: conversion from
>> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
>> '18446744073197811804' to '3783227484' [-Woverflow]
>>    999 |           ~(CMD_TX_EN |
>>        |           ^~~~~~~~~~~~~
>>   1000 |      CMD_RX_EN |
>>        |      ~~~~~~~~~~~
>>   1001 |      CMD_RX_PAUSE_IGNORE |
>>        |      ~~~~~~~~~~~~~~~~~~~~~
>>   1002 |      CMD_TX_ADDR_INS |
>>        |      ~~~~~~~~~~~~~~~~~
>>   1003 |      CMD_HD_EN |
>>        |      ~~~~~~~~~~~
>>   1004 |      CMD_LCL_LOOP_EN |
>>        |      ~~~~~~~~~~~~~~~~~
>>   1005 |      CMD_CNTL_FRM_EN |
>>        |      ~~~~~~~~~~~~~~~~~
>>   1006 |      CMD_RMT_LOOP_EN |
>>        |      ~~~~~~~~~~~~~~~~~
>>   1007 |      CMD_RX_ERR_DISC |
>>        |      ~~~~~~~~~~~~~~~~~
>>   1008 |      CMD_PRBL_EN |
>>        |      ~~~~~~~~~~~~~
>>   1009 |      CMD_TX_PAUSE_IGNORE |
>>        |      ~~~~~~~~~~~~~~~~~~~~~
>>   1010 |      CMD_PAD_EN |
>>        |      ~~~~~~~~~~~~
>>   1011 |      CMD_PAUSE_FWD),
>>        |      ~~~~~~~~~~~~~~
>> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_enable':
>> drivers/net/ethernet/broadcom/bgmac.c:1057:32: warning: conversion from
>> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
>> '18446744073709551612' to '4294967292' [-Woverflow]
>>   1057 |  bgmac_umac_cmd_maskset(bgmac, ~(CMD_TX_EN | CMD_RX_EN),
>>        |                                ^~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_chip_init':
>> drivers/net/ethernet/broadcom/bgmac.c:1108:32: warning: conversion from
>> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
>> '18446744073709551359' to '4294967039' [-Woverflow]
>>   1108 |  bgmac_umac_cmd_maskset(bgmac, ~CMD_RX_PAUSE_IGNORE, 0, true);
>> drivers/net/ethernet/broadcom/bgmac.c:1117:33: warning: conversion from
>> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
>> '18446744073709518847' to '4294934527' [-Woverflow]
>>   1117 |   bgmac_umac_cmd_maskset(bgmac, ~CMD_LCL_LOOP_EN, 0, false);
> 
> I can reproduce that after switching from mips to arm64. Before this
> change bgmac.h was not using BIT() macro. Now it does and that macro
> forces UL (unsigned long).
> 
> Is there any cleaner solution than below one?

Don't use BIT(), if the constants are 32-bit unsigned integer, maybe
open coding them as (1 << x) is acceptable for that purpose.
-- 
Florian
