Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AAD67414
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfGLRUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:20:52 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34647 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfGLRUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 13:20:51 -0400
Received: by mail-pg1-f193.google.com with SMTP id p10so4825587pgn.1
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fDCFU21FX7iM5hltBSKXQsZERfbhCks0C3SkuZDn2cE=;
        b=hs/4tn0aPaP+ck9KP/2MF+L9GRraPJWDLdGluAhn9MyOgAVPRH/7GePpo5Hy1x1XOc
         cdVpTXeDtPXaxlVaHRFSawAMbTbMX5BJPysseSxoJPleGw+/jFCT9gWK6HCjj4wOeGw2
         lSjyPogelCri9o41NPGUecEdHWIKz78j5bYNQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fDCFU21FX7iM5hltBSKXQsZERfbhCks0C3SkuZDn2cE=;
        b=oD+m4Blh/BRNHMfJCOvXM1iQlPv1h6Iu7MEZpnh+lK9Obaiu4rZMyKlyflYZIsljfY
         ltGLBcgfP+o6suXIhdkZRMM2Ff8efgqaL32Dwp0r8WtVZYAzL0IWY/VApQG8Prx3J3fL
         61qEXE02OUzzG78411u/MM19u/d+biN4+3Fg2Wbqy9HM5U5KhJuJBrQm/DsO83SKyiUz
         Ohpr7IlyytmBs7xADThVTuRTK46TSOVQgfsjxXbYfgRwr6WcnbYK3d0VqS4e4GbN63pB
         IRLXhO9yXpVdt5RB4813V+MyJEKomyoXE/Jlya1NfowT3M7fp0nKzHg0CTNk3T7ptvdk
         IVaA==
X-Gm-Message-State: APjAAAXbMQvWNsnESHLE75JM+twiCtLEqYjUr0JqaGhb+kpvM96UcHz/
        PmHsxhJnSorsJZyobFSd6N8BFw==
X-Google-Smtp-Source: APXvYqzRDHVjZQZvO/SrwW+PdfFvVs8Qylpul2+xzXOpUfwsEv0jARgp9zmgNN1kX2jftitaJA433Q==
X-Received: by 2002:a63:6b46:: with SMTP id g67mr12122087pgc.45.1562952050999;
        Fri, 12 Jul 2019 10:20:50 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id g9sm7275782pgs.78.2019.07.12.10.20.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 10:20:49 -0700 (PDT)
Date:   Fri, 12 Jul 2019 10:20:47 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 6/7] dt-bindings: net: realtek: Add property to
 configure LED mode
Message-ID: <20190712172047.GQ250418@google.com>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-6-mka@chromium.org>
 <e8fe7baf-e4e0-c713-7b93-07a3859c33c6@gmail.com>
 <20190703232331.GL250418@google.com>
 <CAL_JsqL_AU+JV0c2mNbXiPh2pvfYbPbLV-2PHHX0hC3vUH4QWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL_JsqL_AU+JV0c2mNbXiPh2pvfYbPbLV-2PHHX0hC3vUH4QWg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 09:55:12AM -0600, Rob Herring wrote:
> On Wed, Jul 3, 2019 at 5:23 PM Matthias Kaehlcke <mka@chromium.org> wrote:
> >
> > Hi Florian,
> >
> > On Wed, Jul 03, 2019 at 02:37:47PM -0700, Florian Fainelli wrote:
> > > On 7/3/19 12:37 PM, Matthias Kaehlcke wrote:
> > > > The LED behavior of some Realtek PHYs is configurable. Add the
> > > > property 'realtek,led-modes' to specify the configuration of the
> > > > LEDs.
> > > >
> > > > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > > > ---
> > > > Changes in v2:
> > > > - patch added to the series
> > > > ---
> > > >  .../devicetree/bindings/net/realtek.txt         |  9 +++++++++
> > > >  include/dt-bindings/net/realtek.h               | 17 +++++++++++++++++
> > > >  2 files changed, 26 insertions(+)
> > > >  create mode 100644 include/dt-bindings/net/realtek.h
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
> > > > index 71d386c78269..40b0d6f9ee21 100644
> > > > --- a/Documentation/devicetree/bindings/net/realtek.txt
> > > > +++ b/Documentation/devicetree/bindings/net/realtek.txt
> > > > @@ -9,6 +9,12 @@ Optional properties:
> > > >
> > > >     SSC is only available on some Realtek PHYs (e.g. RTL8211E).
> > > >
> > > > +- realtek,led-modes: LED mode configuration.
> > > > +
> > > > +   A 0..3 element vector, with each element configuring the operating
> > > > +   mode of an LED. Omitted LEDs are turned off. Allowed values are
> > > > +   defined in "include/dt-bindings/net/realtek.h".
> > >
> > > This should probably be made more general and we should define LED modes
> > > that makes sense regardless of the PHY device, introduce a set of
> > > generic functions for validating and then add new function pointer for
> > > setting the LED configuration to the PHY driver. This would allow to be
> > > more future proof where each PHY driver could expose standard LEDs class
> > > devices to user-space, and it would also allow facilities like: ethtool
> > > -p to plug into that.
> > >
> > > Right now, each driver invents its own way of configuring LEDs, that
> > > does not scale, and there is not really a good reason for that other
> > > than reviewing drivers in isolation and therefore making it harder to
> > > extract the commonality. Yes, I realize that since you are the latest
> > > person submitting something in that area, you are being selected :)
> 
> I agree.
> 
> > I see the merit of your proposal to come up with a generic mechanism
> > to configure Ethernet LEDs, however I can't justify spending much of
> > my work time on this. If it is deemed useful I'm happy to send another
> > version of the current patchset that addresses the reviewer's comments,
> > but if the implementation of a generic LED configuration interface is
> > a requirement I will have to abandon at least the LED configuration
> > part of this series.
> 
> Can you at least define a common binding for this. Maybe that's just
> removing 'realtek'. While the kernel side can evolve to a common
> infrastructure, the DT bindings can't.

Defining a common binding sounds good to me, I will follow up on
Florian's reply to this.
