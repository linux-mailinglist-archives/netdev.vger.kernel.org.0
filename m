Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4212D4C282
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 22:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfFSUo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 16:44:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfFSUo2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 16:44:28 -0400
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB8142177E;
        Wed, 19 Jun 2019 20:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560977066;
        bh=PtdbT4+WZVrSzw4byKsl98ZDeoGvcEoZe9NmCjzp7NY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SmxtmjKiyfEWKKyjPAThNkWlA5SttyK01pMv/kTD8l61XVCe/7BjNti98SwgjiM/T
         Q/ahTcG4e9SA1rQsFe1ZB5NVqF2LhqmjCO1o/p9OPoT0RoY5z/E168ZjUBv83d197K
         Ta3vGJjMlOIct4TbSa/GiCtdVq8NU897XITaTlQ4=
Received: by mail-qt1-f174.google.com with SMTP id y57so719523qtk.4;
        Wed, 19 Jun 2019 13:44:26 -0700 (PDT)
X-Gm-Message-State: APjAAAWIeCtW76D5IbAq0mpiKEUtNegXNfabI339J5hwdn9MjLSxtjW4
        /IKuRmVA+CVnBUE3U6eba0FOrm8CuOPHvEkzrw==
X-Google-Smtp-Source: APXvYqyVAwxgOJDLFwnKUkBgoRpv1RMyh0FtU2bURQqffQhs//0pjSXX6+r6qT6fEnddczKAAfSd98UZabnH3BaOarM=
X-Received: by 2002:ac8:3908:: with SMTP id s8mr106885352qtb.224.1560977065877;
 Wed, 19 Jun 2019 13:44:25 -0700 (PDT)
MIME-Version: 1.0
References: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
 <e7c13fc3c4e287df6292dbee27ae1caeca0c06c4.1560937626.git-series.maxime.ripard@bootlin.com>
 <CAL_Jsq+A+jspyCpu9USL6FQ9y5qL_yqYS=DTE=aM5YzyeZwd0w@mail.gmail.com>
In-Reply-To: <CAL_Jsq+A+jspyCpu9USL6FQ9y5qL_yqYS=DTE=aM5YzyeZwd0w@mail.gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 19 Jun 2019 14:44:13 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLUDKi8jcJ=eZOAR9-ECX0bo9F8+d59sokWGOJzph_q7w@mail.gmail.com>
Message-ID: <CAL_JsqLUDKi8jcJ=eZOAR9-ECX0bo9F8+d59sokWGOJzph_q7w@mail.gmail.com>
Subject: Re: [PATCH v3 06/16] dt-bindings: net: sun4i-emac: Convert the
 binding to a schemas
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

On Wed, Jun 19, 2019 at 8:46 AM Rob Herring <robh+dt@kernel.org> wrote:
>
> On Wed, Jun 19, 2019 at 3:48 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> >
> > Switch our Allwinner A10 EMAC controller binding to a YAML schema to enable
> > the DT validation.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> >
> > ---
> >
> > Changes from v2:
> >   - Switch from the deprecated phy property to phy-handle
> > ---
> >  Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt      | 19 -------------------
> >  2 files changed, 55 insertions(+), 19 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml
> >  delete mode 100644 Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt
> >
> > diff --git a/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml
> > new file mode 100644
> > index 000000000000..2ff9e605cd26
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml
> > @@ -0,0 +1,55 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/allwinner,sun4i-a10-emac.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Allwinner A10 EMAC Ethernet Controller Device Tree Bindings
> > +
> > +allOf:
> > +  - $ref: "ethernet-controller.yaml#"
> > +
> > +maintainers:
> > +  - Chen-Yu Tsai <wens@csie.org>
> > +  - Maxime Ripard <maxime.ripard@bootlin.com>
> > +
> > +properties:
> > +  compatible:
> > +    const: allwinner,sun4i-a10-emac
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  clocks:
> > +    maxItems: 1
> > +
> > +  allwinner,sram:
> > +    description: Phandle to the device SRAM
> > +    $ref: /schemas/types.yaml#/definitions/phandle-array
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +  - clocks
> > +  - phy-handle
>
> Doesn't this throw an error if not listed in properties?

NM, it doesn't.

Reviewed-by: Rob Herring <robh@kernel.org>

Rob
