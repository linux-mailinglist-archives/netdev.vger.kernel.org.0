Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47C2593017
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 15:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiHONjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 09:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiHONjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 09:39:03 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A04C22127A
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 06:39:02 -0700 (PDT)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id D30D9A78EC;
        Mon, 15 Aug 2022 14:39:01 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1660570741; bh=VBv2+vW/5E3W/7zdsXgIef1hROVLG5wiR70N1+RXl4o=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Mon,=2015=20Aug=202022=2014:39:01=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Jakub=20Sitnicki=20<jakub@clou
         dflare.com>|Cc:=20netdev@vger.kernel.org,=20kernel-team@cloudflare
         .com,=0D=0A=09"David=20S.=20Miller"=20<davem@davemloft.net>,=0D=0A
         =09Eric=20Dumazet=20<edumazet@google.com>,=0D=0A=09Jakub=20Kicinsk
         i=20<kuba@kernel.org>,=20Paolo=20Abeni=20<pabeni@redhat.com>,=0D=0
         A=09Haowei=20Yan=20<g1042620637@gmail.com>|Subject:=20Re:=20[PATCH
         =20net=20v2]=20l2tp:=20Serialize=20access=20to=20sk_user_data=20wi
         th=20sock=0D=0A=20lock|Message-ID:=20<20220815133901.GC5059@katali
         x.com>|References:=20<20220815130107.149345-1-jakub@cloudflare.com
         >=0D=0A=20<20220815132137.GB5059@katalix.com>=0D=0A=20<875yittz3n.
         fsf@cloudflare.com>|MIME-Version:=201.0|Content-Disposition:=20inl
         ine|In-Reply-To:=20<875yittz3n.fsf@cloudflare.com>;
        b=qn3AFLK6MKVxARzMELkRQKyEOIAzda2TYue0ZbNcxIl6HcWb0goVhtbL8kkfkvF6T
         J+eZ/RwyTt2bUcMUt5jd1JY7vngfKMRFslYymRJEYCYPsB3qFYgWuckrIariSRGqjQ
         1tJVODn302+FRkkQU7uvEy+TQ8ctBRvNBdyvVara9Njl2I0jfZUWznH0c8OlmtsKJF
         I/EvFm9mlIFU9kcXvFsUp8s4lKXmVEQunf1SBLETnEUbgBEPV5+ICbV5SbScj5suRo
         p12/jMhelMnTIMf/MXaNM6aW1QRLbcwkPZxVUsKzTsSEFZ6fQLY0om/+5Y8rIUdc2T
         tQZ6sRb9bibzA==
Date:   Mon, 15 Aug 2022 14:39:01 +0100
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
Message-ID: <20220815133901.GC5059@katalix.com>
References: <20220815130107.149345-1-jakub@cloudflare.com>
 <20220815132137.GB5059@katalix.com>
 <875yittz3n.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Content-Disposition: inline
In-Reply-To: <875yittz3n.fsf@cloudflare.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Mon, Aug 15, 2022 at 15:26:51 +0200, Jakub Sitnicki wrote:
> On Mon, Aug 15, 2022 at 02:21 PM +01, Tom Parkin wrote:
> > [[PGP Signed Part:Undecided]]
> > On  Mon, Aug 15, 2022 at 15:01:07 +0200, Jakub Sitnicki wrote:
> >> sk->sk_user_data has multiple users, which are not compatible with each
> >> other. To synchronize the users, any check-if-unused-and-set access to=
 the
> >> pointer has to happen with sock lock held.
> >>=20
> >> l2tp currently fails to grab the lock when modifying the underlying tu=
nnel
> >> socket. Fix it by adding appropriate locking.
> >>=20
> >> We don't to grab the lock when l2tp clears sk_user_data, because it ha=
ppens
> >> only in sk->sk_destruct, when the sock is going away.
> >>=20
> >> v2:
> >> - update Fixes to point to origin of the bug
> >> - use real names in Reported/Tested-by tags
> >>=20
> >> Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
> >
> > This still seems wrong to me.
> >
> > In 3557baabf280 pppol2tp_connect checks/sets sk_user_data with
> > lock_sock held.
>=20
> I think you are referring to the PPP-over-L2TP socket, not the UDP
> socket. In pppol2tp_prepare_tunnel_socket() @ 3557baabf280 we're not
> holding the sock lock over the UDP socket, AFAICT.

Yes, you're quite right -- my apologies.

> >
> >> Reported-by: Haowei Yan <g1042620637@gmail.com>
> >> Tested-by: Haowei Yan <g1042620637@gmail.com>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >> Cc: Tom Parkin <tparkin@katalix.com>
> >>=20
> >>  net/l2tp/l2tp_core.c | 17 +++++++++++------
> >>  1 file changed, 11 insertions(+), 6 deletions(-)
> >>=20
> >> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> >> index 7499c51b1850..9f5f86bfc395 100644
> >> --- a/net/l2tp/l2tp_core.c
> >> +++ b/net/l2tp/l2tp_core.c
> >> @@ -1469,16 +1469,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *t=
unnel, struct net *net,
> >>  		sock =3D sockfd_lookup(tunnel->fd, &ret);
> >>  		if (!sock)
> >>  			goto err;
> >> -
> >> -		ret =3D l2tp_validate_socket(sock->sk, net, tunnel->encap);
> >> -		if (ret < 0)
> >> -			goto err_sock;
> >>  	}
> >> =20
> >> +	sk =3D sock->sk;
> >> +	lock_sock(sk);
> >> +
> >> +	ret =3D l2tp_validate_socket(sk, net, tunnel->encap);
> >> +	if (ret < 0)
> >> +		goto err_sock;
> >> +
> >>  	tunnel->l2tp_net =3D net;
> >>  	pn =3D l2tp_pernet(net);
> >> =20
> >> -	sk =3D sock->sk;
> >>  	sock_hold(sk);
> >>  	tunnel->sock =3D sk;
> >> =20
> >> @@ -1504,7 +1506,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tun=
nel, struct net *net,
> >> =20
> >>  		setup_udp_tunnel_sock(net, sock, &udp_cfg);
> >>  	} else {
> >> -		sk->sk_user_data =3D tunnel;
> >> +		rcu_assign_sk_user_data(sk, tunnel);
> >>  	}
> >> =20
> >>  	tunnel->old_sk_destruct =3D sk->sk_destruct;
> >> @@ -1518,6 +1520,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tun=
nel, struct net *net,
> >>  	if (tunnel->fd >=3D 0)
> >>  		sockfd_put(sock);
> >> =20
> >> +	release_sock(sk);
> >>  	return 0;
> >> =20
> >>  err_sock:
> >> @@ -1525,6 +1528,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tun=
nel, struct net *net,
> >>  		sock_release(sock);
> >>  	else
> >>  		sockfd_put(sock);
> >> +
> >> +	release_sock(sk);
> >>  err:
> >>  	return ret;
> >>  }
> >> --=20
> >> 2.35.3
> >>=20
>=20

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmL6TG8ACgkQlIwGZQq6
i9BvIAf/S3FXJ1zl6LDF7V5Bh1CZYULYG0PfiGARsoJ2nImyUFeRXdLe1dk1Lnpr
BFwGvxbKF/Q/4EcULqvN9iWd6rdKKD6Wmu9s/yu0KKxLJbIKoKIc9JLTRsI2jNty
92acy4moH1H/dbcJ94HbCu3W/+CFR9z/4uyDnEe0ELrtyjPrCJt76FxKsgReyDx4
o05n0zgP67e1EJTIVJsrT/c7UXibXkfS4QqQFA8zM9KgU0+QmC18rpgx1XlDZZZD
rcVx/R8ptCd6FaYbsHFpdgWcJmD39Ezr4oEu+i1LQZIaf5UqzUhyJ1XWK6oAKT/U
ZqkprBuKbejv1Zh/O2touxPn9vQrJA==
=q6j/
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
