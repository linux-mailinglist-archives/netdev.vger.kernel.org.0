Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE49202439
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 16:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgFTOnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 10:43:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50052 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgFTOnh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 10:43:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmeiH-001PCT-CW; Sat, 20 Jun 2020 16:43:21 +0200
Date:   Sat, 20 Jun 2020 16:43:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <linux@rempel-privat.de>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH/RFC 1/5] dt-bindings: net: renesas,ravb: Document
 internal clock delay properties
Message-ID: <20200620144321.GH304147@lunn.ch>
References: <20200619191554.24942-1-geert+renesas@glider.be>
 <20200619191554.24942-2-geert+renesas@glider.be>
 <e6d0bfc5-9d75-2dc9-2bfa-671c32cb0b7c@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6d0bfc5-9d75-2dc9-2bfa-671c32cb0b7c@rempel-privat.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 07:47:16AM +0200, Oleksij Rempel wrote:
> Hi Geert,
> 
> Am 19.06.20 um 21:15 schrieb Geert Uytterhoeven:
> > Some EtherAVB variants support internal clock delay configuration, which
> > can add larger delays than the delays that are typically supported by
> > the PHY (using an "rgmii-*id" PHY mode, and/or "[rt]xc-skew-ps"
> > properties).
> >
> > Add properties for configuring the internal MAC delays.
> > These properties are mandatory, even when specified as zero, to
> > distinguish between old and new DTBs.
> >
> > Update the example accordingly.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> >  .../devicetree/bindings/net/renesas,ravb.txt  | 29 ++++++++++---------
> >  1 file changed, 16 insertions(+), 13 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/net/renesas,ravb.txt b/Documentation/devicetree/bindings/net/renesas,ravb.txt
> > index 032b76f14f4fdb38..488ada78b6169b8e 100644
> > --- a/Documentation/devicetree/bindings/net/renesas,ravb.txt
> > +++ b/Documentation/devicetree/bindings/net/renesas,ravb.txt
> > @@ -64,6 +64,18 @@ Optional properties:
> >  			 AVB_LINK signal.
> >  - renesas,ether-link-active-low: boolean, specify when the AVB_LINK signal is
> >  				 active-low instead of normal active-high.
> > +- renesas,rxc-delay-ps: Internal RX clock delay.
> 
> may be it make sense to add a generic delay property for MACs and PHYs?

See Dan Murphys "RGMII Internal delay common property" patchset. That
patchset is addressing the PHY side. Maybe we can build on that to
address the MAC side?

	Andrew
