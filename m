Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8861F9F3C
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 20:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731274AbgFOSPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 14:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgFOSPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 14:15:22 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4CCC061A0E;
        Mon, 15 Jun 2020 11:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zvkQuGM3IsR34BEyAX62BLAfdrNM9I5xmocgMbFO1Lg=; b=i38VihqNIvcpDPK1HeExRe/m2+
        UHuq5PWGHTdI3SFPaRzakWY2nSOelK+Bc8BdqHf7fAZGRboAm0DUkw6Xu2I52d87vvuj+TJud2Kj3
        mKdn4WBJmyNv/Q6fL4EJoinAY+UN1C4g3539FV+6p/Mg8eYD4bdrtj4AEVoVwL7U/vEJs7hNznlDa
        zeD9gS0cOT1KRUvWRwJcoEj4iRKtpN5peCNT6rnrqMBdVzktPdp2Jb9aZQ0hjziQQwHCRtbrcXDrj
        rOVr06xA1Ueurj4gtsu9RPCbaAv8EG+7DvWiLjxetkU5EGWuxJUUWvAaA2qiqI6xMM3/0aeRHJceE
        qTwQowNA==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jktdc-0007gZ-0L; Mon, 15 Jun 2020 19:15:16 +0100
Date:   Mon, 15 Jun 2020 19:15:15 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: net: dsa: qca8k: document SGMII
 properties
Message-ID: <20200615181515.GC17897@earth.li>
References: <cover.1591380105.git.noodles@earth.li>
 <ca767d2dd00280f7c0826c133d1ff6f262b6736d.1591380105.git.noodles@earth.li>
 <20200615174516.GA2018349@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615174516.GA2018349@bogus>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 11:45:16AM -0600, Rob Herring wrote:
> On Fri, Jun 05, 2020 at 07:10:02PM +0100, Jonathan McDowell wrote:
> > This patch documents the qca8k's SGMII related properties that allow
> > configuration of the SGMII port.
> > 
> > Signed-off-by: Jonathan McDowell <noodles@earth.li>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > index ccbc6d89325d..9e7d74a248ad 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > @@ -11,7 +11,11 @@ Required properties:
> >  
> >  Optional properties:
> >  
> > +- disable-serdes-autoneg: Boolean, disables auto-negotiation on the SerDes
> >  - reset-gpios: GPIO to be used to reset the whole device
> > +- sgmii-delay: Boolean, presence delays SGMII clock by 2ns
> > +- sgmii-mode: String, operation mode of the SGMII interface.
> > +  Supported values are: "basex", "mac", "phy".
> 
> Either these should be common properties and documented in a common 
> spot or they need vendor prefixes. They seem like they former to me 
> (though 'sgmii-delay' would need to be more general and take a time).

I've managed to spin a subsequent revision which avoids the need for a
device tree change, based on comments similar to yours. I'll keep them
in mind should it become necessary to re-introduce the DT options.

J.

-- 
] https://www.earth.li/~noodles/ []  I'm a creep, I'm a weirdo, what   [
]  PGP/GPG Key @ the.earth.li    []     the hell am I doing here?      [
] via keyserver, web or email.   []                                    [
] RSA: 4096/0x94FA372B2DA8B985   []                                    [
