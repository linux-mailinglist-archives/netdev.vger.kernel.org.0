Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF53653371
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbiLUPei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbiLUPeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:34:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5482611D;
        Wed, 21 Dec 2022 07:29:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0EEA61808;
        Wed, 21 Dec 2022 15:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D87C43392;
        Wed, 21 Dec 2022 15:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671636568;
        bh=wFkYUylJbr4FMDZjTmOjoxFQ4meaXsYE5Tb4CvtoGe0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=n3aeSl2BOQoCA/GBy2uTAGGbrl9Bk8vlvuVScyTqZUlx14P6/0HSb4EY0mBQlE/Di
         BLxtw3Z9plP2YWp5QKfeQK0GcsI58at8PmzuGBj2h0OpkXvxhC+EwVT1KFHF6HT6qU
         bCeR0NHzUkqzxt+TFa1qelipWE9Atn5+U5ZpZQ7lgQFvthXE8gAP6SXQWoY8EOGSHc
         LtqIEgwBnoktw27gv8UC8h2YwSc9/blZaTdhvCYsD6X9OTyqIaQZm6/mhDpI/UORG2
         dK2EagVkwiYPc1BYYpjJPaSLFN/MAS+9gm9DdDvmMASvTn21CoogI5gTjWkJczAnUu
         O6YfCic3mCQvw==
Received: by mail-vs1-f52.google.com with SMTP id i2so15075337vsc.1;
        Wed, 21 Dec 2022 07:29:28 -0800 (PST)
X-Gm-Message-State: AFqh2kr6afNiCzSYqG7iIAaNZc6bagek6Tf+ufrt7d/Hp+Pv4828ZV1D
        /QYmHwS9xB+f8GahgK39EHfuOn2hcZzBbfUpDA==
X-Google-Smtp-Source: AMrXdXsmJHoE603TUd9P+L+qPTU5ouQ1XqdRnUXlItEa+ZM/qHoda888Y6IWITfLU8au2mnVNozJJOSADJ4wqm2QVVk=
X-Received: by 2002:a67:edd4:0:b0:3b5:1fe4:f1c2 with SMTP id
 e20-20020a67edd4000000b003b51fe4f1c2mr260718vsp.0.1671636567233; Wed, 21 Dec
 2022 07:29:27 -0800 (PST)
MIME-Version: 1.0
References: <20221214235438.30271-1-ansuelsmth@gmail.com> <20221214235438.30271-12-ansuelsmth@gmail.com>
 <20221220173958.GA784285-robh@kernel.org> <Y6JDOFmcEQ3FjFKq@lunn.ch>
 <Y6JkXnp0/lF4p0N1@lunn.ch> <63a30221.050a0220.16e5f.653a@mx.google.com>
In-Reply-To: <63a30221.050a0220.16e5f.653a@mx.google.com>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 21 Dec 2022 09:29:15 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLOvCJ_aHk4jSp64u1LbGyoeTjY_vRgVkvvVNCOp=3NmA@mail.gmail.com>
Message-ID: <CAL_JsqLOvCJ_aHk4jSp64u1LbGyoeTjY_vRgVkvvVNCOp=3NmA@mail.gmail.com>
Subject: Re: [PATCH v7 11/11] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 6:55 AM Christian Marangi <ansuelsmth@gmail.com> wrote:
>
> On Wed, Dec 21, 2022 at 02:41:50AM +0100, Andrew Lunn wrote:
> > > > > +                        };
> > > > > +
> > > > > +                        led@1 {
> > > > > +                            reg = <1>;
> > > > > +                            color = <LED_COLOR_ID_AMBER>;
> > > > > +                            function = LED_FUNCTION_LAN;
> > > > > +                            function-enumerator = <1>;
> > > >
> > > > Typo? These are supposed to be unique. Can't you use 'reg' in your case?
> > >
> > > reg in this context is the address of the PHY on the MDIO bus. This is
> > > an Ethernet switch, so has many PHYs, each with its own address.
> >
> > Actually, i'm wrong about that. reg in this context is the LED number
> > of the PHY. Typically there are 2 or 3 LEDs per PHY.
> >
> > There is no reason the properties need to be unique. Often the LEDs
> > have 8 or 16 functions, identical for each LED, but with different
> > reset defaults so they show different things.
> >
>
> Are we taking about reg or function-enumerator?
>
> For reg it's really specific to the driver... My idea was that since a
> single phy can have multiple leds attached, reg will represent the led
> number.
>
> This is an example of the dt implemented on a real device.
>
>                 mdio {
>                         #address-cells = <1>;
>                         #size-cells = <0>;
>
>                         phy_port1: phy@0 {
>                                 reg = <0>;
>
>                                 leds {
>                                         #address-cells = <1>;
>                                         #size-cells = <0>;
>
>                                         lan1_led@0 {
>                                                 reg = <0>;
>                                                 color = <LED_COLOR_ID_WHITE>;
>                                                 function = LED_FUNCTION_LAN;
>                                                 function-enumerator = <1>;
>                                                 linux,default-trigger = "netdev";
>                                         };
>
>                                         lan1_led@1 {
>                                                 reg = <1>;
>                                                 color = <LED_COLOR_ID_AMBER>;
>                                                 function = LED_FUNCTION_LAN;
>                                                 function-enumerator = <1>;
>                                                 linux,default-trigger = "netdev";
>                                         };
>                                 };
>                         };
>
>                         phy_port2: phy@1 {
>                                 reg = <1>;
>
>                                 leds {
>                                         #address-cells = <1>;
>                                         #size-cells = <0>;
>
>
>                                         lan2_led@0 {
>                                                 reg = <0>;
>                                                 color = <LED_COLOR_ID_WHITE>;
>                                                 function = LED_FUNCTION_LAN;
>                                                 function-enumerator = <2>;
>                                                 linux,default-trigger = "netdev";
>                                         };
>
>                                         lan2_led@1 {
>                                                 reg = <1>;
>                                                 color = <LED_COLOR_ID_AMBER>;
>                                                 function = LED_FUNCTION_LAN;
>                                                 function-enumerator = <2>;
>                                                 linux,default-trigger = "netdev";
>                                         };
>                                 };
>                         };
>
>                         phy_port3: phy@2 {
>                                 reg = <2>;
>
>                                 leds {
>                                         #address-cells = <1>;
>                                         #size-cells = <0>;
>
>                                         lan3_led@0 {
>                                                 reg = <0>;
>                                                 color = <LED_COLOR_ID_WHITE>;
>                                                 function = LED_FUNCTION_LAN;
>                                                 function-enumerator = <3>;
>                                                 linux,default-trigger = "netdev";
>                                         };
>
>                                         lan3_led@1 {
>                                                 reg = <1>;
>                                                 color = <LED_COLOR_ID_AMBER>;
>                                                 function = LED_FUNCTION_LAN;
>                                                 function-enumerator = <3>;
>                                                 linux,default-trigger = "netdev";
>                                         };
>                                 };
>                         };
>
> In the following implementation. Each port have 2 leds attached (out of
> 3) one white and one amber. The driver parse the reg and calculate the
> offset to set the correct option with the regs by also checking the phy
> number.

Okay, the full example makes more sense. But I still thought
'function-enumerator' values should be globally unique within a value
of 'function'. Maybe Jacek has an opinion on this?

You are using it to distinguish phys/ports, but there's already enough
information in the DT to do that. You have the parent nodes and I
assume you have port numbers under 'ethernet-ports'. For each port,
get the phy node and then get the LEDs.

> An alternative way would be set the reg to be the global led number in
> the switch and deatch the phy from the calculation.
>
> Something like
> port 0 led 0 = reg 0
> port 0 led 1 = reg 1
> port 1 led 0 = reg 2
> port 1 led 1 = reg 3
> ...

No.

Rob
