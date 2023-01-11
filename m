Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590DE665A17
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 12:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjAKL3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 06:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbjAKL3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 06:29:15 -0500
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89B73642B
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 03:29:13 -0800 (PST)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 26465A7B8D;
        Wed, 11 Jan 2023 11:29:11 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1673436551; bh=7VIN3OFFNZCriJpbEg3+soj/c0yDyL7eDI3QFUqcuHY=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Wed,=2011=20Jan=202023=2011:29:10=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Cong=20Wang=20<xiyou.wangcong@
         gmail.com>|Cc:=20netdev@vger.kernel.org,=20saeed@kernel.org,=20gna
         ult@redhat.com,=0D=0A=09Cong=20Wang=20<cong.wang@bytedance.com>,=0
         D=0A=09Tetsuo=20Handa=20<penguin-kernel@I-love.SAKURA.ne.jp>,=0D=0
         A=09Jakub=20Sitnicki=20<jakub@cloudflare.com>,=0D=0A=09Eric=20Duma
         zet=20<edumazet@google.com>|Subject:=20Re:=20[Patch=20net=20v2=201
         /2]=20l2tp:=20convert=20l2tp_tunnel_list=20to=20idr|Message-ID:=20
         <20230111112910.GA4173@katalix.com>|References:=20<20230110210030.
         593083-1-xiyou.wangcong@gmail.com>=0D=0A=20<20230110210030.593083-
         2-xiyou.wangcong@gmail.com>|MIME-Version:=201.0|Content-Dispositio
         n:=20inline|In-Reply-To:=20<20230110210030.593083-2-xiyou.wangcong
         @gmail.com>;
        b=i7FifEblsGZyK49GDkIqmImQo6gnnPquI+H2R5o4VGUj+/Cbq6/zw1rORSNN4IfDi
         irh+arjQIfouG8nHgslXVbXgQ3Y94v/lu+lpKnsrkVFEu9IV1drl4ZCPEi4v0+MZsV
         De4Vi0Hgkstju7IUG13mBLOV0Ie/NyLlYTx51ovAjnzuKajZcPupZMlMunCZmC6fr6
         7pANUzu+jqQKm+kBns8rF88zR7T2LO0y81+L7JA5ABQLfqXmjhXjKBTjuA6QL0jWtY
         auabTCGKeSigXjEZ8KvW6TDcu6HxcENjsYcxmSUIWoancFz5qu44/XbZMzmF/T7Q5T
         jNBxL+eS+A1Rw==
Date:   Wed, 11 Jan 2023 11:29:10 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, saeed@kernel.org, gnault@redhat.com,
        Cong Wang <cong.wang@bytedance.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net v2 1/2] l2tp: convert l2tp_tunnel_list to idr
Message-ID: <20230111112910.GA4173@katalix.com>
References: <20230110210030.593083-1-xiyou.wangcong@gmail.com>
 <20230110210030.593083-2-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20230110210030.593083-2-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Tue, Jan 10, 2023 at 13:00:29 -0800, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>=20
> l2tp uses l2tp_tunnel_list to track all registered tunnels and
> to allocate tunnel ID's. IDR can do the same job.
>=20
> More importantly, with IDR we can hold the ID before a successful
> registration so that we don't need to worry about late error
> handling, it is not easy to rollback socket changes.
>=20
> This is a preparation for the following fix.
>=20
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Guillaume Nault <gnault@redhat.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/l2tp/l2tp_core.c | 85 ++++++++++++++++++++++----------------------
>  1 file changed, 42 insertions(+), 43 deletions(-)
>=20
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 9a1415fe3fa7..894bc9ff0e71 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
<snip>
> @@ -1455,12 +1456,19 @@ static int l2tp_validate_socket(const struct sock=
 *sk, const struct net *net,
>  int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>  			 struct l2tp_tunnel_cfg *cfg)
>  {
> -	struct l2tp_tunnel *tunnel_walk;
> -	struct l2tp_net *pn;
> +	struct l2tp_net *pn =3D l2tp_pernet(net);
> +	u32 tunnel_id =3D tunnel->tunnel_id;
>  	struct socket *sock;
>  	struct sock *sk;
>  	int ret;
> =20
> +	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
> +	ret =3D idr_alloc_u32(&pn->l2tp_tunnel_idr, NULL, &tunnel_id, tunnel_id,
> +			    GFP_ATOMIC);
> +	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
> +	if (ret)
> +		return ret;
> +

I believe idr_alloc_u32 will return one of ENOSPC or ENOMEM on
failure, whereas previously this ID check explicitly returned EEXIST
when there was an existing tunnel in the list with the specified ID.

The return code is directly reflected back to userspace in the
pppol2tp case at least (via. the connect handler).

I don't know whether the failure return code could be considered part
of the userspace API or not, but should we be trying to return the
same error code for the "that ID is already in use" case?

--=20
Tom Parkin
Katalix Systems Ltd
https://katalix.com
Catalysts for your Embedded Linux software development

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmO+nYIACgkQlIwGZQq6
i9BdtQgAgymapJZBHnLO2jW2U4HOgVTAKAFLWpa1EjYHXaHAUtCEQZAQW4IuNbeH
5805SLXqR1NooaEOGhgAD31uyl8DHLHqF/L+THhFyEhQpE5bY29Obj3Lv2yAoq6V
CzYSMSk/w57oplslxT2LavhkYzETObjwZ0NfTMhQdvS/cUpR94KJH63h2n6JdjV8
EQL5kYCNuxoZk95XPG8MyCpizdjGVI3c5BQNmIipwDvSSR43NNGTCEC9CI68+URz
j8UPluz0K/WSFYhn9Xc/nfK/wBPBp7D0FXhBfwoOQNOsnlReWxt1OP83Ccupo/l+
suBCd9RCQfFZ1yBR1JepfJlyNUd9fg==
=ilt7
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
