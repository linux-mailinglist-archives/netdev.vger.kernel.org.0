Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7C3586AB
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfF0QHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbfF0QHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 12:07:11 -0400
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC1CD2133F;
        Thu, 27 Jun 2019 16:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561651630;
        bh=qnjDcvg2vr1/aDZRgXt8AUsw/e1VEUmL66zR+wNUqLQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uStUCHmDp1p57SsCyxgo6iBQf6wFT3Wg8FvrqKIm4sUNjPPsiTnd7s2M1ezSNi2qX
         B3uScACkb0zwXtXPDWT9DDEphSX1XeoF187U8BaaTH4o6l/QNBRGq5LmC+oSiUxtzY
         tNfWR3V7PKLR3/v5yYRcxkeOlUudJj+of7MJ5VJo=
Received: by mail-qt1-f174.google.com with SMTP id a15so3016472qtn.7;
        Thu, 27 Jun 2019 09:07:09 -0700 (PDT)
X-Gm-Message-State: APjAAAWwHPv2O7LLgKHShMUlaiZ0zEa3H+T375MH7TmHvKG5E19b4Q/d
        Q2XULjGvGk6j32d91nCgNHRAdxvVGI8TXQT+MA==
X-Google-Smtp-Source: APXvYqzeFDJzuV1gZ6S+zyrzfaa49Md1sFroJG0gDvbc/4XW9ZWqmmLiaHGfS1c2APb0JFORnUFqOnpCDDI8rp/vwfM=
X-Received: by 2002:a0c:b627:: with SMTP id f39mr4191770qve.72.1561651629161;
 Thu, 27 Jun 2019 09:07:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.e80da8845680a45c2e07d5f17280fdba84555b8a.1561649505.git-series.maxime.ripard@bootlin.com>
 <e99ff7377a0d3d140cf62200fd9d62c108dac24e.1561649505.git-series.maxime.ripard@bootlin.com>
 <CAL_JsqKQoj6x-8cMxp2PFQLcu93aitGO2wALDYaH2h72cPSyfg@mail.gmail.com> <20190627155708.myxychzngc3trxhc@flea>
In-Reply-To: <20190627155708.myxychzngc3trxhc@flea>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 27 Jun 2019 10:06:57 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLhUP62vP=RY8Bn_0X92hFphbk_gLqi4K48us56Gxw7tA@mail.gmail.com>
Message-ID: <CAL_JsqLhUP62vP=RY8Bn_0X92hFphbk_gLqi4K48us56Gxw7tA@mail.gmail.com>
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

On Thu, Jun 27, 2019 at 9:57 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> Hi Rob,
>
> On Thu, Jun 27, 2019 at 09:48:06AM -0600, Rob Herring wrote:
> > On Thu, Jun 27, 2019 at 9:32 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > >
> > > The MDIO buses have a number of available device tree properties that can
> > > be used in their device tree node. Add a YAML schemas for those.
> > >
> > > Suggested-by: Andrew Lunn <andrew@lunn.ch>
> > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > ---
> > >  Documentation/devicetree/bindings/net/mdio.txt  | 38 +-------------
> > >  Documentation/devicetree/bindings/net/mdio.yaml | 51 ++++++++++++++++++-
> > >  2 files changed, 52 insertions(+), 37 deletions(-)
> > >  create mode 100644 Documentation/devicetree/bindings/net/mdio.yaml
> >
> > Reviewed-by: Rob Herring <robh@kernel.org>
> >
> > However, some comments for a follow-up...
> >
> > > diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
> > > new file mode 100644
> > > index 000000000000..b8fa8251c4bc
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/mdio.yaml
> > > @@ -0,0 +1,51 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/net/mdio.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: MDIO Bus Generic Binding
> > > +
> > > +maintainers:
> > > +  - Andrew Lunn <andrew@lunn.ch>
> > > +  - Florian Fainelli <f.fainelli@gmail.com>
> > > +  - Heiner Kallweit <hkallweit1@gmail.com>
> > > +
> > > +description:
> > > +  These are generic properties that can apply to any MDIO bus. Any
> > > +  MDIO bus must have a list of child nodes, one per device on the
> > > +  bus. These should follow the generic ethernet-phy.yaml document, or
> > > +  a device specific binding document.
> > > +
> > > +properties:
> > > +  reset-gpios:
> > > +    maxItems: 1
> > > +    description:
> > > +      The phandle and specifier for the GPIO that controls the RESET
> > > +      lines of all PHYs on that MDIO bus.
> > > +
> > > +  reset-delay-us:
> > > +    description:
> > > +      RESET pulse width in microseconds. It applies to all PHY devices
> > > +      and must therefore be appropriately determined based on all PHY
> > > +      requirements (maximum value of all per-PHY RESET pulse widths).
> > > +
> > > +examples:
> > > +  - |
> > > +    davinci_mdio: mdio@5c030000 {
> >
> > Can we enforce nodename to be mdio? That may not work for muxes.
> > You'll probably have to implement it and see.
>
> Ok, I'll send a follow-up patch for this.
>
> > > +        compatible = "ti,davinci_mdio";
> > > +        reg = <0x5c030000 0x1000>;
> > > +        #address-cells = <1>;
> > > +        #size-cells = <0>;
> >
> > These 2 should have a schema.
>
> Indeed, I'll do it for that too.
>
> > > +
> > > +        reset-gpios = <&gpio2 5 1>;
> > > +        reset-delay-us = <2>;
> > > +
> > > +        ethphy0: ethernet-phy@1 {
> > > +            reg = <1>;
> >
> > Need a child node schema to validate the unit-address and reg property.
>
> This should be already covered by the ethernet-phy.yaml schemas
> earlier in this series.

Partially, yes.

> Were you expecting something else?

That would not prevent having a child node such as 'foo {};'  or
'foo@bad {};'. It would also not check valid nodes named something
other than 'ethernet-phy'.

Rob
