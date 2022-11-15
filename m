Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E939362974A
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiKOLWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiKOLWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:22:47 -0500
X-Greylist: delayed 584 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Nov 2022 03:22:45 PST
Received: from mail.katalix.com (mail.katalix.com [3.9.82.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6314B6551
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:22:44 -0800 (PST)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 14A1BA7BDA;
        Tue, 15 Nov 2022 11:12:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1668510779; bh=9Hmp7lsMwRXI6kuGnSdz/RVZR8abq1AKQJfN0PBVbDQ=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2015=20Nov=202022=2011:12:58=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Jakub=20Sitnicki=20<jakub@clou
         dflare.com>|Cc:=20netdev@vger.kernel.org,=20"David=20S.=20Miller"=
         20<davem@davemloft.net>,=0D=0A=09Eric=20Dumazet=20<edumazet@google
         .com>,=0D=0A=09Jakub=20Kicinski=20<kuba@kernel.org>,=20Paolo=20Abe
         ni=20<pabeni@redhat.com>,=0D=0A=09Haowei=20Yan=20<g1042620637@gmai
         l.com>|Subject:=20Re:=20[PATCH=20net=20v4]=20l2tp:=20Serialize=20a
         ccess=20to=20sk_user_data=20with=0D=0A=20sk_callback_lock|Message-
         ID:=20<20221115111258.GA5373@katalix.com>|References:=20<202211141
         91619.124659-1-jakub@cloudflare.com>|MIME-Version:=201.0|Content-D
         isposition:=20inline|In-Reply-To:=20<20221114191619.124659-1-jakub
         @cloudflare.com>;
        b=iFdJGih6L0hFTcE9dTErxijetOGThd8UDVpcJ7jLVc7v4s+1B1ZfW8qgzO9y4Rxvi
         n92eZfV3rwgrHro7I7oBmo57zjs/wiPvTQgXhDzDAxES7KoipaAHFd5YH2F4jaTest
         /FpamYFrpxgSvYUrBliP+k2TKSw8ycraMBvHg6+cMf1QYnSzKifPzOMO6tcZG6XZlO
         hgbQMYsRq8K1eIB6CxpW8I9S0UEUCxJ6vVxxLN7uKfGmubf3cZ8FGU5uZWIRetT3F8
         PAKDqlOOVSVUEaEsWXqVyBREwU2JKWh8VBCDRlUWbudx70tIIA3kq6+hp6sGGAi7ni
         /o4VEeKtIp6bQ==
Date:   Tue, 15 Nov 2022 11:12:58 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Haowei Yan <g1042620637@gmail.com>
Subject: Re: [PATCH net v4] l2tp: Serialize access to sk_user_data with
 sk_callback_lock
Message-ID: <20221115111258.GA5373@katalix.com>
References: <20221114191619.124659-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20221114191619.124659-1-jakub@cloudflare.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Mon, Nov 14, 2022 at 20:16:19 +0100, Jakub Sitnicki wrote:
> sk->sk_user_data has multiple users, which are not compatible with each
> other. Writers must synchronize by grabbing the sk->sk_callback_lock.
>=20
> l2tp currently fails to grab the lock when modifying the underlying tunnel
> socket fields. Fix it by adding appropriate locking.
>=20
> We err on the side of safety and grab the sk_callback_lock also inside the
> sk_destruct callback overridden by l2tp, even though there should be no
> refs allowing access to the sock at the time when sk_destruct gets called.
>=20
> v4:
> - serialize write to sk_user_data in l2tp sk_destruct
>=20
> v3:
> - switch from sock lock to sk_callback_lock
> - document write-protection for sk_user_data
>=20
> v2:
> - update Fixes to point to origin of the bug
> - use real names in Reported/Tested-by tags

LGTM, thanks Jakub.

>=20
> Cc: Tom Parkin <tparkin@katalix.com>
> Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
> Reported-by: Haowei Yan <g1042620637@gmail.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>=20
> This took me forever. Sorry about that.
>=20
>  include/net/sock.h   |  2 +-
>  net/l2tp/l2tp_core.c | 19 +++++++++++++------
>  2 files changed, 14 insertions(+), 7 deletions(-)
>=20
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 5db02546941c..e0517ecc6531 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -323,7 +323,7 @@ struct sk_filter;
>    *	@sk_tskey: counter to disambiguate concurrent tstamp requests
>    *	@sk_zckey: counter to order MSG_ZEROCOPY notifications
>    *	@sk_socket: Identd and reporting IO signals
> -  *	@sk_user_data: RPC layer private data
> +  *	@sk_user_data: RPC layer private data. Write-protected by @sk_callba=
ck_lock.
>    *	@sk_frag: cached page frag
>    *	@sk_peek_off: current peek_offset value
>    *	@sk_send_head: front of stuff to transmit
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 7499c51b1850..754fdda8a5f5 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1150,8 +1150,10 @@ static void l2tp_tunnel_destruct(struct sock *sk)
>  	}
> =20
>  	/* Remove hooks into tunnel socket */
> +	write_lock_bh(&sk->sk_callback_lock);
>  	sk->sk_destruct =3D tunnel->old_sk_destruct;
>  	sk->sk_user_data =3D NULL;
> +	write_unlock_bh(&sk->sk_callback_lock);
> =20
>  	/* Call the original destructor */
>  	if (sk->sk_destruct)
> @@ -1469,16 +1471,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunn=
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
> +	write_lock(&sk->sk_callback_lock);
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
> @@ -1504,7 +1508,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel=
, struct net *net,
> =20
>  		setup_udp_tunnel_sock(net, sock, &udp_cfg);
>  	} else {
> -		sk->sk_user_data =3D tunnel;
> +		rcu_assign_sk_user_data(sk, tunnel);
>  	}
> =20
>  	tunnel->old_sk_destruct =3D sk->sk_destruct;
> @@ -1518,6 +1522,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel=
, struct net *net,
>  	if (tunnel->fd >=3D 0)
>  		sockfd_put(sock);
> =20
> +	write_unlock(&sk->sk_callback_lock);
>  	return 0;
> =20
>  err_sock:
> @@ -1525,6 +1530,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel=
, struct net *net,
>  		sock_release(sock);
>  	else
>  		sockfd_put(sock);
> +
> +	write_unlock(&sk->sk_callback_lock);
>  err:
>  	return ret;
>  }
> --=20
> 2.38.1
>=20

--=20
Tom Parkin
Katalix Systems Ltd
https://katalix.com
Catalysts for your Embedded Linux software development

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmNzdDYACgkQlIwGZQq6
i9Dl6wgAr+kHl0G5Womae44/w376HChGZ/sT+YvNpgiYvlsNCIkcDP5TsiO3/ujh
565dDOZxbWjqaTTfYOYaOjpK0qDJ31ZfnaYL6NKudFxO9UnbYPH4e17ZJ4DInjUv
ZWfgY1v1xps6o/2E/uF/o1DbtnlGXNwdjJth/erxdiX+0jNs0g0D8Ex3bD/W6GAo
iFXk6f2P1pn1buv0sNAE1eWYQBX3KlSPQT1u2XWLglPko8XJXiR5BqkNNlhRAN0o
wEz6j19o/L/J0MRCYeuOMlZCPoKcWUMNflPDZWdgNnouLYp1rTjtAYKHzm8zgu4a
B02dvOp/ThxexiMGYouMjHv49wLnKg==
=hzea
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
