Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E458C492
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 01:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfHMXCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 19:02:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36443 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfHMXCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 19:02:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so2821377wme.1
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 16:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GRAf1XBzSU7k1psNlRTXRx6YaYS8Dp13kO8Sy6Twlf0=;
        b=UvvrUcyo2qST/GUA3N+BfDqq0Wmv4bElaCnZVzE+LUQyfs6HjdFIceOwl7giryjscJ
         Q5GWp4WIbz4vWRQ7oeNjh7r5GDaq3Kkg+nycYaujHukrJe+rAWFg+5X+lFYUi6fahq8p
         TwAca1EqxGefNjtZU0ZOq73YMjRfHxr+10FaHztVw0moQjD7yDXzugmsMYGrlOEZW8aY
         q0wrTYoH4cWywOPCjiD6B3Cyo5Fv3M92QBanbrCjJ1LrLAsbgujIIxmvSh1MwrWGnsju
         MdNn7FmH78eIUi/0SOtMc25vWrckBiqdv/CFLkobvLBXsxyuGDMSXeF+GwsC1Olm+zwv
         II8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GRAf1XBzSU7k1psNlRTXRx6YaYS8Dp13kO8Sy6Twlf0=;
        b=EWdbSnN7GQs6HgnYFW+HPd0aE3PNIhFav3ZX1bFyWaNo4oZKG9QPBIFDOemlkW4tPk
         Fxkq7Z7IxNXxpfMxgQtr+oTmlLch29fe/Dxp0Apj/m29QIHXUraQRZwPQUKWWMaYiGgA
         tX13PV2a3OaiT5RLKhJu18Lp1awvRjjggDTblRwlKFMoTlgZUtdK56jqpPA9JDDaNqFO
         ojllkcClAE+jbXsARuRGVyEwc0Wy05/pRRnFI3l5spC+e/vpQTR9UtAk6zsooSsHu/+L
         G42i/UUcJ9y1nmUI8MDjm9Anr6L+XOPuGEBvkk3Y301PQcRtviOSFEna5n+ILg92ciEg
         f0pA==
X-Gm-Message-State: APjAAAURQaT6NC3qI0YsAtSn3ZtTCgzxjuZmObkg6BQqfd27DK57kCyh
        wvm+tUE2tOs3BeKTEgIeCPonCTZE
X-Google-Smtp-Source: APXvYqzCk2mh0WzZ5NStujD9TiJpjN3Mml2KnZ+IAxaVyFJq/NiHe9ElwUlTLLUMCLGjyNugSJgKhA==
X-Received: by 2002:a7b:c649:: with SMTP id q9mr4934878wmk.108.1565737336592;
        Tue, 13 Aug 2019 16:02:16 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a? (p200300EA8F2F3200E1E264B7EE242D4A.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a])
        by smtp.googlemail.com with ESMTPSA id f70sm4153177wme.22.2019.08.13.16.02.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 16:02:15 -0700 (PDT)
Subject: Re: [PATCH RFC 2/4] net: phy: allow to bind genphy driver at probe
 time
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Marek Behun <marek.behun@nic.cz>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ac3471d5-deb7-b711-6e74-23f59914758a@gmail.com>
 <b066560d-2cc3-2ea5-5233-e63a612c5aa1@gmail.com>
 <010ae64f-7e48-5e1e-2928-af3c4364f6e3@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7225e653-6f93-63fc-8d61-a712318d1949@gmail.com>
Date:   Wed, 14 Aug 2019 01:02:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <010ae64f-7e48-5e1e-2928-af3c4364f6e3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.08.2019 00:53, Florian Fainelli wrote:
> On 8/13/19 2:25 PM, Heiner Kallweit wrote:
>> In cases like a fixed phy that is never attached to a net_device we
>> may want to bind the genphy driver at probe time. Setting a PHY ID of
>> 0xffffffff to bind the genphy driver would fail due to a check in
>> get_phy_device(). Therefore let's change the PHY ID the genphy driver
>> binds to to 0xfffffffe. This still shouldn't match any real PHY,
>> and it will pass the check in get_phy_devcie().
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/phy/phy_device.c | 3 +--
>>  include/linux/phy.h          | 4 ++++
>>  2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 163295dbc..54f80af31 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -2388,8 +2388,7 @@ void phy_drivers_unregister(struct phy_driver *drv, int n)
>>  EXPORT_SYMBOL(phy_drivers_unregister);
>>  
>>  static struct phy_driver genphy_driver = {
>> -	.phy_id		= 0xffffffff,
>> -	.phy_id_mask	= 0xffffffff,
>> +	PHY_ID_MATCH_EXACT(GENPHY_ID),
>>  	.name		= "Generic PHY",
>>  	.soft_reset	= genphy_no_soft_reset,
>>  	.get_features	= genphy_read_abilities,
>> diff --git a/include/linux/phy.h b/include/linux/phy.h
>> index 5ac7d2137..3b07bce78 100644
>> --- a/include/linux/phy.h
>> +++ b/include/linux/phy.h
>> @@ -37,6 +37,10 @@
>>  #define PHY_1000BT_FEATURES	(SUPPORTED_1000baseT_Half | \
>>  				 SUPPORTED_1000baseT_Full)
>>  
>> +#define GENPHY_ID_HIGH		0xffffU
>> +#define GENPHY_ID_LOW		0xfffeU
>> +#define GENPHY_ID		((GENPHY_ID_HIGH << 16) | GENPHY_ID_LOW)
> 
> This is a possible user ABI change here, if there is anything that
> relies on reading 0xffff_ffff as a valid PHY OUI, you would be breaking
> it. We might as well try to assign ourselves a specific PHY OUI, very
> much like the Linux USB hubs show up with a Linux Foundation vendor ID.
> 

I see the point. However in get_phy_device() we have the following check
that should cause a PHY with ID 0xffff_ffff to be ignored. Therefore
I doubt there's any such PHY ID in use.

	/* If the phy_id is mostly Fs, there is no device there */
	if ((phy_id & 0x1fffffff) == 0x1fffffff)
		return ERR_PTR(-ENODEV);

Heiner
