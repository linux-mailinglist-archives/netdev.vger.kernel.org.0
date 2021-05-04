Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4246373220
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 23:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhEDV6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 17:58:15 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:33981 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232943AbhEDV6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 17:58:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FZYbc2jZWz9s1l;
        Wed,  5 May 2021 07:57:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1620165437;
        bh=Z52JiiQfTABgnfHHVJHvgoGp+g+Oua5xSDj1AGuuASI=;
        h=Date:From:To:Cc:Subject:From;
        b=lsrbw5qsBdRFOh96zVHYNOlTt69DhNo7+loozTYHpaiQApIWI1dwJfLnQx622GVL+
         lRE3YqoHXnsEXIndmmkhYlLwvgJ81+gQfA5e51QkaBO87ibXSfNb6ssxHmgCKRhPVW
         l+yhU7RqUdCdEeTkF4JhPTV260okaaiOgDN2ulyxOlNqxZ/oFowSWekAic4k/e6CnQ
         FW3W0LV5Z0S1fuCjiTIea9QinML/oowxdpcB5G6Gs/bIk0ftaRxaJZ8CmdDgfJbdkg
         2Qvx9v8ND0xqpGiglds2nNKfzO3dbOhUQBQlIre6dPTmlwdFEjRLW3NE2XQiula4gt
         GDWdHcTgzo/Lg==
Date:   Wed, 5 May 2021 07:57:14 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Or Cohen <orcohen@paloaltonetworks.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210505075714.7cd28130@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/dgkxTrnwME5ETf1ocP/9nZG";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/dgkxTrnwME5ETf1ocP/9nZG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  c61760e6940d ("net/nfc: fix use-after-free llcp_sock_bind/connect")

Fixes tag

  Fixes: c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")

has these problem(s):

  - SHA1 should be at least 12 digits long

This is probably not worth rebasing to fix.  In the future this can be
avoided by setting core.abbrev to 12 (or more) or (for git v2.11 or later)
just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/dgkxTrnwME5ETf1ocP/9nZG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCRwzoACgkQAVBC80lX
0GwTFwf9HWW54cHYx9AJNAJshYVQxYBVTazhC9l93YRvIp0QDmq6m+bS/8ZUBpuo
XBPqkmVVwZixbilvGXs6ZzLiC0TjF1UAoJ618s/7ar1hiTUMgGl6oGi+zI38ecGi
DDkMVm7qJG41J2QyqiZUmcVopeM/HbspGjtVzhbHLnacyazkmwf9mxu62nWSlIe4
8568j5MhF0PGhUpA65dbwdMI6Cz63zyiDqUnL9nXAiF4Xk3Piw49DA82SIqXL1n8
mmtQdeMlTsF3iOsw7M2lLmv4ouLQ5I3QYOqv2+ASou+kAQ3NEh6T04iCfs9GadQG
qJBVG7aiA0RfrlBx/3wJt3ZctionZw==
=m32/
-----END PGP SIGNATURE-----

--Sig_/dgkxTrnwME5ETf1ocP/9nZG--
