Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C4E88249
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407292AbfHISVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:21:37 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53854 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfHISVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:21:37 -0400
Received: by mail-wm1-f68.google.com with SMTP id 10so6586959wmp.3;
        Fri, 09 Aug 2019 11:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KS+6+3TpDsN/cMREG4Zh8J1SqTdnJsjbnKgo2hSxdoU=;
        b=W0gleuCJ5t5oo8pfcK9STTX3EWn/Qh/9+krSDhjhTcWPj70UiBMbwFiESJtJJaVWoE
         f/3vLJrtxiWyOqzz4xa7w5iodRf+gbzsvROOEOw6OY0mrvj58pdz8ubf6SxToqp6qchK
         YcRlX7xMlnGULyDGr64Pz1sbwNi/G10U5fM6mhxdYlat1ejPQ0YhVT3QusnQSiy9ct93
         sFl/cIqvMZVw8WM3mz/l+O/Kl7+Mv6r6Op/gV6D8cRkDCvYPEshNbeqpCw0isrK9+a1l
         PIVJdHDdCTz3NSM8ABTc6B+nnS/Kn/JBvSCumgMMDHjO+KGLdJmLNRA7+Ulx9c/aK3h4
         tAcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KS+6+3TpDsN/cMREG4Zh8J1SqTdnJsjbnKgo2hSxdoU=;
        b=kR+S6q0MGXgL3DkgHxoICmYS4RnsWU2g/4O86D+Si+DcYMzU/YR+L7U9y8YBLLmuOh
         d9gCzgSx4xnpxCN92rEzptlhLAFNnn8u6lqofYh+IvBkYQxIUXkpxvZNIfUjU2aXfqkk
         eM/+PupbELaiOChzYYgZcF4tihXNmQqg5R0Esm+zpjKNGqKQAAZHb11O3AltBGtz11wS
         ztaet2LHIRUpSrQKZ2Glc1wOYYb7IXZ//7e2jgJkO0aPmgYOfaY/6luhhoB6SN1f8S3+
         XAg4i26Cns9oIzHdaTWjVlGpWyq3HQG9lIbLDtiR3QjEtiJvo9O6Cgut/7Zcn5YS4fGt
         MjLQ==
X-Gm-Message-State: APjAAAU+12HI4idyW2u015QAsOycLc6OHDkVW8XIF8ZZ94uHfIvaiPaZ
        lgNeN3RfkE7soGc+HRqZ1Y8=
X-Google-Smtp-Source: APXvYqxALuzfwghxeWWaugrAJ1zyJR5eJHZlLgeYwHuNE5R5Hu8qBZKiJRWWfbqoeVIRn39/1NkE7w==
X-Received: by 2002:a1c:9a46:: with SMTP id c67mr12060038wme.11.1565374894612;
        Fri, 09 Aug 2019 11:21:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:2994:d24a:66a1:e0e5? (p200300EA8F2F32002994D24A66A1E0E5.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:2994:d24a:66a1:e0e5])
        by smtp.googlemail.com with ESMTPSA id m23sm3346214wml.41.2019.08.09.11.21.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 11:21:34 -0700 (PDT)
Subject: Re: [PATCH v3 03/14] net: phy: adin: add support for interrupts
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        f.fainelli@gmail.com, andrew@lunn.ch
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
 <20190809133552.21597-4-alexandru.ardelean@analog.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a8a52659-b905-3796-e0ae-86d3af44dca3@gmail.com>
Date:   Fri, 9 Aug 2019 20:19:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809133552.21597-4-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.08.2019 15:35, Alexandru Ardelean wrote:
> This change adds support for enabling PHY interrupts that can be used by
> the PHY framework to get signal for link/speed/auto-negotiation changes.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  drivers/net/phy/adin.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
> index fc0148ba4b94..91ff26d08fd5 100644
> --- a/drivers/net/phy/adin.c
> +++ b/drivers/net/phy/adin.c
> @@ -14,11 +14,45 @@
>  #define PHY_ID_ADIN1200				0x0283bc20
>  #define PHY_ID_ADIN1300				0x0283bc30
>  
> +#define ADIN1300_INT_MASK_REG			0x0018
> +#define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
> +#define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
> +#define   ADIN1300_INT_ANEG_PAGE_RX_EN		BIT(6)
> +#define   ADIN1300_INT_IDLE_ERR_CNT_EN		BIT(5)
> +#define   ADIN1300_INT_MAC_FIFO_OU_EN		BIT(4)
> +#define   ADIN1300_INT_RX_STAT_CHNG_EN		BIT(3)
> +#define   ADIN1300_INT_LINK_STAT_CHNG_EN	BIT(2)
> +#define   ADIN1300_INT_SPEED_CHNG_EN		BIT(1)
> +#define   ADIN1300_INT_HW_IRQ_EN		BIT(0)
> +#define ADIN1300_INT_MASK_EN	\
> +	(ADIN1300_INT_ANEG_STAT_CHNG_EN | ADIN1300_INT_ANEG_PAGE_RX_EN | \
> +	 ADIN1300_INT_LINK_STAT_CHNG_EN | ADIN1300_INT_SPEED_CHNG_EN | \
> +	 ADIN1300_INT_HW_IRQ_EN)

phylib only needs the link status change interrupt. It shouldn't hurt
if enable more interrupt sources, but it's not needed.


> +#define ADIN1300_INT_STATUS_REG			0x0019
> +
>  static int adin_config_init(struct phy_device *phydev)
>  {
>  	return genphy_config_init(phydev);
>  }
>  
> +static int adin_phy_ack_intr(struct phy_device *phydev)
> +{
> +	/* Clear pending interrupts */
> +	int rc = phy_read(phydev, ADIN1300_INT_STATUS_REG);
> +
> +	return rc < 0 ? rc : 0;
> +}
> +
> +static int adin_phy_config_intr(struct phy_device *phydev)
> +{
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> +		return phy_set_bits(phydev, ADIN1300_INT_MASK_REG,
> +				    ADIN1300_INT_MASK_EN);
> +
> +	return phy_clear_bits(phydev, ADIN1300_INT_MASK_REG,
> +			      ADIN1300_INT_MASK_EN);
> +}
> +
>  static struct phy_driver adin_driver[] = {
>  	{
>  		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
> @@ -26,6 +60,8 @@ static struct phy_driver adin_driver[] = {
>  		.config_init	= adin_config_init,
>  		.config_aneg	= genphy_config_aneg,
>  		.read_status	= genphy_read_status,
> +		.ack_interrupt	= adin_phy_ack_intr,
> +		.config_intr	= adin_phy_config_intr,
>  		.resume		= genphy_resume,
>  		.suspend	= genphy_suspend,
>  	},
> @@ -35,6 +71,8 @@ static struct phy_driver adin_driver[] = {
>  		.config_init	= adin_config_init,
>  		.config_aneg	= genphy_config_aneg,
>  		.read_status	= genphy_read_status,
> +		.ack_interrupt	= adin_phy_ack_intr,
> +		.config_intr	= adin_phy_config_intr,
>  		.resume		= genphy_resume,
>  		.suspend	= genphy_suspend,
>  	},
> 

