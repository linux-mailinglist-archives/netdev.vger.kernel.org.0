Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9929211483
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 22:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgGAUjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 16:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgGAUjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 16:39:23 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 395DA20760;
        Wed,  1 Jul 2020 20:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593635962;
        bh=Mv90pdTDmmCVPBQ+ilKuLGK6rDI94hGPVOU6z7qxgNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vn7yonK6UORJ8OJ5CLMTZ2+x/gvdycGSabhl28wLOeWEfNZZtkdKMc0I9L12/I0dk
         bB9jRJM9ZAsrHrmNUN0Xe9QCw5cG+b24CXLz5B4CAtKfE3rFp/wnozWmeRUhlpAwyP
         D81gDHxv1SI3ntiRTx4ygWm8AtJKSXVEdFaatGao=
Date:   Wed, 1 Jul 2020 21:39:20 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mm@kvack.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH v2 08/16] spi: davinci: Remove uninitialized_var() usage
Message-ID: <20200701203920.GC3776@sirena.org.uk>
References: <20200620033007.1444705-1-keescook@chromium.org>
 <20200620033007.1444705-9-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Content-Disposition: inline
In-Reply-To: <20200620033007.1444705-9-keescook@chromium.org>
X-Cookie: "Ahead warp factor 1"
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 19, 2020 at 08:29:59PM -0700, Kees Cook wrote:
> Using uninitialized_var() is dangerous as it papers over real bugs[1]
> (or can in the future), and suppresses unrelated compiler warnings (e.g.
> "unused variable"). If the compiler thinks it is uninitialized, either
> simply initialize the variable or make compiler changes. As a precursor
> to removing[2] this[3] macro[4], just remove this variable since it was
> actually unused:

Please copy maintainers on patches :(

Acked-by: Mark Brown <broonie@kernel.org>

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl789HcACgkQJNaLcl1U
h9AfDgf/RKZyImjLhB9HvSTTPElSdnVo2uGyMkLMGX5E2rrBkIm+JRHNqfloV/46
Mx7zbEttRmKiYixfSdmsDpbg56ljycPfGBLHIZxfW4p4HDkXI2rwNl6yNQwAFGfS
xREw+xp//6eFOklwHHWspFdXjwvYVwxwCJbntC3mxtA44GrP1RcSNdlYSRlLMUqE
b4V1aHQtulWHWcA6qc3e7e3VH7t/F4vy9AftF3S8ckIbrmZO6+HfcvGjITyILn0T
0ReKIdfQ/UEHEeGXnai1E9efkWymKRW43Frx6JRO6Sd4KhBeHGohovlQ3mhKLfdg
vH1jBuQdhXfJWc+yprXAcHmpsHpQZw==
=XnWw
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
