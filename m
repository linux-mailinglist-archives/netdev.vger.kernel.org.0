Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4668D78B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbfHNP7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:59:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfHNP7H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 11:59:07 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1F1E3317529A;
        Wed, 14 Aug 2019 15:59:07 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-57.rdu2.redhat.com [10.10.112.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EBD70891D6;
        Wed, 14 Aug 2019 15:59:05 +0000 (UTC)
Message-ID: <be26c48a5a749a80d7c5fdb6cb92b5c9dbf6b535.camel@redhat.com>
Subject: Re: [PATCH net-next 0/5] net/rds: Fixes from internal Oracle repo
From:   Doug Ledford <dledford@redhat.com>
To:     Gerd Rausch <gerd.rausch@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Date:   Wed, 14 Aug 2019 11:59:03 -0400
In-Reply-To: <0b05ed75-6772-e339-11e6-1fb5714981c0@oracle.com>
References: <0b05ed75-6772-e339-11e6-1fb5714981c0@oracle.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-8bJiVdzuohwfTvtBBxY5"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 14 Aug 2019 15:59:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-8bJiVdzuohwfTvtBBxY5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-08-13 at 11:20 -0700, Gerd Rausch wrote:
> This is the first set of (mostly old) patches from our internal
> repository
> in an effort to synchronize what Oracle had been using internally
> with what is shipped with the Linux kernel.
>=20
> Andy Grover (2):
>   RDS: Re-add pf/sol access via sysctl
>   rds: check for excessive looping in rds_send_xmit
>=20
> Chris Mason (2):
>   RDS: limit the number of times we loop in rds_send_xmit
>   RDS: don't use GFP_ATOMIC for sk_alloc in rds_create
>=20
> Gerd Rausch (1):
>   net/rds: Add a few missing rds_stat_names entries
>=20
>  net/rds/af_rds.c  |  2 +-
>  net/rds/ib_recv.c | 12 +++++++++++-
>  net/rds/rds.h     |  2 +-
>  net/rds/send.c    | 12 ++++++++++++
>  net/rds/stats.c   |  3 +++
>  net/rds/sysctl.c  | 21 +++++++++++++++++++++
>  6 files changed, 49 insertions(+), 3 deletions(-)
>=20

That first patch looks like a total bogon to me, but the remaining four
look fine.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-8bJiVdzuohwfTvtBBxY5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl1UL8cACgkQuCajMw5X
L92TTBAAlMy+mBp99ewXwbOtTsVjlA2Os65s44sVpe3kVyqmXD+pllwe7WkU62Ql
rLHzi3acwxncvS+b9lI2GjbS4ZglgCSimg/iTdSgnMgjH33xjJw4y9oh2S3x2Jcc
BDyCykpPKxFNHPJWUrS0HG/hUOYDyWs7stZztTItQ5WipUje3HpejvJ61XO1bIun
g4EGP1sfATZ5Z6M1IJmXi6gmF5JBDe7UgAD/H6mA0v0kcLwXkp8KPfKvCeDuQYZn
Cp0DILQLnpKwE3PVBsua6WWqT2huiex6wOtq3zyfWfR3SniTyNwJDC0UaA9Nhcpf
iEGKwAwIMoSH2w4F4Uz0Wz/X6pfqnYaXhDylzmnoYyTMAoDzR/74RgYJX5ms2z5L
+3Tzs0R4RIhkciYqJntIHkaZt49RTTxCgd9qquUg1cjmpvSEHDDLeNjsXsOInV1z
7a+CvOY3qwLJrVUMTT89TWg8G6U5wYXCVCGz04nuyOpD6+bW/oBNz8IB0qApfiWd
wd9rj52rj0Bpt32Bk8luAIqeyAM/vvuQJj1duoRZgRY7aI7IKE+UkQVHU30wPwGU
SKgDkVs/Q8OqcrgwqRvbQnoY7BI8OT0o+V2SG+x5Z80e6gb0sNxEIluhXf5DTLYb
1gFpGooral6YHpPKPQ42A0pbray65PzF9J+BOdLQUtWnHl+VIW0=
=xMH5
-----END PGP SIGNATURE-----

--=-8bJiVdzuohwfTvtBBxY5--

