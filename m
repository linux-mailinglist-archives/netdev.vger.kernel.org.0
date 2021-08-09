Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C233E4142
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 09:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhHIH7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 03:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbhHIH7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 03:59:40 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32B1C061796;
        Mon,  9 Aug 2021 00:59:17 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id az7so17440822qkb.5;
        Mon, 09 Aug 2021 00:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yZGwaoW+74yOYe7AWTee01O7ZajaTQrxGSp7Oi3hbfk=;
        b=Sd9ib6YPdjx7zYxuYPXDWNAWapxYFrhQ7GaLVqFkwbgYz1yKsgeDeAhpfV7DRE12wQ
         FC0kN9mfn8J+PvgwvEeNNzmE8o8o01NO8shIaQPc7YiVnrvH3xNqB8MLlLqEUOFGgkyG
         MJU07wM1byXc05jYW6kjKbSQt4IlqWhdisib0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yZGwaoW+74yOYe7AWTee01O7ZajaTQrxGSp7Oi3hbfk=;
        b=PFcwshiF1pKaL1blPQwV1fpABIVwZcrVNURVNNeAX8o4+h1X1hih5dVFtPaEvPhXgg
         gelLj6vlEBvBSB2PbJHPhPhZ/DIa/PHPT9JgHo9niTkP9UcjMeTotX+NFA/i9lU93cGx
         TvqvDE7DDgWfwo0FKbj8L7VPspPYlz2UmfwGyhLV43Yb7mk7JAzcv6xTz5Eoi+gaHJZR
         d6AF6V3YcUCxJ39OlTIWKnqmcpRQKyviPf1WLNPy0++ePpsmsJPyi98DMXCBU7+7adUV
         7WyMcdgjjZ9duIwJDt9dGi2qWRfQ+Iblk8I8bzH1xxEw/jbM2P2yczw5Y6Jvzum6sXLt
         GQEA==
X-Gm-Message-State: AOAM531196eayj8r4AKCu92OSOBpecUhcceqLrDD8jiq6MODOEx2PZzN
        G+UA7hTzUfExzXqvbOxhA1AJ4PZipQGbiJ9PFtg=
X-Google-Smtp-Source: ABdhPJwLEOCQ5lbLi4Tznra9/LzTGpXcz9WmNQUddJipFMnMKm8yq9gpXeFX5iVT/d1ZsuyvsYrhaN+GCEPWi7A/6rY=
X-Received: by 2002:ae9:e704:: with SMTP id m4mr14345023qka.465.1628495956905;
 Mon, 09 Aug 2021 00:59:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210806054904.534315-1-joel@jms.id.au> <20210806054904.534315-2-joel@jms.id.au>
 <YQ7ZXu7hHTCNBwNz@lunn.ch>
In-Reply-To: <YQ7ZXu7hHTCNBwNz@lunn.ch>
From:   Joel Stanley <joel@jms.id.au>
Date:   Mon, 9 Aug 2021 07:59:05 +0000
Message-ID: <CACPK8XdKi3f60h2PNjuWsEiw5Rz+F7Ngtw0yF0ZOg+N3kOy0tQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: net: Add bindings for LiteETH
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Stafford Horne <shorne@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Gabriel Somlo <gsomlo@gmail.com>, David Shah <dave@ds0.me>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Aug 2021 at 19:05, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Aug 06, 2021 at 03:19:03PM +0930, Joel Stanley wrote:
> > LiteETH is a small footprint and configurable Ethernet core for FPGA
> > based system on chips.
> >
> > Signed-off-by: Joel Stanley <joel@jms.id.au>
> > ---
> >  .../bindings/net/litex,liteeth.yaml           | 62 +++++++++++++++++++
> >  1 file changed, 62 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/litex,liteeth.yaml b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
> > new file mode 100644
> > index 000000000000..e2a837dbfdaa
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
> > @@ -0,0 +1,62 @@
> > +# SPDX-License-Identifier: GPL-2.0-or-later OR BSD-2-Clause
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/litex,liteeth.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: LiteX LiteETH ethernet device
> > +
> > +maintainers:
> > +  - Joel Stanley <joel@jms.id.au>
> > +
> > +description: |
> > +  LiteETH is a small footprint and configurable Ethernet core for FPGA based
> > +  system on chips.
> > +
> > +  The hardware source is Open Source and can be found on at
> > +  https://github.com/enjoy-digital/liteeth/.
> > +
> > +properties:
> > +  compatible:
> > +    const: litex,liteeth
> > +
> > +  reg:
> > +    minItems: 3
> > +    items:
> > +      - description: MAC registers
> > +      - description: MDIO registers
> > +      - description: Packet buffer
>
> Hi Joel
>
> How configurable is the synthesis? Can the MDIO bus be left out? You
> can have only the MDIO bus and no MAC?
>
> I've not looked at the driver yet, but if the MDIO bus has its own
> address space, you could consider making it a standalone
> device. Somebody including two or more LiteETH blocks could then have
> one shared MDIO bus. That is a supported Linux architecture.

It's currently integrated as one device. If you instatined two blocks,
you would end up with two mdio controllers, each inside those two
liteeth blocks.

Obviously being software someone could change that. We've had a few
discussions about the infinite possibilities of a soft SoC and what
that means for adding driver support to mainline. I think having some
basic driver support is useful, particularly as we then get close
review as Jakub provided.

The liteeth block has seen a lot of use under Linux by risc-v
(vexriscv), powerpc (microwatt), and openrisc (mor1k) designs. The
microwatt and or1k designs have mainline support, making them easy to
test. This driver will support the normal configurations of those
platforms.

As the soft core project evolves, we can revisit what goes in
mainline, how flexible that driver support needs to be, and how best
to manage that.

>
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  rx-fifo-depth:
> > +    description: Receive FIFO size, in units of 2048 bytes
> > +
> > +  tx-fifo-depth:
> > +    description: Transmit FIFO size, in units of 2048 bytes
> > +
> > +  mac-address:
> > +    description: MAC address to use
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    mac: ethernet@8020000 {
> > +        compatible = "litex,liteeth";
> > +        reg = <0x8021000 0x100
> > +               0x8020800 0x100
> > +               0x8030000 0x2000>;
> > +        rx-fifo-depth = <2>;
> > +        tx-fifo-depth = <2>;
> > +        interrupts = <0x11 0x1>;
> > +    };
>
> You would normally expect to see some MDIO properties here, a link to
> the standard MDIO yaml, etc.

Do you have a favourite example that I could follow?
