Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDE96079E0
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJUOq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiJUOqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:46:17 -0400
Received: from vps0.lunn.ch (unknown [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7C324FED2;
        Fri, 21 Oct 2022 07:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=DASFuLJJNq4WTKnN3M+jeaBpyWIiNxGCwtAM3YAh+VM=; b=VM39L88LKRPTrVCMfOfG/HywTz
        RBERUxhuPov67KcUQ3aJCiGojCyQ0THud8AxZOBGJp1TauhVL6u2Z45nEcmJ31Gx38wEMjybJyopE
        vlPY19zFYrH6zGpJTOmmyeO6lYxu6X8s3/k2RlP0MlX2Fo/Gjpy9Jx/Sfr+sdqo+JIh4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oltHl-000F9R-Kg; Fri, 21 Oct 2022 16:46:09 +0200
Date:   Fri, 21 Oct 2022 16:46:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v5 3/5] net: dsa: add out-of-band tagging
 protocol
Message-ID: <Y1KwsWO70vUJOhf7@lunn.ch>
References: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
 <20221021124556.100445-4-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021124556.100445-4-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NEUTRAL,SPF_NEUTRAL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 3eef72ce99a4..c50508e9f636 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -57,6 +57,14 @@ config NET_DSA_TAG_HELLCREEK
>  	  Say Y or M if you want to enable support for tagging frames
>  	  for the Hirschmann Hellcreek TSN switches.
>  
> +config NET_DSA_TAG_OOB
> +	select SKB_EXTENSIONS
> +	tristate "Tag driver for Out-of-band tagging drivers"

Here the sorting is based on the tristate. So again, after Ocelot
8021q please.

      Andrew
