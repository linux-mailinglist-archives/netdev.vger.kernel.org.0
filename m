Return-Path: <netdev+bounces-6040-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08F58714848
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:03:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23E85280D61
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 396763D9E;
	Mon, 29 May 2023 11:03:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29262A53
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 11:03:26 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F874DF;
	Mon, 29 May 2023 04:03:23 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 1775284775;
	Mon, 29 May 2023 13:03:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685358201;
	bh=GqokHjKP/g/o3iocPWhiRG0b1OMpUzny8buyeSDIlNw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yenk1p/F6BHYZeX892TJYfgx7a4wRneSJz8igBXw6l5Ot+ivz85zkiplG+5FXf3H7
	 UXw1oyRtiQJuR1ORNHcHfNTg6eUxcruo+W3zoaebHjOJU+bqh8KAifji7H3FI5C175
	 s2AZ1hzNvd+hlps9D41yPwcRnHpKky6/9DVEIs4GZmfe84Ix6msqcouQeh+UXsHE8W
	 CbJ4MY0haMyCPcF1iG2yLDl64drDnHf5attqwew26tC8h91dR7uS7LaxGp8ekE0lxc
	 ZOiqBPZED7VWghPwb77YdOwUyjhDQnMFAQMyeJwSggSOOqElwgs+SkNco6fDov6TNQ
	 hRDmsvfh31wvQ==
Date: Mon, 29 May 2023 13:03:14 +0200
From: Lukasz Majewski <lukma@denx.de>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>, Eric
 Dumazet <edumazet@google.com>, Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Alexander Duyck
 <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] dsa: marvell: Add support for mv88e6071 and 6020
 switches
Message-ID: <20230529130314.0d4c474e@wsk>
In-Reply-To: <20230529105132.h673mnjddubl7und@skbuf>
References: <20230523142912.2086985-1-lukma@denx.de>
	<20230529110222.68887a31@wsk>
	<20230529105132.h673mnjddubl7und@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wjR+okbr5dZj2MG3U4lC9KN";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/wjR+okbr5dZj2MG3U4lC9KN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> Hello Lukasz,
>=20
> On Mon, May 29, 2023 at 11:02:22AM +0200, Lukasz Majewski wrote:
> > Dear All,
> >  =20
> > > After the commit (SHA1: 7e9517375a14f44ee830ca1c3278076dd65fcc8f);
> > > "net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220,
> > > 6250, 6290" the error when mv88e6020 or mv88e6071 is used is not
> > > present anymore.
> > >  =20
> >=20
> > Are there any more comments for this patch set? =20
>=20
> Has your email client eaten these comments too?
>=20
> https://lore.kernel.org/netdev/c39f4127-e1fe-4d38-83eb-f372ca2ebcd3@lunn.=
ch/
> | On Wed, May 24, 2023 at 03:48:02PM +0200, Andrew Lunn wrote:
> | > > > Vladimir indicates here that it is not known how to change
> the max MTU | > > > for the MV88E6250. Where did you get the
> information from to implement | > > > it?
> | > >=20
> | > > Please refer to [1].
> | > >=20
> | > > The mv88e6185_g1_set_max_frame_size() function can be reused (as
> | > > registers' offsets and bits are the same for mv88e60{71|20}).
> | >=20
> | > So you have the datasheet? You get the information to implement
> this | > from the data sheet?
> | >=20

This I've replied to Andrew in a private mail.

> | >      Andrew
>=20
> https://lore.kernel.org/netdev/ZG4E+wd03cKipsib@shell.armlinux.org.uk/
> | On Wed, May 24, 2023 at 01:37:15PM +0100, Russell King (Oracle)
> wrote: | > On Wed, May 24, 2023 at 02:17:43PM +0200, Lukasz Majewski
> wrote: | > > Please refer to [1].
> | > >=20
> | > > The mv88e6185_g1_set_max_frame_size() function can be reused (as
> | > > registers' offsets and bits are the same for mv88e60{71|20}).
> | > >=20
> | > > After using Vladimir's patch there is no need to add max_frame
> size | > > field and related patches from v6 can be dropped.
> | >=20
> | > However, you haven't responded to:
> | >=20
> | >
> https://lore.kernel.org/all/ZGzP0qEjQkCFnXnr@shell.armlinux.org.uk/ |
> > | > to explain why what you're doing (adding this function) is safe.
> | >=20
> | > Thanks.
> | >=20

The above question has been replied:
https://lore.kernel.org/all/20230524145357.3928f261@wsk/

> | > --=20
> | > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> | > FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

Do you have any more comments?


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/wjR+okbr5dZj2MG3U4lC9KN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmR0hnIACgkQAR8vZIA0
zr3phggAnR4vPpm7QoDvoYhqmbZqP8NmH+Xwb+XojKe9MRSSCQr0CcH/uF0+9dqm
H+b88EW66uMrlN9PmQDrK6gelrzMO2qqILFCE4IYTLlJtlBbMxcn5fxyNqHx6HWe
tSy8aiVywTW+++Rtrkp4lPDhNjV9aBiqudyPWPTYVsvCkWQPxVtsUdHXEvIOJQRZ
cWzfyKrjOrR6RAIDvdQPsRrS0GSrPnQQRv1SsPYwRMzK5QOUpc8QHw9WU0M2XIUg
rLV22gdtVstZIg+6HC8eM6mHtquJHJ7kfH008JTj5AIqkLgwe7Fs2CiaYLGnNOaW
u2dHQC/uo9/7bRdir3xfOlZAelZ5FA==
=ffyA
-----END PGP SIGNATURE-----

--Sig_/wjR+okbr5dZj2MG3U4lC9KN--

