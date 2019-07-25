Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4A975646
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 19:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbfGYRxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 13:53:08 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38185 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfGYRxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 13:53:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so23129570pfn.5
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 10:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x+3BFyzp7D/vPI4eYVBwW0OZVm0O0+MUXJZpdTJS7yk=;
        b=ciww8qYZU3JjNb3Aq1dK4VO+0r3eFfGv8fv2UUIvYZfMGK/O9pj4NkBvbJ4pIGLiHT
         Nhlo0mKTPWNZP0AJC2tLZR5vrGSYghGKPaD6s92SU67gaD0wGJ/fjnQmlsDKoInfmwFf
         s4+5ZPv7SkM86xKq4fpaeq/pW2npHzZ/GWtag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x+3BFyzp7D/vPI4eYVBwW0OZVm0O0+MUXJZpdTJS7yk=;
        b=FS5Z5jXKTT2WU1cbnXvBjZYvFHQPQV9u7td9cnlDqUGeVDOKF4KAjRVomSGN5K3RK0
         OP6wxJZzOfNDugjjmSHmrY7Y3nk1drg3XEb7iiLTEKd9GX3W7EHbtq6FCzQJ+fvHG5Qt
         utaEnxvdNTB4bQgPslxt6jFHmIncY37uLVn3Un+yRADBIBjoxttlyiMR5i6e3wMdrhP/
         1siJyxuegis7RPU2JBfeNl8vxYjPn4eeLVj4N50Pa2n4sXiQyKlQkfqzIxEHYXy0PXPP
         vyImlgjITsGYGX9S6rJADDXQ/xA5I/m5RNB6oTzCbsCao3GrnE2w1bPeZ7OM6r03Kazo
         uVcg==
X-Gm-Message-State: APjAAAUgWHWz6v++RylhqhqmkgKaTG7QljGh9Dz2TDMeUIy0UNrWm6w4
        vRA3OWJ/cgcRIftAiWi/R8MtXw==
X-Google-Smtp-Source: APXvYqzUxAOwJ6wOw4ygsDnCgRPH1p4MKEK+ioEao6peJecQrhFdUdXjMC+z7alvRtjH+qI16qh7/g==
X-Received: by 2002:a62:87c8:: with SMTP id i191mr17939790pfe.133.1564077187553;
        Thu, 25 Jul 2019 10:53:07 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id s43sm64364749pjb.10.2019.07.25.10.53.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 10:53:06 -0700 (PDT)
Date:   Thu, 25 Jul 2019 10:52:58 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [RFC] dt-bindings: net: phy: Add subnode for LED configuration
Message-ID: <20190725175258.GE250418@google.com>
References: <20190722223741.113347-1-mka@chromium.org>
 <20190724180430.GB28488@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190724180430.GB28488@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Jul 24, 2019 at 08:04:30PM +0200, Andrew Lunn wrote:
> On Mon, Jul 22, 2019 at 03:37:41PM -0700, Matthias Kaehlcke wrote:
> > The LED behavior of some Ethernet PHYs is configurable. Add an
> > optional 'leds' subnode with a child node for each LED to be
> > configured. The binding aims to be compatible with the common
> > LED binding (see devicetree/bindings/leds/common.txt).
> > 
> > A LED can be configured to be 'on' when a link with a certain speed
> > is active, or to blink on RX/TX activity. For the configuration to
> > be effective it needs to be supported by the hardware and the
> > corresponding PHY driver.
> > 
> > Suggested-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > This RFC is a follow up of the discussion on "[PATCH v2 6/7]
> > dt-bindings: net: realtek: Add property to configure LED mode"
> > (https://lore.kernel.org/patchwork/patch/1097185/).
> > 
> > For now posting as RFC to get a basic agreement on the bindings
> > before proceding with the implementation in phylib and a specific
> > driver.
> > ---
> >  Documentation/devicetree/bindings/net/phy.txt | 33 +++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
> > index 9b9e5b1765dd..ad495d3abbbb 100644
> > --- a/Documentation/devicetree/bindings/net/phy.txt
> > +++ b/Documentation/devicetree/bindings/net/phy.txt
> > @@ -46,6 +46,25 @@ Optional Properties:
> >    Mark the corresponding energy efficient ethernet mode as broken and
> >    request the ethernet to stop advertising it.
> >  
> > +- leds: A sub-node which is a container of only LED nodes. Each child
> > +    node represents a PHY LED.
> > +
> > +  Required properties for LED child nodes:
> > +  - reg: The ID number of the LED, typically corresponds to a hardware ID.
> > +
> > +  Optional properties for child nodes:
> > +  - label: The label for this LED. If omitted, the label is taken from the node
> > +    name (excluding the unit address). It has to uniquely identify a device,
> > +    i.e. no other LED class device can be assigned the same label.
> 
> Hi Matthias
> 
> I've thought about label a bit more. 
> 
> > +			label = "ethphy0:left:green";
> 
> We need to be careful with names here. systemd etc renames
> interfaces. ethphy0 could in fact be connected to enp3s0, or eth0
> might get renamed to eth1, etc. So i think we should avoid things like
> ethphy0.

Agreed, this could be problematic.

> Also, i'm not sure we actually need a label, at least not to
> start with.Do we have any way to expose it to the user?

As of now I don't plan to expose the label to userspace by the PHY
driver/framework itself.

From my side we can omit the label for now and add it later if needed.

> If we do ever make it part of the generic LED framework, we can then
> use the label. At that point, i would probably combine the label with
> the interface name in a dynamic way to avoid issues like this.

Sounds good.

Thanks

Matthias
