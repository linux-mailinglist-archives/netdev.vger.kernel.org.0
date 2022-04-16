Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABCF5036DC
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 15:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiDPNvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 09:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiDPNvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 09:51:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF433C704;
        Sat, 16 Apr 2022 06:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=fQFaKMW6gm7npdxtIFfE0RrlCeY4gGTbCdpIyvFb5xM=; b=jp
        VmvmVOHSw88NPCp4V/2PxuyNxwbsmzPNyOev4P3KCRmN6I8plSNrqHM4cciCmJvvbRBzVC/tM5abN
        y9/SQDNy5Cd/gw5iTSvh5vi+J/WIJLJBSdJKaqtKpKbZfJ67xAH7+kb1b05dnGWI1e5wOnDS4pxeq
        ezm+UTmZ0fmeuqw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nfinD-00G6bB-T1; Sat, 16 Apr 2022 15:48:51 +0200
Date:   Sat, 16 Apr 2022 15:48:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/12] ARM: dts: r9a06g032: describe MII
 converter
Message-ID: <YlrJQ47tkmQdhtMu@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-10-clement.leger@bootlin.com>
 <YlismVi8y3Vf6PZ0@lunn.ch>
 <20220415102453.1b5b3f77@fixe.home>
 <Yll+Tpnwo5410B9H@lunn.ch>
 <20220415163853.683c0b6d@fixe.home>
 <YlmLWv4Hsm2uk8pa@lunn.ch>
 <20220415172954.64e53086@fixe.home>
 <YlmbIjoIZ8Xb4Kh/@lunn.ch>
 <20220415184541.0a6928f5@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220415184541.0a6928f5@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 06:45:41PM +0200, Clément Léger wrote:
> Le Fri, 15 Apr 2022 18:19:46 +0200,
> Andrew Lunn <andrew@lunn.ch> a écrit :
> 
> > > I think it would be good to modify it like this:
> > > 
> > > eth-miic@44030000 {
> > >     ...
> > >   converters {
> > >     mii_conv0: mii-conv@0 {
> > >       // Even if useless, maybe keeping it for the sake of coherency
> > >       renesas,miic-input = <MIIC_GMAC1>;
> > >       reg = <0>;
> > >     };  
> > 
> > This is not a 'bus', so using reg, and @0, etc is i think wrong.  You
> > just have a collection of properties.
> 
> Agreed, but this is the same thing that is done for DSA ports (at least
> I think). It uses reg which describe the port number, this is not a
> real bus per se, it only refer to port indices.

True. That is an old binding, before a lot of good practices were
enforced. I'm not sure it would be accepted today.

I suggest you make a proposal and see what the DT Maintainers say.

> But if you think this should not be done like this, what do you
> propose then ? These nodes are also reference from "pcs-handle"
> properties in switch to retrieve the PCS.

This i was not thinking about. Make this clear in the binding
documentation for what you propose.

Humm, this last point just gave me an idea. How are you representing
the PCS in DT? Are they memory mapped? So you have a nodes something
like:

eth-pcs-conv1@44040100 {
	compatible = "acm-inc,pcs"
}

eth-pcs-conv2@44040200 {
	compatible = "acm-inc,pcs"
}

The MAC node than has a pcs-handle pointing to one of these nodes?

You implicitly have the information you need to configure the MII
muxes here. The information is a lot more distributed, but it is
there. As each MAC probes, it can ask the MII MUX driver to connect
its MAC to the converter pointed to by its pcs-handle.

	Andrew

