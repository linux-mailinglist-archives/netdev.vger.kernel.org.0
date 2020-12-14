Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185C82DA0FE
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502878AbgLNUCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730043AbgLNUCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 15:02:09 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E13C0613D3;
        Mon, 14 Dec 2020 12:01:28 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Cvsj25Qqlz9sSC;
        Tue, 15 Dec 2020 07:01:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607976087;
        bh=R+AMyV+pIO+eK0hlpWR2H9CRJLFlIORsRKod1hXihOg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fyZzJPKchaMI8mhCbKoJA/2+tBPC0JdG45PF/k2pmw7PqvUjWMH8kWgW4Q1HvSDig
         mn+GoiI3WgoHuo88uooBJ0H9IS27kEkBe7M27s+muGqbsi894R/aZmfKoOQKHTgV0D
         eXWFbhhIqCPNQTSF2NBkIyDIhMkoB87PZGXSZO6Sv95Rb2+z6zhKdZ5gfePyGzMfhx
         Enp12rRTTkY4EM1DBOw+HNZi0GxxR6zTEAkdZNq5d5BTj0WM53mEETVQ/bBPyJFZmD
         zCQ57vfB/0nIfLVKTVxFZ+6u53h/tDfobOQIC6Uih+eyLyVQay56j+3pMUUWUqCh05
         j2fnEt0DvqSQw==
Date:   Tue, 15 Dec 2020 07:01:25 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20201215070125.5f982171@canb.auug.org.au>
In-Reply-To: <20201126174057.0ac8d95b@canb.auug.org.au>
References: <20201126174057.0ac8d95b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fJ6B7LOXkNBGaGq48GNdM1e";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fJ6B7LOXkNBGaGq48GNdM1e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 26 Nov 2020 17:40:57 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the net-next tree, today's linux-next build (htmldocs)
> produced this warning:
>=20
> include/linux/phy.h:869: warning: Function parameter or member 'config_in=
tr' not described in 'phy_driver'
>=20
> Introduced by commit
>=20
>   6527b938426f ("net: phy: remove the .did_interrupt() and .ack_interrupt=
() callback")

I am still getting this warning.
--=20
Cheers,
Stephen Rothwell

--Sig_/fJ6B7LOXkNBGaGq48GNdM1e
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/XxJUACgkQAVBC80lX
0Gzk7wgAiHgSjUBXo0kPZfk2UzubysCjOWoT08ez5b2NjHPZiQBdzPy8wCMPU5EU
GdGNxOmWVyAjOBbuHm1S3H8rvU08reyb9LB8TbcjsiF0g9oYlBZaT1JAkdiPFAuP
OXIBxuSB5QLwLUyAVdM3AcWU/2fET6eGoscxZVGB4+h05Ji9v1uJxDt7kiGONbhB
9wfaqdN4zDUcLwCy//0UZylgGekPSkI94YzCjtfrAtmDS7a9EKWPPkamp81riUcP
hARGyqw0Rwp0R0YY2r7p+l/76kuksmg/yVmaal+Ayb0f2gMUwHmUTmjUB+Hn1dus
7rIuSKnV/e58i94NaojEVa31LRnZYA==
=3YHC
-----END PGP SIGNATURE-----

--Sig_/fJ6B7LOXkNBGaGq48GNdM1e--
