Return-Path: <netdev+bounces-4965-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7351870F612
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:18:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A97C12812E2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:18:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 615AA18004;
	Wed, 24 May 2023 12:17:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D008472
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:17:55 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E551135;
	Wed, 24 May 2023 05:17:53 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id E72F5820F2;
	Wed, 24 May 2023 14:17:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1684930671;
	bh=LkM/bZ9fUL4pshbM4qtC4eGKFgQaRWUq/wKzWk4QxFQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EO26svgA/TNan6SW6K/zaPBN71CX/OiBtClp1OaWhxTyddi86uSEAN0wEx81J93lR
	 tqxBe+7Kwwf8QFwbSvJBLNwbSVdgCojMGDmf0AJL9t8QSmHu6Wk+sncvfDwmZ+GXnE
	 NV+L9pp9cA+YnkTUUGf/3ROCJiHx2bzSUfmtxiSmlQ9MASE4dizH/OBqG/0wwKtX3U
	 PWrFwR+Ao3OqUOIlh5c80kumaVWuznGRPiRVL0g4IxDukfP5NdpnNn/K2flks10+Xn
	 ty9UV+NjtwvE5nN/XfwFNpJEDXxIWD1mGP5hNURQDC1kzSACVIHfPHul6Q7J2BKlCd
	 ayoNiCJUk5vlw==
Date: Wed, 24 May 2023 14:17:43 +0200
From: Lukasz Majewski <lukma@denx.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Vladimir Oltean <olteanv@gmail.com>, Russell King
 <linux@armlinux.org.uk>, Eric Dumazet <edumazet@google.com>, Florian
 Fainelli <f.fainelli@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Alexander Duyck <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] dsa: marvell: Add support for mv88e6071 and 6020
  switches
Message-ID: <20230524141743.1322c051@wsk>
In-Reply-To: <89fd3a8d-c262-46d8-98ad-c8dc04fe9d9c@lunn.ch>
References: <20230523142912.2086985-1-lukma@denx.de>
	<89fd3a8d-c262-46d8-98ad-c8dc04fe9d9c@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hxSIXto_jl.E+eAfLXTCiOR";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/hxSIXto_jl.E+eAfLXTCiOR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Tue, May 23, 2023 at 04:29:09PM +0200, Lukasz Majewski wrote:
> > After the commit (SHA1: 7e9517375a14f44ee830ca1c3278076dd65fcc8f);
> > "net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220,
> > 6250, 6290" the error when mv88e6020 or mv88e6071 is used is not
> > present anymore. =20
>=20
> >   dsa: marvell: Define .set_max_frame_size() function for mv88e6250
> > SoC family =20
>=20
> Hi Lukasz
>=20
> commit 7e9517375a14f44ee830ca1c3278076dd65fcc8f
> Author: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date:   Tue Mar 14 20:24:05 2023 +0200
>=20
>     net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220,
> 6250, 6290=20
>     There are 3 classes of switch families that the driver is aware
> of, as far as mv88e6xxx_change_mtu() is concerned:
>    =20
>     - MTU configuration is available per port. Here, the
>       chip->info->ops->port_set_jumbo_size() method will be present.
>    =20
>     - MTU configuration is global to the switch. Here, the
>       chip->info->ops->set_max_frame_size() method will be present.
>    =20
>     - We don't know how to change the MTU. Here, none of the above
> methods will be present.
>    =20
>     Switch families MV88E6165, MV88E6191, MV88E6220, MV88E6250 and
> MV88E6290 fall in category 3.
>=20
>=20
> Vladimir indicates here that it is not known how to change the max MTU
> for the MV88E6250. Where did you get the information from to implement
> it?

Please refer to [1].

The mv88e6185_g1_set_max_frame_size() function can be reused (as
registers' offsets and bits are the same for mv88e60{71|20}).

After using Vladimir's patch there is no need to add max_frame size
field and related patches from v6 can be dropped.

>=20
> 	Andrew


Links:

[1] - https://www.spinics.net/lists/kernel/msg4798861.html

Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/hxSIXto_jl.E+eAfLXTCiOR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmRuAGcACgkQAR8vZIA0
zr0mwwgAlLajNzPWKh8DfgQzUDlUa6AdtQ8/xbBwHVh2YdV34VJUPZGghWjSG3NJ
4YfP+YnsUdo7FnYRXHyqYel2X6fOR0wWo+VAlEDRk0VbIZyTmRh21eRm71zhz++1
IrgemMToB3XOsrvkHyicfQxGynRzvcsENoDW4aFDO/eFdDcFmtRf6Dw/AvMHmQIP
sUXPTxxZR8pGQpFnZZXslYs8P+0GJ/vAb8Ak61inDVMfZziphHUNlQYMuudKzkp7
EBf7KNWAN1jRGlXTMJqqYfuuvKM3sfRElfh75PjyPkFh61BvifuZ98QBkxkOdGXo
7ughGBgzF2phWJj1yZV/qjCDwis7nw==
=BRNr
-----END PGP SIGNATURE-----

--Sig_/hxSIXto_jl.E+eAfLXTCiOR--

