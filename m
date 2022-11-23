Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43DCF636E78
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiKWXeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiKWXeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:34:20 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF522A727;
        Wed, 23 Nov 2022 15:34:18 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DCA13240002;
        Wed, 23 Nov 2022 23:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669246457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QZEGkusolukN4rVJkkr+SmRPY0B0B9qmE32YQK4KN28=;
        b=UIJ1/vnWuGxD2BugR4k5HWjkEduaRhQO2Ez84GdKl3yeBvpIR/+gyYyhdindqVR+idKU1Q
        Zj9Qfu80ezmteY+Rfy8pwmWI5zNKpi7V79zGeoJwT1FC7djSbTYYCikW1GYdwI2tvDwHUf
        L/uLSM1hwoff/7v40YIqqK1S7QRqi9VchP2aNJBzJB3d227qzjL328aGqLEtnBmaES/OHf
        hsbnXO3LZQGuUDPWPDZejzkFwBNLNG7GiXpZIITCbPql8pboPZMclaLKWTlJ17S1c+NeZu
        SfZtNCodFk643mcpal+Qy28lajsmM/XaHk0JEB10WVHojOH++2zdJWGtVkSiDA==
Date:   Thu, 24 Nov 2022 00:34:13 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH 2/6] dt-bindings: net: marvell,dfx-server: Convert to
 yaml
Message-ID: <20221124003413.6a2c4518@xps-13>
In-Reply-To: <20221123221023.GA2582938-robh@kernel.org>
References: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
        <20221117215557.1277033-3-miquel.raynal@bootlin.com>
        <20221123221023.GA2582938-robh@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

robh@kernel.org wrote on Wed, 23 Nov 2022 16:10:23 -0600:

> On Thu, Nov 17, 2022 at 10:55:53PM +0100, Miquel Raynal wrote:
> > Even though this description is not used anywhere upstream (no matching
> > driver), while on this file I decided I would try a conversion to yaml
> > in order to clarify the prestera family description.
> >=20
> > I cannot keep the nodename dfx-server@xxxx so I switched to dfx-bus@xxxx
> > which matches simple-bus.yaml. Otherwise I took the example context from
> > the only user of this compatible: armada-xp-98dx3236.dtsi, which is a
> > rather old and not perfect DT.
> >=20
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> > I am fine dropping this file entirely as well, if judged useless.
> > ---
> >  .../bindings/net/marvell,dfx-server.yaml      | 60 +++++++++++++++++++
> >  .../bindings/net/marvell,prestera.txt         | 18 ------
> >  2 files changed, 60 insertions(+), 18 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/marvell,dfx-s=
erver.yaml
> >=20
> > diff --git a/Documentation/devicetree/bindings/net/marvell,dfx-server.y=
aml b/Documentation/devicetree/bindings/net/marvell,dfx-server.yaml
> > new file mode 100644
> > index 000000000000..72151a78396f
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/marvell,dfx-server.yaml
> > @@ -0,0 +1,60 @@
> > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/marvell,dfx-server.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Marvell Prestera DFX server
> > +
> > +maintainers:
> > +  - Miquel Raynal <miquel.raynal@bootlin.com>
> > +
> > +select:
> > +  properties:
> > +    compatible:
> > +      contains:
> > +        const: marvell,dfx-server
> > +  required:
> > +    - compatible
> > +
> > +properties:
> > +  compatible:
> > +    items:
> > +      - const: marvell,dfx-server
> > +      - const: simple-bus
> > +
> > +  reg: true =20
>=20
> How many entries?

Right, there is a single one, I'll constrain reg properly in v2.

> > +
> > +  ranges: true
> > +
> > +  '#address-cells':
> > +    const: 1
> > +
> > +  '#size-cells':
> > +    const: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - ranges
> > +
> > +# The DFX server may expose clocks described as subnodes
> > +additionalProperties: true =20
>=20
> addtionalProperties:
>   type: object
>=20
> So that only nodes can be added.

Excellent, I never thought about this possibility, but of course that
works. Thanks a lot!

>=20
> > +
> > +examples:
> > +  - |
> > +
> > +    #define MBUS_ID(target,attributes) (((target) << 24) | ((attribute=
s) << 16))
> > +    bus@0 {
> > +        reg =3D <0 0>;
> > +        #address-cells =3D <2>;
> > +        #size-cells =3D <1>;
> > +
> > +        dfx-bus@ac000000 {
> > +            compatible =3D "marvell,dfx-server", "simple-bus";
> > +            #address-cells =3D <1>;
> > +            #size-cells =3D <1>;
> > +            ranges =3D <0 MBUS_ID(0x08, 0x00) 0 0x100000>;
> > +            reg =3D <MBUS_ID(0x08, 0x00) 0 0x100000>;
> > +        };
> > +    }; =20


Thanks,
Miqu=C3=A8l
