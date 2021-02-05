Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A8031060C
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 08:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhBEHs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 02:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhBEHsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 02:48:25 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361EDC0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 23:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1612511261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NY/OHLmGEhTKLYIQvD2W3iTCrAS4oS+QNMhd0T0lkUA=;
        b=nJ6tr4cN3klUZizZOlUCBVI1QljYZiNC+uMKw+Uju7OsIHIs9aGsxtYwMVbsCqshoW4uvP
        vtM1+Vsqbtp/R5CkiX2nHUJ6M7hfH9rBrIzx6DKFVdD8e4EvrPvxuWcdk9CWaxWSxyAcY0
        BDuLEBPlIDlwRpUsTUBukLNv0d9Eqls=
From:   Sven Eckelmann <sven@narfation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Wunderlich <sw@simonwunderlich.de>, davem@davemloft.net,
        netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 2/4] batman-adv: Update copyright years for 2021
Date:   Fri, 05 Feb 2021 08:47:38 +0100
Message-ID: <4678664.8dpOeDNDtA@ripper>
In-Reply-To: <20210204115836.4f66e1c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210202174037.7081-1-sw@simonwunderlich.de> <3636307.aAJz7UTs6F@ripper> <20210204115836.4f66e1c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4981605.MO7qgpoJSq"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart4981605.MO7qgpoJSq
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Simon Wunderlich <sw@simonwunderlich.de>, davem@davemloft.net, netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 2/4] batman-adv: Update copyright years for 2021
Date: Fri, 05 Feb 2021 08:47:38 +0100
Message-ID: <4678664.8dpOeDNDtA@ripper>
In-Reply-To: <20210204115836.4f66e1c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210202174037.7081-1-sw@simonwunderlich.de> <3636307.aAJz7UTs6F@ripper> <20210204115836.4f66e1c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>

On Thursday, 4 February 2021 20:58:36 CET Jakub Kicinski wrote:
> Back when I was working for a vendor I had a script which used git to
> find files touched in current year and then a bit of sed to update the
> dates. Instead of running your current script every Jan, you can run
> that one every Dec.

Just as an additional anecdote: Just had the situation that a vendor 
complained that the user visible copyright notice was still 2020 for a project 
published in 2021 but developed and tested 2020 (and thus tagged + packaged in 
2020).

Now to something more relevant: what do you think about dropping the copyright 
year [1]?

Kind regards,
	Sven

[1] https://reuse.software/faq/#years-copyright


--nextPart4981605.MO7qgpoJSq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmAc+BoACgkQXYcKB8Em
e0YNDA/+Nw44yDv7M7vmOZufXsViF7g4fnHI7veE1xwU043DWUmEX3k/I8Yb4Fd8
H/QQWCYpkh+RyRj9s0JQ6Ji1dZSnSr93sqE9Wy0yoBN69vLynwe0KNKg+t8NMGo9
9WqvSz11XEZlfLRhzvu9B/rvmOfoDLyahnyzIGJK81hWYZVHUlo7JUs71+Lspe9y
QV3FVc1AxTfevP0zm8t7Be5ltD1oHHxmvN9eAcg0myODXKF0DyMzkQ/ksaooIxNR
m29OkGJ4BgWgHsVGzanW59aULt33vA4i8teuDEqNBOaI9AJLPsrO/SUEXqRTaXGH
hu9Phmr4TZrS2EfjghbONnyDT65aJCfIpLg102FqzWKXEdpGKapJFTnbz2PY1wds
GAQbozAHRW7WmBFLOe+617rjrpqVF+CBJNZ0LCTXOctpiD2GMeVlxPiczhthLDU8
4SpoTIb2Hgjvta/QcSNJNaSsNCGxbdn7uVQJI48m83ne+RxMxPyakESJMFNvKWj6
B0Dlis5W2y0V63DDkIL3NQU1V7Jf1gmNnhuSYk8DsXsWJ45hrhHkTO1vKlRMmV8t
X9xrErO8V17zDovGNgtMdpNcMTiuKnkLcc2RnazR26gH3Ro/f3ldq+8XjYduzlQr
74T6js8h/LNuZtvRFeKehwPaKOF4wlRq5I5El6JosOdwHHUVV9s=
=Gonv
-----END PGP SIGNATURE-----

--nextPart4981605.MO7qgpoJSq--



