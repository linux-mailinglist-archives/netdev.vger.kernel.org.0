Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1269585860
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 05:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239980AbiG3D4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 23:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239891AbiG3Dz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 23:55:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80C718B34;
        Fri, 29 Jul 2022 20:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JVsC0xoxn3sYecOyx9axL+kOqYWjJrBFCKfFASN0cRA=; b=J1+kXzNR4r0BEaNxHBITZRVNuQ
        sQZhXfxwIaAdrplif3WHXtGD0LFpYwz10T/g1BDjCziPdgpnf0qIcpsKyx5T6cc69mmogPHhGvHi+
        8ra8BZXKkSfxOnwbFgDtHPWup9mOGlHpfMuFSbFj7Ik5fJ43jk9ZnIOhgXWRgYyQUZX8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oHda1-00BzRu-1A; Sat, 30 Jul 2022 05:55:57 +0200
Date:   Sat, 30 Jul 2022 05:55:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH net-next v3 2/4] dt-bindings: net: ethernet-controller:
 add QUSGMII mode
Message-ID: <YuSrzX+47vw7wGFI@lunn.ch>
References: <20220729153356.581444-1-maxime.chevallier@bootlin.com>
 <20220729153356.581444-3-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729153356.581444-3-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 05:33:54PM +0200, Maxime Chevallier wrote:
> Add a new QUSGMII mode, standing for "Quad Universal Serial Gigabit
> Media Independent Interface", a derivative of USGMII which, similarly to
> QSGMII, allows to multiplex 4 1Gbps links to a Quad-PHY.
> 
> The main difference with QSGMII is that QUSGMII can include an extension
> instead of the standard 7bytes ethernet preamble, allowing to convey
> arbitrary data such as Timestamps.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> Acked-by: Rob Herring <robh@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
