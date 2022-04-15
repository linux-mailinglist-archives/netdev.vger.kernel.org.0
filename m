Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAEC4502D00
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350138AbiDOPgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355474AbiDOPf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:35:58 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5AAD4476;
        Fri, 15 Apr 2022 08:31:24 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8FE39E0005;
        Fri, 15 Apr 2022 15:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650036683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5PxUe/jVOziohrmOicNYY1NsCVv8h1sy+kBFs3ns1qA=;
        b=e++gmbm5jOhwqvqQNApsOKbqHDxmZxZJl+i+rTOmPFMYyErOSmlhX2RorX0RUev+YdkpYX
        5afXGsrmBl/GHJ3cZN1ImxN5rI83UpLDx6yfbkUHcQdvQV4S3dpTp1C1kAD92Yo2bPNHY/
        cMSwiel+wUKf/h2/fCbw9nilDsXB3UwUF6woHk1K8CNiohC09GOFC4k5zBiLMlfXj7TMgT
        L8R4/QwvwzigMq0BYndP0c233YnEss5rqFoVgnOaYiEVEvEiAU0C+Llz0JPDcGljoTuCIG
        oB8OJFlVr4YY+phywFrY//KZcTg9QAaQT7KYQtzCrxZdkRXJtL6fSXSW6qOuEg==
Date:   Fri, 15 Apr 2022 17:29:54 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
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
Subject: Re: [PATCH net-next 09/12] ARM: dts: r9a06g032: describe MII
 converter
Message-ID: <20220415172954.64e53086@fixe.home>
In-Reply-To: <YlmLWv4Hsm2uk8pa@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-10-clement.leger@bootlin.com>
        <YlismVi8y3Vf6PZ0@lunn.ch>
        <20220415102453.1b5b3f77@fixe.home>
        <Yll+Tpnwo5410B9H@lunn.ch>
        <20220415163853.683c0b6d@fixe.home>
        <YlmLWv4Hsm2uk8pa@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 15 Apr 2022 17:12:26 +0200,
Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :

> > Ok, looks like a more flexible way to doing it. Let's go with something
> > like this:
> >=20
> > renesas,miic-port-connection =3D <PORTIN_GMAC2>, <MAC2>, <SWITCH_PORTC>,
> > <SWITCH_PORTB>, <SWITCH_PORTA>; =20
>=20
> Not all combinations are possible. In fact, there is a limited choice
> for each value. So consider getting the yaml tools to help you by
> listing what is valid for each setting. You might need a different
> format than. Also, this format it is not clear what each value refers
> to.
>=20
> renesas,miic-port-connection-mii-conv1 =3D <PORTIN_GMAC2>;
> renesas,miic-port-connection-mii-conv2 =3D <MAC2>;
> renesas,miic-port-connection-mii-conv3 =3D <SWITCH_PORTC>;
> renesas,miic-port-connection-mii-conv4 =3D <SWITCH_PORTB>;
> renesas,miic-port-connection-mii-conv5 =3D <SWITCH_PORTA>;
>=20
> is more sense documenting, and i suspect easier to make the validator
> work for you.

While doing it, I think it probably even makes more sense to have
something more structured. I currently have the following:

    eth-miic@44030000 {
      ...

      mii_conv0: mii-conv@0 {
        reg =3D <0>;
      };

      mii_conv1: mii-conv@1 {
        reg =3D <1>;
      };
      ...
    };

I think it would be good to modify it like this:

eth-miic@44030000 {
    ...
  converters {
    mii_conv0: mii-conv@0 {
      // Even if useless, maybe keeping it for the sake of coherency
      renesas,miic-input =3D <MIIC_GMAC1>;
      reg =3D <0>;
    };
    mii_conv1: mii-conv@1 {
      renesas,miic-input =3D <SWITCH_PORTA>;
      reg =3D <1>;
    };
    mii_conv2: mii-conv@2 {
      renesas,miic-input =3D <SWITCH_PORTB>;
      reg =3D <2>;
    };
    mii_conv3: mii-conv@3 {
      renesas,miic-input =3D <SWITCH_PORTC>;
      reg =3D <3>;
    };
    mii_conv4: mii-conv@4 {
      renesas,miic-input =3D <SWITCH_PORTD>;
      reg =3D <4>;
    };
  };

This way, it remains tied to the MII converter output port definition. I
guess that the yaml definitions would still allow to restrict the values
available per nodes. Validation for the final combination is probably
more difficult to do using yaml.

Regarding the SWITCH_PORTIN, I don't see any way to use the same
definition than for the converter port and thus, a
"renesas,miic-switch-portin" property seems mandatory.


--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
