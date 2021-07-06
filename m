Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBA13BC9E8
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 12:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhGFK3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 06:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231305AbhGFK3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 06:29:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67D94619A5;
        Tue,  6 Jul 2021 10:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625567225;
        bh=0Vco6bcsV+Des5dnB/IHP43/fsWcFHTPga6X4P0iyiI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MJ47WOBtCFnBMrkhOv+LFd3d2n5QIFWUez/HdhcKSgj7hDo7O0eQPQO5H1okLYNyY
         WRHGLatcUEVgmIJR5BCR7gEfLHN7Lv0rc0YJ5MyF740i+lCi8D4V+MGNYVLcohzTMs
         AfQKJwNYwrk/3LHkBQb8ARTgdmp51CHltJ3T5fWM60xGKOpwPUaG1eqdKH5Upw0qVs
         s7qgJDHkhXgsuZf0dm36DQ+Su4NaRp8y0KTbqHcRHQh4sMzfcc9GcElEIURZcXDone
         /RqrSOsALErH8v8KBG/HSN0T6lH+qCDwKWZm1izYVpvXQqH5K2135N2PlYwMDGoyI2
         kPGtTEoLasdOg==
Date:   Tue, 6 Jul 2021 12:26:31 +0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Wu Hao <hao.wu@intel.com>, Tom Rix <trix@redhat.com>,
        Moritz Fischer <mdf@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Johannes Thumshirn <morbidrsa@gmail.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jon Mason <jdmason@kudzu.us>, Allen Hubbe <allenbh@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Krzysztof =?UTF-8?B?V2lsY3p5xYRza2k=?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thorsten Scherer <t.scherer@eckelmann.de>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>, Michael Buesch <m@bues.ch>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Martyn Welch <martyn@welchs.me.uk>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Marc Zyngier <maz@kernel.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Samuel Holland <samuel@sholland.org>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joey Pabalan <jpabalanb@gmail.com>,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frank Li <lznuaa@gmail.com>,
        Mike Christie <michael.christie@oracle.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        SeongJae Park <sjpark@amazon.de>,
        Julien Grall <jgrall@amazon.com>,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-cxl@vger.kernel.org,
        nvdimm@lists.linux.dev, dmaengine@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-fpga@vger.kernel.org,
        linux-input@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-i3c@lists.infradead.org,
        industrypack-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        linux-pci@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-msm@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-staging@lists.linux.dev,
        greybus-dev@lists.linaro.org, target-devel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH] bus: Make remove callback return void
Message-ID: <20210706122631.463bc671@coco.lan>
In-Reply-To: <20210706095037.1425211-1-u.kleine-koenig@pengutronix.de>
References: <20210706095037.1425211-1-u.kleine-koenig@pengutronix.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue,  6 Jul 2021 11:50:37 +0200
Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de> escreveu:

> The driver core ignores the return value of this callback because there
> is only little it can do when a device disappears.
>=20
> This is the final bit of a long lasting cleanup quest where several
> buses were converted to also return void from their remove callback.
> Additionally some resource leaks were fixed that were caused by drivers
> returning an error code in the expectation that the driver won't go
> away.
>=20
> With struct bus_type::remove returning void it's prevented that newly
> implemented buses return an ignored error code and so don't anticipate
> wrong expectations for driver authors.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
>=20
> this patch depends on "PCI: endpoint: Make struct pci_epf_driver::remove
> return void" that is not yet applied, see
> https://lore.kernel.org/r/20210223090757.57604-1-u.kleine-koenig@pengutro=
nix.de.
>=20
> I tested it using allmodconfig on amd64 and arm, but I wouldn't be
> surprised if I still missed to convert a driver. So it would be great to
> get this into next early after the merge window closes.
>=20
> I send this mail to all people that get_maintainer.pl emits for this
> patch. I wonder how many recipents will refuse this mail because of the
> long Cc: list :-)
>=20
> Best regards
> Uwe
>=20

> diff --git a/drivers/media/pci/bt8xx/bttv-gpio.c b/drivers/media/pci/bt8x=
x/bttv-gpio.c
> index b730225ca887..a2b18e2bed1b 100644
> --- a/drivers/media/pci/bt8xx/bttv-gpio.c
> +++ b/drivers/media/pci/bt8xx/bttv-gpio.c
> @@ -46,14 +46,13 @@ static int bttv_sub_probe(struct device *dev)
>  	return sub->probe ? sub->probe(sdev) : -ENODEV;
>  }
> =20
> -static int bttv_sub_remove(struct device *dev)
> +static void bttv_sub_remove(struct device *dev)
>  {
>  	struct bttv_sub_device *sdev =3D to_bttv_sub_dev(dev);
>  	struct bttv_sub_driver *sub =3D to_bttv_sub_drv(dev->driver);
> =20
>  	if (sub->remove)
>  		sub->remove(sdev);
> -	return 0;
>  }
> =20

Acked-by: Mauro Carvalho Chehab <mchehab@kernel.org> # for drivers/media


Thanks,
Mauro
