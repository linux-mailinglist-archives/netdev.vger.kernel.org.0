Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040F0699CA4
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 19:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjBPSuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 13:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBPSue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 13:50:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEFE3B222;
        Thu, 16 Feb 2023 10:50:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD16EB8295A;
        Thu, 16 Feb 2023 18:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCEAC433D2;
        Thu, 16 Feb 2023 18:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676573430;
        bh=AImnf+2dqdDiUhTA+4XLQG6ccdNzGaAOj2rHAnNmR9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cwn2YrfskMK7b8K/KimZBAxY/yyMR/7dHYwkZ62/Ai0XU+LFgqyfNyyeGPdpBVD/z
         L5tR6ut4sU5d0mPmnlz4O3RGW1dEEEeJyiVGZcmuEcDFtLfUYmMsbc7TzqPoodANtP
         hlNgL9cbxXz3nPmhgZoJsHw8Cy5xVuoVntsQFQ6gUp4p8vv50rlYukm/+dJLWsXO4+
         +BG8W2lJu5PqVhOQHPmkCR52mXRI0bIV8ckrCigczowbjO0Q2bcMVpdbKMbf+/eUYw
         MWuW3ALreFOeCyBrbqK6ki6aic8OAe4gScHw7OhlSTUzSD/6Vqo+dHijYTR0D/n+rN
         58PVJwgvIXBGA==
Date:   Thu, 16 Feb 2023 18:50:22 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Cc:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com,
        daire.mcnamara@microchip.com
Subject: Re: [PATCH 04/12] soc: sifive: ccache: Add non-coherent DMA handling
Message-ID: <Y+567t+kDjZI+fbo@spud>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-5-cristian.ciocaltea@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dCe6axd58RjANF5F"
Content-Disposition: inline
In-Reply-To: <20230211031821.976408-5-cristian.ciocaltea@collabora.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dCe6axd58RjANF5F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Emil,

+CC Daire

On Sat, Feb 11, 2023 at 05:18:13AM +0200, Cristian Ciocaltea wrote:
> From: Emil Renner Berthing <kernel@esmil.dk>
>=20
> Add functions to flush the caches and handle non-coherent DMA.
>=20
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> [replace <asm/cacheflush.h> with <linux/cacheflush.h>]
> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
> ---

> +void *sifive_ccache_set_uncached(void *addr, size_t size)
> +{
> +	phys_addr_t phys_addr =3D __pa(addr) + uncached_offset;
> +	void *mem_base;
> +
> +	mem_base =3D memremap(phys_addr, size, MEMREMAP_WT);
> +	if (!mem_base) {
> +		pr_err("%s memremap failed for addr %p\n", __func__, addr);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	return mem_base;
> +}

The rest of this I either get b/c we did it, or will become moot so I
amn't worried about it, but can you please explain this, in particular
the memremap that you're doing here?

Cheers,
Conor.


--dCe6axd58RjANF5F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+567gAKCRB4tDGHoIJi
0isoAQCgGCQCl64HiPsxg1E4/GDsGMTIJGdrEEQIXQCaEdTjeAD9Hv8l410SaOFy
q5SvBa8IxUyuUjr2p8ixdFb2JfHoEAk=
=7P7u
-----END PGP SIGNATURE-----

--dCe6axd58RjANF5F--
