Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A8FF61A7
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 22:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfKIVhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 16:37:37 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36150 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfKIVhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 16:37:36 -0500
Received: by mail-ed1-f66.google.com with SMTP id f7so8957833edq.3;
        Sat, 09 Nov 2019 13:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v2rlUqcAtuAl3VsuUjT6IuOByjI2GD6fMPEYr5wAeuI=;
        b=TXCDad10SMV/uwl8/+qe0SREn2XQsQqXQR3prsAxoLCFxxeqergAC9f9+2CJugiARs
         JHVgCjM7DXZeQCW5gmyskvM0m8NZdblM3ykJXvnVPmMD0LwK4Iip9DDJzonBJkB7OGkl
         qYG3yieHrxhPpc+Q1++skFFogVH6YCgtMLmXjATUzLidIJQiCJIoT+ZHgKO2fEbFJw3Q
         bKJ5rQj+fAmcXT7o8Gm48+xCbSTF3nZC/18xIc3Ragm/BfIW95MRvYPprzjgiE71ePM4
         sZI30DpBqceE/YH3mefCaLbP77XL7hGwFNpq4QX14kklNoFoFDhUOKistffPik5vxan7
         fe4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v2rlUqcAtuAl3VsuUjT6IuOByjI2GD6fMPEYr5wAeuI=;
        b=K+AbQP5JjIX12l30JKtwlJzmD5qtlnMTtIJoV4qX1rDVGn9G/PqaRAZ9LLA5nHFQ/S
         0Wu/iWkD0JTQvi2sHJXx+VfMPGttOJfwo8FRmDsz7wBjTWQ1dzFt/PLU5tplFkAaEc2B
         NL/6a+mMfieD1MEUYvSZCsnfr3vv54eU6hww4R+ZL3/l11EpPEXrJ6kMF63ORk+gOGuK
         JRa16MGS1kmdoZzKs9Gqshe5z44uWDHQlOudzgJOUQMUQSK1ydjG6jBiEo+k168A06OE
         qli9E8wTH3IBl3J/atfvAy0+tIz7IpweE/f76tL/j1Dh+kdeuOBJsYpqfF9fQEzWH9uw
         lh/Q==
X-Gm-Message-State: APjAAAWYhjloE2LdlSpqbrrKw+9JgLg44wAtnDoHXzmuDtZ+qB8sT3E/
        hPpR7F93HC9MraenXm0KBpoNTQLYnXzZ0tX24yc=
X-Google-Smtp-Source: APXvYqz9fVCFirGSrnpJPZ/fGN+Vp1m8kWf/gR7wl8YC+sQC1r3wJYxUYLIziw0nTEibrT8sz6mJqeFEXn/GXtoUx4U=
X-Received: by 2002:a50:b63b:: with SMTP id b56mr18152663ede.165.1573335453236;
 Sat, 09 Nov 2019 13:37:33 -0800 (PST)
MIME-Version: 1.0
References: <20191109105642.30700-1-olteanv@gmail.com> <20191109150953.GJ22978@lunn.ch>
 <CA+h21hoqkE2D03BHrFeU+STbK8pStRRFu+x7+9j2nwFf+EHJNg@mail.gmail.com>
 <393335751.FoSYQk3TTC@kongar> <20191109210549.GB12999@lunn.ch>
In-Reply-To: <20191109210549.GB12999@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 9 Nov 2019 23:37:22 +0200
Message-ID: <CA+h21hqU2bW82Q5jReEhsP6fhLTEgpcXuyU3EsdKFOgNrogoTQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: ls1021a-tsn: Use interrupts for the SGMII PHYs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alexander Stein <alexander.stein@mailbox.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, leoyang.li@nxp.com,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Nov 2019 at 23:05, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Nov 09, 2019 at 08:52:54PM +0100, Alexander Stein wrote:
> >  On Saturday, November 9, 2019, 4:21:51 PM CET Vladimir Oltean wrote:
> > > On 09/11/2019, Andrew Lunn <andrew@lunn.ch> wrote:
> > > > On Sat, Nov 09, 2019 at 12:56:42PM +0200, Vladimir Oltean wrote:
> > > >> On the LS1021A-TSN board, the 2 Atheros AR8031 PHYs for eth0 and eth1
> > > >> have interrupt lines connected to the shared IRQ2_B LS1021A pin.
> > > >>
> > > >> The interrupts are active low, but the GICv2 controller does not support
> > > >> active-low and falling-edge interrupts, so the only mode it can be
> > > >> configured in is rising-edge.
> > > >
> > > > Hi Vladimir
> > > >
> > > > So how does this work? The rising edge would occur after the interrupt
> > > > handler has completed? What triggers the interrupt handler?
> > > >
> > > >   Andrew
> > > >
> > >
> > > Hi Andrew,
> > >
> > > I hope I am not terribly confused about this. I thought I am telling
> > > the interrupt controller to raise an IRQ as a result of the
> > > low-to-high transition of the electrical signal. Experimentation sure
> > > seems to agree with me. So the IRQ is generated immediately _after_
> > > the PHY has left the line in open drain and it got pulled up to Vdd.
> >
>
> > It is correct GIC only supports raising edge and active-high. The
> > IRQ[0:5] on ls1021a are a bit special though.  They not directly
> > connected to GIC, but there is an optional inverter, enabled by
> > default.
>
> Ah, O.K. So configuring for a rising edge is actually giving a falling
> edge. Which is why it works.
>
> Actually supporting this correctly is going a cause some pain. I
> wonder how many DT files currently say rising/active high, when in
> fact falling/active low is actually being used? And when the IRQ
> controller really does support active low and falling, things brake?
>
> Vladimir, since this is a shared interrupt, you really should use
> active low here. Maybe the first step is to get control of the
> inverter, and define a DT binding which is not going to break
> backwards compatibility. And then wire up this interrupt.
>
>           Andrew

Oh, ok, this is what you mean, thanks Alexander for the clarification.
This sure escalated quickly and is going to keep me busy for a while.

-Vladimir
