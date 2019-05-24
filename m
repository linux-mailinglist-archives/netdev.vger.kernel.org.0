Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE4929CC8
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731468AbfEXRYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:24:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40385 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfEXRYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:24:17 -0400
Received: by mail-wr1-f65.google.com with SMTP id t4so2506133wrx.7
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 10:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mA11Odh198KnOGL3eK3O5B1MhZXahK/t8NNAmnuwoMA=;
        b=GSvC0tJNA2wnlWtR3ejYktKRWA7sGH8PG5esQT46fPEoUhhc5IppyTNG8vlfRwpVX6
         cXNd+M49TQKx4rFnwXX+32b6337RVY3yCsVCrm4bNg3fI37GmC6aUebRB4qzaltHj7r5
         tf+D0pd+ajhY32VguCwBFUpjI0O5AZACJgHHoAvQRwjy7RZ3IB1f0/EfQc2JwNIOd7TE
         L8EU7smfdiEgnoM7rt3YPLwXntk+J5/lE6STI8HxZ5pc2aCqu8ljLPlJ07MHe0bgLAjt
         kVmpr1DGqlSaub+bQy0FoNEL33Lw7h56y59suETFrhhWEAxBDsAtH5LmPmm9oLt9dQlo
         HgPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mA11Odh198KnOGL3eK3O5B1MhZXahK/t8NNAmnuwoMA=;
        b=CT54a32e9BdcHaYsARuF+KvRFYS8S40JuTS+PHSGrPGwtFkEb+EYsuQzqklKiOp4Kj
         NlKx5pNJ5da0ryfS8MIHrf0sq5XenvQYwFyxrksJ66oM7xpRGhzYF215xU+4TfvJ0CYd
         NS+YfIWXXAjmIamsll9DVorNYDwzJ6qFvsTTetDIj+UggRXpaCP22Vv+I6GxbD5KLWOp
         w9VwE1SWdieJCmjZ8A4H8U50ZRhBivPfKUKO2vp8Cnnn+2zf7KUfQgu33lI2jNX7bMkZ
         mrqSFhgRmXNEliaJxLAqLM2fjfaBf0wYEjVwPwnA7SDQd8JgN/gy96BVwEV3uLhxPnUQ
         loqQ==
X-Gm-Message-State: APjAAAUenM5cwJoTn1kTwWQlvV6hM0In2etiuqjHJ2DvcwxIx4+0LQ8s
        HuLVO8R4jQg8HqYZ9xfgEMk=
X-Google-Smtp-Source: APXvYqyLOvc+6byRByNRsvfQuyyygnZaNHBAXdiVJn93Vso6D5H0sAncyyjrBdCi8qo9GNNwgrTYYA==
X-Received: by 2002:a5d:440a:: with SMTP id z10mr24327583wrq.157.1558718655409;
        Fri, 24 May 2019 10:24:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:e8aa:5f65:936f:3a1f? (p200300EA8BE97A00E8AA5F65936F3A1F.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:e8aa:5f65:936f:3a1f])
        by smtp.googlemail.com with ESMTPSA id m10sm3720433wmf.40.2019.05.24.10.24.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 10:24:14 -0700 (PDT)
Subject: Re: [PATCH 1/3] net:phy:dp83867: fix speed 10 in sgmii mode
To:     Max Uvarov <muvarov@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net
References: <20190524102541.4478-1-muvarov@gmail.com>
 <20190524102541.4478-2-muvarov@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a812ab2b-23ce-80b8-0623-de847b941fe7@gmail.com>
Date:   Fri, 24 May 2019 19:22:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190524102541.4478-2-muvarov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.05.2019 12:25, Max Uvarov wrote:
> For support 10Mps sped in SGMII mode DP83867_10M_SGMII_RATE_ADAPT bit
> of DP83867_10M_SGMII_CFG register has to be cleared by software.
> That does not affect speeds 100 and 1000 so can be done on init.
> 
> Signed-off-by: Max Uvarov <muvarov@gmail.com>
> ---
>  drivers/net/phy/dp83867.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index fd35131a0c39..afd31c516cc7 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -30,6 +30,7 @@
>  #define DP83867_STRAP_STS1	0x006E
>  #define DP83867_RGMIIDCTL	0x0086
>  #define DP83867_IO_MUX_CFG	0x0170
> +#define DP83867_10M_SGMII_CFG  0x016F
>  
>  #define DP83867_SW_RESET	BIT(15)
>  #define DP83867_SW_RESTART	BIT(14)
> @@ -74,6 +75,9 @@
>  /* CFG4 bits */
>  #define DP83867_CFG4_PORT_MIRROR_EN              BIT(0)
>  
> +/* 10M_SGMII_CFG bits */
> +#define DP83867_10M_SGMII_RATE_ADAPT		 BIT(7)
> +
>  enum {
>  	DP83867_PORT_MIRROING_KEEP,
>  	DP83867_PORT_MIRROING_EN,
> @@ -277,6 +281,24 @@ static int dp83867_config_init(struct phy_device *phydev)
>  				       DP83867_IO_MUX_CFG_IO_IMPEDANCE_CTRL);
>  	}
>  
> +	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
> +		/* For support SPEED_10 in SGMII mode
> +		 * DP83867_10M_SGMII_RATE_ADAPT bit
> +		 * has to be cleared by software. That
> +		 * does not affect SPEED_100 and
> +		 * SPEED_1000.
> +		 */
> +		val = phy_read_mmd(phydev, DP83867_DEVADDR,
> +				   DP83867_10M_SGMII_CFG);
> +		val &= ~DP83867_10M_SGMII_RATE_ADAPT;
> +		ret = phy_write_mmd(phydev, DP83867_DEVADDR,
> +				    DP83867_10M_SGMII_CFG, val);

This could be simplified by using phy_modify_mmd().

> +		if (ret) {
> +			WARN_ONCE(1, "dp83867: err DP83867_10M_SGMII_CFG\n");

This error message says more or less nothing. The context is visible in the
stack trace, so you can remove the message w/o losing anything.
As we're in the config_init callback, I don't think the "ONCE" version is
needed. So you could simply use WARN_ON(1). Typically just the errno is
returned w/o additional message, so you could also simply do:
return phy_modify_mmd(phydev, ...)

> +			return ret;
> +		}
> +	}
> +
>  	/* Enable Interrupt output INT_OE in CFG3 register */
>  	if (phy_interrupt_is_valid(phydev)) {
>  		val = phy_read(phydev, DP83867_CFG3);
> 

