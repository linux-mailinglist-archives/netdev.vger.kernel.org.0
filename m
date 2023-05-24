Return-Path: <netdev+bounces-5014-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F94E70F6FA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4214281250
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B1FD6085D;
	Wed, 24 May 2023 12:54:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511F1C8D1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:54:11 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F1BB3;
	Wed, 24 May 2023 05:54:08 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 0F1DD846D0;
	Wed, 24 May 2023 14:54:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1684932846;
	bh=QCzzfgmG63M1/pMaqaQDNZHc9acw3p1qR4deDjnJaWk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xiWz6z0znNdLTbyvr7JrtI/UgV0NZuXtyZ0zuxuVJV/JpWmbE6ZrsZ4/8IssnHagv
	 BP1M+pO9gwy4tQVYY/n2dSQCaC6jv196Lt6KGBTckYyaorRMlzxBYSQGg4yD5h/b/8
	 wE9LOWM05UXyfCNr+9xASFfvn/JrVTAsMIu4dW+cTKnzo/Tztb8rqVarKjIcSG5huD
	 1xpz3u+vD8Sd3j7wbtGtUR0tieu5JiLxy7NzmEQKDijtJknTTShuKQ7Z2OPP3cq5/N
	 5/TKvfrdd3x3vUz8QvoFqfhP2D/5ugbA6nEvy8LxTBgZCxnV1CzB3DIjY3E/41IBqZ
	 9SJPCPqgaBO9g==
Date: Wed, 24 May 2023 14:53:57 +0200
From: Lukasz Majewski <lukma@denx.de>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>, Eric
 Dumazet <edumazet@google.com>, Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Alexander Duyck
 <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] dsa: marvell: Define .set_max_frame_size()
 function for mv88e6250 SoC family
Message-ID: <20230524145357.3928f261@wsk>
In-Reply-To: <ZGzP0qEjQkCFnXnr@shell.armlinux.org.uk>
References: <20230523142912.2086985-1-lukma@denx.de>
	<20230523142912.2086985-2-lukma@denx.de>
	<ZGzP0qEjQkCFnXnr@shell.armlinux.org.uk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/p9zgazvQbjRB1YLmCGCtI4O";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/p9zgazvQbjRB1YLmCGCtI4O
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russell,

> On Tue, May 23, 2023 at 04:29:10PM +0200, Lukasz Majewski wrote:
> > Switches from mv88e6250 family (the marketing name - "Link Street",
> > including mv88e6020 and mv88e6071) need the possibility to setup the
> > maximal frame size, as they support frames up to 2048 bytes.
> >=20
> > Signed-off-by: Lukasz Majewski <lukma@denx.de> =20
>=20
> Adding this function doesn't allow the "possibility" for a larger
> frame size. Adding it changes the value returned from
> mv88e6xxx_get_max_mtu() to be a larger frame size, so all switches
> that make use of mv88e6250_ops will be expected to support this
> larger frame size. Do we know whether that is true?
>=20

According to functional specification - the 6070, 6071, 6250, 6020 and
6220 have "Max Frame Size" of 2048 bytes.

The mv88e6xxx_get_max_mtu() now will:
return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;

which is acceptable and safe for this family of chips.

> There were patches floating about a while ago that specified the
> maximum size in struct mv88e6xxx_info, but it seems those died a
> death.
>=20

Those patches seems to not be strictly required after Vladimir's work.

The v7 provides what I need, so yes - extra patches from v6 can be
discarded.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/p9zgazvQbjRB1YLmCGCtI4O
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmRuCOUACgkQAR8vZIA0
zr2l0wgAgnNNE4xRUMWkg3oPVg2EE/NLMbmfCovQjXUb91E/5mpvsko3w7HmZ0A3
UE2gXcqs5+KQpv969efpYlya8PIMfPXxh8LiBIa1v3iRT9UuY2HBIx8LpPRiPvax
V/2JXf0kqwkS7hbL2pU/bDj32Pm/KjfIpcIjG0ruicXlCv7VNdPXLQgj2pLmfffC
+1WMw6W+ivZ5PAHQPfsDSmJuQQ1MOAi87OSksZ+OpviD3ff5rCIl2MOcPP2ElAmH
UVDXqeCq9M5dHPb2Gz30t1L1WaCcx1yzxyiW6k19SQV5M48nXXRAxxv1U+4sETSM
jW3tmUfFEaTdkCg1bV5ByT20RnAZEg==
=kcsj
-----END PGP SIGNATURE-----

--Sig_/p9zgazvQbjRB1YLmCGCtI4O--

