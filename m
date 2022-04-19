Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05F2507144
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 17:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349429AbiDSPE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 11:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347789AbiDSPE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 11:04:57 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9399B2D1DB;
        Tue, 19 Apr 2022 08:02:13 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CF4D7240012;
        Tue, 19 Apr 2022 15:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650380530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GsDF21Scwpzk12ag+GO/8lcdNxhDhaAggJYyHxq2BDk=;
        b=gKhcg6VhM7omoOFct2rFBg35LWARoAzxbEfp5VezTqIKwH69hQPhqjnfXMIKwFLcP2wxGs
        XG3HTl8ibshJEny/FEYMVglygvSnDOSyam9n5HSPH9oU875QUZvmTuGFPCtSrNrniTezCj
        Ety2BHZhaOT+jX0kSfyJavQ34UXRQlYjH7aaStaWbbzS3SnXkaveh+shKiVuSmwatAkNL1
        ceDJFSuH7sLCEW2+iBuykcrqyf9mjpp8jUHEKcQX5KHc+uNmj+nleg0bcxa81kI/76GEuK
        aSq+B/Qm9l8RwlbjMV/jMOFiL9iY5yysb4YkHMksQ4KgZ35tiF/PQ8zgu6tEAw==
Date:   Tue, 19 Apr 2022 17:00:44 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 03/12] dt-bindings: net: pcs: add bindings for
 Renesas RZ/N1 MII converter
Message-ID: <20220419170044.450050ca@fixe.home>
In-Reply-To: <Yl68k22fUw7uBgV9@robh.at.kernel.org>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-4-clement.leger@bootlin.com>
        <Yl68k22fUw7uBgV9@robh.at.kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, 19 Apr 2022 08:43:47 -0500,
Rob Herring <robh@kernel.org> a =C3=A9crit :

> > +  clocks:
> > +    items:
> > +      - description: MII reference clock
> > +      - description: RGMII reference clock
> > +      - description: RMII reference clock
> > +      - description: AHB clock used for the MII converter register int=
erface
> > +
> > +  renesas,miic-cfg-mode:
> > +    description: MII mux configuration mode. This value should use one=
 of the
> > +                 value defined in dt-bindings/net/pcs-rzn1-miic.h. =20
>=20
> Describe possible values here as constraints. At present, I don't see=20
> the point of this property if there is only 1 possible value and it is=20
> required.

The ethernet subsystem contains a number of internal muxes that allows
to configure ethernet routing. This configuration option allows to set
the register that configure these muxes.

After talking with Andrew, I considered moving to something like this:

eth-miic@44030000 {
  compatible =3D "renesas,rzn1-miic";

  mii_conv1: mii-conv-1 {
    renesas,miic-input =3D <MIIC_GMAC1_PORT>;
    port =3D <1>;
  };
  mii_conv2: mii-conv-2 {
    renesas,miic-input =3D <MIIC_SWITCHD_PORT>;
    port =3D <2>;
  };
   ...
};

Which would allow embedding the configuration inside the port
sub-nodes. Moreover, it allows a better validation of the values using
the schema validation directly since only a limited number of values
are allowed for each port.

>=20
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > + =20
> > +patternProperties:
> > +  "^mii-conv@[0-4]$":
> > +    type: object =20
>=20
>        additionalProperties: false
>=20
> > +    description: MII converter port
> > +
> > +    properties:
> > +      reg:
> > +        maxItems: 1 =20
>=20
> Why do you need sub-nodes? They don't have any properties. A simple mask=
=20
> property could tell you which ports are present/active/enabled if that's=
=20
> what you are tracking. Or the SoC specific compatibles you need to add=20
> can imply the ports if they are SoC specific.

The MACs are using phandles to these sub-nodes to query a specific MII
converter port PCS:

switch@44050000 {
    compatible =3D "renesas,rzn1-a5psw";

    ports {
        port@0 {
            reg =3D <0>;
            label =3D "lan0";
            phy-handle =3D <&switch0phy3>;
            pcs-handle =3D <&mii_conv4>;
        };
    };
};

According to Andrew, this is not a good idea to represent the PCS as a
bus since it is indeed not a bus. I could also switch to something like
pcs-handle =3D <&eth_mii 4> but i'm not sure what you'd prefer. We could
also remove this from the device-tree and consider each driver to
request the MII ouput to be configured using something like this for
instance:

 miic_request_pcs(pcs_np, miic_port_nr, MIIC_SWITCHD_PORT);

But I'm not really fan of this because it requires the drivers to
assume some specificities of the MII converter (port number are not in
the same order of the switch for instance) and thus I would prefer this
to be in the device-tree.

Let me know if you can think of something that would suit you
better but  keep in mind that I need to correctly match a switch/MAC
port with a PCS port and that I also need to configure MII internal
muxes.=20

For more information, you can look at section 8 of the manual at [1].

Thanks,

[1]
https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-gr=
oup-users-manual-system-introduction-multiplexing-electrical-and
--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
