Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A7812F397
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 04:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgACDi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 22:38:28 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:35297 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgACDi2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 22:38:28 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47prGR3kgsz9s4Y;
        Fri,  3 Jan 2020 14:38:23 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1578022705;
        bh=r28IWWWPmNsCm4OFWfh0nMhNSVkiMeoBpvxCtcrNNYw=;
        h=Date:From:To:Cc:Subject:From;
        b=gQiIXYF+nZtjskf7N4xQT9/pKJDLt+p38PyIm7yWiYH13mZ66CK6x1TYNJPSorirN
         37wjQtzGtohUJVpfiWzNgmlAj8fgQYXr3CSJh+QGyS3dMhX2ozqoxMa087BX70r6gs
         +kuTC1aojIp7Xmz+BDO445GPtQrPzGOcDBoTbPLiQMvH/shfZz05shWNFR0x4QAjhl
         oeV/GzabPg/szNaciDbLE8ABgnH2VknOQu5X2sXuWWXq9+sSI5fo/PcKQnqB8xCoNM
         Z4UkYNWBFaHf4QMmFU2C+nPhqrxx9lxcXNl7GMBtmxbfE6U1nLkMV/R9iekiWyjQFy
         DOiFi4gHArOZA==
Date:   Fri, 3 Jan 2020 14:38:29 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20200103143829.42b58cca@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8BajyGUBxKqH6VFaj3VpwrN";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/8BajyGUBxKqH6VFaj3VpwrN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  f7a48b68abd9 ("net: dsa: mv88e6xxx: force cmode write on 6141/6341")

Fixes tag

  Fixes: 7a3007d22e8 ("net: dsa: mv88e6xxx: fully support SERDES on Topaz f=
amily")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/8BajyGUBxKqH6VFaj3VpwrN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4OtzUACgkQAVBC80lX
0Gxr7QgAmj6gV+HmeAr3QLLqE6vHGldyozbLzCukPy9M1XM9jeBkl59vVJeg8MhA
1KeMrWMvRYcAUQW4lsQh2HVSlZLgQYpoiFoP+HyOMcqPw9wMQQKbc4hx5quplbZW
Rz/IOchbwGfjX3qMT8cxhgyf08JLnqQyxGP4rhgWy/aMviiABtEjU1WYy7YWmpbG
tqdJC4dKVoPHh3n9vRTtaOdzBEwCinUuYvWHqRCdVJhZoGtDqjSOZCs+3wpFPE6d
oaX7dityN+Dz82+qzWQo2hl7TbtEVf2LBWr4PtuQLQZHkRBNTHwZ8AW2jDDRyBe/
ie9PBFKkM0redafoJse0OD7y+kuadg==
=cB2x
-----END PGP SIGNATURE-----

--Sig_/8BajyGUBxKqH6VFaj3VpwrN--
