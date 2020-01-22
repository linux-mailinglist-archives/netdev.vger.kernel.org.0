Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9118145B3D
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 18:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgAVR6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 12:58:34 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46415 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVR6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 12:58:34 -0500
Received: by mail-ed1-f67.google.com with SMTP id m8so421814edi.13
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 09:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mjXeG66n6CJPSYgojRfKKGGiQ2YMHcEzfQXjFf9M2X4=;
        b=Za+4f6n0Xr0DuyxEp3QoUqLrhZ18O21J4jtQ+CT2Otb5qKIbQaZvZetTBjdCBBaT+v
         cFMexyVA/qLYdPX5yqh15pCSZbLKQ7AexwGwMPsid0FDlkVt8c2XYmKd8FRshTvRFK4/
         tFXwBNjZ0g6kBDc6sM4aDLK/4mpeRlGcER7XqpWQMJD2XEemAjQvw2z8XL2YxrN83MwU
         d4U+JucPyWGgAO2k0Lkj06sJzzfW4V1KmRXaItMGSJXC5QKHxWQTxkWlyW+J+ez6HGXq
         XG0WbcGGr1YZjG0Vzo9KwMQu1du5td32bwQnM0OkxtSm1r9oCXwd4+It4xYc+jkhq+Yt
         umDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mjXeG66n6CJPSYgojRfKKGGiQ2YMHcEzfQXjFf9M2X4=;
        b=gmdDxfBjy4BL1hZWg8is6xRGvJOcafdu2YMZyuBKj/rpqMdVXAxOURnQKpFbUJeuAz
         x4r9Onp6Xq+pqRZwulQd8IUwOaGtmiPFivOtYgVJ2G/wh3TxJfDWjH+/sd7zA5SY/uCf
         7U5CWQCBw9xFEH0s21Gpbm4wOMhwwL8s3wsKmw/Uv+I/y8UvQSnke+oBi+LAX19kMTPI
         GdrCXSjOc9o2V1XMsbn3SrxGt7j0w1g/boNArKYfMsF3Orv/Y1LREUu8k4Ym8NUEmQdo
         5PL3rxadF0a4XToQdxh+FBSwVHWO4hf8Im7uFvsaMVJoEiFiNqohtCHiGTaQs1Tx0kQM
         OPag==
X-Gm-Message-State: APjAAAVBbvGJGJkdPiyZjco9/J3qKLSfp1icXH2oWvk6KnmaUSb1/et9
        j5MhZP4taHf15ctcutVtrjk=
X-Google-Smtp-Source: APXvYqw2/RGufZTk+G2gKKoGZPwMgwHeGzCyA3S1kugZ9jeUXKbEkV/sxfP1AYrnC4NnuVnk8BRPNw==
X-Received: by 2002:a50:aacd:: with SMTP id r13mr3683668edc.129.1579715912719;
        Wed, 22 Jan 2020 09:58:32 -0800 (PST)
Received: from [10.67.48.204] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d92sm1496390edc.7.2020.01.22.09.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 09:58:32 -0800 (PST)
Subject: Re: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
To:     madalin.bucur@oss.nxp.com, davem@davemloft.net
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        ykaukab@suse.de
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com>
Date:   Wed, 22 Jan 2020 09:58:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/20 5:59 AM, Madalin Bucur wrote:
> The AQR PHYs are able to perform rate adaptation between
> the system interface and the line interfaces. When such
> a PHY is deployed, the ethernet driver should not limit
> the modes supported or advertised by the PHY. This patch
> introduces the bit that allows checking for this feature
> in the phy_device structure and its use for the Aquantia
> PHYs.
> 
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> ---
>  drivers/net/phy/aquantia_main.c | 3 +++
>  include/linux/phy.h             | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
> index 975789d9349d..36fdd523b758 100644
> --- a/drivers/net/phy/aquantia_main.c
> +++ b/drivers/net/phy/aquantia_main.c
> @@ -209,6 +209,9 @@ static int aqr_config_aneg(struct phy_device *phydev)
>  	u16 reg;
>  	int ret;
>  
> +	/* add here as this is called for all devices */
> +	phydev->rate_adaptation = 1;

How about introducing a new PHY_SUPPORTS_RATE_ADAPTATION flag and you
set that directly from the phy_driver entry? using the "flags" bitmask
instead of adding another structure member to phy_device?

> +
>  	if (phydev->autoneg == AUTONEG_DISABLE)
>  		return genphy_c45_pma_setup_forced(phydev);
>  
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index dd4a91f1feaa..2a5c202333fc 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -387,6 +387,9 @@ struct phy_device {
>  	/* Interrupts are enabled */
>  	unsigned interrupts:1;
>  
> +	/* Rate adaptation in the PHY */
> +	unsigned rate_adaptation:1;
> +
>  	enum phy_state state;
>  
>  	u32 dev_flags;
> 


-- 
Florian
