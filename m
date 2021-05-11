Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE0437B2CE
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhEKXz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:55:29 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:53671 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEKXz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 19:55:28 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FfvsR58ZBz9sWC;
        Wed, 12 May 2021 09:54:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1620777260;
        bh=SGsGx7JGciiu+5QnXSBQ8t2IqebMwAWOqLoy+nBZKwY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g6malUTRz5JkiZZmUGwDabJ5+66dfP7iCDxvabbRZx4fNQkJCrpq8OEsTMaUi9uAW
         nc4JQmQ2rMdBfKgegoKNHpJjUPfH8gMld804eKg9AHbYUBhgTNmDcvK8IPVhHxK2BF
         BRD1m2JRq9YNKCd3Sa1a8PUN3/idYpiNOupIhQeIN9ijRYbuIugE74gt0a4mOx+w77
         wqTRL3oWFj0orJLMR1GiWOlUHUcRk/W8MGDzddChZA07kj/inTlIN78/G6sX4p8V4V
         WpnPtNRorbwJXtSMICa4QmkoiFHUscg4INFEtzqQkf5b0V44LAsjiS8YF/HESDCK43
         4+yVArbVcfhkQ==
Date:   Wed, 12 May 2021 09:54:18 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210512095418.0ad4ea4a@canb.auug.org.au>
In-Reply-To: <20210512095201.09323cda@canb.auug.org.au>
References: <20210512095201.09323cda@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lTN1OeNplbEpaffUwB8n4zp";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/lTN1OeNplbEpaffUwB8n4zp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Wed, 12 May 2021 09:52:01 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/usb/class/cdc-wdm.c: In function 'wdm_wwan_port_stop':
> drivers/usb/class/cdc-wdm.c:858:2: error: implicit declaration of functio=
n 'kill_urbs' [-Werror=3Dimplicit-function-declaration]
>   858 |  kill_urbs(desc);
>       |  ^~~~~~~~~
>=20
> Caused by commit
>=20
>   cac6fb015f71 ("usb: class: cdc-wdm: WWAN framework integration")
>=20
> kill_urbs() was removed by commit
>=20
>   18abf8743674 ("cdc-wdm: untangle a circular dependency between callback=
 and softint")
>=20
> Which is included in v5.13-rc1.

Sorry, that commit is only in linux-next (from the usb.current tree).
I will do a merge fix up tomorrow - unless someone provides one.

> I have used the net-next tree from next-20210511 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/lTN1OeNplbEpaffUwB8n4zp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCbGSoACgkQAVBC80lX
0GwShAf+KABuJ1/az7j2XG+7CduJuuTtMGbqYYkd+Dgnw1wEwH9+KQ2IXsOQ+DMX
HZokY/wD0RzHic2Fr7geOQJpgLDYslfL2GrR98fUQBVnyAU1NpK4V5MkPZ25bCT5
8JaZ+OvIs3fsbm0blptEX6HR82V2HdKXH6hOMt4VJgRqdeWdEdVP5Xyz1p2YR0YS
K8HgkZvfS7n0gDjJOqaHJ0nx7yZ9bCeuJoLOPq2sBQ9CCHP6xFBGynrDTJvtqQdi
jpUVF5FJC5+1LGgmbxF2z5oF7ZTIU0EXnttHJFFp/Q56M0bjINZraW8hOTClUCCT
ODAsEPZuh7VyJ5Ol0SB/mW0PT3X1Sw==
=IT5I
-----END PGP SIGNATURE-----

--Sig_/lTN1OeNplbEpaffUwB8n4zp--
