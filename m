Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCD080028
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 20:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406718AbfHBS1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 14:27:41 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46448 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405941AbfHBS1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 14:27:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id k189so17421004pgk.13
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 11:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iyciDfeLefufud92XPtBIUcF3M+xfQxtot7qPaY4KjU=;
        b=YMoFTbKPBoZXwxCuEwYjWgzntl3tH9LcT7GN3ZqIIS1GgX+sZ87yWZaE7/AqB+2Z8Z
         pCHK1MVBWhDpKa5X633FwA7Q4Rqowqa2XCBlN2JXFgYkPgrYNdjvuo4ex0zXKi5kFhuF
         JKJEAy4Fr9o7zIxYeE6ObA/pOTC00km6k1tHY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iyciDfeLefufud92XPtBIUcF3M+xfQxtot7qPaY4KjU=;
        b=Qz5DBuz6/jCPvvY7CWHf17HvFzggzt6GUNcJyNEfVFZXcOSSOEWOD2QkSdpeLRaV+D
         6Vd/PgzroWfaEOf8IJP3Bb54UN993cpF7R1x9OcGjxQBZ6YiMLWUhavN5i9zhTxPgOxD
         /WSn5RhW2b6sP+aTr7DLvVGdx5oNZgcC+pPhbcyDx8Ro/qDXRnBXgTB0OrzX4bTcaVSY
         W5M5mp6fxS+Joy4Xe7aJ20vx2j+OpD7dkB5jV2xpN5BvQQqrcapN1kgcw4qHELRcqyW0
         jxseRI4yrTjbMYPbOjrL+OEncSpYg+pDm9xvkCFoViS+1s8ZCju2DYekGSZGWBSElq0w
         L7/w==
X-Gm-Message-State: APjAAAWVXJlw0q5xHmiinfvjGfFB2LqliLs4ua2swWD4b9IaLLUMn4eQ
        NEOapRr3ZRWGOCmM/19ijj4gpA==
X-Google-Smtp-Source: APXvYqzgiY/OITDZnfouf3W8+91k7jkvNExx1DHHP9P0YLXPGjyTAYOaPiqzpNyX6alwgFIQHXRQig==
X-Received: by 2002:a63:ff65:: with SMTP id s37mr83163171pgk.102.1564770460233;
        Fri, 02 Aug 2019 11:27:40 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id p23sm81442697pfn.10.2019.08.02.11.27.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 11:27:39 -0700 (PDT)
Date:   Fri, 2 Aug 2019 11:27:37 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add subnode for LED
 configuration
Message-ID: <20190802182737.GL250418@google.com>
References: <20190801190759.28201-1-mka@chromium.org>
 <20190801190759.28201-2-mka@chromium.org>
 <20190802165755.GM2099@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190802165755.GM2099@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 06:57:55PM +0200, Andrew Lunn wrote:
> On Thu, Aug 01, 2019 at 12:07:56PM -0700, Matthias Kaehlcke wrote:
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
> > Changes in v4:
> > - patch added to the series
> > ---
> >  .../devicetree/bindings/net/ethernet-phy.yaml | 47 +++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > index f70f18ff821f..81c5aacc89a5 100644
> > --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > @@ -153,6 +153,38 @@ properties:
> >        Delay after the reset was deasserted in microseconds. If
> >        this property is missing the delay will be skipped.
> >  
> > +patternProperties:
> > +  "^leds$":
> > +    type: object
> > +    description:
> > +      Subnode with configuration of the PHY LEDs.
> > +
> > +    patternProperties:
> > +      "^led@[0-9]+$":
> > +        type: object
> > +        description:
> > +          Subnode with the configuration of a single PHY LED.
> > +
> > +    properties:
> > +      reg:
> > +        description:
> > +          The ID number of the LED, typically corresponds to a hardware ID.
> > +        $ref: "/schemas/types.yaml#/definitions/uint32"
> > +
> > +      linux,default-trigger:
> > +        description:
> > +          This parameter, if present, is a string specifying the trigger
> > +          assigned to the LED. Supported triggers are:
> > +            "phy_link_10m_active" - LED will be on when a 10Mb/s link is active
> > +            "phy_link_100m_active" - LED will be on when a 100Mb/s link is active
> > +            "phy_link_1g_active" - LED will be on when a 1Gb/s link is active
> > +            "phy_link_10g_active" - LED will be on when a 10Gb/s link is active
> > +            "phy_activity" - LED will blink when data is received or transmitted
> 
> Matthias
> 
> We should think a bit more about these names.
> 
> I can see in future needing 1G link, but it blinks off when there is
> active traffic? So phy_link_1g_active could be confusing, and very similar to
> phy_link_1g_activity?

agreed, the 'active' vs' 'activity' can be confusing, let's avoid that.

> So maybe 

> > +            "phy_link_10m" - LED will be solid on when a 10Mb/s link is active
> > +            "phy_link_100m" - LED will be solid on when a 100Mb/s link is active
> > +            "phy_link_1g" - LED will be solid on when a 1Gb/s link is active
> 
> etc.
>
> And then in the future we can have
> 
>                "phy_link_1g_activity' - LED will be on when 1Gbp/s
>                                         link is active and blink off
>                                         with activity.

sounds good to me

> What other use cases do we have? I don't want to support everything,
> but we should be able to represent the most common modes without the
> names getting too confusing.

Initially I planned to support to configure a LED to be solid for
multiple link speeds, however that could become a bit messy with the
string based triggers, unless we limit the possible combinations. My
expertise in network land is limited, so I'm not sure if that's an
important/realistic use case.
