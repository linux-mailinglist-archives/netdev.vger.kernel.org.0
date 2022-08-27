Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA115A38CC
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 18:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbiH0Qk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 12:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiH0QkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 12:40:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788A732042;
        Sat, 27 Aug 2022 09:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1qxz11csHlRde10VOF4ER62xHAAcANDj0X6F7thPb4E=; b=UVIdWaKluWEj0kwGfFc7eKGy72
        QKYM3WwPhe3kIAdwZb7ijMij6UUKRIRS5wkxb+G4R5FxLdwMfBF+IwyhZgPJ0/CHwD8jrcO0D55wK
        +6HrknIPjz1I5Pwxq/RUo3gBOvGpJSPum5gqgmGlgfUAt6Z2t7iu8aIUjvVBqMcsMGrM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRyr0-00Emxj-8H; Sat, 27 Aug 2022 18:40:14 +0200
Date:   Sat, 27 Aug 2022 18:40:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v3 3/7] net: add framework to support Ethernet
 PSE and PDs devices
Message-ID: <YwpI7opQlDMp2Qyd@lunn.ch>
References: <20220827051033.3903585-1-o.rempel@pengutronix.de>
 <20220827051033.3903585-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220827051033.3903585-4-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 27, 2022 at 07:10:29AM +0200, Oleksij Rempel wrote:
> This framework was create with intention to provide support for Ethernet PSE
> (Power Sourcing Equipment) and PDs (Powered Device).
> 
> At current step this patch implements generic PSE support for PoDL (Power over
> Data Lines 802.3bu) specification with reserving name space for PD devices as
> well.
> 
> This framework can be extended to support 802.3af and 802.3at "Power via the
> Media Dependent Interface" (or PoE/Power over Ethernet)
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
