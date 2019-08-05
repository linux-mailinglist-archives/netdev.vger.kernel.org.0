Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C248268B
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbfHEVDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:03:09 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37531 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730099AbfHEVDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 17:03:09 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so60664610wrr.4;
        Mon, 05 Aug 2019 14:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wD9pRuLXxIn2k87gFSwjMexyP/R3+2bHVXEqdFsqtg0=;
        b=qc/u1ZJI/gLWI5msj09zALj0xWOCirj/CMHgRj9yjtLkdpmxv/APbxHIKFD1Maorwx
         qJLd3IvV2cOFBcUJQsvjWn1y0za5UTPBRod3tGMI2QTOSQb29IEX8GtuY1EihWiIduib
         8CvsrZMl0ONE+5JKTjnQq6dWwadFMnMZnzhSIpvKC8VhCjDx+FRP9cx0BkS40Ym7OGpS
         XbLSBgrNrBjFjWU0A+M3GvSq+IHi8++L+uKu/QP5EsJRDPPXPivp4a6kcDzuMiyUJ2m2
         ujR2nqSgKq3aCei8ukc464h8gVE61dsxwtzHYTX8dho5OID/q9Q7RdUjXj2LIqW8voCG
         3/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wD9pRuLXxIn2k87gFSwjMexyP/R3+2bHVXEqdFsqtg0=;
        b=tNWBJcjDJqqKsXUv2N4pwlxNqu81ftqIgAuQxlZ+JbmdbKwHL5yGnHoFkPzOHIGUOv
         7HwfaTAXl4hfqUPn1ViURL6y9J9ITujzIJqoI1a1ImjTWJAfmQhdCniEAbadQyfa57o0
         T3W0Rp25OWRlU8NX5DY7Q0miyNDjZdbKp8NRs8pgJ+aKiDCud15GrqUdE6s+eWv6EkCB
         BlM3hq0pyjARPudZySw2pi4uVqvC4hH+lNIci3MiGf+094RmUbcf7AkBqmjL8iNvVbMC
         28QD9KBpLgh0Xt3S3I+CcbkVAFUTIhcVPoC++jPVzo3KKuIMiTIfuT2VYaV97hssKsES
         Zdjw==
X-Gm-Message-State: APjAAAUYHskgnGmOp9S0FruRHONHj/OyIEC1kg2sIM+5ckg3Im2U1D/w
        Gid2fkKkl+J81Y5vLa03LW0=
X-Google-Smtp-Source: APXvYqxgU7vbAbvUbr3mc2vHRvtfI01ZiTZbvl85ATELi73bOeOQQnx4udm+hLOdzrNCYrHzveXe2w==
X-Received: by 2002:adf:dcc6:: with SMTP id x6mr45584wrm.322.1565038986135;
        Mon, 05 Aug 2019 14:03:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f05:8600:d16c:62d1:98de:d1e5? (p200300EA8F058600D16C62D198DED1E5.dip0.t-ipconnect.de. [2003:ea:8f05:8600:d16c:62d1:98de:d1e5])
        by smtp.googlemail.com with ESMTPSA id a84sm111051583wmf.29.2019.08.05.14.03.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 14:03:05 -0700 (PDT)
Subject: Re: [PATCH 03/16] net: phy: adin: add support for interrupts
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        f.fainelli@gmail.com, andrew@lunn.ch
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-4-alexandru.ardelean@analog.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4f539572-4c59-0450-fcd4-0bbc3eece9c8@gmail.com>
Date:   Mon, 5 Aug 2019 23:02:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805165453.3989-4-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.08.2019 18:54, Alexandru Ardelean wrote:
> This change adds support for enabling PHY interrupts that can be used by
> the PHY framework to get signal for link/speed/auto-negotiation changes.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  drivers/net/phy/adin.c | 44 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
> index c100a0dd95cd..b75c723bda79 100644
> --- a/drivers/net/phy/adin.c
> +++ b/drivers/net/phy/adin.c
> @@ -14,6 +14,22 @@
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
> +#define ADIN1300_INT_STATUS_REG			0x0019
> +
>  static int adin_config_init(struct phy_device *phydev)
>  {
>  	int rc;
> @@ -25,15 +41,40 @@ static int adin_config_init(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +static int adin_phy_ack_intr(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	/* Clear pending interrupts.  */
> +	ret = phy_read(phydev, ADIN1300_INT_STATUS_REG);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
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
>  		.phy_id		= PHY_ID_ADIN1200,
>  		.name		= "ADIN1200",
>  		.phy_id_mask	= 0xfffffff0,
>  		.features	= PHY_BASIC_FEATURES,
> +		.flags		= PHY_HAS_INTERRUPT,

This flag doesn't exist any longer. This indicates that you
develop against an older kernel version. Please develop
against net-next. Check up-to-date drivers like the one
for Realtek PHY's for hints.

>  		.config_init	= adin_config_init,
>  		.config_aneg	= genphy_config_aneg,
>  		.read_status	= genphy_read_status,
> +		.ack_interrupt	= adin_phy_ack_intr,
> +		.config_intr	= adin_phy_config_intr,
>  		.resume		= genphy_resume,
>  		.suspend	= genphy_suspend,
>  	},
> @@ -42,9 +83,12 @@ static struct phy_driver adin_driver[] = {
>  		.name		= "ADIN1300",
>  		.phy_id_mask	= 0xfffffff0,
>  		.features	= PHY_GBIT_FEATURES,
> +		.flags		= PHY_HAS_INTERRUPT,
>  		.config_init	= adin_config_init,
>  		.config_aneg	= genphy_config_aneg,
>  		.read_status	= genphy_read_status,
> +		.ack_interrupt	= adin_phy_ack_intr,
> +		.config_intr	= adin_phy_config_intr,
>  		.resume		= genphy_resume,
>  		.suspend	= genphy_suspend,
>  	},
> 

