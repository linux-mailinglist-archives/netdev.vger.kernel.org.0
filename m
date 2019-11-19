Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B22E91024BE
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 13:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfKSMnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 07:43:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:45166 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728060AbfKSMnr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 07:43:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 61E29AA35;
        Tue, 19 Nov 2019 12:43:43 +0000 (UTC)
Message-ID: <56cbba61d92f9bc7d0a33c1de379bcd5cf411cb8.camel@suse.de>
Subject: Re: [PATCH v2 1/6] linux/log2.h: Add roundup/rounddown_pow_two64()
 family of functions
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     Heiko Stuebner <heiko@sntech.de>, linux-pci@vger.kernel.org,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-rdma@vger.kernel.org, maz@kernel.org, phil@raspberrypi.org,
        iommu@lists.linux-foundation.org,
        linux-rockchip@lists.infradead.org, f.fainelli@gmail.com,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org, mbrugger@suse.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeremy.linton@arm.com, Tom Joseph <tjoseph@cadence.com>,
        wahrenst@gmx.net, james.quinlan@broadcom.com,
        Robin Murphy <robin.murphy@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Tue, 19 Nov 2019 13:43:39 +0100
In-Reply-To: <052d07fb4eb79b29dd58cab577d59bab6684329a.camel@suse.de>
References: <20191112155926.16476-1-nsaenzjulienne@suse.de>
         <20191112155926.16476-2-nsaenzjulienne@suse.de>
         <20191119111320.GP43905@e119886-lin.cambridge.arm.com>
         <052d07fb4eb79b29dd58cab577d59bab6684329a.camel@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-PEkTPRiOa1AqhiKRErKs"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-PEkTPRiOa1AqhiKRErKs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-11-19 at 12:30 +0100, Nicolas Saenz Julienne wrote:
> Hi Andrew, thanks for the review.
> > > +/**
> > > + * __roundup_pow_of_two64() - round 64bit value up to nearest power =
of
> > > two
> > > + * @n: value to round up
> > > + */
> > > +static inline __attribute__((const)) __u64 __roundup_pow_of_two64(__=
u64
> > > n)
> >=20
> > To be consistent with other functions in the same file (__ilog_u64) you=
 may
> > want to rename this to __roundup_pow_of_two_u64.
>=20
> Sounds good to me.
>=20
> > Also do you know why u64 is used in some places and __u64 in others?
>=20
> That's unwarranted, it should be __u64 everywhere.

Sorry, now that I look deeper into it, it should be u64.

> > > +{
> > > +	return 1UL << fls64(n - 1);
> >=20
> > Does this need to be (and for the others):
> >=20
> > return 1ULL << fls64(n - 1);
> >=20
> > Notice that the PCI drivers you convert, all use 1ULL.
>=20
> Noted
>=20
> Regards,
> Nicolas
>=20


--=-PEkTPRiOa1AqhiKRErKs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl3T43sACgkQlfZmHno8
x/7LuAf/c4Ft9xBoQ5DrEpF3NZnrHpWnbCYGBZ5Q00PjCEwaMwf7zN1jspazlRC1
8u+n3yELpEHEhnu5CArHUsydAcMXpcZ05JTf+ii7TGVQfZmFY/iII/4C0WEQPif5
T19cDHz4f+qS+CVqpEWBvFt5YBDXfVst7ezSwZSRfRYNVjYMG4d2zbTRqSlVmOT5
6FKyeFGOK+lGpYpAaAu09PG7IFFqMEae3x6TkHfO2cfzUzy88FyOVNZ8G4Oucvhe
90OcIAUpPGgfX+Q2mQPBsITErw/o+Z4qY6t/kwwLcj9YjCFjh9MuwoDpS24a8Tmq
5XWFnFRetCT6rYY15K2BujP0/VQBBQ==
=sJh7
-----END PGP SIGNATURE-----

--=-PEkTPRiOa1AqhiKRErKs--

