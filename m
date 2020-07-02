Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70702127B8
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 17:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgGBPXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 11:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726807AbgGBPXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 11:23:37 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCF68208B6;
        Thu,  2 Jul 2020 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593703417;
        bh=WNTkJbutilXS82yRZLpy+ORdJKpcXG8AaT4h8ivgBxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IO27kxXbo/P4rRR6VADu+Ya64vT44dzJWzB4oWNekCyIHo6tVM1IRX18CYnuiL3oO
         J51pEoHytJXAHtFcGivkDIcOSMQIyRBhLDJpGqz0G+dxGiDEHsDrokKHQq4xAzyNIT
         w08ZbGp/qLFQHQQU0YajAR7ZinMTdyeksf2VLOM8=
Date:   Thu, 2 Jul 2020 16:23:35 +0100
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
Message-ID: <20200702152335.GJ4483@sirena.org.uk>
References: <20200620033007.1444705-1-keescook@chromium.org>
 <20200620033007.1444705-9-keescook@chromium.org>
 <20200701203920.GC3776@sirena.org.uk>
 <202007020819.318824DA@keescook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GlnCQLZWzqLRJED8"
Content-Disposition: inline
In-Reply-To: <202007020819.318824DA@keescook>
X-Cookie: I'm rated PG-34!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GlnCQLZWzqLRJED8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 02, 2020 at 08:21:40AM -0700, Kees Cook wrote:
> On Wed, Jul 01, 2020 at 09:39:20PM +0100, Mark Brown wrote:

> > Please copy maintainers on patches :(

> Hi! Sorry about that; the CC list was giant, so I had opted for using
> subsystem mailing lists where possible.

If you're going to err in a direction there I'd err in the direction of
CCing the people not the list - I only saw this since I was looking for
something else, I don't normally see stuff in the mailing list folder.

--GlnCQLZWzqLRJED8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl79+/YACgkQJNaLcl1U
h9Djdwf9FVJo+4ywgEFtzDJmcKhgfjUWwqu3KS6uuCh0kB55Sw1SQjJSSXpOVAxD
c1THQwWtp3yoK50+wen7yecLtGzYsGfOc1qPCbtoHXUb4vt9F+2dUN3fYKlp5OkY
ptmLndV7KSAVJLXgCq3TadMYTowK69OXYgiVLB63DplYlmYfBulsIp0tstfTNxTd
/9OTPNQwCTG4HFHZcCOoKL62qCNCSgYJEamVHX8CAIYb1B9JHmPQQg5lm9xja8Do
f9XUirVfGI8NG4jqh51RT140BT7QOzzj5jZIV5wOf+fFu6SAD35MvR+YlABDxfNx
sED17NzL1wIx4PO0x1a//RB9L31ujg==
=X/3I
-----END PGP SIGNATURE-----

--GlnCQLZWzqLRJED8--
