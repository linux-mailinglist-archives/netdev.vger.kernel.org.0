Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C755419BC
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 02:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406363AbfFLAy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 20:54:57 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:33145 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406117AbfFLAy5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 20:54:57 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45NpLP2K5tz9s00;
        Wed, 12 Jun 2019 10:54:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1560300894;
        bh=jJVvQRYv+RNct+AwT6tYADRT40DSB6dPMv1XUCrWfrQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GRfIjh5qO9TFHNI6LP9yAJ+evoY6UDmuBo/eJPcDq47EE/3P/6Y7Hh/O98St9VyuH
         Xgmz51MjoE/Aqxz9qyrw4gdZjBl+VYOUu3lBl98r+XQSA3ZRU53kWgP0dCRLssonnH
         y3GGqJBtaM1cJAPJRhq4BjoRKykv07tqDrfxSggWgxuwnSz4Tx62ouOvuGZmnI7ZiO
         lP8U6VbaLGqWbjo7IDXk++gJ4Ek8VUlLFo6LZW83dGv0sn3egQ36wSzZm3dLuCf4LH
         YiHXm23S+L2pnPHK/LnsWbN54EjUX29x/y9ySKlIbfaijgfMlHwpz/FizpKKztibuk
         BaHtOMH00Zh9w==
Date:   Wed, 12 Jun 2019 10:54:51 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-next@vger.kernel.org>
Subject: Re: [RESEND PATCH net-next] net: ethernet: ti: cpts: fix build
 failure for powerpc
Message-ID: <20190612105451.4d2e9aa3@canb.auug.org.au>
In-Reply-To: <20190611111632.9444-1-grygorii.strashko@ti.com>
References: <20190611111632.9444-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/2bUUK0tUc_lYIUql4YF9vie"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/2bUUK0tUc_lYIUql4YF9vie
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 11 Jun 2019 14:16:32 +0300 Grygorii Strashko <grygorii.strashko@ti.=
com> wrote:
>
> Add dependency to TI CPTS from Common CLK framework COMMON_CLK to fix
> allyesconfig build for Powerpc:
>=20
> drivers/net/ethernet/ti/cpts.c: In function 'cpts_of_mux_clk_setup':
> drivers/net/ethernet/ti/cpts.c:567:2: error: implicit declaration of func=
tion 'of_clk_parent_fill'; did you mean 'of_clk_get_parent_name'? [-Werror=
=3Dimplicit-function-declaration]
>   of_clk_parent_fill(refclk_np, parent_names, num_parents);
>   ^~~~~~~~~~~~~~~~~~
>   of_clk_get_parent_name
>=20
> Fixes: a3047a81ba13 ("net: ethernet: ti: cpts: add support for ext rftclk=
 selection")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

I have applied this to linu-next today instead of reverting a3047a81ba13.

--=20
Cheers,
Stephen Rothwell

--Sig_/2bUUK0tUc_lYIUql4YF9vie
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0ATVsACgkQAVBC80lX
0GxUiQf8DC0a5Zd5gWjOT5FiuKW9u3jmojquQB/VqM7zhVpf/34wTw93JvoiIAd1
I59WfIfDCzPwFE3bFMjxeReBhZStQocz5ADc5lGleJ0qHX7z3rbEcbgGILSWOEsm
r10tVBmqphIvQdQLzkL2WIYdE0fVC931lkcUf1UV/qc7MdsKrAi3wG72YWNjfMXM
zYlhw6DI3nrwlUaiiAbo3FhdeIVmlUdaEBJI6BDDB/dPjo4u8YFj9OGeNldl4+2L
3L3q5ZPggrEF4VbF/CBnL3uEMzGHU2PhkMxAexpzCZmUpNzF2MDbsN6RqjgN+KpX
5DO2V/Uv91jWR4z8BmxK/rwXZoQAsw==
=Cbkw
-----END PGP SIGNATURE-----

--Sig_/2bUUK0tUc_lYIUql4YF9vie--
