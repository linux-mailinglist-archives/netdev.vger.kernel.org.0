Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBF349132
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 22:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfFQUTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 16:19:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfFQUTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 16:19:01 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EF27EC0524FB;
        Mon, 17 Jun 2019 20:19:00 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-63.rdu2.redhat.com [10.10.112.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 37DEF9839;
        Mon, 17 Jun 2019 20:18:59 +0000 (UTC)
Message-ID: <51c50b108d2ab2fc7ff22bf7b38053adca0c365e.camel@redhat.com>
Subject: Re: [PATCH rdma-next v1 0/4] Expose ENCAP mode to mlx5_ib
From:   Doug Ledford <dledford@redhat.com>
To:     Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Parav Pandit <parav@mellanox.com>, Petr Vorel <pvorel@suse.cz>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Date:   Mon, 17 Jun 2019 16:18:56 -0400
In-Reply-To: <20190616124357.GH4694@mtr-leonro.mtl.com>
References: <20190612122014.22359-1-leon@kernel.org>
         <20190616124357.GH4694@mtr-leonro.mtl.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-cDVk982+pcQY7caxNPz5"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 17 Jun 2019 20:19:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-cDVk982+pcQY7caxNPz5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2019-06-16 at 12:44 +0000, Leon Romanovsky wrote:
> On Wed, Jun 12, 2019 at 03:20:10PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >=20
> > Changelog v0->v1:
> >  * Added patch to devlink to use declared enum for encap mode
> > instead of u8
> >  * Constify input argumetn to encap mode function
> >  * fix encap variable type to be boolean
> >=20
> > -----------------------------------------------------------------
> > ----
> > Hi,
> >=20
> > This is short series from Maor to expose and use enacap mode inside
> > mlx5_ib.
> >=20
> > Thanks
> >=20
> > Leon Romanovsky (1):
> >   net/mlx5: Declare more strictly devlink encap mode
> >=20
> > Maor Gottlieb (3):
> >   net/mlx5: Expose eswitch encap mode
>=20
> Those two applied to mlx5-next
> 82b11f071936 net/mlx5: Expose eswitch encap mode
> 98fdbea55037 net/mlx5: Declare more strictly devlink encap mode
>=20
> >   RDMA/mlx5: Consider eswitch encap mode
> >   RDMA/mlx5: Enable decap and packet reformat on FDB
>=20
> Doug, Jason
>=20
> Can you please take those two patches in addition to latest mlx5-
> next?

Done, thanks.


--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
2FDD

--=-cDVk982+pcQY7caxNPz5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl0H9bAACgkQuCajMw5X
L917uA//e5x498U/O5qfHU6XmC/M8F30bbBP9608RzJTu6smZnw0HysLX98g9AeA
99dod1NvL8XSm6vJkZDFeMuCVHTXSIbnujEWbk5hSnqmgFxG+Q2sIG1pxmNft7zy
Bt+MWMoedRmuvQUgU3nQr8OcMRIXKaPuYCVaGvmhu5s4Q2Qy6SG3jK9ka/TN0lHP
63ke/oNQyY9Y7gnxfJRBfCfcAe+iF94S1rdWhKhQNM8E0zBJ0axzC+JcJAlm8qd/
eZX2++0FrBdDPInwWZfm8YZK41cTrit+jzZZr5EBuUdx1EoaBmUYOcXoL8kwUjM7
Sg6VzGLWoKLhJhhF2obvVZwu51x2uu1gzr2GCIN14kslxsyoxSwhOaX6YAk7bVLT
DJFcp21AEEVCi/2GZDPrWS55KI1uWy0azKfXKK9w7aDJXrs56MkJ/jII41c5IV9A
YVj6YffTL5CjMQikq6cLcOIybL9tZZtQM8OPrBhY5V23P1kXF+ZU1GTG6tnjuG9v
AHlUJ3XNCiMxtoxJfwXhhr4ifpwBeRoO7JVn3XPPIGTizAq53nNXb+QYNi3KPIYd
JhCvywYgm5Fhs6tapHuqnsIgWu5ACLEOOACHtA6G/sjRjGIreX8pck25bqAESS//
0M1XmdfGtCoInB/Zp8/pSW9dZD/pRVdh9+lY+yBiV+/LA8gcFvg=
=wE8p
-----END PGP SIGNATURE-----

--=-cDVk982+pcQY7caxNPz5--

