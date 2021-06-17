Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AD03AAB65
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 07:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhFQFwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 01:52:23 -0400
Received: from www.zeus03.de ([194.117.254.33]:43670 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhFQFwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 01:52:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=txV8Finzg7rGGU0YURmRHYvLobGc
        EfiaKSowZNWDJVY=; b=HjNWC/Evgt4kqDKXfI5VamHFThUEmLCRh7Y2yPlH73TP
        K7opLL7qwa2VR5I9SQRq15TdsaJDrJEdPMaTXgdldKz7RAnQyvZSwhMJEr6ELNFj
        DtoEfnRUwXYKhA/OCmoDlPnxkkStBczp0vFas8gDwMwqt+DThYbbF4dIsAFHGkQ=
Received: (qmail 212463 invoked from network); 17 Jun 2021 07:50:11 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 17 Jun 2021 07:50:11 +0200
X-UD-Smtp-Session: l3s3148p1@I0PDx+/EVM4gAwDPXxG6AGBCCTPRmR7s
Date:   Thu, 17 Jun 2021 07:50:11 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     netdev@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michael Walle <michael@walle.cc>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
Message-ID: <YMrik9LBVYvu3Xkw@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michael Walle <michael@walle.cc>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210616195333.1231715-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OZ12UJaMUBfcACI+"
Content-Disposition: inline
In-Reply-To: <20210616195333.1231715-1-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OZ12UJaMUBfcACI+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 16, 2021 at 12:53:33PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally reading across neighboring array fields.
>=20
> The memcpy() is copying the entire structure, not just the first array.
> Adjust the source argument so the compiler can do appropriate bounds
> checking.
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>

For the record:

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--OZ12UJaMUBfcACI+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmDK4pIACgkQFA3kzBSg
KbYVvg//dtV8RU8D/hpGH2BEQIDcYy8gwypQ8GJLk2kiWH1H9M2CjnQciapF/8l0
WeMMCSD70iVw9nTNT0DMv64M8LxpPTYS9fEMmbtfEn45Yb25ax3TPyiAT4FxA3yB
iQN+m7Q9FbdZfEQzH7itu9AMtCqZZPB5BeWLM8NLDrPgkZEV4wCKxDk3f49Gx8mD
3K0pvPEbn5yiqrmhkADYND75RT9cJX4pzLdQuRnSFRd8WLvOJCaze+zGrwdVsa22
kgWuXT9U8IxuXPUaW2JbV/DzjTHbin5kmmWl3jcJgjSWDeNJ8F0l4W3Ydp3UMLtW
mBmohFQZMfxM6414ZPg4GTmq/rUIMc2tePgqPWmFMzGE/EA7ShsXXwbuhAtO3WH3
VpL3QvmIqG1zZW7IXGBQ/xbyjjIwvS7LKVGv9KovEcfikJ4VjCQhoDmJ9YvPttsp
8ZujPnk6cQMAAvdQFzNKSxHhwaLynu4eKpUS1h8H31Hg0CY3P1IdLLuZ1Qfvm+ZY
HVdp1JUSbzhCnkkiUaIC6QgzxcAGIOqY3yORuWJ+IDMeBKf/KmRUEofkkxN1ZCht
0Cqcvep3wJHZjBetRgLAonjmIaApw6nMzH09oy6NAhqYB4LM0LJdbmaDnR4UMRwH
FxmptOJGqgzguBOjKYsQblJs1dFWvcBfc6CoIwrORAw344klKjs=
=GZHy
-----END PGP SIGNATURE-----

--OZ12UJaMUBfcACI+--
