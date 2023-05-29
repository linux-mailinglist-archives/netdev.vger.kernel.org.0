Return-Path: <netdev+bounces-6029-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D5597146CC
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A6E6280E41
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 09:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43A2946A3;
	Mon, 29 May 2023 09:02:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C697C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 09:02:34 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8A19C;
	Mon, 29 May 2023 02:02:32 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 8D4DE8215F;
	Mon, 29 May 2023 11:02:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685350950;
	bh=mxJF2rG5NfRMzs/sH8AlTVnhuq4+7EmqGbtNevuhHVo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Dgur7oJ2vNQoyn035H2miR5nccnQyt6Q5cykwTca2kxWsdJ40NrWi+tMXs6/kPdJ8
	 sXgaI6ddVy2fXuJx66X3aqOaDL3l9EFkoGm5UVb+yK2VgSErGjv5pHaK0hVYbnAdnr
	 VWi2dX1EUHxXMhE3HgjorWMeMkhvC6UMuOdgYVpI1LdoIf3uhl7nsqWrEuW4VLr3j/
	 aE8o7fWTXR2oTmJsK/KWoJjEoM9xB6AX4IZq3tG1xA4k7x04vcoQ6d9NV4jWnFgJ+g
	 /cETUgvGNa+QscPzpDZwjXTe2dQE+fmTRpG/vh4jIsnu9Ycs6TIE+vDbUNUB5ZXx+X
	 n5WHrHjvJtUaw==
Date: Mon, 29 May 2023 11:02:22 +0200
From: Lukasz Majewski <lukma@denx.de>
To: Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
 Russell King <linux@armlinux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>, Florian Fainelli
 <f.fainelli@gmail.com>, "David S. Miller" <davem@davemloft.net>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Alexander
 Duyck <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] dsa: marvell: Add support for mv88e6071 and 6020
  switches
Message-ID: <20230529110222.68887a31@wsk>
In-Reply-To: <20230523142912.2086985-1-lukma@denx.de>
References: <20230523142912.2086985-1-lukma@denx.de>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6859To1L./u.yFDOGr/r6d/";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/6859To1L./u.yFDOGr/r6d/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Dear All,

> After the commit (SHA1: 7e9517375a14f44ee830ca1c3278076dd65fcc8f);
> "net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250,
> 6290" the error when mv88e6020 or mv88e6071 is used is not present
> anymore.
>=20

Are there any more comments for this patch set?

> As a result patches for adding max frame size are not required to
> provide working setup with aforementioned switches.
>=20
> Lukasz Majewski (2):
>   dsa: marvell: Define .set_max_frame_size() function for mv88e6250
> SoC family
>   net: dsa: mv88e6xxx: add support for MV88E6071 switch
>=20
> Matthias Schiffer (1):
>   net: dsa: mv88e6xxx: add support for MV88E6020 switch
>=20
>  drivers/net/dsa/mv88e6xxx/chip.c | 41
> ++++++++++++++++++++++++++++++++ drivers/net/dsa/mv88e6xxx/chip.h |
> 2 ++ drivers/net/dsa/mv88e6xxx/port.h |  2 ++
>  3 files changed, 45 insertions(+)
>=20




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/6859To1L./u.yFDOGr/r6d/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmR0ah4ACgkQAR8vZIA0
zr2cvwgAh8ek05WoONQVlzY2ZyyfV1amhPpaiFIZkyARjxOyX00Yi9YnATsaTgim
lZNnQ8+zGAQf8+f2HPml3GtqV0kvzp99ttOrQrgMRQXRrv/wBqAhJbG7mBnKBu9n
WIW3vyvhqKwHZ9yVMWQqe2DwcmmiOh2GUSY9VQ6T6A9hhdLQw3nv0BjMWBaF5hjU
RoVK4quZ/yBFvEDjvCfGkB/YUxlkSdb0eP74MTuAhb9aoo7mx5iPyP/KusWGFChO
teiXEvuVr6EuNP600veWPnj5nlJu3ScNjZaHjnY3w/xOoTLG/33t41AVSIq0tGCE
25iIsF2I6mrs1RlpQ5cXrTr5wvCWDQ==
=LQIc
-----END PGP SIGNATURE-----

--Sig_/6859To1L./u.yFDOGr/r6d/--

