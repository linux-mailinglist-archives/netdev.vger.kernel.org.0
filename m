Return-Path: <netdev+bounces-6726-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E1F2717A67
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:44:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3EF6281453
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65E7847C;
	Wed, 31 May 2023 08:44:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E4879D7
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:44:19 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CA91AE;
	Wed, 31 May 2023 01:43:56 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 113F8861A8;
	Wed, 31 May 2023 10:43:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685522634;
	bh=j1UsfRe3ZI+3excUqUKbxozkjP+PYiTcZH3jP+0A9qg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Zn6t37LT/Na5zyk2YLQwzjQErfPrqnJhJglAiEdqIQgoqLARHuhjsOGsUXYtQZMds
	 aXWFx2qxyPwOJofdYKFkplkFU9ZLkcIvoBOY0EAXtC5Q2qZwVtktA7gLWTQgF+eYqP
	 JhYKmvP/RkxQ3wsKvsdxSPZB4EM6RpnmEirpqiXFC4Qbwr/bIQ3pIdpUL8nyHQVDsz
	 XTfsQ9sAE+FM3IazT1SWXT7+E8pjO68a/jYBqIC6Hw1aB05JecsKNULisURUXwRvXX
	 TCqf17iKs6p8JTMFhDIfdIbr6LmYViEQwHkCbKUOKpgf25eUGOCti6BQHnLWaABPl4
	 ZMvwN0L8PVr2A==
Date: Wed, 31 May 2023 10:43:46 +0200
From: Lukasz Majewski <lukma@denx.de>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <vivien.didelot@gmail.com>,
 Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>, Jakub
 Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <20230531104346.2a131c42@wsk>
In-Reply-To: <ZHYRgIb6UCYq1n/Z@shell.armlinux.org.uk>
References: <20230530122621.2142192-1-lukma@denx.de>
	<ZHXzTBOtlPKqNfLw@shell.armlinux.org.uk>
	<20230530160743.2c93a388@wsk>
	<ZHYGv7zcJd/Ad4hH@shell.armlinux.org.uk>
	<35546c34-17a6-4295-b263-3f2a97d53b94@lunn.ch>
	<20230530164731.0b711649@wsk>
	<ZHYRgIb6UCYq1n/Z@shell.armlinux.org.uk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/h3oACLcYM6yL5d120wOvs.Q";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/h3oACLcYM6yL5d120wOvs.Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russell,

> On Tue, May 30, 2023 at 04:47:31PM +0200, Lukasz Majewski wrote:
> > Hi Andrew,
> >  =20
> > > > So, I'm wondering what's actually going on here... can you give
> > > > any more details about the hardware setup?   =20
> > >=20
> > > And what switch it actually is. =20
> >=20
> > It is mv88e6071.
> >  =20
> > > I've not looked in too much detail,
> > > but i think different switch families have different EEE
> > > capabilities. =20
> >=20
> > Yes, some (like b53) have the ability to disable EEE in the HW.
> >=20
> > The above one from Marvell seems to have EEE always enabled (in
> > silicon) and the only possibility is to not advertise it [*]. =20
>=20
> Right, and that tells the remote end "we don't support EEE" so the
> remote end should then disable EEE support.
>=20
> Meanwhile the local MAC will _still_ signal LPI towards its PHY. I
> have no idea whether the PHY will pass that LPI signal onwards to
> the media in that case, or if it prevents entering low power mode.
>=20
> It would be interesting to connect two of these switches together,
> put a 'scope on the signals between the PHY and the media isolation
> transformer, and see whether it's entering low power mode,
> comparing when EEE is successfully negotiated vs not negotiated.
>=20
> My suspicion would be that in the case where the MAC always signals
> LPI to the PHY, the result of negotiation won't make a blind bit of
> difference.
>=20
> > > But in general, as Russell pointed out, there is no MAC support
> > > for EEE in the mv88e6xxx driver. =20
> >=20
> > I may be wrong, but aren't we accessing this switch PHYs via c45 ?
> > (MDIO_MMD_PCS devices and e.g. MDIO_PCS_EEE_ABLE registers)? =20
>=20
> As I've said - EEE is a MAC-to-MAC thing. The PHYs do the capability
> negotiation and handle the media dependent part of EEE. However, it's
> the MACs that signal to the PHY "I'm idle, please enter low power
> mode" and when both ends that they're idle, the media link only then
> drops into low power mode. This is the basic high-level operation of
> EEE in an 802.3 compliant system.
>=20
> As I've also said, there are PHYs out there which do their own thing
> as an "enhancement" to allow MACs that aren't EEE capable to gain
> *some* of the power savings from EEE (and I previously noted one
> such example.)
>=20
> The PHY EEE configuration is always done via Clause 45 - either
> through proper clause 45 cycles on the MDIO bus, or through the MMD
> access through a couple of clause 22 registers. There aren't the
> registers in the clause 22 address space for EEE.
>=20
> The MDIO_PCS_EEE_ABLE registers describe what the capabilities of the
> PHY is to the management software (in this case phylib). These are not
> supposed to change. The advertisements are programmed via the
> autonegotiation MMD register set. There's some additional
> configuration bits in the PHY which control whether the clock to the
> MAC is stopped when entering EEE low-power mode.
>=20
> However, even with all that, the MAC is still what is involved in
> giving the PHY permission to enter EEE low-power mode.
>=20
> The broad outline sequence in an 802.3 compliant setup is:
>=20
> - Whenever the MAC sends a packet, it resets the LPI timer.
> - When LPI timer expires, MAC signals to PHY that it can enter
>   low-power mode.
> - When the PHY at both ends both agree that they have permission from
>   their respective MACs to enter low power mode, they initiate the
>   process to put the media into low power mode.
> - If the PHY has been given permission from management software to
> stop clock, the PHY will stop the clock to the MAC.
> - When the MAC has a packet to send, the MAC stops signalling
> low-power mode to the PHY.
> - The PHY restores the clock if it was stopped, and wakes up the link,
>   thereby causing the remote PHY to also wake up.
> - Normal operation resumes.
>=20
> 802.3 EEE is not a PHY-to-PHY thing, it's MAC-to-MAC.
>=20

Thanks for the detailed explanation.

With "switch" setup - where I do have MAC from imx8 (fec driver)
connected to e.g. mv88e6071 with "fixed-link", I do guess that the EEE
management is done solely in mv88e6071?

In other words - the mv88e6071 solely decides if its internal PHY shall
signal EEE to the peer switch.

Just for the record - the mv88e6071 has a "register space" where one
can tune assertion and wakeup timers. Unfortunately, there is no "bit"
setting to disable EEE in the HW.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/h3oACLcYM6yL5d120wOvs.Q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmR3CMIACgkQAR8vZIA0
zr0X5QgA5fMzeLSa4Fp2TNDYy79aUK9AOvRk2YITSAdUBD6cv5lF7ZZqhoPW1GJV
VEfOnLNDo7hxS5uV3ghok5XFs24Xkyuf/hVL7SF8J57lxfeQV+kzFXe1vs2PgTO9
rITCKZqOSaXGxA5pntrqZValme8isUrqB9CMiPJZ1TUsG1qr9ttK6cUKWj6LW0mF
PNsWfsvyv6WVZngOE20ZLluNs2fFW2RiYSEPC8EUKPBgjSGijFoQeQLUawOzm46Y
wkT+z19qlNgzNjSdoYRh2lK9z7gLyypnA3qyeFQpbv0VZ9PkYOekQfLLo29Zb7z6
SxklIVMZvy5EblQuwRbggw+Ew8H2MQ==
=ewf0
-----END PGP SIGNATURE-----

--Sig_/h3oACLcYM6yL5d120wOvs.Q--

