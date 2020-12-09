Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5822D4D7A
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388591AbgLIWUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388567AbgLIWUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 17:20:44 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DC5C0613CF;
        Wed,  9 Dec 2020 14:20:03 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Crs1F04wdz9sW8;
        Thu, 10 Dec 2020 09:20:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607552401;
        bh=vYl6b8T/pCw/U0nYGd0muwfFELQAOrkH03yaiZtHyX4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VRGb3q7cPatcCDByvi4VKJc3UeVLzak/7Tpamsdo+2HzUq5mOwYDAAA2DWMtHxMuK
         EwvF6UDOVOUJeBzKqmN4nKYmitvLwuu1s5jFT4gJAx9rh0hlY2C36QLUmFRtf05rfh
         m2nWBV1q42T1G1MdDC/LGqQ/08sS/rxSMkg5sGRB8zHtOQaZ8fRUn+cpX8kLQSo3rc
         UhsYZpnE7guuAsv8TDTxMHgblIKDGtz/o8uBPpXFyyxuK6rOwAtzbhz4L4jhVJv3sA
         zWg6HpffNU5E0bmJtDMWJi9gAcJzJ0vcZty0zHJxchiyzUxgYCoRmjn7/m18Cz6/Qh
         6LLu40OMpc/2w==
Date:   Thu, 10 Dec 2020 09:20:00 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Chris Mi <cmi@nvidia.com>
Subject: Re: linux-next: Tree for Dec 9 (ethernet/mellanox/mlx5)
Message-ID: <20201210092000.4c28192c@canb.auug.org.au>
In-Reply-To: <e5519ac6-1d25-632a-9b55-087d8ffaf386@infradead.org>
References: <20201209214447.3bfdeb87@canb.auug.org.au>
        <e5519ac6-1d25-632a-9b55-087d8ffaf386@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//nEQFZCzWmY_20I/Arc4J06";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_//nEQFZCzWmY_20I/Arc4J06
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 9 Dec 2020 12:14:39 -0800 Randy Dunlap <rdunlap@infradead.org> wrot=
e:
>
> On 12/9/20 2:44 AM, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Changes since 20201208:
> >  =20
>=20
> on i386:
>=20
> I see this warning:/note: repeated 106 times on i386 build:
>=20
>                  from ../drivers/net/ethernet/mellanox/mlx5/core/alloc.c:=
34:
> ../include/vdso/bits.h:7:26: warning: left shift count >=3D width of type=
 [-Wshift-count-overflow]
>  #define BIT(nr)   (UL(1) << (nr))
>                           ^
> ../include/linux/mlx5/mlx5_ifc.h:10716:46: note: in expansion of macro =
=E2=80=98BIT=E2=80=99
>   MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER =3D BIT(0x20),
>                                               ^~~

Introduced by commit

  2a2970891647 ("net/mlx5: Add sample offload hardware bits and structures")

now in the net-next tree.
--=20
Cheers,
Stephen Rothwell

--Sig_//nEQFZCzWmY_20I/Arc4J06
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/RTZAACgkQAVBC80lX
0Gw/fQgAlynJrf78Tpjjgez63yrCuHjGEUmkhVcTt3a48hpJQELbLU5V57TIvHUQ
tw+QxYrIs2hBKHcbJEY3MYTFyiFJ0YCM+zxusbdUHoAX5D8ANWTvHOFptq0voDRq
3JF4NDuwjCyVQsB6ghfO3B7awcX/N/dkAddx3MvlAwUwe0hlD57KFYI8LFdZfZBi
oKD6rttaQIVSo+uO5YT/cMPCy8t7V8eIaI4a9+vfpN7K7n/z8njDU7Y5IMAa1YVf
W5R6m2sOjBsJY75+ZgOffbkX2tojVVdSuTmbOsLzcDJEXM/Hs5YsRoGi8+10YlZQ
0j+/PEfSOIxucjQcKx7tpDUkeN94Fw==
=Swrk
-----END PGP SIGNATURE-----

--Sig_//nEQFZCzWmY_20I/Arc4J06--
