Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F609490027
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 03:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbiAQCWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 21:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236803AbiAQCWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 21:22:07 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB7EC061574;
        Sun, 16 Jan 2022 18:22:07 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JcbJY26SKz4xmt;
        Mon, 17 Jan 2022 13:22:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1642386125;
        bh=IhRCgjt4zGUdtKQ7LJ37CbkXvYDvkz0T5n6dvfUtwys=;
        h=Date:From:To:Cc:Subject:From;
        b=DDnP8Y7qpB8G1auAWeU1H7RENcwiISHZdJNh4Q3mg4aIehegnEaRAeHQfgjygLPHR
         A4RLkmUixP9JO2qzXw5o+0GSNOg8UsQQMAZcdT3mqwfn5X11spHrxH3zf7wMLBoIyM
         GzrHInf8bQtIXjVdetdwjt34/sUl0SRL3e85aHy6K6VGHjD2rYKwreA2VH0ncK1Pt2
         GbaCZVGM4Ijw4gxB/SEQBGJHUtPRZyYij09XbpYPvHKeISssD3fhLcLKwnNhcE3D2h
         tcoFxzOaXj/uFNZzdH25zmreVHK6VIzVv0L+v6hjiAXxNQdRnwi0dCTi3g292SCb14
         JA8Q0y5udcv7w==
Date:   Mon, 17 Jan 2022 13:22:03 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Moshe Tal <moshet@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20220117132203.43528592@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yz=fH3GoRaME8zvBnrHq25h";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/yz=fH3GoRaME8zvBnrHq25h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  429e3d123d9a ("bonding: Fix extraction of ports from the packet headers")

Fixes tag

  Fixes: a815bde56b15 ("net, bonding: Refactor bond_xmit_hash for use with

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

Please, in the future, do not split Fixes tags over more that one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/yz=fH3GoRaME8zvBnrHq25h
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHk0ssACgkQAVBC80lX
0GxS5Qf+JDelqxLQcIr71MFI6IjhJ95WyC0filly6nak+r2K8/5M9Zg34+CLhSP6
GAdI55/j63XWt+q4DJkxblW4jrqmukEbWeVYmJrxkmUlXwHjQZFjo3mhmtZC5/Pi
Meva5rG1tZyY9k85KzXk6yPLcBkhwfUZ3mOjhvqMuPN5QbJHOPCrLIiytat9ZMye
kEly1kVAtUtalnQsfQ8GcjRfZfwXzNMJEUjmM6y7DoKQrO7KWIKV6nO69CJxyLO5
PLQkRVvh+CBS0cXq4w5H8eeKxkMvMLwh+oDBZVzqgWpYHgzJRQ60SIthsbnNBpWm
NZ3Lo8FzLA+wEtz0WhiEZ8EBP2u0LA==
=l4/t
-----END PGP SIGNATURE-----

--Sig_/yz=fH3GoRaME8zvBnrHq25h--
