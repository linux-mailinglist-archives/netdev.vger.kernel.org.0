Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585706079D7
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiJUOn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiJUOn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:43:57 -0400
Received: from vps0.lunn.ch (unknown [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E9B27FABF;
        Fri, 21 Oct 2022 07:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=73aqR6HV5iOcxyMSF4YE4ZmbimjzG5hqXoHDTRylJ4E=; b=strngkscdax+cwEcwSvU9iuLvn
        Pr3fH3nNfLRtg7p+KgHGYDKLHT7B0fbe7vpVJE9NTIvzPgmtusbiUz9ED+PWwZUeFZMR6JC2+aEvN
        gOqBPoDRMZT9Z3Gx+VjqCSKqBMO9/jNzCMg1U/iDSgnTXztBrRScPtp1eaLn9rtS60Vg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oltFY-000F8w-Dz; Fri, 21 Oct 2022 16:43:52 +0200
Date:   Fri, 21 Oct 2022 16:43:52 +0200
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
Message-ID: <Y1KwKGcssBJ5tixJ@lunn.ch>
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

> @@ -17,6 +17,7 @@ obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
>  obj-$(CONFIG_NET_DSA_TAG_DSA_COMMON) += tag_dsa.o
>  obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
>  obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
> +obj-$(CONFIG_NET_DSA_TAG_OOB) += tag_oob.o
>  obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
>  obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
>  obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o

This list is roughly in alphabetic order, part from
CONFIG_NET_DSA_TAG_RTL4_A. Please add OOB after OCELOT_8021Q.

Thanks
	Andrew
