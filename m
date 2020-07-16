Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149AD222ECF
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgGPXNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:13:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39766 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726113AbgGPXNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 19:13:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jwCQe-005W6C-L1; Fri, 17 Jul 2020 00:32:36 +0200
Date:   Fri, 17 Jul 2020 00:32:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Matthew Hagan <mnhagan88@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
Message-ID: <20200716223236.GA1314837@lunn.ch>
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
 <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 03:09:25PM -0700, Jakub Kicinski wrote:
> On Mon, 13 Jul 2020 21:50:26 +0100 Matthew Hagan wrote:
> > Add names and decriptions of additional PORT0_PAD_CTRL properties.
> > 
> > Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > index ccbc6d89325d..3d34c4f2e891 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > @@ -13,6 +13,14 @@ Optional properties:
> >  
> >  - reset-gpios: GPIO to be used to reset the whole device
> >  
> > +Optional MAC configuration properties:
> > +
> > +- qca,exchange-mac0-mac6:	If present, internally swaps MAC0 and MAC6.
> 
> Perhaps we can say a little more here?
> 
> > +- qca,sgmii-rxclk-falling-edge:	If present, sets receive clock phase to
> > +				falling edge.
> > +- qca,sgmii-txclk-falling-edge:	If present, sets transmit clock phase to
> > +				falling edge.
> 
> These are not something that other vendors may implement and therefore
> something we may want to make generic? Andrew?

I've never seen any other vendor implement this. Which to me makes me
think this is a vendor extension, to Ciscos vendor extension of
1000BaseX.

Matthew, do you have a real use cases of these? I don't see a DT patch
making use of them. And if you do, what is the PHY on the other end
which also allows you to invert the clocks?

       Andrew
