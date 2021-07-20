Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61FD3D034E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 22:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbhGTUH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 16:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236897AbhGTTpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 15:45:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56E9760BBB;
        Tue, 20 Jul 2021 20:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626812753;
        bh=l5xDkWzCR3urdpTjqmcMUpN6o09NewdpR8Jc68Liw0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VBe4HBaGXZMGD0ZdODVsdKbrJ8SORqt3SuXaX37yK3AHshxYDbXGRQXluA6mx7jW3
         pTBW48mt4sopqYvfTU+bZO/p3bIz4jENtO9uPBTi0SuDufiC+I7vrG7Ce/qo8tgdbL
         Vv6L36N+yjTOuiDCZaFxIklqrdMuw+BZDERVBNSuKxTccmMm+0DpHaq2hVxlihY0dP
         QgyoMfzVLFJnhH8igTsTFxC4OBQeb5IzLYxfferXAP0fHcTPB3F6Yr+8KbAgAJLPf2
         a0unVf6CWv1kUs6z+N9Cr2G8gL44dgqsGt8dlJjFYXR6m7PEcLW13zfgVQ2ipy0CDg
         OpoYDDMZUiahA==
Date:   Tue, 20 Jul 2021 22:25:42 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel@pengutronix.de,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Alex Dubov <oakad@yahoo.com>, Alex Elder <elder@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Andy Gross <agross@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Dexuan Cui <decui@microsoft.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Finn Thain <fthain@linux-m68k.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Li <lznuaa@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Geoff Levand <geoff@infradead.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hannes Reinecke <hare@suse.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>, Ira Weiny <ira.weiny@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Wang <jasowang@redhat.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Joey Pabalan <jpabalanb@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Johannes Thumshirn <morbidrsa@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Juergen Gross <jgross@suse.com>,
        Julien Grall <jgrall@amazon.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lee Jones <lee.jones@linaro.org>, Len Brown <lenb@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martyn Welch <martyn@welchs.me.uk>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Michael Buesch <m@bues.ch>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Jamet <michael.jamet@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Christie <michael.christie@oracle.com>,
        Moritz Fischer <mdf@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Rich Felker <dalias@libc.org>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Samuel Holland <samuel@sholland.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        SeongJae Park <sjpark@amazon.de>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thorsten Scherer <t.scherer@eckelmann.de>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Tom Rix <trix@redhat.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Wei Liu <wei.liu@kernel.org>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Wu Hao <hao.wu@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        YueHaibing <yuehaibing@huawei.com>,
        Yufen Yu <yuyufen@huawei.com>, alsa-devel@alsa-project.org,
        dmaengine@vger.kernel.org, greybus-dev@lists.linaro.org,
        industrypack-devel@lists.sourceforge.net, kvm@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-fpga@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-i3c@lists.infradead.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-media@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-parisc@vger.kernel.org,
        linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-sunxi@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nvdimm@lists.linux.dev,
        platform-driver-x86@vger.kernel.org, sparclinux@vger.kernel.org,
        target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org,
        Johannes Thumshirn <jth@kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v4 5/5] bus: Make remove callback return void
Message-ID: <YPcxRgfZymtjJ4ih@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel@pengutronix.de,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Alex Dubov <oakad@yahoo.com>, Alex Elder <elder@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Andy Gross <agross@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Dexuan Cui <decui@microsoft.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Finn Thain <fthain@linux-m68k.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Li <lznuaa@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Geoff Levand <geoff@infradead.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hannes Reinecke <hare@suse.de>, Hans de Goede <hdegoede@redhat.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
        Ira Weiny <ira.weiny@intel.com>, Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Jaroslav Kysela <perex@perex.cz>, Jason Wang <jasowang@redhat.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Jiri Kosina <jikos@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
        Joey Pabalan <jpabalanb@gmail.com>, Johan Hovold <johan@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Johannes Thumshirn <morbidrsa@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Juergen Gross <jgross@suse.com>,
        Julien Grall <jgrall@amazon.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lee Jones <lee.jones@linaro.org>, Len Brown <lenb@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martyn Welch <martyn@welchs.me.uk>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Michael Buesch <m@bues.ch>, Michael Ellerman <mpe@ellerman.id.au>,
        Michael Jamet <michael.jamet@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Christie <michael.christie@oracle.com>,
        Moritz Fischer <mdf@kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Rich Felker <dalias@libc.org>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Rob Herring <robh@kernel.org>, Russell King <linux@armlinux.org.uk>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Samuel Holland <samuel@sholland.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        SeongJae Park <sjpark@amazon.de>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thorsten Scherer <t.scherer@eckelmann.de>,
        Tomas Winkler <tomas.winkler@intel.com>, Tom Rix <trix@redhat.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Wei Liu <wei.liu@kernel.org>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Wu Hao <hao.wu@intel.com>, Yehezkel Bernat <YehezkelShB@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        YueHaibing <yuehaibing@huawei.com>, Yufen Yu <yuyufen@huawei.com>,
        alsa-devel@alsa-project.org, dmaengine@vger.kernel.org,
        greybus-dev@lists.linaro.org,
        industrypack-devel@lists.sourceforge.net, kvm@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-cxl@vger.kernel.org, linux-fpga@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-i3c@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-ntb@googlegroups.com,
        linux-parisc@vger.kernel.org, linux-pci@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-sunxi@lists.linux.dev, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        nvdimm@lists.linux.dev, platform-driver-x86@vger.kernel.org,
        sparclinux@vger.kernel.org, target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, Johannes Thumshirn <jth@kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>
References: <20210713193522.1770306-1-u.kleine-koenig@pengutronix.de>
 <20210713193522.1770306-6-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o9Bjd73EPYzHYRI8"
Content-Disposition: inline
In-Reply-To: <20210713193522.1770306-6-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--o9Bjd73EPYzHYRI8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 13, 2021 at 09:35:22PM +0200, Uwe Kleine-K=C3=B6nig wrote:
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
> Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk> (For ARM, Am=
ba and related parts)
> Acked-by: Mark Brown <broonie@kernel.org>
> Acked-by: Chen-Yu Tsai <wens@csie.org> (for sunxi-rsb)
> Acked-by: Pali Roh=C3=A1r <pali@kernel.org>
> Acked-by: Mauro Carvalho Chehab <mchehab@kernel.org> (for media)
> Acked-by: Hans de Goede <hdegoede@redhat.com> (For drivers/platform)
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Acked-By: Vinod Koul <vkoul@kernel.org>
> Acked-by: Juergen Gross <jgross@suse.com> (For xen)
> Acked-by: Lee Jones <lee.jones@linaro.org> (For mfd)
> Acked-by: Johannes Thumshirn <jth@kernel.org> (For mcb)
> Acked-by: Johan Hovold <johan@kernel.org>
> Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org> (For slimb=
us)
> Acked-by: Kirti Wankhede <kwankhede@nvidia.com> (For vfio)
> Acked-by: Maximilian Luz <luzmaximilian@gmail.com>
> Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com> (For ulpi and=
 typec)
> Acked-by: Samuel Iglesias Gons=C3=A1lvez <siglesias@igalia.com> (For ipac=
k)
> Reviewed-by: Tom Rix <trix@redhat.com> (For fpga)
> Acked-by: Geoff Levand <geoff@infradead.org> (For ps3)
> Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com> (For thunderbolt)
> Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com> (For in=
tel_th)
> Acked-by: Dominik Brodowski <linux@dominikbrodowski.net> (For pcmcia)
> Reviewed-by: Cornelia Huck <cohuck@redhat.com> (For drivers/s390 and driv=
ers/vfio)
> Acked-by: Rafael J. Wysocki <rafael@kernel.org> (For ACPI)
> Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org> (rpmsg and apr)
> Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com> (For =
intel-ish-hid)
> Acked-by: Dan Williams <dan.j.williams@intel.com> (For CXL, DAX, and NVDI=
MM)
> Acked-by: William Breathitt Gray <vilhelm.gray@gmail.com> (For isa)
> Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (For firewire)
> Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> (For hid)
> Acked-by: Thorsten Scherer <t.scherer@eckelmann.de> (For siox)
> Acked-by: Sven Van Asbroeck <TheSven73@gmail.com> (For anybuss)
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org> (For MMC)
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>

Acked-by: Wolfram Sang <wsa@kernel.org> # for I2C

Thanks, Uwe!


--o9Bjd73EPYzHYRI8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmD3MUIACgkQFA3kzBSg
KbYzoQ//fHsReQ7gV79Uj6MfHENOZAAxSFMd8yIWNeX0Ug8crVQ2fzQgvlotUS1y
62KPO9MFbi37+nfCWwl5uNEiDPwYjpB+jM/jfqJ849ngfiIQyUqCK7qr5b1FIWkp
TuEV1Rx/wlpmxMEjKFAuo+/5OkXVwvpxQGiqBemOeTmOKjqITCpXEBkYqDqqI/MY
lnzwpE8R30sf8IH/aThtb9dZBz+8y2mry6nVtSbMMmZ0VAYgwEPmuPLfa9CIhaCJ
Oqe6Uf+sJs/emp0nfyZ5IDXvO8vE5kgPoy0l/smHEtejHLUkHBKf4MusKOzDdbax
Uk48fnhKgbhxbVN0guT7IzWvRG+80hU4Ns9YPjmHYNXr4Wg03//hoAv4otMAAqXU
Tjk9sEMBGHasqHZ0e1j3xTRhxQOwTJjzwVNhkrTX4HIZ/k0gXQK0ojBXxGvWeds2
yQ7FUakyf1LQBmrLwssWSXbyp+W6tVodIUmnebSK1IpVd7YK4NZPf796yD44Ckzd
XM4O5xTksxr5X+cEsNNLxhXFMohR/BOpLCj4R1+vpRNyMTHLIqfsI7GL+TJh+Mri
+kuq0TQgbTRlrIw/jfTcenYmXhQte4oeFQa3uVwGY2b+5kB/zRMTKThU0e2Vpd+8
Kifz6u9a8LEGAMrLNXVd1B/uHQSOMYeeIzsuZ+BHqVxDsyNvJds=
=zPVh
-----END PGP SIGNATURE-----

--o9Bjd73EPYzHYRI8--
