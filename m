Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1B738F80B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhEYCYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhEYCYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:24:48 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAB7C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:23:18 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id g18so20742976pfr.2
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YNwxStsD+A4s3Y5YPD+y/yzjouBFbGraopsBtlg56ZE=;
        b=NSy9fOXI9c1ltnW1iqS2aDY0CjYdTLrxZPmU5nUiplUVxvp8/CCRd8pH5tgxLeGA2n
         fGQK1gUpwE7feIrfwJvsXmzw7hQPLoKhjHUKIUoKjs+dWqpZN/uZOXQx8ei4h7KYnlZH
         /NUsTT1vXhXgKjRUY1e84kaYRMHUfj9QS9fxU+noUadFygmlT0Nx5PClsJA76m8dRC9x
         yUVzD0nuHRx2NhHhc3gGaLH1PNzeG0y4z51VF78pbQNnremwBdbPLLWopXWQ/9uaUXzF
         PHwfx+ugwmKO76SCUtCBMcIqiXay+7aHYE8KLFG9V+qHnz8AexPfUIC7nNcHFLPMA37B
         E42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YNwxStsD+A4s3Y5YPD+y/yzjouBFbGraopsBtlg56ZE=;
        b=QuUrfbI2J63ZrWwey5Ykg1qII47OiR00EHTC4krqGwRiCdpM8RZto9EcwEVOUn+jv2
         sL8bytQZJYqGIO3H6mlMCrkPseZ0LcwyshMvlC9LPlWv73rHW0tb/jgD6UdMBTxgCitD
         gJAi+DbsV+pJAaVEVi4c2HOfydBMtzU181KxhnIAXj5QFvQq8Hsypi/BPf2h3tN/Gk8x
         XkBjtblDdyHh0eLSqdAe8r4SyNB5A4WPd+3nRY88I0PcC6a7qek85iJ2/AOAu4nTcIyU
         hWCGOBaWK1fV4PhEx99gE1cHcv5bn+967g8X1uCQcklleiLDwAIFY0t8GPtrBl5rgj6j
         QilA==
X-Gm-Message-State: AOAM530hlAveC2rdCDBNOu7o7wnazUQV2JLeqhddBSnBjr3M75FhM+M9
        IMbqx9xFkhBmbdqEjiGEF4Q=
X-Google-Smtp-Source: ABdhPJxutDzBIztARiDViD2PivV74OGN4LmkZBwB9mzuMYFcVz0btZdVhm6MRm9uNxRNna7bnvKFrw==
X-Received: by 2002:a63:1d42:: with SMTP id d2mr16401998pgm.21.1621909397578;
        Mon, 24 May 2021 19:23:17 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mt24sm11071808pjb.18.2021.05.24.19.23.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 19:23:17 -0700 (PDT)
Subject: Re: [PATCH net-next 05/13] net: dsa: sja1105: add a PHY interface
 type compatibility matrix
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e1d8f74a-6cb7-75bc-551c-5214998a2521@gmail.com>
Date:   Mon, 24 May 2021 19:23:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524232214.1378937-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> On the SJA1105, all ports support the parallel "xMII" protocols (MII,
> RMII, RGMII) except for port 4 on SJA1105R/S which supports only SGMII.
> This was relatively easy to model, by special-casing the SGMII port.
> 
> On the SJA1110, certain ports can be pinmuxed between SGMII and xMII, or
> between SGMII and an internal 100base-TX PHY. This creates problems,
> because the driver's assumption so far was that if a port supports
> SGMII, it uses SGMII.
> 
> We allow the device tree to tell us how the port pinmuxing is done, and
> check that against a PHY interface type compatibility matrix for
> plausibility.
> 
> The other big change is that instead of doing SGMII configuration based
> on what the port supports, we do it based on what is the configured
> phy_mode of the port.
> 
> The 2500base-x support added in this patch is not complete.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/sja1105/sja1105.h      |  5 +++
>  drivers/net/dsa/sja1105/sja1105_main.c | 59 +++++++++++++-------------
>  drivers/net/dsa/sja1105/sja1105_spi.c  | 20 +++++++++
>  3 files changed, 55 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
> index d5c0217b1f65..a27841642693 100644
> --- a/drivers/net/dsa/sja1105/sja1105.h
> +++ b/drivers/net/dsa/sja1105/sja1105.h
> @@ -111,6 +111,11 @@ struct sja1105_info {
>  				enum packing_op op);
>  	int (*clocking_setup)(struct sja1105_private *priv);
>  	const char *name;
> +	bool supports_mii[SJA1105_MAX_NUM_PORTS];
> +	bool supports_rmii[SJA1105_MAX_NUM_PORTS];
> +	bool supports_rgmii[SJA1105_MAX_NUM_PORTS];
> +	bool supports_sgmii[SJA1105_MAX_NUM_PORTS];
> +	bool supports_2500basex[SJA1105_MAX_NUM_PORTS];

If you used a bitmap you may be able to play some nice tricks with
ordering them in PHY_INTERFACE_MODE_* order and just increment a pointer
to the bitmap.

Since it looks like all of the chips support MII, RMII, and RGMII on all
ports, maybe you can specify only those that don't?

Still:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
