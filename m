Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D89A644430
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiLFNKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbiLFNKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:10:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5981A380;
        Tue,  6 Dec 2022 05:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VnpjLHo/sa2cz01oNYrd1ELG111YGtUPPSMPURQFhK4=; b=eJZ9nei4Og3IjrlvXXmkRS9MZX
        eB7DRiCw+bbdcFxcZTrsYXsx9JcqYAnCONBCNZzxnPbz9Ril2/aguLqXLIIun0K5tu7uTLLqFJH/q
        EkXw+y1GiVrjDoNmOys9cTFWvuQot3pteBfQmYxGzXWSKXgGsSH4KraKYK2zFxmOw/a8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2Xfw-004Wo4-3K; Tue, 06 Dec 2022 14:07:56 +0100
Date:   Tue, 6 Dec 2022 14:07:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v5 net-next 2/2] net: phy: micrel: Fix warn: passing zero
 to PTR_ERR
Message-ID: <Y48+rLpF7Gre/s1P@lunn.ch>
References: <20221206073511.4772-1-Divya.Koppera@microchip.com>
 <20221206073511.4772-3-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206073511.4772-3-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 1bcdb828db56..650ef53fcf20 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -3017,10 +3017,6 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
>  {
>  	struct lan8814_shared_priv *shared = phydev->shared->priv;
>  
> -	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> -	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> -		return 0;
> -

Why are you removing this ?

    Andrew
