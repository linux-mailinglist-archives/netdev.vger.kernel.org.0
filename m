Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2861831D
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 03:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfEIBH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 21:07:29 -0400
Received: from ozlabs.org ([203.11.71.1]:44657 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbfEIBH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 21:07:28 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44zwDY0Tfkz9sBV;
        Thu,  9 May 2019 11:07:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1557364045;
        bh=z7RKUdcv39RmUFu7h7XjjB8CeA+0giObheLTz+x3H5Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OvRBXXdx3fE+9ApExagCmYf7N/2JJElmdcQE/IiEqili3QXa3kjiMYVVzgEU3fcC3
         gWUYCpxRp/ipB+Zn3Qfc0Vio0rHUGExhxyomchwKFAxqNnsRWZ58nHgxOfZtJZjtc3
         VH0FMOMFhTvZX6uxb1eCcLk6/jWXoSqtt98vhftDNeCbhNoVqK+fEnYmt4v95VJv1a
         G+gA79/MxN3351syVdT2keMh43gYIOMPmmTRYZ2RNVUS/rX0HYW4Pd4lt3qFLZmc6u
         d2MBWcJjl0CcDv5zSr0XIEsK+K2cFPX7BGOXUShgqgwTcpAjoNyXknemYe/RFCY+p0
         dTwzhiQCH/d+g==
Date:   Thu, 9 May 2019 11:07:24 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Networking <netdev@vger.kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vu Pham <vuhuong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: Re: linux-next: manual merge of the mlx5-next tree with the rdma
 tree
Message-ID: <20190509110724.6694d991@canb.auug.org.au>
In-Reply-To: <20190506140147.23d41ac1@canb.auug.org.au>
References: <20190430135846.0c17df6e@canb.auug.org.au>
        <20190506140147.23d41ac1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/n5dCGEwjrWyPV6gM/vr=LWj"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/n5dCGEwjrWyPV6gM/vr=LWj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 6 May 2019 14:01:47 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Hi all,
>=20
> On Tue, 30 Apr 2019 13:58:46 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > Hi Leon,
> >=20
> > Today's linux-next merge of the mlx5-next tree got a conflict in:
> >=20
> >   drivers/infiniband/hw/mlx5/main.c
> >=20
> > between commit:
> >=20
> >   35b0aa67b298 ("RDMA/mlx5: Refactor netdev affinity code")
> >=20
> > from the rdma tree and commit:
> >=20
> >   c42260f19545 ("net/mlx5: Separate and generalize dma device from pci =
device")
> >=20
> > from the mlx5-next tree.
> >=20
> > I fixed it up (see below) and can carry the fix as necessary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts.
> >=20
> > --=20
> > Cheers,
> > Stephen Rothwell
> >=20
> > diff --cc drivers/infiniband/hw/mlx5/main.c
> > index 6135a0b285de,fae6a6a1fbea..000000000000
> > --- a/drivers/infiniband/hw/mlx5/main.c
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@@ -200,12 -172,18 +200,12 @@@ static int mlx5_netdev_event(struct not
> >  =20
> >   	switch (event) {
> >   	case NETDEV_REGISTER:
> >  +		/* Should already be registered during the load */
> >  +		if (ibdev->is_rep)
> >  +			break;
> >   		write_lock(&roce->netdev_lock);
> > - 		if (ndev->dev.parent =3D=3D &mdev->pdev->dev)
> >  -		if (ibdev->rep) {
> >  -			struct mlx5_eswitch *esw =3D ibdev->mdev->priv.eswitch;
> >  -			struct net_device *rep_ndev;
> >  -
> >  -			rep_ndev =3D mlx5_ib_get_rep_netdev(esw,
> >  -							  ibdev->rep->vport);
> >  -			if (rep_ndev =3D=3D ndev)
> >  -				roce->netdev =3D ndev;
> >  -		} else if (ndev->dev.parent =3D=3D mdev->device) {
> > ++		if (ndev->dev.parent =3D=3D mdev->device)
> >   			roce->netdev =3D ndev;
> >  -		}
> >   		write_unlock(&roce->netdev_lock);
> >   		break;
> >    =20
>=20
> This is now a conflict between the net-next tree and the rdma tree.

And now between the rdma tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/n5dCGEwjrWyPV6gM/vr=LWj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzTfUwACgkQAVBC80lX
0GwMrQf/VkAhwibKjn27GJoRox74VtVB3guRMFjw+TsMO5fCNIdGkRtROoHV7Fgi
AtbKH6CQXw54+q+2sHbPqBvOb9tmsPshuDJ8jvwzp989QNGHrbIshDLvOJLhRUhl
XLjf+jIHazXYa5w/7JIELz9JOGgJ6ySOvFjwrpvjGDEUtWcxzWMvzDhq9cOYDf/n
szEpKMRvAo9UgTqCzEVW/HMypUfJp7c/yESFz5iildGt91IR0t62aLZC9u4rBPij
NAlXWQyHewIcp5bJFgIxwn4cJeIXanpB4ax8MGuHhdHrj864eo6AeRNPuEXoLVvD
Y7mG1T8oFfei+wr6/NP+P0TSdBVugw==
=VkZ9
-----END PGP SIGNATURE-----

--Sig_/n5dCGEwjrWyPV6gM/vr=LWj--
