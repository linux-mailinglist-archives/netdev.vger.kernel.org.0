Return-Path: <netdev+bounces-965-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BFE16FB7DD
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 22:01:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB9071C20A40
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 20:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C6B4111BE;
	Mon,  8 May 2023 20:01:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699AF4411
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 20:01:21 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0FEDC
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 13:01:19 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 250E721D89;
	Mon,  8 May 2023 20:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1683576067; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jGjIIKPfOt1b0ws2xIIX0WvsNqaR6pSB4qec0K1JvzI=;
	b=RO+J3YgLqPYgs12yvkr65ytU+4H/6+lc7DyumH873wP2e/Q/zosU1RvJqSTwLwFZamQyPA
	jz9tWdYVZ0uJ6l+Ig6CgPQbuxejP38SudIybpTC0CmB7M4CfnU3xi0AniLMnPxDuT+1xT0
	jFFSKEsFAoeAUWESj7ogfjYD4D/YPKM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1683576067;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jGjIIKPfOt1b0ws2xIIX0WvsNqaR6pSB4qec0K1JvzI=;
	b=DCq5Fby96jLxuaVVLDKBr+Uy10WkMrVHz0+itd9jMym6nfcxdDxi6j17+kG6xvemWUOyBh
	Sgq4dVMGXAmToTAw==
Received: from lion.mk-sys.cz (unknown [10.163.44.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 14E992C142;
	Mon,  8 May 2023 20:01:07 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
	id 8186360926; Mon,  8 May 2023 22:01:04 +0200 (CEST)
Date: Mon, 8 May 2023 22:01:04 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Nicholas Vinson <nvinson234@gmail.com>
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] Fix argc and argp handling issues
Message-ID: <20230508200104.ktrzgazsn3t54n2a@lion.mk-sys.cz>
References: <4b89caeddf355b07da0ba68ea058a94e5a55ff59.1683549750.git.nvinson234@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="c72yie2rjxus55yr"
Content-Disposition: inline
In-Reply-To: <4b89caeddf355b07da0ba68ea058a94e5a55ff59.1683549750.git.nvinson234@gmail.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--c72yie2rjxus55yr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 08, 2023 at 08:45:33AM -0400, Nicholas Vinson wrote:
> Fixes issues that were originally found using gcc's static analyzer. The
> flags used to invoke the analyzer are given below.
>=20
> Upon manual review of the results and discussion of the previous patch
> '[PATCH ethtool 3/3] Fix potentinal null-pointer derference issues.', it
> was determined that when using a kernel lacking the execve patch ( see
> https://github.com/gregkh/linux/commit/dcd46d897adb70d63e025f175a00a89797=
d31a43),
> it is possible for argc to be 0 and argp to be an array with only a
> single NULL entry. This scenario would cause ethtool to read beyond the
> bounds of the argp array. However, this scenario should not be possible
> for any Linux kernel released within the last two years should have the
> execve patch applied.
>=20
>     CFLAGS=3D-march=3Dnative -O2 -pipe -fanalyzer       \
>         -Werror=3Danalyzer-va-arg-type-mismatch       \
>         -Werror=3Danalyzer-va-list-exhausted          \
>         -Werror=3Danalyzer-va-list-leak               \
>         -Werror=3Danalyzer-va-list-use-after-va-end
>=20
>     CXXCFLAGS=3D-march=3Dnative -O2                     \
>         -pipe -fanalyzer                            \
>         -Werror=3Danalyzer-va-arg-type-mismatch       \
>         -Werror=3Danalyzer-va-list-exhausted          \
>         -Werror=3Danalyzer-va-list-leak               \
>         -Werror=3Danalyzer-va-list-use-after-va-end
>=20
>     LDFLAGS=3D"-Wl,-O1 -Wl,--as-needed"
>=20
>     GCC version is gcc (Gentoo 13.1.0-r1 p1) 13.1.0

This looks good to me, except for the missing Signed-off-by (as
mentioned by Jesse). IMHO it's not necessary to resubmit the patch,
replying with the Signed-off-by line should suffice. If you can do that
by tomorrow, I'll include the patch in 6.3 release.

Michal

> ---
>  ethtool.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/ethtool.c b/ethtool.c
> index 98690df..0752fe4 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -6405,6 +6405,9 @@ int main(int argc, char **argp)
> =20
>  	init_global_link_mode_masks();
> =20
> +	if (argc < 2)
> +		exit_bad_args();
> +
>  	/* Skip command name */
>  	argp++;
>  	argc--;
> @@ -6449,7 +6452,7 @@ int main(int argc, char **argp)
>  	 * name to get settings for (which we don't expect to begin
>  	 * with '-').
>  	 */
> -	if (argc =3D=3D 0)
> +	if (!*argp)
>  		exit_bad_args();
> =20
>  	k =3D find_option(*argp);
> --=20
> 2.40.1
>=20
>=20

--c72yie2rjxus55yr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmRZVPwACgkQ538sG/LR
dpULsAf/cYk6v6bm8m22VM6yR/qr/82i4imyHS52muezxKV637F9uQyOmLfKlVeg
n+mUnqy0DIQHnaYqsdXplePzL26pNhqwT6Xb1HB7Wcx890wHAWvAPTJy4IN3F57U
TGJyu5VHo3wEwm437q4RKfRuHuFrtlXSdMM7cW3Psa+6rWxtsGUIl+Jd23AaImug
NaoZfWkB0OwGpnC1xb3C0owLKjushnSiWgZZILiR5ASiZg5Wq6Z9Z5K/ydWKgTJq
3jwPF6dEyUDUT5xztWUakbASxihSK686Ja6jG+bPZh5Mr9hcH/5Ff3vnr7Yt7nP9
/2TY5VqJt+JFc01LCPbPemh+16f2BA==
=V1aY
-----END PGP SIGNATURE-----

--c72yie2rjxus55yr--

