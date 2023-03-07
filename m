Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56BCA6AFA29
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 00:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjCGXU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 18:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCGXU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 18:20:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8929545B;
        Tue,  7 Mar 2023 15:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MEsDeIzfvSdQj8Fljw8bkhuz1XEGejvnjA+UHXeQYLY=; b=SJ6iOaCSrsXj6YREg8CRLGO33Z
        QqYyW0g7F1JkAjKMS43N/Nho6bdXGn/Syf0E/PghEDKAxgpBhrz0KFiW9NSA8/ObsXAiRDH2ibeMb
        pTRXbCcb9KnZvSiAsy5GgD4bmNESPChZ0zGZm+85asspMHyZorFDptqrh928FdiXV2OU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZgbR-006iUK-Tk; Wed, 08 Mar 2023 00:20:17 +0100
Date:   Wed, 8 Mar 2023 00:20:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH 11/11] arm: mvebu: dt: Add PHY LED support for
 370-rd WAN port
Message-ID: <70a38eb2-7ade-4474-8e1a-f18e99d45977@lunn.ch>
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-12-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307170046.28917-12-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 06:00:46PM +0100, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> The WAN port of the 370-RD has a Marvell PHY, with one LED on
> the front panel. List this LED in the device tree.
> 
> Set the LED default state to "keep" to not change any blink rule
> set by default.

Hi Christian

What board are you using for testing? It would be good to patch its
.dts file to enable its LEDs. We don't normally had new code without a
user.

	Andrew
