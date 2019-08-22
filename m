Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75C9399828
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 17:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732243AbfHVP3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 11:29:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731590AbfHVP3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 11:29:07 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C775330833CB;
        Thu, 22 Aug 2019 15:29:06 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-63.rdu2.redhat.com [10.10.112.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AEC26E707;
        Thu, 22 Aug 2019 15:29:05 +0000 (UTC)
Message-ID: <c7caa8eece02f3d15a0928663e9f64f99572f3ab.camel@redhat.com>
Subject: Re: [PATCH rdma-next 0/3] RDMA RX RoCE Steering Support
From:   Doug Ledford <dledford@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Date:   Thu, 22 Aug 2019 11:29:02 -0400
In-Reply-To: <20190821140204.GG4459@mtr-leonro.mtl.com>
References: <20190819113626.20284-1-leon@kernel.org>
         <6e099d052f1803e74b5731fe3da2d9109533734d.camel@redhat.com>
         <20190821140204.GG4459@mtr-leonro.mtl.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-XJg5FL1Fz1OzauK9oxVI"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 22 Aug 2019 15:29:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-XJg5FL1Fz1OzauK9oxVI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-08-21 at 17:02 +0300, Leon Romanovsky wrote:
> On Tue, Aug 20, 2019 at 01:54:59PM -0400, Doug Ledford wrote:
> > On Mon, 2019-08-19 at 14:36 +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >=20
> > > Hi,
> > >=20
> > > This series from Mark extends mlx5 with RDMA_RX RoCE flow steering
> > > support
> > > for DEVX and QP objects.
> > >=20
> > > Thanks
> > >=20
> > > Mark Zhang (3):
> > >   net/mlx5: Add per-namespace flow table default miss action
> > > support
> > >   net/mlx5: Create bypass and loopback flow steering namespaces
> > > for
> > > RDMA
> > >     RX
> > >   RDMA/mlx5: RDMA_RX flow type support for user applications
> >=20
> > I have no objection to this series.
>=20
> Thanks, first two patches were applied to mlx5-next
>=20
> e6806e9a63a7 net/mlx5: Create bypass and loopback flow steering
> namespaces for RDMA RX
> f66ad830b114 net/mlx5: Add per-namespace flow table default miss
> action support

mlx5-next merged into for-next, final patch applied, thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-XJg5FL1Fz1OzauK9oxVI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl1etL8ACgkQuCajMw5X
L91QBg/+Ow9YolvdQe9Z8H+fgqNCTBiFQ4GlK4L9QsNrAW8hbjrm+7fBUDG21wjy
Qnj00x/zo40DznU/2iEgmLi4h7FB5vlb1Z1YdBJ5+9gVlzNHQc0j1N5mtmYpiOaK
diRUoTfot7/pF9qearm/kO58/9v31B7A02SOrhp6VnMpVrRoZGomM+kXXJOLPVmg
9L7pwK3xjaZmRfiXAKrRI3Q9LwHDxBLTG+tkbRc5Otzr3ydN7iiumNIPMmuUQHxd
QYrsFlMtWXKQK2TWXFeDqPf/A/HbwA9ykwkY3+ZFRON2Xjx6Dzf+L+gHVbWb+qi0
jjpu/SQDoJBRWcP+hEKbv9tJnj73XebI/LqMP72JBX4X5Lpgrc7u63NZ+dYH0fif
HC3sdu72FGn0xKuvgMoKO1Sn5ooca9y/Jl6ZEx0cUDMUKb5IAk5PqQLJ34VdGnvr
IAGMOVeI8yii5xoy+BtBT1DrJdS2cL5yU46KeqCS06Q/rt+4i2TOtxfMMt+tZvZO
/gbzCIQFtFAlNRT3qqzA4zM+WnDyi6BocWhJr9LkgSjK4kFAvD+1JVgyd9UmXfSS
itADq4DOb1kwzEeyCQLq2hxLbwjpCuyeEnJ6AiZCFoq9nZLsFYLMNeaOd9JIfLIL
RGl7EEYZLYzuIYDKkLFSTAkBOSxklzTmq+hn6p0rrJ6QWSVydBA=
=dqBL
-----END PGP SIGNATURE-----

--=-XJg5FL1Fz1OzauK9oxVI--

