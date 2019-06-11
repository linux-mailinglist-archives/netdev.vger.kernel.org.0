Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBD8A3C80E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 12:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404575AbfFKKGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 06:06:01 -0400
Received: from ozlabs.org ([203.11.71.1]:57065 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728937AbfFKKGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 06:06:01 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45NQcj5fd0z9sDX;
        Tue, 11 Jun 2019 20:05:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1560247558;
        bh=7U/XVQfmfn8ksgJsWS+ntJglSV9GfB0NOkUJ1PR2ASU=;
        h=Date:From:To:Cc:Subject:From;
        b=TYyrZ/RnmVdu8hnXhHmtS6Yw2EJ8C2Gsoiwha8KT+17ar9qtTPkN83ccTxdsTBDwo
         EtRD00u1vRBtP+bkHD3EgbFx5XCbs+7Pvm7IQqzd+OP3XXKpli1MrkppVqhqepXaEZ
         iLCkQ4rnaUG9y0w/26CrFiWedDmazHtMVlvy5cKOrbkbfWBII7uisz5I/eb7d3uXLx
         tGnpB9zF5eI7+HxX1AW1sjIQRGTrIRWH0dQFP5GU+lrPQ3wDhE5eXt01U5OA3T3M85
         z/LkQ6oDWnV4Y5MrrPaMpgaarb+XmDnbZSdjWTvYOuEPuVv85R5+qHLIpM4AombThv
         JdWSjm8XmUf0g==
Date:   Tue, 11 Jun 2019 20:05:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: linux-next: Fixes tag needs some work in the bpf tree
Message-ID: <20190611200556.4a09514d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7xsX+2aY0ikNJvTtDD9/vld"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/7xsX+2aY0ikNJvTtDD9/vld
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  605465dd0c27 ("bpf: lpm_trie: check left child of last leftmost node for =
NULL")

Fixes tag

  Fixes: b471f2f1de8 ("bpf: implement MAP_GET_NEXT_KEY command for LPM_TRIE=
")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/7xsX+2aY0ikNJvTtDD9/vld
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlz/fQQACgkQAVBC80lX
0Gw7Wgf+NtaIzPwZpz/rKY47PD9aCIfaKCLRcxWh1n6vDHtaVi9uVFDOI3GTkO0z
vffYFAo5iVot9EEt0kA4sgPs2s6dMXzD2BHpTuxeHb5hpX8twkOoFqTOSfjoINvz
fCRzX6EgJ2z3ympwYDvDZ+PdEj5sAYOg7xF2su4qCAbTM9CBmTgMLIrlnvaURPUF
ayTypYQ3OMzm4A4oop9McAnn+ku7/xIUfyLrMfOgY+sXZGCE/hQrEZvjAvVYX/1E
hluUVGmdHmba/fCzsPIUorFrGVCEbI8nKOpo3axeBdhnaWTlDTncYmnu7TqOPq6e
D/guwtPY9vuzOfIFuJsxEofV1N36Ng==
=oDUu
-----END PGP SIGNATURE-----

--Sig_/7xsX+2aY0ikNJvTtDD9/vld--
