Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C738D966AB
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbfHTQoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:44:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbfHTQoE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 12:44:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8ECCD87648;
        Tue, 20 Aug 2019 16:44:04 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-63.rdu2.redhat.com [10.10.112.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFD1E90F44;
        Tue, 20 Aug 2019 16:44:03 +0000 (UTC)
Message-ID: <14c1cf427331900f296cf80b09bb25890d9dd0a0.camel@redhat.com>
Subject: Re: [PATCH mlx5-next 0/5] Mellanox, Updates for mlx5-next branch
 2019-08-15
From:   Doug Ledford <dledford@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Date:   Tue, 20 Aug 2019 12:44:01 -0400
In-Reply-To: <20190815194543.14369-1-saeedm@mellanox.com>
References: <20190815194543.14369-1-saeedm@mellanox.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-KD6TU4HR7jxZbRNWVe9c"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 20 Aug 2019 16:44:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-KD6TU4HR7jxZbRNWVe9c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-08-15 at 19:46 +0000, Saeed Mahameed wrote:
> Hi All,
>=20
> This series includes misc updates for mlx5-next shared branch.
>=20
> mlx5 HW spec and bits updates:
> 1) Aya exposes IP-in-IP capability in mlx5_core.
> 2) Maxim exposes lag tx port affinity capabilities.
> 3) Moshe adds VNIC_ENV internal rq counter bits.
>=20
> Misc updates:
> 4) Saeed, two compiler warnings cleanups
>=20
> In case of no objection this series will be applied to mlx5-next
> branch
> and sent later as pull request to both rdma-next and net-next
> branches.
>=20
> Thanks,
> Saeed.

Series looks fine to me.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-KD6TU4HR7jxZbRNWVe9c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIyBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl1cI1EACgkQuCajMw5X
L92Fww/3dAB8PdPPJ1drOD+8P9kCOOzwvMbNyttODjWsX83baeZuz/riG+xt7qI5
GNm6fhWxizEgdvlcuDhfgdYG9nk6itz6pbLK5BtWV0dzUnvGpmUR5pYdc26j/Imd
XgOvLxvwYlJvSLVRzI3EUIR/sJ+owaq+WXBctU1RwJZ5x2VQdTcV2rl25jdM9CE5
eIIi8do0yryseLBO7SH6y5XuaYsmFerJ4V8+0a3/n8mQDyjXyNDqcCLPXrD6NG7/
hfAgfvIri0HimKdFc/TUz4CIGfr7FBOMaR2WmpqaEcO9CQODgShSFcEtvPyhNPg9
U/nzBgbKp8xkCvDCmHupIM9OCna6d9/PnC2QSklrjzgZ5nvcaWTw2+1SWQV59YV/
AncnFYy5NhWFi0aMYnfv1ZtE33waBJmx5ysLedsGvGLq9HFVdn8cgvBNUpxOSZqo
E5vRGAO7jFVn6inb8dKYY8xXiZWxQL/A3RhnRMpC/96kfDAN3Awj/GSsC+jD8ltS
NsW2UWjHjQUjgrQXlnIxiSrsRH+E6aXfsk2W9UTtoPNjgEZbR6+7fbQwSBz7dqdn
EuNFCG2sK2HJPZOImjGQ28AqOS5K0uBeUa+VNFXSPjDFiU7X4BN5l7QMt4wWnUEO
dE3L3JPM9OH9uEJwH4Ts8FG8PfMnYEn4GRKRxTsPcR3TG+PpAA==
=xuBo
-----END PGP SIGNATURE-----

--=-KD6TU4HR7jxZbRNWVe9c--

