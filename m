Return-Path: <netdev+bounces-4916-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1980870F2A2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C912F280F79
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D737DC2F4;
	Wed, 24 May 2023 09:22:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF76C2E1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:22:40 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAA1130
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 02:22:13 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 0F4181FE2F;
	Wed, 24 May 2023 09:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1684920125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OdlLHTm10vBGsbOg2QjxOUVqEyhkwZl0b0PH2Ffn4K8=;
	b=Yz10kh2llqvTGYL7byJyODkoNMLRest8+m6cQfMtofyey1h7D4sV3RLUEGowNXNHP0FmvA
	yCOQes7HagW1ZDAnAaectACbA/0HY6cpDYGzv7YavNDG00OurnlPALSu2oiivd5QWJLciy
	9RgM7Y1i2IJLiQJrJG7qCyRRYe8uziw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1684920125;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OdlLHTm10vBGsbOg2QjxOUVqEyhkwZl0b0PH2Ffn4K8=;
	b=gTmIHr01u61FESlQmfcNBSPStmr/f474OOpWcSNprUPvqBBQDxMLoFPpi3TWM5+/KeAkcW
	2FMovDUK67NkZyBw==
Received: from lion.mk-sys.cz (unknown [10.163.44.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 00FEA2C141;
	Wed, 24 May 2023 09:22:04 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
	id D561360433; Wed, 24 May 2023 11:22:04 +0200 (CEST)
Date: Wed, 24 May 2023 11:22:04 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: netdev@vger.kernel.org
Cc: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Subject: Re: [PATCH ethtool] Require a compiler with support for C++11
 features
Message-ID: <20230524092204.jvq2l23xkcqgah2x@lion.mk-sys.cz>
References: <20230523171908.2000901-1-dario.binacchi@amarulasolutions.com>
 <20230524082407.onank3xhtd35vmc6@lion.mk-sys.cz>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jfn3pczbsttrzkye"
Content-Disposition: inline
In-Reply-To: <20230524082407.onank3xhtd35vmc6@lion.mk-sys.cz>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--jfn3pczbsttrzkye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 24, 2023 at 10:24:07AM +0200, Michal Kubecek wrote:
> On Tue, May 23, 2023 at 07:19:08PM +0200, Dario Binacchi wrote:
> > Just like the kernel, which has been using -std=3Dgnu11 for about a yea=
r,
> > we also require a C11 compiler for ethtool.
> >=20
> > The addition of m4 macros allows the package to be compiled even if they
> > are not present in the autoconf-archive.
> >=20
> > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > ---
> > +# SYNOPSIS
> > +#
> > +#   AX_CXX_COMPILE_STDCXX(VERSION, [ext|noext], [mandatory|optional])
> > +#
> > +# DESCRIPTION
> > +#
> > +#   Check for baseline language coverage in the compiler for the speci=
fied
> > +#   version of the C++ standard.  If necessary, add switches to CXX and
> > +#   CXXCPP to enable support.  VERSION may be '11', '14', '17', or '20=
' for
> > +#   the respective C++ standard version.
>=20
> Is this the correct macro? We need C compiler, not C++, so we probably
> rather need something like AX_CHECK_COMPILE_FLAG().
>=20
> Or maybe even that is an overkill and just AC_COMPILE_IFELSE() with an
> empty source and enforced "-std=3Dc11" in CFLAGS might suffice.

I experimented a bit and this seems to do the trick:

------------------------------------------------------------------------
--- a/configure.ac
+++ b/configure.ac
@@ -13,6 +13,13 @@ AC_PROG_GCC_TRADITIONAL
 AM_PROG_CC_C_O
 PKG_PROG_PKG_CONFIG
=20
+AC_LANG(C)
+saved_CFLAGS=3D"$CFLAGS"
+CFLAGS=3D"$CFLAGS -std=3Dc11"
+AC_COMPILE_IFELSE([AC_LANG_SOURCE([])],,
+	AC_MSG_FAILURE([The compiler does not support C11 standard.]))
+CFLAGS=3D"$saved_CFLAGS"
+
 dnl Checks for libraries.
=20
 dnl Checks for header files.
------------------------------------------------------------------------

(Plus some message on success, of course.)

Michal

Note to self: configure.ac would certainly deserve a review and cleanup.
Examples: strtol() is guaranteed by C11 (and probably long before that),
with included copy of linux/types.h there is no need to check for
__be16/__be32 any more and AC_PROG_GCC_TRADITIONAL is also unlikely to
be still of any use.

--jfn3pczbsttrzkye
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmRt1zgACgkQ538sG/LR
dpWLqwf+NJPqOUi9pPYBiCsdtJU6TpheXS6UlypOAaHTVOnVc9jLIG4vcx2FnMLM
nnkIO5UKYXapil013eey8kREEBGC/doDI2JT/crVN6ZqjOqQDPMyypniNdOlpCEY
9sPHWIa6Cx4ZTglPmS60Z2g6WuSQ7DrY7Sun8xYHbXyLUQ8Mm6Xaa/ir+f6lVZ9b
J+WUmJqKDt2sKIY+CYVRM4uotsreAHwYxyUsKvYrgTfouK5moc8k8wHd72asTa6a
yqASTCzrbwZjfEob7EbHOg93+hqb8rH0Hf7ZJPMWtjzXVNXr7uwThN7zBxd1iQA1
/+5jd1BS6Aul/au/9fNL1RYJemduxQ==
=xn6q
-----END PGP SIGNATURE-----

--jfn3pczbsttrzkye--

