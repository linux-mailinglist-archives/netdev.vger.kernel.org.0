Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442A65EF99
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 01:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfGCXXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 19:23:35 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35235 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbfGCXXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 19:23:34 -0400
Received: by mail-pf1-f194.google.com with SMTP id u14so808212pfn.2
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 16:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XN3qgR1tVFK8sR9o1ybEyQRnUeXtfxfXh+O+zHL4/+Y=;
        b=NzaNPXi+YZBGhIbIgIUZaTohxouzyDY7kLRqaDb4+9gt2fecCZ8L3hIKaY4vXMfsYQ
         FxCmxwlE32iIfosrg9EOn5v5GkBgijUn24kBLYBMZN08ljM7nepXFEurCwjzALS56CR9
         U5pBPaqa6xQnuBxvVQwfk/PA1nRUA3Q34yqUo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XN3qgR1tVFK8sR9o1ybEyQRnUeXtfxfXh+O+zHL4/+Y=;
        b=RBxus6iioWw/H/cpONGJExxasoKaBWxZv1I5neOMbZ9v0olBIHA87o2enTnPabilC1
         SLTwhldeM1VKbnKRx8m2snKN99FuoEp6r6xym8ygNwa1XHicJLNu7QyL+pYKgwFgTQ1v
         0Eu3KgMhdYbTmGR1XDBA7SrA0OoWKVd21JQXaNQklDWNsCz1O97WRVhlcmYvAqQhylIW
         J9UMbLCeT4iGyxP5Ier2ImQR6UcL/Ds3TUc6mNhRbnCOkGrUF4tdu2llXlO6cuKZz4QS
         tIkGjaa1jS9bIZ2nGgH4p2dG3ekzdkDq2dPXQTlti9RP8i/23UUDNR/a7LGG3QQWJ099
         fX7Q==
X-Gm-Message-State: APjAAAW0aRQ+6w8bJaYYNaaQQqC8s4Re8X+fi0tqoCZ0JB+L+6IaOhtJ
        zX5R2ll15oA9exbMCKuRqWgosw==
X-Google-Smtp-Source: APXvYqx7unjhBypVqBgNvPTq6zAIlWKbNq6OlF0jySSP96LUGqlwwpVzJOnU2WwDUiZnU1HtSWbhLA==
X-Received: by 2002:a63:5107:: with SMTP id f7mr25033521pgb.266.1562196214038;
        Wed, 03 Jul 2019 16:23:34 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id v22sm5837535pgk.69.2019.07.03.16.23.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 16:23:33 -0700 (PDT)
Date:   Wed, 3 Jul 2019 16:23:31 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 6/7] dt-bindings: net: realtek: Add property to
 configure LED mode
Message-ID: <20190703232331.GL250418@google.com>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-6-mka@chromium.org>
 <e8fe7baf-e4e0-c713-7b93-07a3859c33c6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e8fe7baf-e4e0-c713-7b93-07a3859c33c6@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, Jul 03, 2019 at 02:37:47PM -0700, Florian Fainelli wrote:
> On 7/3/19 12:37 PM, Matthias Kaehlcke wrote:
> > The LED behavior of some Realtek PHYs is configurable. Add the
> > property 'realtek,led-modes' to specify the configuration of the
> > LEDs.
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > Changes in v2:
> > - patch added to the series
> > ---
> >  .../devicetree/bindings/net/realtek.txt         |  9 +++++++++
> >  include/dt-bindings/net/realtek.h               | 17 +++++++++++++++++
> >  2 files changed, 26 insertions(+)
> >  create mode 100644 include/dt-bindings/net/realtek.h
> > 
> > diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
> > index 71d386c78269..40b0d6f9ee21 100644
> > --- a/Documentation/devicetree/bindings/net/realtek.txt
> > +++ b/Documentation/devicetree/bindings/net/realtek.txt
> > @@ -9,6 +9,12 @@ Optional properties:
> >  
> >  	SSC is only available on some Realtek PHYs (e.g. RTL8211E).
> >  
> > +- realtek,led-modes: LED mode configuration.
> > +
> > +	A 0..3 element vector, with each element configuring the operating
> > +	mode of an LED. Omitted LEDs are turned off. Allowed values are
> > +	defined in "include/dt-bindings/net/realtek.h".
> 
> This should probably be made more general and we should define LED modes
> that makes sense regardless of the PHY device, introduce a set of
> generic functions for validating and then add new function pointer for
> setting the LED configuration to the PHY driver. This would allow to be
> more future proof where each PHY driver could expose standard LEDs class
> devices to user-space, and it would also allow facilities like: ethtool
> -p to plug into that.
> 
> Right now, each driver invents its own way of configuring LEDs, that
> does not scale, and there is not really a good reason for that other
> than reviewing drivers in isolation and therefore making it harder to
> extract the commonality. Yes, I realize that since you are the latest
> person submitting something in that area, you are being selected :)

I see the merit of your proposal to come up with a generic mechanism
to configure Ethernet LEDs, however I can't justify spending much of
my work time on this. If it is deemed useful I'm happy to send another
version of the current patchset that addresses the reviewer's comments,
but if the implementation of a generic LED configuration interface is
a requirement I will have to abandon at least the LED configuration
part of this series.
