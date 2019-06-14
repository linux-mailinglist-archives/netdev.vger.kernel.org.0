Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE91845E61
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbfFNNiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:38:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727808AbfFNNiD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 09:38:03 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75ACA2177E;
        Fri, 14 Jun 2019 13:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560519481;
        bh=5kPUwCBQMbS2M8o+wglPzUUXRhVd4mGNXeo+GKUnF6A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0pkIZa6kP5BSGUByBNXPb11Mtf9FoTuMz5OP/9UhNutVmICtSUC0evQmkqa7iouuB
         gnqMfGThUsxcWLoeMeycy32pw31W8V3FRPXUbwnacWCx00mOPxpQA406tg6jwOfjOO
         cCPg8YY4ve8ySWSx2GrOulpCip2vxl2n5Arfh2Gg=
Received: by mail-qt1-f182.google.com with SMTP id y57so2460183qtk.4;
        Fri, 14 Jun 2019 06:38:01 -0700 (PDT)
X-Gm-Message-State: APjAAAU891oPhSgnye1YQ3evNVnwF3e4KIMj83XFNFq70z39ZvTw3Alv
        A9FgytHeyP7izlDpTb49AqSR/UkEZwdBEbm93g==
X-Google-Smtp-Source: APXvYqyAj1odsDjtBwKdPSSywnQwCLoF/jNhPP0/kPXHppC/FT4M38muk0yGeu+a4kpzJwb49v6vKwKl9z5OZO/sjH8=
X-Received: by 2002:aed:3f10:: with SMTP id p16mr15675043qtf.110.1560519480558;
 Fri, 14 Jun 2019 06:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <d198d29119b37b2fdb700d8992b31963e98b6693.1560158667.git-series.maxime.ripard@bootlin.com>
 <20190610143139.GG28724@lunn.ch> <CAL_JsqJahCJcdu=+fA=ewbGezuEJ2W6uwMVxkQpdY6w+1OWVVA@mail.gmail.com>
 <20190611145856.ua2ggkn6ccww6vpp@flea> <CAL_Jsq+KwH-j8f+r+fWhMuqJPWcHdBQau+nUz3NRAXYTpsyuvg@mail.gmail.com>
 <20190614095048.j2xwdsucucbakkl2@flea>
In-Reply-To: <20190614095048.j2xwdsucucbakkl2@flea>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 14 Jun 2019 07:37:49 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+=yh3WhTg=1G02LUHGLHts6mECR9BQ+n7qHAihFViAxA@mail.gmail.com>
Message-ID: <CAL_Jsq+=yh3WhTg=1G02LUHGLHts6mECR9BQ+n7qHAihFViAxA@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] dt-bindings: net: sun4i-emac: Convert the
 binding to a schemas
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Mark Rutland <mark.rutland@arm.com>,
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
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 3:50 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> Hi Rob,
>
> On Thu, Jun 13, 2019 at 11:32:30AM -0600, Rob Herring wrote:
> > On Thu, Jun 13, 2019 at 7:25 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > > On Mon, Jun 10, 2019 at 12:59:29PM -0600, Rob Herring wrote:
> > > > On Mon, Jun 10, 2019 at 8:31 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > > > >
> > > > > > +required:
> > > > > > +  - compatible
> > > > > > +  - reg
> > > > > > +  - interrupts
> > > > > > +  - clocks
> > > > > > +  - phy
> > > > > > +  - allwinner,sram
> > > > >
> > > > > Quoting ethernet.txt:
> > > > >
> > > > > - phy: the same as "phy-handle" property, not recommended for new bindings.
> > > > >
> > > > > - phy-handle: phandle, specifies a reference to a node representing a PHY
> > > > >   device; this property is described in the Devicetree Specification and so
> > > > >   preferred;
> > > > >
> > > > > Can this be expressed in Yaml? Accept phy, but give a warning. Accept
> > > > > phy-handle without a warning? Enforce that one or the other is
> > > > > present?
> > > >
> > > > The common schema could have 'phy: false'. This works as long as we've
> > > > updated (or plan to) all the dts files to use phy-handle. The issue is
> > > > how far back do you need kernels to work with newer dtbs.
> > >
> > > I guess another question being raised by this is how hard do we want
> > > to be a deprecating things, and should the DT validation be a tool to
> > > enforce that validation.
> > >
> > > For example, you've used in you GPIO meta-schema false for anything
> > > ending with -gpio, since it's deprecated. This means that we can't
> > > convert any binding using a deprecated property without introducing a
> > > build error in the schemas, which in turn means that you'll have a lot
> > > of friction to support schemas, since you would have to convert your
> > > driver to support the new way of doing things, before being able to
> > > have a schema for your binding.
> >
> > I've err'ed on the stricter side. We may need to back off on some
> > things to get to warning free builds. Really, I'd like to have levels
> > to separate checks for existing bindings, new bindings, and pedantic
> > checks.
>
> That would be awesome. Do you have a plan for that already though? I
> can't really think of a way to implement it at the moment.

The only idea I have so far is some sort of 'level' property and then
we filter schema based on what level we run validation at. I'm not too
sure if that would take some restructuring of schema though because
it's all a mixture ATM.

The other aspect is how to set the 'level' per platform so new
platforms have to pass a higher level. We already have that problem
just with dtc warnings. Ideally, we should build new platforms with
'W=1' or 'W=12'. Maybe the soc/board schema's can specify the level.

> > For '-gpio', we may be okay because the suffix is handled in the GPIO
> > core. It should be safe to update the binding to use the preferred
> > form.
>
> It might require a bit of work though in drivers, since the fallback
> is only handled if you're using the gpiod API, and not the legacy one.
>
> > > And then, we need to agree on how to express the deprecation. I guess
> > > we could allow the deprecated keyword that will be there in the
> > > draft-8, instead of ad-hoc solutions?
> >
> > Oh, nice! I hadn't seen that. Seems like we should use that. We can
> > start even without draft-8 support because unknown keywords are
> > ignored (though we probably have to add it to our meta-schema). Then
> > at some point we can add a 'disallow deprecated' flag to the tool.
>
> So, in the generic ethernet binding, we would have:
>
> properties:
>   phy-handle:
>     $ref: /schemas/types.yaml#definitions/phandle
>     description:
>       Specifies a reference to a node representing a PHY device.
>
>   phy:
>     $ref: "#/properties/phy-handle"
>     deprecated: true
>
>   phy-device:
>     $ref: "#/properties/phy-handle"
>     deprecated: true
>
> Does that sound good?

Yes.

> Now, how do we handle the case above, in the device specific binding?
> We just require the non-deprecated one, or the three?

Wouldn't that just depend if all the instances of the device specific
binding have been updated?

Rob
