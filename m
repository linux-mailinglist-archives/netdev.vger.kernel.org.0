Return-Path: <netdev+bounces-767-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5064F6F9C9A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 00:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 133171C208ED
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 22:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A3FE11C8E;
	Sun,  7 May 2023 22:57:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E96228F2
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 22:57:56 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BBF4EE0
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 15:57:53 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 837D41FD98;
	Sun,  7 May 2023 22:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1683500272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fIu2N6r7PqLw8Dq3Uu1A0oiEWmu7HviDn1OQWnlBf8k=;
	b=brQNGtPEleXEfw2nk4SSZUKfneeek+WuP416WwVZ070n4Uhu9uKA1iR1ilrBxa2VjbdE9G
	9WA98g4mgdrYfUm+4vJIsRbGksniGxdsggjVDrhhjUaOXOLQc2mytC+eiv6oCiUfaYJLeL
	OOGVyPWXw1IsXYot7n3h+GQPScMJLCM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1683500272;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fIu2N6r7PqLw8Dq3Uu1A0oiEWmu7HviDn1OQWnlBf8k=;
	b=kQrKcSN/oxPWKFhp2EwQvNPwknybHunV/C0uEUrcdNSdrJ3zbfeCCNVcATuApUJWLWyaeT
	+/fsVuXAKCYvqmCw==
Received: from lion.mk-sys.cz (unknown [10.163.44.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 41B502C141;
	Sun,  7 May 2023 22:57:52 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
	id 24C0D608F9; Mon,  8 May 2023 00:57:52 +0200 (CEST)
Date: Mon, 8 May 2023 00:57:52 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Nicholas Vinson <nvinson234@gmail.com>
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 3/3] Fix potentinal null-pointer derference
 issues.
Message-ID: <20230507225752.fhsf7hunv6kqsten@lion.mk-sys.cz>
References: <cover.1682894692.git.nvinson234@gmail.com>
 <105e614b4c8ab46aa6b70c75111848d8e57aff0c.1682894692.git.nvinson234@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="r3mbag7xic6kkz3z"
Content-Disposition: inline
In-Reply-To: <105e614b4c8ab46aa6b70c75111848d8e57aff0c.1682894692.git.nvinson234@gmail.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--r3mbag7xic6kkz3z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 30, 2023 at 06:50:52PM -0400, Nicholas Vinson wrote:
> Found via gcc -fanalyzer. Analyzer claims that it's possible certain
> functions may receive a NULL pointer when handling CLI arguments. Adding
> NULL pointer checks to correct the issues.
>=20
> Signed-off-by: Nicholas Vinson <nvinson234@gmail.com>

A similar theoretical issue was discussed recently:

  https://patchwork.kernel.org/project/netdevbpf/patch/20221208011122.23433=
63-8-jesse.brandeburg@intel.com/

My position is still the same: argv[] members cannot be actually null
unless there is a serious kernel bug (see the link above for an
explanation). I'm not opposed to doing a sanity check just in case but
if we do, I believe we should check the whole argv[] array right at the
beginning and be done with it rather than add specific checks to random
places inside parser code.

> @@ -6182,16 +6182,18 @@ static int find_option(char *arg)
>  	size_t len;
>  	int k;
> =20
> -	for (k =3D 1; args[k].opts; k++) {
> -		opt =3D args[k].opts;
> -		for (;;) {
> -			len =3D strcspn(opt, "|");
> -			if (strncmp(arg, opt, len) =3D=3D 0 && arg[len] =3D=3D 0)
> -				return k;
> -
> -			if (opt[len] =3D=3D 0)
> -				break;
> -			opt +=3D len + 1;
> +	if (arg) {
> +		for (k =3D 1; args[k].opts; k++) {
> +			opt =3D args[k].opts;
> +			for (;;) {
> +				len =3D strcspn(opt, "|");
> +				if (strncmp(arg, opt, len) =3D=3D 0 && arg[len] =3D=3D 0)
> +					return k;
> +
> +				if (opt[len] =3D=3D 0)
> +					break;
> +				opt +=3D len + 1;
> +			}
>  		}
>  	}
> =20

I would rather prefer a simple

	if (!arg)
		return -1;

to avoid closing almost all of the function body inside an if block.

Michal

--r3mbag7xic6kkz3z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmRYLOkACgkQ538sG/LR
dpUMQgf+O4ddR76/47UM6mN48KlkZ7CPs0fTYtJxnToHe5+nqvBv5GdcU81rkbHK
hPe6hYvDP67o3tumhmyX+BTecGkjqCenIQqlqI5QNwP4FmsQUFHCVFDWWckljZDP
UV6jWv48gI8otSH5rcdXljHnWjqcOFAopDff3Q+ciTq2Wzo3MOWz4O/C/3Sjkmoc
3cq/tPhkKGuG7u1xHdlM2CoLaOBRcTIOt4gAJUnaniOqDxhAk9N73bL20iU3+R34
Z4bpBBcKUepNY5oqRUEWfBA9QTsyVKun5L+47RNWcgjoMuQWGci9Z6sbbLCbYPsh
O6iNlhvBgHbEcAdDlSDKOTFHIVdlKQ==
=gD2V
-----END PGP SIGNATURE-----

--r3mbag7xic6kkz3z--

