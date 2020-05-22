Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94651DECE9
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 18:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730390AbgEVQLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 12:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730195AbgEVQLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 12:11:14 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121E9C061A0E;
        Fri, 22 May 2020 09:11:14 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id f21so2197324pgg.12;
        Fri, 22 May 2020 09:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6yGwOkXLg7GHKHathTBWhqxYl0q0EDsPE6Xli2YNqgM=;
        b=ezt7no7rFfuyVnbv7ys1ZSAS1QceFEK4CnfrJrloyrjdfo/ENc5Jb/vUSIt9qZRCVi
         k82tOj5elvhMWbRZe7bZ49J7RC6Kduui61/Ww2qccIalrNT/PAHjeoqXWEVhxCnq5Lem
         QSMI2UXek50KnEObR+SeCEFa39WavI7wwrFd5PU61DDBA+JbQDgxYG9pap/0S/pN1Axt
         f3uM+GVBUCgRjKDa/WjeLM3x3F9fh0ZgF680OefkIu9FBrUL0xw8+I3M/TXi5gnqp8oC
         b1KNBbf1vx6nmtbyfyJH3iuogURcdbw5f2DUPCk3DLw/2HaHUh7hAy2j9xsIKn7guhLS
         0Htw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6yGwOkXLg7GHKHathTBWhqxYl0q0EDsPE6Xli2YNqgM=;
        b=E6TJ57T9PaX3RlMJzFfwr/ONC/vRxMSv+66Efg0fbn/sBzgBvbBTzlBmbZEROTf6jD
         oUNxeWGDrGdgcj/3LZzyrdQEvCM5QBtGp2pV5jGjnZDFndB8CEWUURmAJ0EXxaY/R7vZ
         4id61IEXDTsglSgOfMb9YDmQCltqPKacBIX3ojvhzN98qgU9Gisf9XDkxxfL+es2IYUO
         8j+TU3gPrFfNjMfThLG8hod4Lt2bmZZU5CBP2Wr2Cf6h2kBkVPAaNrA8tAN3XzXdSux6
         03IgwORNBh0+UsjEUD14C4sH7elzYPtoC3pAbRM1WiaSwztSgw6NpDIv9RyA2TlMGoVC
         dZeQ==
X-Gm-Message-State: AOAM530oDrF0yjS+yKXE2zGhef5MhsziHEFQ05JGyqEtsX1u3/v3XZO3
        HwIKIbcmo9i2QeAuvahatKtP6UIJ
X-Google-Smtp-Source: ABdhPJxiQcMkTlT2EgGKGmZxNBYjphQYy22duEAY+YaW20zVknDvqyZME8MWl9SPtKdIrM1SgckLsg==
X-Received: by 2002:a65:6799:: with SMTP id e25mr14924885pgr.9.1590163873042;
        Fri, 22 May 2020 09:11:13 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u4sm11820575pjf.3.2020.05.22.09.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 09:11:12 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/4] net: phy: Add a helper to return the
 index for of the internal delay
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, robh@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20200522122534.3353-1-dmurphy@ti.com>
 <20200522122534.3353-3-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <da85ecb0-1da1-2ccd-0830-a3ec18ee486c@gmail.com>
Date:   Fri, 22 May 2020 09:11:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522122534.3353-3-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/2020 5:25 AM, Dan Murphy wrote:
> Add a helper function that will return the index in the array for the
> passed in internal delay value.  The helper requires the array, size and
> delay value.
> 
> The helper will then return the index for the exact match or return the
> index for the index to the closest smaller value.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  drivers/net/phy/phy_device.c | 45 ++++++++++++++++++++++++++++++++++++
>  include/linux/phy.h          |  2 ++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 7481135d27ab..40f53b379d2b 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2661,6 +2661,51 @@ void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause)
>  }
>  EXPORT_SYMBOL(phy_get_pause);
>  
> +/**
> + * phy_get_delay_index - returns the index of the internal delay
> + * @phydev: phy_device struct
> + * @delay_values: array of delays the PHY supports
> + * @size: the size of the delay array
> + * @delay: the delay to be looked up
> + *
> + * Returns the index within the array of internal delay passed in.

Can we consider using s32 for storage that way the various
of_read_property_read_u32() are a natural fit (int works too, but I
would prefer being explicit).

> + */
> +int phy_get_delay_index(struct phy_device *phydev, int *delay_values, int size,
> +			int delay)
> +{
> +	int i;
> +
> +	if (size <= 0)
> +		return -EINVAL;
> +
> +	if (delay <= delay_values[0])
> +		return 0;
> +
> +	if (delay > delay_values[size - 1])
> +		return size - 1;

Does not that assume that the delays are sorted by ascending order, if
so, can you make it clear in the kernel doc?

> +
> +	for (i = 0; i < size; i++) {
> +		if (delay == delay_values[i])
> +			return i;
> +
> +		/* Find an approximate index by looking up the table */
> +		if (delay > delay_values[i - 1] &&

&& i > 0 so you do not accidentally under-run the array?

> +		    delay < delay_values[i]) {
> +			if (delay - delay_values[i - 1] < delay_values[i] - delay)
> +				return i - 1;
> +			else
> +				return i;
> +		}
> +
> +	}
> +
> +	phydev_err(phydev, "error finding internal delay index for %d\n",
> +		   delay);
> +
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL(phy_get_delay_index);
> +
>  static bool phy_drv_supports_irq(struct phy_driver *phydrv)
>  {
>  	return phydrv->config_intr && phydrv->ack_interrupt;
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 2bcdf19ed3b4..73552612c189 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -1408,6 +1408,8 @@ void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx);
>  bool phy_validate_pause(struct phy_device *phydev,
>  			struct ethtool_pauseparam *pp);
>  void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause);
> +int phy_get_delay_index(struct phy_device *phydev, int *delay_values,
> +			int size, int delay);
>  void phy_resolve_pause(unsigned long *local_adv, unsigned long *partner_adv,
>  		       bool *tx_pause, bool *rx_pause);
>  
> 

-- 
Florian
