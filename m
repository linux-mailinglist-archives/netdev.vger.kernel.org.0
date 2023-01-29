Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A21D680161
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 21:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbjA2UwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 15:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbjA2UwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 15:52:18 -0500
X-Greylist: delayed 550 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 29 Jan 2023 12:52:17 PST
Received: from polaris.svanheule.net (polaris.svanheule.net [84.16.241.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314FE1BADB
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 12:52:16 -0800 (PST)
Received: from [192.168.100.237] (cust-41-49-110-94.dyn.as47377.net [94.110.49.41])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sander@svanheule.net)
        by polaris.svanheule.net (Postfix) with ESMTPSA id 0E4A43744C0;
        Sun, 29 Jan 2023 21:43:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svanheule.net;
        s=mail1707; t=1675024982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GKCL4x5Txs5llaY7BYYY71zG1gIHojGBLbaJh42WF2U=;
        b=fZiGVi8n69bRgrIt/cGwzR5qVM88nWhqbRDxoIxLxoImEPG0gvyW/l/tbvtJF+abPNt/yR
        sIGDN2G/q6XR3/QU1WY47DI1hq2ozdiCvbERfeEN32h/UWEysKWKd8wRWNZJ+uIZQUqE8/
        l3QdvM3j5RMspUG/ExKvneq4DnZI4+xzMKr2zqL560X6Crm9OhtfETYiuN3sbmoAGY64vU
        0jtFSknqbvxBFeFqBGZN1ElZMsUvUeMJ/b7gcSnPnIGzslmS93Fzmrchii7xEHiq89f3lF
        RTYA7y60bhhqVtY0trX1G4LvAB9ECvzSBhMzwSM46f0GACuf39qJB7VcDW9xWQ==
Message-ID: <c609a7f865ab48f858adafdd9c1014dda8ec82d6.camel@svanheule.net>
Subject: Re: [PATCH v7 11/11] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
From:   Sander Vanheule <sander@svanheule.net>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh@kernel.org>,
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
Date:   Sun, 29 Jan 2023 21:43:00 +0100
In-Reply-To: <63a30221.050a0220.16e5f.653a@mx.google.com>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
         <20221214235438.30271-12-ansuelsmth@gmail.com>
         <20221220173958.GA784285-robh@kernel.org> <Y6JDOFmcEQ3FjFKq@lunn.ch>
         <Y6JkXnp0/lF4p0N1@lunn.ch> <63a30221.050a0220.16e5f.653a@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

On Wed, 2022-12-21 at 13:54 +0100, Christian Marangi wrote:
> For reg it's really specific to the driver... My idea was that since a
> single phy can have multiple leds attached, reg will represent the led
> number.
>=20
> This is an example of the dt implemented on a real device.
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0mdio {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0#ad=
dress-cells =3D <1>;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0#si=
ze-cells =3D <0>;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0phy=
_port1: phy@0 {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0reg =3D <0>;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0leds {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0#address-cells =3D <1>;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0#size-cells =3D <0>;
[...]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0};
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0};
[...]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0};
>=20
> In the following implementation. Each port have 2 leds attached (out of
> 3) one white and one amber. The driver parse the reg and calculate the
> offset to set the correct option with the regs by also checking the phy
> number.

With switch silicon allowing user control of the LEDs, vendors can (and wil=
l)
use the switch's LED peripheral to drive other LEDs (or worse). E.g. on a C=
isco
SG220-26 switch, using a Realtek RTL8382 SoC, the LEDs associated with some
unused switch ports are used to display a global device status. My concern =
here
is that one would have to specify switch ports, that aren't connected to
anything, just to describe those non-ethernet LEDs.

Would an alternative with a 'trigger-sources' property pointing to the righ=
t phy
be an option? The trade-off I see would be that extra port info has to be
provided on a separate LED controller, which your example can avoid thanks =
to
the phy's reg property.

Building on your example this may become:

       switch {
           mdio {
                #address-cells =3D <1>;
                #size-cells =3D <0>;
               =20
                switch_phy0: phy@0 {
                    reg =3D <0>;
                    #trigger-source-cells =3D <1>;
                };
            };

            leds {
                #address-cells =3D <2>;
                #size-cells =3D <0>;

                /* First port, first LED */
                /* Port status, can be offloaded */
                led@0.0 {
                    reg =3D <0 0>;
                    trigger-sources =3D <&switch_phy0 (NET_LINK | NET_SPEED=
_1000)>;
                    function =3D color =3D <LED_COLOR_ID_WHITE>;
                    function =3D LED_FUNCTION_LAN;
                    function-enumerator =3D <1>;
                    linux,default-trigger =3D "netdev";
                };

                /* First port, first LED */
                /* Port status, can be offloaded */
                led@0.1 {
                    reg =3D <0 1>;
                    trigger-sources =3D <&switch_phy0 (NET_LINK | NET_SPEED=
_100 | NET_SPEED_10)>;
                    function =3D color =3D <LED_COLOR_ID_AMBER>;
                    function =3D LED_FUNCTION_LAN;
                    function-enumerator =3D <1>;
                    linux,default-trigger =3D "netdev";
                };

                /* Last port (not used in hardware), first LED */
                /* Device status, software controlled */
                led@7.0 {
                    reg =3D <7 0>;
                    function =3D color =3D <LED_COLOR_ID_AMBER>;
                    function =3D LED_FUNCTION_STATUS;
                    linux,default-trigger =3D "default-on";
                };
            };
        };


To be a bit less verbose, the &switch_mdio node might serve as trigger prov=
ider
with a single cell, but the above would allow only defined phy-s to be
referenced.

The trigger-source cells could be used for a more fine grained control of w=
hat
should be offloaded (link up/down, Rx/Tx activity, link speed, ...). Althou=
gh
this selectivity is most likely runtime configurable, this could serve as a
description of static device labeling (e.g. "LINK/ACT 1000").

Switching to the implementation and driver side, the 'trigger-sources' prop=
erty
could be used by the netdev trigger to determine if a status LED can be
offloaded. The netdev trigger could just hide the whole hardware/software
control aspect then. Much like how the timer trigger always offloads if an
implementation is provided, even when offloading is less flexible than the
software implementation of the timer trigger.


Best,
Sander
