Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D2918DB7B
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 00:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbgCTXFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 19:05:09 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:37368 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgCTXFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 19:05:09 -0400
Received: by mail-il1-f195.google.com with SMTP id a6so7223459ilc.4;
        Fri, 20 Mar 2020 16:05:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nIWOiKMDqsOkzdHOwt1Pgu15FcIP6eSPSTCofdmQ7P0=;
        b=kMewjn0+3bUcgUnmbrFD6uXeVmdudLGUjZyy9KX81kJsDR6Rq/3HY+mxR2T4XdXK2s
         PQ2qJ0KbbJf6kWhOIQ/Nm1YCS4X64LSZ90/sMn9TPDWBwaMAmsVDTVuL/OeZTrVeHXZi
         DVZTtE8FQtCtcr4sMzZhYrW6YBWLXZgV8dtB+HdqNHbKDG5zQDJ8TCBv53P8n9DKYjE8
         QcJKi6bhINJqcdWUMnUBDBGJ2LCuLLR5S08OZhYkwtokISkF9AcIZfAcUuQH4h4fTwZX
         cHTF4NGYcFUgkXnZyx3Y7SbIBwchVxclbDtvJo3RCYeHrEbWvKRNNhu2DtEOMmk27oG3
         uhhQ==
X-Gm-Message-State: ANhLgQ146HGi+gEQ9BWnVTTnjlexHkR3A38OwsuWLUBwunDv52hV1kMP
        88Rjtx6rVooSJp4HDE9BEw==
X-Google-Smtp-Source: ADFU+vsp05fLbA5STpkQJaBrSR3y0lMYeypridHN3erUTUJpS7/dNF0qlRNaymHKBZMwoMSKHkQPag==
X-Received: by 2002:a92:5fc1:: with SMTP id i62mr9839602ill.15.1584745508424;
        Fri, 20 Mar 2020 16:05:08 -0700 (PDT)
Received: from rob-hp-laptop ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id j1sm1965120iop.32.2020.03.20.16.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 16:05:06 -0700 (PDT)
Received: (nullmailer pid 7286 invoked by uid 1000);
        Fri, 20 Mar 2020 23:05:04 -0000
Date:   Fri, 20 Mar 2020 17:05:04 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add support for NXP TJA11xx
Message-ID: <20200320230504.GA30209@bogus>
References: <20200313052252.25389-1-o.rempel@pengutronix.de>
 <20200313052252.25389-2-o.rempel@pengutronix.de>
 <545d5e46-644a-51fb-0d67-881dfe23e9d8@gmail.com>
 <20200313181056.GA29732@lunn.ch>
 <20200313181601.sbxdrqdjqfj3xn3e@pengutronix.de>
 <15dafdcd-1979-bf35-3968-c80ffc113001@gmail.com>
 <20200313185327.nawcp2imfldyhpqa@pengutronix.de>
 <20200317115626.4ncavxdcw4wu5zgc@pengutronix.de>
 <137a6dd3-c5ba-25b1-67ff-f0112afd7f34@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <137a6dd3-c5ba-25b1-67ff-f0112afd7f34@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 12:48:47PM -0700, Florian Fainelli wrote:
> 
> 
> On 3/17/2020 4:56 AM, Oleksij Rempel wrote:
> > On Fri, Mar 13, 2020 at 07:53:27PM +0100, Oleksij Rempel wrote:
> >> On Fri, Mar 13, 2020 at 11:20:35AM -0700, Florian Fainelli wrote:
> >>>
> >>>
> >>> On 3/13/2020 11:16 AM, Oleksij Rempel wrote:
> >>>> On Fri, Mar 13, 2020 at 07:10:56PM +0100, Andrew Lunn wrote:
> >>>>>>> diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> >>>>>>> new file mode 100644
> >>>>>>> index 000000000000..42be0255512b
> >>>>>>> --- /dev/null
> >>>>>>> +++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> >>>>>>> @@ -0,0 +1,61 @@
> >>>>>>> +# SPDX-License-Identifier: GPL-2.0+
> >>>>>>> +%YAML 1.2
> >>>>>>> +---
> >>>>>>> +$id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
> >>>>>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> >>>>>>> +
> >>>>>>> +title: NXP TJA11xx PHY
> >>>>>>> +
> >>>>>>> +maintainers:
> >>>>>>> +  - Andrew Lunn <andrew@lunn.ch>
> >>>>>>> +  - Florian Fainelli <f.fainelli@gmail.com>
> >>>>>>> +  - Heiner Kallweit <hkallweit1@gmail.com>
> >>>>>>> +
> >>>>>>> +description:
> >>>>>>> +  Bindings for NXP TJA11xx automotive PHYs
> >>>>>>> +
> >>>>>>> +allOf:
> >>>>>>> +  - $ref: ethernet-phy.yaml#
> >>>>>>> +
> >>>>>>> +patternProperties:
> >>>>>>> +  "^ethernet-phy@[0-9a-f]+$":
> >>>>>>> +    type: object
> >>>>>>> +    description: |
> >>>>>>> +      Some packages have multiple PHYs. Secondary PHY should be defines as
> >>>>>>> +      subnode of the first (parent) PHY.
> >>>>>>
> >>>>>>
> >>>>>> There are QSGMII PHYs which have 4 PHYs embedded and AFAICT they are
> >>>>>> defined as 4 separate Ethernet PHY nodes and this would not be quite a
> >>>>>> big stretch to represent them that way compared to how they are.
> >>>>>>
> >>>>>> I would recommend doing the same thing and not bend the MDIO framework
> >>>>>> to support the registration of "nested" Ethernet PHY nodes.
> >>>>>
> >>>>> Hi Florian
> >>>>>
> >>>>> The issue here is the missing PHY ID in the secondary PHY. Because of
> >>>>> that, the secondary does not probe in the normal way. We need the
> >>>>> primary to be involved to some degree. It needs to register it. What
> >>>>> i'm not so clear on is if it just needs to register it, or if these
> >>>>> sub nodes are actually needed, given the current code.
> >>>>
> >>>> There are a bit more dependencies:
> >>>> - PHY0 is responsible for health monitoring. If some thing wrong, it may
> >>>>   shut down complete chip.
> >>>> - We have shared reset. It make no sense to probe PHY1 before PHY0 with
> >>>>   more controlling options will be probed
> >>>> - It is possible bat dangerous to use PHY1 without PHY0.
> >>>
> >>> probing is a software problem though. If we want to describe the PHY
> >>> package more correctly, we should be using a container node, something
> >>> like this maybe:
> >>>
> >>> phy-package {
> >>> 	compatible = "nxp,tja1102";
> >>>
> >>> 	ethernet-phy@4 {
> >>> 		reg = <4>;
> >>> 	};
> >>>
> >>> 	ethernet-phy@5 {
> >>> 		reg = <5>;
> >>> 	};
> >>> };
> >>
> >> Yes, this is almost the same as it is currently done:
> >>
> >> phy-package {
> >> 	reg = <4>;
> >>  
> >>  	ethernet-phy@5 {
> >>  		reg = <5>;
> >>  	};
> >> };
> >>
> >> Because the primary PHY0 can be autodetected by the bus scan.
> >> But I have nothing against your suggestions. Please, some one should say the
> >> last word here, how exactly it should be implemented?
> 
> It's not for me to decide, I was hoping the Device Tree maintainers
> could chime in, your current approach would certainly work although it
> feels visually awkward.

Something like this is what I'd do:

ethernet-phy@4 {
  compatible = "nxp,tja1102";
  reg = <4 5>;
};

Rob
