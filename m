Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3211EEEDB
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 02:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgFEAqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 20:46:31 -0400
Received: from ozlabs.org ([203.11.71.1]:32953 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgFEAqb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 20:46:31 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49dP900f9mz9sSF;
        Fri,  5 Jun 2020 10:46:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591317989;
        bh=v/V2tmExsWL7XWQtcEavYgZH/wfnaCe+ov9xQHal9Lw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Se73HZh/Ja38uuh4RJ7b1XPtarqWFBZmibNIrSiuTI9AfZBI5chSJ8R5yprKfJtdM
         DJ8RE63/Zk+u9yI5CJBEzYxTMM0yJ2J+xpxZq5dgDBezrL60Qe0TcNoCL6qrJ/g5GB
         KZz+Y8MJzmuAUS8cFQtmybqGpQ54Q2WyIDQTwWq9uXG+YPWCZOkOh0g6A9Rg08sBFY
         RkS6iwxb5Uf5wdEeEQorBdZ5cHfZ491HFx6WYmBcrcwB/cwPBwWdUL2Nqk5Bcq54SR
         F9uxRLPYFBAWx4lWkAiIDQHetjyF3uMg9XkOhrgpw0RFsdfSVwRnBSauKFKTEfiSku
         S/h5wquJv7AtA==
Date:   Fri, 5 Jun 2020 10:46:26 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: Re: linux-next: manual merge of the net-next tree with the nfsd
 tree
Message-ID: <20200605104626.4969f897@canb.auug.org.au>
In-Reply-To: <20200529131955.26c421db@canb.auug.org.au>
References: <20200529131955.26c421db@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.yt+CK9eQKH1i/Sllb_r5W6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/.yt+CK9eQKH1i/Sllb_r5W6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 29 May 2020 13:19:55 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the net-next tree got a conflict in:
>=20
>   net/sunrpc/svcsock.c
>=20
> between commits:
>=20
>   11bbb0f76e99 ("SUNRPC: Trace a few more generic svc_xprt events")
>   998024dee197 ("SUNRPC: Add more svcsock tracepoints")
>=20
> from the nfsd tree and commits:
>=20
>   9b115749acb2 ("ipv6: add ip6_sock_set_v6only")
>   7d7207c2d570 ("ipv6: add ip6_sock_set_recvpktinfo")
>=20
> from the net-next tree.
>=20
>=20
> diff --cc net/sunrpc/svcsock.c
> index 97d2b6f8c791,e7a0037d9b56..000000000000
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@@ -1357,7 -1322,11 +1343,6 @@@ static struct svc_xprt *svc_create_sock
>   	struct sockaddr *newsin =3D (struct sockaddr *)&addr;
>   	int		newlen;
>   	int		family;
> - 	int		val;
>  -	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
>  -
>  -	dprintk("svc: svc_create_socket(%s, %d, %s)\n",
>  -			serv->sv_program->pg_name, protocol,
>  -			__svc_print_addr(sin, buf, sizeof(buf)));
>  =20
>   	if (protocol !=3D IPPROTO_UDP && protocol !=3D IPPROTO_TCP) {
>   		printk(KERN_WARNING "svc: only UDP and TCP "

This is now a conflict between the nfsd tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/.yt+CK9eQKH1i/Sllb_r5W6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7ZleIACgkQAVBC80lX
0GzVFwf+NO6prTAGv0+7KO/2Phh3VvWR4Lp6PTj4MSXgiBFJWgdUatxQqW/TNX9a
KkQh0UtPzH93+VyC5TdLDCZFuCDPmiwZQfVvg1UUFrK7k13aLT1MBh+7BjgfqsYy
Wz7uBgBflba9lauKt8kL8iKJUbGuMZ0P9Y0Ae0xJdXFPxe9zCAB4vrVFxCS2JUg7
wn/5TrJ4vfu/+e9KP0VolPKsgJCzVgZH7hSxnErHq2scUH//HAs8THhPthT8e5kV
DCrOaeLy5ng83AUadS+glr7dYXXJjCM8j000+3JfVQLKUmr1tTlljy3DjAmqpJRo
Frm5RcYmQeJDo47ERqawWwqyErbPew==
=+smt
-----END PGP SIGNATURE-----

--Sig_/.yt+CK9eQKH1i/Sllb_r5W6--
