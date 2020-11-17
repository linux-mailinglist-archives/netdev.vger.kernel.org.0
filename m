Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D31F2B7083
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgKQU5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgKQU5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:57:04 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0547BC0613CF;
        Tue, 17 Nov 2020 12:57:03 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id m16so9078998edr.3;
        Tue, 17 Nov 2020 12:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ddOfz6r21avy+Gf5L6KkTvDcz/FVQukeuhfDgsb2Gz8=;
        b=svJ9Vk5Pp32nkIViNuhyl+wme/EAIknlj4Uw/KAckNvqSwMiraD6LyAcUMn4JxttXa
         j4NC69v1pj/ZyN7SrTmoObbzWm5tLrF6rYlvU/oNTiAXKPsb6fRyjnron6qWd4p9FLsZ
         FSxhxATCssVyj5MY3XnJDBNkquwF3c2lV+5tiYrvbyfivlx8UcseFwk6OwRGwyDV8Vsd
         SHDwroSBFp7+mqpOv3YRNVREEE0ZoxyFmnMRB6RG+n0SR1N+2/UeMH0HtAFhbzHFv+Xs
         wl/Z94Eq0eFvOgooDOMZfX975RLmObA0k+O1K0UFC5jtR2jaf6rGhDHRoc9wLar/SLub
         gYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ddOfz6r21avy+Gf5L6KkTvDcz/FVQukeuhfDgsb2Gz8=;
        b=fDy7uKhYKZI+OGIw+/OL5Plz+Fpeo56/RdBRGu8kAt3+p1vPR1aCFvhPMfpv3DXYng
         jIimWcBAgyXA/xZvADgcCZ9mp/aaTLbVxOIPEMFVrIk3sRggCPmSEcIeIyunyu1Wu8HR
         wfzCRiGnP6/qhciuZLEZGG+Lh9Q4imL5te8I2xk/ziEnob9m1F3ws2gMxtZ3YkkMNyHo
         FfN6KtB1EXxbPssFhS7lGq5AEazrLx0P+YjMSgH4JU5qMLweHHyXa8jEVlDCQDzs1GSF
         /KQqylZfg867e9cfQNxSGqF6ncp33cgz75cLliigDg9BWZQek0+r6bsk8bOsZHti2DzM
         mJHw==
X-Gm-Message-State: AOAM531vPywLRympA1if0LU4TexsMxhy7eMpJcC/n8bA4FhzkLEcUnSL
        Hf6jqCBnHGNkJTAIpEUTA6w=
X-Google-Smtp-Source: ABdhPJyoQgV3y0Y/kAeZqRFPyaod8kZF8F+DWFpzgW5AaJLeEBIGdgw0h+WzFzDkPy3TcaeZDrwo4w==
X-Received: by 2002:a50:daca:: with SMTP id s10mr14271292edj.263.1605646622596;
        Tue, 17 Nov 2020 12:57:02 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id k2sm11859258ejp.6.2020.11.17.12.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 12:57:01 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Tue, 17 Nov 2020 22:57:00 +0200
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, robh@kernel.org, ciorneiioana@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 4/4] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
Message-ID: <20201117205700.to7h7pfgniq5fx5l@skbuf>
References: <20201117201555.26723-1-dmurphy@ti.com>
 <20201117201555.26723-5-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117201555.26723-5-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 02:15:55PM -0600, Dan Murphy wrote:
> The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
> that supports 10M single pair cable.
> 
> The device supports both 2.4-V p2p and 1-V p2p output voltage as defined
> by IEEE 802.3cg 10Base-T1L specfications. These modes can be forced via
> the device tree or the device is defaulted to auto negotiation to
> determine the proper p2p voltage.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
> 
> v4 - Considerable rework of the code after secondary test setup was created.
> This version also uses the handle_interrupt call back and reduces the
> configuration arrays as it was determined that 80% of the array was the same.
> 
>  drivers/net/phy/Kconfig     |   6 +
>  drivers/net/phy/Makefile    |   1 +
>  drivers/net/phy/dp83td510.c | 505 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 512 insertions(+)
>  create mode 100644 drivers/net/phy/dp83td510.c
> 

[snip]

> +static int dp83td510_ack_interrupt(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, DP83TD510_INT_REG1);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = phy_read(phydev, DP83TD510_INT_REG2);
> +	if (ret < 0)
> +		return ret;
> +
> +	phy_trigger_machine(phydev);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t dp83td510_handle_interrupt(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = dp83td510_ack_interrupt(phydev);
> +	if (ret)
> +		return IRQ_NONE;
> +
> +	return IRQ_HANDLED;
> +}

From what I can see in the datasheet, the INT_REG1 and INT_REG2 are used
for both interrupt configuration and interrupt status.

If this is the case, the state machine should only be triggered if the
interrupt was triggered (eg DP83TD510_INT1_LINK is set), not if _any_
bit from the register is set. This is broken since anytime you have
interrupts enabled, the lower half of the register will be non-zero
since that contains you interrupt enabled bits.

The .handle_interrupt() should look something like:

	ret = phy_read(phydev, DP83TD510_INT_REG1);
	if (ret < 0)
		return ret;
	
	if (!(ret & (DP83TD510_INT1_ESD | DP83TD510_INT1_LINK | DP83TD510_INT1_RHF)))
		return IRQ_NONE;

	ret = phy_read(phydev, DP83TD510_INT_REG2);
	if (ret < 0)
		return ret;
	
	if (!(ret & (DP83TD510_INT2_POR | DP83TD510_INT2_POL | DP83TD510_INT2_PAGE)))
		return IRQ_NONE;

	phy_trigger_machine(phydev);

	return IRQ_HANDLED;

> +
> +static int dp83td510_config_intr(struct phy_device *phydev)
> +{
> +	int int_status;
> +	int gen_cfg_val;
> +	int ret;
> +
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
> +		int_status = phy_read(phydev, DP83TD510_INT_REG1);
> +		if (int_status < 0)
> +			return int_status;
> +
> +		int_status = (DP83TD510_INT1_ESD_EN | DP83TD510_INT1_LINK_EN |
> +			      DP83TD510_INT1_RHF_EN);
> +
> +		ret = phy_write(phydev, DP83TD510_INT_REG1, int_status);
> +		if (ret)
> +			return ret;
> +
> +		int_status = phy_read(phydev, DP83TD510_INT_REG2);
> +		if (int_status < 0)
> +			return int_status;
> +
> +		int_status = (DP83TD510_INT2_POR | DP83TD510_INT2_POL |
> +				DP83TD510_INT2_PAGE);
> +

Shouldn't you use DP83TD510_INT2_POR_EN, DP83TD510_INT2_POL_EN etc here?
It seems that you are setting up the bits corresponding with the
interrupt status and not the interrupt enable.

Ioana
