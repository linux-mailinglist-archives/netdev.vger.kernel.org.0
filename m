Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 276F61101CE
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 17:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfLCQGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 11:06:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:51528 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbfLCQGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 11:06:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AD9186A2F7;
        Tue,  3 Dec 2019 16:06:47 +0000 (UTC)
Message-ID: <d1c87c83f38e74f0c6b0692248fe88dfd2bdec3e.camel@suse.de>
Subject: Re: [PATCH v4 8/8] linux/log2.h: Use roundup/dow_pow_two() on 64bit
 calculations
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Murray <andrew.murray@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "maintainer:BROADCOM BCM7XXX ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        james.quinlan@broadcom.com, Matthias Brugger <mbrugger@suse.com>,
        Phil Elwell <phil@raspberrypi.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        PCI <linux-pci@vger.kernel.org>,
        "moderated list:BROADCOM BCM2835 ARM ARCHITECTURE" 
        <linux-rpi-kernel@lists.infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-acpi@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        devicetree@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>
Date:   Tue, 03 Dec 2019 17:06:43 +0100
In-Reply-To: <CAL_JsqLMCXdnZag3jihV_dzuR+wFaVKFb7q_PdKTxTg0LVA6cw@mail.gmail.com>
References: <20191203114743.1294-1-nsaenzjulienne@suse.de>
         <20191203114743.1294-9-nsaenzjulienne@suse.de>
         <CAL_JsqLMCXdnZag3jihV_dzuR+wFaVKFb7q_PdKTxTg0LVA6cw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-VHC+bPmpbRjqhnK2ykxw"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-VHC+bPmpbRjqhnK2ykxw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Rob,

On Tue, 2019-12-03 at 09:53 -0600, Rob Herring wrote:
> On Tue, Dec 3, 2019 at 5:48 AM Nicolas Saenz Julienne
> <nsaenzjulienne@suse.de> wrote:
> > The function now is safe to use while expecting a 64bit value. Use it
> > where relevant.
>=20
> What was wrong with the existing code? This is missing some context.

You're right, I'll update it.

For most of files changed the benefit here is factoring out a common patter=
n
using the standard function roundup/down_pow_two() which now provides corre=
ct
64bit results.

As for of/device.c and arm64/iort.c it's more of a readability enhancement.=
 I
consider it's easier to understand than the current calculation as it abstr=
acts
the math.

> > Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> > ---
> >  drivers/acpi/arm64/iort.c                        | 2 +-
> >  drivers/net/ethernet/mellanox/mlx4/en_clock.c    | 3 ++-
> >  drivers/of/device.c                              | 3 ++-
>=20
> In any case,
>=20
> Acked-by: Rob Herring <robh@kernel.org>
>=20

Thanks!

Regards,
Nicolas


--=-VHC+bPmpbRjqhnK2ykxw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl3miBMACgkQlfZmHno8
x/5s+Af/a2icSd66GHrsABoMtUfJXpQclSae81ThRP5Bfx6+mK4Ty4en3T+IxOK+
NPmneod0gjSfyqqQniFbEcmlKAd8wXyUnBCCi6urRvuqOWcw65h10DA3fQCivaOt
NWn3FRWMlPZbBIAYr/XOcsdOOkbD+VaFE/PaBYmxU/rWaCLGMWpYYBhF/Vcm+ASd
VPQ4g8AfxyGvQW9EgbmRTMC0k7kMP6qrpmgIjNWvUPyJ+8ytD2Zly2xvbVf9TqhX
/PP/t19fWayTqhsg+B04K0aN0oriRqSFX44yvCOApKhLBSsF6Nyc40m2sreqKMYY
98kwrOrux/Fb3OeV/Wzdhhh8VhH+Sg==
=4wmf
-----END PGP SIGNATURE-----

--=-VHC+bPmpbRjqhnK2ykxw--

