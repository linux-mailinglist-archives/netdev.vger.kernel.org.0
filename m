Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08AD62CFC2
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 21:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfE1Tsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 15:48:52 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33518 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfE1Tsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 15:48:52 -0400
Received: by mail-pl1-f196.google.com with SMTP id g21so8788674plq.0;
        Tue, 28 May 2019 12:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wF9HTKTSqjEWD9biAIqmvRFaHV98shxME6q1WLMW/+4=;
        b=hqiaki/L18RAHsXejAjkskhmBYA+5hAWciscX1QM3DxD8eGqN05EcRZq703tNpJk7m
         saZX2cundeLlnBd5nP1KrC5iZrd7XATBYsLrzOt4IdLad2Q2h+SdwiCDpSpgkUJMEyLc
         rzk0xJycl6xfZXCwe7mjYFUYx9LRMLZE9aZFn3YpCVgdFZ1Lx3E0oegpH2rGSuKyc4oQ
         t6VMjJmvC8pVtsvqwLdIQnmNSO/j3gk6UxbQZU/pmklB9sbc3CIfpFJgK+x32Qb58SdX
         tbwzIc17oyyZWBwm1f4QcquvYf0xhWW7T5Z+lXCvCu1XJAc+F91NxpjclKpw1HxwBKFb
         Pcvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=wF9HTKTSqjEWD9biAIqmvRFaHV98shxME6q1WLMW/+4=;
        b=HkbMhtAyenZOpRb1DzN8DA3j3Uz4kYZq/5rjEROPvyNmZzhunC5H5CY3u7bECjdWIS
         /hv6cjfcf3ZXdc19+w2uu4EzATlOnrw9jqwcYVhEiKB+gujTeRY3FBt7+csm9x+AXEsN
         xzaA3fy89oPbMW75LgjL395CLqyZ6u7A1up40WCkGOPXU8tl3wQm0VibfYmEpNPVl+9g
         fE//lHp9wlWhBtiIsE+IHo6vH4pW896gzOhQD0hdlp81VaojtzYloTXWJ4l8z6L+ftS3
         PesVmVHmZZgO/ZLlwLGKCGayqMg/iaaQc1SN4fCKD4nCi2CiLH/ib/3c8Vx88x7/BcvM
         3bMw==
X-Gm-Message-State: APjAAAVonSlOSko3Lo2C8GqEOk3uekKZTmyItrOEHNm4vV8s+PJJOYgC
        s0VdfWd7WY84AqCl1tkTuFI=
X-Google-Smtp-Source: APXvYqxBT35dsp3x051eqR+xZigGwx3StF4HGBIas7azqnb4lycmbzpKFUlp4YR9S3RTk/VPeRi70A==
X-Received: by 2002:a17:902:8609:: with SMTP id f9mr76857704plo.252.1559072931874;
        Tue, 28 May 2019 12:48:51 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h123sm16915268pfe.80.2019.05.28.12.48.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 12:48:50 -0700 (PDT)
Date:   Tue, 28 May 2019 12:48:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH] net: phy: tja11xx: Switch to HWMON_CHANNEL_INFO()
Message-ID: <20190528194850.GF24853@roeck-us.net>
References: <20190528181541.1946-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528181541.1946-1-marex@denx.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 08:15:41PM +0200, Marek Vasut wrote:
> The HWMON_CHANNEL_INFO macro simplifies the code, reduces the likelihood
> of errors, and makes the code easier to read.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Guenter Roeck <linux@roeck-us.net>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: linux-hwmon@vger.kernel.org
> ---
>  drivers/net/phy/nxp-tja11xx.c | 24 ++----------------------
>  1 file changed, 2 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
> index 11b8701e78fd..b705d0bd798b 100644
> --- a/drivers/net/phy/nxp-tja11xx.c
> +++ b/drivers/net/phy/nxp-tja11xx.c
> @@ -311,29 +311,9 @@ static umode_t tja11xx_hwmon_is_visible(const void *data,
>  	return 0;
>  }
>  
> -static u32 tja11xx_hwmon_in_config[] = {
> -	HWMON_I_LCRIT_ALARM,
> -	0
> -};
> -
> -static const struct hwmon_channel_info tja11xx_hwmon_in = {
> -	.type		= hwmon_in,
> -	.config		= tja11xx_hwmon_in_config,
> -};
> -
> -static u32 tja11xx_hwmon_temp_config[] = {
> -	HWMON_T_CRIT_ALARM,
> -	0
> -};
> -
> -static const struct hwmon_channel_info tja11xx_hwmon_temp = {
> -	.type		= hwmon_temp,
> -	.config		= tja11xx_hwmon_temp_config,
> -};
> -
>  static const struct hwmon_channel_info *tja11xx_hwmon_info[] = {
> -	&tja11xx_hwmon_in,
> -	&tja11xx_hwmon_temp,
> +	HWMON_CHANNEL_INFO(in, HWMON_I_LCRIT_ALARM),
> +	HWMON_CHANNEL_INFO(temp, HWMON_T_CRIT_ALARM),
>  	NULL
>  };
>  
> -- 
> 2.20.1
> 
