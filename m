Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A255416C319
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgBYN7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:59:22 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51506 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729287AbgBYN7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:59:21 -0500
Received: by mail-wm1-f65.google.com with SMTP id t23so3111241wmi.1;
        Tue, 25 Feb 2020 05:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1LEeQz9rLoFuQ2vwZIwdg0x06s31QUfcOgdiVu+Auj4=;
        b=QkhjKjcj15gtMfq5DbTi6oPAlp7mWTNwPx5w9VypaUoZZIbWJcGFBAYnj0jx/gfgh8
         26JELHXryYgVKnFItMOnD9OMYx12Kr1EdHFqFTVuwz52rL9AKaeoHIEoI1OMpH5thmxa
         7tlOkadCco7AkK0bXzzhDZbrKCsEHaEMspCOljVH9ftSTMm7EFIZxNUJ1KKpLRd3p7w8
         yDSfTHxIbNR267GpJeE9JKVroJud9RPE8w5ye5vDE8iWW65XSTmcKxJEpHfT+mElvi79
         cgddb5RIvmyTp6jZvQC/pWjwGvMOr5io/GaKl1w1/YQurF5kS2pKIRmzhclixP8sK9bL
         VkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1LEeQz9rLoFuQ2vwZIwdg0x06s31QUfcOgdiVu+Auj4=;
        b=HrZrlBnmVqh6/YLeAtorY8psKNxszAckq+gsKpxLSacOGO1YxCoZDyI5lkt5Z/4TKb
         V84P5VZ/ElN6LH2nbqq+S0OouTZoDNdbs2EcZK43BhDGQdHo0a+Zjs5sGQV+C/EEdDvg
         NqzZUGTFWtjNlM0xfSmsr0UfccKgunjE3qb7P0RZEbhJ9DArHiKe1+Vu3lYyoSxCcML+
         AsXkYmY3VFKKU12DugTskYOiXraWyVGInnMLlPqXPJF8KX2LMRojh+vTo5n4W/kOLlAu
         3ACkrFx9X7aFuOG58RiZx3pt7Ngh5elusEEkQGGwHmHhozK2nolxVx/Gd/HKtpYRrOWC
         ZNMg==
X-Gm-Message-State: APjAAAXD+9ZJmi3YG4h70m/yug6BSPIKmlJCrfuDwkpKijtM5uYmYRay
        facA665XM7YsLBf3UxvuNAeMHcZL
X-Google-Smtp-Source: APXvYqy+urL8B2E1P8ykBOqUQ1PxfKX3HkSr+CS+niES8z1lCOSFTwmcxUHtN8ud4xNBSnPKv01kLw==
X-Received: by 2002:a05:600c:2c13:: with SMTP id q19mr5640589wmg.144.1582639159661;
        Tue, 25 Feb 2020 05:59:19 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:30a8:e117:ed7d:d145? (p200300EA8F29600030A8E117ED7DD145.dip0.t-ipconnect.de. [2003:ea:8f29:6000:30a8:e117:ed7d:d145])
        by smtp.googlemail.com with ESMTPSA id 61sm8675693wrf.65.2020.02.25.05.59.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 05:59:19 -0800 (PST)
Subject: Re: [PATCH] net: phy: corrected the return value for
 genphy_check_and_restart_aneg
To:     Sudheesh Mavila <sudheesh.mavila@amd.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200225122208.6881-1-sudheesh.mavila@amd.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <90fc4cb6-d11b-20d0-a1fa-28e0564a425b@gmail.com>
Date:   Tue, 25 Feb 2020 14:59:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225122208.6881-1-sudheesh.mavila@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.02.2020 13:22, Sudheesh Mavila wrote:
> When auto-negotiation is not required, return value should be zero.
> 
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> ---
>  drivers/net/phy/phy_device.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 6a5056e0ae77..36cde3dac4c3 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1806,10 +1806,13 @@ int genphy_check_and_restart_aneg(struct phy_device *phydev, bool restart)
>  			restart = true;
>  	}
>  
> -	if (restart)
> -		ret = genphy_restart_aneg(phydev);
> +	/* Only restart aneg if we are advertising something different
> +	 * than we were before.
> +	 */
> +	if (restart > 0)

In addition to what Russell and Andrew commented already:
- You shouldn't compare a bool with an int. There's no need to change
  the original condition.
- The comment isn't really needed, and it's wrong. See the comment few
  lines earlier.
- After this change the initialization of ret isn't needed any longer.

> +		return genphy_restart_aneg(phydev);
>  
> -	return ret;
> +	return 0;
>  }
>  EXPORT_SYMBOL(genphy_check_and_restart_aneg);
>  
> 

