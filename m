Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3DC948CED
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFQSu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:50:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbfFQSu1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 14:50:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D473130C0DEA;
        Mon, 17 Jun 2019 18:50:21 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-63.rdu2.redhat.com [10.10.112.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E16C152FA;
        Mon, 17 Jun 2019 18:50:20 +0000 (UTC)
Message-ID: <660becf7676076f6b9cd7e0aa3f9bc92347ce3f9.camel@redhat.com>
Subject: Re: [PATCH 1/2] ipoib: correcly show a VF hardware address
From:   Doug Ledford <dledford@redhat.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        mkubecek@suse.cz
Date:   Mon, 17 Jun 2019 14:50:18 -0400
In-Reply-To: <20190617085341.51592-1-dkirjanov@suse.com>
References: <20190617085341.51592-1-dkirjanov@suse.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-PLhUO8sElGh7lG+uVpDI"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 17 Jun 2019 18:50:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-PLhUO8sElGh7lG+uVpDI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-06-17 at 10:53 +0200, Denis Kirjanov wrote:
> in the case of IPoIB with SRIOV enabled hardware
> ip link show command incorrecly prints
> 0 instead of a VF hardware address.
>=20
> Before:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0 MAC 00:00:00:00:00:00, spoof checking off, link-state
> disable,
> trust off, query_rss off
> ...
> After with iproute2 patch[0]
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
> checking off, link-state disable, trust off, query_rss off
>=20
> [0]: https://patchwork.kernel.org/patch/10997111/
>=20
> v1->v2: just copy an address without modifing ifla_vf_mac
> v2->v3: update the changelog
> v3->v4: update the changelog: add a link to the patch for iproute2
>=20
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>

I assume you want this to go as a series through netdev, so you can add
my:

Acked-by: Doug Ledford <dledford@redhat.com>

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
2FDD

--=-PLhUO8sElGh7lG+uVpDI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl0H4OoACgkQuCajMw5X
L93VBA//V6RMpPDJfgEzqBckk4dQeJRvUqVIVtnn7EtHDmI3aGVS1T/Ka7d2frfz
AX3f6POwgj8RHE/7BkAWJ2S//KJdpkBFml4aYc4pwLa2HKGvHTinDdlI5Ef2eJdn
utiucrAuZx7L/dQggnuB7BjiuB6IOpTyZYfBs2COZ1x5Hq+CsLX04Z8Gq6iQdntR
f/llPcBsV1339+YNUmvB30GkNRkGD5Nsf7sLlXR8kA4SB3P25MOwbEBxJqYxMqT8
Q9G3oMKfU53enuOiqq7FmnIhqB90szll4a0xAsaA8+exOi4CCamyZZIW72LqEC+1
2x/UcPKIYMhC+eKBMZoVrw/Hi1rgAB7p8YlnY/GOCRyowaxOMZ8ORGiK0vuhkBRo
tC2N/EXunxohWK/BYNy07byEeRrM+FfLPRIwfVrK7+wQI/fU0hJokisMAjGJjb6e
14E+ozdEQeId6IVrYuB34Wf6rDPDepNN86UXW3WxteJFCdGQq9t9fyfPAwsf3Nto
Gf44eQWBAv+S9pmkqbrIb+R3XzQk99F0+h3jRsuqt8RoNtOKDUwMUcGLR+lLFFxh
gzePupAlZKJIp4FrAdA/0MnUHwgAjL88+XqkiRX62765s0GX2l1fDNAg8QVBfIzv
Ik7sT2Rqr2Iajj2qNyKV3nEfhBdKud6T8dSjDd+lFydwZDUH9Ew=
=5/A3
-----END PGP SIGNATURE-----

--=-PLhUO8sElGh7lG+uVpDI--

