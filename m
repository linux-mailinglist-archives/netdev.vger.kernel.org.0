Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE9066014E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbjAFNdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbjAFNdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:33:20 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAF980AC6;
        Fri,  6 Jan 2023 05:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gFRnDD0u8zMmAkqpfw2Mae08d1OFC69JOUlUhPh3bXE=; b=dIMhEegKau/LL2xYeerwW6EZFE
        2OYeQ0vwFUfQVy18Qc70uuD7vRckFluBtqwhJBI6ojgqF6SuChEiKR1RAFxrOV5KfUp/ZKFE5jRSj
        xZdfctnWQgsu9490TAWInJITnTelMn6h9YjNzlr9mSswfSAWSZpUDf4rC68bTNfmdhGc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pDmpI-001Kru-1n; Fri, 06 Jan 2023 14:32:04 +0100
Date:   Fri, 6 Jan 2023 14:32:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Frank.Sae" <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/3] net: phy: Add dts support for Motorcomm
 yt8521/yt8531s gigabit ethernet phy
Message-ID: <Y7gi1EPaMwX0GPeI@lunn.ch>
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-3-Frank.Sae@motor-comm.com>
 <Y7cC2MKYK4omdZKg@lunn.ch>
 <e74ff413-6d7d-63a3-ece4-c2fc555fea9d@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e74ff413-6d7d-63a3-ece4-c2fc555fea9d@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>  #define PHY_ID_YT8511		0x0000010a
> >> -#define PHY_ID_YT8521		0x0000011A
> >> -#define PHY_ID_YT8531S		0x4F51E91A
> >> +#define PHY_ID_YT8521		0x0000011a
> >> +#define PHY_ID_YT8531S		0x4f51e91a
> > 
> > Please do the lower case conversion as a separate patch.
> > 
> 
> I will fix.

Hi Frank

There is no need to say this. Please just reply to parts you want to
add more information, ask questions, or disagree with etc.

> >> +/* Phy Serdes analog cfg2 Register */
> >> +#define YTPHY_SERDES_ANALOG_CFG2_REG		0xA1
> >> +#define YTPHY_SAC2R_TX_AMPLITUDE_MASK		((0x7 << 13) | (0x7 << 1))
> >> +#define YT8521_SAC2R_TX_AMPLITUDE_LOW		((0x7 << 13) | (0x0 << 1))
> >> +#define YT8521_SAC2R_TX_AMPLITUDE_MIDDLE	((0x5 << 13) | (0x5 << 1))
> >> +#define YT8521_SAC2R_TX_AMPLITUDE_HIGH		((0x3 << 13) | (0x6 << 1))
> > 
> > So there are two values which control the amplitude? Buts 1-3, and bit
> > 7-9?  Can they be used independently?  Also, 7, 5, 3 is also add. Does
> > bit 0 of this value have some special meaning? Please document this
> > fully.
> > 
> 
> There are three values which control the amplitude,  13-15,3 and 1-2.
> They be used independently. Maybe it is good to expose three type ( 0:
> low;   1: middle;   2: high)to dts.
> 
> Bit	Symbol		Access	default	Description
> 15:13	Tx_swing_sel	RW	0x0	TX driver stage2 amplitude control
> 12	Tx_driver_stg1	RW	0x1	TX driver stage1 amplitude control
> 11	Reserved	RO	0x0	Reserved
> 10:8	Tx_ckdiv10_con	RW	0x0	tx divide by 10 clock delay control
> 7:4	Reserved	RO	0x0	Reserved
> 3	Tx_post_stg1	RW	0x0	TX driver post stage1 amplitude control
> 2:1	Tx_de_sel	RW	0x0	TX driver post stage2 amplitude control
> 0	Tx_pd		RW	0x0	power down analog tx

It would be nice to add defines for the individual parts, and then
combine them to give YT8521_SAC2R_TX_AMPLITUDE_HIGH. We then have full
documentation of the hardware.

> >> +#define YT8531S_SAC2R_TX_AMPLITUDE_LOW		((0x0 << 13) | (0x0 << 1))
> >> +#define YT8531S_SAC2R_TX_AMPLITUDE_MIDDLE	((0x0 << 13) | (0x1 << 1))
> >> +#define YT8531S_SAC2R_TX_AMPLITUDE_HIGH		((0x0 << 13) | (0x2 << 1))
> > 
> > This more sense, but why the 0 << 13? What do the bits 13-? mean?
> 
> 0 << 13 means 13-15 bit all zero.
> bits 13- mans the start bit is 13.

Sorry, my question was unclear. Why do bits 13-14 need to be zero? It
suggests these bits have some meaning. But the defines do not explain
the meaning.

> >> +	if (!of_property_read_u32(node, "motorcomm,rx-delay-additional-ps", &val)) {
> >> +		if (val > YTPHY_DTS_MAX_DELAY_VAL) {
> >> +			phydev_err(phydev, "invalid motorcomm,rx-delay-additional-ps\n");
> >> +			return -EINVAL;
> >> +		}
> > 
> > Please check the value is also one of the supported values. Please do
> > that for all your delays.
> > 
> 
> The following code check the supported values.
> 
> if (val)
> 			val /= YTPHY_DTS_STEP_DELAY_VAL;
> 		priv->rx_delay_additional = val;

It does not check it is a supported value. Say DT contained 42? That
is not a supported value. the /= YTPHY_DTS_STEP_DELAY_VAL will
calculate 0, which is the nearest rounded down value, but it will not
return -EINVAL.

> rx-delay-additional-ps = reg_val(0-15) *150ps. so val >
> YTPHY_DTS_MAX_DELAY_VAL 2250 is err.
> rx_delay_additional is store the reg_val (0-15).
> 
> >> +	if (of_property_read_bool(node, "motorcomm,keep-pll-enabled"))
> >> +		priv->keep_pll_enabled = true;
> > 
> > I think this only makes sense when priv->clock_output is true? Please
> > test for that.
> > 
> 
> No,priv->clock_output is used to output 25Mhz or 125Mhz for mac.
> priv->keep_pll_enabled is used to enable RXC clock when no wire plug.

So if priv->clock_output is set to 25MHz, it will always output 25Mhz,
independent of if there is a link peer or not?

Sometimes this clock is the recovered clock from the line, and if
there is no link peer, there is no recovered clock. In order to keep
this clock ticking, you need to keep the PLL locked by supplying it
from the local oscillator. I'm just trying to understand if that is
what is happening here. But you say it is completely independent. O.K.

     Andrew
