Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1363E13B2D8
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 20:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgANTVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 14:21:31 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45617 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANTVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 14:21:30 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so13322916wrj.12
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 11:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QJLDq14f39yOcS2mcOQCkyRhKJ+NIw05mpXsM1cbSn0=;
        b=MdAYrdH9LrQHxYI+UXO42NU6pQWpMFV2sFbUwrBvX7MlGkzsW3eV06+1YwbtCfwoE0
         AR4IgWZ343uqY44h+OykaPvnryzOlQjRJATumkJJNr5HZPQgCkVN7I+6Tb4LPh7MZ+Y1
         bei3w5Xfkh5VldkuxJju0SvgeMU/ENwBFHNZSXCEhLTG7eoL09C8ZgGskbT7yWldFY3D
         YTqtsjzOq0Ok4Yy7eYWZdrAaLiGQwXna8/hNaoqzFQ5hLaHfzIDwPEpkafSyIkF+mKoN
         +yJyYSqx0uGcqcKvVG9dCPXVq01cTFBMuL984G+XIz6W6Ld5hZz7xtkaMLmEPKujfLma
         D2zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QJLDq14f39yOcS2mcOQCkyRhKJ+NIw05mpXsM1cbSn0=;
        b=BoUPzK09Chg0CjbSr2+yiMtBRGWhpMmMZvTmj2r6lMILJnYuc9Q1+YsPtehN/rJWTc
         9Cpf7BNVnmi9AtYouIuH9YYcFroiu8jnGqkZfwVIrIJJWE36w8fH2kxVMZRxRRmFHUlm
         P9ZYYDtWpv1yNiwRROMqt6m0iL5b3vxIZhJa4j6vbQtveNQYMntvPCImjotZ9tOaIJ+x
         qe2nZwTzqGEVibdwt45lEg1ACYuTlVROL0H0mi/zfFoxwegajhhifg+O2NuvS/sMSXun
         +4xx/19bpKBYT6w/ycWYWQxEyqJ54vdMUlROzFQsz0Yk8CTrcY7MK0LhJGbN9LBrY+iW
         vccQ==
X-Gm-Message-State: APjAAAWlJ5Mtjjti/Di3/UKnl7Aj9iDbnGKA3/SkytAw0vnQX4QWBg6F
        gA5U3cX+8TDumtNrjPpUWojyXUE+
X-Google-Smtp-Source: APXvYqxMJKNXlUrO1mMwcQlVURPIvNHXCaS8t/5Lor5SuO6eAKzRagGqqmRa8RXKV1gTEPXK+L202g==
X-Received: by 2002:a5d:410e:: with SMTP id l14mr26068260wrp.238.1579029689017;
        Tue, 14 Jan 2020 11:21:29 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id p17sm19984652wmk.30.2020.01.14.11.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 11:21:28 -0800 (PST)
Subject: Re: [PATCH v2] net: phy: dp83867: Set FORCE_LINK_GOOD to default
 after reset
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, kernel@pengutronix.de
References: <20200114132502.GH11788@lunn.ch>
 <20200114164553.12997-1-m.grzeschik@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1871867b-717d-ba43-4a6e-1b469867b0aa@gmail.com>
Date:   Tue, 14 Jan 2020 20:21:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200114164553.12997-1-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.01.2020 17:45, Michael Grzeschik wrote:
> According to the Datasheet this bit should be 0 (Normal operation) in
> default. With the FORCE_LINK_GOOD bit set, it is not possible to get a
> link. This patch sets FORCE_LINK_GOOD to the default value after
> resetting the phy.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
> v1 -> v2: - fixed typo in subject line
>           - used phy_modify instead of read/write
> 
>  drivers/net/phy/dp83867.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index adda0d0eab800..68855177d92cc 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -99,6 +99,7 @@
>  #define DP83867_PHYCR_TX_FIFO_DEPTH_MASK	GENMASK(15, 14)
>  #define DP83867_PHYCR_RX_FIFO_DEPTH_MASK	GENMASK(13, 12)
>  #define DP83867_PHYCR_RESERVED_MASK		BIT(11)
> +#define DP83867_PHYCR_FORCE_LINK_GOOD		BIT(10)
>  
>  /* RGMIIDCTL bits */
>  #define DP83867_RGMII_TX_CLK_DELAY_MAX		0xf
> @@ -635,6 +636,15 @@ static int dp83867_phy_reset(struct phy_device *phydev)
>  
>  	usleep_range(10, 20);
>  
> +	/* After reset FORCE_LINK_GOOD bit is set. Although the
> +	 * default value should be unset. Disable FORCE_LINK_GOOD
> +	 * for the phy to work properly.
> +	 */
> +	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
> +			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
> +	if (err < 0)
> +		return err;
> +
>  	return 0;

You can simply do "return phy_modify();" here.

>  }
>  
> 

