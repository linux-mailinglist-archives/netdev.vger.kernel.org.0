Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B2D316F6B
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbhBJTAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 14:00:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33128 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233756AbhBJS6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 13:58:46 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9ugO-005NHt-KI; Wed, 10 Feb 2021 19:57:48 +0100
Date:   Wed, 10 Feb 2021 19:57:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan Varadharajan 
        <prasanna.vengateshan@microchip.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        robh+dt@kernel.org, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/8] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Message-ID: <YCQsrPNmyRnhp4Mm@lunn.ch>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
 <20210128064112.372883-2-prasanna.vengateshan@microchip.com>
 <20210130020227.ahiee4goetpp2hb7@skbuf>
 <6531ab6c7e40b7e2f73a6087b31ecfe0a8f214e4.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6531ab6c7e40b7e2f73a6087b31ecfe0a8f214e4.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +        ethernet-ports {
> > > +          #address-cells = <1>;
> > > +          #size-cells = <0>;
> > > +          port@0 {
> > > +            reg = <0>;
> > > +            label = "lan1";
> > > +          };
> > > +          port@1 {
> > > +            reg = <1>;
> > > +            label = "lan2";
> > > +          };
> > > +          port@2 {
> > > +            reg = <7>;
> > 
> > reg should match node index (port@2), here and everywhere below. As
> > for
> > the net device labels, I'm not sure if the mismatch is deliberate
> > there.
> reg & port node indexes are different here because to match with the
>  physical to logical port mapping done in the LAN9374. I realized that
> the description is missing and that is to be added. However, should reg
> & port node index match for the net dev? 
> If it should be the same, then the same can be acheived by renaming a
> label (lanx) as well.

The label should match whatever the text on the device case says. So
it is fine if port 2 says lan3 on the front panel. However, port@2
should have reg=<2>. Please change it to port@7. This is a generic DT
requirement, not specific to DSA.

       Andrew
