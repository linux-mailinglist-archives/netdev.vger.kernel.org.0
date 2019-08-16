Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C5F90364
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfHPNqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:46:20 -0400
Received: from ozlabs.org ([203.11.71.1]:58975 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbfHPNqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 09:46:20 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4694NS2SWHz9sDB;
        Fri, 16 Aug 2019 23:46:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565963176;
        bh=VOTQaZYz1xio2T92p1aCB1LyoPwoMTtpquFEUZuR86c=;
        h=Date:From:To:Cc:Subject:From;
        b=kk2Mg7V425fVXQ+bHeJh3wx8+Bzbi4ROzZwG3I+hhLrrui4CcjvINyXRfM3TZ67jo
         RsIqKNJkzRmfusYnoTY3X28jOxygAtCqKrzT2a7JncLk6bgp7GpWKgcQot9Z6bbuvb
         JgXRriDnR5WjLNZ3vx1SYwtipXv92gJoM4c5d7hD6y4FB/QmxVxlujQoakpTyvXFk+
         XjQjneJPT1MsF+rU/8xLoVKn9MzF+Iy7O42ztxIUxJhASE840s59LIpWnCcm4NQZ2g
         Lr0cr1AGu7YUHwDjODl2XkcT9/NlvQXUSOH8kGxz008hlN5z5MvyZIL2QNO+pPRxCf
         dsphGxr4o05zA==
Date:   Fri, 16 Aug 2019 23:46:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: linux-next: Fixes tag needs some work in the bpf-next tree
Message-ID: <20190816234613.351ddf07@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aJmX.em67UJDsAhx.uHHPI+";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/aJmX.em67UJDsAhx.uHHPI+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  ed4a3983cd3e ("tools: bpftool: fix argument for p_err() in BTF do_dump()")

Fixes tag

  Fixes: c93cc69004dt ("bpftool: add ability to dump BTF types")

has these problem(s):

  - missing space between the SHA1 and the subject

This is dues to the trailing 't' on the SHA1 :-(

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/aJmX.em67UJDsAhx.uHHPI+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1Ws6UACgkQAVBC80lX
0Gye1Af+PunMrf+NtAIZGFRzAYEFfh7xXEdAcH0BtuOFp0hR2or2CVkXvqp9pXT4
FkzMTCzVrZVIdP0+UQQ1KCWSI4rRe9dFVP+clNqwvQumgocxvba9g8nAH/Qvz9SX
PXZpFj+JYVnx0Gn0NHY8Usl3AttDzCOm/3cfLn+4xa22hkc6AUSrvGfqtR6Ug/vM
6c+1y66R70UwJNuc5LUJ7glO0+Hs7AUmK2ECKsaYKQFTJuelf9xMHDyAfTdzgO8n
/YMWwdv0Sb6BoSBRw4+TltAKVYBeGjZ397j1EOk/mJOkyOTHKvJMR375yykE+VKk
GAogs4Hx/xD+OScr5zxJyX4vKUF0vg==
=wMsH
-----END PGP SIGNATURE-----

--Sig_/aJmX.em67UJDsAhx.uHHPI+--
