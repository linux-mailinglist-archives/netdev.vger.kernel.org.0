Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB7DAED39
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 16:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388101AbfIJOhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 10:37:40 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58833 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387676AbfIJOhj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 10:37:39 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46SSKw4gk0z9s4Y;
        Wed, 11 Sep 2019 00:37:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1568126256;
        bh=4z1XeOUTPzpueRuks3y9AT8sA53R1X8yxALmPSFyLfk=;
        h=Date:From:To:Cc:Subject:From;
        b=btUcsowtL4lESBd70quiC+OgRZhZajfwjetohFph8KfhWzB3JVKAzrOyNGVGDRPB6
         cZkVavBqR6o5S+1SqugF2VHXEyxtNnCwlsJw0lp3sl8cpN+o6PWW/tUe7g9oyC7Z52
         1BGGNsay7vs9V/NScef6KqOr1igjLT0U3Tk44WbCZ9zmlBMoP/eyoyQ/B6CkP5EF7Y
         TpS83s9szMwsMCjDO2yzHzjSV0CzREkeymYhh3qmuCzu55dU4yj5DWg3WdSRPZ7FE7
         WxNce16q9OHLd+8heBq3KcPrY2Gev5lfOw5v4ZFFVHaxRQAtkbZnzP9qiQ0U0c0exh
         gPsgHlCDxsatA==
Date:   Wed, 11 Sep 2019 00:37:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20190911003713.1e7579f0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WIOCxjaEg2HC.1+3FoJPwMR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/WIOCxjaEg2HC.1+3FoJPwMR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  ed4a3983cd3e ("tools: bpftool: fix argument for p_err() in BTF do_dump()")

Fixes tag

  Fixes: c93cc69004dt ("bpftool: add ability to dump BTF types")

has these problem(s):

  - missing space between the SHA1 and the subject

Presumably:

Fixes: c93cc69004df ("bpftool: add ability to dump BTF types")

--=20
Cheers,
Stephen Rothwell

--Sig_/WIOCxjaEg2HC.1+3FoJPwMR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl13tRkACgkQAVBC80lX
0GzmIgf/d0fr3KZyh4rd0Zh18hxgWl2xksEnj3LhDI+CEDzizWxE5DaV9VYByLIH
5Xh/hKCkC7e9kdxrKVMv9ZSmk5eOioALtUy3mW+Txnc6RZRSsWs1A+Tr3pa6oaF3
S+cMRA7cV/5hQxiZvXrAf76LZoYes+/7CMhqN2NAKTIFNf6mTNWwdu5MBFrCPpRC
8q7CgV4dlvcri61IcijgvS5/igQ0VZ2ct12Biu1fTIsN3v9d+otmUDxdVDdoq/PM
Cttjlp5OQ/OmIZPNSyPMkeXjJ/w2O5dMU0cF/g1CaGEZsCrgzpqjddfJ7b6FPdFW
R34DdPhK2oi6zD0M5GsvdSRHcRCjXg==
=CfTU
-----END PGP SIGNATURE-----

--Sig_/WIOCxjaEg2HC.1+3FoJPwMR--
