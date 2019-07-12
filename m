Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E90D0666ED
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 08:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbfGLGXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 02:23:11 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:55229 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbfGLGXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 02:23:11 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45lNCH5r3pz9s4Y;
        Fri, 12 Jul 2019 16:23:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562912588;
        bh=jh4yud1uh5MHKbfXMC20Ub1u0Ft7ZfL9wBBPxAOC0mk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MjniTqyxB281FEgODDvI9asxlGGnn4kx0DS/8roF3a/FE5Fnie9lR9N44wd21alte
         kyvVewrQ9Hh6ypfiuIKt+KBewclioUPMu9cP8OJiWR7YPJUwCqhs+LfBjL4Bd1nDaK
         Bv4mFJ6Lg3lfr5EFdTMIy9MlkeUtIh/ca5ANyVvPg4+rcGf2cRJfN2cEID0xesUGhy
         ekxnALUincd0qtXlKpF7wWgykDiSMHYQ3YBHsMlIf5zHz7sSJhgzyPdFsq2tAKzSOO
         hpP7ZgIJ9LWzk7lceEnRyACD9RCu18kj8YPui/4jyYgRo3qEDRg16m2fBaj8FY6dWt
         87iM9ikaR7d0A==
Date:   Fri, 12 Jul 2019 16:23:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Yoshinori Sato <ysato@users.sourceforge.jp>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: linux-next: manual merge of the net-next tree with the sh tree
Message-ID: <20190712162307.4d63a16a@canb.auug.org.au>
In-Reply-To: <87y313950z.wl-ysato@users.sourceforge.jp>
References: <20190617114011.4159295e@canb.auug.org.au>
        <20190712105928.2846f8d0@canb.auug.org.au>
        <87y313950z.wl-ysato@users.sourceforge.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UZ8nh1ToNs3warKxgFKUtF6"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/UZ8nh1ToNs3warKxgFKUtF6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Yoshinori,

On Fri, 12 Jul 2019 14:49:00 +0900 Yoshinori Sato <ysato@users.sourceforge.=
jp> wrote:
>
> I can not update sh-next now, so I will fix it tomorrow.

You don't need to (and should not) update your tree, just mention the
conflicts to Linus when you send your pull request.

--=20
Cheers,
Stephen Rothwell

--Sig_/UZ8nh1ToNs3warKxgFKUtF6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0oJ0sACgkQAVBC80lX
0GzUBAf+KfXxUOmFzD8cKQI3teZDWaDKNCiU0gCTBmfa1zV9RYliEXiKGo7M5MGA
MQRPA8W44jqPgvgZWXtTuiZdgZySQ33JfnjJ6qd0pEHF+HfSOnxjvcciO6sBqOy9
MzZJLhF42zSkTz5g9SFz8y7maJKyjYRxJ32oFytvu5npI1tpWT8s4SX1F1XkhSMO
8GnFjZtAViMNu4oYd9roqzg0fty3BxOGK+8yasiZj13kb/aZfmEhvqkSTUjLEL53
MshiPYzNP/8HVt3IWmJ+J0AWKhcCxEsXrDptlESevqFEGNCeEqZ43IbU8UZzrOOz
pxE9rCUG+/z7fW89e1yK5NXgktgCTA==
=/vsf
-----END PGP SIGNATURE-----

--Sig_/UZ8nh1ToNs3warKxgFKUtF6--
