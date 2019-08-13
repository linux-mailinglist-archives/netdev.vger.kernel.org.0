Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3348BE88
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 18:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbfHMQ2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 12:28:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727504AbfHMQ2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 12:28:05 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC9DC285AE;
        Tue, 13 Aug 2019 16:28:04 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-57.rdu2.redhat.com [10.10.112.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E981271A5;
        Tue, 13 Aug 2019 16:28:03 +0000 (UTC)
Message-ID: <be3410bb2bfe134255363ccd8018320e8be3b322.camel@redhat.com>
Subject: Re: [PATCH rdma-next 0/4] Add XRQ and SRQ support to DEVX interface
From:   Doug Ledford <dledford@redhat.com>
To:     Leon Romanovsky <leonro@mellanox.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Edward Srouji <edwards@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Date:   Tue, 13 Aug 2019 12:28:00 -0400
In-Reply-To: <20190813100642.GE29138@mtr-leonro.mtl.com>
References: <20190808084358.29517-1-leon@kernel.org>
         <20190808101059.GC28049@mtr-leonro.mtl.com>
         <dc88624d6632f23a1b0ca77f45ed21a20158d3e6.camel@redhat.com>
         <20190813100642.GE29138@mtr-leonro.mtl.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-uf6bWHzlaDJ7aNElxbKY"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 13 Aug 2019 16:28:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-uf6bWHzlaDJ7aNElxbKY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-08-13 at 10:06 +0000, Leon Romanovsky wrote:
> On Mon, Aug 12, 2019 at 11:43:58AM -0400, Doug Ledford wrote:
> > On Thu, 2019-08-08 at 10:11 +0000, Leon Romanovsky wrote:
> > > On Thu, Aug 08, 2019 at 11:43:54AM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@mellanox.com>
> > > >=20
> > > > Hi,
> > > >=20
> > > > This small series extends DEVX interface with SRQ and XRQ legacy
> > > > commands.
> > >=20
> > > Sorry for typo in cover letter, there is no SRQ here.
> >=20
> > Series looks fine to me.  Are you planning on the first two via
> > mlx5-
> > next and the remainder via RDMA tree?
> >=20
>=20
> Thanks, applied to mlx5-next
>=20
> b1635ee6120c net/mlx5: Add XRQ legacy commands opcodes
> 647d58a989b3 net/mlx5: Use debug message instead of warn

Merged mlx5-next, then applied remaining two patches to for-next.=20
Thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-uf6bWHzlaDJ7aNElxbKY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl1S5RAACgkQuCajMw5X
L90egA/9Hketfl8VboKjsO8/wx3gylKGv8qI3dwEB74YEnZWcVd1oyAgIopLB2vF
mgudk2PLDpBrbZPBBsk/x9dZmVQ5VZLF1lUnkWuiryK4uZRBivvF659/7nPCF3OR
7GkDyaUy9CfpYUVWRIt6GWOicsSBb6feBjSdkStm4IucSk/rYCYU8dM2DJM3i1Ii
KS23KJS/bLD3y12fLueI+Q4IB3FD57jg8UagRRB2NfzGIsQr/qJ7M8rFaYxI3wXj
UJbQZCsi/OSALkgv8DPxXVfHZBTMXEJXLa+feuI8M/P/KebJ0aci5xVUcZuMEWrp
Q+CxCUvkYGiizMSCjChW6MeXIsLfEqnjHSFwt0yoOSB7vkpqzKzFgGt96oqWwl2R
DbeYM1M5hEy+4eoDMvvk0txKOMLW9qWycGa6U7wLzMr43pvOh8vGLGuN2r0Bk1DR
kIn6KZg9OBmGIbdoiaIpdjNmEKui1Y74DLOs1DfeFivMwUYsLWSE3mKbxz0ZMgif
YNanjhvgchF+pjnZdJOxiAX5Dq73clODCuXy6No8C3hhX3XD6v8hu0tLDCQshDRH
315yNJ5X0cLxjh5zRGJ+lKYYLSVMhILgvsTFCqE3DR4XGXSqt6Kw8b3jpW0aO9Fd
QxCSSKn/jxj/w3Q9EOpTEE+JsazasKgK8llfCymjNBlkVwxHDDk=
=ZAEY
-----END PGP SIGNATURE-----

--=-uf6bWHzlaDJ7aNElxbKY--

