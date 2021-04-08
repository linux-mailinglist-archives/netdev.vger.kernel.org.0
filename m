Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E99357EA7
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhDHJDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhDHJDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 05:03:09 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD03C061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 02:02:58 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x15so1278884wrq.3
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 02:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=77cHg8LuhM3IDi6HJrJagIBM1vf3FkR2J5qESmxOhBs=;
        b=LPIT6lZVssaojzziKtsyTEd20YwVUp0BOKnu2CA+NobnegY3G4ET+6zJgi+XvOYmj0
         nhove0vbI8t4V7B4WFN46P2kGi4RgH5BZ0AduT7zU8/h01edTKd+FWoofRyjeDh7dV4W
         hzCbnITJarTduHS8mXGj5gZr51Cr9bSNnWEnycSBxXTSchCpAjJD27YVyiH6+07nypOT
         vYgDSFGvPTnpI8Ww1RGdPz76GGy37UduH+A/2oiU4LUolg8RnOoZBj/Dfejh20x7Rh6H
         vZQu7B6KBbU2+OjNLNIUq4VMaeqYEFCIZWfSDVCv8PaqXfT4SVqB2pxMql2bNJ3htXK0
         MAMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=77cHg8LuhM3IDi6HJrJagIBM1vf3FkR2J5qESmxOhBs=;
        b=P7xynadloOfMmTS+HzCciUtAac5tSRWIvXDu0V0MnMdL8ayAuUozQmpQOJvEAsct9X
         mg65xb42AUqsfBsVq3vSc/rPdlM1PI7YBu5sXBT22oan9AW3SVv03itpRefbLNfFo2oK
         cbN+KqYEiS2/w/QoD0PUbRcvAPxy2m5oHKhbJF27R9ntMxPJ36+D1QF343gkUlBuccHo
         8BRPElBJksBeIp0G3vmccgEQnYbm4lnUy4wog6+9/2EnI592q7QRKkvKxvjz0zjzYwA6
         A79Cw8+yH7nXC3ll8sL2hK4vq2kZp0WH9GmeEPNmV40ByaIrXToszLOO3psnXnQMLqYe
         f6CQ==
X-Gm-Message-State: AOAM530YSKyfeFyovxsdxpYgr8tWwP4NBB+XtgRmS71Yh7Z3nZ+am0b0
        uUNSNjY4UwuejCMeFiKh8zBjRu71VGg=
X-Google-Smtp-Source: ABdhPJztewboEb0cWbQd0mqhEI+5fA0MWS47XumsaXKs+SHyJAJUWdJ2IXA1jKtana10pjwk6JPllw==
X-Received: by 2002:adf:e387:: with SMTP id e7mr9386380wrm.44.1617872576495;
        Thu, 08 Apr 2021 02:02:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:6dfe:cdb3:c4f9:2744? (p200300ea8f3846006dfecdb3c4f92744.dip0.t-ipconnect.de. [2003:ea:8f38:4600:6dfe:cdb3:c4f9:2744])
        by smtp.googlemail.com with ESMTPSA id w10sm17417590wrv.95.2021.04.08.02.02.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 02:02:55 -0700 (PDT)
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
 <DB8PR04MB6795C5587FB2FF7DB1B40160E6749@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 0/3] net: make PHY PM ops a no-op if MAC driver
 manages PHY PM
Message-ID: <4defd59a-7c09-1227-ad85-c40b81f39087@gmail.com>
Date:   Thu, 8 Apr 2021 11:02:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795C5587FB2FF7DB1B40160E6749@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.04.2021 07:42, Joakim Zhang wrote:
> 
> Hi Heiner,
> 
> Why not target this patch set to net repo as a bug fixes? Others may also suffer from this.
> 
Reason is that the patch includes new functionality that usually
doesn't get backported. I'd like to see whether your case remains
the only one or whether there will be more similar reports.
In this case we had to think about a fix that doesn't need new
functionality or check whether backporting the new functionality
would be acceptable.

> Best Regards,
> Joakim Zhang
> 
Heiner

>> -----Original Message-----
>> From: Heiner Kallweit <hkallweit1@gmail.com>
>> Sent: 2021年4月7日 23:51
>> To: Andrew Lunn <andrew@lunn.ch>; Russell King - ARM Linux
>> <linux@armlinux.org.uk>; Jakub Kicinski <kuba@kernel.org>; David Miller
>> <davem@davemloft.net>; Fugang Duan <fugang.duan@nxp.com>
>> Cc: netdev@vger.kernel.org; Joakim Zhang <qiangqing.zhang@nxp.com>
>> Subject: [PATCH net-next 0/3] net: make PHY PM ops a no-op if MAC driver
>> manages PHY PM
>>
>> Resume callback of the PHY driver is called after the one for the MAC driver.
>> The PHY driver resume callback calls phy_init_hw(), and this is potentially
>> problematic if the MAC driver calls phy_start() in its resume callback. One issue
>> was reported with the fec driver and a KSZ8081 PHY which seems to become
>> unstable if a soft reset is triggered during aneg.
>>
>> The new flag allows MAC drivers to indicate that they take care of
>> suspending/resuming the PHY. Then the MAC PM callbacks can handle any
>> dependency between MAC and PHY PM.
>>
>> Heiner Kallweit (3):
>>   net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM
>>   net: fec: use mac-managed PHY PM
>>   r8169: use mac-managed PHY PM
>>
>>  drivers/net/ethernet/freescale/fec_main.c | 3 +++
>> drivers/net/ethernet/realtek/r8169_main.c | 3 +++
>>  drivers/net/phy/phy_device.c              | 6 ++++++
>>  include/linux/phy.h                       | 2 ++
>>  4 files changed, 14 insertions(+)
>>
>> --
>> 2.31.1
> 

