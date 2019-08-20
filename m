Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA1496816
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 19:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbfHTRzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 13:55:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53556 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbfHTRzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 13:55:04 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B5C12C0022F1;
        Tue, 20 Aug 2019 17:55:03 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-63.rdu2.redhat.com [10.10.112.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4098427CCF;
        Tue, 20 Aug 2019 17:55:02 +0000 (UTC)
Message-ID: <6e099d052f1803e74b5731fe3da2d9109533734d.camel@redhat.com>
Subject: Re: [PATCH rdma-next 0/3] RDMA RX RoCE Steering Support
From:   Doug Ledford <dledford@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Date:   Tue, 20 Aug 2019 13:54:59 -0400
In-Reply-To: <20190819113626.20284-1-leon@kernel.org>
References: <20190819113626.20284-1-leon@kernel.org>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-3B5VOJtY6hTY/+Hg+kip"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 20 Aug 2019 17:55:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-3B5VOJtY6hTY/+Hg+kip
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-08-19 at 14:36 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> Hi,
>=20
> This series from Mark extends mlx5 with RDMA_RX RoCE flow steering
> support
> for DEVX and QP objects.
>=20
> Thanks
>=20
> Mark Zhang (3):
>   net/mlx5: Add per-namespace flow table default miss action support
>   net/mlx5: Create bypass and loopback flow steering namespaces for
> RDMA
>     RX
>   RDMA/mlx5: RDMA_RX flow type support for user applications

I have no objection to this series.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-3B5VOJtY6hTY/+Hg+kip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl1cM/MACgkQuCajMw5X
L92Qmg//TjZFAGoUsS2Mx4bqktSXOLOvSnKtxGJE9nSmZzNftq7zbhqmnCMEizA7
j6Jd7WyVAQu1aHQRvRlH1swQlY8S88yLV8HGtLtcALI1/2auyy8734Loaer3eVJh
x6D+TC8bneDIFzWXhuq7Ug7qucSqL40elklo1s9qMSBgp/YC9iulH1GrPcH+kMS6
CByqlg7y6zLpvBcdFnYp78mroRt1jzSxH7vCpm2HrEvdFZEmGbOYYITryy5FAwUj
tK9HarL1uc4k28J8UW6nQBtH6QKCsWhwV5+G7VdTWBK1G+zDoZXs17MkDOLP9oJZ
+Hq+5xDTAF53aSMNjKa35mcqRwJvS32hrfigrcsX+7ZnmGvRMOMMYqMdLsX4dMil
Qlh/cer70af/0yx+CS1ysJ2vryJWVo0D+6a0HwcQ6XVlFyZxKyc+tDO4wIWXaHuW
fOTHNb/hM6MBfVnQxUjYTvbluqGw6CSqGtPYniGTknj65k5+tiO8ohHfIcGUdLJV
SDiineOwkxusockHG2WOCSmKrY2Q6H9YcNl2QtzIEtgg3FL6FAv1/vv5lHlBfu4R
z04Gr4pihJoGxbpbZX9SXK9jScub9yZLynxl4ygpu2Mimwn/GgZSN9uDxaPwwb75
0ciFc5MFZzONviyjApSegTGT1T2C28MohHh6bqzJwkH0JRAMGBY=
=/ncf
-----END PGP SIGNATURE-----

--=-3B5VOJtY6hTY/+Hg+kip--

