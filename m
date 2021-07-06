Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E653BDD78
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 20:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhGFSqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 14:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbhGFSqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 14:46:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28F4C06175F
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 11:44:06 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m0q2W-0000ek-Kp; Tue, 06 Jul 2021 20:43:24 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m0q2V-00021e-8f; Tue, 06 Jul 2021 20:43:23 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m0q2V-0004QV-6e; Tue, 06 Jul 2021 20:43:23 +0200
Date:   Tue, 6 Jul 2021 20:43:23 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     nvdimm@lists.linux.dev, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-fpga@vger.kernel.org, linux-pci@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-cxl@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, target-devel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-i3c@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-acpi@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        linux-input@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-sunxi@lists.linux.dev, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, greybus-dev@lists.linaro.org,
        virtualization@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-spi@vger.kernel.org, kernel@pengutronix.de,
        dmaengine@vger.kernel.org, linux-ntb@googlegroups.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 4/4] bus: Make remove callback return void
Message-ID: <20210706184323.fudcbsiu4i34dojs@pengutronix.de>
References: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
 <20210706154803.1631813-5-u.kleine-koenig@pengutronix.de>
 <YOSb1+yeVeLxiSRc@yoga>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2fjaqpmq47gf4tbn"
Content-Disposition: inline
In-Reply-To: <YOSb1+yeVeLxiSRc@yoga>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2fjaqpmq47gf4tbn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Bjorn,

On Tue, Jul 06, 2021 at 01:08:18PM -0500, Bjorn Andersson wrote:
> On Tue 06 Jul 10:48 CDT 2021, Uwe Kleine-K?nig wrote:
> > diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
> > index c1404d3dae2c..7f6fac618ab2 100644
> > --- a/drivers/rpmsg/rpmsg_core.c
> > +++ b/drivers/rpmsg/rpmsg_core.c
> > @@ -530,7 +530,7 @@ static int rpmsg_dev_probe(struct device *dev)
> >  	return err;
> >  }
> > =20
> > -static int rpmsg_dev_remove(struct device *dev)
> > +static void rpmsg_dev_remove(struct device *dev)
> >  {
> >  	struct rpmsg_device *rpdev =3D to_rpmsg_device(dev);
> >  	struct rpmsg_driver *rpdrv =3D to_rpmsg_driver(rpdev->dev.driver);
> > @@ -546,8 +546,6 @@ static int rpmsg_dev_remove(struct device *dev)
> > =20
> >  	if (rpdev->ept)
> >  		rpmsg_destroy_ept(rpdev->ept);
> > -
> > -	return err;
>=20
> This leaves err assigned but never used, but I don't mind following up
> with a patch cleaning that up after this has landed.

Ah, good catch. If I send out a v3 I will fold the following into this
patch:

diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
index 7f6fac618ab2..9151836190ce 100644
--- a/drivers/rpmsg/rpmsg_core.c
+++ b/drivers/rpmsg/rpmsg_core.c
@@ -534,10 +534,9 @@ static void rpmsg_dev_remove(struct device *dev)
 {
 	struct rpmsg_device *rpdev =3D to_rpmsg_device(dev);
 	struct rpmsg_driver *rpdrv =3D to_rpmsg_driver(rpdev->dev.driver);
-	int err =3D 0;
=20
 	if (rpdev->ops->announce_destroy)
-		err =3D rpdev->ops->announce_destroy(rpdev);
+		rpdev->ops->announce_destroy(rpdev);
=20
 	if (rpdrv->remove)
 		rpdrv->remove(rpdev);

Maybe .announce_destroy() should then be changed to return void, too?
Something like:

diff --git a/drivers/rpmsg/rpmsg_internal.h b/drivers/rpmsg/rpmsg_internal.h
index a76c344253bf..d5204756714c 100644
--- a/drivers/rpmsg/rpmsg_internal.h
+++ b/drivers/rpmsg/rpmsg_internal.h
@@ -40,7 +40,7 @@ struct rpmsg_device_ops {
 					    struct rpmsg_channel_info chinfo);
=20
 	int (*announce_create)(struct rpmsg_device *ept);
-	int (*announce_destroy)(struct rpmsg_device *ept);
+	void (*announce_destroy)(struct rpmsg_device *ept);
 };
=20
 /**
diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_=
bus.c
index 8e49a3bacfc7..4e05994634f8 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -340,7 +340,7 @@ static int virtio_rpmsg_announce_create(struct rpmsg_de=
vice *rpdev)
 	return err;
 }
=20
-static int virtio_rpmsg_announce_destroy(struct rpmsg_device *rpdev)
+static void virtio_rpmsg_announce_destroy(struct rpmsg_device *rpdev)
 {
 	struct virtio_rpmsg_channel *vch =3D to_virtio_rpmsg_channel(rpdev);
 	struct virtproc_info *vrp =3D vch->vrp;
@@ -360,8 +360,6 @@ static int virtio_rpmsg_announce_destroy(struct rpmsg_d=
evice *rpdev)
 		if (err)
 			dev_err(dev, "failed to announce service %d\n", err);
 	}
-
-	return err;
 }
=20
 static const struct rpmsg_device_ops virtio_rpmsg_ops =3D {

though it's not obvious for me that the last hunk is sensible. (OTOH the
return code is ignored anyhow as rpmsg_dev_remove() is the only caller.

Best regards and thanks
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--2fjaqpmq47gf4tbn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmDkpEcACgkQwfwUeK3K
7Ak4/gf+JPjwmTdMOBhuMe8ecxXY1LASOPn6raBvtbwdOTQTpuggYaNCNlkaVJAE
HyLf68h68hyvV9vpIoID8AOmf9uXGwFBXlOzR/nHgHqauU/8HnbE2GH+wOywoCi8
Tkzj2jT35NSYD0Cmtorpd0wmKVjEQuPqiv8px5gEqAMvtwp93P9dQwyKm7IPhUSf
Ly8NwR3EsI/ng6nNulL+Z6d0tGg+RRvUj5mWp8YcIYePISvHdibi/lFHA6vTaWE7
ZqLwQsajLZaY5r33EPGYZOxBPk809iKwh4Q5mfww37TTXySNeps2tFT7S6r4d6To
OAUYwloDQSOqtVvuLc4PfxSTkToueQ==
=o1F8
-----END PGP SIGNATURE-----

--2fjaqpmq47gf4tbn--
