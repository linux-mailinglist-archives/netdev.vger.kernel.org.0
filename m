Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD1B10B494
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 18:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfK0Rgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 12:36:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:54054 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726655AbfK0Rgw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 12:36:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BE0F9B042;
        Wed, 27 Nov 2019 17:36:49 +0000 (UTC)
Message-ID: <4e77aa14b0fd1150a186d5d6e540f115beb7cd2f.camel@suse.de>
Subject: Re: [PATCH v3 1/7] linux/log2.h: Add roundup/rounddown_pow_two64()
 family of functions
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     andrew.murray@arm.com, maz@kernel.org,
        linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     james.quinlan@broadcom.com, mbrugger@suse.com,
        f.fainelli@gmail.com, phil@raspberrypi.org, wahrenst@gmx.net,
        jeremy.linton@arm.com, linux-pci@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org,
        iommu@lists.linux-foundation.org
Date:   Wed, 27 Nov 2019 18:36:43 +0100
In-Reply-To: <20191126091946.7970-2-nsaenzjulienne@suse.de>
References: <20191126091946.7970-1-nsaenzjulienne@suse.de>
         <20191126091946.7970-2-nsaenzjulienne@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-pGA2H6iLsoqumxPFnjV/"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-pGA2H6iLsoqumxPFnjV/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-11-26 at 10:19 +0100, Nicolas Saenz Julienne wrote:
> Some users need to make sure their rounding function accepts and returns
> 64bit long variables regardless of the architecture. Sadly
> roundup/rounddown_pow_two() takes and returns unsigned longs. Create a
> new generic 64bit variant of the function and cleanup rougue custom
> implementations.
>=20
> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

Small Nit: I corrected the patch subject for next version.

linux/log2.h: Add roundup/rounddown_pow_two_u64() family of functions

Note the change here:                      ^^^^

Regards,
Nicolas


--=-pGA2H6iLsoqumxPFnjV/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl3etCsACgkQlfZmHno8
x/4AJwf9Eq0ZM4NqHmqyyrS7BQmYgPtM7piuXLZCM3vqnnuHZTenFUoHxhH60Ffb
HzBZeEMXW4jW8lQIOtwAy6+cQ19qTmM3uR2gAPmNzuvcFvpVOXPvKGMKSte+IYqI
s5O/WUAFckUhcZRDrI4P0P2PdZLOgYXsQU9k6jGXPnWW1my63yF6W+01o/Oy/Oef
x+WobkWQtp9ozxgzG9Six/Sx7Bmn22OPxFSiGftu00G9AYSX1jkgv8yUPyoT0buj
aNTTrueG/JVXF9afKDupaKDAV69F7eYTFjYiMxl53jTQAshV6s9FV+tOdnFWqBRX
abK/iKFoC2e1Sip+k57Zx8tFXUexGg==
=qoBY
-----END PGP SIGNATURE-----

--=-pGA2H6iLsoqumxPFnjV/--

