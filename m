Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3D7B5A350
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfF1SR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbfF1SR3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 14:17:29 -0400
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E2D6216FD;
        Fri, 28 Jun 2019 18:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561745848;
        bh=WEewm/I8ZtGtlarCL0Kn+22mM26dscf3xRKcIsgTilY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KdZqIh+/dbl2KM/DglLXMr8RRiF37wmqzDnSBG0OOrZm88FHZLWeqoZJTAXBew0vE
         RCjqZ8i+TzSFRbw7sKBA+6RRhbA97gu7+V4Kjj7mLzdGTmlYNbqAlR4UNizwRRdYH1
         NqBARTsG3cRq5LJPstp9NwRsswNJMgDrC0qinUmI=
Received: by mail-qk1-f177.google.com with SMTP id p144so5589028qke.11;
        Fri, 28 Jun 2019 11:17:28 -0700 (PDT)
X-Gm-Message-State: APjAAAVdwscWbG1WgU0V0iDyRkMLI8gLMQ0AvwuMuyzhHSyh4TaAmpFF
        XmwY31oZZ46Aj+k8QOtKg9XB30gMUX9ZH3Tytw==
X-Google-Smtp-Source: APXvYqy3MzvCjB+KLt1OVmFltrR2WiZ5cZ+Oh3r7gZHAGRF19j+S/sbA4Erqc/j0sd6VdXSFeTDa8FH7AclbdRhxYJg=
X-Received: by 2002:a05:620a:1447:: with SMTP id i7mr10092989qkl.254.1561745847189;
 Fri, 28 Jun 2019 11:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.e80da8845680a45c2e07d5f17280fdba84555b8a.1561649505.git-series.maxime.ripard@bootlin.com>
 <e99ff7377a0d3d140cf62200fd9d62c108dac24e.1561649505.git-series.maxime.ripard@bootlin.com>
 <CAL_JsqKQoj6x-8cMxp2PFQLcu93aitGO2wALDYaH2h72cPSyfg@mail.gmail.com>
 <20190627155708.myxychzngc3trxhc@flea> <CAL_JsqLhUP62vP=RY8Bn_0X92hFphbk_gLqi4K48us56Gxw7tA@mail.gmail.com>
 <20190628134553.l445r5idtejwlryl@flea>
In-Reply-To: <20190628134553.l445r5idtejwlryl@flea>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 28 Jun 2019 12:17:15 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+OCN6Mbcc0ztheVc7OS2SF12h-=t_7ZGrcqj93x4m08Q@mail.gmail.com>
Message-ID: <CAL_Jsq+OCN6Mbcc0ztheVc7OS2SF12h-=t_7ZGrcqj93x4m08Q@mail.gmail.com>
Subject: Re: [PATCH v4 03/13] dt-bindings: net: Add a YAML schemas for the
 generic MDIO options
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 7:46 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> On Thu, Jun 27, 2019 at 10:06:57AM -0600, Rob Herring wrote:
> > On Thu, Jun 27, 2019 at 9:57 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > > > > +
> > > > > +        reset-gpios = <&gpio2 5 1>;
> > > > > +        reset-delay-us = <2>;
> > > > > +
> > > > > +        ethphy0: ethernet-phy@1 {
> > > > > +            reg = <1>;
> > > >
> > > > Need a child node schema to validate the unit-address and reg property.
> > >
> > > This should be already covered by the ethernet-phy.yaml schemas
> > > earlier in this series.
> >
> > Partially, yes.
> >
> > > Were you expecting something else?
> >
> > That would not prevent having a child node such as 'foo {};'  or
> > 'foo@bad {};'. It would also not check valid nodes named something
> > other than 'ethernet-phy'.
>
> Right, but listing the nodes won't either, since we can't enable
> additionalProperties in that schema. So any node that wouldn't match
> ethernet-phy@.* wouldn't be validated, but wouldn't generate a warning
> either.

Perhaps I wasn't clear, but it was missing or incorrect 'reg' property
and unit-address format checks that I was thinking about. Just like we
have for SPI.

Rob
