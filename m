Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23907ECFDA
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 18:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfKBRAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 13:00:33 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40067 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfKBRAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 13:00:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id f3so869676wmc.5;
        Sat, 02 Nov 2019 10:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xc27u7ceqiTWpTWlYOFM9ybCKdufAH8OMf4kxjbhRQw=;
        b=gUyGsL9EE3YYu2BfPXo30EkGD3MdhoJoDJJvckx3iDKrw/mkvdcwQrJnc6SO4aTWsn
         cHkDV4hoGyrLwan2RO1HfWbCXXD1L8z/klBRG8RORUsKGUDklCol2QRywssw7ATxd86P
         7r3EOZQ3Pov3B+gkhu9qVr8Y5jiWD9JQ9iTqG4I6W7UXdLD1+DV0Hhm0QAcrL+NnGVZ8
         ZbHvx/eznp3sMQGGZTzXI80FeR2k0XK6UXDSCTcPvVg2J45/3hRvNm3WsOqVoeSErzfK
         CFZvKAb0ja+36BG3b74ADscLJ1fa98UCMTivpD0jX4BTTgAlurCan7d3wHolhEljrZm0
         gz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xc27u7ceqiTWpTWlYOFM9ybCKdufAH8OMf4kxjbhRQw=;
        b=jSMmogCglWHhGaqN9pVLuO1UJRoad9DafPzqYRh2UoM7gGqX8UmDPCJw4DAc/1BrIK
         DbNg7fz+X8rxwn4PJkeW0MRvn2yci5pAzNgyKQjR3f2BafwB2+nhFSvoYhZbDNQlwvj8
         VZR+iQHW/ANhuyB8q1uyvJGJbs1jhY2Z4E7xBwj+BxQbj9wXQt6ILdagTXlsMMTABnS2
         u8kT4pgbxXNA2kexPo+aRNlRhj616u55VbLgkbUiVTgROs52Xwy4QDQi53HBHWBT2cMw
         T79HGpHim6RMT82wwDQdUIDDkGYotP535lHUyhPeJQLZyQ5jjwYBrncacczGJotWJ/YE
         E7Qw==
X-Gm-Message-State: APjAAAV2d8jM66zjFWmpkXeqMKHpDBduLo0nXd9i/Rylql1MXehMNRDv
        cz5puTjcEEm7VBo86/ukxZ+WsJ2D
X-Google-Smtp-Source: APXvYqxktjFb4BBT72+bjXHuAFTQodH6UymyBnkOnvrYr6YvBr1H5Beweg902Mq6MU7oGnQnNATBIg==
X-Received: by 2002:a1c:808d:: with SMTP id b135mr15108485wmd.175.1572714030425;
        Sat, 02 Nov 2019 10:00:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f17:6e00:d5ec:6bbe:31e4:1053? (p200300EA8F176E00D5EC6BBE31E41053.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:d5ec:6bbe:31e4:1053])
        by smtp.googlemail.com with ESMTPSA id b1sm4624617wrw.77.2019.11.02.10.00.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 Nov 2019 10:00:29 -0700 (PDT)
Subject: Re: [PATCH] net: phy: marvell: Fix bits clear bug
To:     Hansen Yang <yanghansen1@163.com>, andrew@lunn.ch
Cc:     f.fainelli@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 496645649@qq.com
References: <20191102141508.4416-1-yanghansen1@163.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f9972dcf-d586-ca1b-075f-69f4e61721db@gmail.com>
Date:   Sat, 2 Nov 2019 18:00:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191102141508.4416-1-yanghansen1@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.11.2019 15:15, Hansen Yang wrote:
> The correct way to clear bits before setting some of them is using
> "& = ~BIT_MASK".
> The wrong operation "& = BIT_MASK" will clear other bits.
> 
> m88e1116r_config_init() calls marvell_set_polarity() to config
> MDI crossover mode by modifying reg MII_M1011_PHY_SCR, then it
> calls marvell_set_downshift() to config downshift by modifying
> the same reg. According to the bug, marvell_set_downshift()
> clears other bits and set MDI Crossover Mode to Manual MDI
> configuration. If we connect two devices both using this driver
> with a wrong Ethernet cable, they can't automatically adjust
> their crossover mode. Finally they fail to link.
> 
Function marvell_set_downshift() doesn't exist any longer.
Note that all new developments should be against net-next.

If you want to submit this as a fix for stable:
- annotate patch as [PATCH net]
- add Fixes tag
- mention that fix applies up to 5.4 only

> Signed-off-by: Hansen Yang <yanghansen1@163.com>
> ---
>  drivers/net/phy/marvell.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index a7796134e3be..6ab8fe339043 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -282,7 +282,7 @@ static int marvell_set_downshift(struct phy_device *phydev, bool enable,
>  	if (reg < 0)
>  		return reg;
>  
> -	reg &= MII_M1011_PHY_SRC_DOWNSHIFT_MASK;
> +	reg &= ~MII_M1011_PHY_SRC_DOWNSHIFT_MASK;
>  	reg |= ((retries - 1) << MII_M1011_PHY_SCR_DOWNSHIFT_SHIFT);
>  	if (enable)
>  		reg |= MII_M1011_PHY_SCR_DOWNSHIFT_EN;
> 

Heiner
