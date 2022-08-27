Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E649D5A38B0
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 18:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiH0QLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 12:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbiH0QLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 12:11:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC162AC51;
        Sat, 27 Aug 2022 09:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5+EcxU/p9tcH2joiDA44y00ZRz2SBbdI45Ym8eBkZoE=; b=42OA2XZGSF7TX9xMJ9wA5TFF5K
        AKJZXAdUUSFP9KOcOHYHwYdwM7EW+Sbaj8uqR8r1xRSW/Mr03br7GLUhG2DXoJ3oQ1pctq4soqra8
        4UQ/LuySgXbyK+lnOqYtWIPZLLKJZ7TyTW6uDXx8M1ZqnSGWOh/m0JxaH+qzvF+KNHig=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRyOz-00EmsE-2r; Sat, 27 Aug 2022 18:11:17 +0200
Date:   Sat, 27 Aug 2022 18:11:17 +0200
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
Subject: Re: [PATCH net-next v2 1/7] dt-bindings: net: pse-dt: add bindings
 for generic PSE controller
Message-ID: <YwpCJULGjuw4dK7W@lunn.ch>
References: <20220825130211.3730461-1-o.rempel@pengutronix.de>
 <20220825130211.3730461-2-o.rempel@pengutronix.de>
 <Ywf3Z+1VFy/2+P78@lunn.ch>
 <20220826074940.GC2116@pengutronix.de>
 <Ywou0na2zy3cLJG+@lunn.ch>
 <20220827151217.GG2116@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220827151217.GG2116@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ok, so current plan is:
> - rename this driver and binding to pse-regulator
> - i will integrate the "ieee802.3-pairs" property, since this driver
>   need to know which field it need to fill in the ethtool response (PSE
>   vs PoDL PSE)

It seems odd to have a property which only purpose is to supply
userspace with some information. If all you have is a single
regulator, does it even matter if it is PSE vs PoDL PSE?

If you think it does matter, i would probably have two compatibles.

   Andrew

