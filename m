Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA184CB9F1
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 10:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiCCJQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 04:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiCCJQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 04:16:23 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17A2119857;
        Thu,  3 Mar 2022 01:15:38 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K8QLx0rFvz4xZq;
        Thu,  3 Mar 2022 20:15:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646298937;
        bh=OggeblJu5EDG72NA5XkdNucyLOg6MRP8xsG3P6UstmM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P6w0lzHL/XxsHvXw9JoKXAZbq/osqutnHasY1lGBFhnPPZ74y5ZkaA1QHC9x/ZTTC
         x4V3ddQLu51BJGEBDgK8KO57i6bZid7Vv/N7phnvAI0Uab7UxXjo6zy9HnXuWgiWt3
         nwSrEwQRlENem2XqSDdXGHDZLlisFjGNFcc5RArqslp2Fmaf/xobrRpJ7XKYL5a+Pp
         zLtYHFTum10Bw4rHt02po3RSSkV7tWdLjwbnD7F5L2O8fm8MRqSLwCP+2fO41eOMs8
         AIKODqvsz3l2qGiqESXCMcI1ofZEs13XbrkUTE2Aq8TF73kjHTU1on5iWP9r8mRrh0
         5lYdgMGzh58SA==
Date:   Thu, 3 Mar 2022 20:15:36 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20220303201536.042e9135@canb.auug.org.au>
In-Reply-To: <20220303201352.43ea21a3@canb.auug.org.au>
References: <20220303201352.43ea21a3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Asc0DN8B1hZjxNnJb+9IGip";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Asc0DN8B1hZjxNnJb+9IGip
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 3 Mar 2022 20:13:52 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the net-next tree, today's linux-next build (htmldocs)
> produced this warning:
>=20
> Documentation/networking/smc-sysctl.rst:3: WARNING: Title overline too sh=
ort.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
> SMC Sysctl
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Introduced by commit
>=20
>   12bbb0d163a9 ("net/smc: add sysctl for autocorking")

Also:

Documentation/networking/smc-sysctl.rst: WARNING: document isn't included i=
n any toctree

--=20
Cheers,
Stephen Rothwell

--Sig_/Asc0DN8B1hZjxNnJb+9IGip
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIghzgACgkQAVBC80lX
0GzDDAf/XlEo7RHH6iCKvECM5up+IOsirqStB0G3O6lnWvqU2rAer6b0J4kIBzJt
UneTn4HYGckJbteqduv1g5a0X6AjB1ds97Qz86i2zkn59LWF0yS+QL4RN25D97Ur
xyZkSZ9i/4YoE33UQUuRd88tdpnwmeyFXrgy4a0imOAWPLKbHNvzywJy5WwZ7po8
JIQ5MeHk2u247W0AH5zqu9IwBJZta/zpB3OJ78ZuldD9DI8+aTF59N4FUu4/8itu
U6YrrtjxIiVsjsqgagvcDUfByxvRkAQeTlnr0/dL2daXPM3IKrJH9gXlrU+NZMyF
vsDfvAFlEJM4fOhGTsbp7JrF5fB7gA==
=Y3WL
-----END PGP SIGNATURE-----

--Sig_/Asc0DN8B1hZjxNnJb+9IGip--
