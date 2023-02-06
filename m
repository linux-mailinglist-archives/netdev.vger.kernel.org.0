Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269C468BE2A
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjBFNbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjBFNa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:30:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21616C64E;
        Mon,  6 Feb 2023 05:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rPMkQ0FfP4TyRB/ySG5okmmWPtiq9gLsybMziD5gFZM=; b=UAxI0Su9v5V5lSCU6VZytS5V0m
        NY+XATGnn5+0t+lpa5rR5p96QQ/AJYWFCIBGP5oUnK+FbmW+TzFAdjMvV8Af9wZYgykulALD1s8TL
        lMuDgHlxkj4LhPEcvrqfkJRwoCi/y1+rXaE61u25d+lE6OFJoC9+HNW+dzeoM0e9bnF0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pP1Zy-004Cla-GO; Mon, 06 Feb 2023 14:30:42 +0100
Date:   Mon, 6 Feb 2023 14:30:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, michael@walle.cc
Subject: Re: [PATCH net-next v3 1/2] net: micrel: Add support for lan8841 PHY
Message-ID: <Y+EBArQ5JP5bRZpc@lunn.ch>
References: <20230206082302.958826-1-horatiu.vultur@microchip.com>
 <20230206082302.958826-2-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206082302.958826-2-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define LAN8841_MMD_TIMER_REG			0
> +#define LAN8841_MMD0_REGISTER_17		17
> +#define LAN8841_MMD0_REGISTER_17_DROP_OPT(x)	((x) & 0x3)
> +#define LAN8841_MMD0_REGISTER_17_XMIT_TOG_TX_DIS	BIT(3)
> +#define LAN8841_OPERATION_MODE_STRAP_OVERRIDE_LOW_REG	2
> +#define LAN8841_OPERATION_MODE_STRAP_OVERRIDE_LOW_REG_MAGJACK	BIT(14)
> +#define LAN8841_MMD_ANALOG_REG			28
> +#define LAN8841_ANALOG_CONTROL_1		1
> +#define LAN8841_ANALOG_CONTROL_1_PLL_TRIM(x)	(((x) & 0x3) << 5)
> +#define LAN8841_ANALOG_CONTROL_10		13
> +#define LAN8841_ANALOG_CONTROL_10_PLL_DIV(x)	((x) & 0x3)
> +#define LAN8841_ANALOG_CONTROL_11		14
> +#define LAN8841_ANALOG_CONTROL_11_LDO_REF(x)	(((x) & 0x7) << 12)
> +#define LAN8841_TX_LOW_I_CH_C_D_POWER_MANAGMENT	69
> +#define LAN8841_TX_LOW_I_CH_C_D_POWER_MANAGMENT_VAL 0xbffc
> +#define LAN8841_BTRX_POWER_DOWN			70
> +#define LAN8841_BTRX_POWER_DOWN_QBIAS_CH_A	BIT(0)
> +#define LAN8841_BTRX_POWER_DOWN_BTRX_CH_A	BIT(1)
> +#define LAN8841_BTRX_POWER_DOWN_QBIAS_CH_B	BIT(2)
> +#define LAN8841_BTRX_POWER_DOWN_BTRX_CH_B	BIT(3)
> +#define LAN8841_BTRX_POWER_DOWN_BTRX_CH_C	BIT(5)
> +#define LAN8841_BTRX_POWER_DOWN_BTRX_CH_D	BIT(7)
> +#define LAN8841_ADC_CHANNEL_MASK		198
> +static int lan8841_config_init(struct phy_device *phydev)
> +{
> +	int err;

It would be good to add a blank line before the function.

> +	int ret;

I don't think you need both err and ret. But i expect the compiler is
optimising one of them out anyway.

> +
> +#define LAN8841_OUTPUT_CTRL			25
> +#define LAN8841_OUTPUT_CTRL_INT_BUFFER		BIT(14)
> +static int lan8841_config_intr(struct phy_device *phydev)
> +{

Blank line again, it helpers make the functions stand out.


> +#define LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER 3
> +#define LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER_STRAP_RGMII_EN BIT(0)
> +static int lan8841_probe(struct phy_device *phydev)
> +{
> +	int err;

...

	Andrew
