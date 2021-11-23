Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA58245AE6E
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 22:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhKWV1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 16:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbhKWV1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 16:27:53 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0DFC061574;
        Tue, 23 Nov 2021 13:24:44 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x6so816925edr.5;
        Tue, 23 Nov 2021 13:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=444QMqDjsr/4IdpE/tLDY4FNQjqFzhOwAAsJFthSU7c=;
        b=YzhL55wMTenJtwWRQwCReF84Xaz46sqAtLJk0GkBEFxZjM8/iIUYxxt4oBaViYSh0x
         W+hl6lN/O2XxwE/wdWpBIdiXHWFkScL/8fPSkYYSlqUxQcuayIQ43zMoOhzySJuga7YH
         TLioJ7hmu/pds9Gi5ubGeLfwyhB4ekrJBS0cL1cQrdGMn0Uy2Zm4kN7dn1vlpuOHpQ0l
         DY615KiX2d1ww+fsiQv/aZnaCMh2PdDJBI2De8Yb/jpd+pnnNBMbEpBxFc60Tie62/oH
         c50iLWsH9XWMJQrKUOfRjqgWy/FbA3jMxPIi9OntmrIta31E2zLKZmIjm4Qa3A12kik6
         StlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=444QMqDjsr/4IdpE/tLDY4FNQjqFzhOwAAsJFthSU7c=;
        b=fO0Be2o6wmY8UgK2d59GkvK5QEvrIGhiqy3tJQmIf4ElLxNXinYJp5p16XrLJwC2Gw
         Yem3yXY5eqP2dntpZ68JqrngjRi2e/wcEUwfyQsYE15tImYUD32XLZE8Uu0qz0ADvOmy
         Aj76p3Ay8flvJxWsJF92LeAimixJ6xHd6pKABeUuyGWSENxKYFK4zMktC9i0awrFT2KZ
         CytG+61/meBmya2kmjSOxFw3h6JQycHnjxS1aOTMu3YOG65eq8IF3CG9C4eFG6pbZ1t4
         +vWEr28P9bW68mIJ/kucXFsx2H6v3MuCxpQbDtmTDPuhcHCyEwX1id+IN8cJGmS+d5Os
         tAog==
X-Gm-Message-State: AOAM532bT8HjaHzu2PxXiOMENbQ16IC1iHePIZ5u8HNp0jfqEwz+BTIF
        KMAA30DIuzLNRRCJ8SIfw6c=
X-Google-Smtp-Source: ABdhPJz7PXRbMHZ8Nm7RBp4N2lsgP5cds9YsGiYdhgK0Nh9B9tsHWmMJ5A/lYTJY60dZ+VXlhzWCmw==
X-Received: by 2002:a50:8d47:: with SMTP id t7mr14669800edt.14.1637702683110;
        Tue, 23 Nov 2021 13:24:43 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id p26sm5719999edt.94.2021.11.23.13.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 13:24:42 -0800 (PST)
Date:   Tue, 23 Nov 2021 23:24:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net
Subject: Re: [PATCH net-next v2 4/8] net: phylink: update
 supported_interfaces with modes from fwnode
Message-ID: <20211123212441.qwgqaad74zciw6wj@skbuf>
References: <20211123164027.15618-1-kabel@kernel.org>
 <20211123164027.15618-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211123164027.15618-5-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 05:40:23PM +0100, Marek Behún wrote:
> Now that the 'phy-mode' property can be a string array containing more
> PHY modes (all that are supported by the board), update the bitmap of
> interfaces supported by the MAC with this property.
> 
> Normally this would be a simple intersection (of interfaces supported by
> the current implementation of the driver and interfaces supported by the
> board), but we need to keep being backwards compatible with older DTs,
> which may only define one mode, since, as Russell King says,
>   conventionally phy-mode has meant "this is the mode we want to operate
>   the PHY interface in" which was fine when PHYs didn't change their
>   mode depending on the media speed
> 
> An example is DT defining
>   phy-mode = "sgmii";
> but the board supporting also 1000base-x and 2500base-x.
> 
> Add the following logic to keep this backwards compatiblity:
> - if more PHY modes are defined, do a simple intersection
> - if one PHY mode is defined:
>   - if it is sgmii, 1000base-x or 2500base-x, add all three and then do
>     the intersection
>   - if it is 10gbase-r or usxgmii, add both, and also 5gbase-r,
>     2500base-x, 1000base-x and sgmii, and then do the intersection
> 
> This is simple enough and should work for all boards.
> 
> Nonetheless it is possible (although extremely unlikely, in my opinion)
> that a board will be found that (for example) defines
>   phy-mode = "sgmii";
> and the MAC drivers supports sgmii, 1000base-x and 2500base-x, but the
> board DOESN'T support 2500base-x, because of electrical reasons (since
> the frequency is 2.5x of sgmii).
> Our code will in this case incorrectly infer also support for
> 2500base-x. To avoid this, the board maintainer should either change DTS
> to
>   phy-mode = "sgmii", "1000base-x";
> and update device tree on all boards, or, if that is impossible, add a
> fix into the function we are introducing in this commit.
> 
> Another example would be a board with device-tree defining
>   phy-mode = "10gbase-r";
> We infer from this all other modes (sgmii, 1000base-x, 2500base-x,
> 5gbase-r, usxgmii), and these then get filtered by those supported by
> the driver. But it is possible that a driver supports all of these
> modes, and yet not all are supported because the board has an older
> version of the TF-A firmware, which implements changing of PHY modes via
> SMC calls. For this case, the board maintainer should either provide all
> supported modes in the phy-mode property, or add a fix into this
> function that somehow checks for this situation. But this is a really
> unprobable scenario, in my opinion.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
> Changes since v1:
> - added 10gbase-r example scenario to commit message
> - changed phylink_update_phy_modes() so that if supported_interfaces is
>   empty (an unconverted driver that doesn't fill up this member), we
>   leave it empty
> - rewritten phylink_update_phy_modes() according to Sean Anderson's
>   comment: use phy_interface_and/or() instead of several
>   if (test_bit) set_bit
> ---
>  drivers/net/phy/phylink.c | 70 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 3603c024109a..d2300a3a60ec 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -564,6 +564,74 @@ static int phylink_parse_fixedlink(struct phylink *pl,
>  	return 0;
>  }
>  
> +static void phylink_update_phy_modes(struct phylink *pl,
> +				     struct fwnode_handle *fwnode)
> +{
> +	unsigned long *supported = pl->config->supported_interfaces;
> +	DECLARE_PHY_INTERFACE_MASK(modes);
> +
> +	/* FIXME: If supported is empty, leave it as it is. This happens for
> +	 * unconverted drivers that don't fill up supported_interfaces. Once all
> +	 * such drivers are converted, we can drop this.
> +	 */
> +	if (phy_interface_empty(supported))
> +		return;
> +
> +	if (fwnode_get_phy_modes(fwnode, modes) < 0)
> +		return;
> +
> +	/* If no modes are defined in fwnode, interpret it as all modes
> +	 * supported by the MAC are supported by the board.
> +	 */
> +	if (phy_interface_empty(modes))
> +		return;
> +
> +	/* We want the intersection of given supported modes with those defined
> +	 * in DT.
> +	 *
> +	 * Some older device-trees mention only one of `sgmii`, `1000base-x` or
> +	 * `2500base-x`, while supporting all three. Other mention `10gbase-r`
> +	 * or `usxgmii`, while supporting both, and also `sgmii`, `1000base-x`,
> +	 * `2500base-x` and `5gbase-r`.
> +	 * For backwards compatibility with these older DTs, make it so that if
> +	 * one of these modes is mentioned in DT and MAC supports more of them,
> +	 * keep all that are supported according to the logic above.
> +	 *
> +	 * Nonetheless it is possible that a device may support only one mode,
> +	 * for example 1000base-x, due to strapping pins or some other reasons.
> +	 * If a specific device supports only the mode mentioned in DT, the
> +	 * exception should be made here with of_machine_is_compatible().
> +	 */
> +	if (bitmap_weight(modes, PHY_INTERFACE_MODE_MAX) == 1) {

I like the idea of extending the mask of phy_modes based on the
phylink_config.supported_interfaces bitmap that the driver populates
(assuming, of course, that it's converted correctly to this new format,
and I looked through the implementations and just found a bug). I think
it might just work with old device trees, too. In fact, it may work so
well, that I would even be tempted to ask "can we defer for a while
updating the device trees and bindings documents with an array, just
keep the phy modes as an array internally inside the kernel?"

On the Marvell boards that you're working with, do you have an example
board on which not all the PHY modes supported by the driver might be
available? Do you also know the reason why? You give an example in the
comments about 1000base-X and strapping, can you expand on that?

Because I think it's a bit strange to create a framework for fixups now,
when we don't even know what kind of stuff may be broken. The PHY modes
(effectively SERDES protocols) might not be what you actually want to restrict.
I mean, restricting the PHY modes is like saying: "the MAC supports
USXGMII and 10GBase-R, the PHY supports USXGMII and 10GBase-R, I know
how to configure both of them in each mode, but on this board, USXGMII
works and 10GBase-R doesn't".

?!

It may make more sense, when the time comes for the first fixup, to put
a cap on the maximum gross data rate attainable on that particular lane
(including stuff such as USXGMII symbol repetition), instead of having
to list out all the PHY modes that a driver might or might not support
right now. Imagine what pain it will be to update device trees each time
a driver gains software support for a SERDES protocol it didn't support
before. But if you cap the lane frequency, you can make phylink_update_phy_modes()
deduce what isn't acceptable using simple logic.

Also, if there's something to be broken by this change, why would we put
an of_machine_is_compatible() here, and why wouldn't we instead update
the phylink_config.supported_interfaces directly in the driver? I think
it's the driver's responsibility for passing a valid mask of supported
interfaces.

> +		DECLARE_PHY_INTERFACE_MASK(mask);
> +		bool lower = false;
> +
> +		if (test_bit(PHY_INTERFACE_MODE_10GBASER, modes) ||
> +		    test_bit(PHY_INTERFACE_MODE_USXGMII, modes)) {
> +			phy_interface_zero(mask);
> +			__set_bit(PHY_INTERFACE_MODE_5GBASER, mask);
> +			__set_bit(PHY_INTERFACE_MODE_10GBASER, mask);
> +			__set_bit(PHY_INTERFACE_MODE_USXGMII, mask);
> +			phy_interface_and(mask, supported, mask);
> +			phy_interface_or(modes, modes, mask);
> +			lower = true;
> +		}
> +
> +		if (lower || (test_bit(PHY_INTERFACE_MODE_SGMII, modes) ||
> +			      test_bit(PHY_INTERFACE_MODE_1000BASEX, modes) ||
> +			      test_bit(PHY_INTERFACE_MODE_2500BASEX, modes))) {
> +			phy_interface_zero(mask);
> +			__set_bit(PHY_INTERFACE_MODE_SGMII, mask);
> +			__set_bit(PHY_INTERFACE_MODE_1000BASEX, mask);
> +			__set_bit(PHY_INTERFACE_MODE_2500BASEX, mask);
> +			phy_interface_and(mask, supported, mask);
> +			phy_interface_or(modes, modes, mask);
> +		}
> +	}
> +
> +	phy_interface_and(supported, supported, modes);
> +}
> +
>  static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
>  {
>  	struct fwnode_handle *dn;
> @@ -1157,6 +1225,8 @@ struct phylink *phylink_create(struct phylink_config *config,
>  	__set_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
>  	timer_setup(&pl->link_poll, phylink_fixed_poll, 0);
>  
> +	phylink_update_phy_modes(pl, fwnode);
> +
>  	bitmap_fill(pl->supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>  	linkmode_copy(pl->link_config.advertising, pl->supported);
>  	phylink_validate(pl, pl->supported, &pl->link_config);
> -- 
> 2.32.0
> 
