Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA535592FC1
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 15:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbiHONVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 09:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242856AbiHONVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 09:21:39 -0400
X-Greylist: delayed 16703 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Aug 2022 06:21:38 PDT
Received: from mail.katalix.com (mail.katalix.com [3.9.82.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A5D81CB35
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 06:21:38 -0700 (PDT)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 6DD5D7D578;
        Mon, 15 Aug 2022 14:21:37 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1660569697; bh=5FEUYfTBpQJd4LJz3xiIwkz+a/tMc3ESOmO/q0JfTmo=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Mon,=2015=20Aug=202022=2014:21:37=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Jakub=20Sitnicki=20<jakub@clou
         dflare.com>|Cc:=20netdev@vger.kernel.org,=20kernel-team@cloudflare
         .com,=0D=0A=09"David=20S.=20Miller"=20<davem@davemloft.net>,=0D=0A
         =09Eric=20Dumazet=20<edumazet@google.com>,=0D=0A=09Jakub=20Kicinsk
         i=20<kuba@kernel.org>,=20Paolo=20Abeni=20<pabeni@redhat.com>,=0D=0
         A=09Haowei=20Yan=20<g1042620637@gmail.com>|Subject:=20Re:=20[PATCH
         =20net=20v2]=20l2tp:=20Serialize=20access=20to=20sk_user_data=20wi
         th=20sock=0D=0A=20lock|Message-ID:=20<20220815132137.GB5059@katali
         x.com>|References:=20<20220815130107.149345-1-jakub@cloudflare.com
         >|MIME-Version:=201.0|Content-Disposition:=20inline|In-Reply-To:=2
         0<20220815130107.149345-1-jakub@cloudflare.com>;
        b=rdI61YmMVZEIs1k/Hq2UadsG20nGXXtg2OoF7q+U1/d/sEu2BzhqTVDgf4TIs+CdX
         ghK3yBVgat5CgCdkpCx1GGrlPYG/2N9DbKIg8JxiRN8DyJ33i1OQQqolabqdGHN0de
         4hLwa2vPRaRsCxsJGB2h6d5WdIWSjzRHaVmrTfBt8pWgCN1QaOG1RwHRPk/HD4Cm4/
         +ZMeRwALVgY1Y7bkxlkNsxRjWnZAaY2pLX8F0FEHTL+NBYJqiXTEg7lDtXqLoURBBB
         Phf0/NB2VAcDvPb+hwB1DjrtjbGHvtq9C4c3Lvq6QZhLq0p5wQ/EBNrq7eJ1rMtmDi
         SiOy1E3veN6dg==
Date:   Mon, 15 Aug 2022 14:21:37 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Haowei Yan <g1042620637@gmail.com>
Subject: Re: [PATCH net v2] l2tp: Serialize access to sk_user_data with sock
 lock
Message-ID: <20220815132137.GB5059@katalix.com>
References: <20220815130107.149345-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <20220815130107.149345-1-jakub@cloudflare.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Mon, Aug 15, 2022 at 15:01:07 +0200, Jakub Sitnicki wrote:
> sk->sk_user_data has multiple users, which are not compatible with each
> other. To synchronize the users, any check-if-unused-and-set access to the
> pointer has to happen with sock lock held.
>=20
> l2tp currently fails to grab the lock when modifying the underlying tunnel
> socket. Fix it by adding appropriate locking.
>=20
> We don't to grab the lock when l2tp clears sk_user_data, because it happe=
ns
> only in sk->sk_destruct, when the sock is going away.
>=20
> v2:
> - update Fixes to point to origin of the bug
> - use real names in Reported/Tested-by tags
>=20
> Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")

This still seems wrong to me.

In 3557baabf280 pppol2tp_connect checks/sets sk_user_data with
lock_sock held.

> Reported-by: Haowei Yan <g1042620637@gmail.com>
> Tested-by: Haowei Yan <g1042620637@gmail.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
> Cc: Tom Parkin <tparkin@katalix.com>
>=20
>  net/l2tp/l2tp_core.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 7499c51b1850..9f5f86bfc395 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1469,16 +1469,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunn=
el, struct net *net,
>  		sock =3D sockfd_lookup(tunnel->fd, &ret);
>  		if (!sock)
>  			goto err;
> -
> -		ret =3D l2tp_validate_socket(sock->sk, net, tunnel->encap);
> -		if (ret < 0)
> -			goto err_sock;
>  	}
> =20
> +	sk =3D sock->sk;
> +	lock_sock(sk);
> +
> +	ret =3D l2tp_validate_socket(sk, net, tunnel->encap);
> +	if (ret < 0)
> +		goto err_sock;
> +
>  	tunnel->l2tp_net =3D net;
>  	pn =3D l2tp_pernet(net);
> =20
> -	sk =3D sock->sk;
>  	sock_hold(sk);
>  	tunnel->sock =3D sk;
> =20
> @@ -1504,7 +1506,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel=
, struct net *net,
> =20
>  		setup_udp_tunnel_sock(net, sock, &udp_cfg);
>  	} else {
> -		sk->sk_user_data =3D tunnel;
> +		rcu_assign_sk_user_data(sk, tunnel);
>  	}
> =20
>  	tunnel->old_sk_destruct =3D sk->sk_destruct;
> @@ -1518,6 +1520,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel=
, struct net *net,
>  	if (tunnel->fd >=3D 0)
>  		sockfd_put(sock);
> =20
> +	release_sock(sk);
>  	return 0;
> =20
>  err_sock:
> @@ -1525,6 +1528,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel=
, struct net *net,
>  		sock_release(sock);
>  	else
>  		sockfd_put(sock);
> +
> +	release_sock(sk);
>  err:
>  	return ret;
>  }
> --=20
> 2.35.3
>=20

--=20
Tom Parkin
Katalix Systems Ltd
https://katalix.com
Catalysts for your Embedded Linux software development

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmL6SFsACgkQlIwGZQq6
i9BKLwgArnj3DJtyp5RKbo7u5vC5/s4Ao7jQCFcE4L5jgHeg/wnu0SeZ2Sd9yy8m
+WIKI6PQ/VJWY9IOjoGHf36QTwEDZW5qYq9cwCxbIv/flKZ8Shd/kFczxlWgVDVT
SMk4bqbeUs906TqFnLkQfW8+TSbqhVuzEeOhR3OpqSNaTohHzm+sjXbR8CeT4tLz
+F5mYyQqcCit8Ha/F10wII3YCmTpua4eTgbSSKIvb6F3t9hM7JhVhfeANssKrESY
3GzWiAJoGQLI6Vkkhq5xDl8RT+QeYewy5cPasU6fcZQ17IBIBvq92lL6NZDKN6kW
k5VrdLLpVOzfQ0VDZduU0mc/rx/7ww==
=MtLn
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
