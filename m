Return-Path: <netdev+bounces-6443-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 038CD7164BE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:47:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 990F51C20BAF
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 428CA1F177;
	Tue, 30 May 2023 14:47:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B6D1F164
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:47:37 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703A4C5;
	Tue, 30 May 2023 07:47:35 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id AEA8284726;
	Tue, 30 May 2023 16:47:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685458053;
	bh=RP5mZjYaDjVA5mhz0Ff8ESEjp4pyJWEbkoKv35RFyzU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=A9x9UtivGCTKaN8Cq9EdEGxj3DsQ2nr58U/pJ0t7xlobllwQ8xLxApN63q4T2JaC2
	 GDgpd8+b38OZNN3EgxoYglg21vlST2NbXaSve7x7jXscBlyRSinXPr2e4hH9ydKq2R
	 0+C5ba94FKhaVQaac4AFSLqy3UrUb7q5YFFxbeLLFSe7M0wYF8ArF+eIUnOyba5Znz
	 iNqmrQGv8m/5U9INiglzm5OWcZnJzdXQwjF3SyplT7qg8TpFHBBjGgsc8SpJjw5BQr
	 Tns0LGxRQaKopm+4A5NRtOk7Bx128q/GTMKn+hv2LSMqRG4MTnXzOrsC9NSc7sgLUq
	 +ib4GdM7LcsMw==
Date: Tue, 30 May 2023 16:47:31 +0200
From: Lukasz Majewski <lukma@denx.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, Vivien Didelot
 <vivien.didelot@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <20230530164731.0b711649@wsk>
In-Reply-To: <35546c34-17a6-4295-b263-3f2a97d53b94@lunn.ch>
References: <20230530122621.2142192-1-lukma@denx.de>
	<ZHXzTBOtlPKqNfLw@shell.armlinux.org.uk>
	<20230530160743.2c93a388@wsk>
	<ZHYGv7zcJd/Ad4hH@shell.armlinux.org.uk>
	<35546c34-17a6-4295-b263-3f2a97d53b94@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/l7qCvXq/FTQDT3bLEkM2sDq";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/l7qCvXq/FTQDT3bLEkM2sDq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > So, I'm wondering what's actually going on here... can you give
> > any more details about the hardware setup? =20
>=20
> And what switch it actually is.

It is mv88e6071.

> I've not looked in too much detail,
> but i think different switch families have different EEE capabilities.

Yes, some (like b53) have the ability to disable EEE in the HW.

The above one from Marvell seems to have EEE always enabled (in silicon)
and the only possibility is to not advertise it [*].

> But in general, as Russell pointed out, there is no MAC support for
> EEE in the mv88e6xxx driver.

I may be wrong, but aren't we accessing this switch PHYs via c45 ?
(MDIO_MMD_PCS devices and e.g. MDIO_PCS_EEE_ABLE registers)?

>=20
>     Andrew


[*] - maybe it is possible via some "reserved" registers. However,
there are "register pages" for EEE, which allow tuning timers.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/l7qCvXq/FTQDT3bLEkM2sDq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmR2DIMACgkQAR8vZIA0
zr3AjAgAtbAzj9ESVpzSo3QNSuO9KOphrBagbND3PolryZptPV6XhIg2jqxqLM+q
zN4Di8DnRtkQ2CuD9pVUd2iACa+CKQy6Q/tOhAWdi1XH13+Iblovy4w/hSBDoOgu
uXdGc+ps4cnmfPI60/9CT6BtbXNDwWM4egt9F9WqOA4PHR3CPurUfzd16U76Qtyn
r3XkhYx3R1TuJQ3SMhWu4l9d/XAxO6f1HwqeRdmN6r8ylqReaQ9+m/BlKtlRMKjG
ID3DhH0BJOmjr8WTe33PeJPzFDiqbt0GA80ycU7TRSjgNLNzUyy2JcGQ2QWZ9Y0B
yYQuE4NB02vYFLeHdENRCTG9Pw/5mg==
=JV1w
-----END PGP SIGNATURE-----

--Sig_/l7qCvXq/FTQDT3bLEkM2sDq--

