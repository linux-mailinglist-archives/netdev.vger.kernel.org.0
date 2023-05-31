Return-Path: <netdev+bounces-6722-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E36F37179C1
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:16:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A1A91C20DDA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35983BE5A;
	Wed, 31 May 2023 08:16:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29533BA2B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:16:46 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47ED8C5;
	Wed, 31 May 2023 01:16:44 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id D03D78611C;
	Wed, 31 May 2023 10:16:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685521002;
	bh=QIT5LdXsd38HnT1gObrlKAjLGwfJ/Ui3fx46NLLUQac=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VP3Jvfbn0rOgAcsX3fMnSgyQSUENXDYAJZf6G8CTfx23vjm6uxde16oYHDfltQ664
	 phmfrjyQlGyR/aq9xBFhtNe324WFfgVbHgjGAtRgBVr26dm6jl265cD3QLg5tJmDfR
	 Gt+JeDI6RdWHvgwVK0A0wKWevIfr3P6e73kVDBIPrNgwlYUE2wHDXEe4jXr9ERoDXw
	 UbtDXGFtHn4ZsHm6vrcZrDIO7lXgBvRegVyV3K3WcC/ShbEZVZsWKofiaJyRR+suqW
	 DpFosSbZF8pg3AeHIEA+gtFKaoWOTGI+V0h7KNVqRNILd8mqRi2bDW6KounbNkC5vf
	 +va52tIB45TGQ==
Date: Wed, 31 May 2023 10:16:40 +0200
From: Lukasz Majewski <lukma@denx.de>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <vivien.didelot@gmail.com>,
 Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>, Jakub
 Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <20230531101640.131fe934@wsk>
In-Reply-To: <ZHYLNGkG26QP/QAS@shell.armlinux.org.uk>
References: <20230530122621.2142192-1-lukma@denx.de>
	<ZHXzTBOtlPKqNfLw@shell.armlinux.org.uk>
	<20230530160743.2c93a388@wsk>
	<ZHYGv7zcJd/Ad4hH@shell.armlinux.org.uk>
	<35546c34-17a6-4295-b263-3f2a97d53b94@lunn.ch>
	<ZHYLNGkG26QP/QAS@shell.armlinux.org.uk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Kl0N1N7kWlpAgVWt2ktIom0";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/Kl0N1N7kWlpAgVWt2ktIom0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russell,

> On Tue, May 30, 2023 at 04:26:49PM +0200, Andrew Lunn wrote:
> > > So, I'm wondering what's actually going on here... can you give
> > > any more details about the hardware setup? =20
> >=20
> > And what switch it actually is. I've not looked in too much detail,
> > but i think different switch families have different EEE
> > capabilities. But in general, as Russell pointed out, there is no
> > MAC support for EEE in the mv88e6xxx driver. =20
>=20
> ... except for the built-in PHYs,

This is my case.

> which if they successfully negotiate
> EEE, that status is communicated back to the MAC in that one sees
> MV88E6352_PORT_STS_EEE

I cannot find this register in my documentation.

> set, which results in the MAC being able to
> signal LPI to the PHY... and I've stuck a 'scope on the PHY media-side
> signals in the past and have seen that activity does stop without
> there needing to be any help from the driver for this.
>=20
> At least reading the information I have for the 88E6352, there is no
> configuration of LPI timers, nor any seperate LPI enable. If EEE is
> enabled at the MAC, then LPI will be signalled according to whatever
> Marvell decided would be appropriate.

And this knowledge is not disclosed to public.

>=20
> For an external PHY that the PPU is not polling, the only way that
> we'd have EEE functional is if we forced EEE in port control register
> 1 on switches that support those bits. In other words setting both the
> EEE and FORCE_EEE bits...
>=20

Are those bits available in c45 standard? Or are they SoC (IC) specific?

In my case I do have only two c45 registers disclosed (i.e. described)
for mv88e6071 SoC in the documentation.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/Kl0N1N7kWlpAgVWt2ktIom0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmR3AmgACgkQAR8vZIA0
zr2vgAf/TPyuqCpXqy8OzcsofOh15TCYmLibHnjTznVps7GTT0zuwuoH9wWaif7E
bUgJEGjaKr3yNTonliDF1C7rfuP7n6YwGhwIFEf5oyU1uN+ELTWPy9EqUplbE3oM
MIl9KnPc0vqV5MFweT6OLUZeacklzCsRGAyNmcchlLx2h+9jTXKosXevBroYmyIe
FuV5nMr/yJkR6hXXwQi+YiuavL0LttUx/z2Q3co2FWfuZiYqv3dZHr7MgbTiQIOk
P+JSwlPOOz0n97h5ktJCclxHuAU+SPf3GbYs4f4lHnLFVKGJQwf4HQW7Cp6qdBIJ
r4FYxEmTNTygcOj2ntB3/YXUpgFscw==
=TFoU
-----END PGP SIGNATURE-----

--Sig_/Kl0N1N7kWlpAgVWt2ktIom0--

