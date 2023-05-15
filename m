Return-Path: <netdev+bounces-2604-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01E52702AD2
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8445428124B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4E479D5;
	Mon, 15 May 2023 10:43:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5F079D0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:43:04 +0000 (UTC)
Received: from forward500a.mail.yandex.net (forward500a.mail.yandex.net [178.154.239.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3488196;
	Mon, 15 May 2023 03:43:02 -0700 (PDT)
Received: from mail-nwsmtp-smtp-production-main-18.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-18.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:5f1d:0:640:49bf:0])
	by forward500a.mail.yandex.net (Yandex) with ESMTP id A5D035EB08;
	Mon, 15 May 2023 13:42:58 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-18.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id vgXTnwxsAGk0-U9VWOEj0;
	Mon, 15 May 2023 13:42:57 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maquefel.me; s=mail; t=1684147377;
	bh=5Yf+nT9MWwC9WKid3XZN6dD355P7wOWx3LcVfWCOKwU=;
	h=References:Date:In-Reply-To:Cc:To:From:Subject:Message-ID;
	b=Kw42ataQQQf6GiAII5s/bVVcljzb8dMqqPOKnGk2UH1RgDrMoSaaZ6HPsy8gmkQBd
	 /Ewuww9pyci6rIgsziayoea/GQeSqIvFV8m7tNxu19Jj87Y0X4XGN8vyfZRJwpSnpX
	 wgHU8sdZ60mBnoDD4DQeGfNBCokPGSO2PVfb5/wk=
Authentication-Results: mail-nwsmtp-smtp-production-main-18.vla.yp-c.yandex.net; dkim=pass header.i=@maquefel.me
Message-ID: <c42805a244149e1887dca2c414a36243f862fcae.camel@maquefel.me>
Subject: Re: [PATCH 18/43] dt-bindings: net: Add DT bindings ep93xx eth
From: Nikita Shubin <nikita.shubin@maquefel.me>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Arnd Bergmann <arnd@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Alexander Sverdlin <alexander.sverdlin@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rob Herring
 <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzysztof.kozlowski+dt@linaro.org>, Hartley Sweeten
 <hsweeten@visionengravers.com>, netdev@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 15 May 2023 16:42:57 +0300
In-Reply-To: <7f05ecdc-cbbd-40b0-9a40-229e18aec721@lunn.ch>
References: <20230424123522.18302-1-nikita.shubin@maquefel.me>
	 <20230424123522.18302-19-nikita.shubin@maquefel.me>
	 <7f05ecdc-cbbd-40b0-9a40-229e18aec721@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Andrew!

On Mon, 2023-04-24 at 15:39 +0200, Andrew Lunn wrote:
> > +=C2=A0 copy_addr:
> > +=C2=A0=C2=A0=C2=A0 type: boolean
> > +=C2=A0=C2=A0=C2=A0 description:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Flag indicating that the MAC address sh=
ould be copied
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 from the IndAd registers (as programmed=
 by the bootloader)
>=20
> Looking at ep93xx_register_eth(), all callers are setting copy_addr
> to
> 1. So i don't think you need this.

Agreed. Dropped copy_addr entirely.

>=20
> > +
> > +=C2=A0 phy_id:
> > +=C2=A0=C2=A0=C2=A0 description: MII phy_id to use
>=20
> The eEP93xx Ethernet driver is a very old driver, so it is doing MDIO
> and PHY the old way. Ideally you should be using ep93xx_mdio_read()
> and ep93xx_mdio_write() to create an MDIO bus with
> of_mdiobus_regsiter, and then use a phy-handle to point to the PHY on
> the bus. It will then be the same as all other ethernet drivers using
> DT.

I've tinkered with the preferred way, however this involves turning on=20

- CONFIG_PHYLIB
- CONFIG_MDIO_DEVICE

And maybe CONFIG_MICREL_PHY (at least for me, unless i can use some
common phy driver) which implies a kernel size increase - which is
undesirable for us.

Can we slip by with something like:

+       np =3D of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
+       if (!np) {
+               dev_err(&pdev->dev, "Please provide \"phy-handle\"\n");
+               return -ENODEV;
+       }
+
+       if (of_property_read_u32(np, "reg", &phy_id)) {
+               dev_err(&pdev->dev, "Failed to locate \"phy_id\"\n");
+               return -ENOENT;
+       }

And standard device tree bindings ?:

+    ethernet@80010000 {
+      compatible =3D "cirrus,ep9301-eth";
+      reg =3D <0x80010000 0x10000>;
+      interrupt-parent =3D <&vic1>;
+      interrupts =3D <7>;
+      phy-handle =3D <&phy0>;
+      mdio {
+        #address-cells =3D <1>;
+        #size-cells =3D <0>;
+        phy0: ethernet-phy@1 {
+          reg =3D <1>;
+          device_type =3D "ethernet-phy";
+        };
+      };
+    };


>=20
> =C2=A0=C2=A0=C2=A0 Andrew


