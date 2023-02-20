Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0742269D0B9
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbjBTPfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbjBTPfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:35:05 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB0F99;
        Mon, 20 Feb 2023 07:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jiUNs+XPy3wI2cI5f4T6K+ubODlCpF8ab3E9enHqUMA=; b=peBbdGiK4NIGz4e9u30LJo6zis
        8gUKhx2d0z7STGXGsBnmSUWcmRqCpGqxXaXrckZ1petD0rw94G/RqwPIKqgdizTIq47Lure3xTshk
        4vbCU1d2tiNMBPHMOV7vuyokzaqMsj4lUO8txj3Hw7bYHUK9HDrGuNsSVBP8b1yIzwdg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pU8Bt-005WGB-QC; Mon, 20 Feb 2023 16:34:57 +0100
Date:   Mon, 20 Feb 2023 16:34:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v1 4/4] net: phy: c45:
 genphy_c45_ethtool_set_eee: validate EEE link modes
Message-ID: <Y/OTIQPmSaKAMchT@lunn.ch>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
 <20230220135605.1136137-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220135605.1136137-5-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +			adv[0] = data->advertised;

Same here please.

> +			linkmode_andnot(adv, adv, phydev->supported_eee);
> +			if (!linkmode_empty(adv)) {
> +				phydev_warn(phydev, "At least some EEE link modes are not supported.\n");
> +				return -EINVAL;
> +			}
> +
>  			phydev->advertising_eee[0] = data->advertised;

...

	Andrew
