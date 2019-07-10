Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3312064A2D
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 17:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfGJPzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 11:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbfGJPzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 11:55:25 -0400
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 883F5208C4;
        Wed, 10 Jul 2019 15:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562774124;
        bh=qCL+I0bGVObTidwDwHaXu9MuDIyEKZp4oVrDcqJBmnE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BqTAEyBoL49l6a9wlkoVxEC2QkECtLLQgg0p2FkHMetUlluZXPDwPsE2QW9d1TBqF
         sF7c7Qnrz+MMhfdoGaZLj+erkj3gN7i8HX4bU4Ek6q9xWf40Jbjb4CUhv5T1mJDzHW
         I1M7GeJeC4asrRo73RWTJBWK9C865hwA3GCjVKjI=
Received: by mail-qk1-f178.google.com with SMTP id s145so2274324qke.7;
        Wed, 10 Jul 2019 08:55:24 -0700 (PDT)
X-Gm-Message-State: APjAAAU/b3nCGhfig6W4zYB/E8YdFzg11ZSxE6jXDU5DZ3TSFpLsaTPT
        kzFBAtLKAmhPZp8NX3YGVGw3Wg+51YfJH4b1ZA==
X-Google-Smtp-Source: APXvYqwKfK396n6gL35FIM1KH5iVePKtER3VtkXQjd6pS6o1UtucpUKv3qUu8+77/xQX/zm28J4oPAu1ze3k+toJGEU=
X-Received: by 2002:a37:a48e:: with SMTP id n136mr24536697qke.223.1562774123770;
 Wed, 10 Jul 2019 08:55:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190703193724.246854-1-mka@chromium.org> <20190703193724.246854-6-mka@chromium.org>
 <e8fe7baf-e4e0-c713-7b93-07a3859c33c6@gmail.com> <20190703232331.GL250418@google.com>
In-Reply-To: <20190703232331.GL250418@google.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 10 Jul 2019 09:55:12 -0600
X-Gmail-Original-Message-ID: <CAL_JsqL_AU+JV0c2mNbXiPh2pvfYbPbLV-2PHHX0hC3vUH4QWg@mail.gmail.com>
Message-ID: <CAL_JsqL_AU+JV0c2mNbXiPh2pvfYbPbLV-2PHHX0hC3vUH4QWg@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] dt-bindings: net: realtek: Add property to
 configure LED mode
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 5:23 PM Matthias Kaehlcke <mka@chromium.org> wrote:
>
> Hi Florian,
>
> On Wed, Jul 03, 2019 at 02:37:47PM -0700, Florian Fainelli wrote:
> > On 7/3/19 12:37 PM, Matthias Kaehlcke wrote:
> > > The LED behavior of some Realtek PHYs is configurable. Add the
> > > property 'realtek,led-modes' to specify the configuration of the
> > > LEDs.
> > >
> > > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > > ---
> > > Changes in v2:
> > > - patch added to the series
> > > ---
> > >  .../devicetree/bindings/net/realtek.txt         |  9 +++++++++
> > >  include/dt-bindings/net/realtek.h               | 17 +++++++++++++++++
> > >  2 files changed, 26 insertions(+)
> > >  create mode 100644 include/dt-bindings/net/realtek.h
> > >
> > > diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
> > > index 71d386c78269..40b0d6f9ee21 100644
> > > --- a/Documentation/devicetree/bindings/net/realtek.txt
> > > +++ b/Documentation/devicetree/bindings/net/realtek.txt
> > > @@ -9,6 +9,12 @@ Optional properties:
> > >
> > >     SSC is only available on some Realtek PHYs (e.g. RTL8211E).
> > >
> > > +- realtek,led-modes: LED mode configuration.
> > > +
> > > +   A 0..3 element vector, with each element configuring the operating
> > > +   mode of an LED. Omitted LEDs are turned off. Allowed values are
> > > +   defined in "include/dt-bindings/net/realtek.h".
> >
> > This should probably be made more general and we should define LED modes
> > that makes sense regardless of the PHY device, introduce a set of
> > generic functions for validating and then add new function pointer for
> > setting the LED configuration to the PHY driver. This would allow to be
> > more future proof where each PHY driver could expose standard LEDs class
> > devices to user-space, and it would also allow facilities like: ethtool
> > -p to plug into that.
> >
> > Right now, each driver invents its own way of configuring LEDs, that
> > does not scale, and there is not really a good reason for that other
> > than reviewing drivers in isolation and therefore making it harder to
> > extract the commonality. Yes, I realize that since you are the latest
> > person submitting something in that area, you are being selected :)

I agree.

> I see the merit of your proposal to come up with a generic mechanism
> to configure Ethernet LEDs, however I can't justify spending much of
> my work time on this. If it is deemed useful I'm happy to send another
> version of the current patchset that addresses the reviewer's comments,
> but if the implementation of a generic LED configuration interface is
> a requirement I will have to abandon at least the LED configuration
> part of this series.

Can you at least define a common binding for this. Maybe that's just
removing 'realtek'. While the kernel side can evolve to a common
infrastructure, the DT bindings can't.

Rob
