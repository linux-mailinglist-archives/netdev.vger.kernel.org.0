Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31608453EAC
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 03:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhKQC6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 21:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbhKQC6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 21:58:11 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345C0C061570;
        Tue, 16 Nov 2021 18:55:13 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hv6wv1dPjz4xbs;
        Wed, 17 Nov 2021 13:55:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1637117711;
        bh=TzU+rEIilQxfE0ib2UBdfLOsw7hzflwhrLFyamc18UM=;
        h=Date:From:To:Cc:Subject:From;
        b=la3zqOpOzGpLNVZZZSnzCA6ELBsOSUtj6XAeyULmpqSUk7Pyto0cDkSJjnNZ9QSpG
         6FLEswedSA4AWtNCaJ0Qkj19asd0Ax/5PIbK+yKiZ6+zMYXKukCb6rhMnOiKTfztgP
         OPMgz1HUvDSjYArRdw5UI1BNyNHS/2eozLDvbLw5WpcBL/mzeChKx1WnBl2f8rjwsf
         8UtuZtuLk/o78JWuuV399/nt84JYPUXZrjDZGRbnXI6kWKM/zV3yRIXIyj1z+LRUSc
         m85ABQF3PyDdbV5oXp4PS0NrUu3aUVLy92GTZzm/NL0hgERfwp/gGqCqWThfS6MApY
         tkKNGBe1sze9Q==
Date:   Wed, 17 Nov 2021 13:55:10 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20211117135510.0307294e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ib6d_mEyoUiI0.kLEYtd6H5";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ib6d_mEyoUiI0.kLEYtd6H5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

include/net/sock.h:540: warning: Function parameter or member 'defer_list' =
not described in 'sock'

Introduced by commit

  f35f821935d8 ("tcp: defer skb freeing after socket lock is released")

--=20
Cheers,
Stephen Rothwell

--Sig_/ib6d_mEyoUiI0.kLEYtd6H5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGUbw4ACgkQAVBC80lX
0GwObQf/bwjjIlCti1MAz3XHJg3iwllSLplSoHHsoW9OnBKSOKDWiEF6mE8keR2u
TWNpViSeabVLPRMHHiZZ06HPDVJEDOO9SC0YvgWAEbpiTl+hkzF4VlmfD/Sg7I0g
gQlGfZ4znU86GHVpcWVPj1JRhhQI/BWHAGdnwxvrSkbeXKCBmchDe5KBf6BCAOP6
5OcyLwvnSKGoEt2XklTf4Ue6ppVw9TV5KOlQwYcj53srXs+clSXJgj+/Jb9gQ53y
u/qH5IPEPxZjRKtDrsJRF1mWOwEnGTtjOwx1bvFlEbd38qncMO6mQZVsT5i9Kqh4
eBNwuecVMS7kPD0yV80pISB/6+vDZQ==
=6eEE
-----END PGP SIGNATURE-----

--Sig_/ib6d_mEyoUiI0.kLEYtd6H5--
