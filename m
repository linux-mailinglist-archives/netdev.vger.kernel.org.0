Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A067C1D0505
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 04:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgEMCeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 22:34:23 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38781 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgEMCeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 22:34:22 -0400
Received: by mail-ot1-f66.google.com with SMTP id m33so12279721otc.5;
        Tue, 12 May 2020 19:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fKA+HN7DFIpgs8ZrB5MxC4H5K1lA7nFWaEml5FhCyq4=;
        b=r+M9H2GbEgUT1j4fSMTTMW2ME++zzmMKTlHEgnbxQYqpsyJ7mx5hqmPfH7re8E7/yF
         vFVIaOPq4bZDhmtFWyfR8Z2tph033v7LnqUvSHGNi0O6SnoOTh9AjvpufVROzWOztap4
         oWsNnKujY+K9ruSkNr67dXPlyZOHsdL7uNCDdlQjjoEl/FkmuMG3blI54Hba3+l3Jk1s
         GCHznrM53QYp0H/ynRs7yVhOL0CgkQlJMuGxVdayk/wb1XLOWz2keeCrMhN2bxXgkP2C
         DniQQ/i/BIDauvR5Ascp9+dNb1AQ7CUklECECDg2V1e8XBKabKzOXgUPMGYY5vUsOORl
         ywJQ==
X-Gm-Message-State: AGi0PubwZb7S5qgnz7nd1DnrVb6OXcWWiLsbVg53TlJzeNx+mzj0uzF+
        Y7q/QaJIL9aNevwwfmNOzA==
X-Google-Smtp-Source: APiQypLhhqul6TC7LRjZ60DCqeVuIHtcQj9P8NPNm6b/uH4cFIdWF9E2N+vMFiUIlETyiZKUYsyVbw==
X-Received: by 2002:a9d:2aa1:: with SMTP id e30mr19243391otb.364.1589337259735;
        Tue, 12 May 2020 19:34:19 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id v207sm5736450oie.3.2020.05.12.19.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 19:34:19 -0700 (PDT)
Received: (nullmailer pid 18007 invoked by uid 1000);
        Wed, 13 May 2020 02:34:18 -0000
Date:   Tue, 12 May 2020 21:34:18 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v1] dt-bindings: net: nxp,tja11xx: rework validation
 support
Message-ID: <20200513023418.GA23016@bogus>
References: <20200505104215.8975-1-o.rempel@pengutronix.de>
 <20200505140127.GJ208718@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505140127.GJ208718@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 04:01:27PM +0200, Andrew Lunn wrote:
> On Tue, May 05, 2020 at 12:42:15PM +0200, Oleksij Rempel wrote:
> > To properly identify this node, we need to use ethernet-phy-id0180.dc80.
> > And add missing required properties.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  .../devicetree/bindings/net/nxp,tja11xx.yaml  | 55 ++++++++++++-------
> >  1 file changed, 35 insertions(+), 20 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> > index 42be0255512b3..cc322107a24a2 100644
> > --- a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> > +++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> > @@ -1,4 +1,4 @@
> > -# SPDX-License-Identifier: GPL-2.0+
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >  %YAML 1.2
> >  ---
> >  $id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
> > @@ -12,44 +12,59 @@ maintainers:
> >    - Heiner Kallweit <hkallweit1@gmail.com>
> >  
> >  description:
> > -  Bindings for NXP TJA11xx automotive PHYs
> > +  Bindings for the NXP TJA1102 automotive PHY. This is a dual PHY package where
> > +  only the first PHY has global configuration register and HW health
> > +  monitoring.
> >  
> > -allOf:
> > -  - $ref: ethernet-phy.yaml#
> > +properties:
> > +  compatible:
> > +    const: ethernet-phy-id0180.dc80
> > +    description: ethernet-phy-id0180.dc80 used for TJA1102 PHY
> > +
> > +  reg:
> > +    minimum: 0
> > +    maximum: 14
> > +    description:
> > +      The PHY address of the parent PHY.
> 
> Hi Oleksij
> 
> reg is normally 0 to 31, since that is the address range for MDIO. 
> Did you use 14 here because of what strapping allows?
> 
> > +required:
> > +  - compatible
> > +  - reg
> > +  - '#address-cells'
> > +  - '#size-cells'
> 
> So we have two different meanings of 'required' here.
> 
> One meaning is the code requires it. compatible is not required, the
> driver will correctly be bind to the device based on its ID registers.
> Is reg also required by the code?
> 
> The second meaning is about keeping the yaml verifier happy. It seems
> like compatible is needed for the verifier. Is reg also required? We
> do recommend having reg, but the generic code does not require it.

Well, you have to be able to match a discoverable device to a DT node. 
Unless you only have one thing on the bus (how would you know though, 
they're discoverable?), that's with reg. And if you need to say turn on 
a regulator for the device to be discovered, then you need compatible to 
know how to do that.

So either don't describe the device in DT because you can discover 
everything or you describe it in DT with both 'compatible' and 'reg'. 
MDIO is not special.

Rob
