Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 462ECE654D
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 21:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfJ0UNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 16:13:39 -0400
Received: from ozlabs.org ([203.11.71.1]:60489 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbfJ0UNj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 16:13:39 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 471TZ71l8Pz9sPc;
        Mon, 28 Oct 2019 07:13:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1572207217;
        bh=AI3HByymQggsR1X2ApeJiKkRTCdlZN52iCGwQ9q8Fow=;
        h=Date:From:To:Cc:Subject:From;
        b=NWhjfIKskO21x7KAOP1gZPAVkRQO9nl9sn655yQnIkwX2OsGmGz6dSZdsAw436ahY
         sQrjqn9wETEP0eIZTqWTpdd3+/YXHDnEDvwn8Qnrfz+t8w2YItmZmkHhHMyEeMUNOp
         +1Qb5jYNwdZaBOT3q7k+F0WzwYW91nYR77XKoVOgW5pVMNen4bEPwHQ9rASG8UNYRA
         qIvGuTVVj4BHkIoiP+3/WYsF3UgJUkDERBJhS+5XgMB8xtIDsOGExURDDXmrwdDLlB
         hElZjImq9K5Gx7C0nN+vpRfG6Rw+XfLnuOrRqHrlb7bXnTGpprVVj2+XjaB9thXNui
         MhbLewXjmMh/Q==
Date:   Mon, 28 Oct 2019 07:13:19 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        wenxu <wenxu@ucloud.cn>, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20191028071319.1f5b242e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.XC+F5s8EzM7gFjuagM.RYq";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/.XC+F5s8EzM7gFjuagM.RYq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  a69a85da458f ("netfilter: nft_payload: fix missing check for matching len=
gth in offloads")

Fixes tag

  Fixes: 92ad6325cb89 ("netfilter: nf_tables: add hardware offload support")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

Did you mean

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")

--=20
Cheers,
Stephen Rothwell

--Sig_/.XC+F5s8EzM7gFjuagM.RYq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl21+l8ACgkQAVBC80lX
0GxNJwgAlBnGcEKmcB32xJGUBRwucJJYCTsaqayTdaIAkzqaTL+WvRf4cSZJOnaQ
3YL6cZB0yrdxtBU1sJtQTSa/VFzMdP5vrIIn8z3F0FvIrUfgS4OaRTCvq5uK5ajO
AlbbR0KUGJUQDmZMM2FGZOrW4ygSJKb+QV4zlRaYfIWpsFneH7f4Ivh8AP0045il
XogBwp+bxh28fJ4CUlanqMQsxAtsxEB5RGat5bSHOex2iE5HlMGM6tcS+Nz+ir77
p64dAE77MNYqwNRRCCMiHkK80lip0eNCgHC4Y08RN+xPPePOwIwTW3IWvmGDqjQO
fB0mLSLNis6KQiK0b8z/qd7tnWLSbg==
=3ebO
-----END PGP SIGNATURE-----

--Sig_/.XC+F5s8EzM7gFjuagM.RYq--
