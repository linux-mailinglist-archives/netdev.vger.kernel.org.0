Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EC42EC421
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 20:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbhAFTqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 14:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbhAFTqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 14:46:18 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA65BC06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 11:45:37 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id u4so451081pjn.4
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 11:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z2Fi6LidA33ASCb45f7449drMiT8KVxdzlES06YUhWI=;
        b=SlUxpYszQ7RUJ6l8KQKi5IC0e3r3Sp7pQfzEPTcACGC1qaS/E6OIHCg4qqwQz8kOZ9
         lFuFkXkYPzFGZ6bY9oA9N+3RtiM00I81eEeRCgfKcBnaU2p3ZepNWWWoeIBOJLv+Rt+l
         ZiyuWK5BeezmZTatbgWY/G+TVBls72YqNFqF1lCeaEwxYoqTycVPucmo3hTC2EoVk+fb
         kVVSQMtq51zFdNUZEhzCU6icDx3WwN2GafeDp49AMMxLlv2NcJA6WglLyjorVYoi0m1A
         7fHaYDzw2e4gHGcUaNsVHBkgfP2c0EvnV6JAKh3VJYYohZZzJ03meK9L2Sa8ii0KQIqg
         mL0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Z2Fi6LidA33ASCb45f7449drMiT8KVxdzlES06YUhWI=;
        b=MGjOF8rT8p7Tnv1+/qUarfWic1Z3LDvb5P5xKDA5xLgehFDqOr8ywHx6iiug0eHmEm
         8DJlXnXSWOC7vn0vSqwaCl3HFGeCPszUXcS0u1WlD46PA6m00+AxJVmC3jOh8nbnqf6A
         nYynKWKUN+Kao8wkJWaPjLYAEZlVkMSgD5Dzb53glsftOLKZRq2CJa01OP5x6EhNcCln
         WSWO3fhV+uXqAiijsXCb06PRQCfE2XSKF9XhckgGn6oC8uvUaGO0XHAxkrZ9lgkqydPH
         sQ3wUrk6fjgas4ptmYE03CmlPFPId4TJm68u1r3RGp0M9aty/HcBT7xHo3s5kTsZYO7M
         E1Tg==
X-Gm-Message-State: AOAM530Ura9SLBccYsMqZts8tk5OjlN4L3nJxhRaofP1ChDvY7TY8axs
        fRcI+cu/7164zes94kH6wuA=
X-Google-Smtp-Source: ABdhPJw11rzTfPIHISYmvf4Jr/6iSEqFtUHYsygqNAALZ9w81mtPG9wW2oCUHxI5lado9l2KhySXdQ==
X-Received: by 2002:a17:90a:1b29:: with SMTP id q38mr5662305pjq.223.1609962337207;
        Wed, 06 Jan 2021 11:45:37 -0800 (PST)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 3sm3365215pfv.92.2021.01.06.11.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 11:45:36 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] net: broadcom: share header defining UniMAC
 registers
To:     Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <b03b0817-8d22-0c95-651d-7d14300a4124@gmail.com>
Date:   Wed, 6 Jan 2021 11:45:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <284cc000-edf1-e943-2531-8c23e9470de1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/21 11:26 AM, Florian Fainelli wrote:
> On 1/5/21 11:32 PM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> UniMAC is integrated into multiple Broadcom's Ethernet controllers so
>> use a shared header file for it and avoid some code duplication.
>>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>>  MAINTAINERS                                   |  2 +
> 
> Don't you need to update the BGMAC section to also list unimac.h since
> it is a shared header now? This looks good to me, the conversion does
> produce the following warnings on x86-64 (and probably arm64, too):
> 
> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_set_rx_mode':
> drivers/net/ethernet/broadcom/bgmac.c:788:33: warning: conversion from
> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
> '18446744073709551599' to '4294967279' [-Woverflow]
>   788 |   bgmac_umac_cmd_maskset(bgmac, ~CMD_PROMISC, 0, true);
> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_mac_speed':
> drivers/net/ethernet/broadcom/bgmac.c:828:13: warning: conversion from
> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
> '18446744073709550579' to '4294966259' [-Woverflow]
>   828 |  u32 mask = ~(CMD_SPEED_MASK << CMD_SPEED_SHIFT | CMD_HD_EN);
>       |             ^
> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_chip_reset':
> drivers/net/ethernet/broadcom/bgmac.c:999:11: warning: conversion from
> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
> '18446744073197811804' to '3783227484' [-Woverflow]
>   999 |           ~(CMD_TX_EN |
>       |           ^~~~~~~~~~~~~
>  1000 |      CMD_RX_EN |
>       |      ~~~~~~~~~~~
>  1001 |      CMD_RX_PAUSE_IGNORE |
>       |      ~~~~~~~~~~~~~~~~~~~~~
>  1002 |      CMD_TX_ADDR_INS |
>       |      ~~~~~~~~~~~~~~~~~
>  1003 |      CMD_HD_EN |
>       |      ~~~~~~~~~~~
>  1004 |      CMD_LCL_LOOP_EN |
>       |      ~~~~~~~~~~~~~~~~~
>  1005 |      CMD_CNTL_FRM_EN |
>       |      ~~~~~~~~~~~~~~~~~
>  1006 |      CMD_RMT_LOOP_EN |
>       |      ~~~~~~~~~~~~~~~~~
>  1007 |      CMD_RX_ERR_DISC |
>       |      ~~~~~~~~~~~~~~~~~
>  1008 |      CMD_PRBL_EN |
>       |      ~~~~~~~~~~~~~
>  1009 |      CMD_TX_PAUSE_IGNORE |
>       |      ~~~~~~~~~~~~~~~~~~~~~
>  1010 |      CMD_PAD_EN |
>       |      ~~~~~~~~~~~~
>  1011 |      CMD_PAUSE_FWD),
>       |      ~~~~~~~~~~~~~~
> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_enable':
> drivers/net/ethernet/broadcom/bgmac.c:1057:32: warning: conversion from
> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
> '18446744073709551612' to '4294967292' [-Woverflow]
>  1057 |  bgmac_umac_cmd_maskset(bgmac, ~(CMD_TX_EN | CMD_RX_EN),
>       |                                ^~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_chip_init':
> drivers/net/ethernet/broadcom/bgmac.c:1108:32: warning: conversion from
> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
> '18446744073709551359' to '4294967039' [-Woverflow]
>  1108 |  bgmac_umac_cmd_maskset(bgmac, ~CMD_RX_PAUSE_IGNORE, 0, true);
> drivers/net/ethernet/broadcom/bgmac.c:1117:33: warning: conversion from
> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
> '18446744073709518847' to '4294934527' [-Woverflow]
>  1117 |   bgmac_umac_cmd_maskset(bgmac, ~CMD_LCL_LOOP_EN, 0, false);
> 
> 
> I did verify that the md5sum of the objects does not change before and
> after changes (except bgmac.o, which is expected due to the warning
> above0, so that gives me good confidence that the changes are correct :)
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Thanks for doing this.

For GENET and SYSTEMPORT you should be able to share the MIB counters as
well, and in premise we could even get a step further and share the
ethtool stats array between drivers since they are the exact same. You
don't have to include that as part of your series though, we can address
it later. We have a third driver coming up which is also using an UniMAC
and could benefit from not replicating these headers.
-- 
Florian
