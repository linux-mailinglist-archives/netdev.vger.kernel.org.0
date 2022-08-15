Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D7F592CF6
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiHOItb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 04:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiHOIta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 04:49:30 -0400
X-Greylist: delayed 372 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Aug 2022 01:49:29 PDT
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3284A205DA
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 01:49:28 -0700 (PDT)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 7723E7D5B1;
        Mon, 15 Aug 2022 09:43:14 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1660552994; bh=PsToe7c4M/JitU7m/h6ilpx+7IvtIeZYUv6GiQzjWnY=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Mon,=2015=20Aug=202022=2009:43:14=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Jakub=20Sitnicki=20<jakub@clou
         dflare.com>|Cc:=20Jakub=20Kicinski=20<kuba@kernel.org>,=20netdev@v
         ger.kernel.org,=0D=0A=09kernel-team@cloudflare.com,=20van=20fantas
         y=20<g1042620637@gmail.com>|Subject:=20Re:=20[PATCH=20net]=20l2tp:
         =20Serialize=20access=20to=20sk_user_data=20with=20sock=20lock|Mes
         sage-ID:=20<20220815084313.GA5059@katalix.com>|References:=20<2022
         0810102848.282778-1-jakub@cloudflare.com>=0D=0A=20<20220811102310.
         3577136d@kernel.org>=0D=0A=20<87edxlu6kd.fsf@cloudflare.com>|MIME-
         Version:=201.0|Content-Disposition:=20inline|In-Reply-To:=20<87edx
         lu6kd.fsf@cloudflare.com>;
        b=B8BpVfz/471juGneq/ErCVaDPaJpygm7JoF2+hs+mMduUjdG5kOzy5BrkUkmTvkoy
         S9es1K95zTNX11fSOZdEtKscw5BqAsNJMioTQdx36HHIaTuqKXpfVST14hMK2BWbqY
         No6TYkD6hvb2czol/K2RYcMxDBmEI4Z6VsR9D2vkMMwhc9/3jrTyZJigSIZxZ+AVL6
         Q532dCAR/PdhMQ1Sp7XstPCHEXRE3P7SW7OZgSpNa4zWlnoooBsPmL7j9bcECZTeYd
         7eZoYXDQNzBqZaWDh92RJ++GLeeQcmcWEEGe/SVvsfWJ3izFTEoEgWuochpn8IQcm9
         RMC/kZikzyJAQ==
Date:   Mon, 15 Aug 2022 09:43:14 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, van fantasy <g1042620637@gmail.com>
Subject: Re: [PATCH net] l2tp: Serialize access to sk_user_data with sock lock
Message-ID: <20220815084313.GA5059@katalix.com>
References: <20220810102848.282778-1-jakub@cloudflare.com>
 <20220811102310.3577136d@kernel.org>
 <87edxlu6kd.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <87edxlu6kd.fsf@cloudflare.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Fri, Aug 12, 2022 at 11:54:43 +0200, Jakub Sitnicki wrote:
> On Thu, Aug 11, 2022 at 10:23 AM -07, Jakub Kicinski wrote:
> > On Wed, 10 Aug 2022 12:28:48 +0200 Jakub Sitnicki wrote:
> >> Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp an=
d ppp parts")
> >
> > That tag immediately sets off red flags. Please find the commit where
> > to code originates, not where it was last moved.
>=20
> The code move happened in v2.6.35. There's no point in digging further, I=
MHO.

At the time of fd558d186df2, sk_user_data was checked/set by the newly
added function l2tp_tunnel_create.  The only callpath for
l2tp_tunnel_create was via.  pppol2tp_connect which called
l2tp_tunnel_create with lock_sock held (and indeed still does).

I think the addition of the netlink API (which added a new callpath
for l2tp_tunnel_create via. l2tp_nl_cmd_tunnel_create which was *not*
lock_sock-protected) is perhaps the right commit to point to?

309795f4bec2 ("l2tp: Add netlink control API for L2TP")

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmL6Bx0ACgkQlIwGZQq6
i9B5nAgAj6fL3gToqPZmWQZ6iYA9i0EBjeh6xGBrVWSJdrN1fA+JyfgAnIYsmGPh
BxgY+IW/5Gj5nuWtYbKCMpnN6dh0LjgPVUJFKcBNCXuSW70smU5VTUPo4jM4eh/x
GhuruZ2MwVhF8HZK6uqRWrRYa/kQAPXrXX8M8AovA1QpI/SqxR3pO0+LyO5RJPS9
9c+9y9OW7OyHWcBSgJcK/GvEzXIuSGbWO3O7+1xXUGYikl+R+Kk5tZLpqFbBBpSq
BcW8YzMVP+lwnk8ATnBEhqzP4dlw810FitwklHE+dx043pWwCkSmPgyDUtNVD45r
Fv88ZGQS1uCNAzwseaZ4Sh2GXr5EOw==
=KqX/
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
