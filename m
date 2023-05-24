Return-Path: <netdev+bounces-4896-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C882770F08F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79776280E9D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 08:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 906D2C158;
	Wed, 24 May 2023 08:24:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FBDC145
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:24:12 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1FC9E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 01:24:10 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id C5EDF21A2C;
	Wed, 24 May 2023 08:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1684916648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W7bVwmmhWryN+m1FgIeRID4Gyf7PFLpcwrzPrFBQQbI=;
	b=gn0h952CQXCbC5FIh4kjMBE7o302aVJ2oeDVPkoB2R71eezrKf5mvyYirnNHCKc/UgrFnL
	Awh96IvX8CkW/2p43HH/5l46YrhD6gkR7OEgEjNM4fur3LUnuPKWwTNvOjUV7MsMTPVKpM
	D32Xy2+i15IwHlT0iyBGFfLdK8vrhxY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1684916648;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W7bVwmmhWryN+m1FgIeRID4Gyf7PFLpcwrzPrFBQQbI=;
	b=SRNakRaHP/r26LfZ/0AUMwB9PImyKF0YiiTl17dZM8OVmyyAThb3+HlFStufeFez8froaI
	uac/QKvswiX6AyDg==
Received: from lion.mk-sys.cz (unknown [10.163.44.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id B19CA2C141;
	Wed, 24 May 2023 08:24:08 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
	id 610E760433; Wed, 24 May 2023 10:24:07 +0200 (CEST)
Date: Wed, 24 May 2023 10:24:07 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] Require a compiler with support for C++11
 features
Message-ID: <20230524082407.onank3xhtd35vmc6@lion.mk-sys.cz>
References: <20230523171908.2000901-1-dario.binacchi@amarulasolutions.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cbo2nlxzdktm5qhl"
Content-Disposition: inline
In-Reply-To: <20230523171908.2000901-1-dario.binacchi@amarulasolutions.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--cbo2nlxzdktm5qhl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 23, 2023 at 07:19:08PM +0200, Dario Binacchi wrote:
> Just like the kernel, which has been using -std=3Dgnu11 for about a year,
> we also require a C11 compiler for ethtool.
>=20
> The addition of m4 macros allows the package to be compiled even if they
> are not present in the autoconf-archive.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> ---
> +# SYNOPSIS
> +#
> +#   AX_CXX_COMPILE_STDCXX(VERSION, [ext|noext], [mandatory|optional])
> +#
> +# DESCRIPTION
> +#
> +#   Check for baseline language coverage in the compiler for the specifi=
ed
> +#   version of the C++ standard.  If necessary, add switches to CXX and
> +#   CXXCPP to enable support.  VERSION may be '11', '14', '17', or '20' =
for
> +#   the respective C++ standard version.

Is this the correct macro? We need C compiler, not C++, so we probably
rather need something like AX_CHECK_COMPILE_FLAG().

Or maybe even that is an overkill and just AC_COMPILE_IFELSE() with an
empty source and enforced "-std=3Dc11" in CFLAGS might suffice.

Michal

--cbo2nlxzdktm5qhl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmRtyaIACgkQ538sG/LR
dpUa6QgAoovvgt3TTtBM+a8oOBn3l72zseNHTSEJ/vVdAQt9DLFdl5qeVSzQzT96
fP0Jb+9srLAwHoJT7YRBNeIVlrrMfuBxeE6K2U6CTi+GkZeclWOrjxIWDPJoKcr7
mm/7IQaBXsbmiUnlImBOzgbaf5O8NEc5U40ggJs0meolvwclDfvYHJLz0uWjVRBl
0CFZKriCqfmFyXRsUr5yZjp7GAdKpnxu5KiwKi7gNagx80kxRehjbAUkbtPprHIZ
T8xyll2Pe9LU605AZjLQbRmf5OgzDP2ccSCqsAlsf2CMy8vzQPRxcTcS5WCflIqb
+oL9C3YPenVOlUJR1BCys+Uxc2w5ZA==
=wU7v
-----END PGP SIGNATURE-----

--cbo2nlxzdktm5qhl--

