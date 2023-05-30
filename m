Return-Path: <netdev+bounces-6408-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC4E716327
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:08:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73FAF2811BA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C689821075;
	Tue, 30 May 2023 14:07:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63D521073
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:07:58 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34719E8;
	Tue, 30 May 2023 07:07:53 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 8732785F52;
	Tue, 30 May 2023 16:07:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685455671;
	bh=DxEeEwLI+riVU0nN82Dofb9kzcwsJO6WvuTfNK7QJ+I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VOtG3IcY80mysNE6AwRVh++cAWX+S/rFMGZRC34W6E3L1bh9tWOmtsf+gFtXgdp7r
	 7WqATGBTUlS+bp/V4WLdYzuWulSIaWCrrW4KCj1QnfwOnxcLETkIsY4nCqp1PNZz6v
	 EEMq8awIyqBr8JLt9Nm8L69jcU4gPDCpH5x9oWyTpk0QRITr42MGPFOVcqfuaDxuW4
	 Dlmd73wiZqTIML2z8R7e+YHhWc+eLDi1adn8alLL9++GsC5TcMDmpJKJhwsUgZnIR8
	 4XT2/5y9z5a7y/M6QcETrsdp473FxHyHa3PqGg0TwrpBx7oYX4MBRl/yciz3spESoD
	 9de0XsRxMu7Fg==
Date: Tue, 30 May 2023 16:07:43 +0200
From: Lukasz Majewski <lukma@denx.de>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <vivien.didelot@gmail.com>,
 Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>, Jakub
 Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <20230530160743.2c93a388@wsk>
In-Reply-To: <ZHXzTBOtlPKqNfLw@shell.armlinux.org.uk>
References: <20230530122621.2142192-1-lukma@denx.de>
	<ZHXzTBOtlPKqNfLw@shell.armlinux.org.uk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gukjY9rUgd.rLL7bPFTqt74";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/gukjY9rUgd.rLL7bPFTqt74
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russell,

> On Tue, May 30, 2023 at 02:26:21PM +0200, Lukasz Majewski wrote:
> > One can disable in device tree advertising of EEE capabilities of
> > PHY when 'eee-broken-100tx' property is present in DTS.
> >=20
> > With DSA switch it also may happen that one would need to disable
> > EEE due to some network issues.
> >=20
> > Corresponding switch DTS description:
> >=20
> >  switch@0 {
> > 	 ports {
> > 		port@0 {
> > 		reg =3D <0>;
> > 		label =3D "lan1";
> > 		phy-handle =3D <&switchphy0>;
> > 		};
> > 	}
> > 	mdio {
> > 		switchphy0: switchphy@0 {
> > 		reg =3D <0>;
> > 		eee-broken-100tx;
> > 	};
> > 	};
> >=20
> > This patch adjusts the content of MDIO_AN_EEE_ADV in MDIO_MMD_AN
> > "device" so the phydev->eee_broken_modes are taken into account
> > from the start of the slave PHYs. =20
>=20
> This should be handled by phylib today in recent kernels without the
> need for any patch (as I describe below, because the config_aneg PHY
> method should be programming it.) Are you seeing a problem with it
> in 6.4-rc?

Unfortunately, for this project I use LTS 5.15.z kernel.

My impression is that the mv88e6xxx driver is not handling EEE setup
during initialization (even with v6.4-rc).

I've tried to replace genphy_config_eee_advert() with phy_init_eee, but
it lacks the part to program PCS advertise registers.

>=20
> > As a result the 'ethtool --show-eee lan1' shows that EEE is not
> > supported from the outset.
> >=20
> > Questions:
> >=20
> > - Is the genphy_config_eee_advert() appropriate to be used here?
> >   As I found this issue on 5.15 kernel, it looks like mainline now
> > uses PHY features for handle EEE (but the aforementioned function
> > is still present in newest mainline - v6.4-rc1).
> >=20
> > - I've also observed strange behaviour for EEE capability register:
> >   Why the value in MDIO_MMD_PCS device; reg MDIO_PCS_EEE_ABLE is
> > somewhat "volatile" - in a sense that when I use:
> >   ethtool --set-eee lan2 eee off
> >=20
> >   It is cleared by PHY itself to 0x0 (from 0x2) and turning it on
> > again is not working.
> >=20
> >   Is this expected? Or am I missing something? =20
>=20
> No - this register is supposed to report the capabilities of the PHY,
> and bits 1..15 should be read-only, and as they report the
> capabilities they should be fixed. Writing to bit 1 of this register
> will therefore be ignored. It sounds like your PHY has some odd
> behaviour - maybe someone misinterpreted 802.3 45.2.3.9?
>=20

It is a good question. Or maybe after EEE disabling I read some wrong
data (however, up till this moment bit offsets and values seems
reasonable).

> > Signed-off-by: Lukasz Majewski <lukma@denx.de>
> > ---
> >  net/dsa/slave.c | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > index 353d8fff3166..712923c7d4e2 100644
> > --- a/net/dsa/slave.c
> > +++ b/net/dsa/slave.c
> > @@ -2247,6 +2247,7 @@ static int dsa_slave_phy_setup(struct
> > net_device *slave_dev) phylink_destroy(dp->pl);
> >  	}
> > =20
> > +	genphy_config_eee_advert(slave_dev->phydev); =20
>=20
> No network driver (which includes DSA) should be calling any function
> starting genphy_*. These functions are purely for phylib or phy
> drivers to use, and no one else.

As stated before, it looks like some PHY "update" in respect of EEE is
not done when DSA framework creates phydevs for slave ports.

>=20
> genphy_config_eee_advert() is a deprecated function (see commit
> 5827b168125d ("net: phy: c45: migrate to genphy_c45_write_eee_adv()")
> and thus should not be used.

Ok.

>=20
> genphy_c45_write_eee_adv() is called by
> genphy_c45_an_config_eee_aneg() which will in turn be called by
> genphy_config_aneg() for a clause 22 PHY, or by
> genphy_c45_an_config_aneg() for a clause 45 PHY. These will write the
> EEE advertisement mask to the PHY's AN MMD.
>=20

Ok.

> So, EEE should be handled by phylib according to the firmware
> settings.=20

I also would expect, that phy core code parses DTS properties and then
phydev->eee_broken_mode is used to mask EEE advertisement during PHY
initialization and startup.

> The only thing that network drivers that use phylib have to
> deal with is setting their hardware for the LPI timeout and
> enabling/disabling the timeout as necessary.
>=20

Yes. I do agree.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/gukjY9rUgd.rLL7bPFTqt74
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmR2Ay8ACgkQAR8vZIA0
zr0yNgf+MSmXQfSuHrYUlnCE2+UdHZnZS1IgUyT0DBnm7WkVggfh5/jWjgtlmkx7
glfhaJYQRXUR9OKDnagJdpPzw4yrkX1S3N+5bAkqnFWHEO7idNnY9pgd7OJXg84r
0p96obyfkIxpSjQXd1oBWFlrJ2rJjvMEougmQ9ANaZJajVmV80K1u3qgIiSDc0Va
0dB/oAmGSi6JRgcrs3EARuCPL3Gt0KRo2Z4OllbhcqDZ6+bTShYffqfnNuyhG83E
LRtpbgoLWqJsLTID4m1rfuo0hsrc06ewOuCeXdEDVO5P5Hm+f6VxrgxBpH6ymBm2
h/JuCiarOt2WxEO2UZnDawsCG20L5g==
=+NgL
-----END PGP SIGNATURE-----

--Sig_/gukjY9rUgd.rLL7bPFTqt74--

