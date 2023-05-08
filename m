Return-Path: <netdev+bounces-819-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB5986FA133
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 09:40:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BB731C2096B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 07:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897CE154A1;
	Mon,  8 May 2023 07:40:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7912B3C21
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 07:40:43 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFB31A1C0
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 00:40:41 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 1C31221F01;
	Mon,  8 May 2023 07:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1683531640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=svJr/QL7IvrM0dMZ9kDYqUkInRrxGGXDc4kn3BwGDzI=;
	b=Js8trxgIeJ4Zeilp4ylgtgbF4SGG7gj5jkauRt+5e+YDL2/hw0cNpxqtTwzBi/n4aqedKd
	vJziygUehpR+wz70IiBwCnxYdIfvM2uHOWHZVf6jmTqYbfBmXcgT3krpDdOEtzxbdBMm0c
	fEzemiGYt9ceXB9mpm3YJavL3N+MiUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1683531640;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=svJr/QL7IvrM0dMZ9kDYqUkInRrxGGXDc4kn3BwGDzI=;
	b=VLUrM5VqwMjND0XxpNUV2pDB8J7/mF32ypFvRguHAB/wpdF/A2w6DouQfsOMsGYjnQmrz6
	ZVgiJryknHvKTaBw==
Received: from lion.mk-sys.cz (unknown [10.163.44.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 0F71F2C141;
	Mon,  8 May 2023 07:40:40 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
	id E7AC560414; Mon,  8 May 2023 09:40:39 +0200 (CEST)
Date: Mon, 8 May 2023 09:40:39 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Nicholas Vinson <nvinson234@gmail.com>
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 3/3] Fix potentinal null-pointer derference
 issues.
Message-ID: <20230508074039.n6ofud6dbkuhe64x@lion.mk-sys.cz>
References: <cover.1682894692.git.nvinson234@gmail.com>
 <105e614b4c8ab46aa6b70c75111848d8e57aff0c.1682894692.git.nvinson234@gmail.com>
 <20230507225752.fhsf7hunv6kqsten@lion.mk-sys.cz>
 <8907c066-9ac9-8abc-eeff-078d0b0219de@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6ujo7n4f5vdixqin"
Content-Disposition: inline
In-Reply-To: <8907c066-9ac9-8abc-eeff-078d0b0219de@gmail.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--6ujo7n4f5vdixqin
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 07, 2023 at 10:46:05PM -0400, Nicholas Vinson wrote:
>=20
> On 5/7/23 18:57, Michal Kubecek wrote:
> > On Sun, Apr 30, 2023 at 06:50:52PM -0400, Nicholas Vinson wrote:
> > > Found via gcc -fanalyzer. Analyzer claims that it's possible certain
> > > functions may receive a NULL pointer when handling CLI arguments. Add=
ing
> > > NULL pointer checks to correct the issues.
> > >=20
> > > Signed-off-by: Nicholas Vinson <nvinson234@gmail.com>
> > A similar theoretical issue was discussed recently:
> >=20
> >    https://patchwork.kernel.org/project/netdevbpf/patch/20221208011122.=
2343363-8-jesse.brandeburg@intel.com/
> >=20
> > My position is still the same: argv[] members cannot be actually null
> > unless there is a serious kernel bug (see the link above for an
> > explanation). I'm not opposed to doing a sanity check just in case but
> > if we do, I believe we should check the whole argv[] array right at the
> > beginning and be done with it rather than add specific checks to random
> > places inside parser code.
>=20
> By convention and POSIX standard, the last argv[] member is always set to
> NULL and is accessed from main(int argc, char **argp) via argp[argc] (see
> https://pubs.opengroup.org/onlinepubs/9699919799/functions/execve.html).
> It's also possible for argc to be zero. In such a case, find_option(NULL)
> would get called.

Please note that ethtool is not a utility for a general POSIX system.
It is a very specific utility which works and makes sense only on Linux.
That's why it can and does take many assumptions which are only
guaranteed on Linux but may not be true on other POSIX systems.

> However, after reviewing main(), I recommend changing:
>=20
> =A0=A0=A0=A0=A0=A0=A0 if (argc =3D=3D 0)
>=20
> =A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 exit_bad_args();
>=20
> to
>=20
> =A0=A0=A0=A0=A0=A0=A0 if (argc <=3D 0 || !*argp)
>=20
> =A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 exit_bad_args();
>=20
>=20
> as this fixes the potential issue of main()'s argc being 0 (argc would be=
 -1
> at this point in such cases), and "!*argp" silences gcc's built-in analyz=
er
> (and should silence all other SA with respect to the reported issue) as t=
he
> SA doesn't recognize that it would take a buggy execve implementation to
> allow argp to be NULL at this point ).
>=20
> If you don't have any objections to this change, I can draft an updated
> patch to make this change.

As I said before, I do not object to adding a sanity check of argc/argv,
I only objected to adding random checks inside the parser code just to
make static checkers happy. If you want to add (or strengthen) a sanity
check right at the beginning of the program, before any parsing, I have
no problem with that.

Michal

--6ujo7n4f5vdixqin
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmRYp3QACgkQ538sG/LR
dpWJzQgAnAC+voOf0/QKi5ZmNNHbj9JBDJjAFLPg8NsIdZpVSNEO5v5NzN1mCen5
8JfDYbKBHKh5Gcaok+Lx679AjgapMVjulSD4XWowiqTrjS4IKDjn9+gSf7xY+uGG
Lmy7xqatQ9Ut6xz2py4jUHgSL7a18vX19mLX8HoRXdk1I3CYb+NaMGWpqwhINP0l
RD+xME6TKOGLKpXU9/O5EsdBecqn7sj9qtc58J/+aooo3teLpyPOWEAt6awYPSSC
ZcESlrG75poZNP0ke8PKdzCf2bbhgGWrPE03wRtZm40t/gapmp5Kc9EBXVgGQ7S/
u0rQtdmbKUD5aEVj5HYPGxcsNOzplA==
=vxLo
-----END PGP SIGNATURE-----

--6ujo7n4f5vdixqin--

