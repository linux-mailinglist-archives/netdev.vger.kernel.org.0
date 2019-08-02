Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A001800AE
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391852AbfHBTIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:08:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34546 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbfHBTIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 15:08:34 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD27D89AD0;
        Fri,  2 Aug 2019 19:08:33 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-50.rdu2.redhat.com [10.10.112.50])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F0925D9E2;
        Fri,  2 Aug 2019 19:08:31 +0000 (UTC)
Message-ID: <76d6d890c70397d184f8dbc88f9f9de42cb3e567.camel@redhat.com>
Subject: Re: [PATCH V2] mlx5: Fix formats with line continuation whitespace
From:   Doug Ledford <dledford@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "joe@perches.com" <joe@perches.com>,
        "leon@kernel.org" <leon@kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Fri, 02 Aug 2019 15:08:19 -0400
In-Reply-To: <910f77ed7f2923206adc8927204c6d759ec18d20.camel@mellanox.com>
References: <f14db3287b23ed8af9bdbf8001e2e2fe7ae9e43a.camel@perches.com>
         <20181101073412.GQ3974@mtr-leonro.mtl.com>
         <ac8361beee5dd80ad6546328dd7457bb6ee1ca5a.camel@redhat.com>
         <f2b2559865e8bd59202e14b837a522a801d498e2.camel@perches.com>
         <910f77ed7f2923206adc8927204c6d759ec18d20.camel@mellanox.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-pzRitbc4Ei4uyzoykOWO"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 02 Aug 2019 19:08:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-pzRitbc4Ei4uyzoykOWO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-08-02 at 18:32 +0000, Saeed Mahameed wrote:
> On Fri, 2019-08-02 at 11:09 -0700, Joe Perches wrote:
> > On Tue, 2018-11-06 at 16:34 -0500, Doug Ledford wrote:
> > > On Thu, 2018-11-01 at 09:34 +0200, Leon Romanovsky wrote:
> > > > On Thu, Nov 01, 2018 at 12:24:08AM -0700, Joe Perches wrote:
> > > > > The line continuations unintentionally add whitespace so
> > > > > instead use coalesced formats to remove the whitespace.
> > > > >=20
> > > > > Signed-off-by: Joe Perches <joe@perches.com>
> > > > > ---
> > > > >=20
> > > > > v2: Remove excess space after %u
> > > > >=20
> > > > >  drivers/net/ethernet/mellanox/mlx5/core/rl.c | 6 ++----
> > > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > > >=20
> > > >=20
> > > > Thanks,
> > > > Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> > >=20
> > > Applied, thanks.
> >=20
> > Still not upstream.  How long does it take?
> >=20
>=20
> Doug, Leon, this patch still apply, let me know what happened here ?
> and if you want me to apply it to one of my branches.

I'm not entirely sure what happened here.  Obviously I said I had taken
it, which I don't do under my normal workflow until I've actually
applied and build tested the patch.  For it to not make it into the tree
means that I probably applied it to my wip/dl-for-next branch, but prior
to moving it to for-next, I might have had a rebase and it got lost in
the shuffle or something like that.  My apologies for letting it slip
through the cracks.  Anyway, I pulled the patch from patchworks, applied
it, and pushed it to k.o.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-pzRitbc4Ei4uyzoykOWO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl1EiiMACgkQuCajMw5X
L92JuQ/+LYwoMz5g+dwlMLtnq8MkugbuOW7+2ki/QEYBGJLgsWcvZQlCCogsTBEN
AvHFwydXoujplix9dCXmCWwu0wM9A+kEgbOnrx7i5Yf6NGljBRNxHBAvga7RtAsy
zTPd1Ywg5+Y1eNi+eQdIJSNa0Z8BJQd8QTOlBzixXM0kzSW/2qP0gfWY9pmXgaI4
UNdALPSc7sSO5mnVEGjOiCLN+X8+kJdXMAqh58eTYEvhZMfYhtsjhwtus7iBV0tK
WUEEdEWu/lCpYtGDdg0XIQQK8/4iO2Qgp+gOUUtcKOjbU68rOFWjOQ8VOUqJSWSs
Rqo0kKPCbK6XXM7FGJ7/KLOjVWtzIg4I0BOTQlgKffmtniziKd2mARKFbwZGWP2f
LkuE80rofWj5zoUp+YM+Mgiraak9EK/hD27tY2X6LamaVzXCr+yH9bCqx7cpaRvm
foUAmk+UMXHacqB9i4MshHLhY2F6JA3b7b+k7Fy6+ZVezmuxxYKEZqhtJCVMhl2C
2k/vuRC2oMowbQl/YN0kH/c4A88+UKNqGI5PYrGH6NYZusmXX0vjWHQhdlpPox+8
8zi80QuviijrPBk+HUsGrhuBzTHDn1BhyuLhTNpWV9TJrktGC6JMFO86H5EZyqB0
lRT02NjTucfdTwIB3dhP1bWENBa2tcqgOIsk5Vc6MqwnphSRJZo=
=bpdO
-----END PGP SIGNATURE-----

--=-pzRitbc4Ei4uyzoykOWO--

