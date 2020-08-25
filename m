Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51520251529
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgHYJRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:17:13 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:38085 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbgHYJRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 05:17:12 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BbNfr5s2Nz9sSP;
        Tue, 25 Aug 2020 19:17:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1598347030;
        bh=8+HCk3p1QLwmXwB6X50SNetgu111UDw1AjiCvBM1Qoc=;
        h=Date:From:To:Cc:Subject:From;
        b=VjpbkblajU7mqY192XaSvH07JYOT7dIP0r2K67EFTD1QN5Rjx61EmDnEqE9jiSPXG
         97jJNo9a388hhQQ/84o/6/nHx/VSCMAyjV5E7jSE7KQ+qGNA+qTWjkakLKPbFldMlu
         abxbDo0eM12E8B8p4LT76udOlpl5mZASdfSWjIqEUMB16qQ/ehJHKRf1e3Eax+EdBx
         VIFvm2bNHKGES27gzqd1/PiacoZ1Ih4aM+BJoiTSRvACxLV3j7EVeJu7D/ntZWujpM
         Ma/O25A6iL+3AC5MWjr08nMQUQ4rf3y9jLfYOwJqoIMTY5QopiClq08e/e3WP6Jxrj
         GJKBz+VhCxQkw==
Date:   Tue, 25 Aug 2020 19:17:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20200825191707.3c244b4f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Qee=H7JH_MGf+Bt0fL0_Jdo";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Qee=H7JH_MGf+Bt0fL0_Jdo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  0093870aa891 ("batman-adv: Migrate to linux/prandom.h")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/Qee=H7JH_MGf+Bt0fL0_Jdo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9E1xMACgkQAVBC80lX
0Gwh7ggAnnBLs/I+UEtLEoB8fQg2672yo7GLfnZFpN9+LrY4i5vhF2YTPXAQU1en
A4KVU9QxZbt5k7ZZW2u0Dx1+h8XXTjmn6cQR28i+JXcv7BFwsCGKM3VCVhrQZzJj
OklyzKb0OIrytVvQBnScuOhQAaunFFj9zMH1iTAapfzco9NTVyv+gQG+rrubR2uV
SFZVqY5ShtTqM5MybBvHGImK6cm0XnLFNwrAFwUQeeHysMpkuYq5FQcVotH74Yd5
BOp+ixOvuvWBmQrkuvesAMmonXHADgSgPkWCFXIkwEHriQfH+uWOD9U0jFor+pK/
jIBlD63YZb2Eedqiy2b3+BwgMrvYrA==
=Qoeq
-----END PGP SIGNATURE-----

--Sig_/Qee=H7JH_MGf+Bt0fL0_Jdo--
