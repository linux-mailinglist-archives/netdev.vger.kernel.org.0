Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C291C0C78
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgEADMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEADMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:12:38 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C118BC035495;
        Thu, 30 Apr 2020 20:12:35 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49Cy3h6gYcz9sRf;
        Fri,  1 May 2020 13:12:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1588302754;
        bh=PEmTEM07EcMhSq9dBO/VlgkkATLgTQaiPSsap4ldA8E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T328w/yKzKrsJRVERNGTpxPvuZBnMbZhvuUJmFcNobPs1/P6punGcH5I9aUUmFPXX
         MvNGkRxQe6r4a6OT5v6gHPEfObqwsi2U9w15h8qfnggiWZ9PjWjAwDxp0kXNfATiO2
         CW11jdlL/sFrBVieT0+9sBYlI/vRODiqwlQorPzEC42sUK6KMpoepmSnCU1N5ljgcL
         i9YCrzao1pX1ujwBrFnKOdCxEVK2e8GhA0+JIgrxjUTmcuwFyy+LEuu1l4xapeIV/E
         vtapKSQS6n/u2UFLoadp0Jc9smlkFVRJpRu2YrvKfuLqHMLmbpTlkW1ijdCRDLKbAz
         unSuOQevAWVwA==
Date:   Fri, 1 May 2020 13:12:30 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huy Nguyen <huyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Raed Salem <raeds@mellanox.com>
Subject: Re: linux-next: manual merge of the mlx5-next tree with the
 kspp-gustavo tree
Message-ID: <20200501131230.58835994@canb.auug.org.au>
In-Reply-To: <20200429120625.2b5bb507@canb.auug.org.au>
References: <20200429120625.2b5bb507@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/3Wm6hv7q_O_SNduvacDF_Oj";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/3Wm6hv7q_O_SNduvacDF_Oj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 29 Apr 2020 12:06:25 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the mlx5-next tree got a conflict in:
>=20
>   include/linux/mlx5/mlx5_ifc.h
>=20
> between commit:
>=20
>   3ba225b506a2 ("treewide: Replace zero-length array with flexible-array =
member")
>=20
> from the kspp-gustavo tree and commit:
>=20
>   d65dbedfd298 ("net/mlx5: Add support for COPY steering action")
>=20
> from the mlx5-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc include/linux/mlx5/mlx5_ifc.h
> index 8d30f18dcdee,fb243848132d..000000000000
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@@ -5743,7 -5771,7 +5771,7 @@@ struct mlx5_ifc_alloc_modify_header_con
>   	u8         reserved_at_68[0x10];
>   	u8         num_of_actions[0x8];
>  =20
> - 	union mlx5_ifc_set_action_in_add_action_in_auto_bits actions[];
>  -	union mlx5_ifc_set_add_copy_action_in_auto_bits actions[0];
> ++	union mlx5_ifc_set_add_copy_action_in_auto_bits actions[];
>   };
>  =20
>   struct mlx5_ifc_dealloc_modify_header_context_out_bits {
> @@@ -9677,9 -9705,32 +9705,32 @@@ struct mlx5_ifc_mcda_reg_bits=20
>  =20
>   	u8         reserved_at_60[0x20];
>  =20
>  -	u8         data[0][0x20];
>  +	u8         data[][0x20];
>   };
>  =20
> + enum {
> + 	MLX5_MFRL_REG_RESET_TYPE_FULL_CHIP =3D BIT(0),
> + 	MLX5_MFRL_REG_RESET_TYPE_NET_PORT_ALIVE =3D BIT(1),
> + };
> +=20
> + enum {
> + 	MLX5_MFRL_REG_RESET_LEVEL0 =3D BIT(0),
> + 	MLX5_MFRL_REG_RESET_LEVEL3 =3D BIT(3),
> + 	MLX5_MFRL_REG_RESET_LEVEL6 =3D BIT(6),
> + };
> +=20
> + struct mlx5_ifc_mfrl_reg_bits {
> + 	u8         reserved_at_0[0x20];
> +=20
> + 	u8         reserved_at_20[0x2];
> + 	u8         pci_sync_for_fw_update_start[0x1];
> + 	u8         pci_sync_for_fw_update_resp[0x2];
> + 	u8         rst_type_sel[0x3];
> + 	u8         reserved_at_28[0x8];
> + 	u8         reset_type[0x8];
> + 	u8         reset_level[0x8];
> + };
> +=20
>   struct mlx5_ifc_mirc_reg_bits {
>   	u8         reserved_at_0[0x18];
>   	u8         status_code[0x8];

This is now a conflict between the net-next and kspp-gustavo trees.

--=20
Cheers,
Stephen Rothwell

--Sig_/3Wm6hv7q_O_SNduvacDF_Oj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6rk54ACgkQAVBC80lX
0GziZwgAktgIhS4cVUIEemnKH5jbGZPN+B2zibbUeQKdPPIadgrs8r617rsu7F51
Tr2M89lznsENYuY2VpBAuyl3uU+aIzLDlM9ufs1Euw9Id0IypyGG6SABFQTo+6jL
tU7qHfPcprdVtF9ZcWtHhEf6FHgeqvcXtFHRn9wavB9pOZYjN+xfQ9rAUP8vkded
kcKSqpxxk3Ifr2CriSr45uV2NCCWBFDRGRM8EZ54XZkNdl2z1+3l0qaAZFKyQxrR
+xIcTwcXuuTVA9Z1eO5PyznZUv0vq+XpOIww8Evkww6V2jLJi7bE//WxDVPvbU2j
zkbPvJl5Pu2a5Af1yUir49bsvsDKbA==
=uGS7
-----END PGP SIGNATURE-----

--Sig_/3Wm6hv7q_O_SNduvacDF_Oj--
