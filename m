Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B9982B4B
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 07:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbfHFFw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 01:52:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46551 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFFw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 01:52:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so86552317wru.13;
        Mon, 05 Aug 2019 22:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IKYzr/0YT531QrNixFqMn902QrmR+puknePogdS0+Zg=;
        b=tCHON0Ts/tcmE99CnFfZK4odqaGPSPilqivgiu4Ogpn0w6TOsLQzghFJ+43bfVq0WL
         QzFVMkQGV4p2Z8lmnQ++2y9h0px6MgKpxUlDBD2eOy+H7GDRZoWXhh7bXUNyno3WIXbm
         8l657xYLH49gBQMchqHw1Q2FiwsAfg2HvyKX2qeHERB2U0ej0yOSS4/qSk/sipRQHZPr
         7Unv0NIWD1PmfdEEZCo+MI/rTbjKTe+Sy+/K81xrA91DVvlostfd1Xzl1jT0qlJ44hii
         3GSFqw9TgY7JX3lywKoyosIeq/miU4gw2HuKMmZWGoAbO2k5uT7jjD8JUau4pIGzXVio
         PnpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IKYzr/0YT531QrNixFqMn902QrmR+puknePogdS0+Zg=;
        b=sPCSdH1opKU/YLegvbX0ub2j6ZZukH5bcGHrhHhK71l6izW0WliJ0b6IYujyNZCknI
         4WsWNBeq3ZBJY7FcwXY2JlanC0ZIba6pF60px5bYWGA0/b6nV0NFjgOROsSbBKYXH+g1
         uFEb+ObDAaZZzJ60qhhFr6MHPLbss1xan6mGbLxOQysw+0lLvNPYn9/sILucGkvALE0D
         /L8VxwLfJhNUe7t0TWwnBk3Ss+Tvxn0b9i6FCA5vcwa5egY3QlTZA9w7866/g/cpTcSC
         YEu7FXA4XmDC64uYFBgcqqMvmy9ahHxpdIfTsY3Q/7zB8y1alj+qTRQvRRt8xGjNrDXi
         Rqyw==
X-Gm-Message-State: APjAAAV6R1maVBYjT7qzIbmu2XTC2XW5tu2O2SOwprdGt9sjqeuGGMLQ
        oyAT7b/5UCBz6mEAU1ExLP6f1YYe
X-Google-Smtp-Source: APXvYqxlLw8cLWlTr7FwYobeQeRUGypD/EjsE0AvhkDLimi25MR7E6IHojkVRCoVFegVtwx999OgNQ==
X-Received: by 2002:a5d:4087:: with SMTP id o7mr2185278wrp.277.1565070776253;
        Mon, 05 Aug 2019 22:52:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f05:8600:992f:1d79:8aac:243c? (p200300EA8F058600992F1D798AAC243C.dip0.t-ipconnect.de. [2003:ea:8f05:8600:992f:1d79:8aac:243c])
        by smtp.googlemail.com with ESMTPSA id n3sm78289438wrt.31.2019.08.05.22.52.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 22:52:55 -0700 (PDT)
Subject: Re: [PATCH 14/16] net: phy: adin: make sure down-speed auto-neg is
 enabled
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        f.fainelli@gmail.com, andrew@lunn.ch
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-15-alexandru.ardelean@analog.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <baac3842-bd9c-75af-83e3-9e89def1c429@gmail.com>
Date:   Tue, 6 Aug 2019 07:52:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805165453.3989-15-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.08.2019 18:54, Alexandru Ardelean wrote:
> Down-speed auto-negotiation may not always be enabled, in which case the
> PHY won't down-shift to 100 or 10 during auto-negotiation.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  drivers/net/phy/adin.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
> index 86848444bd98..a1f3456a8504 100644
> --- a/drivers/net/phy/adin.c
> +++ b/drivers/net/phy/adin.c
> @@ -32,6 +32,13 @@
>  #define   ADIN1300_NRG_PD_TX_EN			BIT(2)
>  #define   ADIN1300_NRG_PD_STATUS		BIT(1)
>  
> +#define ADIN1300_PHY_CTRL2			0x0016
> +#define   ADIN1300_DOWNSPEED_AN_100_EN		BIT(11)
> +#define   ADIN1300_DOWNSPEED_AN_10_EN		BIT(10)
> +#define   ADIN1300_GROUP_MDIO_EN		BIT(6)
> +#define   ADIN1300_DOWNSPEEDS_EN	\
> +	(ADIN1300_DOWNSPEED_AN_100_EN | ADIN1300_DOWNSPEED_AN_10_EN)
> +
>  #define ADIN1300_INT_MASK_REG			0x0018
>  #define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
>  #define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
> @@ -425,6 +432,22 @@ static int adin_config_mdix(struct phy_device *phydev)
>  	return phy_write(phydev, ADIN1300_PHY_CTRL1, reg);
>  }
>  
> +static int adin_config_downspeeds(struct phy_device *phydev)
> +{
> +	int reg;
> +
> +	reg = phy_read(phydev, ADIN1300_PHY_CTRL2);
> +	if (reg < 0)
> +		return reg;
> +
> +	if ((reg & ADIN1300_DOWNSPEEDS_EN) == ADIN1300_DOWNSPEEDS_EN)
> +		return 0;
> +
> +	reg |= ADIN1300_DOWNSPEEDS_EN;
> +
> +	return phy_write(phydev, ADIN1300_PHY_CTRL2, reg);

Using phy_set_bits() would be easier.

> +}
> +
>  static int adin_config_aneg(struct phy_device *phydev)
>  {
>  	int ret;
> @@ -433,6 +456,10 @@ static int adin_config_aneg(struct phy_device *phydev)
>  	if (ret)
>  		return ret;
>  
> +	ret = adin_config_downspeeds(phydev);
> +	if (ret < 0)
> +		return ret;
> +
>  	return genphy_config_aneg(phydev);
>  }
>  
> 

