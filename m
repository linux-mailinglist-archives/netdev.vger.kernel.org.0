Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7D0466BC8
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349108AbhLBV6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:58:32 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:40372 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243133AbhLBV6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 16:58:31 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9FA0F1FC9E;
        Thu,  2 Dec 2021 21:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1638482107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kLMuNoDzH8szGiyJgjfe2r4Gxxeyzcr+2ahYBhkvPEw=;
        b=0t4POD28QyaRSE1B/+io+4fwAsfa8lJE8GsGHn87Gpy0hsZ9T/QY+Wiabeln6BrJbn0LRo
        LdJbeg7BCcAK8IHb/Znks3hWvRGfYf+ib8XdRIL4omaSG6Q0jGSAWs3dZeajjwbjnrbikw
        3al0BW9PFudDm+lQ5bAYJUh+HuLvv8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1638482107;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kLMuNoDzH8szGiyJgjfe2r4Gxxeyzcr+2ahYBhkvPEw=;
        b=ZzRPN8rthaKR1KutBTbmUKtWomAQ8Dqb7ydX5mPSEsFX51BYZVNY8He+rydduaN94fyGJI
        Wdsg6TWm3Bw71mCg==
Received: from lion.mk-sys.cz (unknown [10.100.225.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 96935A3B83;
        Thu,  2 Dec 2021 21:55:07 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 7364E607CC; Thu,  2 Dec 2021 22:55:07 +0100 (CET)
Date:   Thu, 2 Dec 2021 22:55:07 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next 2/8] sff-common: Move OFFSET_TO_U16_PTR() to
 common header file
Message-ID: <20211202215507.fymmrckusn5y4rqh@lion.mk-sys.cz>
References: <20211123174102.3242294-1-idosch@idosch.org>
 <20211123174102.3242294-3-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qg4ya6xv4lm2rgay"
Content-Disposition: inline
In-Reply-To: <20211123174102.3242294-3-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qg4ya6xv4lm2rgay
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 23, 2021 at 07:40:56PM +0200, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
>=20
> The define is also useful for CMIS, so move it from SFF-8636 to the
> common header file.
>=20
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  qsfp.c       | 1 -
>  sff-common.h | 4 ++--
>  2 files changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/qsfp.c b/qsfp.c
> index 58c4c4775e9b..b3c9e1516af9 100644
> --- a/qsfp.c
> +++ b/qsfp.c
> @@ -700,7 +700,6 @@ sff8636_show_wavelength_or_copper_compliance(const st=
ruct sff8636_memory_map *ma
>   * Second byte are 1/256th of degree, which are added to the dec part.
>   */
>  #define SFF8636_OFFSET_TO_TEMP(offset) ((__s16)OFFSET_TO_U16(offset))
> -#define OFFSET_TO_U16_PTR(ptr, offset) (ptr[offset] << 8 | ptr[(offset) =
+ 1])
> =20
>  static void sff8636_dom_parse(const struct sff8636_memory_map *map,
>  			      struct sff_diags *sd)
> diff --git a/sff-common.h b/sff-common.h
> index aab306e0b74f..9e323008ba19 100644
> --- a/sff-common.h
> +++ b/sff-common.h
> @@ -126,8 +126,8 @@
>  #define  SFF8024_ENCODING_PAM4			0x08
> =20
>  /* Most common case: 16-bit unsigned integer in a certain unit */
> -#define OFFSET_TO_U16(offset) \
> -		(id[offset] << 8 | id[(offset) + 1])
> +#define OFFSET_TO_U16_PTR(ptr, offset) (ptr[offset] << 8 | ptr[(offset) =
+ 1])
> +#define OFFSET_TO_U16(offset) OFFSET_TO_U16_PTR(id, offset)

I'm aware that you are just moving an old piece of code around so this
is rather meant as a tip for a future cleanup: OFFSET_TO_U16_PTR() does
not really need to be a macro so an inline function would be cleaner
(and type safe). OFFSET_TO_U16() is only used in 4 places, AFAICS, so
it is IMHO questionable if it is worth the worse readability.

Michal

> =20
>  # define PRINT_xX_PWR(string, var)                             \
>  		printf("\t%-41s : %.4f mW / %.2f dBm\n", (string),         \
> --=20
> 2.31.1
>=20

--qg4ya6xv4lm2rgay
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmGpQLQACgkQ538sG/LR
dpX/7wf/do/OVzOxu6iH6M6bXse23xiOHduQQCUY8YMrw2md7YjlJs44URvZ83T0
4yqAa1qHjyaGLYilxVKhrFis387r98a/Bl5HsuTbsdBhL+o8MYNv4zVoS6PkiyUz
lXd6ORHTbjTGwM3l3/Xmf8fVIzHRD6oyHRj7iPcm7uKNMsvgZZxVX6fUmOeJkXGz
ruSdeFVOgdU39FFp8Gv/rZReqHlN3PSSYRud5kcYICDYg8sqoV5zpLYFyx6Uf7kI
Au01B07Rsk3MjIkIIPTAp1bZQ6BfHsmuprvJnkgWthoZ5djhNrezHZ0v5d+LFHrb
3J1tJvzb33BkvDlpmQ87WtRYZZsylA==
=f8qi
-----END PGP SIGNATURE-----

--qg4ya6xv4lm2rgay--
