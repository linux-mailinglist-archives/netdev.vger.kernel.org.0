Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE703145CD7
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 21:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgAVUFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 15:05:39 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40103 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVUFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 15:05:39 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so436103wrn.7
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 12:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zYMmTihlnk1DMWT7gkXqp5LvgiIFpZWKlcqvO6b0Q7s=;
        b=hVT0L/VTiNwY2CF6UAj5Q+u9wUnYLRrRZE3Il9PTvtiyEo1BH7qXAeocxlCpWlJl1j
         HEqRLKtIs5jrnL9ajbpiutrdq6CWBriBfw525fqW1SPKEE4aftF4EohDcp216NsOLA6L
         5Sm4jGnRsoPi71hspy6J5ERqjxah6Gdset9RN0sznA/p2Q0XfyUB1KF3p3jMbTYjrpBY
         xfE2BThIsmvuwHo6zxIJ5wlJry6zMrLkIaKi57QPtikv5yoTyepYw9O6HbItPaFYIu/V
         51Z4LYUaHN9Y+lvaNKXDFRUUp5qObH7h3gxktCCX1JrZZfMxdYjVEnbZPVuOdI6LQ8+/
         BL7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zYMmTihlnk1DMWT7gkXqp5LvgiIFpZWKlcqvO6b0Q7s=;
        b=hZz9m8GDm/KiJ20VL422PN6BsFFo/TPscELy6oemFLJP35YASu7kG+DvWtUT6g86U5
         4Wnzea8GGu7xPM3Slx95mmlI7U+XhufKTethAt9U+nlIujstt4mpz1Bcy9tz6wamcneZ
         RFoFq+OY8HFVswFRCucrzWry3/VYKSWYPyU7ul8qWxGrqXcsy3t4wNCJ0xa93OY1WL2j
         n2xsGQY564ADmFEER+7+oINya0Jrbtl5GhR6wHc6ImzgiWbfjk7c3nqMqNF3YYAXbS9x
         /s9q9BsjVt4OeCIn5dL6qiW8htdf0MKE5ql4J+p4hYphAL32pPP6rMYBNRBpueonsW/y
         LE1Q==
X-Gm-Message-State: APjAAAUbKZHBpwK/XnIPOG4nf8O8xO7D04wWjB9wX56RbE6ibsWsXoHt
        rGuH9RGcnTZ/nq3aIMzCrEw=
X-Google-Smtp-Source: APXvYqwVY4dRl0m6xJN9+3hba3spc0QijH5jCHbJ3WaLSOy5DAvxLi6ANUB2VR5WW1sVZCHfNcGXsg==
X-Received: by 2002:a5d:4386:: with SMTP id i6mr12841032wrq.63.1579723537343;
        Wed, 22 Jan 2020 12:05:37 -0800 (PST)
Received: from ?IPv6:2003:ea:8f36:6800:550a:88ee:b6b9:8233? (p200300EA8F366800550A88EEB6B98233.dip0.t-ipconnect.de. [2003:ea:8f36:6800:550a:88ee:b6b9:8233])
        by smtp.googlemail.com with ESMTPSA id z6sm59230643wrw.36.2020.01.22.12.05.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 12:05:36 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] dpaa_eth: support all modes with rate
 adapting PHYs
To:     madalin.bucur@oss.nxp.com, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org,
        ykaukab@suse.de
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1579701573-6609-3-git-send-email-madalin.bucur@oss.nxp.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <eaaf792f-c590-a0df-824f-c28a85b1887c@gmail.com>
Date:   Wed, 22 Jan 2020 21:05:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1579701573-6609-3-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.01.2020 14:59, Madalin Bucur wrote:
> Stop removing modes that are not supported on the system interface
> when the connected PHY is capable of rate adaptation. This addresses
> an issue with the LS1046ARDB board 10G interface no longer working
> with an 1G link partner after autonegotiation support was added
> for the Aquantia PHY on board in
> 
> commit 09c4c57f7bc4 ("net: phy: aquantia: add support for auto-negotiation configuration")
> 
> As it only worked in other modes besides 10G because the PHY
> was not configured by its driver to remove them, this is not
> really a bug fix but more of a feature add.
> 

I understand the issue, however the description may be a little misleading.
mac_dev->if_support doesn't include 1Gbps mode, therefore this mode is
removed from phydev->supported. What happens:
- before referenced commit: aqr_config_aneg() basically is a
  no-op and doesn't touch the advertised modes in the chip.
  Therefore 1Gbps is advertised and aneg succeeds.
- after referenced commit: 1Gbps is removed from modes advertised by the
  PHY, therefore aneg doesn't succeed.

Maybe in the context of this change the interface mode should be fixed.
These Aquantia PHY's don't support XGMII, they support USXGMII.
USXGMII support was added to phylib not too long ago, therefore older
drivers use value PHY_INTERFACE_MODE_XGMII. For the same compatibility
reason the Aquantia PHY driver still accepts PHY_INTERFACE_MODE_XGMII.

Heiner

> Reported-by: Mian Yousaf Kaukab <ykaukab@suse.de>
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index a301f0095223..d3eb235450e5 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2471,9 +2471,13 @@ static int dpaa_phy_init(struct net_device *net_dev)
>  		return -ENODEV;
>  	}
>  
> -	/* Remove any features not supported by the controller */
> -	ethtool_convert_legacy_u32_to_link_mode(mask, mac_dev->if_support);
> -	linkmode_and(phy_dev->supported, phy_dev->supported, mask);
> +	if (mac_dev->phy_if != PHY_INTERFACE_MODE_XGMII ||
> +	    !phy_dev->rate_adaptation) {
> +		/* Remove any features not supported by the controller */
> +		ethtool_convert_legacy_u32_to_link_mode(mask,
> +							mac_dev->if_support);
> +		linkmode_and(phy_dev->supported, phy_dev->supported, mask);
> +	}
>  
>  	phy_support_asym_pause(phy_dev);
>  
> 

