Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB15041C143
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237806AbhI2JGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244898AbhI2JGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 05:06:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F01EC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 02:04:39 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mVVVX-0003JP-91; Wed, 29 Sep 2021 11:04:07 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mVVVS-0004kK-3w; Wed, 29 Sep 2021 11:04:02 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mVVVS-0000V5-1n; Wed, 29 Sep 2021 11:04:02 +0200
Date:   Wed, 29 Sep 2021 11:04:01 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        oss-drivers@corigine.com, Paul Mackerras <paulus@samba.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Ido Schimmel <idosch@nvidia.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Vadym Kochan <vkochan@marvell.com>, Michael Buesch <m@bues.ch>,
        Jiri Pirko <jiri@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        Oliver O'Halloran <oohall@gmail.com>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 4/8] PCI: replace pci_dev::driver usage that gets the
 driver name
Message-ID: <20210929090401.qvpjng3jne76o6kw@pengutronix.de>
References: <20210927204326.612555-1-uwe@kleine-koenig.org>
 <20210927204326.612555-5-uwe@kleine-koenig.org>
 <20210928100127.GA16801@corigine.com>
 <20210928103129.c3gcbnfbarezr3mm@pengutronix.de>
 <20210929080541.GA13506@corigine.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ey4ikhdxthigr5cx"
Content-Disposition: inline
In-Reply-To: <20210929080541.GA13506@corigine.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ey4ikhdxthigr5cx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Simon,

On Wed, Sep 29, 2021 at 10:05:42AM +0200, Simon Horman wrote:
> On Tue, Sep 28, 2021 at 12:31:29PM +0200, Uwe Kleine-K=F6nig wrote:
> > On Tue, Sep 28, 2021 at 12:01:28PM +0200, Simon Horman wrote:
> > > On Mon, Sep 27, 2021 at 10:43:22PM +0200, Uwe Kleine-K=F6nig wrote:
> > > > From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > > >=20
> > > > struct pci_dev::driver holds (apart from a constant offset) the same
> > > > data as struct pci_dev::dev->driver. With the goal to remove struct
> > > > pci_dev::driver to get rid of data duplication replace getting the
> > > > driver name by dev_driver_string() which implicitly makes use of st=
ruct
> > > > pci_dev::dev->driver.
> > > >=20
> > > > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > >=20
> > > ...
> > >=20
> > > > diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b=
/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > > > index 0685ece1f155..23dfb599c828 100644
> > > > --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > > > +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > > > @@ -202,7 +202,7 @@ nfp_get_drvinfo(struct nfp_app *app, struct pci=
_dev *pdev,
> > > >  {
> > > >  	char nsp_version[ETHTOOL_FWVERS_LEN] =3D {};
> > > > =20
> > > > -	strlcpy(drvinfo->driver, pdev->driver->name, sizeof(drvinfo->driv=
er));
> > > > +	strlcpy(drvinfo->driver, dev_driver_string(&pdev->dev), sizeof(dr=
vinfo->driver));
> > >=20
> > > I'd slightly prefer to maintain lines under 80 columns wide.
> > > But not nearly strongly enough to engage in a long debate about it.
> >=20
> > :-)
> >=20
> > Looking at the output of
> >=20
> > 	git grep strlcpy.\*sizeof
> >=20
> > I wonder if it would be sensible to introduce something like
> >=20
> > 	#define strlcpy_array(arr, src) (strlcpy(arr, src, sizeof(arr)) + __mu=
st_be_array(arr))
> >=20
> > but not sure this is possible without a long debate either (and this
> > line is over 80 chars wide, too :-).
>=20
> My main motivation for the 80 char limit in nfp_net_ethtool.c is
> not that I think 80 char is universally a good limit (although that is tr=
ue),
> but rather that I expect that is the prevailing style in nfp_net_ethtool.=
c.

I sent out v5 with an additional line break now.
=20
> So a macro more than 80 car wide somewhere else is fine by me.
>=20
> However, when running checkpatch --strict over the patch it told me:
>=20
>     WARNING: Prefer strscpy over strlcpy - see: https://lore.kernel.org/r=
/CAHk-=3DwgfRnXz0W3D37d01q3JFkr_i_uTL=3DV6A6G1oUZcprmknw@mail.gmail.com/
>     #276: FILE: drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c:205:
>     +	strlcpy(drvinfo->driver, dev_driver_string(&pdev->dev), sizeof(drvi=
nfo->driver));
>=20
>     total: 0 errors, 1 warnings, 0 checks, 80 lines checked
>=20
> (Amusingly, more text wider than 80 column, perhaps suggesting the folly =
of
>  my original comment, but lets move on from that.)
>=20
> As your patch doesn't introduce the usage of strlcpy() I was considering a
> follow-up patch to change it to strscpy(). And in general the email at the
> link above suggests all usages of strlcpy() should do so. So perhaps
> creating strscpy_array is a better idea?

What I read about strscpy() is that conversions for the sake of the
conversion are not welcome. When such a conversion comes from someone
involved with the driver that is also tested this is probably fine.
=20
> I have not thought about this much, and probably this just leads us to a
> deeper part of the rabbit hole.

I assume so, too.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--ey4ikhdxthigr5cx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFUK/8ACgkQwfwUeK3K
7AlkTwf/dkfubvexEL8hKb2Rh3bCdHj1QQgkHxBsDLSNCo4lhj+H8iJlt8IyS3H8
+XjgTjDp2XDrOSbFVQug/BYE5Wk94BoOdy/6cprREtPJZ4oI3QgdaaikCtG1CdwW
KzFBUgIiRQlfUsxTM/xz9zGA40xpfydtliziKS7R4Kwn1dqfSB0Cl3hm97kC5DEA
O42j5CvC58tvuAmEV02PSFRtt8xMb20mgqTN43Q9kzPHM2ziW4g0R9U999fyNqmT
0vHgrGgXXdRc5+VU3Jd1ZCnrTVzWJMpaKoOCzGZVBO47gcB/7/mH6iFzMVACIYKV
f5p890vGJmfiOE9WD2VDNGj7w2NU/A==
=vlM1
-----END PGP SIGNATURE-----

--ey4ikhdxthigr5cx--
