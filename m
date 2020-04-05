Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6472E19E82A
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 03:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgDEBDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 21:03:04 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:33033 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbgDEBDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Apr 2020 21:03:04 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48vwQB4jswz9sP7;
        Sun,  5 Apr 2020 11:02:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1586048580;
        bh=1blZoo3vVyhmNqddNOFTZ6uyACtlgq/IeEhOrTE/sUc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sXahE9V7LMQFiVUgz2ZqgK5vEh41rJ+3IMOw6bk7rr9TYxTAUsoAA/h0vIOiKSH+U
         vvBi7QfCSzWPYWkTd/FKiz+GHke1z/hO+RSOyATnrJSRlFCNLABRGZ4bFBsatcRrZw
         NYwMylTrS8WVV5UxEsiE3k0xJ5ZiM1G/Vy6WLLiSpXSh7WKTbDAtU1cCcfhOXuumjC
         ZJG5TAoyQHOQFZ/uRv4NSBcXwDvBBUSNPSQIoCLhu0QT5Mwlb+ETKW2c1vdx/HWWSW
         Lw2MDYk0fZSFzYDishXeqWxfgoHJHNwmF2xHh5xsDn2SX5LikUgNuIKD8fPNZc0fHv
         NfcPDkj0hnaMg==
Date:   Sun, 5 Apr 2020 11:02:51 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KP Singh <kpsingh@google.com>
Subject: Re: linux-next: manual merge of the keys tree with the bpf-next
 tree
Message-ID: <20200405110251.2a15afe2@canb.auug.org.au>
In-Reply-To: <20200330130636.0846e394@canb.auug.org.au>
References: <20200330130636.0846e394@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fmd/H82N.UluJmFTwe6HCM/";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fmd/H82N.UluJmFTwe6HCM/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 30 Mar 2020 13:06:36 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the keys tree got a conflict in:
>=20
>   include/linux/lsm_hooks.h
>=20
> between commit:
>=20
>   98e828a0650f ("security: Refactor declaration of LSM hooks")
>=20
> from the bpf-next tree and commits:
>=20
>   e8fa137bb3cb ("security: Add hooks to rule on setting a watch")
>   858bc27762c1 ("security: Add a hook for the point of notification inser=
tion")
>=20
> from the keys tree.
>=20
> I fixed it up (I used the former version of this file and added the
> following merge resolution patch) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 30 Mar 2020 12:55:31 +1100
> Subject: [PATCH] security: keys: fixup for "security: Refactor declaratio=
n of
>  LSM hooks"
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/lsm_hook_defs.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 9cd4455528e5..4f8d63fd1327 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -252,6 +252,16 @@ LSM_HOOK(int, 0, inode_notifysecctx, struct inode *i=
node, void *ctx, u32 ctxlen)
>  LSM_HOOK(int, 0, inode_setsecctx, struct dentry *dentry, void *ctx, u32 =
ctxlen)
>  LSM_HOOK(int, 0, inode_getsecctx, struct inode *inode, void **ctx,
>  	 u32 *ctxlen)
> +#ifdef CONFIG_KEY_NOTIFICATIONS
> +LSM_HOOK(int, 0, watch_key, struct key *key)
> +#endif
> +#ifdef CONFIG_DEVICE_NOTIFICATIONS
> +LSM_HOOK(int, 0, watch_devices, void)
> +#endif
> +#ifdef CONFIG_WATCH_QUEUE
> +LSM_HOOK(int, 0, post_notification, const struct cred *w_cred,
> +	 const struct cred *cred, struct watch_notification *n)
> +#endif
> =20
>  #ifdef CONFIG_SECURITY_NETWORK
>  LSM_HOOK(int, 0, unix_stream_connect, struct sock *sock, struct sock *ot=
her,
> --=20
> 2.25.0

This is now a conflict between the keys tree and Linus' tree.
--=20
Cheers,
Stephen Rothwell

--Sig_/fmd/H82N.UluJmFTwe6HCM/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6JLjsACgkQAVBC80lX
0GyWVwgAkcTlPF9X4YXQU9Tf2+Zf/cdI2g0kySmk4IzT6s0bVWBr6pfHEuFWnMRy
Yi8GZMF+sbbV4Agem5o/KdfzTrjF2xfnC4N/BRxTDwK6IavBBNIxwyQdOpkRcRSS
b+WdKRnwwfszxWAAZa3oqXCKIdT9OSCjfZyEfTMYnEBS3MFDw/HhgJujHoG+EmVJ
TF+9i59lT47/AN1Adwcs5Psr/aIxf6V/8+sl47e7TimgUnvch+LrEz53ByFhcMCg
TYrKdXNjRdfD5F4xRJwQLGDjFJaEQxFchPhB7CD8sVDTSsXPYPQh7lYeC0PRC3iv
0ouA1ztljHL3YloZ8wDHH9thoW0Fzg==
=x0hx
-----END PGP SIGNATURE-----

--Sig_/fmd/H82N.UluJmFTwe6HCM/--
