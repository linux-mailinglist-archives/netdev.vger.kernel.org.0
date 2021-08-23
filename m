Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504563F5335
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 00:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhHWWJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 18:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbhHWWJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 18:09:24 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228E8C061575;
        Mon, 23 Aug 2021 15:08:40 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GtmbT067bz9sXM;
        Tue, 24 Aug 2021 08:08:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629756517;
        bh=Atof3JsWfIFHXSoRpUxLakpVF2VquMXJ9JWQN8Acru4=;
        h=Date:From:To:Cc:Subject:From;
        b=guYQVwDjtrtgiBetThIyxBennc4nTdNXki+uoPTU4MursSVowCn0EnCSkmQJWjgSG
         y6BXNTUk/AN9tT5zfoHo46H3FKKkCZzTOaxww1HggCsej9Max7MfTxScv1elN3hSWk
         WAYpENDM8psOWkOtI6DWXLmmU0iyf1KQSMkAEjUUDqQ8OliwVdKqov5GecxV3pA2EC
         zwFHHJ7qu83wYkJmJ2AzVWoY1eFp5cfbr1mYS5cR3J4k32MepnDfoj0txkj1TQr/Ip
         pTiZR0k/lIrtd+U/tCXHI7kcTArtybujRL7ZyT/wlTxGeol+xjcVDGU0J1K3hedK8t
         06ufU+ko9W44A==
Date:   Tue, 24 Aug 2021 08:08:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the bpf tree
Message-ID: <20210824080835.66902837@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/TfGK6.gElTLhQP8EgxlRXNC";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/TfGK6.gElTLhQP8EgxlRXNC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  9cf448c200ba ("ip6_gre: add validation for csum_start")

Fixes tag

  Fixes: Fixes: b05229f44228 ("gre6: Cleanup GREv6 transmit path, call comm=
on

has these problem(s):

  - Extra word "Fixes:"

Also, please do not split Fixes tags over more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/TfGK6.gElTLhQP8EgxlRXNC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEkHGMACgkQAVBC80lX
0GwMtggAhfUS/I9GA28j8v+WbXKHs1A8nqVu2hY2plahalvfHgInjfkr0ADZyfL8
tgZRrqd4wP94oSQ+jXebaLLzCf7cXkVnTjrvX//Hi19lWIKcaOzh0T6ym+zzr2CT
DHvXAr06XlZ2IU82/GPtucXWY6TLFL/nRKUQhUHPRbCrkeJ3cjtNdxWxiXnnG5H6
I9AB/ci6rM2QWWcXrR/AGgcTV8A/tpKjaA7wx97+9tfBho88iy22FsS9Vg8bQqk+
qCeaEasUX5mXyMMn5WZqyKmTy+jIpvPaDlgHUC+QRNrCc7Qifx70uBUryHEuC01U
Au+kWFoUHHmyUYHvQ6RbNkYSGHHWfQ==
=eBnB
-----END PGP SIGNATURE-----

--Sig_/TfGK6.gElTLhQP8EgxlRXNC--
