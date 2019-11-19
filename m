Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA89D102395
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfKSLt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:49:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:39454 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726351AbfKSLt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 06:49:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E3C64BDB4;
        Tue, 19 Nov 2019 11:49:26 +0000 (UTC)
Message-ID: <1b116fabe85a324e2d05a593d38811467f43fb91.camel@suse.de>
Subject: Re: [PATCH v2 0/6] Raspberry Pi 4 PCIe support
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     devicetree@vger.kernel.org, f.fainelli@gmail.com,
        linux-rdma@vger.kernel.org, maz@kernel.org, phil@raspberrypi.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com,
        linux-rockchip@lists.infradead.org,
        iommu@lists.linux-foundation.org, mbrugger@suse.com,
        bcm-kernel-feedback-list@broadcom.com, wahrenst@gmx.net,
        james.quinlan@broadcom.com, linux-pci@vger.kernel.org,
        Robin Murphy <robin.murphy@arm.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org
Date:   Tue, 19 Nov 2019 12:49:24 +0100
In-Reply-To: <20191119111848.GR43905@e119886-lin.cambridge.arm.com>
References: <20191112155926.16476-1-nsaenzjulienne@suse.de>
         <20191119111848.GR43905@e119886-lin.cambridge.arm.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-K76aLLNKfyo+gQkABBwD"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-K76aLLNKfyo+gQkABBwD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-11-19 at 11:18 +0000, Andrew Murray wrote:
> On Tue, Nov 12, 2019 at 04:59:19PM +0100, Nicolas Saenz Julienne wrote:
> > This series aims at providing support for Raspberry Pi 4's PCIe
> > controller, which is also shared with the Broadcom STB family of
> > devices.
> >=20
> > There was a previous attempt to upstream this some years ago[1] but was
> > blocked as most STB PCIe integrations have a sparse DMA mapping[2] whic=
h
> > is something currently not supported by the kernel.  Luckily this is no=
t
> > the case for the Raspberry Pi 4.
> >=20
> > Note that the driver code is to be based on top of Rob Herring's series
> > simplifying inbound and outbound range parsing.
> >=20
> > [1] https://patchwork.kernel.org/cover/10605933/
> > [2] https://patchwork.kernel.org/patch/10605957/
> >=20
>=20
> What happened to patch 3? I can't see it on the list or in patchwork?

For some reason the script I use to call get_maintainer.sh or git send-mail
failed to add linux-pci@vger.kernel.org and linux-kernel@vger.kernel.org as
recipients. I didn't do anything different between v1 and v2 as far as mail=
ing
is concerned.

Nevertheless it's here: https://www.spinics.net/lists/arm-kernel/msg768461.=
html
and should be present in the linux-arm-kernel list.

I'll look in to it and make sure this doesn't happen in v3.

Regards,
Nicolas


--=-K76aLLNKfyo+gQkABBwD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl3T1sQACgkQlfZmHno8
x/5oAAgAsirq9AHBWc9c3u37sxo0sduCFRqCFKOtWMxm0jb/DcUdD6rQy3N9/RIf
tK6vZvovGokMN5GHwwG6sDD7vSCeNimQSFZx7R36XMI5iYvITtmREMYLCwherVD0
W2hMdlOm1hzjt1sEGCz9BHxnMT3w56ZLabkmJWscUGVaPhArD7ISSUo3ksO5x7rh
KS1lbJX9wZLpegmk3gxXxAoHN3OWgDunznERQ07/dvrDALwf4CZkyQT+V/8nOZhr
OV64Rq+nMrhttDcMk2ufbrUsWn0Gt6zVbIXqJyitSJmAEb0If2zq2KGKK/88n2hf
GFsoFCTkw2RQ0cpZmMHvvkVumUTaPg==
=kHJj
-----END PGP SIGNATURE-----

--=-K76aLLNKfyo+gQkABBwD--

