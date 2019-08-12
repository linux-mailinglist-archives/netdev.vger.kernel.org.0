Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED6D8A28E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfHLPoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:44:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbfHLPoD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 11:44:03 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B4C09305B886;
        Mon, 12 Aug 2019 15:44:02 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-57.rdu2.redhat.com [10.10.112.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66F261FE;
        Mon, 12 Aug 2019 15:44:01 +0000 (UTC)
Message-ID: <dc88624d6632f23a1b0ca77f45ed21a20158d3e6.camel@redhat.com>
Subject: Re: [PATCH rdma-next 0/4] Add XRQ and SRQ support to DEVX interface
From:   Doug Ledford <dledford@redhat.com>
To:     Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        Edward Srouji <edwards@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Date:   Mon, 12 Aug 2019 11:43:58 -0400
In-Reply-To: <20190808101059.GC28049@mtr-leonro.mtl.com>
References: <20190808084358.29517-1-leon@kernel.org>
         <20190808101059.GC28049@mtr-leonro.mtl.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-0589yvTJSop36pjdLUYZ"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 12 Aug 2019 15:44:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-0589yvTJSop36pjdLUYZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-08-08 at 10:11 +0000, Leon Romanovsky wrote:
> On Thu, Aug 08, 2019 at 11:43:54AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >=20
> > Hi,
> >=20
> > This small series extends DEVX interface with SRQ and XRQ legacy
> > commands.
>=20
> Sorry for typo in cover letter, there is no SRQ here.

Series looks fine to me.  Are you planning on the first two via mlx5-
next and the remainder via RDMA tree?

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-0589yvTJSop36pjdLUYZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl1RiT4ACgkQuCajMw5X
L90fDA/+KgZ6eeP3c/mtKZ7acgAl38DvSFLeRmCn+MzjvQ5Q8Mm6sLpxue/2jN1i
bukPqJsboJuGoP8ncPwHzB7aa1hdXmY/36p7Pur+l6ha3LSKE3LYlmnwkxjKkvkR
V0VXop1ocWJAq9TNXShWgN+DQPWpV3TO8TDhSsCl89pS7oke3i0tmkegzt9zTuqU
ypRe7u+At0RMpYHmwEMJe/Y3k91ZBHWCQymySGo/vgnf62J1O+91gBaemBxDJuwh
lz20BPyiVVTLmHqaMFImqLQ6VvYS4RuOYQql+rboxp1GRB3MbVJhgUrId2PaiGkJ
+cLD954assIjGMl5VvfmCN9SFWQzyw6JNbsYXBvTHBJ5pyepDmj0Q+kNJankMOhF
iJbhPG5jF/oab9Pv1jylQ198KT/eqn6rgwIF9/5bZUdkwtrIyFvRLY4zB89dJ4AX
qZQFgKvd+12dmgP9ts/NUwiykvxAMrP3jzi2Y000eqd+ar4E5/6fHH9Q9/7jpoqJ
6kVIy0Tm5sxEb8Q6gQIGJLPqUg8iW/uESQqZXJfYnWIQccr0RJ/3IfSDwnVK0Hsk
4eRlQRyBaH0VqUS8WG75mPhvmbxJvgjZopE3jgpTSIeVnuJqHWnYWsWFn6lc5wLH
W8qFEiyGO5uqYh38a3xESYMR+GmM3lHxHZq9wuFocJkgYugUCVE=
=I+Eh
-----END PGP SIGNATURE-----

--=-0589yvTJSop36pjdLUYZ--

