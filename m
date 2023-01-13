Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD04669E5D
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjAMQlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjAMQko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:40:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45A959335;
        Fri, 13 Jan 2023 08:39:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 557EE6225C;
        Fri, 13 Jan 2023 16:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B220AC4339B;
        Fri, 13 Jan 2023 16:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673627939;
        bh=iHyPdMVChENnUCFIczMHl++N28bbycKFvGI459jo8sk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qwQZwgsxI1chEmMs06SlYOE3+WX7/AA50E+TJUV1b9PxVDlo7RzW/W0pL6vZFPWHe
         7n9OXc+N5IzhqTGoEGY39XWqpg6K+QbFdZFlta+avQiNGYshJajNB86tsg6fkQnYPS
         Nbj6XWWqxgUbZQ4rTcBJmF+xEdImg3dR+eM7+U4X2+/Zh7F9jwED1QJIw0PwiUUJeI
         kSvxnRqXcnrkSH8ieLM284mnOYGWm7EW/5NVXnWyI3U1oV5ojxSKyUuz9ZIbXwe3Kb
         NVLpfFGzeXpfa3SWX3IgR0qJr+sTMbUlPzENr2ZX4nflU5nwf+J6o8VOsjwRNE10Rt
         rwuRYVbd8geog==
Received: by mail-vs1-f41.google.com with SMTP id 186so17472924vsz.13;
        Fri, 13 Jan 2023 08:38:59 -0800 (PST)
X-Gm-Message-State: AFqh2krmfSAD9AOLHg4xfeRq1mc+w4JtfrFUsw2ws67XgjlRPby6ozxj
        PDnoU8xT/hWHds2ymV0ZJcrnqtAnpIdvzLd4yg==
X-Google-Smtp-Source: AMrXdXt+gucdpLaS71rIflvXlq+Gcoxs65gTYv2K5/8g2Cw9fpY+IHdsJOrJUMvhlTUEWkOXqFicqnVl6J9ARJWwR7w=
X-Received: by 2002:a67:edd4:0:b0:3b5:1fe4:f1c2 with SMTP id
 e20-20020a67edd4000000b003b51fe4f1c2mr10996575vsp.0.1673627938475; Fri, 13
 Jan 2023 08:38:58 -0800 (PST)
MIME-Version: 1.0
References: <20230109123013.3094144-1-michael@walle.cc> <20230109123013.3094144-3-michael@walle.cc>
 <20230111202639.GA1236027-robh@kernel.org> <73f8aad30e0d5c3badbd62030e545ef6@walle.cc>
In-Reply-To: <73f8aad30e0d5c3badbd62030e545ef6@walle.cc>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 13 Jan 2023 10:38:47 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKMo6op93WQHpuVdBV6tOPYa9Pyu4geRQmOeQAicEsLWg@mail.gmail.com>
Message-ID: <CAL_JsqKMo6op93WQHpuVdBV6tOPYa9Pyu4geRQmOeQAicEsLWg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 4:30 PM Michael Walle <michael@walle.cc> wrote:
>
> Am 2023-01-11 21:26, schrieb Rob Herring:
> > On Mon, Jan 09, 2023 at 01:30:11PM +0100, Michael Walle wrote:
> >> Add the device tree bindings for the MaxLinear GPY2xx PHYs, which
> >> essentially adds just one flag: maxlinear,use-broken-interrupts.
> >>
> >> One might argue, that if interrupts are broken, just don't use
> >> the interrupt property in the first place. But it needs to be more
> >> nuanced. First, this interrupt line is also used to wake up systems by
> >> WoL, which has nothing to do with the (broken) PHY interrupt handling.
> >
> > I don't understand how this is useful. If the interrupt line is
> > asserted
> > after the 1st interrupt, how is it ever deasserted later on to be
> > useful.
>
> Nobody said, that the interrupt line will stay asserted. The broken
> behavior is that of the PHY doesn't respond *immediately* with a
> deassertion of the interrupt line after the its internal status
> register is cleared. Instead there is a random delay of up to 2ms.

With only "keep the interrupt line asserted even after the interrupt
status register is cleared", I assume that means forever, not some
delay.

> There is already a workaround to avoid an interrupt storm by delaying
> the ISR until the line is actually cleared. *But* if this line is
> a shared one. The line is blocked by these 2ms and important
> interrupts (like PTP timestaming) of other devices on this line
> will get delayed. Therefore, the only viabale option is to disable
> the interrupts handling in the broken PHY altogether. I.e. the line
> will never be asserted by the broken PHY.

Okay, that makes more sense.

So really, this is just an 'is shared interrupt' flag. If not shared,
then there's no reason to not use the interrupt? Assuming all
interrupts are described in DT, we already have that information. It's
just hard and inefficient to get it. You have to parse all interrupts
with the same parent and check for the same cells. If we're going to
add something more explicit, we should consider something common. It's
not the first time shared interrupts have come up, and we probably
have some properties already. For something common, I'd probably make
this a flag in interrupt cells rather than a property. That would
handle cases with multiple interrupts better.

> > In any case, you could use 'wakeup-source' if that's the functionality
> > you need. Then just ignore the interrupt if 'wakeup-source' is not
> > present.
>
> Right, that would work for the first case. But not if someone really
> wants to use interrupts with the PHY, which is still a valid scenario
> if it has a dedicated interrupt line.

Right.


> >> Second and more importantly, there are devicetrees which have this
> >> property set. Thus, within the driver we have to switch off interrupt
> >> handling by default as a workaround. But OTOH, a systems designer who
> >> knows the hardware and knows there are no shared interrupts for
> >> example,
> >> can use this new property as a hint to the driver that it can enable
> >> the
> >> interrupt nonetheless.
> >
> > Pretty sure I said this already, but this schema has no effect. Add an
> > extra property to the example and see. No error despite your
> > 'unevaluatedProperties: false'. Or drop 'interrupts-extended' and no
> > dependency error...
>
> I know, I noticed this the first time I tested the schema. But then
> I've looked at all the other PHY binding and not one has a compatible.
>
> I presume if there is a compatible, the devicetrees also need a
> compatible. So basically, "required: compatible" in the schema, right?

The DTs need one, yes. The schema doesn't actually matter here. The
schema is only selected if compatible is present, so the schema
checking that is redundant.

> But that is where the PHY maintainers don't agree.

I guess Andrew agrees now for making schema checks happy. But that's
not really the reason. Usually compatibles on discoverable devices can
be constructed from the discoverable info (e.g. PCI compatible
contains VID/PID), so you can find the node and validate it matches
the device. Second, it is just good practice to provide a way to
identify exactly what each device/node is. The schema checks needing
it is just a convenient way to enforce that practice.

> > You won't get errors as there's no defined way to decide when to apply
> > this because it is based on node name or compatible unless you do a
> > custom select, but I don't see what you would key off of here...
>
> Actually, in the previous version I've asked why the custom select
> of ethernet-phy.yaml doesn't get applied here, when there is a
> "allOf: $ref ethernet-phy.yaml".

No, 'select' is ignored in anything referenced. Using it would cause
your schema to be applied to all ethernet phy nodes. That might work
here, but not if you had a required property. Doing that would
effectively create a single schema with all possible properties for
all phy nodes.

Rob
