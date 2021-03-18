Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7871733FF77
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 07:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCRGXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 02:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhCRGXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 02:23:00 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F06C06174A;
        Wed, 17 Mar 2021 23:22:59 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F1H5F3S88z9sR4;
        Thu, 18 Mar 2021 17:22:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616048577;
        bh=GG/gxLOCiT6GBN9+4s1YLrIyUbK9LIJFmPvSY+3N8aY=;
        h=Date:From:To:Cc:Subject:From;
        b=YR38YE73aTlYa26Xv115wh9K/CChXaDnA9I7tpkXzNugb8L1Yc662LaNNbXf4Dz3F
         sAvVuV6Dw7R55uM5fuGzabxzW+gSbsDDBSVJOcAGHeDQ3K4dxttqIz1WtP7q1plkIU
         XJe/YvPOvWqLzFNQBWI0CpPlF/6ZnFejFSdCzHet+1IhgPrvU19qqwb9iAIP9m4e0S
         rDvOGRKy83QVp1bRvb/kfDNq388pSZdPecmuK2BOQV0ydu55YCXjLO7pQJiQMunxBC
         yAj/eM4ldjeikdWdQmBcmrPysCA7qQMsp06Ux9cExmK8fN6yDGfl3HWodaVDpMKk7H
         F3pA9TMMZxXfQ==
Date:   Thu, 18 Mar 2021 17:22:55 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jon Maloy <jmaloy@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warnings after merge of the net-next tree
Message-ID: <20210318172255.63185609@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/e7YX4A/o=JbM39nUL18RTku";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/e7YX4A/o=JbM39nUL18RTku
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced these warnings:

Documentation/networking/tipc:66: /home/sfr/next/next/net/tipc/name_table.c=
:558: WARNING: Unexpected indentation.
Documentation/networking/tipc:66: /home/sfr/next/next/net/tipc/name_table.c=
:559: WARNING: Block quote ends without a blank line; unexpected unindent.

Introduced by commit

  908148bc5046 ("tipc: refactor tipc_sendmsg() and tipc_lookup_anycast()")

--=20
Cheers,
Stephen Rothwell

--Sig_/e7YX4A/o=JbM39nUL18RTku
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBS8b8ACgkQAVBC80lX
0GxSjAf/fH0wQPhqumnz2rHyn/MdtcS1UDPrLRM2D+t1buzxopZR6zKxeAViNr/C
v6QlNMeuI5tRiP3ZItz2LCkTrZIzFL1v2gs1FE1kjrSuEX8lSEkJ8BnJMMiivkwG
KDqMAVMpdyeiPCzmF7IWNheVTaL/LD25Q35q/5LN35RZLa8Bt5CgQqbKM8iJpBIK
Jy1EwNBdxJmJInwTVba9jfjssxL+/yAXa/jtom95hW0TE6vNzzK71w19aXlkBHCn
Nj8ym3pjSu5d7cvE7S+vhNvpp1g5eT1gYyaoNVL+YY+umEIUnrodi5BGhIpaLpLE
x5dRNpqfBT0h+RzOu5Mc5OI+HYugqw==
=FFL4
-----END PGP SIGNATURE-----

--Sig_/e7YX4A/o=JbM39nUL18RTku--
