Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C985F16A564
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 12:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgBXLpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 06:45:35 -0500
Received: from foss.arm.com ([217.140.110.172]:35818 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbgBXLpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 06:45:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 12FB530E;
        Mon, 24 Feb 2020 03:45:34 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 66C063F534;
        Mon, 24 Feb 2020 03:45:33 -0800 (PST)
Date:   Mon, 24 Feb 2020 11:45:32 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Piotr Sroka <piotrs@cadence.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Olivier Moysan <olivier.moysan@st.com>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] docs: dt: fix several broken doc references
Message-ID: <20200224114532.GC6215@sirena.org.uk>
References: <0e530494349b37eb2eab4a8eccf56626e0b18e6d.1582448388.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
In-Reply-To: <0e530494349b37eb2eab4a8eccf56626e0b18e6d.1582448388.git.mchehab+huawei@kernel.org>
X-Cookie: How you look depends on where you go.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 23, 2020 at 09:59:53AM +0100, Mauro Carvalho Chehab wrote:
> There are several DT doc references that require manual fixes.
> I found 3 cases fixed on this patch:
>=20
> 	- directory named "binding/" instead of "bindings/";
> 	- .txt to .yaml renames;
> 	- file renames (still on txt format);

This seems like it should've been split up a bit.  :/

Acked-by: Mark Brown <broonie@kernel.org>

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5Tt1sACgkQJNaLcl1U
h9CeXgf/ee/xxhTgqVSMNL+gDYl+cgPqn0CVS5ynzTQm6XlCEEXDBneO8oAyMs9Q
B35qG/r62a8QVrA/l3LzqVMhLlv8zL4iGOheD5+eZ6gHnMv7lPajWNmGOfnMJd9H
UKLDbTT2i5G+9z8eCMtms1XURh+HwDOazAYv0AivApzVodTmO2psgQP1QLL2OzJL
LPC4wm0qrtgar4rno/OfhGR/wyJfJKLE7MqnJ73wcaO5fZ48mtXx0mZwh3aJqtxe
3inu1PkxuHNSlxEIMHFKg8Tvg/cGD1vngJEwsEZ8AJ+bTOcI8HX+goLuAyNwTG6F
VynhL1Jdiscm+V62nRat6prHHhzWBw==
=WoRy
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
