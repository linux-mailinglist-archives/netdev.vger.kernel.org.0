Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BDC3BD6CF
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239099AbhGFMrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbhGFMqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 08:46:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60280C09B330
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 05:21:35 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m0jyQ-0001jl-7p; Tue, 06 Jul 2021 14:14:46 +0200
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m0jyP-0001fC-Gy; Tue, 06 Jul 2021 14:14:45 +0200
Date:   Tue, 6 Jul 2021 14:14:45 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        nvdimm@lists.linux.dev, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Christie <michael.christie@oracle.com>,
        Wei Liu <wei.liu@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Julien Grall <jgrall@amazon.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alex Elder <elder@kernel.org>, linux-parisc@vger.kernel.org,
        Geoff Levand <geoff@infradead.org>, linux-fpga@vger.kernel.org,
        linux-usb@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Thorsten Scherer <t.scherer@eckelmann.de>,
        kernel@pengutronix.de, Jon Mason <jdmason@kudzu.us>,
        linux-ntb@googlegroups.com, Wu Hao <hao.wu@intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        linux-wireless@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        virtualization@lists.linux-foundation.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        target-devel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-i2c@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Ira Weiny <ira.weiny@intel.com>, Helge Deller <deller@gmx.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        industrypack-devel@lists.sourceforge.net,
        linux-mips@vger.kernel.org, Len Brown <lenb@kernel.org>,
        alsa-devel@alsa-project.org, linux-arm-msm@vger.kernel.org,
        linux-media@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Johan Hovold <johan@kernel.org>, greybus-dev@lists.linaro.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Johannes Thumshirn <morbidrsa@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>, Wolfram Sang <wsa@kernel.org>,
        Joey Pabalan <jpabalanb@gmail.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tom Rix <trix@redhat.com>, Jason Wang <jasowang@redhat.com>,
        SeongJae Park <sjpark@amazon.de>, linux-hyperv@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, Frank Li <lznuaa@gmail.com>,
        netdev@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Gross <mgross@linux.intel.com>,
        linux-staging@lists.linux.dev, Dexuan Cui <decui@microsoft.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-input@vger.kernel.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Allen Hubbe <allenbh@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jiri Kosina <jikos@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Moritz Fischer <mdf@kernel.org>, linux-cxl@vger.kernel.org,
        Michael Buesch <m@bues.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martyn Welch <martyn@welchs.me.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-mmc@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sven Van Asbroeck <TheSven73@gmail.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-remoteproc@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        linux-i3c@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org,
        Vishal Verma <vishal.l.verma@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Andy Gross <agross@kernel.org>, linux-serial@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Jamet <michael.jamet@intel.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Juergen Gross <jgross@suse.com>, linuxppc-dev@lists.ozlabs.org,
        Takashi Iwai <tiwai@suse.com>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Marc Zyngier <maz@kernel.org>, dmaengine@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Maximilian Luz <luzmaximilian@gmail.com>
Subject: Re: [PATCH] bus: Make remove callback return void
Message-ID: <20210706121445.o3nxgi4bhzrw5w73@pengutronix.de>
References: <20210706095037.1425211-1-u.kleine-koenig@pengutronix.de>
 <87pmvvhfqq.fsf@redhat.com>
 <87mtqzhesu.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qlv3rwmw2vf6tbvn"
Content-Disposition: inline
In-Reply-To: <87mtqzhesu.fsf@redhat.com>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qlv3rwmw2vf6tbvn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 06, 2021 at 01:17:37PM +0200, Cornelia Huck wrote:
> On Tue, Jul 06 2021, Cornelia Huck <cohuck@redhat.com> wrote:
>=20
> > On Tue, Jul 06 2021, Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de=
> wrote:
> >
> >> The driver core ignores the return value of this callback because there
> >> is only little it can do when a device disappears.
> >>
> >> This is the final bit of a long lasting cleanup quest where several
> >> buses were converted to also return void from their remove callback.
> >> Additionally some resource leaks were fixed that were caused by drivers
> >> returning an error code in the expectation that the driver won't go
> >> away.
> >>
> >> With struct bus_type::remove returning void it's prevented that newly
> >> implemented buses return an ignored error code and so don't anticipate
> >> wrong expectations for driver authors.
> >
> > Yay!
> >
> >>
> >> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> >> ---
> >> Hello,
> >>
> >> this patch depends on "PCI: endpoint: Make struct pci_epf_driver::remo=
ve
> >> return void" that is not yet applied, see
> >> https://lore.kernel.org/r/20210223090757.57604-1-u.kleine-koenig@pengu=
tronix.de.
> >>
> >> I tested it using allmodconfig on amd64 and arm, but I wouldn't be
> >> surprised if I still missed to convert a driver. So it would be great =
to
> >> get this into next early after the merge window closes.
> >
> > I'm afraid you missed the s390-specific busses in drivers/s390/cio/
> > (css/ccw/ccwgroup).

:-\

> The change for vfio/mdev looks good.
>=20
> The following should do the trick for s390; not sure if other
> architectures have easy-to-miss busses as well.
>=20
> diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
> index 9748165e08e9..a66f416138ab 100644
> --- a/drivers/s390/cio/ccwgroup.c
> +++ b/drivers/s390/cio/ccwgroup.c
> @@ -439,17 +439,15 @@ module_exit(cleanup_ccwgroup);
> =20
>  /************************** driver stuff ******************************/
> =20
> -static int ccwgroup_remove(struct device *dev)
> +static void ccwgroup_remove(struct device *dev)
>  {
>  	struct ccwgroup_device *gdev =3D to_ccwgroupdev(dev);
>  	struct ccwgroup_driver *gdrv =3D to_ccwgroupdrv(dev->driver);
> =20
>  	if (!dev->driver)
> -		return 0;
> +		return;

This is fine to be squashed into my patch. In the long run: in a remove
callback dev->driver cannot be NULL, so this if could go away.

>  	if (gdrv->remove)
>  		gdrv->remove(gdev);
> -
> -	return 0;
>  }
> =20
>  static void ccwgroup_shutdown(struct device *dev)
> diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
> index a974943c27da..ebc321edba51 100644
> --- a/drivers/s390/cio/css.c
> +++ b/drivers/s390/cio/css.c
> @@ -1371,15 +1371,14 @@ static int css_probe(struct device *dev)
>  	return ret;
>  }
> =20
> -static int css_remove(struct device *dev)
> +static void css_remove(struct device *dev)
>  {
>  	struct subchannel *sch;
> -	int ret;
> =20
>  	sch =3D to_subchannel(dev);
> -	ret =3D sch->driver->remove ? sch->driver->remove(sch) : 0;
> +	if (sch->driver->remove)
> +		sch->driver->remove(sch);

Maybe the return type for this function pointer can be changed to void,
too.

I will add these changes to a v2 that I plan to send out after the dust
settles some more.

Thanks
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--qlv3rwmw2vf6tbvn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmDkSTIACgkQwfwUeK3K
7AmpKwf/cEGBSAtr38Z6g8D5Sb7wD6N+VKt79z1eeeFykI81lxaibOS1hxqeDq28
jW5itKeFVh1+cP8UVt8l7VJlvhIUO+xFsMgJ/LrRGoynkDBqMdlbTfQnZ/yOULyX
KI6vecR8mDHh+M0cs+KxsmbHXtKL+WJfAnGYMVFhrq7cayZ2ZnflKlVAFFyN1iWR
ewHXQduLqDi718k76IDgu9PZfUuQbRNLuX69ZAwyVl1F+BpBxMCvnMU2apcdJQ1B
ovWeCbDSh+HLgMrfUAYcVddvRKo81lrMn1i24FK2RuVnrnYdupIRl3L+Y5V4D7Pd
xOqLOUY6yncBK5uZwnZctg9p3aX8wA==
=Zesi
-----END PGP SIGNATURE-----

--qlv3rwmw2vf6tbvn--
