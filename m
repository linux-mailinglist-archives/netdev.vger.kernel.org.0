Return-Path: <netdev+bounces-4653-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2250270DAEF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:54:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF52C1C20B8C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76CFC4A852;
	Tue, 23 May 2023 10:54:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D224A840
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:54:20 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D978412B
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:54:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 8235421CF0;
	Tue, 23 May 2023 10:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1684839255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V+Xxt2OssOo+9AwYVZEgzP/z/CBaIs5lnhWg3Qyny/I=;
	b=l5H6kQP4sY1EItwBEAj7pi0cA2cjRaOugLojXI+h/DWyjP6Rd4TN78xsWOxgCaRWhS6C97
	ZnGPpJbFaMea2HyuR2T+qsU7melrc1tPqt7AV7VY+InEEGHxKnqccyH3PtUjRmfoKWnFfO
	tAU3iTQuZY3HzL50hDqgohRVqXFqv0w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1684839255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V+Xxt2OssOo+9AwYVZEgzP/z/CBaIs5lnhWg3Qyny/I=;
	b=D8iN7icqu0AtDdXDLBwhCRGxeEDZvYY1QWykPvn3wmt1UQn9oUM/UiAoBOQEASeOU13gXO
	EsiZ4aRRO80UlGDg==
Received: from lion.mk-sys.cz (unknown [10.163.44.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 67E272C141;
	Tue, 23 May 2023 10:54:15 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
	id D869860410; Tue, 23 May 2023 12:54:10 +0200 (CEST)
Date: Tue, 23 May 2023 12:54:10 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc: netdev@vger.kernel.org,
	Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Subject: Re: [PATCH ethtool v2, 1/1] netlink/rss: move variable declaration
 out of the for loop
Message-ID: <20230523105410.wuoaft3kuw7lv7x5@lion.mk-sys.cz>
References: <20230522175401.1232921-1-dario.binacchi@amarulasolutions.com>
 <20230523050604.h7qlqdop2fxxcejy@lion.mk-sys.cz>
 <CABGWkvrG8rsWpLaXhLN6G0GqW3XF1z=fy=GaCs34iti6+r2TPg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="fdmicmxtjnx4ewei"
Content-Disposition: inline
In-Reply-To: <CABGWkvrG8rsWpLaXhLN6G0GqW3XF1z=fy=GaCs34iti6+r2TPg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--fdmicmxtjnx4ewei
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 23, 2023 at 09:28:19AM +0200, Dario Binacchi wrote:
> On Tue, May 23, 2023 at 7:06=E2=80=AFAM Michal Kubecek <mkubecek@suse.cz>=
 wrote:
> > Anyway, with kernel explicitly declaring C11 as the standard to use
> > since 5.18, it would IMHO make more sense to do the same in ethtool so
> > that developers do not need to keep in mind that they cannot use
> > language features they are used to from kernel. What do you think?
>=20
> I agree with you.
> Anyway, to fix this issue
> https://patchwork.ozlabs.org/project/buildroot/patch/20230520211246.39501=
31-1-dario.binacchi@amarulasolutions.com/
> can I send patch updating configure.ac as suggested by Yann E. Morin ?
>=20
> --- a/configure.ac
> +++ b/configure.ac
> @@ -12,6 +12,10 @@ AC_PROG_CC
>  AC_PROG_GCC_TRADITIONAL
>  AM_PROG_CC_C_O
>  PKG_PROG_PKG_CONFIG
> +AC_PROG_CC_C99
> +AS_IF([test "x$ac_cv_prog_cc_c99" =3D "xno"], [
> +       AC_MSG_ERROR([no C99 compiler found, $PACKAGE requires a C99 comp=
iler.])
> +])

I like this approach much more than the previous patch. But how about
using C11 instead? My point is that kernel is already using -std=3Dc11
(or, more precisely, -std=3Dgnu11) for build for about a year and we
can expect significant overlap between kernel and ethtool developers.
Therefore choosing C99 would inevitably result in similar issues in the
future (people using features they are used to from kernel and breaking
the build on older systems not having C11 as default).

As far as I can see, GCC should support -std=3Dc11 since version 4.7, that
does not seem to be too restricting dependency to me.

Michal

--fdmicmxtjnx4ewei
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmRsm04ACgkQ538sG/LR
dpUOnAgAhPi2WndXuy6AY4pSD8W5sFpOZ08KlS4zPGt5ftAqnYBpaVx2soRTgJQv
eu0fr/xJ7rwLGb0/fjoNEt4iNqxxDa0BVNTUeRcXg0cj4BGs/JD8dItHkdKJnQYH
BIJO3zNUEN+CwZK5Kdnttj85UEy4m5aeA3pdCUVYgLs7HvXPPDC5zzhIs0+KfqxW
lzM+BqMLD87W5JKXGQic8zEeoAHU6cMNB++2arQdM2GPzOUVfc+cZn8lXjGAm2Ts
xvYp3DTprbgC0HTDkYTE0/u2BEnad7dLnKUqG8oRgU+n/caLl+uGD09DSS4oJ9Oc
N+rbRj2GrlTK6VwZ9kyH72Z69MpjrA==
=saVu
-----END PGP SIGNATURE-----

--fdmicmxtjnx4ewei--

