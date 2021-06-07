Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2115239E9D0
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 00:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhFGWzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 18:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhFGWzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 18:55:23 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D061C061574;
        Mon,  7 Jun 2021 15:53:31 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FzTDl60tJz9sW8;
        Tue,  8 Jun 2021 08:53:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1623106408;
        bh=OpKpwZ8m68IeGoA+ShA7bTpga7yosVCFfxKrGmhuWnY=;
        h=Date:From:To:Cc:Subject:From;
        b=ReMDG+q8g/WZuaFPnPKg9B5X6BYYlmeroVqOCENkXfVzjI/nLQKhGctpwxjf0MRP1
         fh2ZQKT2RtF39ZKyYvbX2Arfn/CvlLiJzMErRw0cS/5rRLFZ8+L5gMhcrD3At41pp5
         u1D2q/KL3Sd61ku2w+un+m3wsq1Jxxo/ayGkmb/hOfn+y82q/6y/EGRdM8zj9wr3Aq
         5VPcV5invYB0kMMgdPm5yiB69m6QaUrSB3ZyCf1G9rZa9eQu9V5OcHEY9jVjnVoWvX
         SEi9JDek4TAy1HvbBdN+tjGeFDuZcgne77NpqQTC+v711b9P4w+RyEkKaSbMB2G0iV
         zZYKAzob2VnUQ==
Date:   Tue, 8 Jun 2021 08:53:25 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210608085325.61c6056f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ytUmy.xn6sDieHYVNp2.8vF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ytUmy.xn6sDieHYVNp2.8vF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  d566ed04e42b ("mlxsw: spectrum_qdisc: Pass handle, not band number to fin=
d_class()")

Fixes tag

  Fixes: 28052e618b04 ("mlxsw: spectrum_qdisc: Track children per qdisc")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 51d52ed95550 ("mlxsw: spectrum_qdisc: Track children per qdisc")

--=20
Cheers,
Stephen Rothwell

--Sig_/ytUmy.xn6sDieHYVNp2.8vF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmC+o2UACgkQAVBC80lX
0Gzmjwf/X2kNT/Ou4TkpBptu7jSl/kygnbuiTON2BD/rgyDf/tcfJbssKQdv9U4T
Ls6zyKvhuXlJGPt6fkWnejzC56sTk+88vil8Bmrw8kDoNup9m6yIQSAdv/qz441Q
lXkK16dO5qyN/hF7BlXFONJwk77rMB8UV+9VrjbhAGlflvgR7QTSoRe6hH7Awqu+
UkEHnCzscmzSLKuhpxlWvTIigWjCJ8cgm93550ew1JNmV250+i0WTVGRPiRkgeY4
A3OEpfmKZ6myt7X1vVrragmuxla3W31+uIYPwSqvpk61rC6AAMYu7PAXDYIgASJY
xr3viCXlTrUUfqrHGdj2veUmXxzzJA==
=fPVL
-----END PGP SIGNATURE-----

--Sig_/ytUmy.xn6sDieHYVNp2.8vF--
