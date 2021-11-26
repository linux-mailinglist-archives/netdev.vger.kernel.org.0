Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC3045EDEA
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 13:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351117AbhKZMf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 07:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbhKZMd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 07:33:27 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF03FC08E9AE;
        Fri, 26 Nov 2021 03:57:42 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id u18so18110530wrg.5;
        Fri, 26 Nov 2021 03:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=SNB1t9Mob/om/0gEPyMAAK0h4a9sZaQd1Wb0UDuDjBw=;
        b=HjMnDvZcSEAzsxm2g0byVO4kFEIuUg/VqLAOcobRvX2kvDbQNgkwUKk3b5lTpm90Hl
         W4zPMK3sSr8/Z0Mt+TqOjolQAMZ5j3kk4hVZWWzmwExAeu6HFRxFSKms1BOxlQWPm6e+
         jH/qhyE7wBD2beAzJOac/VStJDi4ly68VDmLROcz0sJY4kHHv7m7w3rsXfSG6sJm7cxH
         xaRT+yj6BJEI/V7TUY1zISK9zjvYDwiJ/bHGiHmk9HGr4/LnmutWc6/ueaJNsZ8az/FE
         wnesHMUuMORNV4KTWYwu5B9/tpOME8dUp2k5iNeH53ndNjt+6hkbYGQ86K3C/PI1buZF
         Fzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=SNB1t9Mob/om/0gEPyMAAK0h4a9sZaQd1Wb0UDuDjBw=;
        b=s5dLEi5FAvZVYs44A4oRYJ6B/EnyKYtLMd5/IRVJI5OfqIAg7aLYDQ4Gr8Ljcy/mIe
         AcvT0xn0qqg17/IaBcYsvN9yfAuLaXymySSDoyFbzywO9kbnCvu1LrrRToVoaYftW+FG
         ecOT3Nh67gevS6n2YA+o41WmF0gjmHR8fvfzDvtVOWQYJJ8rHmX7qsi0mchtMnXOy3uH
         WnAu6isXqgSo/mgXmtsirjpaL723/H8TmXm7OYlkCM7lKqzeiDQECRTfUo0LuHaYnEdu
         AuOfZRKFTlxJa5KCb0qDq8Oqp/0FsmUB11LMThhisXDIt3IiEIFI1uSSFZHo6bLqbrKj
         RfpA==
X-Gm-Message-State: AOAM530Jfa4vFcBH4vjVQtSdT4iG1NnJJ3cvDl4ilAE8uL6JOuSwecMt
        EjCfU6SsCZ9LnyxEw+ZLTbs=
X-Google-Smtp-Source: ABdhPJw4v7G31ucJfww0wV0My59oaswfQPi04I1cazf4KHK2ClJUE9lrrIFYRRCmmpQiWphI2FkkMg==
X-Received: by 2002:a5d:550f:: with SMTP id b15mr13273600wrv.212.1637927861345;
        Fri, 26 Nov 2021 03:57:41 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:eda0:b7b0:4339:bfa2? (p200300ea8f1a0f00eda0b7b04339bfa2.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:eda0:b7b0:4339:bfa2])
        by smtp.googlemail.com with ESMTPSA id i17sm6785469wmq.48.2021.11.26.03.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 03:57:40 -0800 (PST)
Message-ID: <402780af-9d12-45dd-e435-e7279f1b9263@gmail.com>
Date:   Fri, 26 Nov 2021 12:57:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211126103833.3609945-1-horatiu.vultur@microchip.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: micrel: Add config_init for LAN8814
In-Reply-To: <20211126103833.3609945-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.11.2021 11:38, Horatiu Vultur wrote:
> Add config_init for LAN8814. This function is required for the following
> reasons:
> - we need to make sure that the PHY is reset,
> - disable ANEG with QSGMII PCS Host side
> - swap the MDI-X A,B transmit so that there will not be any link flip-flaps
>   when the PHY gets a link.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 44a24b99c894..f080312032cf 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1565,6 +1565,14 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
>  #define LAN_EXT_PAGE_ACCESS_ADDRESS_DATA		0x17
>  #define LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC		0x4000
>  
> +#define LAN8814_QSGMII_SOFT_RESET			0x43
> +#define LAN8814_QSGMII_SOFT_RESET_BIT			BIT(0)
> +#define LAN8814_QSGMII_PCS1G_ANEG_CONFIG		0x13
> +#define LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA	BIT(3)
> +#define LAN8814_ALIGN_SWAP				0x4a
> +#define LAN8814_ALIGN_TX_A_B_SWAP			0x1
> +#define LAN8814_ALIGN_TX_A_B_SWAP_MASK			GENMASK(2, 0)
> +
>  #define LAN8804_ALIGN_SWAP				0x4a
>  #define LAN8804_ALIGN_TX_A_B_SWAP			0x1
>  #define LAN8804_ALIGN_TX_A_B_SWAP_MASK			GENMASK(2, 0)
> @@ -1601,6 +1609,29 @@ static int lanphy_write_page_reg(struct phy_device *phydev, int page, u16 addr,
>  	return 0;
>  }
>  
> +static int lan8814_config_init(struct phy_device *phydev)
> +{
> +	int val;
> +
> +	/* Reset the PHY */
> +	val = lanphy_read_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET);
> +	val |= LAN8814_QSGMII_SOFT_RESET_BIT;
> +	lanphy_write_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET, val);
> +
> +	/* Disable ANEG with QSGMII PCS Host side */
> +	val = lanphy_read_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG);
> +	val &= ~LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA;
> +	lanphy_write_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG, val);
> +
> +	/* MDI-X setting for swap A,B transmit */
> +	val = lanphy_read_page_reg(phydev, 2, LAN8814_ALIGN_SWAP);
> +	val &= ~LAN8814_ALIGN_TX_A_B_SWAP_MASK;
> +	val |= LAN8814_ALIGN_TX_A_B_SWAP;
> +	lanphy_write_page_reg(phydev, 2, LAN8814_ALIGN_SWAP, val);
> +

Not directly related to just this patch:
Did you consider implementing the read_page and write_page PHY driver
callbacks? Then you could use phylib functions like phy_modify_paged et al
and you wouldn't have to open-code the paged register operations.

I think write_page would just be
phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));

and read_page
phy_read(phydev, LAN_EXT_PAGE_ACCESS_CONTROL);

> +	return 0;
> +}
> +
>  static int lan8804_config_init(struct phy_device *phydev)
>  {
>  	int val;
> @@ -1793,6 +1824,7 @@ static struct phy_driver ksphy_driver[] = {
>  	.phy_id		= PHY_ID_LAN8814,
>  	.phy_id_mask	= MICREL_PHY_ID_MASK,
>  	.name		= "Microchip INDY Gigabit Quad PHY",
> +	.config_init	= lan8814_config_init,
>  	.driver_data	= &ksz9021_type,
>  	.probe		= kszphy_probe,
>  	.soft_reset	= genphy_soft_reset,
> 

