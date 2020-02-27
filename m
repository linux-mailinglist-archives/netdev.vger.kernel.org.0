Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA1917250A
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgB0R0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:26:17 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41034 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729648AbgB0R0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:26:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rV0yWDS028EyWe+FVKxyqef5iqunBgE96eEFUfnUJg0=; b=FsHxrqEQKZ1XG1e6Z9ClQ7uES
        mGZ0Xq59EIhuvKGUh/Gu31A6oI7Y0Y7z8OwZfy3BRBhedPjIbzYW4h3EsQxccGYVf0tkLGtf99fxN
        SdZtb5z3GiM2WjXx/2ZaGxHALijVbLSmfxZ9Tv7OjuI9zS9P23kfyjKKxVEIz9RrLP3dB6sm0kdkf
        Mph5NmgVVOnXJ2q0JN8Lb1/sYVDVcCRmTmWn08cDjSNsKuuTB26NnZZaH4YFt7WBbzIc8RdgFWYnl
        FmwtJYqlPdzvQKuLaTAI5iJNDLdaDET+UowN1Ar+b/5NqNGjcPfO8hFMztg9/g4k1EnDZ55uYnlN0
        xfIQHndBA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:53558)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j7MvK-0006xK-KA; Thu, 27 Feb 2020 17:26:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j7MvI-00019B-Fg; Thu, 27 Feb 2020 17:26:08 +0000
Date:   Thu, 27 Feb 2020 17:26:08 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: add dt bindings for
 marvell10g driver
Message-ID: <20200227172608.GO25745@shell.armlinux.org.uk>
References: <20200227095159.GJ25745@shell.armlinux.org.uk>
 <E1j7FqO-0003sv-Ho@rmk-PC.armlinux.org.uk>
 <CAL_JsqK9SLJKZfGjWu3RCk9Wiof+YdUaMziwOrCw5ZxjMZAq_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqK9SLJKZfGjWu3RCk9Wiof+YdUaMziwOrCw5ZxjMZAq_Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 11:13:41AM -0600, Rob Herring wrote:
> On Thu, Feb 27, 2020 at 3:52 AM Russell King <rmk+kernel@armlinux.org.uk> wrote:
> >
> > Add a DT bindings document for the Marvell 10G driver, which will
> > augment the generic ethernet PHY binding by having LED mode
> > configuration.
> >
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  .../devicetree/bindings/net/marvell,10g.yaml  | 31 +++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/marvell,10g.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/marvell,10g.yaml b/Documentation/devicetree/bindings/net/marvell,10g.yaml
> > new file mode 100644
> > index 000000000000..da597fc5314d
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/marvell,10g.yaml
> > @@ -0,0 +1,31 @@
> > +# SPDX-License-Identifier: GPL-2.0+
> 
> Dual license new bindings please:
> 
> (GPL-2.0-only OR BSD-2-Clause)
> 
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/marvell,10g.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Marvell Alaska X family Ethernet PHYs
> > +
> > +maintainers:
> > +  - Russell King <rmk+kernel@armlinux.org.uk>
> > +
> > +allOf:
> > +  - $ref: ethernet-phy.yaml#
> > +
> > +properties:
> > +  marvell,led-mode:
> > +    description: |
> > +      An array of one to four 16-bit integers to write to the PHY LED
> > +      configuration registers.
> 
> This is for what to blink or turn on for? I thought we had something
> generic for configuring PHY LEDs specifically?

I see nothing in ethernet-phy.yaml.

Yes, it configures which conditions cause the LED to illuminate and/or
blink, what blink rate and polarity of the pin.

> > +    allOf:
> > +      - $ref: /schemas/types.yaml#/definitions/uint16-array
> > +      - minItems: 1
> > +        maxItems: 4
> > +
> > +examples:
> > +  - |
> > +    ethernet-phy@0 {
> > +        reg = <0>;
> 
> This needs to be under an 'mdio' node with #address-cells and
> #size-cells set correctly.

I wish these things were documented somewhere... I'm pretty sure this
passed validation when I wrote it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
