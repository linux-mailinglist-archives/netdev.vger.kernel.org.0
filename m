Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D3659F04E
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 02:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiHXAmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 20:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiHXAmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 20:42:16 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506687C300
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 17:42:13 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MC6k56sklz4wgr;
        Wed, 24 Aug 2022 10:42:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661301727;
        bh=V5q0ClccD1ln/qwN4+tlEl8YiRuUyp3BpmeGhhzE+Jo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vJqHSQl3EU3DSkf9xspZqEvKOzig1TE1DmJFs4OhRNCe0fhU+j/nsKKIx+NqgP1eS
         DqutwJMjBimQ3bfAwod5+tuavc13S9yLTTmpRULwbh4FraSSjgAmPfG3OTUPiXu4ff
         2FehMJ6wGw31b0xiHaSoM2zuVne76suAKOt2pHli03AbL0M9NQf1sk5qgKegKP3scL
         dSOd9tlWmXu7gFr5VlbDZq/Vxpd3QJaW5+1+aWgJyrse++yA0jY6F+ngkS/0iygABF
         Na9abQir5fZ0csMCb+j0gX4kL8a7bwAPa1keZwtU4q2JhLv+E1wNAnBHrXZTpXVXoP
         UpFGD+Q9Gj/Dw==
Date:   Wed, 24 Aug 2022 10:41:43 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next] docs: fix the table in
 admin-guide/sysctl/net.rst
Message-ID: <20220824104144.466e50b1@canb.auug.org.au>
In-Reply-To: <20220823230906.663137-1-kuba@kernel.org>
References: <20220823230906.663137-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ugQFUvm=Lg/SOQgBbcIMWkz";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ugQFUvm=Lg/SOQgBbcIMWkz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jakub,

On Tue, 23 Aug 2022 16:09:06 -0700 Jakub Kicinski <kuba@kernel.org> wrote:
>
> The table marking length needs to be adjusted after removal
> and reshuffling.
>=20
> Fixes: 1202cdd66531 ("Remove DECnet support from kernel")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  Documentation/admin-guide/sysctl/net.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/adm=
in-guide/sysctl/net.rst
> index 82879a9d5683..65087caf82d4 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -31,9 +31,9 @@ see only some of them, depending on your kernel's confi=
guration.
> =20
>  Table : Subdirectories in /proc/sys/net
> =20
> - =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   Directory Content               Directory  Content
> - =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   802       E802 protocol         mptcp     Multipath TCP
>   appletalk Appletalk protocol    netfilter Network Filter
>   ax25      AX25                  netrom     NET/ROM
> @@ -42,7 +42,7 @@ Table : Subdirectories in /proc/sys/net
>   ethernet  Ethernet protocol     unix      Unix domain sockets
>   ipv4      IP version 4          x25       X.25 protocol
>   ipv6      IP version 6
> - =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  1. /proc/sys/net/core - Network core options
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --=20
> 2.37.2
>=20

How about this instead so that everything lines up nicely:

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin=
-guide/sysctl/net.rst
index 82879a9d5683..871031462e83 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -31,18 +31,18 @@ see only some of them, depending on your kernel's confi=
guration.
=20
 Table : Subdirectories in /proc/sys/net
=20
- =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
- Directory Content               Directory  Content
- =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ Directory Content               Directory Content
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
  802       E802 protocol         mptcp     Multipath TCP
  appletalk Appletalk protocol    netfilter Network Filter
- ax25      AX25                  netrom     NET/ROM
+ ax25      AX25                  netrom    NET/ROM
  bridge    Bridging              rose      X.25 PLP layer
  core      General parameter     tipc      TIPC
  ethernet  Ethernet protocol     unix      Unix domain sockets
  ipv4      IP version 4          x25       X.25 protocol
  ipv6      IP version 6
- =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 1. /proc/sys/net/core - Network core options
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--=20
Cheers,
Stephen Rothwell

--Sig_/ugQFUvm=Lg/SOQgBbcIMWkz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMFc8gACgkQAVBC80lX
0Gx2EggAi+PCueVZLXYCCSIh6lkkODPIbaAgnvKJhTgqR4cKSG1sNqM0ks+esmDg
6t8AK1rCSnA50wjKexy6YFJsG0QhM6eXILss9TI7wgo3+g0VIbMbuNsPVVR5/LaH
jEztYcKxD+8M64dRc3GZlkmja3J9/+lU+Wy2jIcbZnrOdUp2fK4IVrGc7waJkC2J
hd2VQLt/9bEnAMZXlBUOxSzXKti5qvJ50oEBa4flskVlaw6v/OpaGiSWkYjCKtYr
yjwb48/dQ67wPb8YsTpdQli/v0syIo7Bpe4vQZ6XmQA2J/Hk1so1eHmLhOHdZkV0
ReoE6iHa9JQ9XuIgTwjf4dh9189Ftg==
=SfeZ
-----END PGP SIGNATURE-----

--Sig_/ugQFUvm=Lg/SOQgBbcIMWkz--
