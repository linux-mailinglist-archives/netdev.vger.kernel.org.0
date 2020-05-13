Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724781D11D3
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 13:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731558AbgEMLxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 07:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731493AbgEMLxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 07:53:01 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EAFC061A0C;
        Wed, 13 May 2020 04:53:01 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49MY2W4jQlz9sRK;
        Wed, 13 May 2020 21:52:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1589370776;
        bh=l+pd+mpalwVpPCiH+93FYHS/ISb+yEppBpyKCFyPq2s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WuI4fRF4JT2OuppMIkjyvoT/dpbfs+pMgfN/DBejenZuKFPxvOkg5582Pe7ekqpTe
         WGeOM9iKgEoq1PiLYcvpwmQ78lUXPn4iZ7TmfebFAidmTiH8SFzqdD5ZUgZZLOntKs
         V76qW0NsuW1VNRZudddZ2LykQYsp9sA8B4QnEvBnobUMVSFr0J5bEfutwrvWI/0SSy
         I/WCJTex/fDHm6K/6aS7uEPMspPLFRfe0OeI17+i+msnOiva+pNLaNSpAp79sQOAHC
         AfIuTEIEE3Qk57+3CrXoLB1jgGXaidoYqb4g+eIrZmg3Ez0nq+j+7tBH5Sj02XBKFV
         7tFJUA90iY9ig==
Date:   Wed, 13 May 2020 21:52:50 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     madhuparnabhowmik10@gmail.com
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, frextrite@gmail.com,
        joel@joelfernandes.org, paulmck@kernel.org, cai@lca.pw
Subject: Re: [PATCH] Fix suspicious RCU usage warning
Message-ID: <20200513215250.43486e02@canb.auug.org.au>
In-Reply-To: <20200513061610.22313-1-madhuparnabhowmik10@gmail.com>
References: <20200513061610.22313-1-madhuparnabhowmik10@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+ZZmrAi6vQ8lHEwg9rTck/B";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/+ZZmrAi6vQ8lHEwg9rTck/B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 13 May 2020 11:46:10 +0530 madhuparnabhowmik10@gmail.com wrote:
>
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>=20
> This patch fixes the following warning:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> 5.7.0-rc4-next-20200507-syzkaller #0 Not tainted
> -----------------------------
> net/ipv6/ip6mr.c:124 RCU-list traversed in non-reader section!!
>=20
> ipmr_new_table() returns an existing table, but there is no table at
> init. Therefore the condition: either holding rtnl or the list is empty
> is used.
>=20
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Thanks.  Added to my fixes tree from tomorrow (until it turns up
elsewhere).

--=20
Cheers,
Stephen Rothwell

--Sig_/+ZZmrAi6vQ8lHEwg9rTck/B
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6735IACgkQAVBC80lX
0GxXzwf9GtcbY3iOGDoZjrQ1h3WOwWBgxDlxjXrp4sQMQjmZ09AgypNRBCLS2pQ3
/aoFl7wz8hbgQ1RX/PvLddq4c1dIFnkj+WJFauEdqoJJHM6GXRngBjS0nENVVyL0
yJc+bTqAfrG5C+UaxIOHbndNA88svGtDSOqN2zAPEPm/Wz0YwPY/kVyo3gNa3lrN
7NbrjmjZHkuYEXcZ5FYlvasghIppBlm7LMDRzc9Uq4pev/i7nBA0ZfrmNP4m+Bwm
AdK9nLcoHvE9VJhaBiF2IJcMdf0G7/EQ8puwJg/F4k0cxuXq70ITDYa5JJUlNZh1
+Q3h/+6awqJ7DkMrYKmAis+o0fHEqg==
=0Y4j
-----END PGP SIGNATURE-----

--Sig_/+ZZmrAi6vQ8lHEwg9rTck/B--
